# 실습 index.html을 읽어서 url / <= 홈페이지 요청시 출력하도록 구성하시오

from fastapi import FastAPI, Request
from fastapi.templating import Jinja2Templates
from fastapi.staticfiles import StaticFiles
# __init__.py는 곧 패키지를 의미함
#from db import demo_select_car_mart, select_order_by_model
from db import *

app = FastAPI()
templates = Jinja2Templates(directory="templates")
app.mount(
    "/static"
    ,StaticFiles(directory="static")
    ,name="static"
)

@app.get("/")
def home(req : Request):    
    return templates.TemplateResponse("index.html", 
                                      {"request":req,
                                       "brand_name":"대시보드",
                                       "user_profile":{
                                           "name":"guest",
                                           "img":"avatar2.png"
                                       }
                                       
                                       } )

# 게시판 메인 페이지 (car_mart 데이터 출력(상위 10개만))
# 요구사항 1 -> 게시판 형태로 데이터 조회및 테이블 구성
# 요구사항 2 -> 특정 페이지를 요청, 페이지당 개수 요청 -> 이에 맞춰서 데이터 전달하여 테이블 구성
#           -> 매개변수 기본값 부여, 쿼리 매개변수, GET 방식 전달
# http://127.0.0.1:8000/sales/board/?pno=1&pcnt=10
@app.get("/sales/board/")
#def board(req : Request):
def board(req : Request, pno : int = 1 , pcnt : int = 10):
    # 쿼리 매개변수값 확인 -> 해당 데이터는 쿼리에 영향을 줘야함 -> 쿼리 처리 함수에 전달
    print( pno, pcnt )
    # db접속 -> car_mart 뷰를 조회 -> 결과 획득
    rows = demo_select_car_mart( pno, pcnt )
    if not rows: # 결과 없음
        rows = []
    # -> html 구성시 전달 -> html 동적구성(html에서 작성) -> 응답
    return templates.TemplateResponse("/pages/sales_board.html",
                                    {   "request":req,
                                        "brand_name":"대시보드",
                                        "user_profile":{
                                           "name":"guest",
                                           "img":"avatar2.png"
                                        },
                                        "sales":rows # [] or [ {...}, .. ]
                                    } )


# api 개발 샘플
# 클라이언트가 검색어(모델로만)를 입력하여 검색 요청에 대한 처리, post
@app.post("/sales/search/")
def search( data:dict ):
    # 검색 결과(디비쿼리후)만 돌려준다 -> 화면 x -> dict or [ dict ] -> json으로 전달    
    # 더미 데이터 응답
    return { "results":select_order_by_model( data.get('query') ) }


# 상세 페이지로 이동!! -> get방식 + 경로 매개변수 활용(주문번호 전달)
# http://127.0.0.1:8000/sales/detail/2006084
@app.get('/sales/detail/{order_no}')
def read_data(req:Request, order_no:str):
    # 해당 주문번호에 일치되는 정보를 획득 => DB 쿼리 : select_order_detail( no )
    # 해당 주문 상세보기 화면(html) 응답
    return templates.TemplateResponse("/pages/sales_detail.html", {   
        "request":req,
        "brand_name":"대시보드",
        "user_profile":{
            "name":"guest",
            "img":"avatar2.png"
        },
        "order":select_order_detail( order_no )

    })