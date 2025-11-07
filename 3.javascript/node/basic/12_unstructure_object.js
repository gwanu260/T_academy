/**
 * 객체 구조 분해, 객체 비구조화 할당
 */
const pay = {
    name:'커피',
    price:1800
};
console.log( pay );

// 기존 추출 방식
console.log( pay.name, pay['price'] );

// 개선안(많이 사용함)
// 키워드 { 멤버션수명, .... } = 객체;
let { price, name, nm } = pay;
console.log( price, name, nm); // nm은 없는 멤버 -> undefined

// 원 데이터는 보존됨. 원본 훼손 없음
price = 2000;
console.log( pay.price, price );

const pay2 = {
    name:'커피',
    price:1800,
    detail:{
        카페인:'high',
        cc:350
    }
};
// 요구사항 -> 카페인 함량(레벨)등을 출력하시오 -> 중첩구성시 비구조화 할당
const {detail:{ 카페인 }} = pay2;
console.log( 카페인 );
