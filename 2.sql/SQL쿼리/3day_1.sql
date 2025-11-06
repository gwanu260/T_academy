SELECT CAST(REPLACE('4,000', ',', '') AS UNSIGNED

-- car_product 이해
DESC car_product;
-- 브랜드, 모델, 타입 확인
SELECT DISTINCT pdt.brand, `TYPE`, model
FROM t1.car_product AS pdt
;
--가격대한 데이터/타입 보정
-- 샘플값 
SELECT
	CAST(REPLACE(price, ',', '') AS UNSIGNED) AS 주문액
	FROM t1.car_product
	LIMIT 5 # 상위값 5개 확인 => DataFrame.head()
;
-- 집계
SELECT
	pdt.model, # 자동차 모델명
	SUM( CAST(REPLACE(price, ',', '') AS UNSIGNED) )
	AS 주문총액,
	COUNT( price ) AS 주문건수
FROM t1.car_product AS pdt
GROUP BY pdt.model
ORDER BY 주문총액 desc
;
-- car_order 확인
DESC car_orderdetail;

-- car_orderdetail 주문 건수
SELECT COUNT(*)
FROM car_orderdetail
;

-- 요구사항 (리뷰, 쉬는시간)
-- car_orderdetail, car_product를 이용하여
-- 모델명, 주문수, 총주문액, 평균주문액 출력
-- 쿼리문을 작성하시오


