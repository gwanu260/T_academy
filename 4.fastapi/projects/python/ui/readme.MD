# 프로젝트 주제
    - jinja2 템플릿 + adminlte(무료 대시보드) 조합
    - fastapi 기반으로 대시보드 사이트 기본 베이스 구동
    - 화면 기반 웹서비스를 중심으로 하위 페이지에서 fastapi 기능구성
    
# 구조 (tree or tree > s.txt)
/
├─ static
├─ templates
├─ main.py
└─ readme.MD

# 데이터베이스 연동
    - 목표
        - 파이썬 <-> 접속 라이브러리 <-> mysql
        - 접속 라이브러리
            - mysql을 접속하여 쿼리수행을 도와주는 패키지 : `pymysql`, mysql, ...
            - 모든 데이터 베이스 제품에 대한 상위 레벨 패키지
                - sqlAlchemy 
                - 데이터베이스가 my sql이라면
                    - 파이썬 <-> sqlAlchemy <-> 접속 라이브러리 <-> mysql(db)
                - 특징 작업의 확장성 발생
                - SQL을 몰라도 ORM 방식으로 디비와 작업 가능함.
                    - API(간단하게 함수) 사용으로 디비와 작업 가능
                        - 내부에서 알아서 sql 생성함
                - 데이터베이스 제품이 바뀌어도 동일하게 처리됨.
    - 설치
        - pip install pymysql sqlAlchemy
        - requirements.txt
            - pymysql
            - sqlAlchemy
            ```
                pip install -r requirements.txt
            ```
    - 확인
        - pip show pymysql
# 로컬 PC에 파이썬 설치
    - 설치 첫 페이지에 Add .... Path 반드시 체크
    - 체크 안하고 설치햇다면 
        - 사용자 변수 환경변수 추가
            - win + R => 환경변수 엔터 => 사용자 변수 > path 추가
            - C:\Users\사용자명\AppData\Local\Programs\Python\Python314\Scripts\
            - C:\Users\사용자명\AppData\Local\Programs\Python\Python314\