from fastapi import FastAPI, Request, Form, status
from fastapi.templating import Jinja2Templates
from fastapi.staticfiles import StaticFiles
from fastapi.responses import RedirectResponse
from starlette.middleware.sessions import SessionMiddleware
from db import *
# 1. pydantic, typing 추가
from pydantic import BaseModel
from typing import Annotated


app = FastAPI()
templates = Jinja2Templates(directory="templates")
app.mount(
    "/static"
    ,StaticFiles(directory="static")
    ,name="static"
)
app.add_middleware(
    SessionMiddleware,
    secret_key='wsldfjwefjo823rlkwefnlkefnles', # 추후 외부에서 관리
    session_cookie='my_session', # 세션 쿠키의 이름
    max_age=1*60*60*24 # 현재는 1일 적용, 초단위
)

# 2. pydantic 모델 정의(클래스단위, 통신시 주고 받는 데이터 형태)
# HTML 폼전송으로 전달되는 필드 uid, upw의 타입과 구조를 정의
# 길이, 반드시 들어간 값 형태 등등 모두 생략 => Field로 추후적용
class LoginForm(BaseModel): # 타입, 필수옵선임을 설정
    uid : str
    upw : str

@app.get("/")

def home(req : Request):
    # TODO 세션체크 1 -> 모든 페이지에 해당 체크 코드를 삽입해야 하는가?
    # 향후 모든 요청이 통과하는 지점에 세션 체크를 삽입 -> 모든 요청에 대한 체크 OK
    if not req.session.get('user'): # 세션이 없다면 -> 로그인으로 강제이동
        return RedirectResponse(url='/users/login') 
    
    # req.method : "GET", "POST", ... -> 1개의 URL에서 method별 분기 가능
    print('홈페이지 get', req.method)   
    # html 파일을 읽어서 + 데이터가 있다면 전달 => 동적구성 => html 텍스트 응답  
    return templates.TemplateResponse("index.html", {"request":req} )

@app.get("/sales/board/")
def board(req : Request, pno : int = 1 , pcnt : int = 10):
    rows = demo_select_car_mart( pno, pcnt )
    return templates.TemplateResponse("sales_board.html",{"request":req,"sales":rows} )


@app.post("/sales/board/")
def search(req : Request,  query: str = Form(...) ):
    rows =  select_order_by_model( query )
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

@app.get('/users/login/')
def login(req:Request):
    # login.html 읽어서 화면 출력
    # return {'page':'로그인'}
    return templates.TemplateResponse("login.html", {"request":req} )

# 3. pydantic 모델을 이용한 로그인 처리
@app.post('/users/login/')
def login(req:Request, form_data: Annotated[ LoginForm, Form() ]):
    # 리뷰때 Field 옵션 부여하여 길이제약 드읃ㅇ 테스트
    uid = form_data.uid
    upw = form_data.upw

    print( uid, upw )
    if uid == 'admin' and upw == '1234':
        # 2-2. 회원이면 
        print('회원임')
        # TODO SESSION 3 세션생성
        #      -> `세션` 생성(로그인한 유저의 특정정보를 저장(서버측메모리,레디스(nosql)))
        req.session['user'] = 'admin' # 임시 부여
        # TODO Redirect 2 홈페이지로 이동
        # 2-3. 서비스 메인 페이지(첫화면)/특정 페이지로 `포워딩`
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
        
@app.get("/users/logout")
def home(req : Request):
    # 1. 세션 여부 확인
    if req.session.get('user'):
        # 1-1. 존재하면 -> 세션 종료
        req.session.clear() # 쿠키 삭제 -> 접속자 정보를 제거
    
    # 1-2. 여기서는 로그인 화면으로 이동 -> get이므로 307 기본상태값 유지
    # 1-3. 없으면 -> 잘못된 접근 경고 -> 로그인 이동
    return RedirectResponse(url='/users/login') 
