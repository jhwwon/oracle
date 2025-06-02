-- SELECT(데이터 조회), INSERT(데이터 삽입)
-- UPDATE(데이터 수정)
--   -> UPDATE [스키마명].테이블명 SET 컬럼1 = 변경값1, 컬럼2 = 변경값2, ... WHERE 조건1, 조건2... 

SELECT * FROM ex3_1;

DROP TABLE ex3_1;

CREATE TABLE ex3_1 (
	col1    varchar2(10),
	col2    NUMBER,
	col3    timestamp
);

INSERT INTO ex3_1(col1, col2, col3) VALUES ('ABC', 10, '2014-01-27 11:57:38');
INSERT INTO ex3_1(col1, col2, col3) VALUES('DEF', 20, '2014-01-27 11:57:39');
INSERT INTO ex3_1(col1, col2, col3) VALUES('GHI', 10, '2014-01-27 12:00:57');
INSERT INTO ex3_1(col1, col2, col3) VALUES('GHI', 20, '');
INSERT INTO ex3_1(col1, col2, col3) VALUES('10', 10, '2014-01-01 00:00:00');

-- ex3_1테이블의 컬럼이름이 col2인 모든 데이터를 50으로 변경
UPDATE ex3_1 SET col2 = 50;

SELECT * FROM ex3_1;

SELECT * FROM ex3_1 WHERE col3 = '';

-- ex3_1테이블의 컬럼이름이 col3인 데이터 중에서 col3의 값이 없는 경우('') 현재시간으로 변경
UPDATE ex3_1 SET col3 = sysdate WHERE col3 = '';

-- ex3_1테이블의 컬럼이름이 col3인 데이터 중에서 col3의 값이 null 경우 현재시간으로 변경
UPDATE ex3_1 SET col3 = sysdate WHERE col3 is null;

-- 문제: ex3_1테이블의 컬럼이름이 col1인 데이터 중에서 col1의 값이 ABC인 경우 col2의 값을 30으로 변경
UPDATE ex3_1 SET col2 = 30 WHERE col1 = 'ABC';

-- 문제: ex3_1테이블의 컬럼이름이 col1인 데이터 중에서 col1의 값이 DEF인 경우 col3의 값을 현재시간으로 변경
UPDATE ex3_1 SET col3 = sysdate WHERE col1 = 'DEF';

-- 문제: ex3_1테이블의 컬럼이름이 col2인 데이터 중에서 col2의 값이 30이고 col1의 값이 GHI인 데이터들 중에서
--      col2의 값은 10, col3의 값은 현재시간으로 변경
UPDATE ex3_1 SET col2 = 10, col3 = sysdate WHERE col2 = 30 AND col1 = 'GHI';

-- 문제: col1이 '10'(문자열)이면서 col2가 10인 행의 col1 값을 'TEN'으로 변경하시오.
UPDATE ex3_1 SET col1 = 'TEN' WHERE col1 = '10' AND col2 = 10;

-- 문제: col3이 '2014-01-27 12:00:00'보다 이전인 경우, col2 값을 0으로 변경하시오.
UPDATE ex3_1 SET col2 = 0 WHERE col3 < '2014-01-27 12:00:00' 
;

UPDATE ex3_1 SET col2 = 0 WHERE col3 < TO_TIMESTAMP('2014-01-27 12:00:00', 'YYYY-MM-DD HH24:MI:SS') 
;

SELECT * FROM ex3_1 WHERE col3 < '2014-01-27 12:00:00' 
;

-- 문제: col1 = 'GHI'로 중복된 행 중에서 col2 = 10인 행의 col2 값을 100으로 수정하시오.
SELECT * FROM ex3_1 WHERE col1 = 'GHI' AND col2 = 10;

UPDATE ex3_1 SET col2 = 100 WHERE col1 = 'GHI' AND col2 = 10;


