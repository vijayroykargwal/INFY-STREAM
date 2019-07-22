--#######################Triggers###########
--
--##Triggering Event
--
--server startup
--server shutdown
--
--logging in 
--logging out
--
--##DML events##
--
--insert /update /delete  ->table



--     ##EXAMPLE##


--###Triggering Event###
--Employee joined Infosys
--
--###Triggering Action###
--
--generate employee ID
--book ECC
--allocate classroom




--##Database objects created so far##
--
--
--Table
--stored Procedure
--stored function
--sequence
--Trigger


--------------------SYNTAX----------------
/*
CREATE [OR REPLACE] TRIGGER  <trigger-name> BEFORE | AFTER | INSTEAD OF
DELETE | [OR] INSERT | [OR] UPDATE [ OF <column> [, <column>...]] ON <table>

-- This section is called Triggering event

[ FOR EACH ROW [ WHEN  <condition>] ]

-- When clause will be triggering constraint
BEGIN

-- This PL/SQL block is Triggering action

-- PL/SQL Block 
...
END;

*/





set SERVEROUTPUT ON;


--stored procedure/function can be called by name but trigger cannot be


--statement level trigger

create or replace trigger trg_update_of_salary before update of salary on employees

begin
DBMS_OUTPUT.PUT_line('Updatting of Salary is successful!!');
end;

--Execute below statements and check the result

--update employees set salary=30000 where employee_id=100;
--update employees set salary=salary+100 where department_id=20;
--update employees set salary=salary+100 where department_id=50;
--update employees set salary=salary+100;
--
--select * from employees where employee_id=100;



--row level trigger
create or replace trigger trg_update_of_salary before update of salary on employees
FOR EACH ROW 
begin
DBMS_OUTPUT.PUT_line('Updatting of Salary is successful!!');
end;

--Execute below statements and check the result

--update employees set salary=30000 where employee_id=100;
--update employees set salary=salary+100 where department_id=20;
--update employees set salary=salary+100 where department_id=50;
--update employees set salary=salary+100;
--
--select * from employees where employee_id=100;





--row level trigger with :old and :new pseudo records
create or replace trigger trg_update_of_salary before update of salary on employees
FOR EACH ROW when (new.salary>100000)
begin
DBMS_OUTPUT.PUT_line('old salary'|| :old.salary);
DBMS_OUTPUT.PUT_line('new salary'|| :new.salary);
if((((:new.salary-:old.salary)/:old.salary)*100)>60)then
:new.salary :=  :old.salary+1000;
end if;
DBMS_OUTPUT.PUT_line('Updatting of Salary is successful!!');
end;


--Execute below statements and check the result

--update employees set salary=30000 where employee_id=100;
--update employees set salary=salary+100 where department_id=20;
--update employees set salary=salary+100 where department_id=50;
--update employees set salary=salary+100;
--
--select * from employees where employee_id=100;


set SERVEROUTPUT ON;


--row level trigger with when clause

create or replace trigger trg_update_of_salary before update of salary on employees
FOR EACH ROW when (new.salary>100000)
begin
DBMS_OUTPUT.PUT_line('Updatting of Salary is successful!!');
end;


--Execute below statements and check the result

--update employees set salary=30000 where employee_id=100;
--update employees set salary=100001 where employee_id=100;


--same trigger for multiple DML operations

create or replace trigger trg_update_of_salary before update or delete or insert  on employees
FOR EACH ROW 
begin
DBMS_OUTPUT.PUT_line('old salary'|| :old.salary);
DBMS_OUTPUT.PUT_line('new salary'|| :new.salary);
if((((:new.salary-:old.salary)/:old.salary)*100)>60)then
:new.salary :=  :old.salary+1000;
end if;
DBMS_OUTPUT.PUT_line('Updatting of Salary is successful!!');
end;

--Excecute the below queries and see the results

--update employees set salary=100001 where employee_id=100;
--insert into employees values (998,'df','kf','sdfsyf','sg457447',sysdate,'AD_PRES',1,0,100,50);
--delete from employees where employee_id=998;
--select * from employees where employee_id=100;


set SERVEROUTPUT ON;

--usage of INSERTING UPDATING DELETING keywords inside the trigger
create or replace trigger trg_update_of_salary before update or delete or insert  on employees
FOR EACH ROW 
begin
DBMS_OUTPUT.PUT_line('old salary'|| :old.salary);
DBMS_OUTPUT.PUT_line('new salary'|| :new.salary);
if(Inserting)then
DBMS_OUTPUT.PUT_line('Inserting of Salary is successful!!');
end if;
if(updating)then
DBMS_OUTPUT.PUT_line('updating of Salary is successful!!');
end if;
if(deleting)then
DBMS_OUTPUT.PUT_line('deleting of Salary is successful!!');
end if;
end;



--Excecute the below queries and see the results

--update employees set salary=100001 where employee_id=100;
--insert into employees values (998,'df','kf','sdfsyf','sg457447',sysdate,'AD_PRES',1,0,100,50);
--delete from employees where employee_id=998;
--select * from employees where employee_id=100;


--commit rollback statements should not be written inside trigegr
--Exceptions should not be handled inside the trigger
create or replace trigger trg_update_of_salary1 before update or delete or insert  on employees
FOR EACH ROW 
begin
commit;
end;

begin
update employees set salary=9000 where employee_id=100;
end;

