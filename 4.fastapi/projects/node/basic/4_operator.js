/**
 * 연산자
 *  - 대부분 다른 언어와 유사함
 */
// 1. 사칙연산, + - * / => 의도대로 작동 여부
let x = 10;
let y = 6;
console.log( `${ x } + ${ y } = ${ x+y }` );
console.log( `${ x } - ${ y } = ${ x-y }` );
console.log( `${ x } * ${ y } = ${ x*y }` );
console.log( `${ x } / ${ y } = ${ x/y }` );

// 2. 문자열 더하기, 하나만 문자열이면 어떤 타입(주로 수치)도 문자열로 변환돼서 더하기됨
console.log( 'A' + 'B' + 10 );
let t = '' + 10;
console.log( t, typeof t );

// 3. ++, -- <-> 파이썬에는 없음
// ++ => 1더하기, -- => 1빼기 : 단, 증감의 타이밍이 중요함
// ++a, a++은 결과가 다름
let i = 1;
console.log( i, i++, ++i, i ); // 1 1 3 3

// 4. n값 증감 (n이 1이 아닌경우 주로사용)
i += 2;
i = i + 2;
console.log( i );

// 5. 동등연산자 ( == ),
//    일치연산자( === ) -> 실체값 비교(객체의 주소(참조값) 체크 -> 실체(값), 액면)
//    일치연산자는 통상 객체간 비교시, 동등연산자는 같은 타입(수치)의 값들 간 비교시
let x1 = 10;    // number
let x2 = "10";  // string
console.log( typeof x1, typeof x2 );
console.log( x1 == x2, x1 === x2);

// 6. 삼항연산자
// 파이썬 => 변수 = 참일때 값 if 조건식 else 거짓일때 값
// JS    => 조건식 ? 참일때 값(코드) : 거짓일때 값(코드); => ?:;
let coffeeIcePrice =  1800;
coffeeIcePrice > 1800 ? console.log('비쌈') : console.log('적당');