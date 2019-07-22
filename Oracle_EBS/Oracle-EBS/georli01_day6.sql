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

---------------------------------------------------day6---------------------------------------------------------------------------------------------------
--excer83--
set SERVEROUTPUT ON;
DECLARE

    /*Define new collection type for storing employees names*/
    type type_employee_names is table OF employees.first_name%type;
    col_manager_names type_employee_names := type_employee_names();
    /*declare a collection of type defined above */
   v_index number(2):=0;
BEGIN

   /*store manager names into collection*/
   for rec_manager_name in (select e.first_name from employees e inner join departments d on e.employee_id = d.manager_id)
   loop
   col_manager_names.extend();
    v_index:=v_index+1;
    col_manager_names(v_index):=rec_manager_name.first_name;
   end loop;
for v_index in col_manager_names.first..col_manager_names.count
loop
DBMS_OUTPUT.put_line(col_manager_names(v_index));
end loop;

   /*display all the names stored in the collection*/

END;


----excer84---
set serveroutput on;
DECLARE

    /*Define new collection type for storing names department
   
      and to be retrieved using department ID as index*/

    /*declared a collection of above defined type */
    type type_department_details is table OF varchar2(40) index by pls_integer;
    col_department_details type_department_details;
    v_key number(4);
    
BEGIN

   /*get all the department names and their respective ID's store into collection*/
   for rec_department_details in (select department_id,department_name from departments)
   loop
   col_department_details(rec_department_details.department_id) := rec_department_details.department_name;
   end loop;
   v_key := col_department_details.first;
   while (col_department_details.next(v_key) is not null)
   loop
   DBMS_OUTPUT.put_line(v_key||' : '||col_department_details(v_key));
   v_key:=col_department_details.next(v_key);
   end loop;

   /*Retrieve and display elements in collection using key*/

END;

--excer 85---
set SERVEROUTPUT ON;
CREATE OR REPLACE PACKAGE pkg_emp_details
AS
   TYPE type_emp_details IS TABLE OF NUMBER (6);
   /*A collection to store all employee_ids*/
   col_emp_details   type_emp_details:=type_emp_details();
END;

create or replace function sf_get_reportees(p_manager_id employees.manager_id%type) return pkg_emp_details.type_emp_details is
   /*cursor to fetch employees required details*/
   /*counter for indexing of collection,for storing and retrieving values in collection*/
   v_index  NUMBER (3) := 1;
BEGIN
   /*fetch employee ID's from cursor and store into collection*/
   
   
   FOR rec_emp_id IN (SELECT employee_id FROM employees WHERE manager_id = p_manager_id)
   LOOP
      /*refer collection variable col_emp_details, declared in package pkg_emp_details*/
      pkg_emp_details.col_emp_details.EXTEND(1);
      /*store retrieved employee ID into collection*/
      pkg_emp_details.col_emp_details(v_index) := rec_emp_id.employee_id;
      v_index := v_index + 1;
   END LOOP;
   
   /*display all stored employee ID's in collection*/
   return pkg_emp_details.col_emp_details; 
END;

set serveroutput on;


BEGIN
   /* call the function to get the collection of employee ID's */
   --display all stored employee ID's in collection
   pkg_emp_details.col_emp_details := SF_GET_REPORTEES(100);
   FOR v_index IN 1 .. pkg_emp_details.col_emp_details.COUNT
   LOOP
      /*Retrieve and display elements in collection using index position*/
      DBMS_OUTPUT.put_line ( pkg_emp_details.col_emp_details(v_index));
   END LOOP;
END;
---excer 86---
set SERVEROUTPUT ON;
DECLARE
type type_department_names is varray(9) OF departments.department_name%type;
col_department_names type_department_names :=type_department_names();
v_index number(2):=0;
BEGIN
for rec_dep_name in (select department_name from departments)
loop
col_department_names.extend();
v_index:=v_index+1;
col_department_names(v_index):=rec_dep_name.department_name;
end loop;

for v_index in col_department_names.first..col_department_names.count
loop
DBMS_OUTPUT.put_line(col_department_names(v_index));
end loop;

END;

