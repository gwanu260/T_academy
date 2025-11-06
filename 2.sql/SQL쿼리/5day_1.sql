-- 1. 데이터마트 생성
CREATE VIEW car_mart AS
SELECT
     A.*
    ,B.prod_cd      -- 제품코드
    ,B.quantity     -- 수량
    ,C.price            -- 가격
    ,B.quantity * CAST( REPLACE(C.price, ',','') AS UNSIGNED) AS sales_amt  -- 구매액
    ,C.brand            -- 브랜드
    ,C.model            -- 모델
    ,D.store_addr   -- 대리점 주소
    ,E.gender       -- 성별
    ,E.age          -- 나이
    ,E.addr         -- 고객 주소
    ,E.join_date    -- 가입일
FROM car_order AS A
-- 주문 데이터는 고정->컬럼을 확장한다
-- 가장 간단하게 left 조인 적용
LEFT JOIN t1.car_orderdetail AS B ON A.order_no=B.order_no
LEFT JOIN t1.car_product      AS C ON B.prod_cd=C.prod_cd
LEFT JOIN t1.car_store        AS D ON A.store_cd=D.store_cd
LEFT JOIN t1.car_member       AS E ON A.mem_no=E.mem_no
;


-- 전체데이터 크기
-- (4176, 15)
SELECT *
FROM car_mart;

    
CREATE VIEW user_profile_bass AS
SELECT 
	*,
	case
		when age < 20 then '20대미만'
		when age BETWEEN 20 AND 29 then '20대'
		when age BETWEEN 30 AND 39 then '30대'
		when age BETWEEN 40 AND 49 then '40대'
		when age BETWEEN 50 AND 59 then '50대'
		ELSE '60대이상' END
	AS age_band
FROM car_mart;

SELECT * FROM user_profile_bass LIMIT 5;


-- 세대별 고객수(mem_count), 중복고객제거
-- 1명의 고객이 여러주문을 하더라도 1명의 고객임
-- mem_no => 고객 과닐 번호(고객 특정하는 값) -> 중복제거(그룹내)
-- 컬럼 : age_band, mem_count

SELECT
	age_band,
	COUNT( distinct mem_no ) AS mem_count
FROM t1.user_profile_bass
GROUP BY t1.user_profile_bass.age_band
ORDER BY age_band ASC
;
-- 20대 미만 데이터 X
-- -> 현행법규상 20대 미만? 운전면허? 구매력(돈)? 데이터가 없음

-- 젠더별 고갯수
SELECT
	upb.gender,
	COUNT( distinct mem_no ) AS mem_count
FROM user_profile_bass AS upb
GROUP BY upb. gender
;
-- 남성 약 60% 비율, 여성 약 40% 비율


SELECT
	upb.gender,
	upb.age_band,
	COUNT( distinct mem_no ) AS mem_count
FROM user_profile_bass AS upb
GROUP BY upb.gender, upb.age_band
;

-- 남성 여성 기준 세대별 구매력 1등 ~ 꼴등까지 동일
-- 구매 비율을 좀더 디테일하게 계산하여 비교(격차부분 체크)
-- 단.여성의 30대, 40대의 구매력은 거의 비슷함


-- 젠더별, 세대별 고객수(mem_count), 중복고객제거
-- 2020구매자수(mem_count_20), 2021구매자수(mem_count_21)
SELECT upb.gender, upb.age_band
	,COUNT( DISTINCT case when YEAR(order_date) = 2020 then mem_no END ) AS mem_count_20
	,COUNT( DISTINCT case when YEAR(order_date) = 2021 then mem_no END ) AS mem_count_21
FROM user_profile_bass AS upb
GROUP BY upb.gender, upb.age_band
;

-- 2020보다 2021때의 구매력이 전성별, 전세대에서 상승되었다
-- 성별, 세대별 상승비율은 상이하고, 구체적인 값은 다음과 같다
-- 선형차트 ...

SELECT YEAR(order_date) FROM user_profile_bass LIMIT 1;

/*
- 요구사항
- car_mart 대상 데이터 추출하여 데이터마트 구성 =>  rfm_base : view
- 컬럼
  - mem_no
  - 고객별 총 구매액 : total_amt
  - 고객별 구매횟수(빈도) : total_fr
- 조건
  - 기간 한정
    - 2020 <= data <= 2021 : 2년(최근 2년간 (예시, 기준년월)
*/
    
CREATE VIEW rfm_base AS
SELECT
	mem_no
	,SUM( sales_amt ) AS total_amt
	,COUNT( order_no ) AS total_fr	 
FROM car_mart
WHERE YEAR(order_date) BETWEEN 2020 AND 2021
GROUP BY mem_no -- 회원
;

-- 총구매액이 높 -> 낮 순으로 정렬
SELECT *
FROM rfm_base
ORDER BY total_fr DESC
LIMIT 10
;

/*
- rfm_base 기반으로 rfm_base_level 이라는 뷰 구성
- 고객 등급이 반영된 데이터마트
- 고객 등급 조건
    - VVIP   : 구매금액이 20억 이상 and 구매빈도 3회 이상
    - VIP    : 구매금액이 10억 이상 and 구매빈도 2회 이상
    - GOLD   : 구매금액이 5억 이상
    - SILVER : 구매금액이 3억 이상
    - BRONZE : 구매빈도 1회, 기본값(구매만하면)
    - STONE  : 그냥 가입한 고객
  - 요구사항
    - view : rfm_base_level
    - 컬럼
      - level : 등급
      - car_member의 모든 칼럼
      - rfm_base의 총구매액(total_amt), 총구매빈도(total_fr)
*/
CREATE VIEW rfm_base_level
AS
SELECT
	case
		when B.total_amt >= 2000000000 AND B.total_fr >= 3 then 'VVIP'
		when B.total_amt >= 1000000000 AND B.total_fr >= 2 then 'VIP'
		when B.total_amt >= 500000000 then 'GOLD'
		when B.total_amt >= 300000000 then 'SILVER'
		when B.total_fr >= 1 then 'BRONZE'
		ELSE 'STONE' end
		AS `level`,
	A.*,
	B.total_amt,
	B.total_fr
	
FROM car_member AS A
JOIN rfm_base AS B
ON A.mem_no = B.mem_no
;

SELECT * FROM rfm_base_level

-- 리뷰때 vvip가 구매한 내역 확인, 차종, 가격, 개수등 출력

-- 등급 별 인원수, 총 구매액 얼마?  체크 평균(구매액, 빈도)
-- 반올림, 버림, 올림등 처리하여 확인
SELECT 
	`level`
	,COUNT(*)	AS '인원수'
	,SUM(total_amt)	AS '총구매액'
	,AVG(total_amt)	AS '평균구매액'
	,AVG(total_fr)	AS '평균구매빈도'
FROM rfm_base_level
GROUP BY `level`
ORDER BY `인원수` asc