-- 오라클의 날짜 데이터 타입(DATE, TIMESTAMP, 책 p58참고)
CREATE TABLE ex2_5 (
	col_date         DATE,                  --- 값이 없어도 되는 컬럼
	col_timestamp    timestamp NOT NULL     --- 값이 무조건 있어야 되는 컬럼
);

-- 오라클의 날짜 데이터 삽입(모든 컬럼에 값을 넣고자 할 경우에는 컬럼이름을 적는 것을 생략가능)
INSERT INTO ex2_5 VALUES (SYSDATE, SYSTIMESTAMP);

-- 현재 시간 가져오는 쿼리
SELECT SYSDATE, SYSTIMESTAMP FROM DUAL;

INSERT INTO ex2_5 VALUES ('2024-03-05', '2023-08-12');

-- INSERT INTO ex2_5 VALUES (2024-03-05, 2023-08-12);  -- error

INSERT INTO ex2_5(col_date) VALUES('2024-03-05');   -- error(col_timestamp의 컬럼에는 값이 무조건 있어야 함)
INSERT INTO ex2_5(col_timestamp) VALUES('2024-03-05');

-- 오라클의 ex2_5테이블 데이터 조회(* -> 모든 컬럼(col_date, col_timestamp))
SELECT * FROM ex2_5;

-- NOT NULL 제약조건에 관한 실습
CREATE TABLE ex2_6(
	col_null		varchar2(10),
	col_not_null	varchar2(10)	NOT null
);

INSERT INTO ex2_6 VALUES ('AA', '');  -- error

INSERT INTO ex2_6 VALUES ('AA', 'BB');

SELECT * FROM ex2_6;


-- UNIQUE 제약조건에 관한 실습
CREATE TABLE ex2_7 (
	-- 1. col_unique_null컬럼의 값은 중복된 값 허용 X
	col_unique_null		varchar2(10) 	UNIQUE,			 
	-- 1. col_unique_nnull컬럼의 값은 중복된 값 허용 X 
	-- 2. NULL허용 X
	col_unique_nnull    varchar2(10)    UNIQUE  NOT NULL,
	col_unique          varchar2(10),
	CONSTRAINTS unique_nm1 unique(col_unique)
);

INSERT INTO ex2_7 VALUES ('AA', 'AA', 'AA');

INSERT INTO ex2_7(col_unique_null, col_unique_nnull) VALUES ('BB', 'BB');

INSERT INTO ex2_7 VALUES ('', 'CC', 'CC');

INSERT INTO ex2_7 VALUES ('', 'DD', 'DD');

INSERT INTO ex2_7 VALUES ('BB', 'EE', 'EE');

SELECT * FROM ex2_7;


-- 테이블의 기본키(Primary Key) 설정
CREATE TABLE ex2_8 (
	col1    varchar2(10)    PRIMARY KEY,   -- col1의 값들은 unique하며 NOT null이어야 한다.
	col2    varchar2(10)    
);

INSERT INTO ex2_8 VALUES ('', 'AA');    -- error -> col1의 값은 값이 무조건 존재하여야 한다

INSERT INTO ex2_8 VALUES ('AA', 'AA');

INSERT INTO ex2_8 VALUES ('BB', 'AA');

SELECT * FROM ex2_8;


-- CHECK 제약 조건 사용하기
CREATE TABLE ex2_9 (
	num1	NUMBER,
	CONSTRAINTS check1 check( num1 BETWEEN 1 AND 9),   -- num1의 컬럼값은 1~9까지만 허용
	gender  varchar2(10),
	CONSTRAINTS check2 check( gender IN ('MALE', 'FEMALE') ) -- gender의 컬럼값은 'MALE', 'FEMALE'만 허용
);

SELECT * FROM ex2_9;

INSERT INTO ex2_9 VALUES(10, 'MAN');  -- error

INSERT INTO ex2_9 values(5, 'FEMALE');
INSERT INTO ex2_9 values(6, 'MALE');

-- CHECK DATE로 제약 조건 걸기
CREATE TABLE event_schedule (
    event_id NUMBER,
    event_time DATE,
    CONSTRAINT chk_event_time CHECK (event_time >= TO_DATE('2025-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'))
);

INSERT INTO EVENT_SCHEDULE VALUES(1, '2026-01-01');

SELECT * FROM EVENT_SCHEDULE;

