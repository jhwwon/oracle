-- mariadb의 날짜 데이터 타입
CREATE TABLE ex2_5 (
	col_date         DATE,                  -- 값이 없어도 되는 컬럼
	col_timestamp    timestamp NOT NULL     -- 값이 무조건 있어야 되는 컬럼
);

INSERT INTO ex2_5 VALUES (now(), now());

select * from ex2_5; 

CREATE TABLE ex2_6 (
	col_datetime         DATETIME
);

INSERT INTO ex2_6 VALUES (now());

select * from ex2_6;




