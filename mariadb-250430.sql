-- MariaDB 테이블 이름 testtable1 생성
create table testtable1 (
	column1 char(10),
	column2 varchar(10),
	column3 int
);

-- testtable1 테이블 데이터 입력
insert into testtable1 (column1, column2) values ('abc', 'abc');

-- testtable1 테이블의 들어간 데이터 조회
select column1, length(column1) as len1,
       column2, length(column2) as len2
from testtable1;

-- 테이블 ex2_2 생성
CREATE TABLE ex2_2 ( 
	column1		varchar(9)
);

-- 테이블 ex2_2에 데이터 입력
INSERT INTO ex2_2(column1) VALUES ('abc');

SELECT column1, LENGTH(column1) AS len1
FROM ex2_2;

desc ex2_2;

describe testtable1;

-- 현재시간 가져오기
select now(), now();

''   ""    ``

create table `order` (

)


