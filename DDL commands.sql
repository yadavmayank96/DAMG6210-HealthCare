-- PROCEDURE DELETE OBJECT IF ALREADY EXISTS
CREATE OR REPLACE PROCEDURE remove_objects (
    name_of_object VARCHAR2,
    type_of_object VARCHAR2
) IS
    cnt NUMBER := 0;
BEGIN
    IF upper(type_of_object) = 'TABLE' THEN
        SELECT
            COUNT(*)
        INTO cnt
        FROM
            user_tables
        WHERE
            upper(table_name) = upper(TRIM(name_of_object));

        IF cnt > 0 THEN
            EXECUTE IMMEDIATE 'drop table ' || name_of_object || ' cascade constraints';
        END IF;
    END IF;

    IF upper(type_of_object) = 'PROCEDURE' THEN
        SELECT
            COUNT(*)
        INTO cnt
        FROM
            user_objects
        WHERE
                upper(object_type) = 'PROCEDURE'
            AND upper(object_name) = upper(name_of_object);

        IF cnt > 0 THEN
            EXECUTE IMMEDIATE 'DROP PROCEDURE ' || name_of_object;
        END IF;
    END IF;

    IF upper(type_of_object) = 'TRIGGER' THEN
        SELECT
            COUNT(*)
        INTO cnt
        FROM
            user_triggers
        WHERE
            upper(trigger_name) = upper(name_of_object);

        IF cnt > 0 THEN
            EXECUTE IMMEDIATE 'DROP TRIGGER ' || name_of_object;
        END IF;
    END IF;

    IF upper(type_of_object) = 'FUNCTION' THEN
        SELECT
            COUNT(*)
        INTO cnt
        FROM
            user_objects
        WHERE
                upper(object_type) = 'FUNCTION'
            AND upper(object_name) = upper(name_of_object);

        IF cnt > 0 THEN
            EXECUTE IMMEDIATE 'DROP FUNCTION ' || name_of_object;
        END IF;
    END IF;

    IF upper(type_of_object) = 'SEQUENCE' THEN
        SELECT
            COUNT(*)
        INTO cnt
        FROM
            user_sequences
        WHERE
            upper(sequence_name) = upper(name_of_object);

        IF cnt > 0 THEN
            EXECUTE IMMEDIATE 'DROP SEQUENCE ' || name_of_object;
        END IF;
    END IF;

    IF upper(type_of_object) = 'VIEW' THEN
        SELECT
            COUNT(*)
        INTO cnt
        FROM
            user_views
        WHERE
            upper(view_name) = upper(name_of_object);

        IF cnt > 0 THEN
            EXECUTE IMMEDIATE 'DROP VIEW ' || name_of_object;
        END IF;
    END IF;

END;
/




-- CLIENT TABLE
CALL remove_objects('client', 'TABLE');

CREATE TABLE "CLIENT" (
    "CLIENT_ID"    NUMBER(10, 0),
        "CLIENT_NAME"  VARCHAR2(255 BYTE) COLLATE "USING_NLS_COMP" NOT NULL,
        "STATUS"       VARCHAR2(255 BYTE) COLLATE "USING_NLS_COMP",
    "CREATED_DATE" DATE,
    "UPDATED_DATE" DATE,
        "IS_DELETED"   VARCHAR2(255 BYTE) COLLATE "USING_NLS_COMP",
    "DELETE_DATE"  DATE,
    PRIMARY KEY ( "CLIENT_ID" )
        USING INDEX PCTFREE 10 INITRANS 20 MAXTRANS 255 COMPUTE STATISTICS
            STORAGE ( INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645 PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL
            DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT )
        TABLESPACE "DATA"
    ENABLE
) DEFAULT COLLATION "USING_NLS_COMP"
SEGMENT CREATION IMMEDIATE
PCTFREE 10 PCTUSED 40 INITRANS 10 MAXTRANS 255 NOCOMPRESS LOGGING
    STORAGE ( INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645 PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT
    FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT )
TABLESPACE "DATA";



-- HCP TABLE
CALL remove_objects('hcp', 'TABLE');

