/**
 * 문자열
 *  - 타입
 *  - 표현
 *      - '문자열', "문자열" : 초기부터 ~
 *      - ES6(ECMA2015)에 추가
 *          - `문자열`      : 백틱기호 사용 == 포멧팅 기능, 파이썬 여러줄주석
 *              - 생산성 극대화, 간결한 표현
 *              - 포멧팅
 *                  - `${ 값 } X ${ 값 } = ${ 값*값 }` : 구구단 표현 샘플
 */
// 문자열 리터럴 확인
let name = 'js';
let name2  = "js";
let name3 = `js`;
console.log( name, name2, name3 );

// 리터럴을 겹쳐서 표현
let name4 = '"js"';
console.log( name4 );

// 1개 리터럴로 겹쳐서 => 이스케이프 문자 활용
let name5 = '\'js\'';
console.log( name5 );

// 여러줄 구성 => 동적으로 html을 생성할때 유용하게 사용됨.
// 과거에는 전체 구성에 수정할 부분이 있으면 일일이 + 생성
let name6 = `
    <!-- 사용자 입력을 받는 HTMLL의 태크 -->
    <input type='${ 'email' }' ..../>
`

console.log( name6 );