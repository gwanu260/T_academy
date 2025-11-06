'''
타입힌트
    - 입력값에 제한을 두는것 => 유효한 값만 받아서 안정적 처리
    - 타입
        - 기본타입
            - int   : 정수
            - float : 부동소수
            - str   : 문자열
            - bool  : 불리언
        - typping 패키지의 컬렉션타입
            - List  : 순서있는 => List[int]
            - Tuple : 순서있는, 수정불가
            - Dict  : 키값 세트
            - Set   : 중복제거
        - typping 패키지의 특수타입
            - None  : 값이 없다
            - Any   : 모든 타입 -> 타입검사 무시
        - typping 패키지의 고급타입 (써드파트)
            - Optional  : 값이 있던지 없던지(None) => Optional[int]:정수 or None
            - Union     : 여러타입 중 하나 => Union[int, str]
            - Callable  : 함수 => Callable[[str, int], int] => 입력(문자열, 정수), 출력 정수
            - Iterable  : 반복 가능한 객체 => Iterable[str]
            - Sequence  : 시퀀스 타입 => Sequence[int]
        - 커스텀 타입 : 사용자가 만든 특정 클래스타입
'''
from fastapi import FastAPI
app = FastAPI()

# 경로 매개변수 + 타입힌트(기본타입)
# http://127.0.0.1:8000/items/100 => OK
# http://127.0.0.1:8000/items/hi  => 에러
# {"detail":[{"type":"int_parsing",
# "loc":["path","id"],"msg":"Input should be a valid integer, 
#  unable to parse string as an integer","input":"hi"}]}
@app.get("/items/{id}")
def test_path_param( id:int ): # 정수만 입력 가능
    return {'id':id}

# 쿼리 매개변수 + 타입힌트 + 기본값
# http://127.0.0.1:8000/items2/
# http://127.0.0.1:8000/items2/?pno=2&pcnt=20
# http://127.0.0.1:8000/items2/?pno=2&pcnt=hi => 에러
@app.get("/items2/")
def items2(pno : int =1, pcnt : int =10):
    # {"pno":"2","pcnt":"20"} 응답 => 모두 문자열로 처리됨
    return {"pno":pno, "pcnt":pcnt}


# 고급기능
from fastapi import Query
from typing import List, Dict

# q라는 매개변수에 값이 세팅됨 
# 기본값은 [] => Query([]) 형태로 표현
# 함수명을 중북되게 사용(테스트), url을 동일하게 정의(경로vs쿼리)
# http://127.0.0.1:8000/items/ 
# => {"q":[]}
# http://127.0.0.1:8000/items/?q=100&q=101&q=102 
# => {"q":[100,101,102]}
# http://127.0.0.1:8000/items/?q=100&q=101&q=hi
@app.get("/items/")
def test_path_param(q : List[int] = Query([])):
    return {'q':q}

# http://127.0.0.1:8000/dict_items
# => {"detail":[{"type":"missing","loc":["body"],
# "msg":"Field required","input":null}]} <= fastapi의 메세지
# 키와 값의 세트로 전달 => dict로 받겟다 => post 방식 전송 적절
# json 형태로 데이터를 전달하겠다 뜻임
# swagger or postman or thunderclient등 툴을 이용하여 테스트 진행
# json 데이터 전송
'''
json 데이터 (무조건 "로 문자열표기, 마지막 멤버는 ,없음)
{
  "python_score": 90,
  "db_score":80
}
'''
@app.post("/dict_items/")
def test_path_param(data : Dict[str, int]):
    return data