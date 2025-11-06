# 데이터베이스 목록 출력
SHOW DATABASES;

# 사용할 디비 지정
USE t1;

DESC city;

# city 테이블의 모든(*) 데이터 가져오시오

# (4079, 5) <= 데이터 shape (rows, cols)
# *는 위험한 표현임. 디비가 렉걸릴 수 있음
# *는 배제, 필요한 컬럼만 나열

select `name`, population AS popu
FROM city;