CREATE TABLE "HCP" (
    "HCP_ID"        NUMBER(10, 0),
        "HCP_NAME"      VARCHAR2(255 BYTE) COLLATE "USING_NLS_COMP" NOT NULL,
        "SERVICE_TYPE"  VARCHAR2(255 BYTE) COLLATE "USING_NLS_COMP",
        "PROVIDER_TYPE" VARCHAR2(255 BYTE) COLLATE "USING_NLS_COMP",
    "CREATED_DATE"  DATE,
    "UPDATED_DATE"  DATE,
        "IS_DELETED"    VARCHAR2(255 BYTE) COLLATE "USING_NLS_COMP",
    "DELETE_DATE"   DATE,
    PRIMARY KEY ( "HCP_ID" )
        USING INDEX PCTFREE 10 INITRANS 20 MAXTRANS 255 COMPUTE STATISTICS
            STORAGE ( INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645 PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL
            DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT )
        TABLESPACE "DATA"
    ENABLE
) DEFAULT COLLATION "USING_NLS_COMP"
SEGMENT CREATION IMMEDIATE
PCTFREE 10 PCTUSED 40 INITRANS 10 MAXTRANS 255 NOCOMPRESS LOGGING
    STORAGE ( INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645 PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT
    FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT )
TABLESPACE "DATA";



-- PATIENT TABLE
CALL remove_objects('patient', 'TABLE');

CREATE TABLE "PATIENT" (
    "PATIENT_ID"       NUMBER(10, 0),
        "FIRST_NAME"       VARCHAR2(255 BYTE) COLLATE "USING_NLS_COMP" NOT NULL,
        "LAST_NAME"        VARCHAR2(255 BYTE) COLLATE "USING_NLS_COMP" NOT NULL,
    "PATIENT_NUMBER"   NUMBER(10, 0),
    "DATE_OF_BIRTH"    DATE NOT NULL,
        "GENDER"           VARCHAR2(255 BYTE) COLLATE "USING_NLS_COMP",
        "SSN"              VARCHAR2(255 BYTE) COLLATE "USING_NLS_COMP" UNIQUE NOT NULL,
    "CLIENT_ID"        NUMBER(10, 0),
        "INSURANCE_STATUS" VARCHAR2(255 BYTE) COLLATE "USING_NLS_COMP",
    "UPDATED_DATE"     DATE,
    "CREATED_DATE"     DATE,
        "IS_DELETED"       VARCHAR2(255 BYTE) COLLATE "USING_NLS_COMP",
    "DELETE_DATE"      DATE,
        "FLAG"             VARCHAR2(255 BYTE) COLLATE "USING_NLS_COMP",
    PRIMARY KEY ( "PATIENT_ID" )
        USING INDEX PCTFREE 10 INITRANS 20 MAXTRANS 255 COMPUTE STATISTICS
            STORAGE ( INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645 PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL
            DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT )
        TABLESPACE "DATA"
    ENABLE,
    FOREIGN KEY ( "CLIENT_ID" )
        REFERENCES "CLIENT" ( "CLIENT_ID" )
    ENABLE
) DEFAULT COLLATION "USING_NLS_COMP"
SEGMENT CREATION IMMEDIATE
PCTFREE 10 PCTUSED 40 INITRANS 10 MAXTRANS 255 NOCOMPRESS LOGGING
    STORAGE ( INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645 PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT
    FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT )
TABLESPACE "DATA";



  
-- CONTACT TABLE
CALL remove_objects('contact', 'TABLE');

