---------------------------CHECK VALID DATA----------------------------------------
CREATE OR REPLACE PROCEDURE CHECK_VALID_DATA(ITEMTYPE   IN     VARCHAR2,
ITEMKEY    IN     VARCHAR2,ACTID      IN     NUMBER,FUNCMODE   IN     VARCHAR2,RESULT  OUT VARCHAR2)
IS
l_item_name VARCHAR2(50);
l_req_quantity NUMBER;
V_COUNT_ITEM NUMBER;
BEGIN
IF funcmode = 'RUN'
   THEN
   l_item_name := WF_ENGINE.GETITEMATTRTEXT(itemtype   => 'SPH_G04',
                                    itemkey    => itemkey,
                                    aname      => 'ITEM_NAME_G04'
                                );
   l_req_quantity :=WF_ENGINE.GETITEMATTRNUMBER(itemtype   => 'SPH_G04',
                                    itemkey    => itemkey,
                                    aname      => 'QUANTITY_G04'
                                );
  SELECT COUNT(ITEM_ID) INTO V_COUNT_ITEM FROM XX_ITEM_DETAILS_04 WHERE
  UPPER(ITEM_NAME)=UPPER(l_item_name);
  IF V_COUNT_ITEM <=0 THEN
     RESULT:='COMPLETE:INI';
  ELSIF V_COUNT_ITEM > 0 AND l_req_quantity <=0 THEN
    RESULT:='COMPLETE:INQ';
  ELSIF V_COUNT_ITEM > 0 AND l_req_quantity > 0 THEN
    RESULT:='COMPLETE:V';
    END IF;
END IF;
END;

------------------------------REQUISITON TABLE INSERTION--------------
CREATE OR REPLACE PROCEDURE REQ_DATA_INSERTION_FUNC(ITEMTYPE   IN     VARCHAR2,
ITEMKEY    IN     VARCHAR2,ACTID      IN     NUMBER,FUNCMODE   IN     VARCHAR2,RESULT OUT VARCHAR2)
IS
l_item_name VARCHAR2(50);
V_ITEM_ID NUMBER;
l_qnty_req NUMBER;
l_category_name VARCHAR2(50);
V_UNIT_PRICE NUMBER;
l_currency_code VARCHAR2(10);
l_need_by_date VARCHAR2(10);
l_deliver_to_loc_id VARCHAR2(10);
l_dest_org_id VARCHAR2(10);

BEGIN
l_item_name := WF_ENGINE.GETITEMATTRTEXT(itemtype   => 'SPH_G04',
                                    itemkey    => itemkey,
                                    aname      => 'ITEM_NAME_G04'
                                );
    l_qnty_req := WF_ENGINE.GETITEMATTRNUMBER(itemtype   => 'SPH_G04',
                                    itemkey    => itemkey,
                                    aname      => 'QUANTITY_G04'
                                );
      l_category_name := WF_ENGINE.GETITEMATTRTEXT(itemtype   => 'SPH_G04',
                                    itemkey    => itemkey,
                                    aname      => 'CATEGORY_NAME_G04'
                                );
      l_currency_code:=WF_ENGINE.GETITEMATTRNUMBER(itemtype   => 'SPH_G04',
                                    itemkey    => itemkey,
                                    aname      => 'CURRENCY_CODE_G04'
                                    );  
      l_need_by_date :=WF_ENGINE.GETITEMATTRTEXT(itemtype   => 'SPH_G04',
                                    itemkey    => itemkey,
                                    aname      => 'NEED_BY_DATE_G04'
                                );
    l_dest_org_id :=WF_ENGINE.GETITEMATTRTEXT(itemtype   => 'SPH_G04',
                                    itemkey    => itemkey,
                                    aname      => 'DEST_ORG_ID_G04'
                                );
    l_deliver_to_loc_id :=WF_ENGINE.GETITEMATTRTEXT(itemtype   => 'SPH_G04',
                                    itemkey    => itemkey,
                                    aname      => 'DELIVER_TO_LOC_ID'
                                );
      SELECT ITEM_ID INTO V_ITEM_ID FROM XX_ITEM_DETAILS_04 WHERE UPPER(ITEM_NAME)= UPPER(l_item_name);
      SELECT UNIT_PRICE INTO V_UNIT_PRICE FROM XX_SUPPLIERS_INT_P2_G04 WHERE
      UPPER(ITEM_NAME)=UPPER(l_item_name) AND UPPER(CATEGORY_NAME)=UPPER(l_category_name) ;
