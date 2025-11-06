-- 구매 전환율, 구매 주기를 계산하기 위한 사전작업
CREATE VIEW buy_record_base
AS
SELECT
	A.mem_no AS ori_2020_mem_no,
	B.mem_no AS ori_2021_mem_no,
	case when B.mem_no IS NOT NULL then 'Y'
	     ELSE 'N' END AS yn
FROM
	-- 2020 구매자 정보 테이블 => A (from car_mart), 실습 2분
	-- 컬럼은 mem_no만 존재, 중복제거 (1581, 1)
	( SELECT distinct mem_no
	FROM car_mart
	WHERE year(car_mart.order_date) = 2020 ) AS A
LEFT JOIN
	-- 2021 구매자 정보 테이블 => B (2513,1)
	( SELECT distinct mem_no
	FROM car_mart
	WHERE year(car_mart.order_date) = 2021 ) AS B
ON A.mem_no = B.mem_no
;

-- 데이터 확인
SELECT * FROM t1.buy_record_base;
-- 연속적으로 매년 구매한자/비구매자 카운트 비교
-- 2020 구매자중 2021년에도 구매한자가 117명
SELECT
	yn, COUNT(*) AS cnt
FROM t1.buy_record_base
GROUP BY yn
;
-- 재구매한 비율이 7.4%, 93가 2021년도에 신규 고객이였음
SELECT 117/(117+1464)*100;

-- 구매 전환율 = 2020 구매자들 중에서 2021까지 구매한자의 비율
-- 구매 전환율을 7.4% -> 10% 상승하게 하는 마케팅 전략을 수립하시오
SELECT
	COUNT( case when A.yn='y' then ori_2020_mem_no END )
	/ COUNT( ori_2020_mem_no ) * 100 AS rate
FROM buy_record_base AS A
;


/*
- 구매주기 예시
  - 구매를 총 4회 진행 했다면
    - 구매주기 =
      ```
      (최근구매일-최초구매일)/ (구매횟수 - 1)
      ```
    - 날짜 정보 -> 구매 데이터에 존재 -> 데이터마트(car_mart)

- view : buy_cycle_base
- 컬럼
  - store_cd
  - 최근구매일
  - 최초구매일
  - 구매횟수 - 1
- 최종 결과물 => 구매횟수 - 1의 값이 2이상(제한)
*/
CREATE VIEW buy_cycle_base
AS
SELECT
	store_cd
	,min(car_mart.order_date) AS min_order_date
	,max(car_mart.order_date) AS max_order_date
	,COUNT( DISTINCT order_no ) AS total_order_fr_cnt
FROM car_mart
GROUP BY car_mart.store_cd -- 매장별 집계
HAVING total_order_fr_cnt >= 2 -- 데이터셋 구성후 2차 조건 부여 필터링
;

SELECT *
FROM buy_cycle_base
;


-- 실습 구매주기율(= (최근-최초)/(건수-1) ) 계산
-- 컬럼 : buy_cycle_base의 모든 컬럼, buy_cycle 추가
-- DATEDIFF()
SELECT 
	A.*
	,DATEDIFF(A.max_order_date, A.min_order_date)/A.total_order_fr_cnt
		AS buy_cycle
FROM buy_cycle_base AS A
;
-- 구매횟수가 많을수록 구매 주기율이 작다
-- 2011, 2012 등 매장순으로 영업및 매출이 활발하게 진행되고 있음

/*
- car_mart view 를 기반으로 생
- 컬럼 총 4개  
  - 집계 대상 : 브랜드, 모델
  - 년도별 판매액(2020, 2021)
    - total_amt_2020, total_amt_2021
- view는 product_growth_base
*/


CREATE VIEW product_growth_base
AS
SELECT 
	c.brand,
	c.model,
	SUM( case when YEAR(c.order_date) = 2020 then sales_amt END ) AS total_sales_2020,
	SUM( case when YEAR(c.order_date) = 2021 then sales_amt END ) AS total_sales_2021
FROM car_mart AS c
GROUP BY c.brand, c.model
;

-- 브랜드, 모델정렬
-- 2020매출, 2021 매출 순으로 추력
SELECT *
FROM product_growth_base
ORDER BY brand, model asc
;

-- product_growth_base 기반 쿼리
-- 브랜드(집계)의 성장률(2021/2020) -> 전년대비, %sms -1
SELECT
	brand
	,SUM(total_sales_2021) / SUM(total_sales_2020) AS growth -- x,y배 성장
	,SUM(total_sales_2021) / SUM(total_sales_2020)-1 AS growth_per -- y%성장
FROM product_growth_base
GROUP BY brand
;

-- 브랜드별 모델별 집계
-- 브랜드, 모델, 성장률, 랭킹 ROW_NUMBER() ~ OVER() 적용
SELECT
	A.*
	,ROW_NUMBER()
	 OVER( partition BY A.brand ORDER BY A.growth_per desc )
	 AS RANK1
FROM (
		SELECT brand, model
   			,SUM(total_sales_2021)/SUM(total_sales_2020)-1 AS growth_per
		FROM product_growth_base
		GROUP BY brand, model	
	  ) AS A