CREATE TABLE "CONTACT" (
    "CONTACT_ID"   NUMBER(10, 0),
    "PATIENT_ID"   NUMBER(10, 0),
        "ADDRESS"      VARCHAR2(255 BYTE) COLLATE "USING_NLS_COMP" NOT NULL,
        "CITY"         VARCHAR2(255 BYTE) COLLATE "USING_NLS_COMP" NOT NULL,
        "STATE"        VARCHAR2(255 BYTE) COLLATE "USING_NLS_COMP" NOT NULL,
        "POSTAL_CODE"  VARCHAR2(255 BYTE) COLLATE "USING_NLS_COMP" NOT NULL,
        "PHONE_TYPE"   VARCHAR2(255 BYTE) COLLATE "USING_NLS_COMP",
        "PHONE_NUMBER" VARCHAR2(255 BYTE) COLLATE "USING_NLS_COMP",
    "CREATED_DATE" DATE,
    "UPDATED_DATE" DATE,
        "IS_DELETED"   VARCHAR2(255 BYTE) COLLATE "USING_NLS_COMP",
    "DELETE_DATE"  DATE,
    PRIMARY KEY ( "CONTACT_ID" )
        USING INDEX PCTFREE 10 INITRANS 20 MAXTRANS 255 COMPUTE STATISTICS
            STORAGE ( INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645 PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL
            DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT )
        TABLESPACE "DATA"
    ENABLE,
    FOREIGN KEY ( "PATIENT_ID" )
        REFERENCES "PATIENT" ( "PATIENT_ID" )
    ENABLE
) DEFAULT COLLATION "USING_NLS_COMP"
SEGMENT CREATION IMMEDIATE
PCTFREE 10 PCTUSED 40 INITRANS 10 MAXTRANS 255 NOCOMPRESS LOGGING
    STORAGE ( INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645 PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT
    FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT )
TABLESPACE "DATA";



-- PROVIDER PATIENT TABLE
CALL remove_objects('provider_patient', 'TABLE');

CREATE TABLE "PROVIDER_PATIENT" (
    "PROVIDER_PT_ID" NUMBER(10, 0),
    "HCP_ID"         NUMBER(10, 0),
    "PATIENT_ID"     NUMBER(10, 0),
    PRIMARY KEY ( "PROVIDER_PT_ID" )
        USING INDEX PCTFREE 10 INITRANS 20 MAXTRANS 255 TABLESPACE "DATA"
    ENABLE,
    FOREIGN KEY ( "HCP_ID" )
        REFERENCES "HCP" ( "HCP_ID" )
    ENABLE,
    FOREIGN KEY ( "PATIENT_ID" )
        REFERENCES "PATIENT" ( "PATIENT_ID" )
    ENABLE
) DEFAULT COLLATION "USING_NLS_COMP"
SEGMENT CREATION DEFERRED
PCTFREE 10 PCTUSED 40 INITRANS 10 MAXTRANS 255 NOCOMPRESS LOGGING TABLESPACE "DATA";



-- CASE TABLE
CALL remove_objects('case', 'TABLE');

CREATE TABLE "CASE" (
    "CASE_ID"      NUMBER(10, 0),
        "CASE_TYPE"    VARCHAR2(255 BYTE) COLLATE "USING_NLS_COMP",
    "PATIENT_ID"   NUMBER(10, 0),
    "CREATED_DATE" DATE,
    "UPDATED_DATE" DATE,
        "IS_DELETED"   VARCHAR2(255 BYTE) COLLATE "USING_NLS_COMP",
    "DELETE_DATE"  DATE,
    PRIMARY KEY ( "CASE_ID" )
        USING INDEX PCTFREE 10 INITRANS 20 MAXTRANS 255 COMPUTE STATISTICS
            STORAGE ( INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645 PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL
            DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT )
        TABLESPACE "DATA"
    ENABLE,
    FOREIGN KEY ( "PATIENT_ID" )
        REFERENCES "PATIENT" ( "PATIENT_ID" )
    ENABLE
) DEFAULT COLLATION "USING_NLS_COMP"
SEGMENT CREATION IMMEDIATE
PCTFREE 10 PCTUSED 40 INITRANS 10 MAXTRANS 255 NOCOMPRESS LOGGING
    STORAGE ( INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645 PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT
    FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT )
TABLESPACE "DATA";






-- PRESCRIPTION TABLE
CALL remove_objects('prescription', 'TABLE');

