/**
 * 반복문
 *  - 주의 사항 => 반복중에 임시로 생성되는 변수의 키워드는 let or const 를 반드시 사용(잠재적 오류 방지)
 *  - for   : 지정(정해진) 회수만큼 반복
 *      - 종류가 다양함
 *  - while : 무한대(언제 끝날지 모른다), 반복루프
 *      - 0 ~ 무한대
 *  - do ~ while : 상동
 *      - 1 ~ 무한대
 *  - 기타 키워드
 *      - break : 해당 표현을 감싸고 있는 가장 가까운 반복문 탈출
 *      - continue : 해당 표현을 감싸고 있는 가장 가까운 반목문 점프(다른 단계진행)
 */
// 1. 기본 for 문(전통적 방식)
for (let i = 0; i < 5; i++) {
    console.log( `카운트 : ${i}` );
}
// 2. 전통적 방식 + 중첩 반복문
for (let i = 1; i < 2; i++) {
    for (let j = 0; j < 2; j++) {
        console.log( `${i} x ${j} = ${i*j}` );
    }
}

// for ~ in => JS의 객체유형을 대상으로 반복문 처리시 사용 => 타겟은 객체(파이썬 dict)
const person = {
    name:'js',
    age:10
} // JS에서 {}의 단독 표기는 객체를 의미함
for (const key in person) {
    // 키, 값 => (인덱싱으로)을 출력하시오
    if( key === 'name' ) continue // 일치되면 조건문으로 점프함
    console.log( key, person[ key ] );
}

// for ~ of => 타겟이 [ .... ]: 배열(파이썬에는 리스트가 타겟)
const levels = [ 1, 2, 3 ];
for (const level of levels) {
    console.log( level )
}

// for (const i of person) { // 에러, 적용 x
for (const idx in levels) {
    console.log( idx, levels[ idx ] ) // for ~ in 에 배열 배치 -> 값 추출시 번잡함
}

// forEach(배열에 직접 붙어서 처리시), for await(비동기 처리시) -> 나중에 체크
// ------------------------------------------------------------
// while 
let cnt = 0;
while (true) {
    console.log( cnt++ ); // 0 -> 1 -> 2 -> 3 출력 4가 되어서 탈출
    if(cnt > 3) break;
}
// 위 아래는 결과값이 동일함
cnt = 0;
while(cnt<4) {
    console.log( cnt++ );
}

// do ~ while : 1 ~ 무한대
// 반드시 한번은 수행된다(보장)
cnt = 0;
do {
    console.log( cnt++ ); // 0 -> 1 -> 2 -> 3
} while (cnt<4);