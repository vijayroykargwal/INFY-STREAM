set SERVEROUTPUT ON;
--Anonymous block
declare
v_first_name EMPLOYEES.FIRST_NAME%type;
v_last_name EMPLOYEES.laST_NAME%type;
BEGIN
  select first_name,last_name into v_first_name,v_last_name 
  from EMPLOYEES where employee_id=100;
  dbms_output.put_line(v_first_name);
  dbms_output.put_line(v_last_name);
END;

--create a stored fucntion
create or replace function sf_get_emp_name(p_employee_id NUMBER)
return varchar2
as
v_first_name EMPLOYEES.FIRST_NAME%type;
v_last_name EMPLOYEES.laST_NAME%type;
BEGIN
  select first_name,last_name,salary into v_first_name,v_last_name
  from EMPLOYEES where employee_id=p_employee_id;
  return v_first_name||' '||v_last_name;
END;


--test the stored function from anonymous block
declare 
v_ful_name varchar2(500);
begin 
v_ful_name:=sf_get_emp_name(100);
DBMS_OUTPUT.put_line(v_ful_name);
end;


--You can also call this stored function from select query
select sf_get_emp_name(100) from dual;


