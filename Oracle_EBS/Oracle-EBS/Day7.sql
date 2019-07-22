CREATE OR REPLACE PACKAGE pkg_emp_details
  AS
  Type type_emp_details IS TABLE OF NUMBER(6);
  -- A collection to store all employee_ids
  col_emp_details type_emp_details := type_emp_details();
  END;
  
CREATE OR REPLACE FUNCTION sf_get_reportees(p_manager_id employees.employee_id%TYPE) 
return pkg_emp_details.type_emp_details
-- this function returns a collection of employees who is reporting to a given manager
-- the return clause datatype is accessing the collection type delcared in package pkg_emp_details
AS
-- declare a collection to store all employee_id details
v_col_emp_details pkg_emp_details.col_emp_details%type;
BEGIN
 --use bulk collect to collect all employee IDs at once in  pl/sql collection from select statement
 select employee_id BULK COLLECT into  v_col_emp_details from employees where manager_id = p_manager_id;
 
return v_col_emp_details;
END;

set serveroutput on;
begin
FOR v_employee_id IN  sf_get_reportees(103).FIRST .. sf_get_reportees(103).LAST
loop
 dbms_output.put_line(sf_get_reportees(103)(v_employee_id));
 end loop;
 end;
 
 
--Excer 96--
CREATE OR REPLACE PACKAGE pkg_emp_details
  AS
  Type type_emp_details IS TABLE OF NUMBER(6);
  -- A collection to store all employee_ids
  col_emp_details type_emp_details := type_emp_details();
  END;
  
 CREATE OR REPLACE function sf_exp_emp return  pkg_emp_details.type_emp_details is
 v_col_emp_details pkg_emp_details.type_emp_details;
 begin
 select employee_id bulk collect into  v_col_emp_details from employees
 WHERE TO_NUMBER (TO_CHAR (SYSDATE, 'yyyy')) - TO_NUMBER ( (TO_CHAR (hire_date, 'yyyy'))) >= 25;
 return v_col_emp_details;
 end;
 
 CREATE OR REPLACE PROCEDURE sp_update_salary (
   p_col_emp_id          pkg_emp_details.type_emp_details,
   p_hikePercentage    NUMBER)
IS
BEGIN
   /* use FORALL statement to update employee salaries
   */
     FORALL emp_id IN p_col_emp_id.FIRST .. p_col_emp_id.LAST
      UPDATE employees SET salary = salary*(1+p_hikepercentage/100) WHERE employee_id = p_col_emp_id(emp_id);
END sp_update_salary;

---Driver program---
set SERVEROUTPUT ON
declare
v_exp_emp pkg_emp_details.type_emp_details;
begin
v_exp_emp := sf_exp_emp();
sp_update_salary(v_exp_emp,10);
end;

select * from employees;

---excer 97---

CREATE OR REPLACE PACKAGE pkg_emp_details
  AS
  Type type_emp_details IS TABLE OF NUMBER(6);
  -- A collection to store all employee_ids
  col_emp_details type_emp_details := type_emp_details();
  END;
  
 CREATE OR REPLACE function sf_exp_emp return  pkg_emp_details.type_emp_details is
 v_col_emp_details pkg_emp_details.type_emp_details;
 begin
 select employee_id bulk collect into  v_col_emp_details from employees
 WHERE TO_NUMBER (TO_CHAR (SYSDATE, 'yyyy')) - TO_NUMBER ( (TO_CHAR (hire_date, 'yyyy'))) >= 25;
 return v_col_emp_details;
 end;
 
 CREATE OR REPLACE PROCEDURE sp_update_salary (
   p_col_emp_id          pkg_emp_details.type_emp_details,
   p_hikePercentage    NUMBER)