-- MERGE문
--   MERGE INTO [스키마명].테이블명 USING (데이터의 원천(SELECT)) ON insert or update될 조건
--   	WHEN MATCHED THEN SET 컬럼1 = 값1, 컬럼2 = 값2, ... WHERE update조건
--          DELETE WHERE update및delete 조건
--      WHEN NOT MATCHED THEN INSERT (컬럼1, 컬럼2, ...) VALUES(값1, 값2, ... WHERE insert조건

CREATE TABLE ex3_3 (
	employee_id		NUMBER,
	bonus_amt		NUMBER 		DEFAULT 0
);

CREATE TABLE sales (
	prod_id				number(6,0)		NOT NULL,		-- 상품ID(번호)
	cust_id				number(6,0)		NOT NULL,		-- 고객ID(번호)
	channel_id			number(6,0)		NOT NULL,		-- 채널ID(번호)
	employee_id			number(6,0)		NOT NULL,		-- 직원ID(번호)
	sales_date			DATE			DEFAULT sysdate 	NOT NULL, -- 판매월일
	sales_month			varchar2(6),					-- 판매한 년월
	quantity_sold		number(10, 2),					-- 판매수량
	amount_sold			number(10, 2),					-- 판매금액
	create_date			DATE			DEFAULT sysdate,
	update_date			DATE			DEFAULT sysdate
);

INSERT INTO ex3_3 (employee_id)
SELECT e.employee_id 
  FROM employees e, sales s
 WHERE e.employee_id = s.employee_id
   AND s.SALES_MONTH BETWEEN '200010' AND '200012'
 GROUP BY e.employee_id
;

INSERT INTO ex3_3 VALUES(148, 0);
INSERT INTO ex3_3 VALUES(153, 0);
INSERT INTO ex3_3 VALUES(154, 0);
INSERT INTO ex3_3 VALUES(155, 0);
INSERT INTO ex3_3 VALUES(161, 0);

SELECT * FROM ex3_3;

-- employee_id -> 148, 153, 154, 155, 161(manager_id가 146)  -> bonus_amt의 값을 update
SELECT employee_id, manager_id, salary, salary * 0.01
  FROM EMPLOYEES
 WHERE employee_id IN (SELECT employee_id FROM ex3_3)
;

-- employee_id -> 156, 157, 158, 159, 160  -> employee_id값과 bonus_amt의 값을 insert  
SELECT employee_id, manager_id, salary, salary * 0.001
  FROM EMPLOYEES
 WHERE employee_id NOT IN (SELECT employee_id FROM ex3_3)
   AND manager_id = 146
;

SELECT employee_id, manager_id, salary FROM EMPLOYEES WHERE manager_id = 146;

-- insert와 update 동시에 사용하기 위한 merge문
MERGE INTO ex3_3 d
	USING (SELECT employee_id, manager_id, salary FROM EMPLOYEES WHERE manager_id = 146) b
	   ON (d.employee_id = b.employee_id)
  WHEN MATCHED THEN  -- update문(161)
      UPDATE SET d.bonus_amt = d.bonus_amt + b.salary * 0.01
  WHEN NOT MATCHED THEN -- insert문(160)
  	  INSERT (d.employee_id, d.bonus_amt) VALUES (b.employee_id, b.salary * 0.001) WHERE b.salary < 8000
;

SELECT * FROM ex3_3;

-- 문제: ex3_3의 employee_id가 employees와 일치하면 bonus_amt를 salary * 0.1로 갱신하는 코드를 만드시오
MERGE INTO ex3_3 b
--	USING (SELECT * FROM employees) e ON (b.employee_id = e.employee_id)
	USING employees e ON (b.employee_id = e.employee_id)
  WHEN MATCHED THEN
  	UPDATE SET b.bonus_amt = e.salary * 0.1
;

-- 문제: ex3_3에서 존재하지 않는 employees의 사원 정보를 bonus_amt = 0으로 삽입하시오
-- (단, department_id = 80인 경우)
MERGE INTO ex3_3 b
	USING (SELECT employee_id FROM employees WHERE department_id = 80) e
	   ON (b.employee_id = e.employee_id)
  WHEN NOT MATCHED THEN
  	INSERT (employee_id, bonus_amt) VALUES (e.employee_id, 0)
;

SELECT * FROM ex3_3;

SELECT * FROM EMPLOYEES;

-- 문제: employees 중 commission_pct >= 0.2인 사원만을 대상으로
--      bonus_amt를 salary * commission_pct로 설정하고 없으면 삽입하시오.
MERGE INTO ex3_3 b
	USING (SELECT * FROM employees WHERE commission_pct >= 0.2) e
	   ON (b.employee_id = e.employee_id)
  WHEN MATCHED THEN
  	UPDATE SET b.bonus_amt = e.salary * e.commission_pct
  WHEN NOT MATCHED THEN	   
    INSERT (employee_id, bonus_amt) VALUES (e.employee_id, e.salary * e.commission_pct)
;

SELECT * FROM EMPLOYEES;

-- 문제: employee_id가 154인 경우만 bonus_amt를 500으로 수정하고 존재하지 않으면 삽입하시오.
MERGE INTO ex3_3 b
	USING (SELECT a.*, 500 bonus_amt FROM EMPLOYEES a WHERE a.employee_id = 154) e
	--USING (SELECT 154 employee_id, 500 bonus_amt FROM dual) e
	   ON (b.employee_id = e.employee_id)
  WHEN MATCHED THEN
--  	UPDATE SET b.bonus_amt = 500
	  UPDATE SET b.bonus_amt = e.bonus_amt
  WHEN NOT MATCHED THEN	   
    INSERT (employee_id, bonus_amt) VALUES (e.employee_id, e.bonus_amt)
;

SELECT * FROM ex3_3;

-- 문제: employee_id가 153이고, 현재 bonus_amt가 0이면 100으로 수정하시오.(when match만 사용해도 됨)
MERGE INTO ex3_3 b
	 USING (SELECT * FROM ex3_3 WHERE bonus_amt = 0) e
	    ON (b.employee_id = e.employee_id)
  WHEN MATCHED THEN
	UPDATE SET bonus_amt = 100 
;

-- 문제: employees에서 job_id가 'SA_REP'인 사원의 bonus_amt를 salary * 0.05로 반영하고 없으면 삽입하시오.
MERGE INTO ex3_3 b
	 USING (SELECT * FROM employees에서 WHERE job_id = 'SA_REP') e
	    ON (b.employee_id = e.employee_id)
  WHEN MATCHED THEN
	UPDATE SET bonus_amt = e.salary * 0.05
  WHEN NOT MATCHED THEN	   
    INSERT (employee_id, bonus_amt) VALUES (e.employee_id, e.salary * 0.05)
;

-- 문제: employees에서 hire_date가 2000년 이후인 사원의 bonus_amt를 salary * 0.03으로 갱신 또는 삽입하시오.
MERGE INTO ex3_3 b
	 USING (SELECT * FROM employees에서 WHERE hire_date >= TO_DATE('2000-01-01', 'YYYY-MM-DD') e
	    ON (b.employee_id = e.employee_id)
  WHEN MATCHED THEN
	UPDATE SET bonus_amt = e.salary * 0.03
  WHEN NOT MATCHED THEN	   
    INSERT (employee_id, bonus_amt) VALUES (e.employee_id, e.salary * 0.03)
    
-- 문제: employees 중 salary가 8000 이상인 사원은 bonus_amt를 1000으로 갱신하고, 존재하지 않으면 삽입하시오.
MERGE INTO ex3_3 b
	 USING (SELECT * FROM employees WHERE salary >= 8000) e
	    ON (b.employee_id = e.employee_id)
  WHEN MATCHED THEN
	UPDATE SET bonus_amt = 1000
  WHEN NOT MATCHED THEN	   
    INSERT (employee_id, bonus_amt) VALUES (e.employee_id, 1000)

-- 문제: bonus_amt가 0이 아닌 사원만 bonus_amt를 bonus_amt + 100으로 증가시키시오.
MERGE INTO ex3_3 b
	 USING (SELECT * FROM ex3_3 WHERE bonus_amt <> 0) e
	    ON (b.employee_id = e.employee_id)
  WHEN MATCHED THEN
	UPDATE SET bonus_amt = bonus_amt + 100 
	DELETE WHERE (b.employee_id = 161)
;

SELECT * FROM ex3_3;
    
-- 문제: employees의 department_id가 50인 사원 중 ex3_3에 없는 사원은 bonus_amt 300으로 추가하시오
MERGE INTO ex3_3 b
	 USING (SELECT * FROM employees WHERE department_id = 50) e
	    ON (b.employee_id = e.employee_id)
  WHEN NOT MATCHED THEN	   
    INSERT (employee_id, bonus_amt) VALUES (e.employee_id, 300)
;
	
SELECT * FROM ex3_3;    

-- DELETE문(DELETE FROM [스키마명].테이블명 WHERE 조건1, 조건2)
DELETE FROM EX3_3;  -- EX3_3테이블의 모든 데이터 삭제

DELETE FROM EX3_3 WHERE employee_id IN (189, 127, 134);
    
-- TRUNCATE문
TRUNCATE TABLE EX3_3;

SELECT MY_SEQ1.NEXTVAL FROM DUAL;
SELECT MY_SEQ1.CURRVAL FROM DUAL;

-- ROWNUM: 쿼리에서 반환되는 각 로우들의 순서 값
SELECT rownum, employee_id FROM employees;

SELECT rownum, employee_id FROM employees WHERE rownum < 5;

SELECT rownum, employee_id, rowid FROM employees WHERE rownum < 5;


-- ROWID

-- 오라클에서 지원하는 함수 모음
-- 1. 숫자 함수
--   (1) abs(n)함수: 절대값을 반환하는 함수
SELECT abs(-1) abs1 FROM dual;
SELECT abs(10), abs(-10), abs(-10.123) FROM dual;
--   (2) ceil(n)함수: 올림함수
SELECT ceil(10.123), ceil(10.541), ceil(11.001) FROM dual;
--   (3) floor(n)함수: 내림함수
SELECT FLOOR(10.123), FLOOR(10.541), FLOOR(11.001) FROM DUAL;
--   (4) round(n, i)함수: 반올림함수(n은 실제값, i는 소수점 기준 i+1번째에 반올림하기 위한 값(i는 생략가능))
SELECT ROUND(10.154), ROUND(10.541), ROUND(11.001) FROM DUAL;  -- i가 없는 소수점 첫번째자리 기준
SELECT ROUND(10.154, 1), ROUND(10.154, 2), ROUND(10.154, 3) FROM DUAL;
SELECT ROUND(0, 3), ROUND(115.155, -1), ROUND(115.155, -2) FROM DUAL;   




