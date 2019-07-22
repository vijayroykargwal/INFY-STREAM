create or replace  procedure say_hi_9767(ERRBUF out varchar2,RETCODE OUT Varchar2)
as

begin
fnd_file.put_line(fnd_file.output,'Hi');
fnd_file.put_line(fnd_file.log,'Hi in log');
end;

set serveroutput on;
begin
say_hi_9767();
end;