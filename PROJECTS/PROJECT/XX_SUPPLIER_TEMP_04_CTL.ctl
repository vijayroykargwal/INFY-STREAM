OPTIONS (skip=1)
LOAD DATA
INFILE '/ETAVIS/ETAVIS/fs1/EBSapps/appl/gl/12.0.0/bin/SUPPLIER_LEGACY_FEB19_G04.csv'
INSERT
INTO TABLE XX_SUPPLIER_TEMP_04
FIELDS TERMINATED BY','
OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
VENDOR_NAME,
VENDOR_SITE_CODE,
ORG_ID "TO_NUMBER(:ORG_ID)",
SHIP_TO_LOCATION_ID "TO_NUMBER(:SHIP_TO_LOCATION_ID)",
BILL_TO_LOCATION_ID "TO_NUMBER(:BILL_TO_LOCATION_ID)",
INVOICE_CURRENCY_CODE,
PAYMENT_CURRENCY_CODE,
START_DATE_ACTIVE "TO_DATE(:START_DATE_ACTIVE,'DD/MM/YYYY')",
ADDRESS_LINE1,
CITY,
COUNTRY TERMINATED BY WHITESPACE, 
RECORD_STATUS    CONSTANT "LOADED"
)