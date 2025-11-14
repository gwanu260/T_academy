# CICD 테스트용 WAS
    - 간단한 홈페이지

# 구조 (윈:tree /f, 맥:tree (brew install tree))
└─ templates      : html 저장 공간
    └─ index.html : 홈페이지
└─ .env         : 환경설정 파일, 주로 키, 설정값 지정
                  github 등록 x, cicd시 동적으로 
                  gitaction(제품)을 통해서 생성됨.
└─ .gitignore   : github 에 등록시 배제될 파일/디렉토리 지정
└─ main.py      : 서비스 엔트리 파일 (시작점)
└─ requitements.txt : 필요한 설치 패키지 목록