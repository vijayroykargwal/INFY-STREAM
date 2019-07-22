--EXCER71-
  DECLARE
  TYPE type_emp_detail IS record
  (
    employee_id NUMBER(6),
    salary      NUMBER(8,2),
    joining_date Date
  );
  rec_emp_detail type_emp_detail;
  v_department_id departments.department_id%type:=50;
  /*cursor to fetch employees required details*/
  CURSOR cur_emp_details IS
    SELECT employee_id,salary,hire_date FROM employees WHERE department_id=v_department_id;
  /*record anchored to a cursor cur_emp_details to hold 
    details of employees fetched using this cursor*/

BEGIN
  /* get employees details using cursor*/
  OPEN cur_emp_details;
  LOOP
    /*fetching values from cursor and stored into record*/
    FETCH cur_emp_details INTO rec_emp_detail;
    EXIT WHEN cur_emp_details%NOTFOUND;
    /*access individual attribute in record as
    <record_name>.<field_name> */
    DBMS_OUTPUT.put_line('Employee ID : '||rec_emp_detail.employee_id);
    DBMS_OUTPUT.put_line('Salary : '||rec_emp_detail.salary);
    DBMS_OUTPUT.put_line('Hire Date : '||rec_emp_detail.joining_date);
    dbms_output.put_line('---------------------------');
  END LOOP;
END; 

set serveroutput on;
select * from employees;


---Excer72---

set SERVEROUTPUT ON;
declare
 TYPE type_emp_detail IS record(
employee_id employees.employee_id%type,
job_title jobs.job_title%type,
department_id employees.department_id%type,
salary employees.salary%type);
rec_emp_details type_emp_detail;
cursor cur_emp_details is select e.employee_id,j.job_title,e.department_id,e.salary from employees e inner join jobs j on e.job_id=j.job_id 
order by e.salary desc;
begin
open cur_emp_details;
loop
fetch cur_emp_details into rec_emp_details;
exit when cur_emp_details%notfound or cur_emp_details%rowcount =4;
DBMS_OUTPUT.PUT_LINE(rec_emp_details.employee_id ||' '||rec_emp_details.job_title||' '||rec_emp_details.department_id||' '||rec_emp_details.salary);
end loop;
close cur_emp_details;
end;

---Excer73--
select * from departments;
set serveroutput on;
declare
type type_location_details is record(p_department_id departments.department_id%type,
p_department_name departments.department_name%type,
p_street_address locations.street_address%type,
p_city locations.city%type,
p_state_province locations.state_province%type);
rec_department_details type_location_details;
v_department_id departments.department_id%type :=50;
cursor cur_department_details is select d.department_id,d.department_name,l.street_address,l.city,l.state_province 
from departments d inner join locations l on d.location_id=l.location_id where department_id = v_department_id;
begin
open cur_department_details;
loop
fetch cur_department_details into rec_department_details;
exit when cur_department_details%notfound;
DBMS_OUTPUT.PUT_LINE(rec_department_details.p_department_id);
DBMS_OUTPUT.PUT_LINE(rec_department_details.p_department_name);
DBMS_OUTPUT.PUT_LINE(rec_department_details.p_street_address);
DBMS_OUTPUT.PUT_LINE(rec_department_details.p_city);
DBMS_OUTPUT.PUT_LINE(rec_department_details.p_state_province);
DBMS_OUTPUT.PUT_LINE('---------------------------------------');
end loop;
close cur_department_details;
end;

---Excer74---
--pkg specifications---
CREATE OR REPLACE PACKAGE pkg_tax is
FUNCTION sf_tax_eligibility(
    p_employee_id employees.employee_id%TYPE)
  RETURN BOOLEAN;
FUNCTION sf_tax_calc(
    p_employee_id employees.employee_id%TYPE)
  RETURN NUMBER;
 end; 
--package body----

CREATE OR REPLACE PACKAGE body pkg_tax is
----first function---
FUNCTION sf_tax_eligibility(
    p_employee_id employees.employee_id%TYPE)
  RETURN BOOLEAN
IS
  --variable to store the retrieved salary
  v_salary employees.salary%TYPE;
  v_eligible_salary CONSTANT NUMBER(6) := 8000;
