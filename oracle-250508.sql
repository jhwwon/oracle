-- INSTR(문자열, 부분문자열, 시작위치, 몇번째 일치) 함수

-- 1번째 위치에서부터 시작해서 '만약'이라는 글자의 인덱스 위치값을 반환
SELECT instr('내가 만약 외로울 때면, 내가 만약 괴로울 때면, 내가 만약 즐거울 때면', '만약', 1, 1) instr1 
FROM dual;

-- 5번째 위치에서부터 시작해서 '만약'이라는 글자의 인덱스 위치값을 반환
SELECT instr('내가 만약 외로울 때면, 내가 만약 괴로울 때면, 내가 만약 즐거울 때면', '만약', 5, 1) instr1 
FROM dual;

-- 5번째 위치에서부터 시작해서 '만약'이라는 글자가 2번째 일치했을 때의 인덱스 위치값을 반환
SELECT instr('내가 만약 외로울 때면, 내가 만약 괴로울 때면, 내가 만약 즐거울 때면', '만약', 5, 2) instr1 
FROM dual;

-- LENGTH(문자열), LENGTHB(문자열)
SELECT length('대한민국') FROM DUAL;
SELECT lengthb('대한민국') FROM DUAL;

SELECT length('abcd') FROM DUAL;
SELECT lengthb('abcd') FROM DUAL;


-- 날짜함수
-- 현재시간 구하기(SYSDATE, SYSTIMESTAMP)
SELECT sysdate, systimestamp FROM dual;

-- ADD_MONTHS(날짜, 숫자)
SELECT add_months(sysdate, 1) FROM dual;
SELECT add_months(sysdate, -1) FROM dual;

-- MONTHS_BETWEEN(날짜1, 날짜2)
SELECT MONTHS_BETWEEN(sysdate, add_months(sysdate, 1)) FROM dual;
SELECT MONTHS_BETWEEN(add_months(sysdate, 1), sysdate) FROM dual;

-- 날짜 일 수 더하기
SELECT sysdate + 7 AS 일주일후 FROM dual;  -- 7일 더하기
SELECT sysdate - 3 AS 삼일전 FROM dual;  -- 3일 빼기


-- 변환함수(숫자, 문자, 날짜)
-- to_char(숫자 혹은 날짜, 포맷(형식))
SELECT TO_CHAR(1234567, '999,999,999') FROM DUAL;  -- 숫자 -> 문자로
SELECT TO_CHAR(sysdate, 'YYYY-MM-DD') FROM DUAL;  -- 날짜 -> 문자로


-- CUSTOMERS 테이블 생성
CREATE TABLE "CUSTOMERS"(	
    "CUST_ID" NUMBER(6,0) NOT NULL, 
	"CUST_NAME" VARCHAR2(100) NOT NULL, 
	"CUST_GENDER" CHAR(1), 
	"CUST_YEAR_OF_BIRTH" NUMBER(4,0), 
	"CUST_MARITAL_STATUS" VARCHAR2(20), 
	"CUST_STREET_ADDRESS" VARCHAR2(100), 
	"CUST_POSTAL_CODE" VARCHAR2(10), 
	"CUST_CITY" VARCHAR2(30), 
	"CUST_CITY_ID" NUMBER(6,0), 
	"CUST_STATE_PROVINCE" VARCHAR2(40), 
	"CUST_STATE_PROVINCE_ID" NUMBER(6,0), 
	"COUNTRY_ID" NUMBER(6,0), 
	"CUST_MAIN_PHONE_NUMBER" VARCHAR2(25), 
	"CUST_INCOME_LEVEL" VARCHAR2(30), 
	"CUST_CREDIT_LIMIT" NUMBER, 
	"CUST_EMAIL" VARCHAR2(30), 
	"CUST_TOTAL" VARCHAR2(20), 
	"CUST_TOTAL_ID" NUMBER(6,0), 
	"CUST_SRC_ID" NUMBER(6,0), 
	"CUST_EFF_FROM" DATE, 
	"CUST_EFF_TO" DATE, 
	"CUST_VALID" CHAR(1), 
	"CREATE_DATE" DATE DEFAULT SYSDATE, 
	"UPDATE_DATE" DATE DEFAULT SYSDATE
);

