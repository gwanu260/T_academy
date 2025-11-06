/**
 * 형변환
 *  - 타입 변환
 *  - 종류
 *      - 명시적
 *          - 해당 변수를 대놓고 특정 타입으로 바꾼다라는 표기 방식
 *          - String( 변수 ), Number( 변수 ),...
 *          - 정보손실이 발생될 수 있음.
 *      - 암묵적
 *          - 통상 수치형 -> 수치형 => 메모리공간 절약 효과
 *          - 정보 손실 발생되지 않게 유의
 */

// 1. 명시적
let a = 10
console.log(a, typeof a);
// 1-1. 결과물이 수치 -> 문자열
console.log( String(a), typeof String(a) );
console.log( String(false), typeof String(a) );

// 1-2. 결과물이 수치형
console.log( Number("1"), typeof Number("1") );
console.log( Number("1 "), typeof Number("1 ") );
console.log( Number(" 1 "), typeof Number(" 1 ") ); // 공백제거 해줌
console.log( Number("AB"), typeof Number("AB") ); // Not Number (NaN)
// 불린형 변환
console.log( Boolean('1'), Boolean('-1'), Boolean(NaN), Boolean(null), Boolean(undefined) );

// 2. 암묵적 형변환
console.log( 1 + 2 );
// 더하는 대상중 하나라도 문자열이 존재하면, 결과는 문자열임
console.log( "1" + 2 );
console.log( 1 + "2" );
console.log( "1" + "2" );
