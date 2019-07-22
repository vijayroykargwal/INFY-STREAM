--Collections in PLSQL
--
--1.Varray
--
--size is limited 
--Dense collection
--delete --> deletes all the values
--
--
--
--2.nested table
--
--size is unlimited
--dense in beggining and can be sparse later
--extend required to allocate memory /and 
-->delete can delete specific index position value
--
--3.associative arrays   -  like dictionary 
--
--no limit
--no constructor
--no extend required
--key-value pair
----Keys will be of type BINARY_INTEGER  |  PLS_INTEGER  |  VARCHAR2(size_limit)
----Key will get arranged   Ascending order  alphabatical order
--
--


--Example 1 -varray 
set SERVEROUTPUT ON;

DECLARE
type type_emplyee_names is varray(3) OF varchar2(40);
col_employee_names type_emplyee_names :=type_emplyee_names();
BEGIN
col_employee_names.extend;   
col_employee_names(1):='Yogesh';   
DBMS_OUTPUT.PUT_LINE(col_employee_names(1));
col_employee_names.extend;  
col_employee_names(2):='Aakash'; 
DBMS_OUTPUT.PUT_LINE(col_employee_names(2));
col_employee_names.extend;  
col_employee_names(3):='Manisha'; 
DBMS_OUTPUT.PUT_LINE(col_employee_names(3));
END;




--Example 2 -varray
set SERVEROUTPUT ON;
DECLARE
type type_emplyee_names is varray(3) OF varchar2(40);
col_employee_names type_emplyee_names :=type_emplyee_names();
BEGIN
--col_employee_names.extend(3);  
col_employee_names.extend;
DBMS_OUTPUT.PUT_LINE(col_employee_names.limit);
DBMS_OUTPUT.PUT_LINE(col_employee_names.count);
DBMS_OUTPUT.PUT_LINE(col_employee_names.first);
if(col_employee_names.first is null) then
DBMS_OUTPUT.PUT_LINE('its null');
end if;
END;


--Example 3 -varray
set SERVEROUTPUT ON;
DECLARE
type type_department_names is varray(20) OF varchar2(40);
col_department_names type_department_names :=type_department_names();
v_index number(2):=0;
BEGIN
for rec_dep_name in (select department_name from departments)
loop
col_department_names.extend;
v_index:=v_index+1;
col_department_names(v_index):=rec_dep_name.department_name;
end loop;

for v_index in col_department_names.first..col_department_names.count
loop
DBMS_OUTPUT.put_line(col_department_names(v_index));
end loop;

END;


--select department_name from departments;






--Example 4 -varray
DECLARE
type type_emplyee_names is varray(3) OF varchar2(40);
col_employee_names type_emplyee_names :=type_emplyee_names();
BEGIN
col_employee_names.extend;   
col_employee_names(1):='Yogesh';   

col_employee_names.extend;  
col_employee_names(2):='Aakash'; 

col_employee_names.extend;  
col_employee_names(3):='Manisha'; 

col_employee_names.delete;--deletes complete varry 
--in varray cannnot delete specific index value

DBMS_OUTPUT.PUT_LINE(col_employee_names(2));
DBMS_OUTPUT.PUT_LINE(col_employee_names(3));
--DBMS_OUTPUT.PUT_LINE(col_employee_names(1));

END;


--Example 5 -Nested table
DECLARE
type type_emplyee_names is table OF varchar2(40);
col_employee_names type_emplyee_names :=type_emplyee_names();
BEGIN
col_employee_names.extend(3);   
col_employee_names(1):='Yogesh';   
col_employee_names.extend;  
col_employee_names(2):='Aakash'; 
col_employee_names.extend;  
col_employee_names(3):='Manisha'; 
--col_employee_names.delete(2);
DBMS_OUTPUT.PUT_LINE(col_employee_names(1));
DBMS_OUTPUT.PUT_LINE(col_employee_names(2));
DBMS_OUTPUT.PUT_LINE(col_employee_names(3));
END;


--Example 6 -Nested table