INSERT INTO xx_req_base_grp_04 VALUES('PURCHASE',l_item_name,V_ITEM_ID,l_qnty_req,V_UNIT_PRICE,
l_currency_code,l_need_by_date,l_dest_org_id,l_deliver_to_loc_id,SYSDATE,FND_PROFILE.VALUE('USER_ID'),'APPROVED');
COMMIT;
END;

----------------------------CHECK DATA VALIDATION FUNCTION----------------------------
CREATE OR REPLACE PROCEDURE CHECK_DATA_VALIDATION_FUNC(ITEMTYPE   IN     VARCHAR2,
ITEMKEY    IN     VARCHAR2,ACTID      IN     NUMBER,FUNCMODE   IN     VARCHAR2,RESULT OUT VARCHAR2)
IS
l_item_name VARCHAR2(50);
l_ava_quantity NUMBER;
l_req_quantity NUMBER;
l_category_name VARCHAR2(50);
V_QNTY_AVAILABLE NUMBER;
V_UNIT_PRICE NUMBER;
l_final_price NUMBER;
l_supplier_name VARCHAR2(240);
l_count_supplier NUMBER;
BEGIN
IF funcmode = 'RUN'
   THEN
         l_item_name := WF_ENGINE.GETITEMATTRTEXT(itemtype   => 'SPH_G04',
                                    itemkey    => itemkey,
                                    aname      => 'ITEM_NAME_G04'
                                );
         l_req_quantity := WF_ENGINE.GETITEMATTRNUMBER(itemtype   => 'SPH_G04',
                                    itemkey    => itemkey,
                                    aname      => 'QUANTITY_G04'
                                );
        l_category_name := WF_ENGINE.GETITEMATTRTEXT(itemtype   => 'SPH_G04',
                                    itemkey    => itemkey,
                                    aname      => 'CATEGORY_NAME_G04'
                                );
        Select COUNT(SUPPLIER_ID) INTO l_count_supplier FROM XX_SUPPLIERS_INT_P2_G04 
        WHERE UPPER(ITEM_NAME)=UPPER(l_item_name) AND UPPER(CATEGORY_NAME)=UPPER(l_category_name) ;
        IF l_count_supplier>0 THEN
           SELECT SUPPLIER_NAME INTO l_supplier_name FROM XX_SUPPLIERS_INT_P2_G04 
           WHERE UPPER(ITEM_NAME)=UPPER(l_item_name);
           IF UPPER(l_supplier_name)='INTEL' THEN
              select QNTY_AVAILABLE,UNIT_PRICE INTO V_QNTY_AVAILABLE,V_UNIT_PRICE FROM XX_SUPPLIERS_INT_P2_G04 WHERE 
              UPPER(ITEM_NAME)=UPPER(l_item_name) AND UPPER(CATEGORY_NAME)=UPPER(l_category_name) ;
              IF V_QNTY_AVAILABLE >=l_req_quantity THEN
                  WF_ENGINE.SETITEMATTRNUMBER(itemtype   => 'SPH_G04',
                                    itemkey    => itemkey,
                                    aname      => 'INTEL_QUOTE_VALUE_G04',
                                    avalue    => 0
                                );
                 l_final_price := l_req_quantity*V_UNIT_PRICE;
                 WF_ENGINE.SETITEMATTRNUMBER(itemtype   => 'SPH_G04',
                                    itemkey    => itemkey,
                                    aname      => 'INTEL_FINAL_PRICE_G04',
                                    avalue    => l_final_price
                                );
              ELSE 
                  WF_ENGINE.SETITEMATTRNUMBER(itemtype   => 'SPH_G04',
                                    itemkey    => itemkey,
                                    aname      => 'INTEL_QUOTE_VALUE_G04',
                                    avalue    => -2
                                );
              END IF;
            ELSE
                WF_ENGINE.SETITEMATTRNUMBER(itemtype   => 'SPH_G04',
                                    itemkey    => itemkey,
                                    aname      => 'INTEL_QUOTE_VALUE_G04',
                                    avalue    => -1
                                );
          END IF;
           IF UPPER(l_supplier_name)='SAMSUNG' THEN
                               select QNTY_AVAILABLE,UNIT_PRICE INTO V_QNTY_AVAILABLE,V_UNIT_PRICE FROM XX_SUPPLIERS_INT_P2_G04 WHERE 
              UPPER(ITEM_NAME)=UPPER(l_item_name) AND UPPER(CATEGORY_NAME)=UPPER(l_category_name) ;
              IF V_QNTY_AVAILABLE >=l_req_quantity THEN
                  WF_ENGINE.SETITEMATTRNUMBER(itemtype   => 'SPH_G04',
                                    itemkey    => itemkey,
                                    aname      => 'SAMSUNG_QUOTE_VALUE_G04',
                                    avalue    => 0
                                );
                 l_final_price := l_req_quantity*V_UNIT_PRICE;
                 WF_ENGINE.SETITEMATTRNUMBER(itemtype   => 'SPH_G04',
                                    itemkey    => itemkey,
                                    aname      => 'SAMSUNG_FINAL_PRICE_G04',
                                    avalue    => l_final_price
                                );
              ELSE 
                  WF_ENGINE.SETITEMATTRNUMBER(itemtype   => 'SPH_G04',
                                    itemkey    => itemkey,
                                    aname      => 'SAMSUNG_QUOTE_VALUE_G04',
                                    avalue    => -2
                                );
              END IF;
          ELSE
                WF_ENGINE.SETITEMATTRNUMBER(itemtype   => 'SPH_G04',
                                    itemkey    => itemkey,
                                    aname      => 'SAMSUNG_QUOTE_VALUE_G04',
                                    avalue    => -1
                                );  
           END IF;
           IF UPPER(l_supplier_name)='TEXAS INSTRUMENTS' THEN
                             select QNTY_AVAILABLE,UNIT_PRICE INTO V_QNTY_AVAILABLE,V_UNIT_PRICE FROM XX_SUPPLIERS_INT_P2_G04 WHERE 
              UPPER(ITEM_NAME)=UPPER(l_item_name) AND UPPER(CATEGORY_NAME)=UPPER(l_category_name) ;
              IF V_QNTY_AVAILABLE >= l_req_quantity THEN
                  WF_ENGINE.SETITEMATTRNUMBER(itemtype   => 'SPH_G04',
                                    itemkey    => itemkey,
                                    aname      => 'TEXAS_INS_QUOTE_VALUE',
                                    avalue    => 0
                                );
                 l_final_price := l_req_quantity*V_UNIT_PRICE;
                 WF_ENGINE.SETITEMATTRNUMBER(itemtype   => 'SPH_G04',
                                    itemkey    => itemkey,
                                    aname      => 'TEXAS_INS_FINAL_PRICE_G04',
                                    avalue    => l_final_price
                                );
              ELSE 
                  WF_ENGINE.SETITEMATTRNUMBER(itemtype   => 'SPH_G04',
                                    itemkey    => itemkey,
                                    aname      => 'TEXAS_INS_QUOTE_VALUE',
                                    avalue    => -2
                                );
              END IF;
        ELSE
                WF_ENGINE.SETITEMATTRNUMBER(itemtype   => 'SPH_G04',
                                    itemkey    => itemkey,
                                    aname      => 'TEXAS_INS_QUOTE_VALUE',
                                    avalue    => -1
                                );
            END IF;
            
      END IF;           
  END IF; 
