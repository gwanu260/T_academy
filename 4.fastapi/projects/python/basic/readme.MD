# 베이스
    - 웹 개발?
        - 데이터베이스에 정보를 조회하여 특정 목적(메인내용, 뉴스목록, 로그인 화면, ....) 구성하기 위한 프로그램 작성 (비즈니스 로직)
            - 언어(python) -> 프레임웍(fastapi) -> orm -> DB
    - IDE

# 기본
    - 역할
        - 웹서비스상에서 백엔드 포지션
        - 프런트엔드(웹) or 앱(네이티브|웹앱(혹은 하이브리드)) <-> 백엔드 <-> 데이터베이스 or 타서비스(LLM 호출등, 모델 서빙)
            - LLM - 파인튜닝, RAG등 이용한 서비스 특화(모델을 전용으로 학습...)
            - MCP 구성등등
    - 성능
        - 파이썬의 다른 웹서비스(flask, 장고)보다 속도가 더 빠름
        - Go(구글)와 같은 수준
        - (*)I/O이 가장 빠름(비동기 처리 기준)
    - 자동 문서화
        - (*)Swagger 기본 탑재
        - 문서화, api 테스트등 자동 제공
    - 입력값 유효성 검사 -> UI적
        - (*)Pydantic을 이용하여 쉽게 처리
            - 요청과 응답 -> 모델링 구성, 유효성 검사 자동처리
    - (*)비동기 프로그래밍
        - fastapi(비동기 최적화) <-> flask (동기식 최적화)

# 설치
    - 파이썬 설치
        - os 레벨 설치
        - docker 기반 설치
            ```
               docker run --name python -p 8000:8000 -itd -v C:\Users\Dell5371\Desktop\projects\python:/home/app python 
            ```

            - 서비스별로 컨테이너를 구성
                - 서비스별로 가상환경을 구축할 필요가 없음
    - DOCKER상 존재하는 python 컨테이너 접속
        - CLI
            ```
                docker exec -it python bash
            ```
        - (*)vscode
            - Dev container > remote .. > python .. 선택
            - open folder > /home/app
            - 왼쪽 아이콘 > extension > 검색 > python(ms것) 설치
        - docker client
            - container > python > exec 
                ```
                # 
                ```
    - 필요한 패키지 설치
        - pip install fastapi==0.120.2 uvicorn==0.27.0.post1
        - pip install -r requirements.txt
            - requirements.txt : 여러개의 패키지를 버전별로 설치시 일괄적으로 기술하여 설치가능한 파일
            - pip list --format=freeze > requirements.txt
                - 불필요한것도 전부 기록됨.
        - 추후 필요한 패키지
            - requirement.txt 기재 -> 저장 -> 설치명령s
        - 설치 목록 확인하기
            ```
                pip list
            ```

# 기본 코드 작성
    - run.py 작성
    - 구동 (비동기 최적화, 코드 수정시 이를 감지하여 자동 재가동, 도커 컨테이너를 통과해셔 요청, 응답이 원활하게 이동)
        ```
            uvicorn 모듈명:FastAPI객체명 --reload --host=0.0.0.0 --port=8000

            uvicorn run:app --reload --host=0.0.0.0 --port=8000
        ```
        - uvicorn
            - Uvicorn is a lightweight and fast ASGI (Asynchronous Server Gateway Interface) web server implementation for Python. It is designed to host asynchronous web applications and APIs built with frameworks like FastAPI, Starlette, and Quart.
        - 차후 클라우드 세팅
            - client <-> 웹서버(apache or nqinx):web server <-> uvicorn + fastapi:was(Web Appication Server) <-> mysql:database
    - 브라우저 가동 > http://127.0.0.1:8000/ 접속

# 라우팅
    - 목적
        - 클라이언트의 요청을 해석 -> url 파싱
        - 어떤 함수가 이 요청을 처리할지 판단
        - 해당 요청을 전달하고 함수를 호출

# 문서 자동화
    - 스웨거가 자동으로 작동됨
    - http://127.0.0.1:8000/docs
        - API 목록 확인 (특수 주석에 따라 풍성한 설명 가능함)
        - API 테스트 가능
            - 데이터 전달
            - 로그인 등 세션 테스트도 가능
        - http://127.0.0.1:8000/redoc
            - 빠르게 api 확인용 (읽기 전용)
            - 테스트 X

# 템플릿
    - 백엔드 서버로 제공하는 서비스
        - 화면 존재
            - 웹페이지 개발
            - 반드시 템플릿 엔진 병행 -> 동적으로 손쉽게 html 구성 ->
            SSR(Server Side Rendering) : 전통적인 개발방법
                - 파이썬 : jinja2
                    ```
                        pip install jinja2==3.1.2
                        # requiermenst.txt 기재
                        # 특정 패키지가 설치 되었는지 확인
                        pip show jinja2
                    ```
                - node  : ejs, fade, ...
                - java : 타임리프, ...
        - 화면 미존재
            - rest API 개발
            - JSON / XML로 요청및 응답시 데이터를 구성
            - swagger, restapi 테스트 툴등이 필수

    - 템플릿 엔진 역할
        - html 파일(기본틀은 존재함)을 읽어서 데이터(게시판 제목등등)를 동적으로 세팅(생략가능) 최종화면(html) 완성
        - 응답(서버 -> 클라이언트 전송) : return
        - html은 어디에 위치?
            - /templates/*.html
    
    - 정적 데이터 포함
        - 대상 : js, css, 이미지(jpg, png, ..), 동영상(스트리밍 논외), ..
        - 특징 : 웹에서 보여주기 위해 별도의 라우팅 작업 필요 X
            - 특정 위치에 두면 자동으로 URL로 인식함
        - 폴더명 : static

# 구조
/
L static            : 정적 파일을 위치 시킴
    L logo.png
L template          : html 파일을 위치 시킴
    L index.html
L *.py              : 파이썬 모듈