set SERVEROUTPUT ON;
DECLARE
type type_employee_names is table OF varchar2(40);
col_employee_names type_employee_names :=type_employee_names();
v_index number(2):=0;
BEGIN
for rec_dep_name in (select first_name from employees where department_id=50)
loop
col_employee_names.extend;
v_index:=v_index+1;
col_employee_names(v_index):=rec_dep_name.first_name;
end loop;

for v_index in col_employee_names.first..col_employee_names.count
loop
DBMS_OUTPUT.put_line(col_employee_names(v_index));
end loop;

END;



--Example 7 -Nested table --uncomment  the line in below code and observe
DECLARE
type type_emplyee_names is table OF varchar2(40);
col_employee_names type_emplyee_names :=type_emplyee_names();
BEGIN
col_employee_names.extend(3);   
col_employee_names(1):='Yogesh';   
col_employee_names.extend;  
col_employee_names(2):='Aakash'; 
col_employee_names.extend;  
col_employee_names(3):='Manisha'; 
col_employee_names.delete(2);
DBMS_OUTPUT.PUT_LINE(col_employee_names(1));
--DBMS_OUTPUT.PUT_LINE(col_employee_names(2));
DBMS_OUTPUT.PUT_LINE(col_employee_names(3));
END;



--Example 8 -Nested table  --Exists function

DECLARE
type type_emplyee_names is table OF varchar2(40);
col_employee_names type_emplyee_names :=type_emplyee_names();
BEGIN
col_employee_names.extend(3);   
col_employee_names(1):='Yogesh';   
col_employee_names.extend;  
col_employee_names(2):='Aakash'; 
col_employee_names.extend;  
col_employee_names(3):='Manisha'; 
col_employee_names.delete(2);
--col_employee_names(2):='Aakash';
if(col_employee_names.EXISTS(2))then
DBMS_OUTPUT.PUT_LINE(col_employee_names(2));
else
DBMS_OUTPUT.PUT_LINE('no values on 2nd index');
end if;
--DBMS_OUTPUT.PUT_LINE(col_employee_names(2));
END;


--Example 9 -Nested table --collection of %type (anchoring to column)--guess count
DECLARE
type type_emplyee_names is table OF Employees.first_name%type;
col_employee_names type_emplyee_names :=type_emplyee_names();
BEGIN
col_employee_names.extend(3);   
col_employee_names(1):='Yogesh';   
col_employee_names.extend;  
col_employee_names(2):='Aakash'; 
col_employee_names.extend;  
col_employee_names(3):='Manisha'; 
col_employee_names.delete(2);
DBMS_OUTPUT.PUT_LINE(col_employee_names.count);
END;


--Example 10 -Associative array

set SERVEROUTPUT ON;
DECLARE
type type_employee_names is table OF varchar2(40) index by pls_integer;
col_employee_names type_employee_names;

v_key number(4);

BEGIN
for rec_dep_name in (select employee_id,first_name,last_name from employees where department_id=50)
loop
--col_employee_names.extend;
--v_index:=v_index+1;
col_employee_names(rec_dep_name.employee_id):=rec_dep_name.first_name||' '||rec_dep_name.last_name;
end loop;
--
v_key:=col_employee_names.first;
--DBMS_OUTPUT.put_line(col_employee_names.first);
--for v_index in col_employee_names.first..col_employee_names.count
DBMS_OUTPUT.put_line(col_employee_names(v_key));
while (col_employee_names.next(v_key) is not null)
loop
DBMS_OUTPUT.put_line(col_employee_names(v_key));
v_key:=col_employee_names.next(v_key);
end loop;

END;







--Example 11--collections of records

DECLARE
type type_emplyee_names is varray(3) OF jobs%rowtype;
col_employee_names type_emplyee_names :=type_emplyee_names();
BEGIN
col_employee_names.extend;   
col_employee_names(1).job_id  :='MY_job';
col_employee_names(1).job_title:='job_title';
col_employee_names(1).min_salary:=40000;
col_employee_names(1).max_salary:=50000;
DBMS_OUTPUT.PUT_LINE(col_employee_names(1).job_id);
DBMS_OUTPUT.PUT_LINE(col_employee_names(1).job_title);
DBMS_OUTPUT.PUT_LINE(col_employee_names(1).min_salary);
DBMS_OUTPUT.PUT_LINE(col_employee_names(1).max_salary);
END;