IS
v_error_count pls_integer;
BEGIN
   /* use FORALL statement to update employee salaries
   */
     FORALL emp_id IN p_col_emp_id.FIRST .. p_col_emp_id.LAST save exceptions
      UPDATE employees SET salary = salary*(1+p_hikepercentage/100) WHERE employee_id = p_col_emp_id(emp_id);
      exception
      when others then
       --SQL%BULK_EXCEPTIONS.COUNT will return the number of execptions occured during execution of DML statement
      v_error_count := SQL%BULK_EXCEPTIONS.COUNT;
      DBMS_OUTPUT.put_line ('Number Of Exceptions' || v_error_count);
     -- loop to traverse through the collection SQL%BULK_EXCEPTIONS
      FOR i IN 1 .. v_error_count
      LOOP
      -- For every exception in the collection SQL%BULK_EXCEPTIONS (i).ERROR_INDEX will give index value
      -- For every exception in the collection SQLERRM (SQL%BULK_EXCEPTIONS (i).ERROR_CODE) will give error message
         DBMS_OUTPUT.put_line ('Index: '|| SQL%BULK_EXCEPTIONS (i).ERROR_INDEX|| ' Message: '
            || SQLERRM (-SQL%BULK_EXCEPTIONS (i).ERROR_CODE));
      END LOOP;
END sp_update_salary;

---Driver program---
set SERVEROUTPUT ON
declare
v_exp_emp pkg_emp_details.type_emp_details;
begin
v_exp_emp := sf_exp_emp();
sp_update_salary(v_exp_emp,10);
end;


---excer98---
set serveroutput on;
DECLARE
/*Defining new collection type for storing maximum of 15 region names*/
TYPE type_region IS VARRAY(15) OF VARCHAR2(25);
/*declared a collection called col_regions,of type type_region */
col_regions type_region:=type_region();
/*counter for indexing the collection, used
for storing and retrieving values in collection*/
BEGIN
  /*fetch all the regions from cursor and store into collection*/
--  FOR region IN(SELECT region_name FROM regions)
--  LOOP
--    /*increase the size of a varray dynamically using the 
--    EXTEND inbuild PL/SQL procedure upto defined limit */
--    col_regions.EXTEND(1);
--    /*store retrieved region name into collection*/
--    col_regions(v_index_position):=region.region_name;
--    v_index_position:=v_index_position+1;
--  END LOOP;
   select region_name bulk collect into col_regions from regions;
  /*display all stored region names in collection*/
  FOR v_index IN 1..col_regions.COUNT
  LOOP
    /*Retrieve and display elements in collection using index position*/ 
    dbms_output.put_line(v_index||' '||col_regions(v_index));
  END LOOP;
END; 

--excer99--
set serveroutput on;
DECLARE
/*Defining new collection type for storing maximum of 15 region names*/
TYPE type_emp_details IS Table OF employees.employee_id%type;
/*declared a collection called col_regions,of type type_region */
col_emp_details type_emp_details:=type_emp_details();
begin
select employee_id bulk collect into col_emp_details from employees where
to_number(to_char(hire_date,'yyyy')) between to_number(to_char(sysdate,'yyyy'))-1 and to_number(to_char(sysdate,'yyyy'));
if (col_emp_details.count=0) then
dbms_output.put_line('No employee joined in last one year');
else
FOR v_index IN 1..col_emp_details.COUNT
  LOOP
    /*Retrieve and display elements in collection using index position*/ 
    dbms_output.put_line(v_index||' '||col_emp_details(v_index));
  END LOOP;
  end if;
end;

---excer100---
CREATE OR REPLACE PACKAGE pkg_dep_details
  AS
  Type type_dep_details IS TABLE OF departments.department_id%type;
  -- A collection to store all employee_ids
  col_dept_details type_dep_details := type_dep_details();
  END;
  
create or replace function sf_dep_details(p_location_id departments.location_id%type) return pkg_dep_details.type_dep_details is
begin
select department_id bulk collect into pkg_dep_details.col_dept_details from departments where location_id=p_location_id;
return pkg_dep_details.col_dept_details;
end;

