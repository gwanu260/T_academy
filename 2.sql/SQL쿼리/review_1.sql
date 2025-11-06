-- (리뷰 연습) 위의 문제 기준,
-- 국가별 도시수가 30개 이상 <= 조건 추가(모집합 대상)
-- 1차 조건 부여함. => 서브쿼리등 다양한 방법 동원
-- 인 국가를 대상으로 위의 문제 해결
SELECT countrycode, COUNT(*) AS city_count, MAX(population) AS max_popu 
FROM city
WHERE countrycode IN (
							  SELECT countrycode
							  FROM city
							  GROUP BY countrycode
							  HAVING COUNT(*) >= 30)
GROUP BY countrycode
HAVING max_popu >= 9000000
ORDER BY max_popu DESC;