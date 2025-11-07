# 웹 프로그래밍
    - 목표
        - 대시보드(프런트중심, 차트, 소켓), API(백엔드, restFul), 모델서빙(ML/DL/LLM이후), 인프라환경구성(클라우드)
    - s/w or 프로그램 or 언어 구성
    - 3-tier => 1명이 모두 수행(풀스택 개발자)
        - 프런트엔드
        - 백엔드
        - 데이터 베이스
            - 모델링
            - SQL -> AI가 거의 다 정복했음 <-> 프로그래밍에서는 ORM방식 처리(SQL몰라도 가능함)
                - 기본/표준
                - 고급/프로시저, 함수, 트리거

## 프런트엔드
    - 웹브라우저에서 보이는 **화면 담당**
    - 구성
        - html
            - 뼈대, 콘텐츠
            - 틈틈이 계속 체크
        - css
            - 디자인, 레이아웃, 애니메이션
                - 사전에 만들어진 프레임웍기반 `조립(커스텀)`
                - 부트스트립
                    - adiminlte.io, ...
                - 머터리얼
                    - m3.material.io, ...
            - 커스텀
                - 디자인 툴(s/w, sass(클라우드 서비스)기반 서비스)
                - Figma(피그마), Adobe XD, Sketch, Miro
            - `css selector` : JS에서 화면 동적 처리시 유용하게 사용, 데이터 수집 필수값,
        - `javascript`
            - 문법 난이도
              - 초/중 : js(자유도 !!, 오류상황 발생할 수 있음, 최종코드)
              - 중/고 : ts(타입을 강제 부여 오류발생 방지, 구조적 문법 적용 생산성 향상,  유지보수, 협업등에 집중)
            - 사용자와 브라우저(프런트가 보이는 s/w)에 표현된 프런트엔드 화면간 `인터렉션(상호작용)`
              - 이벤트, 통신, 동적화면구성,..
            - `js를 통해서 대시보드 인터렉티브하게 구성 목표`
