-- TABLE CREATION SCRIPT --

DROP TABLE LETSGO_USERS CASCADE CONSTRAINTS;
DROP TABLE VEHICLE CASCADE CONSTRAINTS;
DROP TABLE RESERVATION CASCADE CONSTRAINTS;

COMMIT;

CREATE TABLE LETSGO_USERS
(
   USER_ID           NUMBER PRIMARY KEY,
   USER_NAME         VARCHAR2 (50),
   NO_OF_BOOKINGS    NUMBER
);


CREATE TABLE VEHICLE
(
   VEHICLE_ID        VARCHAR2 (50) PRIMARY KEY,
   VEHICLE_TYPE      VARCHAR2 (50),
   FROM_STN          VARCHAR2 (50),
   TO_STN            VARCHAR2 (50),
   DEPARTURE_TIME    NUMBER,
   ARRIVAL_TIME      NUMBER,
   ADULT_FARE        NUMBER,
   CHILD_FARE        NUMBER,
   AVAILABLE_SEATS   NUMBER
);


CREATE TABLE RESERVATION
(
   RESERVATION_ID NUMBER PRIMARY KEY,
   USER_ID NUMBER REFERENCES LETSGO_USERS(USER_ID),
   VEHICLE_ID VARCHAR2(10) REFERENCES VEHICLE(VEHICLE_ID),
   NO_OF_ADULTS NUMBER,
   NO_OF_CHILDREN NUMBER,
   STATUS CHAR(3)
);

COMMIT;

-- DATA INSERTIION --

-- LETSGO_USERS DATA --
INSERT INTO LETSGO_USERS(USER_ID, USER_NAME) VALUES(1, 'AMAR');
INSERT INTO LETSGO_USERS(USER_ID, USER_NAME) VALUES(2, 'BENNY');
INSERT INTO LETSGO_USERS(USER_ID, USER_NAME) VALUES(3, 'CAROL');
INSERT INTO LETSGO_USERS(USER_ID, USER_NAME) VALUES(4, 'DANISH');
INSERT INTO LETSGO_USERS(USER_ID, USER_NAME) VALUES(5, 'EVE');
INSERT INTO LETSGO_USERS(USER_ID, USER_NAME) VALUES(6, 'FANNY');
INSERT INTO LETSGO_USERS(USER_ID, USER_NAME) VALUES(7, 'GAYLE');

-- VECHICLE DATA--
INSERT INTO VEHICLE VALUES('T1001', 'TRAIN','CHENNAI', 'MYSORE', 12, 23, 200, 100, 150); 
INSERT INTO VEHICLE VALUES('T1002', 'TRAIN','MYSORE', 'BANGLORE', 6, 10, 100, 50, 150);
INSERT INTO VEHICLE VALUES('T1003','TRAIN', 'DELHI', 'AGRA', 10, 14, 400, 200, 150);
INSERT INTO VEHICLE VALUES('T1004','TRAIN', 'MUMBAI', 'PUNE', 12, 18, 250, 110, 150);
INSERT INTO VEHICLE VALUES('T1005','TRAIN', 'CHANDIGARH', 'DELHI', 8, 15, 300, 150, 150);
-- BUS --
INSERT INTO VEHICLE VALUES('B1001','BUS', 'CHENNAI', 'MYSORE', 8, 23, 1000, 500, 40); 
INSERT INTO VEHICLE VALUES('B1002', 'BUS','MYSORE', 'BANGLORE', 10, 14, 400, 250, 40); 
INSERT INTO VEHICLE VALUES('B1003','BUS', 'CHENNAI', 'MYSORE', 10, 21, 1000, 500, 40); 
INSERT INTO VEHICLE VALUES('B1004','BUS', 'DELHI', 'AGRA', 10, 16, 700, 400, 40); 
INSERT INTO VEHICLE VALUES('B1005','BUS', 'CHENNAI', 'MYSORE', 8, 23, 1600, 900, 40); 
INSERT INTO VEHICLE VALUES('B1006', 'BUS','DELHI', 'SHIMLA', 8, 18, 1800, 900, 40); 
INSERT INTO VEHICLE VALUES('B1007','BUS', 'CHANDIGARH', 'DELHI', 4,14, 2000, 1200, 40); 
INSERT INTO VEHICLE VALUES('B1008', 'BUS','CHENNAI', 'MADURAI', 8, 14, 800, 500, 40);

COMMIT;
set SERVEROUTPUT ON;
SELECT * FROM LETSGO_USERS;

SELECT * FROM VEHICLE;

SELECT * FROM RESERVATION;

