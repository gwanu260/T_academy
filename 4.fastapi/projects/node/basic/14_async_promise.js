/**
 * 비동기 처리(JS|node의 기본 코드 처리 방식)
 *  - I/O 작업때 빈번하게 발생함
 */
// 1. 고전적인 처리 방식 -> 콜백함수임
// 파일Io를 이용하여 재현
// 파일시스템(File System => fs) 모듈을 가져와서 진행
// node에서 모듈 가져오기
// 1. CommonJS 방식 -> 초기때부터 지원 -> CJS 방식
// 2. ES Module 방식 -> ES6에서 추가됨 -> react/vue등 spa
const fs = require('fs'); // 파일 시스템 모듈 가져오기(node 기반)

// 비동기 상황 연출 -> 1.txt -> 2.txt -> 3.txt 읽어서 출력
// 동기적 표현
fs.readFile( './data/1.txt', (err, data)=>{
    // 파일 읽기가 성공하면 등록한 콜백함수를 호출하여, 결과를 인자로 넘기겠다
    // 함수가 호출되면 그 다음에 할일을 작성
    console.log( '1.txt', err, new String(data).toString() );
});
fs.readFile( './data/2.txt', (err, data)=>{
    console.log( '2.txt', err, data );
});
fs.readFile( './data/3.txt', (err, data)=>{
    console.log( '3.txt', err, data ); 
});
// 정리 : 비동기 처리 함수들(대부분 I/O)은 동기적으로 수행 완료되지 않음.(제각각)
// 해결 => 콜백함수로 구성 조정 해결 (1번이 끝나면 -> 2번 실행 ...)
// 전통적 비동기 함수들을 동기적으로(순차적으로 처리가 완료되게) 구성
fs.readFile( './data/1.txt', (err, data)=>{
    console.log( '1.txt', err, new String(data).toString() );
    fs.readFile( './data/2.txt', (err, data)=>{
        console.log( '2.txt', err, data );
        fs.readFile( './data/3.txt', (err, data)=>{
            console.log( '3.txt', err, data ); 
        });
    });
});
// 위 방식으로 해결 => 콜백헬 발생 (수정 힘듦, 관리 힘듦, 가독 떨어짐)

// ES6부터 해결방안 제시
// 1. (*)Promise 패턴 <= 핵심 (정의, 사용법(*))
// 2. (*)async ~ await 패턴
// 3. generator 패턴 제시 => 잘 사용 x

// 1. Promise 정의 (Promise 객체를 반환하는 함수)
function es6Promise( fileName ) {
    // resolve  : 작업이 성공하면 호출하는 함수
    // reject   : 작업이 실패하면 호출하는 함수
    return new Promise( ( resolve, reject )=>{
        // 작업 -> 파일 읽기
        fs.readFile( fileName, ( err, data )=>{
            if(err) reject( err );  // 파일 읽기 실패
            else    resolve( data );// 파일 읽기 성공
        }) ;
    } );
}

// 2. Promise 객체를 반환하는 함수 사용법1
/**
es6Promise( './data/1.txt' )
.then( ( data ) =>{     // 파일 읽기가 성공하면 자동 실행됨
    console.log( '읽기 성공', data );
} ) // 파일 읽기가 성공하면 자동 실행됨
.catch( (err)=>{        // 실패하면 여기로 진입
    console.log( '읽기 실패', err );
} )
.finally( ()=>{ // 성공하던, 실패하던 반드시 해야할 코드 작성 위치
    console.log( '뒷정리' );
} );
 */

// 파일 1 -> 2 -> 3 연속으로 읽고 출력 처리
// 비동작업 3개를 동기적으로 배치하여 차례대로 구동, 결과 획득하는 코드
es6Promise( './data/1.txt' )
.then( ( data ) =>{     
    console.log( "1", data );
    return es6Promise( './data/2.txt' );
} )
.then( ( data ) =>{     
    console.log( "2", data );
    return es6Promise( './data/3.txt' );
} )
.then( ( data ) =>{     
    console.log( "3", data );
} )

// 3. Promise 객체를 반환하는 함수 사용법2 -> async ~ await
async function exFileRead() {
    console.log( await es6Promise('./data/1.txt') );
    console.log( await es6Promise('./data/2.txt') );
    console.log( await es6Promise('./data/3.txt') );
}
exFileRead();
