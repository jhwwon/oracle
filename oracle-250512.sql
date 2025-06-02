-- rollup, cube절(only 오라클)
SELECT *
  FROM kor_loan_status
;

-- rollup은 추가적인 집계 정보
SELECT period, gubun, SUM(loan_jan_amt) totl_jan
  FROM kor_loan_status
 WHERE period LIKE '2013%' 
 GROUP BY period, gubun
 ORDER BY period
;

SELECT period, gubun, SUM(loan_jan_amt) totl_jan
  FROM kor_loan_status
 WHERE period LIKE '2013%' 
 GROUP BY ROLLUP(period, gubun)
;

SELECT period, gubun, COUNT(loan_jan_amt) totl_jan
  FROM kor_loan_status
 WHERE period LIKE '2013%' 
 GROUP BY ROLLUP(period, gubun)
;

SELECT period, gubun, SUM(loan_jan_amt) totl_jan
  FROM kor_loan_status
 WHERE period LIKE '2013%' 
 GROUP BY period, ROLLUP(gubun)
;

SELECT period, gubun, SUM(loan_jan_amt) totl_jan
  FROM kor_loan_status
 WHERE period LIKE '2013%' 
 GROUP BY ROLLUP(period), gubun
;

-- cube절
SELECT period, gubun, SUM(loan_jan_amt) totl_jan
  FROM kor_loan_status
 WHERE period LIKE '2013%' 
 GROUP BY CUBE(period, gubun)
;

SELECT period, gubun, SUM(loan_jan_amt) totl_jan
  FROM kor_loan_status
 WHERE period LIKE '2013%' 
 GROUP BY period, CUBE(gubun)
;

-- 집합연산자(UNION(합집합), MINUS(차집합), INTERSECT(교집합))
CREATE TABLE exp_goods_asia (
       country VARCHAR2(10),
       seq     NUMBER,
       goods   VARCHAR2(80)
);
       
INSERT INTO exp_goods_asia VALUES ('한국', 1, '원유제외 석유류');
INSERT INTO exp_goods_asia VALUES ('한국', 2, '자동차');
INSERT INTO exp_goods_asia VALUES ('한국', 3, '전자집적회로');
INSERT INTO exp_goods_asia VALUES ('한국', 4, '선박');
INSERT INTO exp_goods_asia VALUES ('한국', 5,  'LCD');
INSERT INTO exp_goods_asia VALUES ('한국', 6,  '자동차부품');
INSERT INTO exp_goods_asia VALUES ('한국', 7,  '휴대전화');
INSERT INTO exp_goods_asia VALUES ('한국', 8,  '환식탄화수소');
INSERT INTO exp_goods_asia VALUES ('한국', 9,  '무선송신기 디스플레이 부속품');
INSERT INTO exp_goods_asia VALUES ('한국', 10,  '철 또는 비합금강');
INSERT INTO exp_goods_asia VALUES ('일본', 1, '자동차');
INSERT INTO exp_goods_asia VALUES ('일본', 2, '자동차부품');
INSERT INTO exp_goods_asia VALUES ('일본', 3, '전자집적회로');
INSERT INTO exp_goods_asia VALUES ('일본', 4, '선박');
INSERT INTO exp_goods_asia VALUES ('일본', 5, '반도체웨이퍼');
INSERT INTO exp_goods_asia VALUES ('일본', 6, '화물차');
INSERT INTO exp_goods_asia VALUES ('일본', 7, '원유제외 석유류');
INSERT INTO exp_goods_asia VALUES ('일본', 8, '건설기계');
INSERT INTO exp_goods_asia VALUES ('일본', 9, '다이오드, 트랜지스터');
INSERT INTO exp_goods_asia VALUES ('일본', 10, '기계류');

SELECT goods
  FROM exp_goods_asia
 WHERE country = '한국'
 ORDER BY seq
;

SELECT goods
  FROM exp_goods_asia
 WHERE country = '일본'
 ORDER BY seq
;

