/**
 * 조건문
 *  - 조건에 따라 수행되는 코드를 조정
 *  - 문법
 *      - 조건 1개
 *      if (조건식:condition expression) {
 *          [ 수행문(statements) ]
 *      }
 *      - 조건 2개
 *      if (조건식:condition expression) {
 *          [ 수행문(statements) ]
 *      }else{
 *          [ 수행문(statements) ]
 *      }
 *      - 조건이여러개
 *      if ~ else if ~ .... ~ else(or else if) ~
 *      
 *      - switch ~ case
 * 
 *  - 조건식
 *      - 결론 : true or false
 *      - 관련 연산자
 *          - 비교 연산자
 *              - >, <. >=, <=, ==, !=
 *              - ===, !== (JS만 존재)
 *          - 논리 연산자
 *              - A && B (파이썬의 A and B)
 *              - A || B (파이썬의 A or B)
 *              - !A     (파이썬의 not A)
 *          - 기타
 *              - &&=, ||=, ??= : 논리적 할당 연산자
 *              - &, |, ^, ~, <<, >>, >>> : 비트, 쉬프트 연산자
 *              - in : 배열에 데이터가 존재하는지, instance of 객체 타입 체크
 */

// 메가커피 아이스 아메리카노 2000
// 조건 1개
let megacp = 2000
if (megacp > 2000) { // <- 코드블럭
    console.log('구매실패')
}

// 조건 2개 -> 삼항연산자 대체 가능
if (megacp > 2000) {
    console.log('비쌈')
} else {
    console.log('적절')
}

// 조건 3개
let score = 70;
// 90이상 A, 80이상 B, 70이상 C, 60이상 D, F
if (score >= 90) {
    console.log('A')
} else if (score >= 80) {
    console.log('B')
} else if (score >= 70) {
    console.log('C')
} else if (score >= 60) {
    console.log('D')
} else {
    console.log('F')
}

// 삼항연산자, 값세팅
let memberLv = 10;
let levelName = memberLv >= 10 ? "VIP" : "NORMAL";

// 실습 => 조건문(if~ )으로 풀어서 구현하시오
if (memberLv >= 10) {
    levelName = "VIP"
} else {
    levelName = "NORMAL"
}

// 단, 수행문이 1개라면 {} 생략 가능함
if (memberLv >= 10) levelName = "VIP"
else                levelName = "NORMAL"
console.log( levelName );


// switch ~ case
// 케이스별로 분기 처리
let curDay = new Date().getDay(); // 현재시간값(new Date())에서 정보 추출
// 일:0, 월:1, 화:2 => 요일 정보
console.log( curDay );
switch (curDay) {
    case 0: // 케이스 별이므로, 범위 조건식 없음(크다, 작다 x)
        console.log( '일요일' ); // 수행 형식, 변수 값 세팅 OK
        break;
    case 1:
        console.log( '월요일' );
        break;
    case 2:
        console.log( '화요일' );
        break;
    case 3:
    case 4: 
        console.log( '수목요일' );
        break;
    default: // 이도 저도 아닌 기본값 => else 개념
        console.log( '금토요일' );
        break;
}

// 중첩 조건문
// 쇼트 연산자(&&=> and, || => or) 생략