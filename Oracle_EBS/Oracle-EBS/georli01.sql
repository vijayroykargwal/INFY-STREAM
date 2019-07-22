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

set SERVEROUTPUT ON;



BEGIN
  null;
END;






declare 
v_first_name VARCHAR2(20):='Yogesh';

BEGIN
  dbms_output.put_line(v_first_name);
END;


declare 
v_first_name VARCHAR2(20);
v_last_name VARCHAR2(25);
BEGIN
  select first_name,last_name into v_first_name,v_last_name from EMPLOYEES where employee_id=100;
  dbms_output.put_line(v_first_name);
  dbms_output.put_line(v_last_name);
END;

 -- select first_name,last_name from HR.EMPLOYEES where employee_id=100;

select * from employees;

desc EMPLOYEES



declare
v_department_id NUMBER(4);
v_employee_id NUMBER(6):=120;
begin
select department_id into v_department_id 
from EMPLOYEES where employee_id=v_employee_id;
dbms_output.put_line(v_department_id);
if(v_department_id=50)then
update employees set salary=salary+1000 where employee_id=v_employee_id;
dbms_output.put_line('updated');
else
dbms_output.put_line('Not updated');
end if;
end;



declare 
 v_salary NUMBER(8,2);
 v_employee_id NUMBER(6):=120;
 begin
 select salary into v_salary from
 employees where employee_id = v_employee_id;
 dbms_output.put_line(v_salary);
 if(v_salary>1000) then
 dbms_output.put_line('eligible');
 else
 dbms_output.put_line('not eligible');
 end if;
 end;
 
 select * from REGIONS;
 select * from countries;

DECLARE
   v_region_name    regions.region_name%TYPE := 'Asia';
   --get the region ID from regions table
   v_region_id      regions.region_id%TYPE;
   --change the values of folloeing variables to add other countries
   v_country_name   countries.country_name%TYPE := 'Singapore';
   v_country_id     countries.country_id%TYPE := 'SG';
BEGIN


   --write the logic to add the countries
   select region_id into v_region_id from regions 
   where region_name=v_region_name;
   

end;

--EXCER-3
set serveroutput on;
select * from employees
desc employees
DECLARE
  v_employee_id NUMBER (6):= 104;
  v_email_id VARCHAR2(25);
  v_department_id NUMBER(4);
  
  /* Declare three variables with appropriate datatype
  to store email id and department id*/

BEGIN

  --Retrieve the values of employee ID 104 from the database using Select statement
  select email,department_id into v_email_id,v_department_id from employees
  where employee_id=v_employee_id;
  DBMS_OUTPUT.PUT_LINE ('Employee ID: ' || v_employee_id);
  DBMS_OUTPUT.PUT_LINE ('Email ID: ' || v_email_id);
  DBMS_OUTPUT.PUT_LINE ('Department ID: ' || v_department_id);
  -- Display the other details in similar format
  
END;
 
 --EXCER-4
set serveroutput on;
select * from EMPLOYEES
desc employees
DECLARE
  v_employee_id NUMBER (6):= 104;
  v_email_id VARCHAR2(25);
  v_department_id NUMBER(4);
  v_joining_date DATE;
  
  /* Declare three variables with appropriate datatype
  to store email id and department id*/

BEGIN

  --Retrieve the values of employee ID 104 from the database using Select statement
  select email,department_id,hire_date into v_email_id,v_department_id,v_joining_date from employees
  where employee_id=v_employee_id;
  DBMS_OUTPUT.PUT_LINE ('Employee ID: ' || v_employee_id);
  DBMS_OUTPUT.PUT_LINE ('Email ID: ' || v_email_id);
  DBMS_OUTPUT.PUT_LINE ('Department ID: ' || v_department_id);
   DBMS_OUTPUT.PUT_LINE ('Joining Date: ' || v_joining_date);
  -- Display the other details in similar format
  
END;

--EXCER-5

Declare

v_employee_id NUMBER (6):= 110;

BEGIN

update employees set phone_number='515.124.5845' where employee_id = v_employee_id ;

END;

--EXCER-6
Declare
v_employee_id NUMBER (6):= 202;
v_job_id  VARCHAR2(10);
begin
select job_id into v_job_id from employees where employee_id=v_employee_id;
if(v_job_id='MK_REP') then
update employees set COMMISSION_PCT=0.1*COMMISSION_PCT where employee_id=v_employee_id;
end if;
end;

--EXCER-7
set SERVEROUTPUT ON;
Declare
v_count_of_employees pls_integer;
v_start_year number := 1987;
v_current_year number:= to_char(sysdate,'YYYY');
begin
while(v_start_year <= v_current_year)
loop
select count(employee_id) into v_count_of_employees from employees 
where v_start_year = to_char(hire_date,'YYYY');
DBMS_OUTPUT.PUT_LINE(v_start_year||':'||v_count_of_employees);
v_start_year := v_start_year + 1;
end loop;
end;

--EXCER-8
set SERVEROUTPUT ON;
declare 
v_employee_id employees.employee_id%type :=100;
v_first_name employees.first_name%type;
v_email employees.email%type;
v_phone_number employees.phone_number%type;
begin
select employee_id,first_name,email,phone_number into v_employee_id,v_first_name,
v_email,v_phone_number from employees where employee_id=v_employee_id;
  DBMS_OUTPUT.PUT_LINE ('Employee ID: ' || v_employee_id);
  DBMS_OUTPUT.PUT_LINE ('First Name: ' || v_first_name);
  DBMS_OUTPUT.PUT_LINE ('Email : ' || v_email);
  DBMS_OUTPUT.PUT_LINE ('Phone Number: ' || v_phone_number);
end;