-- 임시테이블1(SELECT) UNION 임시테이블2(SELECT) (조건: 임시테이블들의 컬럼의 개수가 반드시 일치)
SELECT goods, country
  FROM exp_goods_asia
 WHERE country = '한국'
UNION
SELECT goods, country
  FROM exp_goods_asia
 WHERE country = '일본'
;

-- 임시테이블1(SELECT) UNION ALL 임시테이블2(SELECT) (조건: 임시테이블들의 컬럼의 개수가 반드시 일치)
SELECT goods
  FROM exp_goods_asia
 WHERE country = '한국'
UNION ALL
SELECT goods
  FROM exp_goods_asia
 WHERE country = '일본'
;

SELECT country
  FROM exp_goods_asia
 WHERE country = '한국'
UNION ALL
SELECT country
  FROM exp_goods_asia
 WHERE country = '일본'
;

-- chapter 5장 문제 3번
SELECT period, gubun, SUM(loan_jan_amt) totl_jan
  FROM kor_loan_status
 WHERE period LIKE '2013%' 
 GROUP BY period, ROLLUP(gubun)
;

SELECT period, gubun, SUM(loan_jan_amt) totl_jan
  FROM kor_loan_status
 WHERE period LIKE '2013%' 
 GROUP BY period, gubun
UNION
SELECT period, NULL AS gubun, SUM(loan_jan_amt) totl_jan
  FROM kor_loan_status
 WHERE period LIKE '2013%' 
 GROUP BY period
ORDER BY period
;

-- chapter 5장 문제 4번
SELECT period, 
       CASE WHEN gubun = '주택담보대출' THEN SUM(loan_jan_amt) ELSE 0 END 주택담보대출액,
       CASE WHEN gubun = '기타대출'    THEN SUM(loan_jan_amt) ELSE 0 END 기타대출액 
  FROM kor_loan_status
 WHERE period = '201311' 
 GROUP BY period, gubun
;

SELECT period, 0 AS 주택담보대출액, sum(LOAN_JAN_AMT) AS 기타대출액
  FROM kor_loan_status
 WHERE PERIOD = '201311'
   AND gubun = '기타대출'
 GROUP BY period 
UNION
SELECT period, sum(LOAN_JAN_AMT) AS 주택담보대출액, 0 AS 기타대출액
  FROM kor_loan_status
 WHERE PERIOD = '201311'
   AND gubun = '주택담보대출'
 GROUP BY period
;

-- INTERSECT(교집합)
SELECT goods
  FROM exp_goods_asia
 WHERE country = '한국'
INTERSECT
SELECT goods
  FROM exp_goods_asia
 WHERE country = '일본'
; 

-- MINUS(차집합) -> 임시테이블1 MINUS 임시테이블2  (임시테이블1 - 임시테이블2)
SELECT goods
  FROM exp_goods_asia
 WHERE country = '한국'
MINUS
SELECT goods
  FROM exp_goods_asia
 WHERE country = '일본'
ORDER BY goods
;

-- 집합연산자 추가문제(테이블은 kor_loan_status)
SELECT *
  FROM KOR_LOAN_STATUS
;

-- 문제1: 201311 기간에 광주 또는 대전 지역에서 발생한 대출 데이터를 가져오되, 중복을 제거하여 한 번만 출력하세요
SELECT region, gubun, LOAN_JAN_AMT 
  FROM KOR_LOAN_STATUS
 WHERE period = '201311'
   AND region IN ('광주')
UNION
SELECT region, gubun, LOAN_JAN_AMT 
  FROM KOR_LOAN_STATUS
 WHERE period = '201311'
   AND region IN ('대전')
;

-- 문제2: 광주와 대전에서 발생한 전체 대출 데이터를 중복 포함해서 모두 출력하세요.
SELECT region, gubun, LOAN_JAN_AMT 
  FROM KOR_LOAN_STATUS
 WHERE period = '201311'
   AND region IN ('광주')
