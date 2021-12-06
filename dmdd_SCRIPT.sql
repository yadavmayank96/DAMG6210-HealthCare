-------------------------WORKING FINE ---------------------------
-----------------------------------------------------------------

create or replace PROCEDURE INS_PATIENT
(
	IN_FIRST_NAME IN VARCHAR2,
	IN_LAST_NAME IN VARCHAR2,
	IN_GENDER IN VARCHAR2,
	IN_SSN IN VARCHAR2, -- 234-67-6457
	IN_CLIENT_NAME IN VARCHAR2,
	IN_DATE_OF_BIRTH IN DATE,
	IN_INSURANCE_STATUS IN VARCHAR2
)
as
    IN_CLIENT_ID NUMBER;
	BEGIN
        IF IN_CLIENT_NAME IS NOT NULL THEN SELECT CLIENT_ID INTO IN_CLIENT_ID FROM CLIENT WHERE CLIENT_NAME=IN_CLIENT_NAME;           
        END IF;
        IF IN_FIRST_NAME IS NULL THEN  DBMS_OUTPUT.PUT_LINE('First Name is required');
        ELSIF IN_LAST_NAME IS NULL THEN  DBMS_OUTPUT.PUT_LINE(	'Last Name is required');
        ELSIF IN_GENDER IS NULL THEN  DBMS_OUTPUT.PUT_LINE('Gender is required');
		ELSIF IN_SSN IS NULL THEN  DBMS_OUTPUT.PUT_LINE('SSN is required');
		ELSIF IN_SSN IS NOT NULL AND SUBSTR() 
		
		ELSIF IN_DATE_OF_BIRTH IS NULL THEN  DBMS_OUTPUT.PUT_LINE('Date of Birth is required') ;
        ELSIF IN_CLIENT_NAME IS NULL THEN DBMS_OUTPUT.PUT_LINE('Client Name is required') ;
		ELSIF IN_INSURANCE_STATUS IS NULL THEN  DBMS_OUTPUT.PUT_LINE('Insurance Status is required') ;
		ELSE INSERT INTO PATIENT(PATIENT_ID,FIRST_NAME,LAST_NAME,PATIENT_NUMBER,DATE_OF_BIRTH,
								 GENDER,SSN,CLIENT_ID,INSURANCE_STATUS,UPDATED_DATE,CREATED_DATE,IS_DELETED,DELETE_DATE) 
						VALUES (SEQUENCE_PRIMARY_ID.nextvaL,IN_FIRST_NAME,IN_LAST_NAME,SEQUENCE_PRIMARY_ID.nextvaL,
								IN_DATE_OF_BIRTH,IN_GENDER,IN_SSN,IN_CLIENT_ID,IN_INSURANCE_STATUS,SYSDATE,SYSDATE,NULL,NULL);
                                commit;
        END IF;
    END;
--------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE INS_PAT_CONTACT
(

    IN_PATIENT_ID IN NUMBER,
	IN_ADDRESS IN VARCHAR2,
	IN_CITY IN VARCHAR2,
	IN_STATE IN VARCHAR2,
	IN_POSTAL_CODE IN VARCHAR2,
    IN_PHONE_TYPE IN VARCHAR2, -- Not Mandatory
	IN_PHONE_NUMBER IN VARCHAR2
)
	AS
	
	VAR_PATIENT_ID NUMBER;
	
	BEGIN
		IF IN_ADDRESS IS NULL THEN  DBMS_OUTPUT.PUT_LINE('Address is required');
		ELSIF IN_CITY IS NULL THEN  DBMS_OUTPUT.PUT_LINE('City is required');
		ELSIF IN_STATE IS NULL THEN  DBMS_OUTPUT.PUT_LINE('State is required');
		ELSIF IN_POSTAL_CODE IS NULL THEN  DBMS_OUTPUT.PUT_LINE('Postal Code is required'); 
		ELSIF IN_PHONE_TYPE IS NULL THEN  DBMS_OUTPUT.PUT_LINE('Phone ype is required'); 
		ELSIF IN_PHONE_NUMBER IS NULL THEN  DBMS_OUTPUT.PUT_LINE('Phone Number is required');
		ELSIF LENGTH(IN_PHONE_NUMBER) <> 10 THEN DBMS_OUTPUT.PUT_LINE('PHONE NUMBER IS NOT IN VALID FORMAT');
		
		Select count(1) into VAR_PATIENT_ID 
                from PATIENT
                Where PATIENT_ID = IN_PATIENT_ID;

                if VAR_PATIENT_ID > 0 then INSERT INTO CONTACT VALUES (SEQUENCE_PRIMARY_ID.NEXTVAL,IN_PATIENT_ID,IN_ADDRESS,IN_CITY,IN_STATE,IN_POSTAL_CODE,IN_PHONE_TYPE,IN_PHONE_NUMBER,SYSDATE,SYSDATE,NULL,NULL);
                -- do something here if exists
                dbms_output.put_line('record exists.');
                else
                -- do something here if not exists
                dbms_output.put_line('record does not exists.');
                end if;
                COMMIT;
        END IF;
    END;

