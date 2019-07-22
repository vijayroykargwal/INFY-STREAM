-----------------------------Records---------------


DECLARE
--declaring record type
type type_emp_info IS record
  ( eid      NUMBER(4),
    jtitle   VARCHAR2(30),
    dname    VARCHAR2 (30),
    h_status BOOLEAN );
    
  --creating record of record type declared above
  rec_emp_info type_emp_info;
  
BEGIN
  SELECT employee_id, job_title,department_name INTO rec_emp_info.eid,  rec_emp_info.jtitle,  rec_emp_info.dname
  FROM employees e, jobs j,  departments d WHERE e.department_id=d.department_id
  AND e.job_id =j.job_id  AND employee_id =100;
  
  DBMS_OUTPUT.put_line(rec_emp_info.eid);
  DBMS_OUTPUT.put_line(rec_emp_info.jtitle);
  DBMS_OUTPUT.put_line(rec_emp_info.dname);
  rec_emp_info.h_status:=True;
END;




------------------------------PAckages-------------

--stand-alone procedure
CREATE OR REPLACE PROCEDURE sp_update_salary( p_employee_id IN NUMBER)
IS
  v_department_id NUMBER(6);
BEGIN
  DBMS_OUTPUT.PUT_LINE('sp_update_salary called');
END;


--stand-alone function
CREATE OR REPLACE FUNCTION sf_get_name(p_employee_id NUMBER)RETURN VARCHAR2
IS
  v_name        VARCHAR2(25);
  v_employee_id NUMBER(6);
BEGIN
  DBMS_OUTPUT.PUT_LINE('sf_get_name called');
  RETURN 'S';
END;



--creating a package to include above stored procedure and stored function

--1 package specification
CREATE OR REPLACE PACKAGE pkg_emp_functionalities
IS
  PROCEDURE sp_update_salary( p_employee_id IN NUMBER);
  FUNCTION sf_get_name(p_employee_id NUMBER)RETURN VARCHAR2;
END;

--1 package body
CREATE OR REPLACE PACKAGE body pkg_emp_functionalities
IS
  PROCEDURE sp_update_salary(p_employee_id IN NUMBER)
  IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('sp_update_salary called');
  END;
  
  FUNCTION sf_get_name(p_employee_id NUMBER)RETURN VARCHAR2
  IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('sf_get_name_1 called---Numbers');
    RETURN 'S';
  END;
  
END;


--calling procedure and function inside the package

begin
DBMS_OUTPUT.PUT_line(pkg_emp_functionalities.sf_get_name(100));
end;





----------------------------------------------------------body less package and usages

--bodyless package
create or replace package pkg_emp_functionalities
is
e_insufficient_salary exception;
v_employee_count number(3):=45;
end;


--use variables /types / exceptions declared in package with the scope of session
begin
DBMS_OUTPUT.PUT_line(pkg_emp_functionalities.v_employee_count);
pkg_emp_functionalities.v_employee_count:=50;
DBMS_OUTPUT.PUT_line(pkg_emp_functionalities.v_employee_count);
Exception
when pkg_emp_functionalities.e_insufficient_salary then
DBMS_OUTPUT.PUT_line('Exception declared in package can be used here as its in the same session');
end;



------------------------------------------------------------overloading of functions in packages\\

--1 package specification
CREATE OR REPLACE PACKAGE pkg_emp_functionalities
IS
  PROCEDURE sp_update_salary( p_employee_id IN NUMBER);
  FUNCTION sf_get_name(p_employee_id NUMBER)RETURN VARCHAR2;
  FUNCTION sf_get_name(p_employee_id varchar2)RETURN VARCHAR2;
END;

--1 package body
CREATE OR REPLACE PACKAGE body pkg_emp_functionalities
IS
  PROCEDURE sp_update_salary(p_employee_id IN NUMBER)
  IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('sp_update_salary called');
  END;
  
  FUNCTION sf_get_name(p_employee_id NUMBER)RETURN VARCHAR2
  IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('sf_get_name_1 called---Numbers');
    RETURN 'S';
  END;
  
   FUNCTION sf_get_name(p_employee_id varchar2)RETURN VARCHAR2
  IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('sf_get_name_1 called---Numbers');
    RETURN 'S';
  END;
END;


--calling procedure and function inside the package

begin
DBMS_OUTPUT.PUT_line(pkg_emp_functionalities.sf_get_name(100));--calls the one with number para
DBMS_OUTPUT.PUT_line(pkg_emp_functionalities.sf_get_name('100'));--calls the one with varhar2 para
end;