BEGIN
  --fetching salary of given employee id 
  SELECT salary
  INTO v_salary
  FROM employees
  WHERE employee_id=p_employee_id;
  --retrieved value is checked as per the rule
  IF v_salary >v_eligible_salary THEN
    RETURN True;
  ELSE
    RETURN False;
  END IF;
EXCEPTION
WHEN OTHERS THEN
  RETURN NULL;
  

END sf_tax_eligibility;
---second function---
FUNCTION sf_tax_calc(
    p_employee_id employees.employee_id%TYPE)
  RETURN NUMBER
IS
  --used for tax calculation
  v_salary employees.salary%TYPE ;
  v_tax_percentage NUMBER(2);
  v_tax_amount NUMBER(8,2);
BEGIN
  --fetching salary of the given employee
  SELECT salary INTO v_salary
  FROM employees WHERE employee_id = p_employee_id;
  --logic for tax percentage computation
  IF v_salary        >=15000 THEN
    v_tax_percentage := 15;
  ELSIF v_salary      < 15000 AND v_salary >= 8000 THEN
    v_tax_percentage := 10;
  ELSE
    v_tax_percentage := 0;
  END IF;
--formula for tax calculation
v_tax_amount:=v_salary*v_tax_percentage*0.01;
RETURN v_tax_amount;
EXCEPTION
WHEN OTHERS THEN
  RETURN -1;
END sf_tax_calc;
end;

---driver program---
set SERVEROUTPUT ON;
begin
if(pkg_tax.sf_tax_eligibility(100)=true)then
DBMS_OUTPUT.PUT_line('eligible'); 
else DBMS_OUTPUT.PUT_line('not eligible'); end if;
DBMS_OUTPUT.PUT_line(pkg_tax.sf_tax_calc(100));
end;

--Excer75--
--pkg specifications---
CREATE OR REPLACE PACKAGE pkg_tax is
FUNCTION sf_tax_eligibility(
    p_employee_id employees.employee_id%TYPE)
  RETURN VARCHAR2;
FUNCTION sf_tax_calc(
    p_employee_id employees.employee_id%TYPE)
  RETURN NUMBER;
 end; 
--package body----

CREATE OR REPLACE PACKAGE body pkg_tax is
----first function---
FUNCTION sf_tax_eligibility(
    p_employee_id employees.employee_id%TYPE)
  RETURN VARCHAR2
IS
  --variable to store the retrieved salary
  v_salary employees.salary%TYPE;
  v_eligible_salary CONSTANT NUMBER(6) := 8000;
BEGIN
  --fetching salary of given employee id 
  SELECT salary
  INTO v_salary
  FROM employees
  WHERE employee_id=p_employee_id;
  --retrieved value is checked as per the rule
  IF v_salary >v_eligible_salary THEN
    RETURN 'eligible';
  ELSE
    RETURN 'not eligible';
  END IF;
EXCEPTION
WHEN OTHERS THEN
  RETURN 'something went wrong';
END sf_tax_eligibility;

---second function---

FUNCTION sf_tax_calc(
    p_employee_id employees.employee_id%TYPE)
  RETURN NUMBER
IS
  --used for tax calculation
  v_salary employees.salary%TYPE ;
  v_tax_percentage NUMBER(2);
  v_tax_amount NUMBER(8,2);
BEGIN
  --fetching salary of the given employee
  SELECT salary INTO v_salary
  FROM employees WHERE employee_id = p_employee_id;
  --logic for tax percentage computation
  IF v_salary        >=15000 THEN
    v_tax_percentage := 15;
  ELSIF v_salary      < 15000 AND v_salary >= 8000 THEN
    v_tax_percentage := 10;
  ELSE
    v_tax_percentage := 0;
  END IF;
--formula for tax calculation
v_tax_amount:=v_salary*v_tax_percentage*0.01;
RETURN v_tax_amount;
EXCEPTION
WHEN OTHERS THEN
  RETURN -1;
END sf_tax_calc;
end;
---driver program--
begin
dbms_output.put_line(pkg_tax.sf_tax_eligibility(107));
DBMS_OUTPUT.PUT_line(pkg_tax.sf_tax_calc(108));
end;

--Excer76--
---package specifications---
CREATE OR REPLACE PACKAGE pkg_departments_with_locations is
type type_location_details is record(p_department_id departments.department_id%type,
p_department_name departments.department_name%type,
p_street_address locations.street_address%type,
p_city locations.city%type,
p_state_province locations.state_province%type);