END;
-----------------------CHECK SUPPLIER FUNCTION------------
CREATE OR REPLACE PROCEDURE CHECK_SUPPLIER_FUNC(ITEMTYPE   IN     VARCHAR2,
ITEMKEY    IN     VARCHAR2,ACTID      IN     NUMBER,FUNCMODE   IN     VARCHAR2,RESULT OUT VARCHAR2)
IS
l_check_supplier VARCHAR2(50);
BEGIN
IF funcmode = 'RUN'
   THEN
   l_check_supplier :=  WF_ENGINE.GETITEMATTRTEXT(itemtype   => 'SPH_G04',
                                    itemkey    => itemkey,
                                    aname      => 'SUP_SEL_DROP_DOWN_G04'
                                  );
    IF UPPER(l_check_supplier) ='INTEL' THEN
        RESULT:='COMPLETE:INTEL';
    ELSIF UPPER(l_check_supplier)='SAMSUNG' THEN
       RESULT:='COMPLETE:SAMSUNG';
    ELSIF UPPER(l_check_supplier)='TEXAS INSTRUMENTS' THEN
       RESULT:='COMPLETE:TEXAS INSTRUMENTS';
    END IF;
END IF;
END;
------------------------------SUPPLIER DATA UPDATION-----------------
CREATE OR REPLACE PROCEDURE SUPPLIER_DATA_UPDATION_FUNC(ITEMTYPE   IN     VARCHAR2,
ITEMKEY    IN     VARCHAR2,ACTID      IN     NUMBER,FUNCMODE   IN     VARCHAR2,RESULT OUT VARCHAR2)
IS
l_item_name VARCHAR2(50); 
l_req_quantity NUMBER;
l_category_name VARCHAR2(50);
BEGIN
      l_item_name := WF_ENGINE.GETITEMATTRTEXT(itemtype   => 'SPH_G04',
                                    itemkey    => itemkey,
                                    aname      => 'ITEM_NAME_G04'
                                );
   l_category_name := WF_ENGINE.GETITEMATTRTEXT(itemtype   => 'SPH_G04',
                                    itemkey    => itemkey,
                                    aname      => 'CATEGORY_NAME_G04'
                                );
