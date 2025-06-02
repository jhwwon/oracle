-- 테이블 복사 방법(새로운 테이블에 기존 테이블의 데이터를 똑같이 복사)
--   (CREATE TABLE [스키마명].사본테이블명 AS SELECT 컬럼1, 컬럼2, ...(*(모든컬럼)) FROM 복사할 테이블명)
DROP TABLE ex2_9;

CREATE TABLE ex2_9 (
	num1	NUMBER,
	CONSTRAINTS check1 check( num1 BETWEEN 1 AND 9),   -- num1의 컬럼값은 1~9까지만 허용
	gender  varchar2(10),
	CONSTRAINTS check2 check( gender IN ('MALE', 'FEMALE') ) -- gender의 컬럼값은 'MALE', 'FEMALE'만 허용
);

INSERT INTO ex2_9 values(5, 'FEMALE');
INSERT INTO ex2_9 values(6, 'MALE');

SELECT * FROM ex2_9;

-- 테이블 ex2_9를 ex2_9_1로 테이블을 생성하여 데이터를 모두 복사
CREATE TABLE ex2_9_1 AS SELECT * FROM ex2_9;

SELECT * FROM ex2_9_1;

CREATE TABLE ex2_9_2 AS
SELECT
	*
FROM
	ex2_9
;

SELECT * FROM ex2_9_2;


-- VIEW 생성하기
--   CREATE OR REPLACE VIEW [스키마명].뷰이름 AS SELECT 문장(컬럼1, 컬럼2) FROM 테이블들... [WHERE 조건식]
-- VIEW 조회하기
--   SELECT 컬럼명1, ... FROM 뷰이름

CREATE OR REPLACE VIEW ex2_9_v1 AS SELECT num1 FROM ex2_9;

SELECT * FROM ex2_9_v1;
SELECT num1 FROM ex2_9_v1;
SELECT genger FROM ex2_9_v1; -- error(ex2_9_v1 뷰는 gender를 가지고 있지 않기 때문)

-- VIEW 삭제하기
--   DROP VIEW [스키마명].뷰이름

DROP VIEW ex2_9_v1;



-- chapter2장 문제1
DROP TABLE "ORDER";

CREATE TABLE "ORDER" (
	"order_id" 		number(12, 0),
	"order_date"	DATE,
	order_mode 		varchar2(8 byte),
	customer_id		number(6,0),
	order_status	number(2,0),
	order_total		number(8,2) 	DEFAULT 0,
	sales_rep_id	number(6,0),
	promotion_id	number(6,0),
	CONSTRAINT pk_order PRIMARY KEY ("order_id"),
	CONSTRAINT ck_order_mode CHECK (order_mode IN ('direct', 'online'))
);

CREATE TABLE "ex2_2_15" (
	col1 NUMBER,
	col2 varchar2(10)
);

-- chapter2 2번문제
CREATE TABLE ORDER_ITEMS (
   ORDER_ID	    NUMBER(12,0),
   LINE_ITEM_ID NUMBER(3,0) ,
   ORDER_MODE	VARCHAR2(8 BYTE),
   PRODUCT_ID   NUMBER(3,0), 
   UNIT_PRICE   NUMBER(8,2) DEFAULT 0, 
   QUANTITY     NUMBER(8,0) DEFAULT 0,
   CONSTRAINT PK_ORDER_ITEMS PRIMARY KEY (ORDER_ID, LINE_ITEM_ID)
); 

-- chapter2 3번문제
CREATE TABLE PROMOTIONS (
   PROMO_ID	    NUMBER(6,0),
   PROMO_NAME	VARCHAR2(8 BYTE),
   CONSTRAINT   PK_PROMOTIONS PRIMARY KEY (PROMO_ID)
); 


-- 시퀀스(SEQUENCE) 생성하는 방법
--    CREATE SEQUENCE [스키마명].시퀀스명 INCREMENT BY 증감숫자 START WITH 시작숫자 (p83참고)

-- my_seq1 시퀀스 생성
CREATE SEQUENCE my_seq1 INCREMENT BY 1 START WITH 1 MINVALUE 1 MAXVALUE 9999999999999999 NOCYCLE NOCACHE;

DROP TABLE ex2_8;

CREATE TABLE ex2_8 (
	col1    varchar2(10)    PRIMARY KEY,   -- col1의 값들은 unique하며 NOT null이어야 한다.
	col2    varchar2(10)    
);

-- 불특정 다수, 불특정 시간, 동시(충돌)에 SQL사용

-- my_seq1 시퀀스 사용1(my_seq1.NEXTVAL 현재값의 1 더한 값)
INSERT INTO ex2_8 (col1) VALUES (my_seq1.nextval);

SELECT * FROM ex2_8;

-- my_seq1의 현재값 확인(my_seq1.CURRVAL)
SELECT my_seq1.currval FROM dual;

INSERT INTO ex2_8 (col1, col2) VALUES (my_seq1.nextval, '홍길동');
INSERT INTO ex2_8 (col1, col2) VALUES (my_seq1.nextval, '유관순');

-- 시퀀스 삭제(DROP SEQUENCE [스키마명].시퀀스명)
DROP SEQUENCE my_seq1;

-- 문제5의 정답
CREATE SEQUENCE ORDERS_SEQ
MINVALUE 1 
MAXVALUE 99999999
INCREMENT BY 1 
START WITH 1000
;


