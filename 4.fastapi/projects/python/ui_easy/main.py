# pip install python-multipart
# TODO Redirect 3 status 모듈 가져오기
from fastapi import FastAPI, Request, Form, status
from fastapi.templating import Jinja2Templates
from fastapi.staticfiles import StaticFiles
# TODO Redirect 1 포워딩을 위한 클래스 
from fastapi.responses import RedirectResponse
# TODO SESSION 1 세션을 위한 클래스
from starlette.middleware.sessions import SessionMiddleware
from db import *

app = FastAPI()
templates = Jinja2Templates(directory="templates")
app.mount(
    "/static"
    ,StaticFiles(directory="static")
    ,name="static"
)
# TODO SESSION 2 미들웨어 등록, 시크릿키(세션의 기본재료) 등록, 쿠키만료시간등
#      시크릿키(세션의 기본재료) => 코드내 삽입 X -> 환경변수 설정 및 가져오기(개선)
app.add_middleware(
    SessionMiddleware,
    secret_key='asdjfl;kasjdjakljfkljaslkdfjalsk;', # 추후 외부에서 관리
    session_cookie='my_session', # 세션 쿠키의 이름
    max_age=1*60*60*24 # 현재는 1일 적용
)

@app.get("/")
#@app.post("/") # 특정 함수에 get, post를 모두 등록할수 있다
def home(req : Request):
    # TODO 세션체크 1 -> 모든 페이지에 해당 체크 코드를 사입해야 하는가?
    # 향후 모든 요청이 통과하는 지점에 세션 체크를 삽입 -> 모든 요청에 대한 체크 OK
    if not req.session.get('user'): # 세션이 없다면 -> 로그인으로 강제이동
        return RedirectResponse(url='/users/login')

    # req.method : "GET", "POST", ... -> 1개의 URL에서 method별 분기 가능
    print('홈페이지 get', req.method)
    # html 파일을 읽어서 + 데이터가 있다면 전달 => 동적구성 => html 텍스트 응답  
    return templates.TemplateResponse("index.html", {"request":req} )


# /sales/board/ 해당주소로 get방식 요청이 왔을때 처리
# /sales/board/ 해당주소로 post방식 요청 하면 -> 준비 않되어 있음 -> Method Not Allowed (405)
@app.get("/sales/board/")
def board(req : Request, pno : int = 1 , pcnt : int = 10):
    rows = demo_select_car_mart( pno, pcnt )
    return templates.TemplateResponse("sales_board.html",{"request":req,"sales":rows} )

# /sales/search/ => /sales/board/ 변경 : 
@app.post("/sales/board/")
def search(req : Request,  query: str = Form(...) ):
    rows =  select_order_by_model( query )
    print(rows)
    return templates.TemplateResponse("sales_board.html",{"request":req,"sales":rows} )

@app.get('/sales/detail/{order_no}')
def read_data(req:Request, order_no:str):
    #res = select_order_detail( order_no ) 
    #print( type(res), res)
    # select_order_detail() 결과값 => dict 임
    return templates.TemplateResponse("sales_detail.html", {   
        "request":req
        ,"order":select_order_detail( order_no ) 
    })

# 404 not found => 해당 주소로 처리할 페이지가 없다 => url등록
@app.get("/users/login/")
def login(req:Request):
    # login.html 읽어서 화면 출력
    # return {'page':'login'}
    return templates.TemplateResponse("login.html", {"request":req})

# 로그인 요청 처리하는 파트
@app.post('/users/login/')
def login(req:Request, uid:str = Form(...), upw:str = Form(...)):
    # 1. 사용자 ID, PW 획득
    print( uid, upw )
    # 2. 데이터베이스 질의 -> 회원인지 체크 -> 맞으면 회원정보(필요한만큼) 전달
    # 2. 일단 기능성 구성 -> 디비없이 고정값으로 로그인 처리 -> 임시코드
    if uid=='admin'and upw == '1234':
        # 2-2. 회원이면
        print('회원임')
        # TODO SESSION 3 세션생성 
        #       -> `세션` 생성(로그인한 유저의 특정정보를 저장(서버측메모리,레디스(nosql)))
        req.session['user'] = 'admin' # 임시 부여
        # TODO Redirect 2 홈페이지로 이동
        # 2-3. 서비스 메인 페이지(첫화면)/특정 페이지로 포워딩 `포워딩`
        # 상태코드 307 : 임시 주소가 변경되었다
        #               -> `원래 요청시 사용했던 메소드 그대로` 새 주소로 요청해라
        # 상태코드 303 : 최초 요청인 post 요청 처리 잘되었다.
        #               -> 이제 get으로 새로운 주소로 요청해라(결과를 확인하기위해)
        return RedirectResponse(url='/',
                                status_code=status.HTTP_303_SEE_OTHER)
        pass
    else:
        # 2-1. 회원 아니면 컷 -> 경고창 -> 확인 -> 이전 페이지로 이동(로그인)
        return templates.TemplateResponse('loginFail.html', {"request":req} )
        pass

# TODO LOGOUT 1 로그아웃 처리
@app.get("/users/logout/")
def login(req:Request):
    # 1. 세션 여부 확인
    if req.session.get('user'):
        # 1-1. 존재하면 -> 세션 종료
        req.session.clear() # 쿠키 삭제 -> 접속자 정보를 제거

    # 1-2. 여기서는 로그인 화면으로 이동 -> get이므로 307 기본상태값 유지
    # 1-3. 없으면 -> 잘못된 접근 경고 -> 로그인|이동
    return RedirectResponse(url='/users/login')

   