UPDATE xx_suppliers_int_p2_g04 SET QNTY_AVAILABLE=QNTY_AVAILABLE - l_req_quantity WHERE 
UPPER(ITEM_NAME)=UPPER(l_item_name) AND UPPER(l_category_name)=UPPER(l_category_name);
COMMIT;
END;

--------------INVOICE DATA INSERTION----------------------

CREATE OR REPLACE PROCEDURE INVOICE_DATA_UPDATION_FUNC(ITEMTYPE   IN     VARCHAR2,
ITEMKEY    IN     VARCHAR2,ACTID      IN     NUMBER,FUNCMODE   IN     VARCHAR2,RESULT OUT VARCHAR2)
IS
l_item_name VARCHAR2(50); 
l_invoice_amount NUMBER;
l_currency_code NUMBER;
l_supplier_id VARCHAR2(10);
l_category_name VARCHAR2(50);
l_supplier_location_id VARCHAR2(10);
l_client_email VARCHAR2(100);
l_client_phone NUMBER;
l_client_id VARCHAR2(10);
l_SUPPLIER_NAME VARCHAR2(240);
BEGIN
 l_item_name := WF_ENGINE.GETITEMATTRTEXT(itemtype   => 'SPH_G04',
                                    itemkey    => itemkey,
                                    aname      => 'ITEM_NAME_G04'
                                );
   l_category_name := WF_ENGINE.GETITEMATTRTEXT(itemtype   => 'SPH_G04',
                                    itemkey    => itemkey,
                                    aname      => 'CATEGORY_NAME_G04'
                                );
l_invoice_amount:= WF_ENGINE.GETITEMATTRNUMBER(itemtype   => 'SPH_G04',
                                    itemkey    => itemkey,
                                    aname      => 'FINAL_PRICE'
                                    );
 l_currency_code:=   WF_ENGINE.GETITEMATTRNUMBER(itemtype   => 'SPH_G04',
                                    itemkey    => itemkey,
                                    aname      => 'CURRENCY_CODE_G04'
                                    );  
    l_supplier_location_id :=  WF_ENGINE.GETITEMATTRTEXT(itemtype   => 'SPH_G04',
                                    itemkey    => itemkey,
                                    aname      => 'SUPPLIER_LOCATION_ID_G04'
                                );
    l_client_email := WF_ENGINE.GETITEMATTRTEXT(itemtype   => 'SPH_G04',
                                    itemkey    => itemkey,
                                    aname      => 'CLIENT_EMAIL_G04'
                                );
    l_client_phone :=WF_ENGINE.GETITEMATTRNUMBER(itemtype   => 'SPH_G04',
                                    itemkey    => itemkey,
                                    aname      => 'CLIENT_EMAIL_G04'
                                );
    l_client_id :=WF_ENGINE.GETITEMATTRTEXT(itemtype   => 'SPH_G04',
                                    itemkey    => itemkey,
                                    aname      => 'CLIENT_EMAIL_G04'
                                );
  SELECT SUPPLIER_ID,SUPPLIER_NAME INTO l_supplier_id,l_SUPPLIER_NAME FROM XX_SUPPLIERS_INT_P2_G04 WHERE 
  UPPER(ITEM_NAME)=UPPER(l_item_name) AND UPPER(l_category_name)=UPPER(l_category_name);
