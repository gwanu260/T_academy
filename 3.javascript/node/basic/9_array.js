/**
 * 배열(파이썬의 리스트 유사), JS에서 가장 중요한 자료구조
 *  - 서버와 통신결과 => json() => {}
 *      - 내용중 반복적 결과 => 배열로 표현 []
 */

// 1. 배열 정의
let arr = [10, 20, 30, 40, 50]; // 배열이 생성되면서 값 세팅된다 => 정적 생성
console.log( arr, typeof arr );
// 2. 특정 멤버값 추출 => 인덱싱
console.log( arr[ 1 ], arr[ -1 ] ); // 변수[ 인덱스 ], 역방향 인덱스 x
// 3. 배열길이
console.log( arr.length );
// 4. for loop 활용
for (let index = 0; index < arr.length; index++) {
    console.log( arr[index] );
}
for (const index in arr) {
    console.log( arr[index]); // 순서대로 멤버의 인덱스 추출 -> 인덱싱 처리
}
// 6. for of
for (const element of arr) {
    console.log( element ); // 순서대로 멤버가 추출
}

// 7. (*)foreach 사용가능(배열이므로)
// 멤버들을 하나씩 꺼내서 콜백함수에 넣어서 호출
// -> 파이썬 람다가 콜백에서 넣어서 작동하는것과 유사
arr.forEach( function (value, index) {
    console.log( value, index) ;
} )
arr.forEach( (value, index) => {
    console.log( value, index );
} )


// 8. foreach 주용도 예시
// 8-1. map()
//    배열의 멤버들에 하나씩 접근해서 값을 3배로 확장하여 다시 배열로 구성한다?
//    파이썬의 map(), pandas의 apply(), JS는 map()
//    함수의 형태가 인자를 3개 가져 필요한것만 앞에서부터 순서대로 받을 수 있다
function mul3( value ) {
     return value*3; // 원데이터를 3배 증가시킴
}
let arr3 = arr.map( mul3 ); // 전처리(api 받은 데이터를 가공처리해서 반환때 사용)
console.log( arr3 );

// 실습, mul3를 화살표 함수로 변경하여 바로 콘솔출력
console.log( arr.map( v => v*3 ) );

// 8-2. filter() -> 특정멤버 -> 조건식 -> true면 포함, 아니면 배제
// arr에서 30이상(>=) 데이터만 추출하여 배열로 회득
console.log( arr.filter( v => v>=30) );
// 실습 바로 위에 코드에서 화살표함수를 표준함수로 변경하여 동일한 결과로 출력하시오
function myFilter( v ) {
    if(v >= 30) {
        return true;
    }
    return false;
}
console.log( arr.filter( myFilter ) );

function myFilter2( v ) {
    // 함수의 결론이  true or false 라면 조건식을 바로 반환하면 간단하게 표현됨
    return v >= 30; // true, false
}
console.log( arr.filter( myFilter2 ) );


// 기타 배열의 멤버 함수들은 차후 체크(필요시)