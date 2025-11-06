'''
- 주제
    - 라우팅 테스트
- 구동
    - uvicorn route_test:app --reload --host=0.0.0.0 --port=8000
- method
    - HTTP 프로토콜상에서 클라이언트가 서버측으로 데이터를 전달하는 방식
        - get, head : 프로토콜의 헤더를 통해 전달
            -> 소량 -> 간단한 키값, 특정값, 유출되도 문제없는 데이터만
            -> 아무것도 안보내도 됨(기본 get), 링크
        - post, put, ... : 프로토콜의 바디(크기가변)를 통해 전달
            -> 대량 -> 글쓰기, 파일업로드, 보안성
'''
from fastapi import FastAPI

app = FastAPI()

# 기본 라우팅 => get 방식으로 서버측에 요청
@app.get("/") 
def home():

    return { "msg":"hello fastapi!!"}

# GET방식 요청 +
# 경로 매개변수(url에 데이터를 심어서 전달)로 데이터를 전달한다
# http://127.0.0.1:8000/items/1a%EA%B0%80!
# http://127.0.0.1:8000/items/1a => 문자열로 전달됨
@app.get("/items/{id}")
def test_path_param( id ):
    return {'id':id}

# 경로 매개변수가 2개 이상이면
# http://127.0.0.1:8000/user/guest/items/p303
# 남은 이슈 => 타입 제한 => 별도주제에서 체크 = 유효성 검사 자동으로 처리됨
@app.get("/user/{uid}/items/{item_id}")
def test_path_param2( uid, item_id ):
    return {'uid':uid, 'item_id':item_id}

# GET 방식 + 쿼리 매개변수(GET 방식 전용)
# url + ? + 키=값&키=값... => 너무 길면 정보손실 발생됨(http 헤더의 크기가 고정)
# http://127.0.0.1:8000/items2/?pno=2&pcnt=20
@app.get("/items2/")
def items2(pno, pcnt):
    # {"pno":"2","pcnt":"20"} 응답 => 모두 문자열로 처리됨
    return {"pno":pno, "pcnt":pcnt}