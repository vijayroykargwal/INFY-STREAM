create table employee_info_9767(
EMP_NAME Varchar2(36),
HIRE_DATE DATE,
department varchar2(15),
salary number,
new_salary number,
UPDATED_DATE DATE,
STATUS VARCHAR2(25),
ERROR_MESSAGE VARCHAR2(25)
);

select * from employee_info_9767

create sequence seq_employee_id_9767
start with 1001;

drop table employee_info_9767;
truncate table employee_info_9767;
