-- 문자열 관련 특수 연산자
-- country테이블에서 국가명에 kor이 들어있다면
-- 모두 추출하시오 -> 검색
SELECT *
FROM country
WHERE country.`Name` LIKE '%kor%'
;

-- ea로 끝난 다면
SELECT *
FROM country
WHERE country.`Name` LIKE '%ea'
;

-- sou 로 시작하는
SELECT *
FROM country
WHERE country.`Name` LIKE 'sou%'
;


-- 산술연산자 활용
-- 한국 면적을 각 국가 면적으로 나눠서
-- 각국가면적/한국 면적 => 비율(부동소수)
-- 한국보다 면적이 큰(>) 국가만
-- 국가코드, 대비값(비율) 를 구하시오

-- 한국면적 -> 1개의 값 -> 서브쿼리 활용
-- 99434.0
SELECT c.SurfaceArea
FROM country AS c
WHERE c.Code='kor'
;

-- 구현 1차버전( 한국면적 고정하여 사용)
-- 비율이 1.0 이상인 데이터만 대상
-- 특정 데이터는 모집합이 모인후->연산작동->결과셋(2차)
SELECT
	ct.Code,
	ct.name,
	ct.SurfaceArea/99434
	AS std_area
FROM country  AS ct
having std_area > 1.0
ORDER BY std_area ASC
;

-- 2차 버전 -> 서브쿼리 활용, 특정 국가코드를 입력하면
-- 자동 계산
-- (109, 3) => 최적화 시도
SELECT
	ct.Code,
	ct.name,
	ct.SurfaceArea/(SELECT c.SurfaceArea
						 FROM country AS c
						 WHERE c.Code='kor')
	AS std_area
FROM country  AS ct
having std_area > 1.0
ORDER BY std_area ASC
;


-- 문자열 함수
SELECT
	LENGTH('hi'), LENGTH('HI'),
	LENGTH('가나'), # 한글 문자당 3byte의 길이 사용(mysql 제품)
	LENGTH('12'), LENGTH('!@');

-- 컬럼에 문자열 함수 적용
SELECT
	city.`Name`,
	LENGTH(city.`Name`) AS size,
	city.Population,
	LENGTH(city.Population) # 수치값도 가능한지 체크->문자열처리후계산
FROM city
ORDER BY size DESC
LIMIT 5
;


-- concat()
SELECT
	CONCAT('hello','-','world'),
	CONCAT('hello',null,'world') # 결과는 NULL
	;

-- 컬럼에 적용
SELECT CONCAT(NAME, '-', city.Population ) AS spec
FROM city
;


-- Locate()
SELECT
	LOCATE('w', 'world'),	-- 맨처음 위치
	LOCATE('or', 'world'),	-- 2글자 이상 위치 탐색?
	LOCATE('z', 'world')		-- 없는 글자 탐색
;

-- 요구사항
-- city 테이블에서 'se'로 시작하는 도시를 모두 찾아라
-- 그 위치값 계산 1<=위치값<=3 인 도시만 추출하여
-- 도시명, 위치값(loc)을 출력하시오
-- where 사용? having 사용?
-- where => 대상 테이블(혹은 데이터셋)에서 이미 loc가 준비되어있어야 함
SELECT *
FROM (SELECT `Name`, LOCATE('se', `Name`) AS loc FROM city) AS A
WHERE A.loc BETWEEN 1 AND 3
;

-- 위의 표현보다 더 빠름, 리소스를 적게 사용함
SELECT `Name`, LOCATE('se', `Name`) AS loc
FROM city
HAVING loc BETWEEN 1 AND 3



-- 왼쪽기준, 오른쪽 기준 추출
SELECT
	LEFT('hello world', 3),
	RIGHT('hello world', 3)
;
SELECT
	LEFT(NAME, 3),
	NAME,
	RIGHT(NAME, 3)
FROM city
;
-- 수치 데이터를 가진 컬럼 값 자르기
SELECT
	LEFT(city.Population, 3),
	Population,
	RIGHT(city,Population, 3)
FROM city
;
		
-- 대소문자 변환
-- 특정 컬럼이 추가
SELECT NAME, LOWER(NAME), UPPER(NAME), LOWER('aB1rk!') AS test
FROM city
;


-- 특정 문자열 대체 (문자열데이터, 수치데이터등 적용가능)
SELECT city.Population, REPLACE( city.Population, '0','*')
FROM city
;


-- 공백제거
-- 각 패턴에 맞게 공백 제거후 남은 문자열 반환
SELECT
	TRIM('  A B  '),
	TRIM('  AB'),
	TRIM('AB  '),
	TRIM(LEADING '@' FROM '@@@ a @@@'),
	TRIM(TRAILING '@' FROM '@@@ a @@@'),
	TRIM(both '@' FROM '@@@ a @@@')
;

-- city 테이블에서
-- 도시명의 첫글자중 'S'를 제거
-- 출력 : 도시명, s가 제거된 도시명
-- 도시명이 'S'로 시작되는 데이터만 출력
SELECT `NAME`, TRIM(LEADING 'S' FROM `NAME`)
FROM city
WHERE `NAME` LIKE 'S%';




-- format
-- 정수부에 대해서는 자동으로 3자리마다 콤마 추가
-- 두번째 인자는 소수부의 자리수 표현
SELECT FORMAT(98247923847.2347289, 3),
		 FORMAT(98247923847.2347289, 4),
		 FORMAT(98247923847.2347289, 0)

-- 요구사항
-- 포멧 함수를 사용하면 문자열로 대체

mysql> select population, format(population, 0) from city limit 5;
/*
+------------+-----------------------+
| population | format(population, 0) |
+------------+-----------------------+
|    1780000 | 1,780,000             |
|     237500 | 237,500               |
|     186800 | 186,800               |
|     127800 | 127,800               |
|     731200 | 731,200               |
+------------+-----------------------+
5 rows in set (0.001 sec)
*/

-- 문자열 자르기
-- 특정위치로부터 특정 길이(개수)만큼 문자 반환(자르기, 추출)
SELECT SUBSTRING('ABCD', 2, 2)

-- 국가명, 국가명(처음부터 3글자만) 앞부분
SELECT c.`Name`, SUBSTRING( c.`Name`, 1, 3)
FROM country AS c
;