--excer87---
set SERVEROUTPUT ON;
DECLARE
type type_department_details is varray(9) OF departments%rowtype;
col_department_details type_department_details :=type_department_details();
v_index number(2):=0;
BEGIN
for rec_dep_details in (select * from departments)
loop
col_department_details.extend();
v_index:=v_index+1;
col_department_details(v_index):=rec_dep_details;
end loop;

for v_index in col_department_details.first..col_department_details.count
loop
DBMS_OUTPUT.put_line(col_department_details(v_index).department_id ||' '||col_department_details(v_index).department_name||' '||
col_department_details(v_index).manager_id||' '||col_department_details(v_index).location_id);
end loop;

END;

---excer 88---
set SERVEROUTPUT ON;
DECLARE
type type_rec_employee_details is record(employee_id employees.employee_id%type,
first_name employees.first_name%type,
last_name employees.last_name%type,
department_id employees.department_id%type);
type type_employee_details is table OF type_rec_employee_details;
col_employee_details type_employee_details :=type_employee_details();
v_index number(2):=0;
BEGIN
for rec_employee_details in (select e.employee_id,e.first_name,e.last_name,e.department_id from employees e inner join departments d on 
e.employee_id=d.manager_id)
loop
col_employee_details.extend();
v_index:=v_index+1;
col_employee_details(v_index):=rec_employee_details;
end loop;

for v_index in col_employee_details.first..col_employee_details.count
loop
DBMS_OUTPUT.put_line(col_employee_details(v_index).employee_id||' '||col_employee_details(v_index).first_name||' '||col_employee_details(v_index).last_name
||' '||col_employee_details(v_index).department_id);
end loop;

END;

---excer89---
select * from employees
set SERVEROUTPUT ON;
DECLARE

type type_employee_details is table OF employees%rowtype;
col_employee_details type_employee_details :=type_employee_details();
v_index number(2):=0;
BEGIN
for rec_employee_details in (select e.employee_id,e.first_name,e.last_name,e.email,e.phone_number,e.hire_date,e.job_id,e.salary,e.commission_pct,
e.manager_id,e.department_id
from employees e inner join departments d on 
e.employee_id=d.manager_id)
loop
col_employee_details.extend();
v_index:=v_index+1;
col_employee_details(v_index):=rec_employee_details;
end loop;

for v_index in col_employee_details.first..col_employee_details.count
loop
DBMS_OUTPUT.put_line(col_employee_details(v_index).employee_id||' '||col_employee_details(v_index).first_name||' '||col_employee_details(v_index).last_name
||' '||col_employee_details(v_index).email||' '||col_employee_details(v_index).phone_number||' '||col_employee_details(v_index).hire_date||' '||
col_employee_details(v_index).job_id||' '||col_employee_details(v_index).salary||' '||col_employee_details(v_index).commission_pct
||' '||col_employee_details(v_index).manager_id||' '||col_employee_details(v_index).department_id);
end loop;

END;

---excer90---
set serveroutput on;
declare
type type_employee_details is table OF employees%rowtype index by departments.department_name%type;
col_employee_details type_employee_details;
v_key departments.department_name%type;
begin
for rec_employee_details in (select e.*,d.department_name from employees e inner join departments d on d.department_id=e.department_id
 where (sysdate-hire_date)in(select max(sysdate-hire_date) from employees group by department_id))
loop
col_employee_details(rec_employee_details.department_name).employee_id:=rec_employee_details.employee_id;
col_employee_details(rec_employee_details.department_name).first_name:=rec_employee_details.first_name;
col_employee_details(rec_employee_details.department_name).last_name:=rec_employee_details.last_name;
col_employee_details(rec_employee_details.department_name).email:=rec_employee_details.email;
col_employee_details(rec_employee_details.department_name).phone_number:=rec_employee_details.phone_number;
col_employee_details(rec_employee_details.department_name).hire_date:=rec_employee_details.hire_date;
col_employee_details(rec_employee_details.department_name).job_id:=rec_employee_details.job_id;
col_employee_details(rec_employee_details.department_name).salary:=rec_employee_details.salary;
col_employee_details(rec_employee_details.department_name).commission_pct:=rec_employee_details.commission_pct;
col_employee_details(rec_employee_details.department_name).manager_id:=rec_employee_details.manager_id;
col_employee_details(rec_employee_details.department_name).department_id:=rec_employee_details.department_id;
end loop;
v_key:=col_employee_details.first;
while (v_key is not null)
loop
DBMS_OUTPUT.put_line(v_key||':'||col_employee_details(v_key).employee_id||' '||col_employee_details(v_key).first_name||' '||col_employee_details(v_key).last_name
||' '||col_employee_details(v_key).email||' '||col_employee_details(v_key).phone_number||' '||col_employee_details(v_key).hire_date
||' '||col_employee_details(v_key).job_id||' '||col_employee_details(v_key).salary||' '||col_employee_details(v_key).commission_pct
||' '||col_employee_details(v_key).manager_id||' '||col_employee_details(v_key).department_id);
v_key:=col_employee_details.next(v_key);
end loop;