UNION ALL
SELECT region, gubun, LOAN_JAN_AMT 
  FROM KOR_LOAN_STATUS
 WHERE period = '201311'
   AND region IN ('대전')
;

-- 문제3: 광주와 대전 지역에서 동일한 종류(GUBUN)의 대출, 동일한 금액(LOAN_JAN_AMT)으로 
--       동일한 기간(PERIOD)에 발생한 레코드를 찾으세요.
SELECT gubun, loan_jan_amt, period
  FROM KOR_LOAN_STATUS
 WHERE region IN ('광주')
INTERSECT 
SELECT gubun, loan_jan_amt, period
  FROM KOR_LOAN_STATUS
 WHERE region IN ('대전')
;

-- 문제4: 광주에서 발생했지만 대전에서는 발생하지 않은 대출 데이터를 찾으세요. 
--       (같은 기간 + 같은 GUBUN + 같은 금액 기준)
SELECT gubun, loan_jan_amt, period
  FROM KOR_LOAN_STATUS
 WHERE region IN ('광주')
MINUS
SELECT gubun, loan_jan_amt, period
  FROM KOR_LOAN_STATUS
 WHERE region IN ('대전')
;

-- 문제5: '서울'과 '경기'에서 발생한 대출 내역 중 서로 동일한 PERIOD, GUBUN, LOAN_JAN_AMT를 갖는 경우만 찾아보세요.
SELECT gubun, loan_jan_amt, period
  FROM KOR_LOAN_STATUS
 WHERE region IN ('서울')
INTERSECT 
SELECT gubun, loan_jan_amt, period
  FROM KOR_LOAN_STATUS
 WHERE region IN ('경기')
;

SELECT *
  FROM KOR_LOAN_STATUS; 
 
-- chapter 5장. 문제 5번

SELECT  a.region
      , sum(a.ljm1_201111) AS "201111"
      , sum(a.ljm2_201112) AS "201112"
      , sum(a.ljm7_201210) AS "201210"
      , sum(a.ljm3_201211) AS "201211"
      , sum(a.ljm4_201212) AS "201212"
      , sum(a.ljm5_201311) AS "201311"
  FROM (
  	SELECT region
  	      , CASE WHEN period = '201111' THEN loan_jan_amt ELSE 0 END ljm1_201111
  	      , CASE WHEN period = '201112' THEN loan_jan_amt ELSE 0 END ljm2_201112
  	      , CASE WHEN period = '201210' THEN loan_jan_amt ELSE 0 END ljm7_201210
  	      , CASE WHEN period = '201211' THEN loan_jan_amt ELSE 0 END ljm3_201211
  	      , CASE WHEN period = '201212' THEN loan_jan_amt ELSE 0 END ljm4_201212
  	      , CASE WHEN period = '201311' THEN loan_jan_amt ELSE 0 END ljm5_201311
  	  FROM KOR_LOAN_STATUS
  ) a
GROUP BY a.region
--ORDER BY 
;

-- 7장 조인(테이블 1개이상들을 연결할 때 사용하는 기능, 항상 alias를 사용)
--     서브쿼리(임시테이블들을 만들기 위해 쿼리 안에 또 다른 조회 쿼리들을 만들어서 사용하는 기능)

SELECT * FROM EMPLOYEES;
SELECT * FROM DEPARTMENTS;

-- 동등조인(EQUI) -> 등호연산자(=)를 사용하여 연결한 조인
SELECT a.*, b.*
  FROM EMPLOYEES a, 
       DEPARTMENTS b
 WHERE a.DEPARTMENT_ID = b.DEPARTMENT_ID    -- 동등조인
;

-- 세미조인 -> 서브 쿼리를 사용해서 서브 쿼리에 존재하는 데이터만 메인 쿼리에 조인하는 방법
--           IN, EXISTS 연산자에서 많이 사용

-- EXIST연산자 사용
SELECT a.department_id, a.department_name
  FROM departments a
 WHERE EXISTS (SELECT * 
                 FROM employees b
                WHERE a.department_id = b.department_id
                  AND b.salary > 3000)
