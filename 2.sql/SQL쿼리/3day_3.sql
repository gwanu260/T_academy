-- 내림, 올림, 반올림
SELECT
	FLOOR(3.95), # 3
	CEIL(3.95),  # 4
	CEIL(3.11),  # 4
	ROUND(3.5),	 # 4
	ROUND(3.4),  # 3
	CEILING(1.56), # 2
	CEILING(1.11)	# 2
;


-- 수학함수
SELECT
	SQRT(4),
	POW(2,3),
	EXP(3),
	LOG( 20.085536923187668 ),
	LOG( EXP(3) )
;

-- 삼각함수
SELECT PI(), SIN( PI()/2 ), COS( PI() ), TAN( PI()/4 ) ;

--
SELECT ABS(-1), RAND();

-- 난수 발생, 0 <= X <= 10
-- 쿼리 작성
SELECT ROUND(RAND()*10);
-- 1 <= X <= 100 => 1-1 <= X <= 100-1 => 0 <= X <= 99
SELECT ROUND( RAND() * 99,0) + 1 ;


-- 표준편차, 분산 (인구수로 임시 표현)
-- 분산의 루트제곱을 씨우면 표준편차가 계산됨
-- 표준편차는 실데이터와 같은 단위로 표현 -> 선호
-- 0에 가까울수록 지표상 좋다(평가)
-- 리뷰시간, 국가명도 출력하시오
-- NGA라는 국가는 도시가 64개 있는데 도시간 인구 차이가 작다
-- 한국은 70개의 도시가 있는 도시간 인구 격차가 크다
SELECT
	countrycode,
	STD(city.Population) AS ST,
	VARIANCE(city.Population) AS VA,
	COUNT(countrycode) AS cnt
FROM city
GROUP BY countrycode # 같은 국가간 도시를 그룹화
HAVING cnt >= 50 # 50개 이상 도시를 가진 국가만 추출
ORDER BY st ASC;


-- 현재 날짜, 시간, 종합
SELECT CURDATE(), CURTIME(), NOW()
-- 현재 시간이 다른 경우, 디비상 설정 시간이 다른 시간대로 세팅
;

-- 요구사항
-- 년 -월, 시:분 출력하시오
SELECT LEFT(CURDATE(), 7), LEFT(CURTIME(), 5)
;

-- 시간정보를 넣어서 세부 정보 추출
SELECT NOW(),
	DATE( NOW() ), MONTH( NOW() ), DAY( NOW() ),
	HOUR( NOW() ), MINUTE( NOW() ), SECOND( NOW() ),
	-- 월, 요일 정보
	MONTHNAME( NOW() ), DAYNAME( NOW() ),
	-- 주|월|년 단위 소요된 day
	DAYOFWEEK( NOW() ), DAYOFMONTH( NOW() ), DAYOFYEAR( NOW() )
;

-- 날짜 + 시간 정보를 원하는 형태로 구성
-- %D : 일(xth) 월간기준 몇번째일, %j : 1년기준 몇일째 되는 날
SELECT DATE_FORMAT( NOW(), '%y %m %D %d , %j %s')
;

-- 시간 계산 기능 확인
# 개강한 날부터 현재까지 소요된 일수
SELECT DATEDIFF( NOW(), '2025-10-01' );
-- 나중 시간을 먼저 배티(아니면 음수로 계산)
SELECT DATEDIFF( '2025-10-01', NOW() );

-- 절대 값으로 보정 가능
SELECT ABS(DATEDIFF( '2025-10-01', NOW() ) );

-- 형변환
SELECT
	CAST( '123' AS UNSIGNED),	-- 문자열 -> 수치
	CAST( 2 AS CHAR(1) ),		-- 수치 -> 문자열(자리수)
	CAST( 20251022 AS DATE),	-- 수치 -> 시간
	CAST( '20251022' AS DATE)	-- 문자열 -> 시간
	
-- 랭킹
-- 전체 사원들의 랭킹(예시)
SELECT
	co.mem_no,
	co.order_date
	-- 랭킹
	,ROW_NUMBER()	OVER ( ORDER by order_date ASC ) AS RANK1
	,RANK() 			OVER ( ORDER by order_date ASC ) AS RANK2
	,DENSE_RANK()	OVER ( ORDER by order_date ASC ) AS RANK3
FROM car_order AS co;
	

-- partition by 의미
-- partition by 컬럼 => 이를 대상으로 그룹화하여 랭킹(개발팀, 디자인팀, 분석팀등등 개별 랭킹)
SELECT
	co.mem_no,
	co.order_date
	-- 랭킹
	,ROW_NUMBER()	OVER ( PARTITION by mem_no ORDER by order_date ASC ) AS RANK1
	,RANK() 			OVER ( PARTITION by mem_no ORDER by order_date ASC ) AS RANK2
	,DENSE_RANK()	OVER ( PARTITION by mem_no ORDER by order_date ASC ) AS RANK3
FROM car_order AS co;

-- (3977,1)
SELECT DISTINCT co.mem_no
FROM car_order AS co;

-- 4094
SELECT COUNT(*)
FROM car_order;


-- country 테이블 대상 3개 집단으로 나눔 -> 컬럼추가(파생변수)
-- 홍콩보다 작은(<=) 면적을 가진 집단
-- 홍콩보다 크고(>) 한국보다 작은(<=) 면적을 가진 집단
-- 한국보다 큰 면적을 가진 집단
-- 홍콩 면적(1075), 한국 면적(99434)은 직접 세팅
SELECT c.SurfaceArea, c.`Name`
FROM country
WHERE c.Code='kor' OR c.code='hkg'
;

SELECT CODE, NAME, c.SurfaceArea,
	case
	when c.SurfaceArea < 1075 then '홍콩보다작은'
	when c.SurfaceArea BETWEEN 1075 AND 99434 then '홍콩과한국사이'
	else '한국보다큰' end
	as sa_flag
FROM country AS c
;
-- 실습
-- 위의 결과를 기반(데이터셋, 테이블로 간주 -> 서브쿼리)으로
-- sa_flag 컬럼 기준 (그룹화 -> 집계)
-- 3개 그룹으로 데이터는 나뉜다 -> 결과
-- 그룹별, 총국가수, 면적평균, 면적최대, 면적최소값을 출력하시오

SELECT A.sa_flag AS 그룹별,
		 COUNT(*) AS 총국가수,
		 AVG(A.SurfaceArea) AS 면적평균,
		 MAX(A.SurfaceArea) AS 면적최대,
		 MIN(A.SurfaceArea) AS 면적최소값
FROM (SELECT CODE, NAME, c.SurfaceArea,
		case
		when c.SurfaceArea < 1075 then '홍콩보다작은'
		when c.SurfaceArea BETWEEN 1075 AND 99434 then '홍콩과한국사이'
		else '한국보다큰' end
		as sa_flag
	FROM country AS c
	)AS A
GROUP BY A.sa_flag
;