END;

---excer91---
set serveroutput on;
declare
type type_employee_details is table OF employees.first_name%type index by departments.department_name%type;
col_employee_details type_employee_details;
v_key departments.department_name%type;
begin
for rec_employee_details in (select e.first_name,d.department_name from employees e inner join departments d on d.department_id=e.department_id
 where (sysdate-hire_date)in(select max(sysdate-hire_date) from employees group by department_id))
loop
col_employee_details(rec_employee_details.department_name):=rec_employee_details.first_name;
end loop;
v_key:=col_employee_details.first;
while (v_key is not null)
loop
DBMS_OUTPUT.put_line(v_key||' : '||col_employee_details(v_key));
v_key:=col_employee_details.next(v_key);
end loop;

END;

---excer92--
set serveroutput on;
create or replace package pkg_department_with_details is
type type_department_with_details is record(department_name departments.department_name%type,
manager_name employees.first_name%type,
total_emp pls_integer,
avg_salary pls_integer,
sum_of_salary pls_integer,
country_name countries.country_name%type);

type type_department_col_details is table of type_department_with_details;
col_department_with_details type_department_col_details:=type_department_col_details();
end;

create or replace function sf_department_with_details
return  pkg_department_with_details.type_department_col_details is
v_index number(2):=0;
BEGIN
for rec_dep_with_details in (select d.department_name,e.first_name,A.total_emp,A.avg_salary,A.sum_of_salary,c.country_name from
(select department_id,count(employee_id) total_emp,avg(salary) avg_salary,sum(salary) sum_of_salary 
from employees group by department_id)A inner join departments d on A.department_id=d.department_id left outer join employees e on e.employee_id=d.manager_id
left outer join locations l on l.location_id=d.location_id left outer join countries c on c.country_id=l.country_id)
loop
pkg_department_with_details.col_department_with_details.extend();
v_index:=v_index+1;
pkg_department_with_details.col_department_with_details(v_index).department_name:=rec_dep_with_details.department_name;
pkg_department_with_details.col_department_with_details(v_index).manager_name := rec_dep_with_details.first_name;
pkg_department_with_details.col_department_with_details(v_index).total_emp := rec_dep_with_details.total_emp;
pkg_department_with_details.col_department_with_details(v_index).avg_salary := rec_dep_with_details.avg_salary;
pkg_department_with_details.col_department_with_details(v_index).sum_of_salary := rec_dep_with_details.sum_of_salary;
pkg_department_with_details.col_department_with_details(v_index).country_name := rec_dep_with_details.country_name;

end loop;

return pkg_department_with_details.col_department_with_details;
END;


begin
for v_index in sf_department_with_details().first..sf_department_with_details().count
loop
DBMS_OUTPUT.put_line(sf_department_with_details()(v_index).department_name);
DBMS_OUTPUT.put_line(sf_department_with_details()(v_index).manager_name);
DBMS_OUTPUT.put_line(sf_department_with_details()(v_index).total_emp);
DBMS_OUTPUT.put_line(sf_department_with_details()(v_index).avg_salary);
DBMS_OUTPUT.put_line(sf_department_with_details()(v_index).sum_of_salary);
DBMS_OUTPUT.put_line(sf_department_with_details()(v_index).country_name);
DBMS_OUTPUT.put_line('----------------------------------------');

end loop;
end;