function pf_department_details(p_department_id departments.department_id%type) return pkg_departments_with_locations.type_location_details;
end;

---package body---
set serveroutput on;
CREATE OR REPLACE PACKAGE Body pkg_departments_with_locations is
function pf_department_details(p_department_id departments.department_id%type) return pkg_departments_with_locations.type_location_details is
cursor cur_department_details is select d.department_id,d.department_name,l.street_address,l.city,l.state_province 
from departments d inner join locations l on d.location_id=l.location_id where department_id = p_department_id;
rec_department_details  pkg_departments_with_locations.type_location_details;
begin
open cur_department_details;
fetch cur_department_details into rec_department_details;
close cur_department_details;
RETURN rec_department_details;
end pf_department_details;
end;
--driver program---
begin
DBMS_OUTPUT.PUT_LINE(pkg_departments_with_locations.pf_department_details(20).p_department_id);
DBMS_OUTPUT.PUT_LINE(pkg_departments_with_locations.pf_department_details(20).p_department_name);
DBMS_OUTPUT.PUT_LINE(pkg_departments_with_locations.pf_department_details(20).p_street_address);
DBMS_OUTPUT.PUT_LINE(pkg_departments_with_locations.pf_department_details(20).p_city);
DBMS_OUTPUT.PUT_LINE(pkg_departments_with_locations.pf_department_details(20).p_state_province);
END;

--EXCER77--
---package specification---
set serveroutput on;
CREATE OR REPLACE PACKAGE pkg_check_job_details is
 PROCEDURE add_job(
      p_job_id    IN jobs.job_id%TYPE,
      p_job_title IN jobs.job_title%TYPE,
      p_min_salary jobs.min_salary%TYPE,
      p_max_salary jobs.max_salary%TYPE,
      p_status OUT NUMBER);
  FUNCTION get_job_title(p_job_id IN jobs.job_id%TYPE)
    RETURN jobs.job_title%TYPE;
end;

---package body---
CREATE OR REPLACE PACKAGE body pkg_check_job_details is
FUNCTION is_job_valid(p_job_id IN jobs.job_id%TYPE)
    RETURN BOOLEAN
is
v_count_jobs pls_integer;
begin
select count(job_id) into v_count_jobs from jobs where job_id = p_job_id;
if v_count_jobs !=0 then
return true;
else
return false;
end if;
end is_job_valid;
  PROCEDURE add_job(
      p_job_id    IN jobs.job_id%TYPE,
      p_job_title IN jobs.job_title%TYPE,
      p_min_salary jobs.min_salary%TYPE,
      p_max_salary jobs.max_salary%TYPE,
      p_status OUT NUMBER) is 
  begin
  if pkg_check_job_details.is_job_valid(p_job_id) = false then
  insert into jobs values(p_job_id,p_job_title,p_min_salary,p_max_salary);
  p_status := 0;
  else
  p_status := -1;
  end if;
  end add_job;
FUNCTION get_job_title(p_job_id IN jobs.job_id%TYPE)
    RETURN jobs.job_title%TYPE is
    v_job_title jobs.job_title%type;
    begin
    if pkg_check_job_details.is_job_valid(p_job_id) = true then
    select job_title into v_job_title from jobs where job_id =  p_job_id;
    return v_job_title;
    else
    return 'invalid job_id';
    end if;
    end get_job_title;
end;  
--Driver program---
select * from jobs;
set serveroutput on; 
declare
p_status number(2);
begin
pkg_check_job_details.add_job('HR_MANAGER','Hr manager',6600,9000,p_status);
DBMS_OUTPUT.PUT_LINE(pkg_check_job_details.get_job_title('IT_PROG'));
end;

--Excer78--
DECLARE
  v_job_id jobs.job_id%TYPE:='ST_CLERK';
  v_job_title jobs.job_title%TYPE;
BEGIN
  /*Invoke the function get_job_title to get the job title*/
  v_job_title := pkg_check_job_details.get_job_title(v_job_id);
  DBMS_OUTPUT.PUT_LINE('The job title for the give job ID is : '||v_job_title);
END;