INSERT INTO base_siliconics VALUES(seq_invoice_data_g04.nextval,l_invoice_amount,l_currency_code,SYSDATE,
'RECIEPT CREATED','FINAL',SYSDATE,l_supplier_id,l_SUPPLIER_NAME,l_supplier_location_id,seq_transaction_number_g04.nextval,
seq_vat_registration_id_g04.nextval,l_client_email,l_client_phone,l_client_id,SYSDATE,FND_PROFILE.VALUE('USER_ID'),
FND_PROFILE.VALUE('LOGIN_ID'),SYSDATE,FND_PROFILE.VALUE('USER_ID'));
COMMIT;
END;


----------PO BASE TABLE DATA INSERTION--------------
CREATE OR REPLACE PROCEDURE PO_DATA_UPDATION_FUNC(ITEMTYPE   IN     VARCHAR2,
ITEMKEY    IN     VARCHAR2,ACTID      IN     NUMBER,FUNCMODE   IN     VARCHAR2,RESULT OUT VARCHAR2)
IS
l_item_name VARCHAR2(50); 
l_category_name VARCHAR2(50);
l_quantity NUMBER;
l_unit_price NUMBER;
V_ITEM_ID NUMBER;
l_need_by_date VARCHAR2(10);
l_currency_code VARCHAR2(10);
l_ship_to_location_id VARCHAR2(10);
l_bill_to_location_id VARCHAR2(10);
l_supplier_name VARCHAR2(240);
BEGIN
 l_item_name := WF_ENGINE.GETITEMATTRTEXT(itemtype   => 'SPH_G04',
                                    itemkey    => itemkey,
                                    aname      => 'ITEM_NAME_G04'
                                );
   l_category_name := WF_ENGINE.GETITEMATTRTEXT(itemtype   => 'SPH_G04',
                                    itemkey    => itemkey,
                                    aname      => 'CATEGORY_NAME_G04'
                                );
    l_quantity:=WF_ENGINE.GETITEMATTRNUMBER(itemtype   => 'SPH_G04',
                                    itemkey    => itemkey,
                                    aname      => 'QUANTITY_G04'
                                );
    l_need_by_date :=WF_ENGINE.GETITEMATTRTEXT(itemtype   => 'SPH_G04',
                                    itemkey    => itemkey,
                                    aname      => 'NEED_BY_DATE_G04'
                                );
                                
   l_currency_code:=   WF_ENGINE.GETITEMATTRNUMBER(itemtype   => 'SPH_G04',
                                    itemkey    => itemkey,
                                    aname      => 'CURRENCY_CODE_G04'
                                    );  
  l_ship_to_location_id :=WF_ENGINE.GETITEMATTRTEXT(itemtype   => 'SPH_G04',
                                    itemkey    => itemkey,
                                    aname      => 'SHIP_TO_LOCATION_ID_G04'
                                );
  l_bill_to_location_id :=WF_ENGINE.GETITEMATTRTEXT(itemtype   => 'SPH_G04',
                                    itemkey    => itemkey,
                                    aname      => 'BILL_TO_LOCATION_ID'
                                );
    SELECT ITEM_ID INTO V_ITEM_ID FROM XX_ITEM_DETAILS_04 WHERE UPPER(ITEM_NAME)= UPPER(l_item_name);
    SELECT SUPPLIER_NAME,UNIT_PRICE INTO l_supplier_name,l_unit_price FROM XX_SUPPLIERS_INT_P2_G04 WHERE 
  UPPER(ITEM_NAME)=UPPER(l_item_name) AND UPPER(l_category_name)=UPPER(l_category_name);                            
INSERT INTO xx_po_bt_p2_04 VALUES(seq_po_data_g04.NEXTVAL,l_supplier_name,V_ITEM_ID,l_item_name,
l_quantity,l_unit_price,l_need_by_date,'APPROVED',l_currency_code,l_ship_to_location_id,l_bill_to_location_id,
FND_PROFILE.VALUE('USER_ID'),SYSDATE,FND_PROFILE.VALUE('USER_ID'),SYSDATE,FND_PROFILE.VALUE('LOGIN_ID'));

COMMIT;

END;

