-- '--'는 SQL 주석을 뜻함

-- Oracle 19c에 사용자 생성을 위한 스크립트 코드
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;

-- Oracle 사용자 생성(id: raymon1,  pw: 1234)
CREATE USER raymon1 IDENTIFIED BY 1234;

-- 롤(권한) 부여
GRANT CONNECT, RESOURCE, DBA TO raymon1;
-- GRANT INSERT ON raymon1.EX2_1 TO raymon1;
GRANT CREATE VIEW TO 여러분계정;

-- 데이터 저장이 가능하도록 테이블스페이스 조정
ALTER USER raymon1 DEFAULT TABLESPACE users quota unlimited ON users;


