'''
- index.html등 html 파일을 읽어서 클라이언트에게 전송 -> 요청한 페이지 화면 표시
- 대시보드 확인차
    - 행동 : http://127.0.0.1:8000 브라우저 가동하여 주소창에 넣어서 엔터
'''
from fastapi import FastAPI, Request
# 1. 템플릿 관련 모듈 과져옴
from fastapi.templating import Jinja2Templates
# 3. 정적 파일 관련 처리 모듈 -> 별도의 라우팅이 필요 x(기본값)
from fastapi.staticfiles import StaticFiles

app = FastAPI()
# 2. Jinja2 Templates 객체 생성
# directory="tmplates" : html이 존재하는 위치를 지정
templates = Jinja2Templates(directory="templates")
# 4. 정적 파일이 위치한 경로 등록, url 사용시 접근할 이름 지정등등 설정
app.mount(
    "/static"       # 클라이언트가 접근할 URL사의 경로명, 필요시 변경가능
    ,StaticFiles(directory="static")   # 실제 로컬상 경로
    ,name="static"  # fastapi에서 내부에서 사용하는 이름
)


# 반드시 Request 객체를 함수의 인자로 전달하여
# TemplateResponse의 인자로 아래처럼 전달하면 html을 처리해준다
@app.get("/") 
def home(req : Request):
    return templates.TemplateResponse("index.html",
                                      {"request":req})

# 데이터를 html에 전달하여 동적으로 html 구성(수정)
# html 파일이 없다면(혹은 오타) => rais TemplateNotFound(template) 발생
# html 파일 + 데이터(동적 획득) => jinja2 엔진 믹스(표현식, 문법) => 새로운 html 생성(동적 생성)
# 템플릿 엔진은 디자이너가 아주 쉽게 간다한 프로그래밍 기법을 사용하여 동적으로 HTML을 구성하게 해주는 도구
@app.get("/data")
def home(req : Request):
    return templates.TemplateResponse("index_data.html",
                    {"request":req, "mydata":"월요일aA1!"})

# html 내부에 다른 html을 포함시킨다(include) 
# => 거대한 html을 쪼개서 관리(파트별로 개발/관리), 다시 조립하여 하나의 화면 구성할 수 있다
# => 공통 모듈 존재 => 공통 모듈을 조립 + 추가 내용 삽입 => 새로운 페이지가 구성 => 생산성 향상
@app.get("/made")
def home(req : Request):
    return templates.TemplateResponse("master.html", {"request":req})