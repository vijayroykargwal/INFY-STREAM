create or replace procedure xx_verify_emp_1039766(ERRBUFF out varchar2,RETCODE out varchar2,p_empid in number,p_country varchar2,p_city varchar2)
is

 rec_emp  xx_emp_verify_due%rowtype;
 v_count_emp number(1);
 v_count_loc number(1);
 v_salary xx_employees.salary%type;
 v_incr_sal xx_employees.salary%type;

begin
select * into rec_emp from xx_emp_verify_due where emp_id=p_empid;
select count(employee_id) into v_count_emp from xx_employees where employee_id=rec_emp.emp_id;
if v_count_emp>0 then
  select count(city) into v_count_loc from xx_locations where city=rec_emp.loc;
  if v_count_loc>0 then
    select salary into v_salary from xx_employees where employee_id=rec_emp.emp_id;
    select salary*1.1 into v_incr_sal from xx_employees where employee_id=rec_emp.emp_id;
    fnd_file.put_line(fnd_file.output,'salary: '||v_salary||' Incremented Salary: '||v_incr_sal);
    --fnd_file.put_line(fnd_file.output,'verified successfully');
    fnd_message.set_name('SQSGL','XX_VERIFY_SUCCESS_MSG_9767');
    
    v_success_msg := fnd_message.get;
    fnd_file.put_line(fnd_file.output,v_success_msg);
    v_user_id := fnd_user.value('USER_ID');
    select user_name into v_user_name from fnd_user where user_id=v_user_id;
    fnd_file.put_line(fnd_file.output,'request submitted for: '||p_city||' '||p_country);
  else
     --fnd_file.put_line(fnd_file.log,'invalid location');
     fnd_message.set_name('SQSGL','XX_INVALID_LOC_ID_MSG_9767');
     v_loc_error_msg := fnd_message.get;
     fnd_file.put_line(fnd_file.output,v_loc_error_msg);
  end if;
else
     fnd_file.put_line(fnd_file.log,'invalid emp id');
end if;
end;
---------------------------------------------------------------------------------------





p_country varchar2,p_city varchar2

create or replace procedure abhi_187(
  ERRBUFF out varchar2,RETCODE out varchar2,p_emp in number)
is
begin
fnd_file.put_line(fnd_file.output,'hello');
fnd_file.put_line(fnd_file.log,'invalid location');
end;

  select * from xx_employees;