ORDER BY a.department_name
;

-- IN 연산자 사용
SELECT a.department_id, a.department_name
  FROM departments a
 WHERE a.DEPARTMENT_ID IN (SELECT b.department_id 
			                 FROM employees b
			                WHERE a.department_id = b.department_id
			                  AND b.salary > 3000)
ORDER BY a.department_name
;

-- 동등조인
SELECT a.department_id, a.department_name
  FROM departments a, employees b
 WHERE a.department_id = b.department_id
   AND b.salary > 3000
ORDER BY a.department_name
;

-- ANTI(안티) 조인
SELECT a.employee_id, a.emp_name, a.department_id, b.department_name
  FROM employees a,
       departments b
 WHERE a.department_id = b.department_id
   AND a.department_id NOT IN (SELECT department_id
                                  FROM departments 
                                 WHERE manager_id IS NULL)
;

SELECT count(*)
  FROM employees a
 WHERE NOT EXISTS (SELECT 1
                     FROM departments c
                    WHERE a.department_id = c.department_id 
					  AND manager_id IS NULL)
;

-- chapter 6장. 1번 문제(departments, employees, job_history, jobs 테이블 활용)
CREATE TABLE "JOBS" (	
	"JOB_ID" VARCHAR2(10) PRIMARY KEY, 
	"JOB_TITLE" VARCHAR2(80) NOT NULL, 
	"MIN_SALARY" NUMBER(8,2) DEFAULT 0, 
	"MAX_SALARY" NUMBER(8,2) DEFAULT 0, 
	"CREATE_DATE" DATE DEFAULT SYSDATE, 
	"UPDATE_DATE" DATE DEFAULT SYSDATE
);

COMMENT ON COLUMN JOBS.JOB_ID IS 'JOB ID';
COMMENT ON COLUMN JOBS.JOB_TITLE IS 'JOB명';
COMMENT ON COLUMN JOBS.MIN_SALARY IS '최소급여';
COMMENT ON COLUMN JOBS.MAX_SALARY IS '최대급여';
COMMENT ON COLUMN JOBS.CREATE_DATE IS '생성일자';
COMMENT ON COLUMN JOBS.UPDATE_DATE IS '변경일자';

