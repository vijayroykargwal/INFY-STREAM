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
------------------------------------------------------------------Day2--------------------------------------------------------------------------
--Excer17--
select * from job_history;
declare
v_employee_id job_history.employee_id%type :=103;
v_start_date job_history.start_date%type;
v_end_date   job_history.end_date%type;
v_job_id job_history.job_id%type;
v_count_of_employees pls_integer;
begin
select count(employee_id) into v_count_of_employees from job_history where employee_id=v_employee_id;
if(v_count_of_employees>1) then
select start_date,end_date,job_id into v_start_date,v_end_date,v_job_id  
from job_history where employee_id=v_employee_id group by start_date,end_date,job_id
Having start_date=max(start_date);
else
select start_date,end_date,job_id into v_start_date,v_end_date,v_job_id  
from job_history where employee_id=v_employee_id;
end if;
Exception
WHEN NO_DATA_FOUND then
dbms_output.put_line('There is no job history for this employee');
end;

--Excer18--
set serveroutput on;
declare
v_employee_id job_history.employee_id%type :=103;
v_start_date job_history.start_date%type;
v_end_date   job_history.end_date%type;
v_job_id job_history.job_id%type;
begin
select start_date,end_date,job_id into v_start_date,v_end_date,v_job_id  
from job_history where employee_id=v_employee_id;
Exception
WHEN  NO_DATA_FOUND then
dbms_output.put_line('There is no job history for this employee');
when TOO_MANY_ROWS then 
dbms_output.put_line('There is too many employees for this job history');
when OTHERS then
dbms_output.put_line('There is some other error occurred');
DBMS_OUTPUT.PUT_LINE ('Error Code: ' || SQLCODE);
DBMS_OUTPUT.PUT_LINE ('Error Message: ' || SQLERRM);
end;

--Excer 19--
select * from employees;
declare
v_department_id departments.department_id%type :=111;
v_department_name departments.department_name%type := 'sales';
v_manager_id departments.manager_id%type := 222;
v_location_id departments.location_id%type := 1500;
e_manager_id_invalid exception;
e_location_id_invalid exception;
v_count_manager pls_integer;
v_count_location pls_integer;
begin
select count(employee_id) into v_count_manager from employees where employee_id=v_manager_id;
select count(location_id) into v_count_location from locations where location_id=v_location_id;
if v_count_manager=0 then
  raise e_manager_id_invalid;
elsif v_count_location =0 then
  raise e_location_id_invalid;
else
insert into departments values(v_department_id,v_department_name,v_manager_id,v_location_id);
end if;
exception
when e_manager_id_invalid then
dbms_output.put_line('manager id invalid');
when e_location_id_invalid then
dbms_output.put_line('location id invalid');
end;

--Excer 20--
declare 
v_department_id departments.department_id%type :=90;
e_violation_child exception;
pragma EXCEPTION_INIT (e_violation_child, -02292);
begin
delete from departments where department_id=v_department_id;
exception
when e_violation_child then
dbms_output.put_line('cannot delete department,parent key found');
when others then
dbms_output.put_line('Something went wrong');
DBMS_OUTPUT.PUT_LINE ('Error Code: ' || SQLCODE);
DBMS_OUTPUT.PUT_LINE ('Error Message: ' || SQLERRM);
end;

--Excer 21--
declare
v_department_id departments.department_id%type :=111;
v_department_name departments.department_name%type := 'sales';
v_manager_id departments.manager_id%type := 222;
v_location_id departments.location_id%type := 1500;
v_count_manager pls_integer;
v_count_location pls_integer;
begin
select count(employee_id) into v_count_manager from employees where employee_id=v_manager_id;
select count(location_id) into v_count_location from locations where location_id=v_location_id;
if v_count_manager=0 then
  RAISE_APPLICATION_ERROR(-20000, 'e_manager_id_invalid');
elsif v_count_location =0 then
  RAISE_APPLICATION_ERROR(-20001, 'e_location_id_invalid');
else
insert into departments values(v_department_id,v_department_name,v_manager_id,v_location_id);
end if;
exception
when others then
 DBMS_OUTPUT.PUT_LINE ('Something went wrong!!');
  DBMS_OUTPUT.PUT_LINE ('Error Code: ' || SQLCODE);
  DBMS_OUTPUT.PUT_LINE ('Error Message: ' || SQLERRM);
END;

--Excer22--
declare
v_first_name employees.first_name%type :='John';
v_phone_number employees.phone_number%type;
begin
select phone_number into v_phone_number from employees where first_name=v_first_name;
exception
when NO_DATA_FOUND then
dbms_output.put_line('there is no employee with this first name');
when TOO_MANY_ROWS then 
dbms_output.put_line('there is too many employee with this first name');
end;

--EXECER23--
select * from employees
select * from  jobs;
declare
v_job_id jobs.job_id%type:='MGR';
rec_job_details jobs%rowtype;
begin
select * into rec_job_details from jobs where job_id=v_job_id;
exception
when No_data_found then 
dbms_output.put_line('invalid job_id');
dbms_output.put_line(SQLCODE);
dbms_output.put_line(SQLERRM);
when others then
dbms_output.put_line('something went wrong');
end;

