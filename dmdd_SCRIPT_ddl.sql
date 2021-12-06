CREATE TABLE client (
	client_id NUMBER(10) PRIMARy key,
	client_name VARCHAR2(255),
	status VARCHAR2(255),
	created_date DATE,
	updated_date DATE,
	is_deleted VARCHAR2(255),
	delete_date DATE,
);

CREATE TABLE patient (
	patient_id NUMBER(10) PRIMARY KEY,
	first_name VARCHAR2(255),
	last_name VARCHAR2(255),
	patient_number NUMBER(10),
	DATE_OF_BIRTH DATE,
	gender VARCHAR2(255),
	ssn VARCHAR2(255),
	client_id NUMBER(10) REFERENCES client (client_id),
	insurance_status VARCHAR2(255),
	updated_date DATE,
	created_date DATE,
	is_deleted VARCHAR2(255),
	delete_date DATE
);

CREATE TABLE contact (
	contact_id NUMBER(10) PRIMARY KEY,
	patient_id NUMBER(10) REFERENCES patient (patient_id),
	address VARCHAR2(255),
	type VARCHAR2(255),
	city VARCHAR2(255),
	state VARCHAR2(255),
	postal_code VARCHAR2(255),
	mobile_number VARCHAR2(255),
	country VARCHAR2(255),
	created_date DATE,
	updated_date DATE,
	is_deleted VARCHAR2(255),
	delete_date DATE
);

--------------------------------------------------------------

  CREATE TABLE "ADMIN"."CONTACT" 
   (	"CONTACT_ID" NUMBER(10,0), 
	"PATIENT_ID" NUMBER(10,0), 
	"ADDRESS" VARCHAR2(255 BYTE) COLLATE "USING_NLS_COMP", 
	"CITY" VARCHAR2(255 BYTE) COLLATE "USING_NLS_COMP", 
	"STATE" VARCHAR2(255 BYTE) COLLATE "USING_NLS_COMP", 
	"POSTAL_CODE" VARCHAR2(255 BYTE) COLLATE "USING_NLS_COMP", 
	"PHONE_TYPE" VARCHAR2(255 BYTE) COLLATE "USING_NLS_COMP", 
	"PHONE_NUMBER" VARCHAR2(255 BYTE) COLLATE "USING_NLS_COMP", 
	"CREATED_DATE" DATE, 
	"UPDATED_DATE" DATE, 
	"IS_DELETED" VARCHAR2(255 BYTE) COLLATE "USING_NLS_COMP", 
	"DELETE_DATE" DATE, 
	 PRIMARY KEY ("CONTACT_ID")
  USING INDEX PCTFREE 10 INITRANS 20 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DATA"  ENABLE, 
	 FOREIGN KEY ("PATIENT_ID")
	  REFERENCES "ADMIN"."PATIENT" ("PATIENT_ID") ENABLE
   )  DEFAULT COLLATION "USING_NLS_COMP" SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 10 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DATA" ;
  
  -----------------------------------------------------------

CREATE TABLE hcp (
	hcp_id NUMBER(10) PRIMARY KEY,
	hcp_name VARCHAR2(255),
	service_type VARCHAR2(255),
	provider_type VARCHAR2(255),
	created_date DATE,
	updated_date DATE,
	is_deleted VARCHAR2(255),
	delete_date DATE
);

CREATE TABLE case (
	case_id NUMBER(10) PRIMARY KEY,
	case_type VARCHAR2(255),
	patient_id NUMBER(10) REFERENCES patient (patient_id),
	created_date DATE,
	updated_date DATE,
	is_deleted VARCHAR2(255),
	delete_date DATE
);

CREATE TABLE prescription (
	prescription_id NUMBER(10) PRIMARY KEY,
	hcp_id VARCHAR2(255) REFERENCES hcp (hcp_id),
	case_id NUMBER(10) REFERENCES case (case_id),
	disease_name VARCHAR2(255),
	disease_type VARCHAR2(255),
	created_date DATE,
	updated_date DATE,
	is_deleted VARCHAR2(255),
	delete_date DATE
);



CREATE TABLE claims(
	claim_id NUMBER(10) PRIMARY KEY,
	claim_type VARCHAR2(255),
	claim_status VARCHAR2(255),
	client_id NUMBER(10) REFERENCES client (client_id),
	client_name VARCHAR2(255),
	prescription_id NUMBER(10) REFERENCES prescription (prescription_id),
	created_date DATE,
	updated_date DATE,
	is_deleted VARCHAR2(255),
	delete_date DATE
);

CREATE TABLE pharmacy(
	pharmacy_id NUMBER(10) PRIMARY KEY,
	pharmacy_name VARCHAR2(255),
	status VARCHAR2(255),
	created_date DATE,
	updated_date DATE,
	is_deleted VARCHAR2(255),
	delete_date DATE
);

CREATE TABLE medicines(
	medicine_id NUMBER(10) PRIMARY KEY,
	medicine_name VARCHAR2(255),
         manufacturer varchar2(255), 
	strength VARCHAR2(255),
	type VARCHAR2(255),
	created_date DATE,
	updated_date DATE,
	is_deleted VARCHAR2(255),
	delete_date DATE
);

CREATE TABLE presc_medicine(
	order_med_id NUMBER(10) PRIMARY KEY,
	prescription_id NUMBER(10) REFERENCES prescription (prescription_id),
	medicine_id NUMBER(10) REFERENCES medicine (medicine_id),
	quantity NUMBER(10),
	strength VARCHAR2(255),
	updated_date DATE,
	created_date DATE
);

CREATE TABLE orders(
	order_id NUMBER(10) PRIMARY KEY,
	order_type VARCHAR2(255),
	order_STATUS VARCHAR2(255),
	case_id NUMBER(10) REFERENCES case (case_id),
	status_desc VARCHAR2(255),
	ship_date DATE,
	delivery_date DATE,
	insurances VARCHAR2(255),
	pharmacy_id VARCHAR2(255) REFERENCES pharmacy (pharmacy_name),
	created_date DATE,
	updated_date DATE,
	is_deleted VARCHAR2(255),
	delete_date DATE
);

CREATE TABLE in_file(
	order_number NUMBER(10) PRIMARY KEY,
	patient_number NUMBER(10),
	order_status VARCHAR2(255),
	status_desc VARCHAR2(255),
	created_date DATE,
	updated_date DATE,
	ship_date DATE,
	delivery_date DATE
);

CREATED TABLE error_records(
	order_number NUMBER(10) PRIMARY KEY,
	patient_number NUMBER(10),
	error VARCHAR2(255),
         err_desc Varchar2(255)
	created_date DATE,
	updated_date DATE

);


	
	


	
	
	
	





