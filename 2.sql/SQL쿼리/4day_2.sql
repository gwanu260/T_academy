-- city 테이블에서 도시명, 인구수만 모아서
-- 가상 테이블 city_view를 생성하시오
CREATE VIEW city_view
AS
SELECT NAME, population
FROM city
;

-- 확인
SELECT COUNT(*)
FROM city_view;


-- 실습
-- city, country, country language 조인
-- 한국에 대한 정보로만 -> inner join(조인)
-- 뷰를 구성
-- 뷰 이름 total_kor_view
-- 컬럼 : 도시명, 면적, 인구수, 랭귀지, -> 영문 컬럼명사용
-- (140, 4)
CREATE VIEW total_kor_view
AS
SELECT B.`Name`, C.`SurfaceArea`, B.Population, A.Language
FROM (SELECT *
		FROM countrylanguage
		WHERE countrycode = 'kor' AND language = 'korean') AS A
JOIN city AS B
	ON A.Countrycode = B.CountryCode
JOIN country AS C
	ON A.Countrycode = C.Code 

WHERE A.countrycode = 'kor'
;

-- WHERE A.CountryCode='kor'

-- 한국어를 모국어로 사용하는 한국 데이터만 추출
SELECT *
FROM countrylanguage
WHERE countrycode = 'kor' AND language = 'korean';

-- 이 데이터만 가지고 분석등...
SELECT * FROM total_kor_view;


-- 뷰 수정 -> 뷰를 통채로 교체, 수정
SELECT * FROM city_view; -- (4079,2)

-- 같은 구조, 같은 크기에 내용만 교체
-- 필요시 통째로 교체 가능함 -> 수정
ALTER VIEW city_view
AS
SELECT city.CountryCode AS 'name', city.Population
FROM city
;
SELECT * FROM city_view;

drop view city_view;

-- 데이터 입력
-- 데이터베이스 A에서 시습
USE A;

DROP TABLE users;
-- 신규로 테이블 생성
-- PRIMARY KEY : 해당 데이터를 대표하는 값, 고유값,
-- 통상자동증가(자동부여-> 데이터가 추가되면 자동부여)
CREATE TABLE users (
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT ,
	age INT NULL,
	uid VARCHAR(32) NOT NULL, 
	pwd VARCHAR(128) NOT NULL, 
	email VARCHAR(64) NULL,
	regdate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 현재시간
SELECT NOW(), CURRENT_TIMESTAMP();

-- 입력 1
-- 컬럼을 나열하여, 매칭되게 데이터로 세팅
-- 단, 기본값(자동삽입)이 존재하는 컬럼은 생략 가능, id, regdate
-- 정상 처리가 되면 로그상에 영향받은 로의 수(effectedrows : 1)
-- 컬럼의 순서는 관계가 X, 값 매칭만 잘되면 ok
INSERT INTO users
(age, uid, email, pwd) -- 컬럼 순서 조정(관계없음)
VALUE
(25, 'a', 'a@a.com', '1234')
;

SELECT * FROM users;

-- 데이터 추가중 unique에서 오류가 나서 리젝되면->관계없이
-- id(auto_increment)값이 부여되고 반영 x

INSERT INTO users
(age, uid, email, pwd) -- 컬럼 순서 조정(관계없음)
VALUES -- value:비표준(임시허용), values 표준
(25, 'a1', 'a1@a.com', '1234')
;

-- 멀티 데이터 입력
-- 한번에 여러개 데이터를 삽입할때 값을 ()로 묶어서 나열
INSERT INTO users
(age, uid, email, pwd)
VALUES
	(25, 'a3', 'a3@a.com', '1234'),
	(25, 'a4', 'a4@a.com', '1234')
;

-- 컬럼 생략 -> 자동세팅되는 컬럼까지도 직접 부여해라
-- 컬럼의 순서대로 데이터 세팅
-- PRIMARY KEY 최종 사용값을 알아야 대처 가능
-- 기본값을 다 세팅, 컬럼 순서대로 데이터 세팅
INSERT INTO users
VALUES
	(13, 25, 'a5', '1234', 'a5@a.com', NOW())
;

CREATE TABLE `users2` (
	`id` INT NOT NULL AUTO_INCREMENT,
	`age` INT NULL DEFAULT NULL,
	`uid` VARCHAR(32) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`pwd` VARCHAR(128) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`email` VARCHAR(64) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
	`regdate` TIMESTAMP NOT NULL DEFAULT (CURRENT_TIMESTAMP),
	PRIMARY KEY (`id`) USING BTREE,
	UNIQUE INDEX `uid_pwd` (`uid`, `pwd`) USING BTREE,
	UNIQUE INDEX `uid` (`uid`) USING BTREE,
	UNIQUE INDEX `email` (`email`) USING BTREE
)
COLLATE='utf8mb4_unicode_ci'
ENGINE=InnoDB
AUTO_INCREMENT=1
;

-- 특정 테이블의 특정 데이터를 타겟 테이블에 일괄 입력
INSERT INTO users2
SELECT * FROM users
;



-- 업데이트
SELECT * FROM users;
-- id가10번 고객을 찾아서,
-- 나이를 +3 시키시오 (업데이트)
UPDATE users
SET age=age+3
WHERE id=10
;


-- 삭제
-- users 테이블에서 나아가 25세를 초과하는 고객 삭제
DELETE FROM users
WHERE users.age > 25;


TRUNCATE TABLE users2;


drop table users2;

DROP DATABASE A;
SHOW DATABASES;