--Excer24--
select * from employees
set serveroutput on;
declare
v_employee_id employees.employee_id%type:=100;
v_count_employee pls_integer;
e_invalid_employee_id exception;
v_salary employees.salary%type; 
begin
select count(employee_id),salary into v_count_employee,v_salary 
from employees where employee_id=v_employee_id group by salary;
if v_count_employee=0 then
raise e_invalid_employee_id;
end if;
if(v_salary<8000) then
dbms_output.put_line('Tax Amount: '|| v_salary);
elsif(v_salary>=8000 and v_salary<15000) then 
dbms_output.put_line('Tax Amount: ' || v_salary*0.1);
elsif(v_salary>15000) then
dbms_output.put_line('Tax Amount: ' || v_salary*0.15);
end if;
exception
when e_invalid_employee_id then
dbms_output.put_line('invalid employee id');
end;
 --EXCER25--
 set serveroutput on;
 declare
 v_employee_id employees.employee_id%type:=123;
 v_new_salary employees.salary%type:=5500;
 v_current_salary employees.salary%type;
 e_invalid_new_salary exception;
 begin
 select salary into v_current_salary from employees where employee_id =v_employee_id;
 if(v_new_salary<v_current_salary) then
 raise e_invalid_new_salary;
 end if;
 exception
 when e_invalid_new_salary then 
 dbms_output.put_line('invalid new salary');
 when others then
 dbms_output.put_line('something went wrong');
 dbms_output.put_line(SQLCODE);
 dbms_output.put_line(SQLERRM);
 end;
 --EXCER26--
 select * from departments
declare
v_department_id departments.department_id%type:=111;
v_manager_id departments.manager_id%type:=222;
v_location_id departments.location_id%type:=1500;
e_not_null exception;
PRAGMA EXCEPTION_INIT(e_not_null,-01400);
begin
 insert into departments values(v_department_id,null,v_manager_id,v_location_id);
 exception
 when e_not_null then
 dbms_output.put_line('voilation of not null_constraint');
 DBMS_OUTPUT.PUT_LINE ('Error Code: ' || SQLCODE);
 DBMS_OUTPUT.PUT_LINE ('Error Message: ' || SQLERRM);
 when others then
dbms_output.put_line('Something went wrong');
DBMS_OUTPUT.PUT_LINE ('Error Code: ' || SQLCODE);
DBMS_OUTPUT.PUT_LINE ('Error Message: ' || SQLERRM);
end;

--EXCER27--
declare
v_department_id departments.department_id%type:=70;
v_manager_id departments.manager_id%type:=333;
e_integrity_constraint exception;
pragma EXCEPTION_INIT (e_integrity_constraint, -02291);
begin
update departments set manager_id=v_manager_id where department_id=v_department_id;
exception
when e_integrity_constraint then 
 dbms_output.put_line('voilation of integrity constraint found');
 DBMS_OUTPUT.PUT_LINE ('Error Code: ' || SQLCODE);
 DBMS_OUTPUT.PUT_LINE ('Error Message: ' || SQLERRM);
 when others then
dbms_output.put_line('Something went wrong');
DBMS_OUTPUT.PUT_LINE ('Error Code: ' || SQLCODE);
DBMS_OUTPUT.PUT_LINE ('Error Message: ' || SQLERRM);
end;

--Excer28--
declare
v_employee_id employees.employee_id%type:=100;
v_count_employee pls_integer;
v_salary employees.salary%type; 
begin
select count(employee_id),salary into v_count_employee,v_salary 
from employees where employee_id=v_employee_id group by salary;
if v_count_employee=0 then
RAISE_APPLICATION_ERROR(-20000, 'employee_id_invalid');
end if;
if(v_salary<8000) then
dbms_output.put_line('Tax Amount: '|| v_salary);
elsif(v_salary>=8000 and v_salary<15000) then 
dbms_output.put_line('Tax Amount: ' || v_salary*0.1);
elsif(v_salary>15000) then
dbms_output.put_line('Tax Amount: ' || v_salary*0.15);
end if;
exception
when others then
dbms_output.put_line('something went wrong');
DBMS_OUTPUT.PUT_LINE ('Error Code: ' || SQLCODE);
DBMS_OUTPUT.PUT_LINE ('Error Message: ' || SQLERRM);
end;

--Excer29--
set serveroutput on;
 declare
 v_employee_id employees.employee_id%type:=123;
 v_new_salary employees.salary%type:=5500;
 v_current_salary employees.salary%type;
 begin
 select salary into v_current_salary from employees where employee_id =v_employee_id;
 if(v_new_salary<v_current_salary) then
 raise_application_error(-20000,'invalid new salary');
 end if;
 exception
 when others then
 dbms_output.put_line('something went wrong');
 dbms_output.put_line(SQLCODE);
 dbms_output.put_line(SQLERRM);
 end;

--Excer-46--
CREATE OR REPLACE PROCEDURE SP_ADD_COUNTRY(P_COUNTRY_ID COUNTRIES.COUNTRY_ID%TYPE,                                           
P_COUNTRY_NAME COUNTRIES.COUNTRY_NAME%TYPE,                                          
P_REGION_ID COUNTRIES.REGION_ID%TYPE,                                          
P_STATUS OUT PLS_INTEGER)
IS
V_COUNT_RID PLS_INTEGER;
V_COUNT_CID PLS_INTEGER;
BEGIN    
SELECT COUNT(*) INTO V_COUNT_RID FROM REGIONS WHERE REGION_ID = P_REGION_ID;    
IF V_COUNT_RID = 0 THEN        
P_STATUS := -1;    
ELSE        
SELECT COUNT(*) INTO V_COUNT_CID FROM COUNTRIES WHERE COUNTRY_ID = P_COUNTRY_ID;        
IF V_COUNT_CID != 0 THEN            
P_STATUS := -2;        
ELSE            
INSERT INTO COUNTRIES VALUES (P_COUNTRY_ID,P_COUNTRY_NAME,P_REGION_ID);            
P_STATUS := 0;        
END IF;    
END IF;
EXCEPTION
WHEN OTHERS THEN
P_STATUS := -3;
END; 
 

