ALTER TABLE REGIONS
 DROP PRIMARY KEY CASCADE;

DROP TABLE REGIONS CASCADE CONSTRAINTS;

CREATE TABLE REGIONS
(
  REGION_ID    NUMBER(2) CONSTRAINT REGION_ID_NN NOT NULL,
  REGION_NAME  VARCHAR2(25 BYTE)
);

CREATE UNIQUE INDEX REG_ID_PK ON REGIONS
(REGION_ID);

ALTER TABLE REGIONS ADD (
  CONSTRAINT REG_ID_PK
  PRIMARY KEY
  (REGION_ID)
  USING INDEX REG_ID_PK
  ENABLE VALIDATE);
/

ALTER TABLE COUNTRIES
 DROP PRIMARY KEY CASCADE;

DROP TABLE COUNTRIES CASCADE CONSTRAINTS;

CREATE TABLE COUNTRIES
(
  COUNTRY_ID    CHAR(2 BYTE) CONSTRAINT COUNTRY_ID_NN NOT NULL,
  COUNTRY_NAME  VARCHAR2(40 BYTE),
  REGION_ID     NUMBER(2)
);

CREATE UNIQUE INDEX COUNTRY_C_ID_PK ON COUNTRIES
(COUNTRY_ID);

ALTER TABLE COUNTRIES ADD (
  CONSTRAINT COUNTRY_C_ID_PK
  PRIMARY KEY
  (COUNTRY_ID)
  USING INDEX COUNTRY_C_ID_PK
  ENABLE VALIDATE);

ALTER TABLE COUNTRIES ADD (
  CONSTRAINT COUNTR_REG_FK 
  FOREIGN KEY (REGION_ID) 
  REFERENCES REGIONS (REGION_ID)
  ENABLE VALIDATE);
/
  
ALTER TABLE LOCATIONS
 DROP PRIMARY KEY CASCADE;

DROP TABLE LOCATIONS CASCADE CONSTRAINTS;

CREATE TABLE LOCATIONS
(
  LOCATION_ID     NUMBER(4),
  STREET_ADDRESS  VARCHAR2(40 BYTE),
  POSTAL_CODE     VARCHAR2(12 BYTE),
  CITY            VARCHAR2(30 BYTE) CONSTRAINT LOC_CITY_NN NOT NULL,
  STATE_PROVINCE  VARCHAR2(25 BYTE),
  COUNTRY_ID      CHAR(2 BYTE)
);

CREATE INDEX LOC_CITY_IX ON LOCATIONS
(CITY);

CREATE INDEX LOC_COUNTRY_IX ON LOCATIONS
(COUNTRY_ID);

CREATE UNIQUE INDEX LOC_ID_PK ON LOCATIONS
(LOCATION_ID);

CREATE INDEX LOC_STATE_PROVINCE_IX ON LOCATIONS
(STATE_PROVINCE);


ALTER TABLE LOCATIONS ADD (
  CONSTRAINT LOC_ID_PK
  PRIMARY KEY
  (LOCATION_ID)
  USING INDEX LOC_ID_PK
  ENABLE VALIDATE);

ALTER TABLE LOCATIONS ADD (
  CONSTRAINT LOC_C_ID_FK 
  FOREIGN KEY (COUNTRY_ID) 
  REFERENCES COUNTRIES (COUNTRY_ID)
  ENABLE VALIDATE);
/
  
ALTER TABLE JOBS
 DROP PRIMARY KEY CASCADE;

DROP TABLE JOBS CASCADE CONSTRAINTS;

CREATE TABLE JOBS
(
  JOB_ID      VARCHAR2(10 BYTE),
  JOB_TITLE   VARCHAR2(35 BYTE) CONSTRAINT JOB_TITLE_NN NOT NULL,
  MIN_SALARY  NUMBER(6),
  MAX_SALARY  NUMBER(6)
);

CREATE INDEX JOB_ID_PK ON JOBS
(JOB_ID);

ALTER TABLE JOBS ADD (
  CONSTRAINT JOB_ID_PK
  PRIMARY KEY
  (JOB_ID)
  USING INDEX JOB_ID_PK
  ENABLE VALIDATE);
/

ALTER TABLE DEPARTMENTS
 DROP PRIMARY KEY CASCADE;

DROP TABLE DEPARTMENTS CASCADE CONSTRAINTS;

CREATE TABLE DEPARTMENTS
(
  DEPARTMENT_ID    NUMBER(4),
  DEPARTMENT_NAME  VARCHAR2(30 BYTE) CONSTRAINT DEPT_NAME_NN NOT NULL,
  MANAGER_ID       NUMBER(6),
  LOCATION_ID      NUMBER(4)
);

CREATE UNIQUE INDEX DEPT_ID_PK ON DEPARTMENTS
(DEPARTMENT_ID);

ALTER TABLE DEPARTMENTS ADD (
  CONSTRAINT DEPT_ID_PK
  PRIMARY KEY
  (DEPARTMENT_ID)
  USING INDEX DEPT_ID_PK
  ENABLE VALIDATE);
  /
  
ALTER TABLE EMPLOYEES
 DROP PRIMARY KEY CASCADE;

DROP TABLE EMPLOYEES CASCADE CONSTRAINTS;

CREATE TABLE EMPLOYEES
(
  EMPLOYEE_ID     NUMBER(6),
  FIRST_NAME      VARCHAR2(20 BYTE),
  LAST_NAME       VARCHAR2(25 BYTE) CONSTRAINT EMP_LAST_NAME_NN NOT NULL,
  EMAIL           VARCHAR2(25 BYTE) CONSTRAINT EMP_EMAIL_NN NOT NULL,
  PHONE_NUMBER    VARCHAR2(20 BYTE),
  HIRE_DATE       DATE CONSTRAINT EMP_HIRE_DATE_NN NOT NULL,
  JOB_ID          VARCHAR2(10 BYTE) CONSTRAINT EMP_JOB_NN NOT NULL,
  SALARY          NUMBER(8,2),
  COMMISSION_PCT  NUMBER(2,2),
  MANAGER_ID      NUMBER(6),
  DEPARTMENT_ID   NUMBER(4)
);

CREATE INDEX EMP_DEPARTMENT_IX ON EMPLOYEES
(DEPARTMENT_ID);

CREATE UNIQUE INDEX EMP_EMAIL_UK ON EMPLOYEES
(EMAIL);

CREATE UNIQUE INDEX EMP_EMP_ID_PK ON EMPLOYEES
(EMPLOYEE_ID);

CREATE INDEX EMP_JOB_IX ON EMPLOYEES
(JOB_ID);

CREATE INDEX EMP_MANAGER_IX ON EMPLOYEES
(MANAGER_ID);

CREATE INDEX EMP_NAME_IX ON EMPLOYEES
(LAST_NAME, FIRST_NAME);

ALTER TABLE EMPLOYEES ADD (
  CONSTRAINT EMP_SALARY_MIN
  CHECK (salary > 0)
  ENABLE VALIDATE,
  CONSTRAINT EMP_EMP_ID_PK
  PRIMARY KEY
  (EMPLOYEE_ID)
  USING INDEX EMP_EMP_ID_PK
  ENABLE VALIDATE,
  CONSTRAINT EMP_EMAIL_UK
  UNIQUE (EMAIL)
  USING INDEX EMP_EMAIL_UK
  ENABLE VALIDATE);

