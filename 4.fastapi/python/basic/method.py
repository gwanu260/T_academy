'''
- http 메소드는 클라이언트가 서버측에게 데이터를 전송하는 방식
    - 데이터는 http 프로토콜의 헤더 혹은 바디를 타고 전송 => 패킷
    - 클라이언트가 서버에게 어떤 동작을 해달라고 요청하는 방식을 정의
    - 종류
        - GET       : 서버로부터 정보를 요청
            - 게시판 목록, 상세보기, 사용자 정보
        - POST      : 데이터를 전송하여 새로운 리소스 생성 요청 -> insert
            - 회원가입, 로그인, 글작성, 검색
            - 챗봇, LLM 관련 프럼프트 => 전송할 데이터 크기!!
        - PUT       : 지정된 리소스를 갱신(업데이트) 요청 -> update
            - 정보수정
        - DELETE    : 지정된 리소스를 삭제 요청 -> delete
            - 회원탈퇴, 글삭제
        API는 위의 뉘앙스나 동작에 준해서 설계
'''
from fastapi import FastAPI
app = FastAPI()

# get 
# 데이터를 특정할수 있는 id를 이용하여 1개 정보만 가져온다
@app.get('/test/{id}')
def read_data(id:int):
    '''
        - 비즈니스 로직 (해당 URL이 업무) -> 특정 id의 책 정보 전송
            - id값을 기준으로 쿼리 수행(예상 시나리오)
            - select * from books where book_id=id
            - 쿼리 결과를 가져와서 -> 전처리(필요시) -> 응답
    '''
    # 더미 데이터 응답
    return {"title":"AI 혁명", "id":id}

# 모든 정보(n개의 정보)를 가져온다
@app.get('/test/')
def read_datas(pno:int = 1, pcnt:int=20):
    '''
        - books 테이블에서 특정 조건이 맞는 데이터 획득->응답
        - select * from books limit (1-1), 20
    '''
    return [ {"title":"AI 혁명", "id":1}, 
             {"title":"AI 반도체 수혜주", "id":2}, 
             {"title":"공부!!", "id":3} 
           ]

# post
# 특정 데이터를 추가(insert)
@app.post('/test/')
def create_data(data:dict):
    '''
        - 데이터 1 or n개 추가
        - insert into () values ();
        - 추가 성공 여부를 반환
        - 요청 데이터
        {
            "title": "hi"
        }
        - 응답
        {
            "status": "ok",
            "msg": "1개의 글이 등록되었습니다.",
            "dict": {
                "title": "hi"
            }
        }
    '''
    return {'status':'ok', "msg":"1개의 글이 등록되었습니다.", 
            "dict":data}

# put
# 특정 id를 고유값으로 가진 데이터를 수정(업데이트, 대체)
@app.put('/test/{id}')
def update_data(id:int, data:dict):    
    '''
        - update ~
        - 데이터 전달 여부만 확인
        - 응답
        {
            "data": {
                "title": "수정된 제목"
            },
            "id": 10
        }
    '''
    return {"data":data, "id":id};

# delete
# 특정 id를 고유값으로 가진 데이터 삭제
@app.delete('/test/{id}')
def delete_data(id:int):
    '''
        - delete from xxx where id=id
        - 삭제가 되었다등 결과 전송하면됨
    '''
    return {"id":id}