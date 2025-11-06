/**
 * 스프레드 연산자
 *  - ... 변수명(배열|객체)
 *  - deep copy 역할(깊은 카피)
 */
// 1. 배열의 깊은 카피 -> 병합시 사용
const arr1 = [1,2,3];
const arr2 = [4,5,6];
// 의도 [ 4, 5, 6, 1, 2, 3 ] 이렇게 배열 구성하고 싶다.
console.log( ... arr2, ... arr1 ); // 많이 사용함. 원본에 영향 x

// 2. 배열 구조 분해시 나머지 연산(나머지 멤버 일괄적으로 배열로 받기)
let [ a, ...rest ] = [1,2,3,4,5];
console.log( a, rest );

// 3. 문자열 + 스프레드 연산다 => 문자열 분해가 됨
console.log( [..."helloworld"] );

// 4. 객체 병합 (서로 다른 구조를 가지 n개의 객체(데이터)를 한개의 데이터 통합)
const s1 = { score:100, subject:'파이썬' };
const s2 = { score:90, age:50 };
console.log( { ...s1, ...s2 } ); // 같은 멤버인 경우 나중값이 최종값이 됨
console.log( { ...s2, ...s1 } );

// 4-1. 깊은 복사 확인
const s3 = { ...s1 }; // 원본 딥(?) 카피
s3.score = 101;
console.log( s1, s3 ); // 상호 다른 값 유지 -> 딥카피 ok

// 5. 함수의 인자로 스프레드 연산 사용 - 배열
function test(x, y, z) {
    console.log( x, y, z)
}
// arr1의 멤버들을 x, y, z에 각각 넣어서 호출한다면?
// 배열의 멤버가 더 커도 순서대로 배열 비구조화 할당 발생함
test( ...arr1 );
let arr4 =( [ ...arr1, ...arr2 ] );
test( ...arr4 );

// (*)6. 함수의 매개변수로 스프레드 연산 사용 - 객체
function test2( {score, subject} ) { // 객체 비구조화할당을 매개변수에 사용
    console.log( score, subject );
}
test2( s1 );

function test3( a, ...data ) { // 가변인자
    console.log( a, data );
}
test3(1);
test3(1,2);
test3(1,2,3);


