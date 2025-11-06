-- 대상 테이블 수 확인
SELECT COUNT(*) FROM city;   	# 데이터수 (4079, 5)
SELECT COUNT(*) FROM country;	# 데이터수 (239, 15)

-- 가장 기본 조인
-- 2개 테이블에 공통으로 존재하는 컬럼 (국가코드)
-- 공통 컬럼을 중심으로 데이터를 연결

-- 요구사항
-- city,country 테이블을 대상으로 inner join
-- 특정 컬럼이 일치하면 하나의  row 데이터로 구성
-- 2개 테이블 기준 -> 결과셋 -> 왼쪽 테이블 같거나 작음
SELECT *
FROM city AS c
-- 조인(기본형이 inner join)
JOIN country AS co
-- 결합조건
ON c.CountryCode = co.Code
;
-- (4079, 20) => (city 테이블의 총 데이터수, 모든 컬럼수)

-- 필요한 데이터만 추출
-- 도시명, 국가코드, district, 인구수, 면적만 추출한다
-- 컬럼명도 위에 언급한대로 구성
SELECT
	c.`Name` AS 도시명,
	co.Code AS 국가코드,
	c.District ,
	c.Population AS 인구수,
	co.SurfaceArea AS 면적
FROM city AS c
JOIN country AS co
ON c.CountryCode = co.Code
;

-- coutryLanguage
DESC countrylanguage;

-- 한국 국가코드를 기반으로 언어 정보 모두 추출
SELECT *
FROM countrylanguage
WHERE countrycode='JPN';
-- 통상 하나의 국가에 언어를 1개 이상 사용한다(비중있게)

-- 요구사항
-- 3개 테이블 조인
-- city, countrycode, countryLanguage

SELECT*
FROM city AS A
JOIN country AS B ON A.CountryCode = B.Code
JOIN countrylanguage AS C ON A.CountryCode = C.Countrycode
;
-- (30670, 24)
-- 국가별로 사용하는 언어수가 1개가 아니므로,
-- n개(제각각) => 이로 인한 데이터 증가(케이스 생성)
-- 데이터가 inner 개념에서는 많아질수 있음

-- left join
-- (4079, 5) => 왼쪽 테이블의 데이터의 수 보장
SELECT
	A.`Name`, B.Code, A.District,
	A.Population, B.SurfaceArea
FROM city AS A
LEFT JOIN country AS B
ON A.CountryCode = B.Code
;

-- RIGHT join
-- (4086, 5) => 오른쪽 테이블의 데이터는 보장(고정) 조인
SELECT
	A.`Name`, B.Code, A.District,
	A.Population, B.SurfaceArea
FROM city AS A
RIGHT JOIN country AS B
ON A.CountryCode = B.Code
;

-- 도시명, 인구수 출력, 한국만 대상, 인구수는 9백만이상
-- 도시명, 인구수 출력, 한국만 대상, 인구수는 8십만이상
-- 2개의 결과를 합치시오
SELECT NAME, POPULATION
FROM city
WHERE countrycode = 'kor' AND population >= 9000000
union
SELECT NAME, POPULATION
FROM city
WHERE countrycode = 'kor' AND population >= 800000
;

SELECT NAME, POPULATION
FROM city
WHERE countrycode = 'kor' AND population >= 9000000
UNION all
SELECT NAME, POPULATION
FROM city
WHERE countrycode = 'kor' AND population >= 800000
;