-- 전체 행을 구하는 쿼리
SELECT count(*) FROM CUSTOMERS;
-- TRUNCATE TABLE CUSTOMERS;

SELECT * FROM EMPLOYEES;

-- 4장 연습문제 풀이
-- 1번문제(###.###.####)
SELECT lpad(substr(PHONE_NUMBER, 5), 12, '(02)') FROM EMPLOYEES;
SELECT '(02)' || substr(PHONE_NUMBER, 5) FROM EMPLOYEES;

-- 2번문제
SELECT employee_id, emp_name, hire_date, (sysdate - hire_date) / 365 AS 근속년수
FROM EMPLOYEES
WHERE ((sysdate - hire_date) / 365) >= 10
ORDER BY hire_date asc
;

SELECT employee_id, emp_name, hire_date, ceil((sysdate - hire_date) / 365) AS 근속년수
FROM EMPLOYEES
WHERE ceil((sysdate - hire_date) / 365) >= 10
ORDER BY hire_date asc
;

SELECT employee_id, emp_name, hire_date, MONTHS_BETWEEN(sysdate, hire_date) / 12 AS 근속년수
FROM EMPLOYEES
WHERE MONTHS_BETWEEN(sysdate, hire_date) / 12 >= 10
ORDER BY 3 asc
;

-- 3번 문제
SELECT TRANSLATE(CUST_MAIN_PHONE_NUMBER, '-', '/') FROM CUSTOMERS;
SELECT REPLACE(CUST_MAIN_PHONE_NUMBER, '-', '/') FROM CUSTOMERS;

-- 4번 문제
SELECT REPLACE(
		REPLACE(
	      REPLACE(
			CUST_MAIN_PHONE_NUMBER, '0', 'a'
		  ), '1', 'b'
		), '2', 'c'
	   ) 
FROM CUSTOMERS;

SELECT translate(CUST_MAIN_PHONE_NUMBER, '0123456789', 'abcdeyghtf') FROM CUSTOMERS
;

-- 5번 문제
SELECT cust_name,
	   cust_year_of_birth,
	   --decode(floor((to_number(to_char(sysdate, 'YYYY')) - CUST_YEAR_OF_BIRTH) / 10),
	   decode(trunc((to_number(to_char(sysdate, 'YYYY')) - CUST_YEAR_OF_BIRTH) / 10),
				3, '30대',
				4, '40대',
				5, '50대',
				'기타') AS 세대
  FROM CUSTOMERS
;

-- 6번 문제(모든 연령대(10대, 20대, ... 70대, 기타)
SELECT CASE 
			WHEN (to_number(to_char(sysdate, 'YYYY')) - CUST_YEAR_OF_BIRTH) BETWEEN 0 AND 19 THEN '10대'
			WHEN (to_number(to_char(sysdate, 'YYYY')) - CUST_YEAR_OF_BIRTH) BETWEEN 20 AND 29 THEN '20대'
			WHEN (to_number(to_char(sysdate, 'YYYY')) - CUST_YEAR_OF_BIRTH) BETWEEN 30 AND 39 THEN '30대'
			WHEN (to_number(to_char(sysdate, 'YYYY')) - CUST_YEAR_OF_BIRTH) BETWEEN 40 AND 49 THEN '40대'
			WHEN (to_number(to_char(sysdate, 'YYYY')) - CUST_YEAR_OF_BIRTH) BETWEEN 50 AND 59 THEN '50대'
			WHEN (to_number(to_char(sysdate, 'YYYY')) - CUST_YEAR_OF_BIRTH) BETWEEN 60 AND 69 THEN '60대'
			WHEN (to_number(to_char(sysdate, 'YYYY')) - CUST_YEAR_OF_BIRTH) BETWEEN 70 AND 79 THEN '70대'
			ELSE '기타'
	   END AS 세대
FROM CUSTOMERS
;

SELECT * FROM EMPLOYEES;

-- NULL관련함수(NVL, NVL2, COALESCE, LNNVL, NULLIF)
-- NVL(수식1(컬럼), 수식2(컬럼)) -> 수식1이 null이면 수식2값으로 대체
SELECT NVL(manager_id, EMPLOYEE_ID), manager_id, EMPLOYEE_ID 
  FROM EMPLOYEES
 WHERE manager_id IS NULL
;

SELECT nvl(department_id, 0) 
  FROM EMPLOYEES
;

SELECT nvl(RETIRE_DATE, sysdate)
  FROM EMPLOYEES
;

SELECT * 
  FROM EMPLOYEES
;

-- NVL2(수식1(컬럼), 수식2(컬럼), 수식3(컬럼)) -> 수식1이 null이면 수식3값으로 대체, null이 아니면 수식2값으로 대체
SELECT salary, COMMISSION_PCT, NVL2(COMMISSION_PCT, salary + (salary * commission_pct), salary) AS 보너스포함한급여
  FROM EMPLOYEES
;

-- coalesce(수식1, 수식2, ...) -> 수식1이 NULL이면 수식2, 수식2가 NULL이면 수식3, 수식3이 NULL이면 수식4...
SELECT EMPLOYEE_ID, SALARY, COMMISSION_PCT,
       coalesce(SALARY * COMMISSION_PCT, SALARY)
  FROM EMPLOYEES
;

SELECT * FROM EMPLOYEES;
SELECT 2 * 3 FROM DUAL;
SELECT 2 * NULL FROM DUAL;

-- NULLIF(수식1, 수식2) -> 수식1의 값과 수식2의 값이 같으면 NULL, 다르면 수식1의 값을 반환
SELECT employee_id,
       TO_CHAR(start_date, 'YYYY') start_year,
       TO_CHAR(end_date, 'YYYY') end_year,
       NULLIF(TO_CHAR(end_date, 'YYYY'), TO_CHAR(start_date, 'YYYY') ) nullif_year
FROM job_history;



CREATE TABLE "JOB_HISTORY" (	
	"EMPLOYEE_ID" NUMBER(6,0) NOT NULL, 
	"START_DATE" DATE DEFAULT SYSDATE NOT NULL, 
	"END_DATE" DATE, 
	"JOB_ID" VARCHAR2(10), 
	"DEPARTMENT_ID" NUMBER(6,0), 
	"CREATE_DATE" DATE DEFAULT SYSDATE, 
	"UPDATE_DATE" DATE DEFAULT SYSDATE
);
ALTER TABLE "JOB_HISTORY" ADD CONSTRAINT "PK_JOB_HISTORY" PRIMARY KEY ("EMPLOYEE_ID", "START_DATE");

INSERT INTO JOB_HISTORY
(EMPLOYEE_ID, START_DATE, END_DATE, JOB_ID, DEPARTMENT_ID, CREATE_DATE, UPDATE_DATE)
VALUES(102, TIMESTAMP '2001-01-13 00:00:00.000000', TIMESTAMP '2006-07-24 00:00:00.000000', 'IT_PROG', 60, TIMESTAMP '2014-01-08 13:59:10.000000', TIMESTAMP '2014-01-08 13:59:10.000000');
INSERT INTO JOB_HISTORY
(EMPLOYEE_ID, START_DATE, END_DATE, JOB_ID, DEPARTMENT_ID, CREATE_DATE, UPDATE_DATE)
VALUES(101, TIMESTAMP '1997-09-21 00:00:00.000000', TIMESTAMP '2001-10-27 00:00:00.000000', 'AC_ACCOUNT', 110, TIMESTAMP '2014-01-08 13:59:10.000000', TIMESTAMP '2014-01-08 13:59:10.000000');
INSERT INTO JOB_HISTORY
(EMPLOYEE_ID, START_DATE, END_DATE, JOB_ID, DEPARTMENT_ID, CREATE_DATE, UPDATE_DATE)
VALUES(101, TIMESTAMP '2001-10-28 00:00:00.000000', TIMESTAMP '2005-03-15 00:00:00.000000', 'AC_MGR', 110, TIMESTAMP '2014-01-08 13:59:10.000000', TIMESTAMP '2014-01-08 13:59:10.000000');
INSERT INTO JOB_HISTORY
(EMPLOYEE_ID, START_DATE, END_DATE, JOB_ID, DEPARTMENT_ID, CREATE_DATE, UPDATE_DATE)
VALUES(201, TIMESTAMP '2004-02-17 00:00:00.000000', TIMESTAMP '2007-12-19 00:00:00.000000', 'MK_REP', 20, TIMESTAMP '2014-01-08 13:59:10.000000', TIMESTAMP '2014-01-08 13:59:10.000000');
INSERT INTO JOB_HISTORY
(EMPLOYEE_ID, START_DATE, END_DATE, JOB_ID, DEPARTMENT_ID, CREATE_DATE, UPDATE_DATE)
VALUES(114, TIMESTAMP '2006-03-24 00:00:00.000000', TIMESTAMP '2007-12-31 00:00:00.000000', 'ST_CLERK', 50, TIMESTAMP '2014-01-08 13:59:10.000000', TIMESTAMP '2014-01-08 13:59:10.000000');
INSERT INTO JOB_HISTORY
(EMPLOYEE_ID, START_DATE, END_DATE, JOB_ID, DEPARTMENT_ID, CREATE_DATE, UPDATE_DATE)
VALUES(122, TIMESTAMP '2007-01-01 00:00:00.000000', TIMESTAMP '2007-12-31 00:00:00.000000', 'ST_CLERK', 50, TIMESTAMP '2014-01-08 13:59:10.000000', TIMESTAMP '2014-01-08 13:59:10.000000');
INSERT INTO JOB_HISTORY
(EMPLOYEE_ID, START_DATE, END_DATE, JOB_ID, DEPARTMENT_ID, CREATE_DATE, UPDATE_DATE)
VALUES(200, TIMESTAMP '1995-09-17 00:00:00.000000', TIMESTAMP '2001-06-17 00:00:00.000000', 'AD_ASST', 90, TIMESTAMP '2014-01-08 13:59:10.000000', TIMESTAMP '2014-01-08 13:59:10.000000');
INSERT INTO JOB_HISTORY
(EMPLOYEE_ID, START_DATE, END_DATE, JOB_ID, DEPARTMENT_ID, CREATE_DATE, UPDATE_DATE)
VALUES(176, TIMESTAMP '2006-03-24 00:00:00.000000', TIMESTAMP '2006-12-31 00:00:00.000000', 'SA_REP', 80, TIMESTAMP '2014-01-08 13:59:10.000000', TIMESTAMP '2014-01-08 13:59:10.000000');
INSERT INTO JOB_HISTORY
(EMPLOYEE_ID, START_DATE, END_DATE, JOB_ID, DEPARTMENT_ID, CREATE_DATE, UPDATE_DATE)
VALUES(176, TIMESTAMP '2007-01-01 00:00:00.000000', TIMESTAMP '2007-12-31 00:00:00.000000', 'SA_MAN', 80, TIMESTAMP '2014-01-08 13:59:10.000000', TIMESTAMP '2014-01-08 13:59:10.000000');
INSERT INTO JOB_HISTORY
(EMPLOYEE_ID, START_DATE, END_DATE, JOB_ID, DEPARTMENT_ID, CREATE_DATE, UPDATE_DATE)
VALUES(200, TIMESTAMP '2002-07-01 00:00:00.000000', TIMESTAMP '2006-12-31 00:00:00.000000', 'AC_ACCOUNT', 90, TIMESTAMP '2014-01-08 13:59:10.000000', TIMESTAMP '2014-01-08 13:59:10.000000');

/*
문제1
다음 중 NVL, NVL2, COALESCE 함수에 대한 설명으로 옳지 않은 것을 모두 고르시오.
  A. NVL(expr1, expr2)는 expr1이 NULL이면 expr2를 반환한다.
  B. NVL2(expr1, expr2, expr3)는 expr1이 NULL이 아니면 expr2를 반환하고, NULL이면 expr3을 반환한다.
  C. COALESCE(expr1, expr2, ..., exprN)은 마지막에 있는 NULL 값을 반환한다.
  D. NVL은 문자열뿐 아니라 숫자, 날짜 등에도 사용할 수 있다.

문제2
COMMISSION_PCT가 NULL인 경우 0으로 대체해서, 실제 급여(SALARY + SALARY * COMMISSION_PCT)를 계산하여 
출력하시오. 단, 컬럼명은 ACTUAL_SALARY로 표시하시오.
*/
SELECT nvl(COMMISSION_PCT, 0) * SALARY + salary AS ACTUAL_SALARY 
FROM EMPLOYEES;


CREATE TABLE STUDENTS (
  STUDENT_ID   NUMBER PRIMARY KEY,
  NAME         VARCHAR2(50),
  PHONE_NUMBER VARCHAR2(20)
);
INSERT INTO STUDENTS VALUES (1, 'Kim', '010-1234-5678');
INSERT INTO STUDENTS VALUES (2, 'Lee', NULL);
INSERT INTO STUDENTS VALUES (3, 'Park', '010-9999-8888');

-- 문제: 전화번호(PHONE_NUMBER)가 NULL인 경우 '정보 없음'으로 표시하고 NULL이 아닌 경우에는 
--      원래 가지고 있는 PHONE_NUMBER를 출력하시오.(NVL사용)
SELECT name, nvl(phone_number, '정보 없음') 
  FROM students; 

CREATE TABLE BOOKS (
  BOOK_ID     NUMBER PRIMARY KEY,
  TITLE       VARCHAR2(100),
  DISCOUNT    NUMBER
);
INSERT INTO BOOKS VALUES (1, '데이터베이스', 10);
INSERT INTO BOOKS VALUES (2, '자바 입문', NULL);
INSERT INTO BOOKS VALUES (3, '파이썬 실전', 5);

-- 문제: DISCOUNT가 있는 책은 '할인 중', DISCOUNT가 NULL인 책은 '정가 판매'로 출력하시오.(NVL2사용)
SELECT title
      ,nvl2(discount, '할인 중' , '정가 판매') AS 할인상태 
      ,nvl2(discount, discount || '%', '없음') AS 할인율
FROM books;
      
-- 기타함수
-- greatest(), least()
SELECT greatest(1,2,3,2) FROM DUAL;
SELECT least(1,2,3,2) FROM DUAL;

-- decode(수식, 검색1, 결과1, 검색2, 결과2, ..., default) 함수 
--   -> 수식과 검색1을 비교해서 같으면 결과1이고 같지 않으면 검색2와 비교해서 같으면 결과2이고 같지 않으면 검색3...
SELECT * FROM EMPLOYEES;

-- 사용 예제
SELECT
  employee_id,
  emp_name,
  department_id,
  DECODE(department_id,
         10, '회계부',
         20, '인사부',
         30, '영업부',
         40, '개발부',
         '기타') AS department_name
FROM employees;

SELECT
  emp_name,
  commission_pct,
  DECODE(commission_pct,
         NULL, '커미션 없음',
         0,    '커미션 없음',
         '커미션 있음') AS commission_status
FROM employees;
