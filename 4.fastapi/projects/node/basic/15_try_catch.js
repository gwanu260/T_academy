/**
 * 예외처리 -> 파이썬과 맥락은 동일
 *  - 오류를 잡는다. try ~ catch
 *  - 오류를 상위로 던진다. throw
 */
function makeException() {
    console.log( 1/0, -1/0 ); // Infinity, -Infinity : JS 허가해줌
    throw new Error('임시 오류'); // 오류 던지기 -> 이 함수를 호출한 곳으로(상위)
}
// 예외 처리문 => s/w 셧다운 방지하는 코드 => I/O 필수적 잠재하고 있음
try {
    console.log( 1 );
    makeException()
    console.log( 2 );
} catch (error) {
    console.log( 3, error );
} finally {
    console.log( 4 );
}