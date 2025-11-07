'''
- mysql을 이용한 mysql 데이터베이스 연동 테스트, 필요함 모듈 구성
'''
import pymysql.cursors

# results : None, [], [ {데이터},... ]
def demo_select_car_mart( pno=1, pcnt=10 ):
    results = None # 값이 없다
    
    try:
        # 1. 디비연결
        connection = pymysql.connect(host='127.0.0.1',
                                    user='root',
                                    password='1234',
                                    database='t1',
                                    cursorclass=pymysql.cursors.DictCursor)
        print('연결')

        with connection:
            # 2. 쿼리 작업 -> 클라이언트가 요청한 데이터를 질의하여 획득
            with connection.cursor() as cursor: # 커서로 쿼리 수행
                    # 쿼리문 준비 -> 주문일 기준 최신순 조정,
                    # 페이징 => LIMIT (pno-1), pcnt
                    sql = '''
                        SELECT * 
                        from car_mart
                        order by  order_date desc
                        limit %s, %s
                        ;
                    '''
                    cursor.execute(sql, (pno-1, pcnt)) # 쿼리문 실행
                    # 정상이면 results에 값이 세팅된다
                    results = cursor.fetchall() # .fetchone() # 모든 결과가져오기
        
    except Exception as e:
        # 로그수집(생략)
        print('오류 발생', e)

    # 조회 결과 반환
    #print( results )
    return results

    # # 3. 연결종료
    # if connection:
    #     print('연결종료')
    #     connection.close()

# 입력 : 모델명 검색어 
# 처리 : 디비쿼리 수행(sql)
# 출력 : 쿼리 결과 출력 => [ {}, {}, ... ]
def select_order_by_model( keyword='' ):
    if not keyword: # 검색어(키워드)가 없다면
        return [] # or None
    
    results = None    
    try:
        # 1. 디비연결 -> 반복적인 코드가 매번 발생됨 -> 차후 개선
        connection = pymysql.connect(host='127.0.0.1',
                                    user='root',
                                    password='1234',
                                    database='t1',
                                    # DictCursor => [ {}, {}, ..] ,컬럼순서무관
                                    cursorclass=pymysql.cursors.DictCursor)
        with connection:            
            with connection.cursor() as cursor:                    
                    sql = f'''
                        SELECT 
                            order_no, mem_no, store_cd, quantity,
                            price, model, join_date 
                        from car_mart
                        where model like '%{keyword}%'
                        order by order_date desc
                        limit 10
                        ;
                    '''
                    cursor.execute(sql)                    
                    results = cursor.fetchall()        
    except Exception as e:
        print('오류 발생', e)    
    return results


# 입력 : 주문번호
# 처리 : 주문번호를 기반으로 주문서 검색(모든 컬럼 획득) -> sql 실행
# 출력 : 주문서 정보 => { .. } or None
def select_order_detail( no='' ):
    if not no: # 주문번호가 없다면
        return {} # or None    
    result = None
    try:
        connection = pymysql.connect(host='127.0.0.1',
                                    user='root',
                                    password='1234',
                                    database='t1',
                                    # DictCursor => [ {}, {}, ..] ,컬럼순서무관
                                    cursorclass=pymysql.cursors.DictCursor)
        with connection:            
            with connection.cursor() as cursor:
                    sql = '''
                        SELECT *
                        from car_mart
                        where order_no=%s
                        ;
                    '''
                    cursor.execute(sql, (no))
                    result = cursor.fetchone()        
    except Exception as e:
        print('오류 발생', e)    
    return result



if __name__=='__main__':
    # 데이터베이스 연동 테스트 코드, 디비개발자만 테스트 사용
    # 웹에서 연동시에는 미작동
    if False:
        rows = demo_select_car_mart()
        print( len(rows) )
        print( select_order_by_model("bmw") )
    print( select_order_detail('2006069'), select_order_detail('') )
    pass