--driver program--
set SERVEROUTPUT ON;
declare
v_dep_details  pkg_dep_details.type_dep_details;
begin
v_dep_details :=  sf_dep_details(1700);
for dep_id in v_dep_details.first..v_dep_details.last
loop
dbms_output.put_line(v_dep_details(dep_id));
end loop;
end;

--excer101--
CREATE OR REPLACE PACKAGE pkg_emp_details
  AS
  Type type_emp_details IS TABLE OF employees.employee_id%type;
  -- A collection to store all employee_ids
  col_emp_details type_emp_details := type_emp_details();
  END pkg_emp_details;
  
create or replace function sf_emp_details(p_department_id employees.department_id%type) return pkg_emp_details.type_emp_details is
begin
select employee_id bulk collect into pkg_emp_details.col_emp_details from employees where department_id=p_department_id;
return pkg_emp_details.col_emp_details;
end sf_emp_details;

 CREATE OR REPLACE PROCEDURE sp_update_salary (
   p_col_emp_id          pkg_emp_details.type_emp_details,
   p_hikePercentage    NUMBER)
IS
v_error_count pls_integer;
BEGIN
   /* use FORALL statement to update employee salaries
   */
     FORALL emp_id IN p_col_emp_id.FIRST .. p_col_emp_id.LAST save exceptions
      UPDATE employees SET salary = salary*(1+p_hikepercentage/100) WHERE employee_id = p_col_emp_id(emp_id);
      exception
      when others then
       --SQL%BULK_EXCEPTIONS.COUNT will return the number of execptions occured during execution of DML statement
      v_error_count := SQL%BULK_EXCEPTIONS.COUNT;
      DBMS_OUTPUT.put_line ('Number Of Exceptions' || v_error_count);
     -- loop to traverse through the collection SQL%BULK_EXCEPTIONS
      FOR i IN 1 .. v_error_count
      LOOP
      -- For every exception in the collection SQL%BULK_EXCEPTIONS (i).ERROR_INDEX will give index value
      -- For every exception in the collection SQLERRM (SQL%BULK_EXCEPTIONS (i).ERROR_CODE) will give error message
         DBMS_OUTPUT.put_line ('Index: '|| SQL%BULK_EXCEPTIONS (i).ERROR_INDEX|| ' Message: '
            || SQLERRM (-SQL%BULK_EXCEPTIONS (i).ERROR_CODE));
      END LOOP;
END sp_update_salary;

---driver program---
set SERVEROUTPUT ON
declare
v_emp_details pkg_emp_details.type_emp_details;
begin
v_emp_details := sf_emp_details(50);
sp_update_salary(v_emp_details,20);
end;

select * from employees;

---Exce102---
CREATE OR REPLACE PACKAGE pkg_emp_details
  AS
  Type type_emp_details IS TABLE OF employees.employee_id%type;
  -- A collection to store all employee_ids
  col_emp_details type_emp_details := type_emp_details();
  END pkg_emp_details;
 
create or replace function sf_emp_details return pkg_emp_details.type_emp_details is
begin
select e.employee_id bulk collect into pkg_emp_details.col_emp_details from employees e inner join departments d on e.employee_id=d.manager_id;
return pkg_emp_details.col_emp_details;
end sf_emp_details;

----driver program---
set SERVEROUTPUT ON;
declare
v_manager_details pkg_emp_details.type_emp_details;
begin
v_manager_details := sf_emp_details();
for v_emp_id in v_manager_details.first..v_manager_details.last
loop
dbms_output.put_line(v_manager_details(v_emp_id));
end loop;
end;

---excer103--
CREATE OR REPLACE PACKAGE pkg_emp_details
  AS
  Type type_emp_details IS TABLE OF employees.employee_id%type;
  -- A collection to store all employee_ids
  col_emp_details type_emp_details := type_emp_details();
  END pkg_emp_details;
 
