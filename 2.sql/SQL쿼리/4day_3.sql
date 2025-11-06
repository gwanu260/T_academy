-- 참조 관계 테스트
-- 테이블 생성
CREATE TABLE country2(
	country_id INTEGER,
	NAME VARCHAR(50),
	population INTEGER,
	PRIMARY KEY (country_id)
);
/*
	참조키
	FOREIGN KEY (특정컬럼)
		REFERENCE 참조하는테이블(참조하는 컬럼명)
		[ON DELETE CASCADE|...]
*/
CREATE TABLE city2(
	city_id INTEGER,
	NAME VARCHAR(50),
	country_id INTEGER,
	PRIMARY KEY (city_id),
	FOREIGN KEY (country_id)
		REFERENCES country2(country_id)
		ON DELETE CASCADE 
);


-- 더미 데이터 삽입
INSERT INTO country2
VALUES
	(1, '한국', 5000),
	(2, '일본', 10000)
;

SELECT * FROM country2;
-- country2의 국가id를 참조하는 데이터 추가
INSERT INTO city2
VALUES
	(1, '서울', 1),
	(2, '도쿄', 2),
	(3, '부산', 1),
	(4, '부산', 2)
;
SELECT * FROM city2;

-- 삭제확인
DELETE FROM country2 WHERE country_id =2;


-- 계정 생성 -> 아이디만 단순하게 구성
CREATE USER guest1;

-- 계정 확인
-- %의 의미는 모든의미, HOST 컬럼값이 %라면 모든 곳에서 접근가능
SELECT 
	HOST, user, mysql.user.authentication_string
FROM mysql.user

-- 계정 삭제
DROP user guest1
