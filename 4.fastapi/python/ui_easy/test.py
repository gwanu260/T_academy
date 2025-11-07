from fastapi import FastAPI
# TODO Pydantic 1. 모듈가져오기
# BaseModel : 클래스 단위로 데이터를 관리할 때 가장 근본(기본)이 되는 클래스
#             따라서 무조건 통신단위에 필요한 클래스는 BaseModel 상속받고 정의
from pydantic import BaseModel

app = FastAPI()

# TODO Pydantic 2. 통신에 필요한 데이터를 정의한 클래스 구현
class Item(BaseModel):
        # 커스텀(필요한 데이터) -> 데이터의 유효성 체크할 수 있다(타입, 결측)
        name    : str
        price   : int
        is_rich : bool = None

# TODO Pydantic 3. 클라이언트가 보내는 데이터 샘플
#                  타입이 다른 경우 422 에러 발생 -> 데이터 유효성중 타입체크
'''
# 정상
{
    "name":"guest",
    "price":1800,
    "is_rich":true
}

# 타입을 틀리게 구성
{
    "name":"guest",
    "price":18.001,
    "is_rich":true
}

# 데이터 누락 -> missing
{
    "name":"guest",
    "is_rich":true
}

# 기본값 있는(옵션) 데이터 누락 -> 정상
{
    "name":"guest",
    "price":1800
}
'''

# TODO Pydantic 4. 라우팅에 전달된 데이터를 받는
#                  그릇으로 BaseModel 상속받은 클래스 세팅
@app.post("/test/item/")
def insert_item( item : Item ):
    return { "전송결과": item.dict() } # 줄이 가있는 함수는 향후 삭제될 것이다

# 옵션 처리
from typing import Optional
'''
변수 타입 -> 에너테이션
- int
- float
- bool
- str
- datetime.datetime
- Optional : 선택적 필드라는 의미, NOne도 허용
'''
class ItemEx(BaseModel):
        name    : str
        price   : int
        tax     : float = 0.1
        desc    : Optional[ str ] = None

'''
{
    "name":"맥북프로",
    "price":2700000,
    "desc":"충전 케이블 옵션"
}
'''
@app.post("/test/itemex/")
def insert_item( item : ItemEx ):
    return { "전송결과": item.dict() }