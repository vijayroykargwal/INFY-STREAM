CREATE OR REPLACE PROCEDURE SP_SUPPLIER_BASE_P2_G04(ERRBUF OUT VARCHAR2, RETCODE OUT VARCHAR2) 
IS
TYPE TYPE_SUPPLIERS_INFO IS TABLE OF XX_SUPPLIERS_INT_P2_G04%ROWTYPE;
COL_SUPPLIERS_INFO TYPE_SUPPLIERS_INFO := TYPE_SUPPLIERS_INFO();
V_COUNT_SUPPLIER NUMBER;
BEGIN
SELECT * BULK COLLECT INTO COL_SUPPLIERS_INFO  FROM XX_SUPPLIERS_INT_P2_G04;
FOR V_INDEX IN COL_SUPPLIERS_INFO.FIRST..COL_SUPPLIERS_INFO.LAST
LOOP
BEGIN
----------INSERTING INTO BASE TABLE-----------------------
DECLARE
V_CREATED_BY VARCHAR2(100) := FND_PROFILE.VALUE('USER_ID');
V_LAST_UPDATE_LOGIN VARCHAR2(100) := FND_PROFILE.VALUE('LOGIN_ID');
V_LAST_UPDATED_BY VARCHAR2(100):= FND_PROFILE.VALUE('USER_ID');
BEGIN
SELECT COUNT(SUPPLIER_ID) INTO V_COUNT_SUPPLIER FROM XX_SUPPLIERS_INT_P2_G04 
WHERE SUPPLIER_ID = COL_SUPPLIERS_INFO(V_INDEX).SUPPLIER_ID;
IF V_COUNT_SUPPLIER = 0 THEN
INSERT INTO XX_SUPPLIER_BASE_P2_G04(SUPPLIER_ID,SUPPLIER_NAME,CATEGORY_NAME,ITEM_NAME,QNTY_AVAILABLE,UNIT_PRICE,
CREATED_BY,CREATION_DATE,LAST_UPDATE_DATE,LAST_UPDATE_LOGIN,LAST_UPDATED_BY,SHIP_TO_LOCATION_ID,
BILL_TO_LOCATION_ID,INVOICE_CURRENCY_CODE,PAYMENT_CURRENCY_CODE,START_DATE_ACTIVE,CITY,COUNTRY)
VALUES(COL_SUPPLIERS_INFO(V_INDEX).SUPPLIER_ID,COL_SUPPLIERS_INFO(V_INDEX).SUPPLIER_NAME,
COL_SUPPLIERS_INFO(V_INDEX).CATEGORY_NAME,COL_SUPPLIERS_INFO(V_INDEX).ITEM_NAME,
COL_SUPPLIERS_INFO(V_INDEX).QNTY_AVAILABLE,COL_SUPPLIERS_INFO(V_INDEX).UNIT_PRICE,V_CREATED_BY,
SYSDATE,SYSDATE,V_LAST_UPDATE_LOGIN,V_LAST_UPDATED_BY,
COL_SUPPLIERS_INFO(V_INDEX).SHIP_TO_LOCATION_ID,
COL_SUPPLIERS_INFO(V_INDEX).BILL_TO_LOCATION_ID,
COL_SUPPLIERS_INFO(V_INDEX).INVOICE_CURRENCY_CODE,
COL_SUPPLIERS_INFO(V_INDEX).PAYMENT_CURRENCY_CODE,
COL_SUPPLIERS_INFO(V_INDEX).START_DATE_ACTIVE,
COL_SUPPLIERS_INFO(V_INDEX).CITY,
COL_SUPPLIERS_INFO(V_INDEX).COUNTRY
);
COMMIT;
END IF;
END;

END;
END LOOP;
EXCEPTION
WHEN OTHERS THEN
FND_FILE.PUT_LINE(FND_FILE.LOG,'SOMETHING WENT WRONG');
END;
