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


from pydantic import Field
# 필드 제약 조건 => Field 클래스 활용
'''
- default   : 기본값
- alias     : JSON 구성시 파이썬 변수와 다른 이름으로 설정하고 싶다면
- title     : 문서화 구성시 주로 사용
- description : 필드의 설명(해당 데이터의) 문서화에서 확인
- min_length or max_length : 최소, 최대 길이 제약
- gt(greater than), lt(less than) : 숫자 크기 제약
- regex     : 정규식 -> 암호, 이메일등 형식을 잡을때
'''
class ItemDetail(BaseModel):
      # ... 명시하지 않는 것은 Field 기본값을 따라간다
      name  : str   = Field(..., min_length=4, max_length=16)
      price : int   = Field(..., gt=0, description="양수만 사용 가능")
      tax   : float = Field(..., alias="kor_tax")

'''
# "type": "missing", 에러 => kor_tax 누락
{
    "name":"맥북프로",
    "price":2700000,
    "tax":0.1
}
# kor_tax로 변경해서 전송
{
    "name":"맥북프로",
    "price":2700000,
    "kor_tax":0.1
}
# 가격을 0으로 조정 -> greater_than 오류 -> 422 -> 0 이상 입력
{
    "name":"맥북프로",
    "price":0,
    "kor_tax":0.1
}
'''

@app.post("/test/itemdetail/")
def insert_item( item : ItemDetail ):
    return { "전송결과": item.dict() }

# TODO Pydantic 남은 파트 : 중첩, 리스트, 제네릭 표기 => T => 차후 진행