CREATE TABLE "PRESCRIPTION" (
    "PRESCRIPTION_ID" NUMBER(10, 0),
    "HCP_ID"          NUMBER(10, 0),
    "CASE_ID"         NUMBER(10, 0),
        "DISEASE_NAME"    VARCHAR2(255 BYTE) COLLATE "USING_NLS_COMP",
        "DISEASE_TYPE"    VARCHAR2(255 BYTE) COLLATE "USING_NLS_COMP",
    "CREATED_DATE"    DATE,
    "UPDATED_DATE"    DATE,
        "IS_DELETED"      VARCHAR2(255 BYTE) COLLATE "USING_NLS_COMP",
    "DELETE_DATE"     DATE,
    PRIMARY KEY ( "PRESCRIPTION_ID" )
        USING INDEX PCTFREE 10 INITRANS 20 MAXTRANS 255 COMPUTE STATISTICS
            STORAGE ( INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645 PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL
            DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT )
        TABLESPACE "DATA"
    ENABLE,
    FOREIGN KEY ( "HCP_ID" )
        REFERENCES "HCP" ( "HCP_ID" )
    ENABLE,
    FOREIGN KEY ( "CASE_ID" )
        REFERENCES "CASE" ( "CASE_ID" )
    ENABLE
) DEFAULT COLLATION "USING_NLS_COMP"
SEGMENT CREATION IMMEDIATE
PCTFREE 10 PCTUSED 40 INITRANS 10 MAXTRANS 255 NOCOMPRESS LOGGING
    STORAGE ( INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645 PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT
    FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT )
TABLESPACE "DATA";




-- CLAIMS TABLE
CALL remove_objects('claims', 'TABLE');

CREATE TABLE "CLAIMS" (
    "CLAIM_ID"        NUMBER(10, 0),
        "CLAIM_TYPE"      VARCHAR2(255 BYTE) COLLATE "USING_NLS_COMP",
        "CLAIM_STATUS"    VARCHAR2(255 BYTE) COLLATE "USING_NLS_COMP",
    "CLIENT_ID"       NUMBER(10, 0),
        "CLIENT_NAME"     VARCHAR2(255 BYTE) COLLATE "USING_NLS_COMP",
    "PRESCRIPTION_ID" NUMBER(10, 0),
    "CREATED_DATE"    DATE,
    "UPDATED_DATE"    DATE,
        "IS_DELETED"      VARCHAR2(255 BYTE) COLLATE "USING_NLS_COMP",
    "DELETE_DATE"     DATE,
    PRIMARY KEY ( "CLAIM_ID" )
        USING INDEX PCTFREE 10 INITRANS 20 MAXTRANS 255
            STORAGE ( INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645 PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL
            DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT )
        TABLESPACE "DATA"
    ENABLE,
    FOREIGN KEY ( "CLIENT_ID" )
        REFERENCES "CLIENT" ( "CLIENT_ID" )
    ENABLE,
    FOREIGN KEY ( "PRESCRIPTION_ID" )
        REFERENCES "PRESCRIPTION" ( "PRESCRIPTION_ID" )
    ENABLE
) DEFAULT COLLATION "USING_NLS_COMP"
SEGMENT CREATION IMMEDIATE
PCTFREE 10 PCTUSED 40 INITRANS 10 MAXTRANS 255 NOCOMPRESS LOGGING
    STORAGE ( INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645 PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT
    FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT )
TABLESPACE "DATA";





-- MEDICINES TABLE
CALL remove_objects('medicines', 'TABLE');

CREATE TABLE "MEDICINES" (
    "MEDICINE_ID"   NUMBER(10, 0),
        "MEDICINE_NAME" VARCHAR2(255 BYTE) COLLATE "USING_NLS_COMP",
        "MANUFACTURER"  VARCHAR2(255 BYTE) COLLATE "USING_NLS_COMP",
        "STRENGTH"      VARCHAR2(255 BYTE) COLLATE "USING_NLS_COMP",
        "TYPE"          VARCHAR2(255 BYTE) COLLATE "USING_NLS_COMP",
    "CREATED_DATE"  DATE,
    "UPDATED_DATE"  DATE,
        "IS_DELETED"    VARCHAR2(255 BYTE) COLLATE "USING_NLS_COMP",
    "DELETE_DATE"   DATE,
    PRIMARY KEY ( "MEDICINE_ID" )
        USING INDEX PCTFREE 10 INITRANS 20 MAXTRANS 255 COMPUTE STATISTICS
            STORAGE ( INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645 PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL
            DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT )
        TABLESPACE "DATA"
    ENABLE
) DEFAULT COLLATION "USING_NLS_COMP"
SEGMENT CREATION IMMEDIATE
PCTFREE 10 PCTUSED 40 INITRANS 10 MAXTRANS 255 NOCOMPRESS LOGGING
    STORAGE ( INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645 PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT
    FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT )
