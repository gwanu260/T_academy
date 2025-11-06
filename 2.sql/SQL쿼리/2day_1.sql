# SELECT 연습

-- 요구사항
-- city 테이블에서
-- 인구수 5000000 이상(>=) 되는 도시 데이터 추출
-- 컬럼 정보 전부 회득
SELECT *
FROM city
WHERE city.Population >= 5000000
;
-- (24, 5)


-- 인구수 5백만 이상(>=)이고, 6백만 이하(<=)인
-- 도시의 모든 정보 추출하시오

SELECT *
FROM city
WHERE city.Population >= 5000000 AND city.Population <= 6000000
;
-- (4, 5)

-- 위와 동일한 쿼리에서 도시수를 구한다면
-- 위 조건을 만족하는 도시의 수는?
-- selcect_express -> count()로 계산하시오
-- 결과셋의 컬럼명은 cnt로 하시오(별칭)
-- count( 컬럼명 * )
SELECT COUNT(*) AS cnt
FROM city
WHERE city.Population >= 5000000 AND city.Population <= 6000000
;

-- 일치하지 않는다(<>. !=)
-- 도시의 인구수가 1780000이 아닌 도시의 총수
-- 전체수 : 4079, 조건에 해당되는 수 : 4078
SELECT COUNT(*) AS cnt
FROM city
WHERE city.Population <> 1780000
#WHERE city.Population != 1780000
;

-- 시티 테이블에서
-- 한국(KOR)이거나 미국(USA)에 있는
-- 모든 도시 정보를
-- 출력하시오

SELECT *
FROM t1.city AS c
WHERE c.CountryCode='KOR' OR c.CountryCode='USA'
;

-- 시티 테이블에서
-- 한국(KOR) 도시들중, 인구수가 백만이상인
-- 모든 도시 정보를
-- 추출하시오
SELECT *
FROM t1.city AS c
WHERE c.CountryCode='KOR' AND c.Population >= 1000000
;
-- 조건식의 배치에 따라 결과셋이 완성되는 시간(자원)이
-- 상이함 => 최적화(표현, 수행시간, 리소스사용량등 고려)
-- 조건식 구성
SELECT *
FROM t1.city AS c
WHERE c.Population >= 1000000 AND c.CountryCode='KOR'
;

-- 인구수 5백만 이상(>=)이고, 6백만 이하(<=)인
-- 도시의 모든 정보 추출하시오
-- Between ~ and ~ 사용 전제 => 조건식보다 간결해짐
SELECT *
FROM city
WHERE population BETWEEN 5000000 AND 6000000;
-- (4, 5)



-- 도시 이름들 중
-- 서울, 부산, 인천인 경우-> in
-- 즉, 전체 도시들중 서울, 부산, 인천 정보만 추출하시오
-- 전체 도시 정보 추출하시오
-- 대소문자 구분 X (별도 상세 조건 x)
SELECT *
FROM city
WHERE `name` IN('seoul', 'pusan', 'inchon')
;

-- 한국(KOR), 미국(USA), 일본(JPN), 프랑스(FRA) 속한
-- 모든 도시들을 모아서, 총수를 구하시오
-- 총수의 결과셋의 컬럼명은 city_count
SELECT COUNT( countrycode ) AS city_count
FROM city 
WHERE city.CountryCode IN('KOR', 'USA', 'JPN', 'FRA')
;
-- 632개

-- 위의 결과셋의 빌추어(조건동일)
-- 도시명과 인구수 추출
-- 단(조건추가), 인구수가 6백만명 이상(>=)인 경우에 해당됨
SELECT city.`Name`, city.Population
FROM city
WHERE city.CountryCode IN('KOR','USA','JPN','FRA')
AND city.Population >= 6000000
;
-- (3,2)

-- 서브쿼리
-- 요구사항. 프랑스의 국가코드르 모르겠다.
-- 단, 파리라는 도시가 프랑스의 도시인것은 알겠다.
-- 파리 -> 도시정보 획득 -> 국가코드 획득 -> 프랑스의
-- 모든 도시 정보 획득

-- 1단계 파리(paris)라는 도시명을 이용하여 국가코드 획득
SELECT countrycode
FROM city
WHERE `name`='paris' -- 값은 '값'으로 표현(타입무관)
;
-- FRA => 결과셋이 1개이다 (1,1)
-- 2단계 1단계 결과를 이용하여 프랑스 모든 도시 정보추출
SELECT *
FROM city
-- WHERE countrycode='FRA'
WHERE countrycode=(
            SELECT countrycode
            FROM city
            WHERE `name`='paris' )
;
-- (40,5)


-- 서브쿼리 오류상황 -> 결과셋이 2개 이상 (여기서는 6개)
SELECT countrycode
FROM city
WHERE city.District='New York'
;

-- 오류 발생 (서브 쿼리 결과가 2>=)
-- 어떤 결과에 조건을 붙일지 판단 X
SELECT *
FROM city
where countrycode=(SELECT countrycode
                         FROM city
                         WHERE city.District='New York')
;

-- 해결 => 이들중 한가지만 선택하여 만족하면 OK => any|some
--  any|some => 수치형인 경우 범위(>, <)
--              같다(=) 수치형|범주형 => in과 유사함
-- 해결 => 이들중 모두 만족하면 OK => all

-- 뉴욕주에 포함된 모든 도시들의 인구수들 보다 큰 인구수를
-- 가진 모든 도시의 정보를 가져오시오

-- 뉴욕주에 포함된 모든 도시들중 인구수가
-- 가장 작은 인구수(93994)보다
-- 크기만 하면 대상이 되는 모든 도시 정보 획득
SELECT *
FROM city
WHERE city.population > ANY (SELECT population
						 FROM city
						 WHERE city.District='New York')
;
-- (3782, 5)
SELECT *
FROM city
WHERE city.population > SOME (SELECT population
						 FROM city
						 WHERE city.District='New York')
;
-- (3782, 5)

-- = 처리 했을시 => IN과 동일한 효과를 발생함
-- IN을 사용하고 싶은데
-- 데이터를 일일이 나열하기 귀찮다(동적처리를 원한다)
SELECT *
FROM city
WHERE city.population = ANY (SELECT population
						 FROM city
						 WHERE city.District='New York')
;



-- countrycode들중 일치되는게 하나라도 있으면 모두 포함
-- 범주형 OK( =만 사용 가능, <나 >은 의미가 달라질수 있다)
SELECT *
FROM city
where countrycode = ANY (SELECT countrycode
						 FROM city
						 WHERE city.District='New York')
;

-- ALL
-- 서브쿼리의 모든 결과셋보다 인구수가 크면 대상이됨(모두만족)
-- 가장 큰값보다 크면 대상
SELECT *
FROM city
WHERE city.population > ALL (SELECT population
						 FROM city
						 WHERE city.District='New York')
;
-- (9,5)