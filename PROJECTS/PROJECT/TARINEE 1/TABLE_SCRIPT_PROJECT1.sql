DROP TABLE XX_SUPPLIER_TEMP_04;
CREATE TABLE XX_SUPPLIER_TEMP_04(
VENDOR_NAME VARCHAR2(240),
VENDOR_SITE_CODE VARCHAR2(15),
ORG_ID NUMBER,
SHIP_TO_LOCATION_ID NUMBER,
BILL_TO_LOCATION_ID NUMBER,
INVOICE_CURRENCY_CODE VARCHAR2(30),
PAYMENT_CURRENCY_CODE VARCHAR2(30),
START_DATE_ACTIVE DATE,
ADDRESS_LINE1 VARCHAR2(240),
CITY VARCHAR2(60),
COUNTRY VARCHAR2(60),
RECORD_STATUS VARCHAR2(30),
VERIFY_FLAG CHAR,
ERROR_MESSAGE VARCHAR2(240)
);

CREATE TABLE AP_SUPPLIERS_INT_DUMMY_G04(
VENDOR_INTERFACE_ID NUMBER,
VENDOR_NAME VARCHAR2(240),
VENDOR_SITE_CODE VARCHAR2(15),
ORG_ID NUMBER,
CREATED_BY VARCHAR2(100),
CREATION_DATE DATE,
LAST_UPDATE_DATE DATE,
LAST_UPDATE_LOGIN VARCHAR2(100),
LAST_UPDATED_BY VARCHAR2(100),
SHIP_TO_LOCATION_ID NUMBER,
BILL_TO_LOCATION_ID NUMBER,
INVOICE_CURRENCY_CODE VARCHAR2(30),
PAYMENT_CURRENCY_CODE VARCHAR2(30),
START_DATE_ACTIVE DATE,
ADDRESS_LINE1 VARCHAR2(240),
CITY VARCHAR2(60),
COUNTRY VARCHAR2(60),
RECORD_STATUS VARCHAR2(30),
VERIFY_FLAG CHAR,
ERROR_MESSAGE VARCHAR2(240)
);


CREATE TABLE AP_SUPPLIER_SITES_INT_DMY_G04(
VENDOR_SITE_INTERFACE_ID NUMBER,
VENDOR_NAME VARCHAR2(240),
VENDOR_SITE_CODE VARCHAR2(15),
ORG_ID NUMBER,
CREATED_BY VARCHAR2(100),
CREATION_DATE DATE,
LAST_UPDATE_DATE DATE,
LAST_UPDATE_LOGIN VARCHAR2(100),
LAST_UPDATED_BY VARCHAR2(100),
SHIP_TO_LOCATION_ID NUMBER,
BILL_TO_LOCATION_ID NUMBER,
INVOICE_CURRENCY_CODE VARCHAR2(30),
PAYMENT_CURRENCY_CODE VARCHAR2(30),
START_DATE_ACTIVE DATE,
ADDRESS_LINE1 VARCHAR2(240),
CITY VARCHAR2(60),
COUNTRY VARCHAR2(60),
RECORD_STATUS VARCHAR2(30),
VERIFY_FLAG CHAR,
ERROR_MESSAGE VARCHAR2(240)
);