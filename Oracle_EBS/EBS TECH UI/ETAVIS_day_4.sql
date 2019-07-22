PO_HEADERS_ALL
TAKE INPUT THE VENDOR ID


DISPLAYS
PO_HEADER_ID
TYPE_LOOKUP_CODE
VENDOR_ID
VENDOR_SITE_ID
------------------------------------------------------------------------------
create or replace procedure XX_PO_REPORT_9767(ERRBUF OUT VARCHAR2,
RETCODE OUT VARCHAR2,
p_vendor_id in number) is
v_vendor_id po_vendors.vendor_id%type;
v_vendor_name po_vendors.vendor_name%type;
begin

for rec_vendor_details in (select distinct pha.po_header_id,pha.type_lookup_code,pov.vendor_id,pha.vendor_site_id   
from po_vendors pov join po_headers_all pha on
pov.vendor_id = pha.vendor_id where pov.vendor_id=p_vendor_id)
loop
fnd_file.put_line(fnd_file.output,rec_vendor_details.po_header_id);
fnd_file.put_line(fnd_file.output,rec_vendor_details.type_lookup_code);
fnd_file.put_line(fnd_file.output,rec_vendor_details.vendor_id);
fnd_file.put_line(fnd_file.output,rec_vendor_details.vendor_site_id);
fnd_file.put_line(fnd_file.output,'-------------------------------------');

end loop;
exception
when others then
fnd_file.put_line(fnd_file.log,'Something went wrong');
end;





select * from po_vendors
select * from po_headers_all