DECLARE
  v_job_id jobs.job_id%TYPE:='ST_AST';
  v_job_title jobs.job_title%TYPE:='Assistant Stock Manager';
  v_max_salary jobs.max_salary%TYPE:=7500;
  v_min_salary jobs.min_salary%TYPE:=4500;
  v_status NUMBER(1);
BEGIN
  /*Invoke the procedure add_job to add a new job*/
  pkg_check_job_details.add_job(v_job_id,v_job_title,v_min_salary,v_max_salary, v_status); 
  DBMS_OUTPUT.PUT_LINE('Status : '||v_status);
END;

---Excer 79--
---specifications---
CREATE OR REPLACE PACKAGE pkg_check_job_details is
type type_job_details is record(p_job_title jobs.job_title%type,
p_min_salary jobs.min_salary%type,
p_max_salary jobs.max_salary%type);
rec_job_details type_job_details;
 PROCEDURE add_job(
      p_job_id    IN jobs.job_id%TYPE,
      p_job_title IN jobs.job_title%TYPE,
      p_min_salary jobs.min_salary%TYPE,
      p_max_salary jobs.max_salary%TYPE,
      p_status OUT NUMBER);
  FUNCTION get_job_title(p_job_id IN jobs.job_id%TYPE)
    RETURN jobs.job_title%TYPE;
  function get_job_details(p_job_id jobs.job_id%type) return type_job_details; 
end;

---package body---
CREATE OR REPLACE PACKAGE body pkg_check_job_details is
FUNCTION is_job_valid(p_job_id IN jobs.job_id%TYPE)
    RETURN BOOLEAN
is
v_count_jobs pls_integer;
begin
select count(job_id) into v_count_jobs from jobs where job_id = p_job_id;
if v_count_jobs !=0 then
return true;
else
return false;
end if;
end is_job_valid;
  PROCEDURE add_job(
      p_job_id    IN jobs.job_id%TYPE,
      p_job_title IN jobs.job_title%TYPE,
      p_min_salary jobs.min_salary%TYPE,
      p_max_salary jobs.max_salary%TYPE,
      p_status OUT NUMBER) is 
  begin
  if pkg_check_job_details.is_job_valid(p_job_id) = false then
  insert into jobs values(p_job_id,p_job_title,p_min_salary,p_max_salary);
  p_status := 0;
  else
  p_status := -1;
  end if;
  end add_job;
FUNCTION get_job_title(p_job_id IN jobs.job_id%TYPE)
    RETURN jobs.job_title%TYPE is
    v_job_title jobs.job_title%type;
    begin
    if pkg_check_job_details.is_job_valid(p_job_id) = true then
    select job_title into v_job_title from jobs where job_id =  p_job_id;
    return v_job_title;
    else
    return 'invalid job_id';
    end if;
    end get_job_title;
function get_job_details(p_job_id jobs.job_id%type) return type_job_details is
cursor cur_job_details is select job_id,min_salary,max_salary from jobs where job_id = p_job_id;
begin
if pkg_check_job_details.is_job_valid(p_job_id) = true then
open cur_job_details;
fetch cur_job_details into rec_job_details;
close cur_job_details;
return rec_job_details;
end if;
end get_job_details;
end;
--excer 80--
SET SERVEROUTPUT ON;
begin
DBMS_OUTPUT.PUT_LINE(pkg_check_job_details.get_job_details('ST_CLERK').p_job_title);
DBMS_OUTPUT.PUT_LINE(pkg_check_job_details.get_job_details('ST_CLERK').p_min_salary);
DBMS_OUTPUT.PUT_LINE(pkg_check_job_details.get_job_details('ST_CLERK').p_max_salary);
end;

--Excer81--
---specifications---
CREATE OR REPLACE PACKAGE pkg_check_job_details is
type type_job_details is record(p_job_title jobs.job_title%type,
p_min_salary jobs.min_salary%type,
p_max_salary jobs.max_salary%type);
rec_job_details type_job_details;
 PROCEDURE add_job(
      p_job_id    IN jobs.job_id%TYPE,
      p_job_title IN jobs.job_title%TYPE,
      p_min_salary jobs.min_salary%TYPE,
      p_max_salary jobs.max_salary%TYPE,
      p_status OUT NUMBER);
  FUNCTION get_job_title(p_job_id IN jobs.job_id%TYPE)
    RETURN jobs.job_title%TYPE;
  function get_job_details(p_job_id jobs.job_id%type) return type_job_details;
  FUNCTION get_min_salary(
      p_job_id IN jobs.job_id%TYPE)
    RETURN jobs.min_salary%TYPE;
  FUNCTION get_max_salary(
      p_job_id IN jobs.job_id%TYPE)
    RETURN jobs.max_salary%TYPE;
