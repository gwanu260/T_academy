# order by
-- 모든 도시의 정보중 인구수를
-- 오름차순 기준(작은값 -> 큰값)으로 정렬하여 추출
SELECT *
FROM city
ORDER BY city.Population ASC;
# 인구수 정렬값 => 42, 167, .... , 10500000

-- 기본정렬은 오름차순 -> 표기법 생략
SELECT *
FROM city
ORDER BY city.Population;

-- 인구수를 기준으로 내림차순 정렬
SELECT *
FROM city
ORDER BY city.Population DESC;

-- 인구수 내림차순, 국가코드 오름차순 정렬하여 도시정보출력
-- ,로 나열
-- 인구수가 같을 확률이 아주 적어서 결과셋에서
-- 적용된 의미를 확인하기가 어려움
SELECT *
FROM city
ORDER BY city.Population DESC, city.CountryCode ASC;
# 범주형 데이터를 먼저 정렬후, 인구배치
# 알파벳을 체크하여 인구를 체크하는 자연스러운 배치가 됨
# 국가별로 인구수를 냄침차순으로 정렬하는 효과
# 전체는 오름 차순, 국가내에서는 인구수 기준 내림차순으로
# 데이터 정렬
SELECT *
FROM city
ORDER BY city.CountryCode ASC, city.Population DESC;

-- 인구는 내림차순
-- 한국 도시만 대상
-- 대상 도시의 모든 정보 추출
SELECT *
FROM city
WHERE city.CountryCode = 'KOR'
# 조건구문 이후 거의 마지막에 위치함
ORDER BY city.Population DESC
;
-- (70, 5)

-- country 테이블에서
-- 국가 정보 모든것
-- 면적순으로 내림차순 정렬
SELECT c.`Name`, c.SurfaceArea
FROM country AS c
ORDER BY c.SurfaceArea DESC
;



-- city 테이블에서 모든 국가 코드를 구하시오
-- 단, 국가별 1개의 코드만 추출함
SELECT distinct countrycode
FROM city
ORDER BY city.CountryCode ASC
;
-- (232, 1)


-- 국가 면적 및 이름을 추출
-- 면적순으로 정렬(큰값->작은값)
-- 상위 top10만 출력함
SELECT c.`Name`, c.SurfaceArea
FROM country AS c
ORDER BY c.SurfaceArea DESC
LIMIT 10
;
-- (239, 2) -> 전체 결과셋에서 상위 10개만 제한


-- limit n(결과셋에서 시작위치), m(페이지당 데이터수)
-- 페이지당 데이터수 : 한페이지에 보이는 데이터(게시물)수
SELECT c.`Name`, c.SurfaceArea
FROM country AS c
ORDER BY c.SurfaceArea DESC
-- LIMIT 0, 10
-- LIMIT 10, 10
-- (24-1)*10 => 24페이지 표현
LIMIT 230, 10 -- 마지마 게시물은 10개 안돼서 9개만 출력(적은 수도 OK)
;
-- limit (페이지번호-1)*(페이지당출력(데이터수)수=M), M

-- 집계 예시 -> 그룹의 대표값 예시
-- 같은 국가코드를 가진 데이터끼리 그룹화 화여 집계 처리
-- `group by contrycode`
-- 데이터셋의 컬럼은 국가코드(컬럼직접사용=집계대상), 인구의 최소값(min_popu)
-- 데이터는 '인구의 최솟값' 기준 오름차순 정렬
-- 상위 탑10만 출력
SELECT countrycode, MIN(population) AS min_popu
-- SELECT name <- 에러발생, 집계 기준 컬럼만 직접 사용 가능
FROM city
GROUP BY countrycode
ORDER BY min_popu ASC
LIMIT 0, 10
;

-- 국가별 도시 인구 평균을 구해서 내림차순 정렬
-- 국가별(집계) 도시 인구 평균을 구해서, 내림차순 정렬
-- 상위 탑 5위부터 10개 출력
-- 출력 값 국가코드, 평균인구수( avg_popu )
SELECT c.CountryCode, AVG(c.Population) AS avg_popu
FROM city AS c
GROUP BY c.CountryCode
ORDER BY avg_popu DESC
LIMIT 4, 10
;

-- 국가별(집계)
-- 최대인구수(max_popu) 기준 내림차순 정렬
-- 출력 : 국가코드, 최대인구수
SELECT countrycode, MAX(population) AS max_popu
FROM city
GROUP BY countrycode
ORDER BY max_popu DESC
;

-- 위의 결과에서, 9백만명 이상(>=)만 대상으로 출력
-- max_popu는 1차 조건(혹은 집계의) 결과물 -> where X
-- 1차 쿼리후 파생된 결과물을 대상으로 조건 -> HAVING
SELECT countrycode, MAX(population) AS max_popu
FROM city
GROUP BY countrycode
HAVING max_popu >= 9000000
ORDER BY max_popu DESC
;
-- (6, 2)

-- (리뷰 연습) 위의 문제 기준,
-- 국가별 도시수가 30개 이상 <= 조건 추가(모집합 대상)
-- 1차 조건 부여함. => 서브쿼리등 다양한 방법 동원
-- 인 국가를 대상으로 위의 문제 해결


-- 요구사항
-- 같은 국가코드를 가진 데이터들의 도시의 인구수를
-- 합산
-- (생략)한국 데이터만 보여준다
-- WITHE ROLLUP -> 중간 집계 데이터가 삽입 (국가별 총인구수,
-- 국가별로 가장 마지막 데이터에 추가되어서 표현

-- 도시별 데이터에 국가별 중간 집계 데이터 추가하시오(합계)
SELECT countrycode, `name`, SUM(population) AS sum_popu
FROM city
GROUP BY countrycode, `name` WITH ROLLUP
#HAVING countrycode = 'kor'