-- 데이터베이스 생성 (기본값 옵션 적용)
CREATE DATABASE IF NOT EXISTS A;
-- 모든 데이터베이스 출력 (생성된것 확인)
SHOW DATABASES;
-- 해당 데이터베이스 사용 지정
USE A;


-- 테이블, 데이터 카피
CREATE TABLE city_copy
AS
SELECT *
FROM city
;

-- 다른 디비의 테이블과 데이터를
-- 복사해옴
CREATE TABLE A.city_copy
AS
SELECT *
FROM t1.city
;

-- 요구사항
-- A 데이터베이스에 city_sub 테이블 생성
-- t1 데이터베이스의 city와 같은 구조
-- 데이터는 국가코드가 한국, 미국, 일본만 추출하여 카피
-- 데이터는 국가코드, 도시명, 인구수만 사용(테이블구조, 데이터)

CREATE TABLE A.city_sub
AS
SELECT c.CountryCode, c.`NAME`, c.Population
FROM t1.city AS c
WHERE countrycode IN ('KOR','USA','JPN')
;



CREATE TABLE `city_copy` (
	`ID` INT NOT NULL DEFAULT '0',
	`Name` CHAR(35) NOT NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`CountryCode` CHAR(3) NOT NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`District` CHAR(20) NOT NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`Population` INT NOT NULL DEFAULT '0'
)
COLLATE='utf8mb4_unicode_ci'
ENGINE=InnoDB
;


-- 테이블 구조 확인
DESC users;

-- 컬럼 추가
ALTER TABLE users
ADD col INT NULL;
DESC users;

-- 컬럼 수정
-- 바꿀 부분만 명시, 기존 세팅은 유지(충돌 없을때만)
-- 이미 데이터가 있다면 신중하게 작업
ALTER TABLE users
MODIFY col VARCHAR(128);
DESC users;

-- 컬럼 삭제
ALTER TABLE users
drop col;
DESC users;



USE A;
-- users 테이블의 모든 인덱스 출력
SHOW INDEX FROM users;

-- 인덱스 생성 -> 기본값으로 BTREE 알고리즘 적용
-- CREATE INDEX 인덱스명
CREATE INDEX uid_idx
-- on 테이블명 (컬럼명)
ON users (uid)
SHOW INDEX FROM users;




SHOW INDEX FROM users;
-- 고유한값을 가진 인덱스 생성
CREATE UNIQUE INDEX email_idx
ON users (email)
;
SHOW INDEX FROM users;

-- 멀티 컬럼의 (고유한값 세트)을 가진 인덱스
CREATE UNIQUE INDEX uid_upw_index
ON users (uid, upw)
;
SHOW INDEX FROM users;

-- uid와 upw가 모두 일치해야 검색 완료
-- 검색단위가 2개 컬럼을 기준으로 진행

alter table users
drop index uid_upw_idx;

show index from users;




alter table users
add FULLTEXT uid_check(uid);

show index from users;
