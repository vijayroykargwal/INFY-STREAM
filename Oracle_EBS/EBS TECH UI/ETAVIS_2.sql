create or replace  procedure say_hi_9767_v2(ERRBUF out varchar2,RETCODE OUT Varchar2)
as
begin
fnd_file.put_line(fnd_file.output,'Hi in output');
fnd_file.put_line(fnd_file.log,'Hi in log');
end;

set serveroutput on;
begin
say_hi_9767_v2();
end;


create or replace  procedure factorial_of_number_9767(ERRBUF out varchar2,RETCODE OUT Varchar2)
as
v_Number number(5) := 5;
v_factorial number(5):=1;
begin
for i in 1..v_number
loop
v_factorial := i*v_factorial;
end loop;
fnd_file.put_line(fnd_file.output,v_factorial);
fnd_file.put_line(fnd_file.log,v_factorial);
end;

declare
p pls_integer;
q pls_integer;
begin
factorial_of_number_9767(p,q);
end;


select * from xx_emp_verify_due
select * from xx_employees
select * from xx_locations
-------------------------------------------------------------------------

create or replace procedure display_salary_9767(ERRBUF out varchar2,RETCODE OUT Varchar2) as
v_count_emp pls_integer;
v_count_location pls_integer;
v_salary number(5);
type rec_emp_details is record(employee_id xx_employees.employee_id%type,
loc xx_locations.city%type);
type type_emp_details is table of rec_emp_details;
col_emp_details type_emp_details := type_emp_details();
begin
select emp_id,loc bulk collect into col_emp_details from xx_emp_verify_due;


for i in col_emp_details.first..col_emp_details.last
loop
select count(employee_id) into v_count_emp from XX_employees where employee_id = col_emp_details(i).employee_id;
if v_count_emp > 0 then
select count(city) into v_count_location from XX_locations where city = col_emp_details(i).loc ;
if v_count_location > 0 then 
select 1.1*salary into v_salary from xx_employees where employee_id = col_emp_details(i).employee_id;
fnd_file.put_line(fnd_file.output,'successfully verification completed'||col_emp_details(i).employee_id ||'  '||v_salary);
else
fnd_file.put_line(fnd_file.log,'location not found for these employees'||col_emp_details(i).employee_id);
end if;
else
fnd_file.put_line(fnd_file.log,'employees not found'||col_emp_details(i).employee_id);
end if;
end loop;
end;


------------------------------------------------------------------------------------------



create or replace procedure display_salary_9767(ERRBUF out varchar2,RETCODE OUT Varchar2,p_empid,p_country) as
v_count_emp pls_integer;
v_count_location pls_integer;
v_salary number(5);
rec_emp_details xx_emp_verify_due%rowtype;
begin
select * into rec_emp_details from xx_emp_verify_due;


for i in col_emp_details.first..col_emp_details.last
loop
select count(employee_id) into v_count_emp from XX_employees where employee_id = col_emp_details(i).employee_id;
if v_count_emp > 0 then
select count(city) into v_count_location from XX_locations where city = col_emp_details(i).loc ;
if v_count_location > 0 then 
select 1.1*salary into v_salary from xx_employees where employee_id = col_emp_details(i).employee_id;
fnd_file.put_line(fnd_file.output,'successfully verification completed'||col_emp_details(i).employee_id ||'  '||v_salary);
else
fnd_file.put_line(fnd_file.log,'location not found for these employees'||col_emp_details(i).employee_id);
end if;
else
fnd_file.put_line(fnd_file.log,'employees not found'||col_emp_details(i).employee_id);
end if;
end loop;
end;
----------------------------------------------------------------------------------------------------------------------------
select * from manu_info
select * from wh_info
select * from model_info

create or replace procedure display_mob_details_9767(ERRBUF out varchar2,RETCODE OUT Varchar2,p_model_id in number,p_loc_id in varchar2,p_city in varchar2) is
v_price model_info.price%type;
v_count_mob pls_integer;
v_model_name model_info.model_name%type;
begin
    select count(model_id) into v_count_mob from model_info where model_id = p_model_id;
    if v_count_mob > 0 then
    select MODEL_NAME,price*1.05 into v_model_name,v_price from model_info where model_id=p_model_id;
    fnd_file.put_line(fnd_file.output,'Model Name: '||v_model_name||'   '||'price: '||v_price);
    fnd_file.put_line(fnd_file.output,'request submitted for: '||p_city);
    fnd_file.put_line(fnd_file.log,'Order Succussfuly Placed');
  else
     fnd_file.put_line(fnd_file.log,'invalid Model Name');
     end if;
end;