------------------------------------------starting---------------------------------
-------sequence------------
create sequence seq_Reservation_Id
start with 7001
increment by 1;
---------package specification--------------
create or replace package pkg_TravelBooking as
procedure booking(p_user_id reservation.user_id%type,p_vehicle_id vehicle.vehicle_id%type, p_no_of_adults reservation.no_of_adults%type,
p_no_of_children reservation.no_of_children%type);
procedure CancelBooking(p_reservation_ID reservation.reservation_ID%type,p_user_id reservation.user_ID%type,p_StatusCode out pls_integer);
type type_vehicleDetails_tab is table of vehicle%rowtype;
col_vehicle_details type_vehicleDetails_tab:=type_vehicleDetails_tab();
end;
-------package body------
create or replace package body pkg_TravelBooking is
function CalculateFare(p_vehicle_id vehicle.vehicle_id%type,p_no_of_adults reservation.no_of_adults%type,p_no_of_children reservation.no_of_children%type) 
return number is
v_total_fare number(10);
v_adult_fare vehicle.adult_fare%type;
v_child_fare vehicle.child_fare%type;
begin
select adult_fare,child_fare into v_adult_fare,v_child_fare from vehicle where vehicle_id=p_vehicle_id;
v_total_fare := v_adult_fare*p_no_of_adults + v_child_fare*p_no_of_children;
return v_total_fare;
exception
when others then
return('something went wrong in private function CalculateFare');
end CalculateFare;
------booking procedure--------
procedure booking(p_user_id reservation.user_id%type,p_vehicle_id vehicle.vehicle_id%type, p_no_of_adults reservation.no_of_adults%type,
p_no_of_children reservation.no_of_children%type) is
v_available_seats vehicle.available_seats%type;
v_total_fare number(10);
v_req_seats vehicle.available_seats%type;
begin
select available_seats into v_available_seats from vehicle where vehicle_id=p_vehicle_id;
v_req_seats := p_no_of_adults+p_no_of_children;
if(v_available_seats>=v_req_seats) then
v_total_fare := pkg_TravelBooking.CalculateFare(p_vehicle_id,p_no_of_adults,p_no_of_children);
insert into reservation values(seq_Reservation_Id.nextval,p_user_id,p_vehicle_id,p_no_of_adults,p_no_of_children,'CNF');
commit;
dbms_output.put_line('Reservation_id'||seq_Reservation_Id.nextval);
dbms_output.put_line('Total Fare:'||v_total_fare);
else
dbms_output.put_line('seats are not available in vehicle');
end if;
exception
when no_data_found then
dbms_output.put_line('no record for this vehicle');
when others then
dbms_output.put_line('something went wrong in booking procedur');
end booking;
----cancel booking procedure-----
procedure CancelBooking(p_reservation_ID reservation.reservation_ID%type,p_user_id reservation.user_ID%type,p_StatusCode out pls_integer) is
v_count_reservation_id pls_integer;
v_count_user_id pls_integer;
v_valid_reservation pls_integer;
begin
select count(reservation_id) into v_count_reservation_id from reservation where reservation_id=p_reservation_ID;
if v_count_reservation_id !=0 then 
select count(user_id) into v_count_user_id from  reservation where user_id=p_user_id;
if v_count_user_id!=0 then
select count(reservation_id) into  v_valid_reservation from reservation where reservation_id=p_reservation_ID and user_id = p_user_id;
if(v_valid_reservation !=0) then
update reservation set status='CAN' where reservation_id=p_reservation_ID and user_id = p_user_id;
else
p_StatusCode :=-3;
end if;
else
p_StatusCode :=-2;
end if;
else
p_StatusCode := -1;
end if;
exception
when others then
dbms_output.put_line('something went wrong in cancel booking');
end CancelBooking;
end;
----triggers---
create or replace trigger trg_update_av_seats after insert or update on reservation for each row
when (old.status='CAN' or old.status='CNF')
begin
if inserting then

update vehicle set available_seats=available_seats-(:old.no_of_adults + :old.no_of_children) where vehicle_id= :old.vehicle_id;
end if;
if updating then
update vehicle set available_seats=available_seats+(:old.no_of_adults + :old.no_of_children) where vehicle_id= :old.vehicle_id;
end if;
end trg_update_av_seats;
-----function---
create or replace function sf_RetrieveVehicleDetails(p_from_stn vehicle.from_stn%type,p_to_stn vehicle.to_stn%type,
p_departure_time vehicle.departure_time%type) 
return pkg_TravelBooking.type_vehicleDetails_tab is
begin
select * bulk collect into pkg_TravelBooking.col_vehicle_details from vehicle where from_stn = p_from_stn and to_stn=p_to_stn 
and departure_time>=p_departure_time;
return pkg_TravelBooking.col_vehicle_details;
end sf_RetrieveVehicleDetails;
---driver ptogram---
set serveroutput on;
declare
v_vehicle_details pkg_TravelBooking.type_vehicleDetails_tab;
begin
v_vehicle_details :=sf_RetrieveVehicleDetails('CHENNAI', 'MYSORE',10);
for veh_details in v_vehicle_details.first..v_vehicle_details.last 
loop
DBMS_OUTPUT.PUT_LINE('***************vehicle_details*****************');
DBMS_OUTPUT.PUT_LINE('Vehicle_type'||' : '||v_vehicle_details(veh_details).vehicle_type);
DBMS_OUTPUT.PUT_LINE('from_stn'||' : '||v_vehicle_details(veh_details).from_stn);
DBMS_OUTPUT.PUT_LINE('to_stn'||' : '||v_vehicle_details(veh_details).to_stn);
DBMS_OUTPUT.PUT_LINE('departure_time'||' : '||v_vehicle_details(veh_details).departure_time);
DBMS_OUTPUT.PUT_LINE('arrival_time'||' : '||v_vehicle_details(veh_details).arrival_time);
DBMS_OUTPUT.PUT_LINE('adult_fare'||' : '||v_vehicle_details(veh_details).adult_fare);
DBMS_OUTPUT.PUT_LINE('child_fare'||' : '||v_vehicle_details(veh_details).child_fare);
DBMS_OUTPUT.PUT_LINE('available_seats'||' : '||v_vehicle_details(veh_details).available_seats);
DBMS_OUTPUT.PUT_LINE('*********************************************');
end loop;
end;


end loop;
end;