create or replace function sf_emp_details return pkg_emp_details.type_emp_details is
begin
select e.employee_id bulk collect into pkg_emp_details.col_emp_details from employees e inner join departments d on e.employee_id=d.manager_id;
return pkg_emp_details.col_emp_details;
end sf_emp_details;

CREATE OR REPLACE procedure sp_update_commission_pct(p_col_emp_id pkg_emp_details.type_emp_details,
p_commission_pct employees.commission_pct%type) is
v_error_count pls_integer;
BEGIN
   /* use FORALL statement to update employee salaries
   */
     FORALL emp_id IN p_col_emp_id.FIRST .. p_col_emp_id.LAST save exceptions
      UPDATE employees SET commission_pct = p_commission_pct WHERE employee_id = p_col_emp_id(emp_id);
      exception
      when others then
       --SQL%BULK_EXCEPTIONS.COUNT will return the number of execptions occured during execution of DML statement
      v_error_count := SQL%BULK_EXCEPTIONS.COUNT;
      DBMS_OUTPUT.put_line ('Number Of Exceptions' || v_error_count);
     -- loop to traverse through the collection SQL%BULK_EXCEPTIONS
      FOR i IN 1 .. v_error_count
      LOOP
      -- For every exception in the collection SQL%BULK_EXCEPTIONS (i).ERROR_INDEX will give index value
      -- For every exception in the collection SQLERRM (SQL%BULK_EXCEPTIONS (i).ERROR_CODE) will give error message
         DBMS_OUTPUT.put_line ('Index: '|| SQL%BULK_EXCEPTIONS (i).ERROR_INDEX|| ' Message: '
            || SQLERRM (-SQL%BULK_EXCEPTIONS (i).ERROR_CODE));
      END LOOP;
END sp_update_commission_pct;

----driver program---
set SERVEROUTPUT ON
declare
v_emp_details pkg_emp_details.type_emp_details;
begin
v_emp_details := sf_emp_details();
sp_update_commission_pct(v_emp_details,0.2);
end;

select * from employees;

---excer104---
CREATE OR REPLACE PACKAGE pkg_emp_details
  AS
  Type type_emp_details IS TABLE OF employees.employee_id%type;
  -- A collection to store all employee_ids
  col_emp_details type_emp_details := type_emp_details();
  END pkg_emp_details;
 
create or replace function sf_emp_details return pkg_emp_details.type_emp_details is
begin
select e.employee_id bulk collect into pkg_emp_details.col_emp_details from employees e inner join departments d on e.employee_id=d.manager_id;
return pkg_emp_details.col_emp_details;
end sf_emp_details;

 CREATE OR REPLACE PROCEDURE sp_update_salary (
   p_col_emp_id          pkg_emp_details.type_emp_details,
   p_hikePercentage    NUMBER)
IS
v_error_count pls_integer;
BEGIN
   /* use FORALL statement to update employee salaries
   */
     FORALL emp_id IN p_col_emp_id.FIRST .. p_col_emp_id.LAST save exceptions
      UPDATE employees SET salary = salary*(1+p_hikepercentage/100) WHERE employee_id = p_col_emp_id(emp_id);
      exception
      when others then
       --SQL%BULK_EXCEPTIONS.COUNT will return the number of execptions occured during execution of DML statement
      v_error_count := SQL%BULK_EXCEPTIONS.COUNT;
      DBMS_OUTPUT.put_line ('Number Of Exceptions' || v_error_count);
     -- loop to traverse through the collection SQL%BULK_EXCEPTIONS
      FOR i IN 1 .. v_error_count
      LOOP
      -- For every exception in the collection SQL%BULK_EXCEPTIONS (i).ERROR_INDEX will give index value
      -- For every exception in the collection SQLERRM (SQL%BULK_EXCEPTIONS (i).ERROR_CODE) will give error message
         DBMS_OUTPUT.put_line ('Index: '|| SQL%BULK_EXCEPTIONS (i).ERROR_INDEX|| ' Message: '
            || SQLERRM (-SQL%BULK_EXCEPTIONS (i).ERROR_CODE));
      END LOOP;