TABLESPACE "DATA";




-- PRESC MEDICINE TABLE
CALL remove_objects('presc_medicine', 'TABLE');

CREATE TABLE "PRESC_MEDICINE" (
    "ORDER_MED_ID"    NUMBER(10, 0),
    "PRESCRIPTION_ID" NUMBER(10, 0),
    "MEDICINE_ID"     NUMBER(10, 0),
    "QUANTITY"        NUMBER(10, 0),
        "STRENGTH"        VARCHAR2(255 BYTE) COLLATE "USING_NLS_COMP",
    "UPDATED_DATE"    DATE,
    "CREATED_DATE"    DATE,
    PRIMARY KEY ( "ORDER_MED_ID" )
        USING INDEX PCTFREE 10 INITRANS 20 MAXTRANS 255 COMPUTE STATISTICS
            STORAGE ( INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645 PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL
            DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT )
        TABLESPACE "DATA"
    ENABLE,
    FOREIGN KEY ( "PRESCRIPTION_ID" )
        REFERENCES "PRESCRIPTION" ( "PRESCRIPTION_ID" )
    ENABLE,
    FOREIGN KEY ( "MEDICINE_ID" )
        REFERENCES "MEDICINES" ( "MEDICINE_ID" )
    ENABLE
) DEFAULT COLLATION "USING_NLS_COMP"
SEGMENT CREATION IMMEDIATE
PCTFREE 10 PCTUSED 40 INITRANS 10 MAXTRANS 255 NOCOMPRESS LOGGING
    STORAGE ( INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645 PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT
    FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT )
TABLESPACE "DATA";





-- PHARMACY TABLE
CALL remove_objects('pharmacy', 'TABLE');

CREATE TABLE "PHARMACY" (
    "PHARMACY_ID"   NUMBER(10, 0),
        "PHARMACY_NAME" VARCHAR2(255 BYTE) COLLATE "USING_NLS_COMP",
        "STATUS"        VARCHAR2(255 BYTE) COLLATE "USING_NLS_COMP",
    "CREATED_DATE"  DATE,
    "UPDATED_DATE"  DATE,
        "IS_DELETED"    VARCHAR2(255 BYTE) COLLATE "USING_NLS_COMP",
    "DELETE_DATE"   DATE,
    PRIMARY KEY ( "PHARMACY_ID" )
        USING INDEX PCTFREE 10 INITRANS 20 MAXTRANS 255 COMPUTE STATISTICS
            STORAGE ( INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645 PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL
            DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT )
        TABLESPACE "DATA"
    ENABLE
) DEFAULT COLLATION "USING_NLS_COMP"
SEGMENT CREATION IMMEDIATE
PCTFREE 10 PCTUSED 40 INITRANS 10 MAXTRANS 255 NOCOMPRESS LOGGING
    STORAGE ( INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645 PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT
    FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT )
TABLESPACE "DATA";





-- ORDERS TABLE
CALL remove_objects('orders', 'TABLE');