end;

---package body---
CREATE OR REPLACE PACKAGE body pkg_check_job_details is
FUNCTION is_job_valid(p_job_id IN jobs.job_id%TYPE)
    RETURN BOOLEAN
is
v_count_jobs pls_integer;
begin
select count(job_id) into v_count_jobs from jobs where job_id = p_job_id;
if v_count_jobs !=0 then
return true;
else
return false;
end if;
end is_job_valid;
  PROCEDURE add_job(
      p_job_id    IN jobs.job_id%TYPE,
      p_job_title IN jobs.job_title%TYPE,
      p_min_salary jobs.min_salary%TYPE,
      p_max_salary jobs.max_salary%TYPE,
      p_status OUT NUMBER) is 
  begin
  if pkg_check_job_details.is_job_valid(p_job_id) = false then
  insert into jobs values(p_job_id,p_job_title,p_min_salary,p_max_salary);
  p_status := 0;
  else
  p_status := -1;
  end if;
  end add_job;
FUNCTION get_job_title(p_job_id IN jobs.job_id%TYPE)
    RETURN jobs.job_title%TYPE is
    v_job_title jobs.job_title%type;
    begin
    if pkg_check_job_details.is_job_valid(p_job_id) = true then
    select job_title into v_job_title from jobs where job_id =  p_job_id;
    return v_job_title;
    else
    return 'invalid job_id';
    end if;
    end get_job_title;
function get_job_details(p_job_id jobs.job_id%type) return type_job_details is
cursor cur_job_details is select job_id,min_salary,max_salary from jobs where job_id = p_job_id;
begin
if pkg_check_job_details.is_job_valid(p_job_id) = true then
open cur_job_details;
fetch cur_job_details into rec_job_details;
close cur_job_details;
return rec_job_details;
end if;
end get_job_details;

 FUNCTION get_min_salary(
      p_job_id IN jobs.job_id%TYPE)
    RETURN jobs.min_salary%TYPE is
    v_min_salary jobs.min_salary%type;
    begin
 if pkg_check_job_details.is_job_valid(p_job_id) = true then
 select min_salary into v_min_salary from jobs where job_id = p_job_id;
 return v_min_salary;
 end if;
 end get_min_salary;
 
  FUNCTION get_max_salary(
      p_job_id IN jobs.job_id%TYPE)
    RETURN jobs.max_salary%TYPE is
    v_max_salary jobs.max_salary%type;
    begin
     if pkg_check_job_details.is_job_valid(p_job_id) = true then
 select max_salary into v_max_salary from jobs where job_id = p_job_id;
 return v_max_salary;
 end if;
 end get_max_salary;
end;

--driver program---
set SERVEROUTPUT ON;
begin
dbms_output.put_line(pkg_check_job_details.get_max_salary('ST_CLERK'));
dbms_output.put_line(pkg_check_job_details.get_min_salary('ST_CLERK'));
end;

---Excer 82 --
---specifications---
CREATE OR REPLACE PACKAGE pkg_check_job_details is
type type_job_details is record(p_job_title jobs.job_title%type,
p_min_salary jobs.min_salary%type,
p_max_salary jobs.max_salary%type);
rec_job_details type_job_details;
 PROCEDURE add_job(
      p_job_id    IN jobs.job_id%TYPE,
      p_job_title IN jobs.job_title%TYPE,
      p_min_salary jobs.min_salary%TYPE,
      p_max_salary jobs.max_salary%TYPE,
      p_status OUT NUMBER);
  FUNCTION get_job_title(p_job_id IN jobs.job_id%TYPE)
    RETURN jobs.job_title%TYPE;
  function get_job_details(p_job_id jobs.job_id%type) return type_job_details;
  FUNCTION get_min_salary(
      p_job_id IN jobs.job_id%TYPE)
    RETURN jobs.min_salary%TYPE;
  FUNCTION get_max_salary(
      p_job_id IN jobs.job_id%TYPE)
    RETURN jobs.max_salary%TYPE;
  PROCEDURE upd_salary (p_employee_id employees.employee_id%type,
  p_new_salary employees.salary%type,p_status out pls_integer);