-- CHECK TIMESTAMP로 제약 조건 걸기
CREATE TABLE meeting_schedule (
    meeting_id NUMBER,
    meeting_time TIMESTAMP,
    CONSTRAINT chk_meeting_time CHECK (
        meeting_time BETWEEN TO_TIMESTAMP('2025-01-01 08:00:00', 'YYYY-MM-DD HH24:MI:SS')
                       AND TO_TIMESTAMP('2025-12-31 18:00:00', 'YYYY-MM-DD HH24:MI:SS')
    )
);

-- DEFAULT 사용(insert시에 컬럼으로 지정되지 않은 것일 때 기본적으로 들어가는 값)
CREATE TABLE ex2_10 (
	col1	varchar2(10)	NOT NULL,
	col2	varchar2(10)    NOT NULL,
	-- 만약 insert시에 create_date컬럼이 지정되지 않으면 기본적으로 현재시간값으로 저장
	create_date   DATE      DEFAULT sysdate    
);

INSERT INTO ex2_10 (col1, col2) VALUES ('AA', 'BB');

SELECT * FROM ex2_10;

-- -- DEFAULT 없는 테이블
CREATE TABLE ex2_10_2 (
	col1	varchar2(10)	NOT NULL,
	col2	varchar2(10)    NOT NULL,
	create_date   DATE
);

INSERT INTO ex2_10_2 (col1, col2) VALUES ('AA', 'BB');

SELECT * FROM ex2_10_2;



CREATE TABLE ex2_10_3 (
	col1	varchar2(10)	DEFAULT '홍길동' NOT NULL,   -- col1의 값이 부여되지 않으면 기본적으로 '홍길동'데이터가 입력
	col2	varchar2(10)    NOT NULL,
	create_date   DATE
);

INSERT INTO ex2_10_3(col2) values('CC');

SELECT * FROM ex2_10_3;


-- 숫자 타입의 default 사용한 테이블
CREATE TABLE ex2_10_4 (
	col1   NUMBER   DEFAULT 1,
	col2   NUMBER
);

INSERT INTO ex2_10_4(col2) VALUES (3);

SELECT * FROM ex2_10_4;

-- 테이블 삭제 문법
-- DROP TABLE [스키마명].테이블명 [CASCADE CONSTRAINTS];

DROP TABLE ex2_10_3;

DROP TABLE ex2_10_2;

DROP TABLE ex2_10;

DROP TABLE ex2_7;

-- 테이블 변경
--   1. 컬럼명 변경(ALTER TABLE [스키마명].테이블명 RENAME COLUMN 변경전컬럼명 TO 변경후컬럼명)
--   2. 컬럼 타입 변경(ALTER TABLE [스키마명].테이블명 MODIFY 컬럼명 데이터타입)
--   3. 컬럼 추가(ALTER TABLE [스키마명].테이블명 ADD 컬럼명 데이터타입)
--   4. 컬럼 삭제(ALTER TABLE [스키마명].테이블명 DROP COLUMN 컬럼명 데이터타입)
--   5. 제약조건(CHECK, NOT NULL, PRIMARY KEY etc...) 추가
--      (ALTER TABLE [스키마명].테이블명 ADD CONSTRAINT 제약조건명 PRIMARY KEY (컬럼명1, ...))
--   6. 제약조건(CHECK, NOT NULL, PRIMARY KEY etc...) 삭제
--      (ALTER TABLE [스키마명].테이블명 DROP CONSTRAINT 제약조건명)

SELECT * FROM ex2_10;

-- 컬럼명 변경
ALTER TABLE ex2_10 RENAME COLUMN col1 TO col11;

-- col2 -> col22로 변경
ALTER TABLE ex2_10 RENAME COLUMN col2 TO col22;

-- 컬럼타입 변경
ALTER TABLE ex2_10 MODIFY col22 varchar2(30);

-- desc ex2_10;  -- error 현재 버전에서는 사용 불가능

-- 컬럼추가 
ALTER TABLE ex2_10 ADD col3 NUMBER;

ALTER TABLE ex2_10 ADD col4 varchar2(20 char);

-- 컬럼삭제
ALTER TABLE ex2_10 DROP COLUMN col3;

ALTER TABLE ex2_10 DROP COLUMN col4;

-- primary key 제약조건 추가
ALTER TABLE ex2_10 ADD CONSTRAINT pk_ex2_10 PRIMARY KEY (col11);

-- primary key 제약조건 삭제
ALTER TABLE ex2_10 DROP CONSTRAINT pk_ex2_10;