ALTER TABLE DEPARTMENTS ADD (
  CONSTRAINT DEPT_LOC_FK 
  FOREIGN KEY (LOCATION_ID) 
  REFERENCES LOCATIONS (LOCATION_ID)
  ENABLE VALIDATE,
  CONSTRAINT DEPT_MGR_FK 
  FOREIGN KEY (MANAGER_ID) 
  REFERENCES EMPLOYEES (EMPLOYEE_ID)
  ENABLE VALIDATE);

ALTER TABLE EMPLOYEES ADD (
  CONSTRAINT EMP_DEPT_FK 
  FOREIGN KEY (DEPARTMENT_ID) 
  REFERENCES DEPARTMENTS (DEPARTMENT_ID)
  ENABLE VALIDATE,
  CONSTRAINT EMP_JOB_FK 
  FOREIGN KEY (JOB_ID) 
  REFERENCES JOBS (JOB_ID)
  ENABLE VALIDATE,
  CONSTRAINT EMP_MANAGER_FK 
  FOREIGN KEY (MANAGER_ID) 
  REFERENCES EMPLOYEES (EMPLOYEE_ID)
  ENABLE VALIDATE);
/

ALTER TABLE JOB_HISTORY
 DROP PRIMARY KEY CASCADE;

DROP TABLE JOB_HISTORY CASCADE CONSTRAINTS;

CREATE TABLE JOB_HISTORY
(
  EMPLOYEE_ID    NUMBER(6) CONSTRAINT JHIST_EMPLOYEE_NN NOT NULL,
  START_DATE     DATE,
  END_DATE       DATE,
  JOB_ID         VARCHAR2(10 BYTE) CONSTRAINT JHIST_JOB_NN NOT NULL,
  DEPARTMENT_ID  NUMBER(4)
);

CREATE INDEX JHIST_DEPARTMENT_IX ON JOB_HISTORY
(DEPARTMENT_ID);

CREATE INDEX JHIST_EMPLOYEE_IX ON JOB_HISTORY
(EMPLOYEE_ID);

CREATE UNIQUE INDEX JHIST_EMP_ID_ST_DATE_PK ON JOB_HISTORY
(EMPLOYEE_ID, START_DATE);

CREATE INDEX JHIST_JOB_IX ON JOB_HISTORY
(JOB_ID);




SET DEFINE OFF;
Insert into REGIONS
   (REGION_ID, REGION_NAME)
 Values
   (1, 'Europe');
Insert into REGIONS
   (REGION_ID, REGION_NAME)
 Values
   (2, 'Americas');
Insert into REGIONS
   (REGION_ID, REGION_NAME)
 Values
   (3, 'Asia');
Insert into REGIONS
   (REGION_ID, REGION_NAME)
 Values
   (4, 'Middle East and Africa');
COMMIT;

SET DEFINE OFF;
Insert into COUNTRIES
   (COUNTRY_ID, COUNTRY_NAME, REGION_ID)
 Values
   ('AR', 'Argentina', 2);
Insert into COUNTRIES
   (COUNTRY_ID, COUNTRY_NAME, REGION_ID)
 Values
   ('AU', 'Australia', 3);
Insert into COUNTRIES
   (COUNTRY_ID, COUNTRY_NAME, REGION_ID)
 Values
   ('BE', 'Belgium', 1);
Insert into COUNTRIES
   (COUNTRY_ID, COUNTRY_NAME, REGION_ID)
 Values
   ('BR', 'Brazil', 2);
Insert into COUNTRIES
   (COUNTRY_ID, COUNTRY_NAME, REGION_ID)
 Values
   ('CA', 'Canada', 2);
Insert into COUNTRIES
   (COUNTRY_ID, COUNTRY_NAME, REGION_ID)
 Values
   ('CH', 'Switzerland', 1);
Insert into COUNTRIES
   (COUNTRY_ID, COUNTRY_NAME, REGION_ID)
 Values
   ('CN', 'China', 3);
Insert into COUNTRIES
   (COUNTRY_ID, COUNTRY_NAME, REGION_ID)
 Values
   ('DE', 'Germany', 1);
Insert into COUNTRIES
   (COUNTRY_ID, COUNTRY_NAME, REGION_ID)
 Values
   ('DK', 'Denmark', 1);
Insert into COUNTRIES
   (COUNTRY_ID, COUNTRY_NAME, REGION_ID)
 Values
   ('IN', 'INDIA', 3);
COMMIT;

SET DEFINE OFF;
Insert into LOCATIONS
   (LOCATION_ID, STREET_ADDRESS, POSTAL_CODE, CITY, STATE_PROVINCE, 
    COUNTRY_ID)
 Values
   (1800, '147 Spadina Ave', 'M5V 2L7', 'Toronto', 'Ontario', 
    'CA');
Insert into LOCATIONS
   (LOCATION_ID, STREET_ADDRESS, POSTAL_CODE, CITY, STATE_PROVINCE, 
    COUNTRY_ID)
 Values
   (1700, '6092 Boxwood St', 'YSW 9T2', 'Whitehorse', 'Yukon', 
    'CA');
Insert into LOCATIONS
   (LOCATION_ID, STREET_ADDRESS, POSTAL_CODE, CITY, COUNTRY_ID)
 Values
   (1400, '40-5-12 Laogianggen', '190518', 'Beijing', 'CN');
Insert into LOCATIONS
   (LOCATION_ID, STREET_ADDRESS, POSTAL_CODE, CITY, STATE_PROVINCE, 
    COUNTRY_ID)
 Values
   (1500, '1298 Vileparle (E)', '490231', 'Bombay', 'Maharashtra', 
    'IN');
Insert into LOCATIONS
   (LOCATION_ID, STREET_ADDRESS, POSTAL_CODE, CITY, STATE_PROVINCE, 
    COUNTRY_ID)
 Values
   (2200, '12-98 Victoria Street', '2901', 'Sydney', 'New South Wales', 
    'AU');
Insert into LOCATIONS
   (LOCATION_ID, STREET_ADDRESS, POSTAL_CODE, CITY, STATE_PROVINCE, 
    COUNTRY_ID)
 Values
   (2700, 'Schwanthalerstr. 7031', '80925', 'Munich', 'Bavaria', 
    'DE');
Insert into LOCATIONS
   (LOCATION_ID, STREET_ADDRESS, POSTAL_CODE, CITY, STATE_PROVINCE, 
    COUNTRY_ID)
 Values
   (2800, 'Rua Frei Caneca 1360 ', '01307-002', 'Sao Paulo', 'Sao Paulo', 
    'BR');
Insert into LOCATIONS
   (LOCATION_ID, STREET_ADDRESS, POSTAL_CODE, CITY, STATE_PROVINCE, 
    COUNTRY_ID)
 Values
   (2900, '20 Rue des Corps-Saints', '1730', 'Geneva', 'Geneve', 
    'CH');
