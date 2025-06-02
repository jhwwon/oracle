-- 데이터베이스 객체의 종류(엑셀파일)
-- (엑셀의 용어들과 비교)
--   1. 테이블(Sheet)
--   2. 뷰(읽기 전용만 되는 Sheet)
--   3. 인덱스(목차)
--   4. 시퀀스(일련번호)
--   5. 함수(입력값은 생략가능, 결과값은 반드시 존재)
--   6. 프로시저(입력값은 생략가능, 결과값도 생략가능) 
--      -> 여러개의 함수 혹은 SQL문을 실행하기 위한 용도

-- 테이블 생성(테이블이름 ex2_1)
-- 사원 테이블 생성
CREATE TABLE employees (
	employee_id		number(6, 0) 	NOT NULL,  -- 사원 ID
	emp_name		varchar2(80)	NOT NULL,  -- 사원 이름
	salary			number(8, 2),		       -- 급여(단위 달러)	
	hire_date		DATE			NOT NULL   -- 입사일자
);

CREATE TABLE ex2_1 (
	-- 컬럼이름(column1) 컬럼데이터타입(char(10))(컬럼값의 성격) [NULL, NOT NULL](표시가 없으면 NULL)
	column1    char(10),
	column2    varchar2(10), 
	column3    nvarchar2(10),
	column4    number
);

-- 데이터타입의 종류(문자, 숫자, 날짜, LOB(Binary), NULL)

-- 테이블에 데이터 삽입
-- INSERT INTO 테이블이름(컬럼1이름, 컬럼2이름, ...) VALUES (컬럼1값, 컬럼2값, ...)
INSERT INTO ex2_1 (column1, column2) VALUES ('abc', 'abc');

-- 테이블의 들어간 데이터 조회
-- SELECT 컬럼1이름 [AS 컬럼이름], 컬럼2이름, 함수1 [AS 컬럼이름(기존의 컬럼이름이 아닌)], 함수2 ... FROM 테이블이름
SELECT column1, LENGTH(column1) AS len1, 
	   column2, LENGTH(column2) AS len2
FROM ex2_1;

-- 테이블 ex2_2 생성
CREATE TABLE ex2_2 ( 
	column1		varchar2(9),   -- 디폴트 값인 byte 적용
	column2		varchar2(9 byte),
	column3		varchar2(9 char)    -- 사람이 보기에 편한 글자수
);

-- 테이블 ex2_2에 데이터 입력
INSERT INTO ex2_2(column1, column2, column3) VALUES ('abc','abc','abc');

SELECT column1, LENGTH(column1) AS len1, 
	   column2, LENGTH(column2) AS len2,
	   column3, LENGTH(column3) AS len3
FROM ex2_2;

INSERT INTO ex2_2(column1, column2, column3) VALUES ('홍길동','홍길동','홍길동');

INSERT INTO ex2_2(column1, column2, column3) VALUES ('こんに','こんに','こんに');

INSERT INTO ex2_2(column1, column2, column3) VALUES ('你好','你好','你好');

INSERT INTO ex2_2(column1) VALUES ('Xin chào');

-- 테이블 이름은 member
CREATE TABLE member (
	id    		varchar2(100)		NOT NULL,		-- 회원번호
	login_id    varchar2(20)		NOT NULL,       -- 로그인 아이디
	password    varchar2(20)		NOT NULL,       -- 패스워드
	name        varchar(20)		NOT NULL,       -- 이름
	gender      char(1),							-- 성별
	birth_date  char(8)								-- 생년월일
);

-- 숫자 타입이 있는 테이블(number(p, s))
CREATE TABLE ex2_3 (
	col_int		integer,   -- 소수점 안됨
	col_dec		decimal,   -- 소수점까지 가능
	col_num1	NUMBER,     -- 소수점까지 가능
	col_num2    NUMBER(3),
	col_num3    NUMBER(3,2),
	col_num4    NUMBER(5,2),
	col_num5    NUMBER(7,1),
	col_num6    NUMBER(7,-1),
	col_num7    NUMBER(4,5),
	col_num8    NUMBER(4,5),
	col_num9    NUMBER(4,7),
	col_num10   NUMBER(3,7)
);

-- ex2_3의 모든 컬럼 조회
SELECT * FROM ex2_3;

INSERT INTO ex2_3(col_num1) VALUES (123.54);
INSERT INTO ex2_3(col_num2) VALUES (123.54);
-- INSERT INTO ex2_3(col_num3) VALUES (123.54);  -- error
INSERT INTO ex2_3(col_num4) VALUES (123.54);
INSERT INTO ex2_3(col_num5) VALUES (123.54);
INSERT INTO ex2_3(col_num6) VALUES (123.54);
-- INSERT INTO ex2_3(col_num7) VALUES (0.1234);   -- error(유효숫자는 4개가 맞지만 뒤에 5가 유효한 숫자인 4자리수라서 오류)
INSERT INTO ex2_3(col_num8) VALUES (0.01234);
INSERT INTO ex2_3(col_num9) VALUES (0.0001234);
-- INSERT INTO ex2_3(col_num10) VALUES (0.0001234);  -- error(소수점 이하 일곱째 자리까지는 유효숫자 1234이고 4개인데 p가 3이므로 오류 )

DESC ex2_3;