END sp_update_salary;

----driver program---
set SERVEROUTPUT ON
declare
v_emp_details pkg_emp_details.type_emp_details;
begin
v_emp_details := sf_emp_details();
sp_update_salary(v_emp_details,25);
end;

select * from employees;
----Excer105------
CREATE OR REPLACE PACKAGE pkg_emp_details
  AS
  type type_rec_emp_details is record(p_employee_id employees.employee_id%type,
  p_email employees.email%type,
  new_job_id employees.job_id%type);
  Type type_emp_details IS TABLE OF type_rec_emp_details;
  -- A collection to store all employee_ids
  col_emp_details type_emp_details := type_emp_details();
  END pkg_emp_details;
  
create or replace procedure sp_emp_details(p_col_emp_details pkg_emp_details.type_emp_details) is
BEGIN
   /* use FORALL statement to update employee salaries
   */
     FORALL emp_details IN p_col_emp_details.FIRST .. p_col_emp_details.LAST
      UPDATE employees SET job_id=p_col_emp_details(emp_details).new_job_id WHERE employee_id = p_col_emp_details(emp_details).p_employee_id;

    End  sp_emp_details;
    
  ---driver program---
  declare
  v_col_emp_details pkg_emp_details.type_emp_details:=pkg_emp_details.type_emp_details();
  begin
  v_col_emp_details.extend();
  v_col_emp_details(1).p_employee_id := 110;
  v_col_emp_details(1).p_email := 'JCHEN';
  v_col_emp_details(1).new_job_id := 'FI_MGR';
  v_col_emp_details.extend();
  v_col_emp_details(2).p_employee_id := 112;
  v_col_emp_details(2).p_email := 'Jmurman';
  v_col_emp_details(2).new_job_id := 'FI_MGR';
  v_col_emp_details.extend();
  v_col_emp_details(3).p_employee_id := 134;
  v_col_emp_details(3).p_email := 'Mrogers';
  v_col_emp_details(3).new_job_id := 'PU_MAN';
  sp_emp_details(v_col_emp_details);
  end;

----excer106---
CREATE OR REPLACE PACKAGE pkg_emp_details
  AS
  type type_rec_emp_details is record(p_employee_id employees.employee_id%type,
  p_email employees.email%type,
  new_job_id employees.job_id%type);
  Type type_emp_details IS TABLE OF type_rec_emp_details;
  -- A collection to store all employee_ids
  col_emp_details type_emp_details := type_emp_details();
  END pkg_emp_details;
  
create or replace procedure sp_emp_details(p_col_emp_details pkg_emp_details.type_emp_details) is
v_error_count pls_integer;
BEGIN
   /* use FORALL statement to update employee salaries
   */
     FORALL emp_details IN p_col_emp_details.FIRST .. p_col_emp_details.LAST save exceptions
      UPDATE employees SET job_id=p_col_emp_details(emp_details).new_job_id WHERE employee_id = p_col_emp_details(emp_details).p_employee_id;
      exception
      when others then
       --SQL%BULK_EXCEPTIONS.COUNT will return the number of execptions occured during execution of DML statement
      v_error_count := SQL%BULK_EXCEPTIONS.COUNT;
      DBMS_OUTPUT.put_line ('Number Of Exceptions' || v_error_count);
     -- loop to traverse through the collection SQL%BULK_EXCEPTIONS
      FOR i IN 1 .. v_error_count
      LOOP
      -- For every exception in the collection SQL%BULK_EXCEPTIONS (i).ERROR_INDEX will give index value
      -- For every exception in the collection SQLERRM (SQL%BULK_EXCEPTIONS (i).ERROR_CODE) will give error message
         DBMS_OUTPUT.put_line ('Index: '|| SQL%BULK_EXCEPTIONS (i).ERROR_INDEX|| ' Message: '
            || SQLERRM (-SQL%BULK_EXCEPTIONS (i).ERROR_CODE));
      END LOOP;
    End  sp_emp_details;
    
  ---driver program---
  declare
  v_col_emp_details pkg_emp_details.type_emp_details:=pkg_emp_details.type_emp_details();
  begin
  v_col_emp_details.extend();
  v_col_emp_details(1).p_employee_id := 110;
  v_col_emp_details(1).p_email := 'JCHEN';
  v_col_emp_details(1).new_job_id := 'FI_MGR';
  v_col_emp_details.extend();
  v_col_emp_details(2).p_employee_id := 112;
  v_col_emp_details(2).p_email := 'Jmurman';
  v_col_emp_details(2).new_job_id := 'FI_MGR';
  v_col_emp_details.extend();
  v_col_emp_details(3).p_employee_id := 134;
  v_col_emp_details(3).p_email := 'Mrogers';
  v_col_emp_details(3).new_job_id := 'PU_MAN';
  sp_emp_details(v_col_emp_details);
  end;
  
  select * from employees;
  