Insert into LOCATIONS
   (LOCATION_ID, STREET_ADDRESS, POSTAL_CODE, CITY, STATE_PROVINCE, 
    COUNTRY_ID)
 Values
   (3000, 'Murtenstrasse 921', '3095', 'Bern', 'BE', 
    'CH');
COMMIT;

SET DEFINE OFF;
Insert into JOBS
   (JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY)
 Values
   ('AD_PRES', 'President', 20000, 40000);
Insert into JOBS
   (JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY)
 Values
   ('FI_MGR', 'Finance Manager', 8200, 16000);
Insert into JOBS
   (JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY)
 Values
   ('FI_ACCOUNT', 'Accountant', 4200, 9000);
Insert into JOBS
   (JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY)
 Values
   ('PU_MAN', 'Purchasing Manager', 8000, 15000);
Insert into JOBS
   (JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY)
 Values
   ('ST_CLERK', 'Stock Clerk', 2000, 5000);
Insert into JOBS
   (JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY)
 Values
   ('IT_PROG', 'Programmer', 4000, 10000);
Insert into JOBS
   (JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY)
 Values
   ('MK_REP', 'Marketing Representative', 4000, 9000);
Insert into JOBS
   (JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY)
 Values
   ('PR_REP', 'Public Relations Representative', 4500, 10500);
Insert into JOBS
   (JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY)
 Values
    ('AD_VP','Administration Vice President',15000,30000);
Insert into JOBS
   (JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY)
 Values
    ('ST_MAN','Stock Manager',5500,8500);
Insert into JOBS
   (JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY)
 Values
    ('MK_MAN','Marketing Manager',9000,15000);
Insert into JOBS
   (JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY)
 Values
    ('AC_MGR','Accounting Manager',8200,16000);
Insert into JOBS
   (JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY)
 Values
    ('AD_ASST','Administration Assistant',3000,6000);
COMMIT;

SET DEFINE OFF;
Insert into DEPARTMENTS
   (DEPARTMENT_ID, DEPARTMENT_NAME, MANAGER_ID, LOCATION_ID)
 Values
   ('10', 'Administration', null, '1700');
Insert into DEPARTMENTS
   (DEPARTMENT_ID, DEPARTMENT_NAME, MANAGER_ID, LOCATION_ID)
 Values
   ('20', 'Marketing', null, '1800');
Insert into DEPARTMENTS
   (DEPARTMENT_ID, DEPARTMENT_NAME, MANAGER_ID, LOCATION_ID)
 Values
   ('30', 'Purchasing', null, '1700');
Insert into DEPARTMENTS
   (DEPARTMENT_ID, DEPARTMENT_NAME, MANAGER_ID, LOCATION_ID)
 Values
   ('50', 'Shipping', null, '1500');
Insert into DEPARTMENTS
   (DEPARTMENT_ID, DEPARTMENT_NAME, MANAGER_ID, LOCATION_ID)
 Values
   ('60', 'IT', null, '1400');
Insert into DEPARTMENTS
   (DEPARTMENT_ID, DEPARTMENT_NAME, MANAGER_ID, LOCATION_ID)
 Values
   ('70', 'Public Relations', null, '2700');
Insert into DEPARTMENTS
   (DEPARTMENT_ID, DEPARTMENT_NAME, MANAGER_ID, LOCATION_ID)
 Values
   ('90', 'Executive', null, '1700');
Insert into DEPARTMENTS
   (DEPARTMENT_ID, DEPARTMENT_NAME, MANAGER_ID, LOCATION_ID)
 Values
   ('100', 'Finance', null, '1700');
Insert into DEPARTMENTS
   (DEPARTMENT_ID, DEPARTMENT_NAME, MANAGER_ID, LOCATION_ID)
 Values
   ('110', 'Accounting', null, '1700');
COMMIT;