--Execr-9
declare 
v_employee_id employees.employee_id%type :=104;
v_first_name employees.first_name%type;
v_email employees.email%type;
v_phone_number employees.phone_number%type;
v_joining_date EMPLOYEES.HIRE_DATE%type;
begin
select employee_id,first_name,email,phone_number,HIRE_DATE into v_employee_id,v_first_name,
v_email,v_phone_number,v_joining_date from employees where employee_id=v_employee_id;
  DBMS_OUTPUT.PUT_LINE ('Employee ID: ' || v_employee_id);
  DBMS_OUTPUT.PUT_LINE ('First Name: ' || v_first_name);
  DBMS_OUTPUT.PUT_LINE ('Email : ' || v_email);
  DBMS_OUTPUT.PUT_LINE ('Phone Number: ' || v_phone_number);
  DBMS_OUTPUT.PUT_LINE ('Joining Date: ' || v_joining_date);
end;

--Excer-10
select * from jobs
desc jobs
set serveroutput on;
DECLARE
  -- Anchor declare the below variables
  v_job_ID jobs.job_id%type := 14;
  v_job_title jobs.job_title%type := 'ADV_DIR';
  v_min_salary jobs.min_salary%type := 5000;
  v_max_salary jobs.max_salary%type := 10000;
  
  --v_count_of_jobs is not used to store values from any table, so it can be declared statically
  v_count_of_jobs PLS_INTEGER;
BEGIN
  --Retrieving the number of jobs with same job_id
  /*COUNT() is an aggregate funtion which will always return one row result,
    so even if there are no matching records in the table it will return 0 
    and will not lead to an exception */
  SELECT COUNT (Job_id)
  INTO v_count_of_jobs FROM jobs WHERE job_id = v_job_ID; 
  
  IF (v_count_of_jobs = 0)
  THEN --if count is 0 indicate given job ID doesn't exist in jobs table
  INSERT INTO Jobs
    VALUES (v_job_ID,v_job_title,v_min_salary,v_max_salary);
    ELSE --otherwise  it indicates given job ID already exist
    DBMS_OUTPUT.PUT_LINE (v_job_title || ' already exists');
    END IF;
END;

--Excer-11
select * from DEPARTMENTS
DECLARE
    v_department_id departments.department_id%type:=10;
    rec_dept_details departments%ROWTYPE;
    /*declare a variable anchored to the departments table and
      name as rec_dept_details ,to fetch following details*/
BEGIN
     select * into rec_dept_details from departments where department_id=v_department_id;
     DBMS_OUTPUT.put_line(rec_dept_details.department_name);
    --retrieve and store the details of deparment 10 in %rowtype variable
    --display all the retrieved details 
END;
--Excer-12
select * from countries
DECLARE
   v_region_name    regions.region_name%TYPE := 'Asia';
   --get the region ID from regions table
   v_region_id      regions.region_id%TYPE;
   --change the values of folloeing variables to add other countries
   v_country_name   countries.country_name%TYPE := 'Srilanka';
   v_country_id     countries.country_id%TYPE := 'LK';
   v_count_of_country pls_integer;
BEGIN
    

   --write the logic to add the countries
   select region_id into v_region_id from regions where region_name=v_region_name;
   select count(country_id) into v_count_of_country from countries where country_id=v_country_id;
   if(v_count_of_country=0) then 
   insert into countries values(v_country_id,v_country_name,v_region_id);
   else
   dbms_output.put_line(v_country_id || 'already_exist');
   end if;
end;

--Excer-13
set serveroutput on;
select * from jobs;
DECLARE
   v_job_id      jobs.job_id%TYPE;
   v_job_title   jobs.job_title%TYPE := 'Programmer';
   v_no_of_emp   NUMBER (3) := 0;
BEGIN
     select job_id into v_job_id from jobs where job_title=v_job_title;
     if(v_job_id is not null) then
     select count(job_id) into v_no_of_emp from jobs where job_title=v_job_title;
     dbms_output.put_line(v_job_title || v_no_of_emp);
     else
     dbms_output.put_line(v_job_title || ':' || 'Not present in Jobs');
     end if;
   --write the logic to get count of employees working on given job title

end;

--excer-14
select * from departments
DECLARE
v_employee_id employees.employee_id%type :=105;
v_months pls_integer;
begin 
select MONTHS_BETWEEN
       (sysdate,
        hire_date) into v_months
  FROM employees where employee_id=v_employee_id;
  if(v_months>=24) then 
  dbms_output.put_line('Eligible');
  else
  dbms_output.put_line('not Eligible');
  end if;
end;


--excer-15
declare
v_employee_id employees.employee_id%type;
v_department_name DEPARTMENTS.DEPARTMENT_NAME%type;
begin
select employee_id into v_employee_id from employees where employee_id=105;
select department_name into v_department_name from departments where department_name='IT';
if(v_employee_id=105 and v_department_name='IT') then 
update departments set manager_id=v_employee_id where department_name=v_department_name;
else 
dbms_output.put_line(v_employee_id||'Not eligible for updation');
end if;
end;

--Excer-16
select * from employees
declare
v_employee_id employees.employee_id%type :=202;
v_job_id employees.job_id%type;
v_total_salary EMPLOYEES.SALARY%type;
begin
select job_id into v_job_id from employees where employee_id=v_employee_id;
if(v_job_id='MK_REP') then
update employees set commission_pct=0.1 where employee_id=v_employee_id;
select salary*(1+commission_pct) into v_total_salary from employees where employee_id=v_employee_id;
DBMS_OUTPUT.PUT_LINE(v_total_salary);
else
DBMS_OUTPUT.PUT_LINE('Not Updated');
end if;
end;

------------------------------------------------------------------Day2--------------------------------------------------------------------------
--Excer17--
select * from jobs;