---Excer107---
CREATE OR REPLACE PACKAGE pkg_job_details
  AS
  type type_rec_job_details is record(job_id VARCHAR2(50),
  job_title jobs.job_title%type,
  min_salary jobs.min_salary%type,
  max_salary jobs.max_salary%type);
  Type type_job_details IS TABLE OF type_rec_job_details;
  -- A collection to store all employee_ids
  col_job_details type_job_details := type_job_details();
  END pkg_job_details;
  
create or replace procedure ins_job_details(p_col_job_details pkg_job_details.type_job_details) is
v_error_count pls_integer;
BEGIN
   /* use FORALL statement to update employee salaries
   */
     FORALL job_details IN p_col_job_details.FIRST .. p_col_job_details.LAST save exceptions
      insert into jobs values(p_col_job_details(job_details).job_id,p_col_job_details(job_details).job_title,p_col_job_details(job_details).min_salary,
      p_col_job_details(job_details).max_salary);
      exception
      when others then
       --SQL%BULK_EXCEPTIONS.COUNT will return the number of execptions occured during execution of DML statement
      v_error_count := SQL%BULK_EXCEPTIONS.COUNT;
      DBMS_OUTPUT.put_line ('Number Of Exceptions' || v_error_count);
     -- loop to traverse through the collection SQL%BULK_EXCEPTIONS
      FOR i IN 1 .. v_error_count
      LOOP
      -- For every exception in the collection SQL%BULK_EXCEPTIONS (i).ERROR_INDEX will give index value
      -- For every exception in the collection SQLERRM (SQL%BULK_EXCEPTIONS (i).ERROR_CODE) will give error message
         DBMS_OUTPUT.put_line ('Index: '|| SQL%BULK_EXCEPTIONS (i).ERROR_INDEX|| ' Message: '
            || SQLERRM (-SQL%BULK_EXCEPTIONS (i).ERROR_CODE));
      END LOOP;
    End  ins_job_details;
----Driver program----
declare
v_col_job_details pkg_job_details.type_job_details := pkg_job_details.type_job_details();
begin
v_col_job_details.extend();
v_col_job_details(1).job_id := 'SL_MAN';
v_col_job_details(1).job_title := 'sales manager';
v_col_job_details(1).min_salary := 9500;
v_col_job_details(1).max_salary:= 20000;
v_col_job_details.extend();
v_col_job_details(2).job_id := 'PU_MAN';
v_col_job_details(2).job_title := 'Purchasing Assistant Manager';
v_col_job_details(2).min_salary := 7000;
v_col_job_details(2).max_salary:= 13000;
v_col_job_details.extend();
v_col_job_details(3).job_id := 'SL_ASSISTANT';
v_col_job_details(3).job_title := 'Sales Assistant Manager';
v_col_job_details(3).min_salary := 7000;
v_col_job_details(3).max_salary:= 13000;
ins_job_details(v_col_job_details);
----doubt manual job_id varchar----
end;