INSERT INTO JOBS (JOB_ID,JOB_TITLE,MIN_SALARY,MAX_SALARY,CREATE_DATE,UPDATE_DATE) VALUES ('AD_PRES','President',20080,40000,TIMESTAMP'2014-01-08 13:52:48',TIMESTAMP'2014-01-08 13:52:48');
INSERT INTO JOBS (JOB_ID,JOB_TITLE,MIN_SALARY,MAX_SALARY,CREATE_DATE,UPDATE_DATE) VALUES ('AD_VP','Administration Vice President',15000,30000,TIMESTAMP'2014-01-08 13:52:48',TIMESTAMP'2014-01-08 13:52:48');
INSERT INTO JOBS (JOB_ID,JOB_TITLE,MIN_SALARY,MAX_SALARY,CREATE_DATE,UPDATE_DATE) VALUES ('AD_ASST','Administration Assistant',3000,6000,TIMESTAMP'2014-01-08 13:52:48',TIMESTAMP'2014-01-08 13:52:48');
INSERT INTO JOBS (JOB_ID,JOB_TITLE,MIN_SALARY,MAX_SALARY,CREATE_DATE,UPDATE_DATE) VALUES ('FI_MGR','Finance Manager',8200,16000,TIMESTAMP'2014-01-08 13:52:48',TIMESTAMP'2014-01-08 13:52:48');
INSERT INTO JOBS (JOB_ID,JOB_TITLE,MIN_SALARY,MAX_SALARY,CREATE_DATE,UPDATE_DATE) VALUES ('FI_ACCOUNT','Accountant',4200,9000,TIMESTAMP'2014-01-08 13:52:48',TIMESTAMP'2014-01-08 13:52:48');
INSERT INTO JOBS (JOB_ID,JOB_TITLE,MIN_SALARY,MAX_SALARY,CREATE_DATE,UPDATE_DATE) VALUES ('AC_MGR','Accounting Manager',8200,16000,TIMESTAMP'2014-01-08 13:52:48',TIMESTAMP'2014-01-08 13:52:48');
INSERT INTO JOBS (JOB_ID,JOB_TITLE,MIN_SALARY,MAX_SALARY,CREATE_DATE,UPDATE_DATE) VALUES ('AC_ACCOUNT','Public Accountant',4200,9000,TIMESTAMP'2014-01-08 13:52:48',TIMESTAMP'2014-01-08 13:52:48');
INSERT INTO JOBS (JOB_ID,JOB_TITLE,MIN_SALARY,MAX_SALARY,CREATE_DATE,UPDATE_DATE) VALUES ('SA_MAN','Sales Manager',10000,20080,TIMESTAMP'2014-01-08 13:52:48',TIMESTAMP'2014-01-08 13:52:48');
INSERT INTO JOBS (JOB_ID,JOB_TITLE,MIN_SALARY,MAX_SALARY,CREATE_DATE,UPDATE_DATE) VALUES ('SA_REP','Sales Representative',6000,12008,TIMESTAMP'2014-01-08 13:52:48',TIMESTAMP'2014-01-08 13:52:48');
INSERT INTO JOBS (JOB_ID,JOB_TITLE,MIN_SALARY,MAX_SALARY,CREATE_DATE,UPDATE_DATE) VALUES ('PU_MAN','Purchasing Manager',8000,15000,TIMESTAMP'2014-01-08 13:52:48',TIMESTAMP'2014-01-08 13:52:48');
INSERT INTO JOBS (JOB_ID,JOB_TITLE,MIN_SALARY,MAX_SALARY,CREATE_DATE,UPDATE_DATE) VALUES ('PU_CLERK','Purchasing Clerk',2500,5500,TIMESTAMP'2014-01-08 13:52:48',TIMESTAMP'2014-01-08 13:52:48');
INSERT INTO JOBS (JOB_ID,JOB_TITLE,MIN_SALARY,MAX_SALARY,CREATE_DATE,UPDATE_DATE) VALUES ('ST_MAN','Stock Manager',5500,8500,TIMESTAMP'2014-01-08 13:52:48',TIMESTAMP'2014-01-08 13:52:48');
INSERT INTO JOBS (JOB_ID,JOB_TITLE,MIN_SALARY,MAX_SALARY,CREATE_DATE,UPDATE_DATE) VALUES ('ST_CLERK','Stock Clerk',2008,5000,TIMESTAMP'2014-01-08 13:52:48',TIMESTAMP'2014-01-08 13:52:48');
INSERT INTO JOBS (JOB_ID,JOB_TITLE,MIN_SALARY,MAX_SALARY,CREATE_DATE,UPDATE_DATE) VALUES ('SH_CLERK','Shipping Clerk',2500,5500,TIMESTAMP'2014-01-08 13:52:48',TIMESTAMP'2014-01-08 13:52:48');
INSERT INTO JOBS (JOB_ID,JOB_TITLE,MIN_SALARY,MAX_SALARY,CREATE_DATE,UPDATE_DATE) VALUES ('IT_PROG','Programmer',4000,10000,TIMESTAMP'2014-01-08 13:52:48',TIMESTAMP'2014-01-08 13:52:48');
INSERT INTO JOBS (JOB_ID,JOB_TITLE,MIN_SALARY,MAX_SALARY,CREATE_DATE,UPDATE_DATE) VALUES ('MK_MAN','Marketing Manager',9000,15000,TIMESTAMP'2014-01-08 13:52:48',TIMESTAMP'2014-01-08 13:52:48');
INSERT INTO JOBS (JOB_ID,JOB_TITLE,MIN_SALARY,MAX_SALARY,CREATE_DATE,UPDATE_DATE) VALUES ('MK_REP','Marketing Representative',4000,9000,TIMESTAMP'2014-01-08 13:52:48',TIMESTAMP'2014-01-08 13:52:48');
INSERT INTO JOBS (JOB_ID,JOB_TITLE,MIN_SALARY,MAX_SALARY,CREATE_DATE,UPDATE_DATE) VALUES ('HR_REP','Human Resources Representative',4000,9000,TIMESTAMP'2014-01-08 13:52:48',TIMESTAMP'2014-01-08 13:52:48');
INSERT INTO JOBS (JOB_ID,JOB_TITLE,MIN_SALARY,MAX_SALARY,CREATE_DATE,UPDATE_DATE) VALUES ('PR_REP','Public Relations Representative',4500,10500,TIMESTAMP'2014-01-08 13:52:48',TIMESTAMP'2014-01-08 13:52:48');