SET DEFINE OFF;
Insert into EMPLOYEES
   (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, 
    HIRE_DATE, JOB_ID, SALARY, DEPARTMENT_ID)
 Values
   (100, 'Steven', 'King', 'SKING', '515.123.4567', 
    TO_DATE('06/17/1987 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'AD_PRES', 24000, 90);
Insert into EMPLOYEES
   (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, 
    HIRE_DATE, JOB_ID, SALARY, MANAGER_ID, DEPARTMENT_ID)
 Values
   (103, 'Alexander', 'Hunold', 'AHUNOLD', '590.423.4567', 
    TO_DATE('01/03/1990 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'IT_PROG', 9000, null, 60);
Insert into EMPLOYEES
   (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, 
    HIRE_DATE, JOB_ID, SALARY, MANAGER_ID, DEPARTMENT_ID)
 Values
   (104, 'Bruce', 'Ernst', 'BERNST', '590.423.4568', 
    TO_DATE('05/21/1991 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'IT_PROG', 6000, null, 60);
Insert into EMPLOYEES
   (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, 
    HIRE_DATE, JOB_ID, SALARY, MANAGER_ID, DEPARTMENT_ID)
 Values
   (105, 'David', 'Austin', 'DAUSTIN', '590.423.4569', 
    TO_DATE('06/25/1997 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'IT_PROG', 4800, null, 60);
Insert into EMPLOYEES
   (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, 
    HIRE_DATE, JOB_ID, SALARY, MANAGER_ID, DEPARTMENT_ID)
 Values
   (106, 'Valli', 'Pataballa', 'VPATABAL', '590.423.4560', 
    TO_DATE('02/05/1998 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'IT_PROG', 4800, null, 60);
Insert into EMPLOYEES
   (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, 
    HIRE_DATE, JOB_ID, SALARY, MANAGER_ID, DEPARTMENT_ID)
 Values
   (107, 'Diana', 'Lorentz', 'DLORENTZ', '590.423.5567', 
    TO_DATE('02/07/1999 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'IT_PROG', 4200, null, 60);
Insert into EMPLOYEES
   (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, 
    HIRE_DATE, JOB_ID, SALARY, MANAGER_ID, DEPARTMENT_ID)
 Values
   (108, 'Nancy', 'Greenberg', 'NGREENBE', '515.124.4569', 
    TO_DATE('08/17/1994 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'FI_MGR', 12000, null, 100);
Insert into EMPLOYEES
   (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, 
    HIRE_DATE, JOB_ID, SALARY, MANAGER_ID, DEPARTMENT_ID)
 Values
   (109, 'Daniel', 'Faviet', 'DFAVIET', '515.124.4169', 
    TO_DATE('08/16/1994 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'FI_ACCOUNT', 9000, null, 100);
Insert into EMPLOYEES
   (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, 
    HIRE_DATE, JOB_ID, SALARY, MANAGER_ID, DEPARTMENT_ID)
 Values
   (110, 'John', 'Chen', 'JCHEN', '515.124.4269', 
    TO_DATE('09/28/1997 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'FI_ACCOUNT', 8200, null, 100);
Insert into EMPLOYEES
   (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, 
    HIRE_DATE, JOB_ID, SALARY, MANAGER_ID, DEPARTMENT_ID)
 Values
   (111, 'Ismael', 'Sciarra', 'ISCIARRA', '515.124.4369', 
    TO_DATE('09/30/1997 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'FI_ACCOUNT', 7700, null, 100);
Insert into EMPLOYEES
   (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, 
    HIRE_DATE, JOB_ID, SALARY, MANAGER_ID, DEPARTMENT_ID)
 Values
   (112, 'Jose Manuel', 'Urman', 'JMURMAN', '515.124.4469', 
    TO_DATE('03/07/1998 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'FI_ACCOUNT', 7800, null, 100);
Insert into EMPLOYEES
   (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, 
    HIRE_DATE, JOB_ID, SALARY, MANAGER_ID, DEPARTMENT_ID)
 Values
   (113, 'Luis', 'Popp', 'LPOPP', '515.124.4567', 
    TO_DATE('12/07/1999 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'FI_ACCOUNT', 6900, null, 100);
Insert into EMPLOYEES
   (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, 
    HIRE_DATE, JOB_ID, SALARY, MANAGER_ID, DEPARTMENT_ID)
 Values
   (114, 'Den', 'Raphaely', 'DRAPHEAL', '515.127.4561', 
    TO_DATE('12/07/1994 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'PU_MAN', 11000, null, 30);
Insert into EMPLOYEES
   (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, 
    HIRE_DATE, JOB_ID, SALARY, MANAGER_ID, DEPARTMENT_ID)
 Values
   (125, 'Julia', 'Nayer', 'JNAYER', '650.124.1214', 
    TO_DATE('07/16/1997 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'ST_CLERK', 3200, null, 50);
Insert into EMPLOYEES
   (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, 
    HIRE_DATE, JOB_ID, SALARY, MANAGER_ID, DEPARTMENT_ID)
 Values
   (126, 'Irene', 'Mikkilineni', 'IMIKKILI', '650.124.1224', 
    TO_DATE('09/28/1998 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'ST_CLERK', 2700, null, 50);
Insert into EMPLOYEES
   (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, 
    HIRE_DATE, JOB_ID, SALARY, MANAGER_ID, DEPARTMENT_ID)
 Values
   (127, 'James', 'Landry', 'JLANDRY', '650.124.1334', 
    TO_DATE('01/14/1999 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'ST_CLERK', 2400, null, 50);
Insert into EMPLOYEES
   (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, 
    HIRE_DATE, JOB_ID, SALARY, MANAGER_ID, DEPARTMENT_ID)
 Values
   (128, 'Steven', 'Markle', 'SMARKLE', '650.124.1434', 
    TO_DATE('03/08/2000 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'ST_CLERK', 2200, null, 50);
Insert into EMPLOYEES
   (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, 
    HIRE_DATE, JOB_ID, SALARY, MANAGER_ID, DEPARTMENT_ID)
 Values
   (129, 'Laura', 'Bissot', 'LBISSOT', '650.124.5234', 
    TO_DATE('08/20/1997 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'ST_CLERK', 3300, null, 50);
Insert into EMPLOYEES
   (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, 
    HIRE_DATE, JOB_ID, SALARY, MANAGER_ID, DEPARTMENT_ID)
 Values
   (130, 'Mozhe', 'Atkinson', 'MATKINSO', '650.124.6234', 
    TO_DATE('10/30/1997 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'ST_CLERK', 2800, null, 50);
Insert into EMPLOYEES
   (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, 
    HIRE_DATE, JOB_ID, SALARY, MANAGER_ID, DEPARTMENT_ID)
 Values
   (131, 'James', 'Marlow', 'JAMRLOW', '650.124.7234', 
    TO_DATE('02/16/1997 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'ST_CLERK', 2500, null, 50);
Insert into EMPLOYEES
   (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, 
    HIRE_DATE, JOB_ID, SALARY, MANAGER_ID, DEPARTMENT_ID)
 Values
   (132, 'TJ', 'Olson', 'TJOLSON', '650.124.8234', 
    TO_DATE('04/10/1999 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'ST_CLERK', 2100, null, 50);
Insert into EMPLOYEES
   (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, 
    HIRE_DATE, JOB_ID, SALARY, MANAGER_ID, DEPARTMENT_ID)
 Values
   (133, 'Jason', 'Mallin', 'JMALLIN', '650.127.1934', 
    TO_DATE('06/14/1996 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'ST_CLERK', 3300, null, 50);
Insert into EMPLOYEES
   (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, 
    HIRE_DATE, JOB_ID, SALARY, MANAGER_ID, DEPARTMENT_ID)
 Values
   (134, 'Michael', 'Rogers', 'MROGERS', '650.127.1834', 
    TO_DATE('08/26/1998 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'ST_CLERK', 2900, null, 50);
Insert into EMPLOYEES
   (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, 
    HIRE_DATE, JOB_ID, SALARY, MANAGER_ID, DEPARTMENT_ID)
 Values
   (135, 'Ki', 'Gee', 'KGEE', '650.127.1734', 
    TO_DATE('12/12/1999 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'ST_CLERK', 2400, null, 50);
Insert into EMPLOYEES
   (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, 
    HIRE_DATE, JOB_ID, SALARY, MANAGER_ID, DEPARTMENT_ID)
 Values
   (136, 'Hazel', 'Philtanker', 'HPHILTAN', '650.127.1634', 
    TO_DATE('02/06/2000 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'ST_CLERK', 2200, null, 50);
Insert into EMPLOYEES
   (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, 
    HIRE_DATE, JOB_ID, SALARY, MANAGER_ID, DEPARTMENT_ID)
 Values
   (137, 'Renske', 'Ladwig', 'RLADWIG', '650.121.1234', 
    TO_DATE('07/14/1995 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'ST_CLERK', 3600, null, 50);
Insert into EMPLOYEES
   (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, 
    HIRE_DATE, JOB_ID, SALARY, MANAGER_ID, DEPARTMENT_ID)
 Values
   (138, 'Stephen', 'Stiles', 'SSTILES', '650.121.2034', 
    TO_DATE('10/26/1997 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'ST_CLERK', 3200, null, 50);
Insert into EMPLOYEES
   (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, 
    HIRE_DATE, JOB_ID, SALARY, MANAGER_ID, DEPARTMENT_ID)
 Values
   (139, 'John', 'Seo', 'JSEO', '650.121.2019', 
    TO_DATE('02/12/1998 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'ST_CLERK', 2700, null, 50);
Insert into EMPLOYEES
   (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, 
    HIRE_DATE, JOB_ID, SALARY, MANAGER_ID, DEPARTMENT_ID)
 Values
   (140, 'Joshua', 'Patel', 'JPATEL', '650.121.1834', 
    TO_DATE('04/06/1998 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'ST_CLERK', 2500, null, 50);
Insert into EMPLOYEES
   (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, 
    HIRE_DATE, JOB_ID, SALARY, MANAGER_ID, DEPARTMENT_ID)
 Values
   (141, 'Trenna', 'Rajs', 'TRAJS', '650.121.8009', 
    TO_DATE('10/17/1995 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'ST_CLERK', 3500, null, 50);
Insert into EMPLOYEES
   (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, 
    HIRE_DATE, JOB_ID, SALARY, MANAGER_ID, DEPARTMENT_ID)
 Values
   (142, 'Curtis', 'Davies', 'CDAVIES', '650.121.2994', 
    TO_DATE('01/29/1997 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'ST_CLERK', 3100, null, 50);
Insert into EMPLOYEES
   (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, 
    HIRE_DATE, JOB_ID, SALARY, MANAGER_ID, DEPARTMENT_ID)
 Values
   (143, 'Randall', 'Matos', 'RMATOS', '650.121.2874', 
    TO_DATE('03/15/1998 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'ST_CLERK', 2600, null, 50);
Insert into EMPLOYEES
   (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, 
    HIRE_DATE, JOB_ID, SALARY, MANAGER_ID, DEPARTMENT_ID)
 Values
   (144, 'Peter', 'Vargas', 'PVARGAS', '650.121.2004', 
    TO_DATE('07/09/1998 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'ST_CLERK', 2500, null, 50);
Insert into EMPLOYEES
   (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, 
    HIRE_DATE, JOB_ID, SALARY, MANAGER_ID, DEPARTMENT_ID)
 Values
   (202, 'Pat', 'Fay', 'PFAY', '603.123.6666', 
    TO_DATE('08/17/1997 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'MK_REP', 6000, null, 20);
Insert into EMPLOYEES
   (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, 
    HIRE_DATE, JOB_ID, SALARY, MANAGER_ID, DEPARTMENT_ID)
 Values
   (204, 'Hermann', 'Baer', 'HBAER', '515.123.8888', 
    TO_DATE('06/07/1994 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'PR_REP', 10000, null, 70);
Insert into EMPLOYEES
   (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, 
    HIRE_DATE, JOB_ID, SALARY, MANAGER_ID, DEPARTMENT_ID)
 Values
   (101, 'Neena', 'Kochhar', 'NKOCHHAR', '515.123.4568', 
    TO_DATE('09/21/1989 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'AD_VP', 17000, null, 90);
Insert into EMPLOYEES
   (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, 
    HIRE_DATE, JOB_ID, SALARY, MANAGER_ID, DEPARTMENT_ID)
 Values
   (102, 'Lex', 'De Haan', 'LDEHAAN', '515.123.4569', 
    TO_DATE('01/13/1993 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'AD_VP', 17000, null, 90);
Insert into EMPLOYEES
   (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, 
    HIRE_DATE, JOB_ID, SALARY, MANAGER_ID, DEPARTMENT_ID)
 Values
   (120, 'Matthew', 'Weiss', 'MWEISS', '650.123.1234', 
    TO_DATE('07/18/1996 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'ST_MAN', 8000, null, 50);
Insert into EMPLOYEES
   (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, 
    HIRE_DATE, JOB_ID, SALARY, MANAGER_ID, DEPARTMENT_ID)
 Values
   (121, 'Adam', 'Fripp', 'AFRIPP', '650.123.2234', 
    TO_DATE('04/10/1997 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'ST_MAN', 8200, null, 50);
Insert into EMPLOYEES
   (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, 
    HIRE_DATE, JOB_ID, SALARY, MANAGER_ID, DEPARTMENT_ID)
 Values
   (122, 'Payam', 'Kaufling', 'PKAUFLIN', '650.123.3234', 
    TO_DATE('05/01/1995 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'ST_MAN', 7900, null, 50);
Insert into EMPLOYEES
   (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, 
    HIRE_DATE, JOB_ID, SALARY, MANAGER_ID, DEPARTMENT_ID)
 Values
   (123, 'Shanta', 'Vollman', 'SVOLLMAN', '650.123.4234', 
    TO_DATE('10/10/1997 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'ST_MAN', 6500, null, 50);
Insert into EMPLOYEES
   (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, 
    HIRE_DATE, JOB_ID, SALARY, MANAGER_ID, DEPARTMENT_ID)
 Values
   (124, 'Kevin', 'Mourgos', 'KMOURGOS', '650.123.5234', 
    TO_DATE('11/16/1999 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'ST_MAN', 5800, null, 50);
Insert into EMPLOYEES
   (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, 
    HIRE_DATE, JOB_ID, SALARY, MANAGER_ID, DEPARTMENT_ID)
 Values
   (201, 'Michael', 'Hartstein', 'MHARTSTE', '515.123.5555', 
    TO_DATE('02/17/1996 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'MK_MAN', 13000, null, 20);
Insert into EMPLOYEES
   (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, 
    HIRE_DATE, JOB_ID, SALARY, MANAGER_ID, DEPARTMENT_ID)
 Values
   (205, 'Shelley', 'Higgins', 'SHIGGINS', '515.123.8080', 
    TO_DATE('06/07/1994 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'AC_MGR', 12000, null, 110);
Insert into EMPLOYEES
   (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, 
    HIRE_DATE, JOB_ID, SALARY, MANAGER_ID, DEPARTMENT_ID)
 Values
   (200, 'Jennifer', 'Whalen', 'JWHALEN', '515.123.4444', 
    TO_DATE('09/17/1987 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'AD_ASST', 4400, null, 10);
COMMIT;



SET DEFINE OFF;
Insert into JOB_HISTORY
   (EMPLOYEE_ID, START_DATE, END_DATE, JOB_ID, DEPARTMENT_ID)
 Values
   (100, TO_DATE('06/17/1987 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('07/24/1998 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'IT_PROG', 90);
   
COMMIT;

SET DEFINE OFF;
UPDATE EMPLOYEES SET MANAGER_ID = 100 WHERE EMPLOYEE_ID IN (101,102,114,120,121,122,123,124,201);
UPDATE EMPLOYEES SET MANAGER_ID = 102 WHERE EMPLOYEE_ID = 103;
UPDATE EMPLOYEES SET MANAGER_ID = 103 WHERE EMPLOYEE_ID IN (104,105,106,107);
UPDATE EMPLOYEES SET MANAGER_ID = 101 WHERE EMPLOYEE_ID = 108;
UPDATE EMPLOYEES SET MANAGER_ID = 108 WHERE EMPLOYEE_ID IN (109,110,111,112,113);
UPDATE EMPLOYEES SET MANAGER_ID = 120 WHERE EMPLOYEE_ID IN (125,126,127,128);
UPDATE EMPLOYEES SET MANAGER_ID = 121 WHERE EMPLOYEE_ID IN (129,130,131,132);
UPDATE EMPLOYEES SET MANAGER_ID = 122 WHERE EMPLOYEE_ID IN (133,134,135,136);
UPDATE EMPLOYEES SET MANAGER_ID = 123 WHERE EMPLOYEE_ID IN (137,138,139,140);
UPDATE EMPLOYEES SET MANAGER_ID = 124 WHERE EMPLOYEE_ID IN (141,142,143);
COMMIT;

SET DEFINE OFF;
UPDATE DEPARTMENTS SET MANAGER_ID = 200 WHERE DEPARTMENT_ID = 10;
UPDATE DEPARTMENTS SET MANAGER_ID = 201 WHERE DEPARTMENT_ID = 20;
UPDATE DEPARTMENTS SET MANAGER_ID = 114 WHERE DEPARTMENT_ID = 30;
UPDATE DEPARTMENTS SET MANAGER_ID = 121 WHERE DEPARTMENT_ID = 50;
UPDATE DEPARTMENTS SET MANAGER_ID = 204 WHERE DEPARTMENT_ID = 70;
UPDATE DEPARTMENTS SET MANAGER_ID = 100 WHERE DEPARTMENT_ID = 90;
UPDATE DEPARTMENTS SET MANAGER_ID = 108 WHERE DEPARTMENT_ID = 100;
UPDATE DEPARTMENTS SET MANAGER_ID = 205 WHERE DEPARTMENT_ID = 110;
COMMIT;

-----------------------------------------------------------------Day4---------------------------------------------------------------------------

--normal cursor
set serveroutput on;

declare 
v_first_name EMPLOYEES.FIRST_NAME%type;
v_last_name EMPLOYEES.laST_NAME%type;
cursor cur_emp_details is select first_name,last_name from EMPLOYEES where DEPARTMENT_ID=20;
begin
open cur_emp_details;
fetch cur_emp_details into v_first_name,v_last_name;
DBMS_OUTPUT.PUT_LINE(v_first_name);
DBMS_OUTPUT.PUT_LINE(v_last_name);
close cur_emp_details;
end if;
end;




--using loop to fetch multiple rows

declare 
v_first_name EMPLOYEES.FIRST_NAME%type;
v_last_name EMPLOYEES.laST_NAME%type;
cursor cur_emp_details is select first_name,last_name from EMPLOYEES where DEPARTMENT_ID=50;
begin
open cur_emp_details;
loop
fetch cur_emp_details into v_first_name,v_last_name;
exit when cur_emp_details%notfound;
DBMS_OUTPUT.PUT_LINE(v_first_name);
DBMS_OUTPUT.PUT_LINE(v_last_name);
end loop;
close cur_emp_details;
end;


--Using cursor for loop

declare 
v_first_name EMPLOYEES.FIRST_NAME%type;
v_last_name EMPLOYEES.laST_NAME%type;
cursor cur_emp_details is select first_name as fname,last_name from EMPLOYEES where DEPARTMENT_ID=20;
begin
for rec_emp_details in cur_emp_details
loop
DBMS_OUTPUT.PUT_LINE(rec_emp_details.fname);
end loop;
end;





--cursor for loop with select statement
declare 
v_first_name EMPLOYEES.FIRST_NAME%type;
v_last_name EMPLOYEES.laST_NAME%type;
begin
for rec_emp_details in ( select first_name as fname,last_name from EMPLOYEES where DEPARTMENT_ID=20)
loop
DBMS_OUTPUT.PUT_LINE(rec_emp_details.fname);
end loop;
end;

--cursor for loop with cursor parameter
declare 
v_first_name EMPLOYEES.FIRST_NAME%type;
v_last_name EMPLOYEES.laST_NAME%type;
cursor cur_emp_details(p_dept_id number) is select first_name as fname,last_name from EMPLOYEES where DEPARTMENT_ID=p_dept_id;
begin
for rec_emp_details in cur_emp_details(100)
loop
DBMS_OUTPUT.PUT_LINE(rec_emp_details.fname);
end loop;
end;

select * from jobs;

set serveroutput on

---Excer50-----


CREATE OR REPLACE TRIGGER trg_check_sal_before_update
   BEFORE INSERT OR UPDATE OF SALARY
   ON EMPLOYEES
   FOR EACH ROW
DECLARE
   v_min_salary   jobs.min_salary%TYPE;
   v_max_salary   jobs.max_salary%type;
   v_new_job_id   jobs.job_id%TYPE := :new.job_id;
BEGIN
   SELECT min_salary,max_salary INTO v_min_salary,v_max_salary FROM jobs WHERE job_id =  UPPER (v_new_job_id);

   IF :new.salary < v_min_salary  THEN
      :new.salary := v_min_salary;
  elsif :new.salary > v_max_salary then
      RAISE_APPLICATION_ERROR(-20000,'Employee salary cannot be more than max salary of his job');
   END IF;
END;


Update employees set salary = 800000 where employee_id=100;




CREATE OR REPLACE TRIGGER trg_check_sal_before_update
   BEFORE UPDATE OF SALARY
   ON EMPLOYEES
   FOR EACH ROW
-- Before updating every employee this trigger will get executed
DECLARE
   v_min_salary   jobs.min_salary%TYPE;
   v_new_job_id   jobs.job_id%TYPE := :new.job_id;
-- To access new value of a row we need to use :new.columnname
BEGIN
   -- Logic to retreive minimum salary of a given job
   SELECT min_salary INTO v_min_salary FROM jobs WHERE job_id = UPPER (v_new_job_id);

   -- Logic to check if new salary is valid or not, if not employees salary should be inserted with minimum salary
   IF :new.salary < v_min_salary
      THEN
      :new.salary := v_min_salary;
   END IF;
END;

select * from departments

---EXCER51----
CREATE TABLE DEPT_MANAGER_LOG
(DEPARTMENT_ID NUMBER,
MANAGER_ID NUMBER,
START_DATE DATE,
END_DATE DATE,
USER_NAME VARCHAR2(20)
)

CREATE OR REPLACE TRIGGER trg_manager_log
   BEFORE  INSERT OR UPDATE OF MANAGER_ID ON DEPARTMENTS 
  FOR EACH ROW 
 declare
 v_user_name DEPT_MANAGER_LOG.user_name%type ;
  BEGIN
 
    IF INSERTING THEN
    /*Logic for inserting manager details will go here
    when a manager is assigned for a department end_date will be null and start_date will be sysdate*/
   
    insert into DEPT_MANAGER_LOG values(:new.department_id,:new.manager_id,sysdate,null,user);
    
    ELSIF UPDATING THEN
    /*updation of end_date for previous manager and insertion of new manager details will go here
    when a manger is changed end_date of previous manager will be sysdate 
    start_date of new manager will be sysdate and end_date will be null*/
     update DEPT_MANAGER_LOG set end_date = sysdate where manager_id = :old.manager_id;  
     insert into DEPT_MANAGER_LOG values(:new.department_id,:new.manager_id,sysdate,null,v_user_name);
    
    END IF;
  END;

insert into departments values(11,'HR',100,1700);
select * from DEPT_MANAGER_LOG;

-----Excer52---
select * from Employees
set serveroutput on;
CREATE OR REPLACE TRIGGER chk_experience_bfr before update of job_id on employees
for each row when (new.job_id<>'FI_MGR' OR new.job_id <> 'AD_PRES')
declare
v_hire_date employees.hire_date%type;
begin
select hire_date into v_hire_date from employees where job_id = :new.job_id;
if (sysdate-v_hire_date)/365 < 2 then
RAISE_APPLICATION_ERROR(-20000,'Experience is not sufficient');
end if;
end;

update employees set first_name = 'vijay' where job_id='IT_PROG';

----Excer53-----
CREATE OR REPLACE TRIGGER chk_time_bfr_update before insert on employees
begin
if to_number(to_char(sysdate, 'HH24')) >=18 and to_number(to_char(sysdate, 'HH24')) <=19 then
raise_application_error(-20000,'System is down, no operation cannot be done');
end if;
end;
set SERVEROUTPUT ON;

begin
dbms_output.put_line(to_number(to_char(sysdate, 'HH24')));
end;

---Excer54---
set serveroutput on;
declare
v_employee_ID employees.employee_id%type;
v_first_name  employees.first_name%type;
 v_job_title jobs.job_title%type;
  v_department_id employees.department_id%type;
  v_hire_date employees.hire_date%type;

cursor cur_all_employee is select e.employee_ID, e.first_name, j.job_title, e.department_id, e.hire_date from employees e inner join jobs j 
on e.job_id=j.job_id
where e.manager_id=103;
begin
open cur_all_employee;
loop
fetch cur_all_employee into v_employee_ID, v_first_name, v_job_title, v_department_id,v_hire_date;
exit when cur_all_employee%notfound;
DBMS_OUTPUT.PUT_LINE(v_employee_ID);
DBMS_OUTPUT.PUT_LINE(v_first_name);
DBMS_OUTPUT.PUT_LINE(v_job_title);
DBMS_OUTPUT.PUT_LINE(v_department_id);
DBMS_OUTPUT.PUT_LINE(v_hire_date);
end loop;
close cur_all_employee;
end;

-------Excer55----------
set serveroutput on

DECLARE
  --declaring a reference variable for cursor
  v_manager_id employees.manager_id%TYPE;
 cursor cur_all_employee is select e.employee_ID, e.first_name, j.job_title, e.department_id, e.hire_date from employees e inner join jobs j 
on e.job_id=j.job_id where e.manager_id=v_manager_id;
  --declare a cursor with reference variable
  --declare a cursor record variable
  rec_emp_details cur_all_employee%rowtype;
BEGIN
  v_manager_id:=103;
  --open the cursor
  open cur_all_employee;
  LOOP
  --fetch the values of employee_id,first_name,job_title,department_id,hire_date from the cursor into record variable
  fetch cur_all_employee into rec_emp_details;
  --Exit condition
  exit when cur_all_employee%notfound;
  -- display the values retrieved from the cursor
    DBMS_OUTPUT.PUT_LINE(rec_emp_details.employee_ID);
DBMS_OUTPUT.PUT_LINE(rec_emp_details.first_name);
DBMS_OUTPUT.PUT_LINE(rec_emp_details.job_title);
DBMS_OUTPUT.PUT_LINE(rec_emp_details.department_id);
DBMS_OUTPUT.PUT_LINE(rec_emp_details.hire_date);
  END LOOP;
  --close the cursor
END;

--Excer56--
DECLARE
  --declaring a reference variable for cursor
  v_manager_id employees.manager_id%TYPE;
 cursor cur_all_employee is select e.employee_ID, e.first_name, j.job_title, e.department_id, e.hire_date from employees e inner join jobs j 
on e.job_id=j.job_id where e.manager_id=v_manager_id;
  --declare a cursor with reference variable
  --declare a cursor record variable
BEGIN
  v_manager_id:=103;
  --open the cursor
  for rec_emp_details in cur_all_employee
  LOOP
  --fetch the values of employee_id,first_name,job_title,department_id,hire_date from the cursor into record variable
 
  -- display the values retrieved from the cursor
    DBMS_OUTPUT.PUT_LINE(rec_emp_details.employee_ID);
DBMS_OUTPUT.PUT_LINE(rec_emp_details.first_name);
DBMS_OUTPUT.PUT_LINE(rec_emp_details.job_title);
DBMS_OUTPUT.PUT_LINE(rec_emp_details.department_id);
DBMS_OUTPUT.PUT_LINE(rec_emp_details.hire_date);
  END LOOP;
  --close the cursor
END;


set SERVEROUTPUT ON;

--Excer57--

DECLARE
  --declaring a reference variable for cursor
  v_manager_id employees.manager_id%TYPE;

  --declare a cursor with reference variable
  --declare a cursor record variable
BEGIN
  v_manager_id:=103;
  --open the cursor
  for rec_emp_details in(select e.employee_ID, e.first_name, j.job_title, e.department_id, e.hire_date from employees e inner join jobs j 
on e.job_id=j.job_id where e.manager_id=v_manager_id)
  LOOP
  --fetch the values of employee_id,first_name,job_title,department_id,hire_date from the cursor into record variable
 
  -- display the values retrieved from the cursor
    DBMS_OUTPUT.PUT_LINE(rec_emp_details.employee_ID);
DBMS_OUTPUT.PUT_LINE(rec_emp_details.first_name);
DBMS_OUTPUT.PUT_LINE(rec_emp_details.job_title);
DBMS_OUTPUT.PUT_LINE(rec_emp_details.department_id);
DBMS_OUTPUT.PUT_LINE(rec_emp_details.hire_date);
  END LOOP;
  --close the cursor
END;

--Excer58--
CREATE OR REPLACE TRIGGER trg_check_sal_before_update
   BEFORE UPDATE OF SALARY
   ON EMPLOYEES
   FOR EACH ROW
-- Before updating every employee this trigger will get executed

-- To access new value of a row we need to use :new.columnname
BEGIN
   -- Logic to retreive minimum salary of a given job

   -- Logic to check if new salary is valid or not, if not employees salary should be inserted with minimum salary
   IF :new.salary < :old.salary then
   raise_application_error(-20000,'Employee salary should not be less than his current salary');
  end if;
  end;

update employees set salary =1000 where employee_id=100;

--Excer59--
CREATE OR REPLACE TRIGGER trg_check_sal
   BEFORE UPDATE OF MIN_SALARY
   ON JOBS
   FOR EACH ROW WHEN (old.job_id<>'AD_PRES')
   begin
   if :new.min_salary < :old.min_salary then
   raise_application_error(-20000,'Employee salary should not be less than his current salary');
  end if;
   end;
   
   update jobs set min_salary = 1000 where job_id = 'IT_PROG';

--Excer60---

CREATE OR REPLACE TRIGGER trg_check_day
   BEFORE INSERT
   ON EMPLOYEES
   FOR EACH ROW
   begin
   if(to_char(sysdate,'day')='sunday') then
   raise_application_error(-20001,'Today is sunday');
  end if;
  end;

--Excer61---
select * from e
set serveroutput on;
CREATE OR REPLACE TRIGGER trg_update_job_history 
AFTER  UPDATE OF job_id ON employees
FOR EACH ROW
DECLARE
v_count_employees pls_integer;
v_end_date job_history.end_date%type;
  BEGIN
/*
  LOGIC TO INSERT DETAILS IN JOB_HISTORY TABLE WILL GO HERE
  */
  select count(job_id) into v_count_employees from job_history where job_id = :old.job_id;
  if v_count_employees=0 then
  INSERT into job_history values(:old.employee_id,:old.hire_date,sysdate,:old.job_id,:old.department_id);
  else
  select end_date into v_end_date from job_history where job_id = :old.job_id;
  INSERT into job_history values(:old.employee_id,v_end_date,sysdate,:old.job_id,:old.department_id);
  end if;
  END;

update employees set job_id='AD_PRES' where employee_id=103;
select * from job_history

--Excer 62--
CREATE OR REPLACE TRIGGER trg_update_job_history_1 
AFTER  UPDATE OF department_id ON employees
FOR EACH ROW
DECLARE
  BEGIN
/*
  LOGIC TO INSERT DETAILS IN JOB_HISTORY TABLE WILL GO HERE
  */
  INSERT into job_history values(:old.employee_id,:old.hire_date,sysdate,:old.job_id,:old.department_id);
  END;


update employees set department_id=50 where employee_id=105;

--EXCER63--
select * from countries
declare
v_region_id countries.region_id%type :=1;
v_country_id countries.country_id%type;
v_country_name countries.country_name%type;
cursor cur_country_details is select country_id,country_name from countries where region_id=v_region_id;
begin
open cur_country_details;
loop
fetch cur_country_details into v_country_id,v_country_name;
exit when cur_country_details%notfound;
dbms_output.put_line(v_country_id ||' '|| v_country_name);
end loop;
close  cur_country_details;
end;

set serveroutput on;

--Excer64--
declare
v_experience pls_integer;
v_employee_id employees.employee_id%type;
v_first_name employees.first_name%type;
v_last_name employees.last_name%type;
cursor cur_emp_details is select employee_id,first_name,last_name from employees where (sysdate-hire_date)/365 >= 25;
begin
open cur_emp_details;
loop
fetch cur_emp_details into v_employee_id,v_first_name,v_last_name;
exit when cur_emp_details%notfound;
dbms_output.put_line(v_employee_id||'   '||v_first_name||' '||v_last_name);
end loop;
close cur_emp_details;
end;

set SERVEROUTPUT ON;

--Excer65--
set SERVEROUTPUT ON;
declare
v_employee_id employees.employee_id%type;
v_job_title jobs.job_title%type;
v_department_id employees.department_id%type;
v_salary employees.salary%type;
cursor cur_emp_details is select e.employee_id,j.job_title,e.department_id,e.salary from employees e inner join jobs j on e.job_id=j.job_id 
order by e.salary desc;
begin
open cur_emp_details;
loop
fetch cur_emp_details into v_employee_id,v_job_title,v_department_id,v_salary;
exit when cur_emp_details%notfound or cur_emp_details%rowcount =4;
DBMS_OUTPUT.PUT_LINE(v_employee_id ||' '||v_job_title||' '||v_department_id||' '||v_salary);
end loop;
close cur_emp_details;
end;

select * from countries

--Excer66--
set serveroutput on;
declare
v_department_name departments.department_name%type;
v_manager_id departments.manager_id%type;
v_count_of_employees pls_integer;
cursor cur_dept_details is select department_name,manager_id from departments 
where location_id in (select location_id from locations where country_ID = (select country_ID from countries where country_name = 'Canada'));
begin
open cur_dept_details;
loop
fetch cur_dept_details into v_department_name,v_manager_id;
exit when cur_dept_details%notfound;
dbms_output.put_line(v_department_name||' '||v_manager_id);
end loop;
v_count_of_employees := cur_dept_details%rowcount;
dbms_output.put_line('no_of_employees:'||' '||v_count_of_employees);
close cur_dept_details;
end;

--EXCER67--
select * from countries
set serveroutput on;
declare
v_region_id regions.region_id%type := 5;
v_region_name regions.region_name%type := 'South America';
v_country_id countries.country_id%type := 'PR';
v_country_name countries.country_name%type :='Peru';
begin
insert into regions values(v_region_id,v_region_name);
if SQL%found=true then
insert into countries values(v_country_id,v_country_name,v_region_id);
else
raise_application_error(-20000,'country cannot be inserted');
end if;
end;

--EXCER68--
set serveroutput on
CREATE OR REPLACE PROCEDURE sp_employee_details(
    p_department_id departments.department_id%TYPE,
    p_dept_emp_count OUT NUMBER)
IS
  --Declare a cursor
  cursor cur_emp_details is select employee_id,salary,hire_date from employees where department_id = p_department_id;
  --Declare variables to store the data
  v_employee_id employees.employee_id%type;
  v_salary employees.salary%type;
  v_hire_date employees.hire_date%type;
BEGIN
  --Retrieve the values using cursor
  open cur_emp_details;
  loop
  fetch cur_emp_details into  v_employee_id , v_salary, v_hire_date;
  exit when cur_emp_details%notfound;
  
  --set the OUT parameter
  --display the values
  DBMS_OUTPUT.PUT_LINE (v_employee_id||' '||v_salary||' '||v_hire_date);
  end loop;
  p_dept_emp_count := cur_emp_details%rowcount;
  close cur_emp_details;
END;

DECLARE
v_dept_id departments.department_id%TYPE:=20;
v_dept_emp_count NUMBER;
BEGIN
  sp_employee_details(v_dept_id, v_dept_emp_count);
  DBMS_OUTPUT.PUT_LINE('Employees in department ' ||v_dept_id|| ' is '||v_dept_emp_count);
END;

--Excer69--
CREATE OR REPLACE PROCEDURE sp_country_details(p_region_id countries.region_id%type,p_count out pls_integer)
is
v_country_id countries.country_id%type;
v_country_name countries.country_name%type;
cursor cur_country_details is select country_id,country_name from countries where region_id=p_region_id;
begin
open cur_country_details;
loop
fetch cur_country_details into v_country_id,v_country_name;
exit when cur_country_details%notfound;
dbms_output.put_line(v_country_id||' '||v_country_name);
end loop;
p_count := cur_country_details%rowcount;
dbms_output.put_line(p_count);
exception
when others then
p_count := -1;
close cur_country_details;
end;


declare
p_count pls_integer;
begin
sp_country_details(10,p_count);
end;
set serveroutput on;

--EXCER70--
CREATE OR REPLACE PROCEDURE sp_emp_details(p_manager_id in employees.manager_id%type, p_emp_count out pls_integer)
is
cursor cur_emp_details is select e.employee_id,e.first_name,j.job_title,e.department_id,e.hire_date from employees e inner join jobs j on
j.job_id=e.job_id where e.manager_id=p_manager_id;
v_employee_id employees.employee_id%type;
v_first_name employees.first_name%type;
v_job_title jobs.job_title%type;
v_department_id employees.department_id%type;
v_hire_date employees.hire_date%type;
begin
open cur_emp_details;
loop
fetch cur_emp_details into v_employee_id , v_first_name,v_job_title,v_department_id,v_hire_date;
exit when cur_emp_details%notfound;
dbms_output.put_line(v_employee_id||' '||v_first_name||' '||v_job_title||' '||v_department_id||' '||v_hire_date);
end loop;
p_emp_count := cur_emp_details%rowcount;
dbms_output.put_line(p_emp_count);
exception
when others then
p_emp_count := -1;
close cur_emp_details;
end;


declare
p_emp_count  pls_integer;
begin
sp_emp_details(103,p_emp_count);
end;
set SERVEROUTPUT ON
select * from employees;


--