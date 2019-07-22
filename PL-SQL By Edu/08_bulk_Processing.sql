set SERVEROUTPUT ON;
DECLARE
type type_employee_names is table OF varchar2(40);
col_employee_names type_employee_names :=type_employee_names();
v_index number(2):=0;
BEGIN
select first_name BULK COLLECT into  col_employee_names from employees where department_id=50;
--for rec_dep_name in (select first_name from employees where department_id=50)
--loop
--col_employee_names.extend;
--v_index:=v_index+1;
--col_employee_names(v_index):=rec_dep_name.first_name;
--end loop;

--for v_index in col_employee_names.first..col_employee_names.count
--loop
----DBMS_OUTPUT.PUT_LINE(col_employee_names(v_index));
--update employees set first_name=first_name||'_1' where first_name= col_employee_names(v_index);
--end loop;


--context switch -25
--Query execution -25

FORALL v_f_name IN col_employee_names.FIRST .. col_employee_names.LAST save exceptions
  update employees set employee_id=100 where first_name= col_employee_names(v_f_name);
 
--context switch -1
--Query execution -25
Exception
when others then 
for i in 1..SQL%BULK_EXCEPTIONS.count
loop
DBMS_OUTPUT.PUT_LINE(SQL%BULK_EXCEPTIONS(i).ERROR_INDEX);
DBMS_OUTPUT.PUT_LINE(SQL%BULK_EXCEPTIONS(i).ERROR_CODE);
DBMS_OUTPUT.PUT_LINE('--------------------------------------');
end loop;
END;


begin 
  update employees set employee_id=100 where employee_id= 101;
end ;

select * from employees where department_id=50;
update employees set first_name=first_name||'_1' where employee_id=100;






