--(substr(regexp_replace(t.p, '[^0-9]',''),1,1) != 0 and length(regexp_replace(t.p, '[^0-9]','')) = 10)
--or (substr(regexp_replace(t.p, '[^0-9]',''),1,1) = 1 and length(regexp_replace(t.p, '[^0-9]','')) = 11;
	

--------------------------------------------------------------------

create or replace PROCEDURE INS_PAT_CONTACT_TEST
(
    IN_PATIENT_ID IN NUMBER
	IN_ADDRESS IN VARCHAR2,
	IN_CITY IN VARCHAR2,
	IN_STATE IN VARCHAR2,
	IN_POSTAL_CODE IN VARCHAR2,
    IN_PHONE_TYPE IN VARCHAR2, -- Not Mandatory
	IN_MOBILE_NUMBER IN VARCHAR2
)
	AS
	
	VAR_PATIENT_ID NUMBER := IN_PATIENT_ID;
    CURSOR C1 IS 
        SELECT PATIENT_ID FROM PATIENT;

	BEGIN
        OPEN C1;
        LOOP
        FETCH C1 INTO VAR_PATIENT_ID;
            EXIT WHEN c1%notfound;
            end loop;
            dbms_output.put_line('patient_id not found');
            close c1;
    end;
	
create or replace PROCEDURE INS_PAT_CONTACT_TEST
(
    IN_PATIENT_ID IN NUMBER,
	IN_ADDRESS IN VARCHAR2
	--IN_CITY IN VARCHAR2,
	--IN_STATE IN VARCHAR2,
	--IN_POSTAL_CODE IN VARCHAR2,
    --IN_PHONE_TYPE IN VARCHAR2, -- Not Mandatory
	--IN_MOBILE_NUMBER IN VARCHAR2
)
	AS
	
	VAR_PATIENT_ID NUMBER := IN_PATIENT_ID;
    CUR_PATIENT_ID NUMBER;
    CURSOR C1 IS 
        SELECT PATIENT_ID FROM PATIENT;

	BEGIN
        IF IN_ADDRESS IS NULL THEN  DBMS_OUTPUT.PUT_LINE('Address Line 1 is required');
        ELSE DBMS_OUTPUT.PUT_LINE(IN_ADDRESS);
        END IF;
        OPEN C1;
        LOOP
        FETCH C1 INTO CUR_PATIENT_ID;
            EXIT WHEN C1%NOTFOUND;
            dbms_output.put_line('Patient_id not found');
            end loop;
        close c1;
    END;
    
SET SERVEROUTPUT ON;  
EXEC INS_PAT_CONTACT_TEST(2,'PARK DRIVE');

SELECT * FROM PATIENT;

-------------------

CREATE OR REPLACE PROCEDURE INS_PAT_CONTACT
(

    IN_PATIENT_ID IN NUMBER,
	IN_ADDRESS IN VARCHAR2,
	IN_CITY IN VARCHAR2,
	IN_STATE IN VARCHAR2,
	IN_POSTAL_CODE IN VARCHAR2,
    IN_PHONE_TYPE IN VARCHAR2, -- Not Mandatory
	IN_PHONE_NUMBER IN VARCHAR2
)
	AS
	
	VAR_PATIENT_ID NUMBER;
	
	BEGIN
		IF IN_PATIENT_ID IS NULL THEN  DBMS_OUTPUT.PUT_LINE('Patient id is required');
		ELSIF IN_ADDRESS IS NULL THEN  DBMS_OUTPUT.PUT_LINE('Address is required');
		ELSIF IN_CITY IS NULL THEN  DBMS_OUTPUT.PUT_LINE('City is required');
		ELSIF IN_STATE IS NULL THEN  DBMS_OUTPUT.PUT_LINE('State is required');
		ELSIF IN_POSTAL_CODE IS NULL THEN  DBMS_OUTPUT.PUT_LINE('Postal Code is required'); 
		ELSIF IN_PHONE_TYPE IS NULL THEN  DBMS_OUTPUT.PUT_LINE('Phone ype is required'); 
		ELSIF IN_PHONE_NUMBER IS NULL THEN  DBMS_OUTPUT.PUT_LINE('Phone Number is required');
        ELSIF IN_PHONE_NUMBER IS NULL THEN  DBMS_OUTPUT.PUT_LINE('Phone Number is required');
        ELSE INSERT INTO CONTACT VALUES (SEQUENCE_PRIMARY_ID.NEXTVAL,IN_PATIENT_ID,IN_ADDRESS,IN_CITY,IN_STATE,IN_POSTAL_CODE,IN_PHONE_TYPE,IN_PHONE_NUMBER,SYSDATE,SYSDATE,NULL,NULL);
        COMMIT;
        END IF;
    END;

SET SERVEROUTPUT ON;
EXEC INS_PAT_CONTACT('4','PARK DRIVE','BOSTON','MA','02215','Mobile','');

--------------------------

Declare
  VAR_PATIENT_ID number;
Begin
  Select count(1) into n_count 
   from PATIENT
   Where PATIENT_ID = IN_PATIENT_ID;

  if n_count > 0 then
    -- do something here if exists
    dbms_output.put_line('record exists.');
  else
    -- do something here if not exists
    dbms_output.put_line('record does not exists.');
  end if;
End;