end;

---package body---
CREATE OR REPLACE PACKAGE body pkg_check_job_details is
FUNCTION is_job_valid(p_job_id IN jobs.job_id%TYPE)
    RETURN BOOLEAN
is
v_count_jobs pls_integer;
begin
select count(job_id) into v_count_jobs from jobs where job_id = p_job_id;
if v_count_jobs !=0 then
return true;
else
return false;
end if;
end is_job_valid;
  PROCEDURE add_job(
      p_job_id    IN jobs.job_id%TYPE,
      p_job_title IN jobs.job_title%TYPE,
      p_min_salary jobs.min_salary%TYPE,
      p_max_salary jobs.max_salary%TYPE,
      p_status OUT NUMBER) is 
  begin
  if pkg_check_job_details.is_job_valid(p_job_id) = false then
  insert into jobs values(p_job_id,p_job_title,p_min_salary,p_max_salary);
  p_status := 0;
  else
  p_status := -1;
  end if;
  end add_job;
FUNCTION get_job_title(p_job_id IN jobs.job_id%TYPE)
    RETURN jobs.job_title%TYPE is
    v_job_title jobs.job_title%type;
    begin
    if pkg_check_job_details.is_job_valid(p_job_id) = true then
    select job_title into v_job_title from jobs where job_id =  p_job_id;
    return v_job_title;
    else
    return 'invalid job_id';
    end if;
    end get_job_title;
function get_job_details(p_job_id jobs.job_id%type) return type_job_details is
cursor cur_job_details is select job_id,min_salary,max_salary from jobs where job_id = p_job_id;
begin
if pkg_check_job_details.is_job_valid(p_job_id) = true then
open cur_job_details;
fetch cur_job_details into rec_job_details;
close cur_job_details;
return rec_job_details;
end if;
end get_job_details;

 FUNCTION get_min_salary(
      p_job_id IN jobs.job_id%TYPE)
    RETURN jobs.min_salary%TYPE is
    v_min_salary jobs.min_salary%type;
    begin
 if pkg_check_job_details.is_job_valid(p_job_id) = true then
 select min_salary into v_min_salary from jobs where job_id = p_job_id;
 return v_min_salary;
 end if;
 end get_min_salary;
 
  FUNCTION get_max_salary(
      p_job_id IN jobs.job_id%TYPE)
    RETURN jobs.max_salary%TYPE is
    v_max_salary jobs.max_salary%type;
    begin
     if pkg_check_job_details.is_job_valid(p_job_id) = true then
 select max_salary into v_max_salary from jobs where job_id = p_job_id;
 return v_max_salary;
 end if;
 end get_max_salary;

 PROCEDURE upd_salary(p_employee_id employees.employee_id%type,
  p_new_salary employees.salary%type,p_status out pls_integer) is
  v_count_employees pls_integer;
  v_job_id employees.job_id%type;
  v_min_salary jobs.min_salary%type;
  begin
  select count(employee_id) into v_count_employees from employees where employee_id=p_employee_id;
  if v_count_employees != 0 then
    select job_id into v_job_id from employees where employee_id = p_employee_id;
     v_min_salary := pkg_check_job_details.get_min_salary(v_job_id);
    if p_new_salary < v_min_salary then
    p_status := -3;
    else
    update employees set salary = p_new_salary where employee_id = p_employee_id;
    p_status :=0;
    end if;
  else
  p_status := -1;
  end if;
  exception
  when others then
  p_status := -2;
  end upd_salary;
end;

--Driver Program--
declare
p_status pls_integer;
begin
pkg_check_job_details.upd_salary(100,25000,p_status);
DBMS_OUTPUT.PUT_LINE('p_status :'||' '||p_status);
pkg_check_job_details.upd_salary(120,5000,p_status);
DBMS_OUTPUT.PUT_LINE('p_status :'||' '||p_status);
pkg_check_job_details.upd_salary(115,5000,p_status);
DBMS_OUTPUT.PUT_LINE('p_status :'||' '||p_status);
pkg_check_job_details.upd_salary(114,20000,p_status);
DBMS_OUTPUT.PUT_LINE('p_status :'||' '||p_status);
end;
----------------------------------------------------------------------------------------------