CREATE TABLE "ORDERS" (
    "ORDER_ID"      NUMBER(10, 0),
        "ORDER_TYPE"    VARCHAR2(255 BYTE) COLLATE "USING_NLS_COMP",
        "ORDER_STATUS"  VARCHAR2(255 BYTE) COLLATE "USING_NLS_COMP",
    "CASE_ID"       NUMBER(10, 0),
    "SHIP_DATE"     DATE,
    "DELIVERY_DATE" DATE,
        "INSURANCES"    VARCHAR2(255 BYTE) COLLATE "USING_NLS_COMP",
    "PHARMACY_ID"   NUMBER(10, 0),
    "CREATED_DATE"  DATE,
    "UPDATED_DATE"  DATE,
        "IS_DELETED"    VARCHAR2(255 BYTE) COLLATE "USING_NLS_COMP",
    "DELETE_DATE"   DATE,
    "ORDER_MED_ID"  NUMBER(10, 0),
    PRIMARY KEY ( "ORDER_ID" )
        USING INDEX PCTFREE 10 INITRANS 20 MAXTRANS 255
            STORAGE ( INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645 PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL
            DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT )
        TABLESPACE "DATA"
    ENABLE,
    FOREIGN KEY ( "CASE_ID" )
        REFERENCES "CASE" ( "CASE_ID" )
    ENABLE,
    FOREIGN KEY ( "PHARMACY_ID" )
        REFERENCES "PHARMACY" ( "PHARMACY_ID" )
    ENABLE,
    FOREIGN KEY ( "ORDER_MED_ID" )
        REFERENCES "PRESC_MEDICINE" ( "ORDER_MED_ID" )
    ENABLE
) DEFAULT COLLATION "USING_NLS_COMP"
SEGMENT CREATION IMMEDIATE
PCTFREE 10 PCTUSED 40 INITRANS 10 MAXTRANS 255 NOCOMPRESS LOGGING
    STORAGE ( INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645 PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT
    FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT )
TABLESPACE "DATA";




-- ERROR_RECORDS TABLE
CALL remove_objects('error_records', 'TABLE');

CREATE TABLE "ERROR_RECORDS" (
    "ORDER_NUMBER"   NUMBER(10, 0),
    "PATIENT_NUMBER" NUMBER(10, 0),
        "ERROR"          VARCHAR2(255 BYTE) COLLATE "USING_NLS_COMP",
        "ERR_DESC"       VARCHAR2(255 BYTE) COLLATE "USING_NLS_COMP",
    "CREATED_DATE"   DATE,
    "UPDATED_DATE"   DATE,
    PRIMARY KEY ( "ORDER_NUMBER" )
        USING INDEX PCTFREE 10 INITRANS 20 MAXTRANS 255 TABLESPACE "DATA"
    ENABLE
) DEFAULT COLLATION "USING_NLS_COMP"
SEGMENT CREATION DEFERRED
PCTFREE 10 PCTUSED 40 INITRANS 10 MAXTRANS 255 NOCOMPRESS LOGGING TABLESPACE "DATA";




-- IN_FILE TABLE
CALL remove_objects('in_file', 'TABLE');

CREATE TABLE "IN_FILE" (
    "ORDER_NUMBER"   NUMBER(10, 0),
    "PATIENT_NUMBER" NUMBER(10, 0),
        "ORDER_STATUS"   VARCHAR2(255 BYTE) COLLATE "USING_NLS_COMP",
        "STATUS_DESC"    VARCHAR2(255 BYTE) COLLATE "USING_NLS_COMP",
    "CREATED_DATE"   DATE,
    "UPDATED_DATE"   DATE,
    "SHIP_DATE"      DATE,
    "DELIVERY_DATE"  DATE,
    PRIMARY KEY ( "ORDER_NUMBER" )
        USING INDEX PCTFREE 10 INITRANS 20 MAXTRANS 255 TABLESPACE "DATA"
    ENABLE
) DEFAULT COLLATION "USING_NLS_COMP"
SEGMENT CREATION DEFERRED
PCTFREE 10 PCTUSED 40 INITRANS 10 MAXTRANS 255 NOCOMPRESS LOGGING TABLESPACE "DATA";



-- SEQUENCE
CALL remove_objects('Sequence_Primary_id', 'SEQUENCE');

CREATE SEQUENCE sequence_primary_id START WITH 500000 INCREMENT BY 1 NOCACHE NOCYCLE;

CALL remove_objects('Sequence_next_key', 'SEQUENCE');

CREATE SEQUENCE sequence_next_key START WITH 100000 INCREMENT BY 1 NOCACHE NOCYCLE;

CALL remove_objects('Sequence_orders_key', 'SEQUENCE');

CREATE SEQUENCE Sequence_orders_key START WITH 7000 INCREMENT BY 1 NOCACHE NOCYCLE;