## 백엔드
  - **프런트엔드 화면 구성에 필요한 서비스, 비즈니스로직, 디비쿼리등 업무 수행, 프럼포트화면에 결과를 전송**
  - 프런트엔드 파트에서 만들어지는 화면을 동적 구성하여 제공, 데이터 제공하는 역할
  - 언어/프레임웍
      - java - springboot (oracle 베이스)
        - servlet/jsp -> ejb -> spring -> springboot
        - 국내 기준 전자정부프레임웍 표준 백엔드 서비스
      - c# - .net (MS)
        - asp -> .net
      - php - php (apache + php + MYSQL :리눅스 )
      - javascript/typescript - nodejs(구글 2000전후 검색엔진 - 2005 구글지도(ajax 개발) - 2008전후 크롬브라우저(v8엔진 기반) - 2009전후 nodejs 탄생(구글x, v8엔진기반)
        - 프런트부터 백엔드까지 단일 언어(js를 사용) 개발 가능해짐.
      - `python - flask, django, fastapi`
        - 빅데이터분석, 데이터처리, ai등의 주력 언어 파이썬임 -> ai시대에 웹서비스까지 단일언어로 구성 가능 조합 (node -> flask, django, fastapi) 흐름이 등장, fastapi는 LLM과 성능적 퍼포먼스로 각광을 받고있음.
      - ..
  - 데이터베이스
  - mysql
# Javascript
  - 특징
    - 세계 top 10(선호도 높은) 언어 포합됨
      - python도 포함됨
    - **SPA(Single Page Application) 개발시 주력언어**
      - 1개의 페이지에서 클릭등 이벤트를 통해 다른 화면이 나올때 기존 내용을 지우고 새로 랜더링 -> 화면 껌벅임( 주소창 옆에 x 표기 -> 없음)
      - Angular - 구글
      - react(웹) - 메타 (1위) / 인스타그램, 페이스북(앱:react-native)
      - vue - 커뮤니티 (2위)
      - ...
    - 참고
      - 화면을 만드는 중심축 (브라우저에서 보이는 화면(html, css, js)을 어디서 생성하는가)
        - SSR : Server Side Rendering : 백엔드 (전통적인 방법)
        - `CSR` : Client Side Rendering : 프런트엔드 (2015년 이후 비중 확장)
          - react, vue, ... => SPA 방식
          - 백엔드는 API만 개발(미들웨어, restFul 만 개발) -> fastapi
        - ...

  - History
    - 2005년 구글 지도이후 js, ajax는 프런트엔드의 핵심 기술로 정립
    - 2009~10 : `nodejs` 등장으로 js는 백엔드 분야로 확장
    - 현재
      - 프런트엔드, 백엔드
      - 웹, 앱, 데스크톱 app 모두 개발 가능

  - 버전
    - 관리 : `ECMA` Script (JS 공식명칭)
      - www.w3shools.com
        - HTML, CSS, JS등 표준 안내, 학습 제공
    - 2009 : `ES5`, ECMAScript 5 표준의 기본
      - 모든 브라우저에 공통으로 적용
    - 2015 : ES6, ECAMScript 2015, ECAM2015
      - 현재 표준의 기본형태. `ES Next`
      - 현재 사용하는 대부분의 추가 문법들이 이때 적립됨
    - 이후 : 매년 갱신(문법)

  - 구동 형식 특징
    - 최신문법 적용 -> **babel** -> ES Next or ES5로 변환하여 구동
    - babel : 최신 코드를 호환 코드로 전환
    - LLM이 만드는 코드 -> ES Next(ES6) or ES5
      - **현재 표준은 ES6(ES Next)**

  - typescript
    - ES5 공부 => ES6 공부 => TS 공부
    - Ts 구동( trans compile을 통해 js가 됨 )
      - TS => ES6(ES Next) 변환 구동 => ES5 변환구동
    - javascript + type + 약간의 문법
# 개발환경
  - IDE (개발 통합 환경)
    - vs code 사용
      - https://code.visualstudio.com/
    - ... (어떤 툴이던 가능)
  - **nodejs 설치**
    - js를 프로그램적으로 개발하기 위해 설치
    - node 기반
      - js 문법 습득등 단독 구동 가능
      - 설치
        - os단 직접 설치
          - https://nodejs.org/ko
        - docker의 컨테이너로 설치

  - nodejs 미사용 js 구동
    - 브라우저의 개발자모드 > 콘솔 화면 직접 구동
  - 도커에 컨테이너로 node.js 설치
    - 호스트PC의 ~projects\node 와 컨테이너의 /home/js 경로가 서로 공유하여 파일(*.JS)이 위치됨
  ```
    docker run --name node -p 3000:3000 -itd -v C:\Users\Dell3571\Desktop\projects\node:/home/js node
  ```

  ```
  # 호스트ps
  C:\Users\Dell5371>docker exec -it node bash
  root@86c329e55501:/#
  root@86c329e55501:/# node -v
  v25.0.0
  root@86c329e55501:/# node
  Welcome to Node.js v25.0.0.
  Type ".help" for more information.
  > console.log("helloworld");
  helloworld
  undefined
  >
  (To exit, press Ctrl+C again or Ctrl+D or type .exit)
  >
  root@86c329e55501:/# exit
  exit

  C:\Users\Dell5371>
  ```
  - VSCODE 구동
    - dev containers 설치
    - F1 (+Fn) or Ctrl + Shift + p 실행
      - 명령 팔레트 구동
      - dev containers:Attach to Running Container... 실행
      - 구동중인 컨테이너 목록 표현
        ```
          - mysql
          - node   <= 선택
        ```
      - 새창(vs code) 오픈 (최초)
        - 왼쪽 메뉴 explorer 오픈
        - open folder
          - /root/ => /home/js 선택 => ok
  - 결론
    - node는 컨테이너로 존재
      - 구동 후 사용
    - vscode를 통해서 간편하게 컨테이너에 존재하는 소스코드(혹은 직접 작성하는코드)를 개발, 실행 가능함.
    - 최종 결과물 `~/projects/node/~` 하위에 공유됨(실시간) <- 호스트 OS(PC, 윈도우, 맥)
# 목차
- 변수, 주석, .
- 문자열
- 연산자
- 형변환
- 흐름제어
- 함수
- 배열
- 클레스, 객체 <-> json 대응
- 주요 최신문법(ES6 이후)
# 타입
  - Null        -> 값이없다
  - Undefined   -> 정의되어 있지 않다 (JS만 존재)
  - Boolean     -> 참(true), 거짓(false)
  - Number      -> 수치형 (정수, 부동소수, ...)
  - Bight       -> 큰범위의 정수
  - String      -> 문자열
  - Symbol      -> 심볼(JS만 존재)
  - Object      -> 객체형
# 프로그램 언어 용어 정리
  - 표현식
    - expression
    - 값을 생성(회득)하는 코드 단위
    - 수행문을 완성하는 조각, 과정
  - 문장|수행문
    - statement
    - 작업 수행 단위
    - ;으로 끝남(JS|python 생략 가능)
  - 키워드
    - 예약어
    - 키워드를 변수|함수|클레스명에 단독 사용 금지
    - 통상 파랑색으로 표현됨.
  - 식별자:identifier
    - 변수명, 함수명, 클레스명, 모듈명, 속성명,...
    - 이름 짓는 규칙 => 네이밍 컨벤션
    - 카멜 표기법
      - Javascript, Java,...
      - 시작문자
        - 문자(a-z, A-Z, 각국문자), $(달러기호), 언더스코어(_)
      - 두번째 문자
        - 숫자(0-9)
      - 대소문자 구분
      - 클레스명은 첫글자 대문자(관습)
      - 이어지는 단어 첫글자는 대문자, 대부분 소문자
      - ex)
        _name, $age, Person, ...