SELECT * FROM EMPLOYEES WHERE EMPLOYEE_ID = 101;
SELECT * FROM DEPARTMENTS;
SELECT * FROM JOBS;
SELECT * FROM JOB_HISTORY;

사번(employees.employee_id)   사원명(employees.emp_name)    job명칭(jobs.job_title)    
job시작일자(job_history.start_date)    job종료일자(job_history.end_date)    
job수행부서명(departments.department_name)

SELECT e1.employee_id AS "사번"
      ,e1.emp_name AS "사원명"
      ,j1.job_title AS "job명칭"
      ,jh1.start_date AS "job시작일자"
      ,jh1.end_date AS "job종료일자"
      ,d1.department_name AS "job수행부서명"      
  FROM employees e1,
       jobs j1,
       job_history jh1,
       departments d1
 WHERE e1.employee_id = 101
   AND e1.employee_id = jh1.EMPLOYEE_ID
   AND d1.DEPARTMENT_ID = e1.DEPARTMENT_ID
   AND j1.JOB_ID = jh1.JOB_ID 
--   AND j1.JOB_ID = e1.JOB_ID 
--   AND e1.JOB_ID = jh1.JOB_ID 
;

    SELECT e1.employee_id AS "사번"
          ,e1.emp_name AS "사원명"
          ,j1.job_title AS "job명칭"
          ,jh1.start_date AS "job시작일자"
          ,jh1.end_date AS "job종료일자"
          ,d1.department_name AS "job수행부서명"      
      FROM employees e1
INNER JOIN jobs j1 ON j1.JOB_ID = e1.job_id
INNER JOIN job_history jh1 ON jh1.employee_id = e1.employee_id
INNER JOIN departments d1 ON d1.DEPARTMENT_ID = e1.DEPARTMENT_ID 
      WHERE e1.employee_id = 101
;


SELECT * FROM EMPLOYEES WHERE EMPLOYEE_ID = 101;
SELECT * FROM JOBS WHERE job_id = 'AD_VP';
SELECT * FROM JOB_HISTORY jh1 WHERE job_id = 'AD_VP';

INSERT INTO JOB_HISTORY VALUES (101, '2010-01-01', '2010-05-10', 'AD_VP', 90, sysdate, sysdate);

DELETE FROM JOB_HISTORY WHERE job_id = 'AD_VP';

-- 셀프조인
SELECT a.employee_id, a.emp_name, b.employee_id, b.emp_name, a.department_id
  FROM employees a,
       employees b
 WHERE a.employee_id < b.employee_id      
   AND a.department_id = b.department_id
   AND a.department_id = 20
;

-- ANSI 조인(모든 DBMS에 호환이 되는 조인 문법)
SELECT a.*, b.*
  FROM EMPLOYEES a 
  INNER JOIN DEPARTMENTS b ON a.DEPARTMENT_ID = b.DEPARTMENT_ID 
;
  
SELECT a.*, b.*
  FROM EMPLOYEES a, 
       DEPARTMENTS b
 WHERE a.DEPARTMENT_ID = b.DEPARTMENT_ID    -- 동등조인
;