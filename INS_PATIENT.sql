create or replace PROCEDURE ins_patient (
    in_first_name       IN VARCHAR2,
    in_last_name        IN VARCHAR2,
    in_gender           IN VARCHAR2,
    in_ssn              IN VARCHAR2, -- 234-67-6457
    in_client_name      IN VARCHAR2,
    in_date_of_birth    IN DATE,
    in_insurance_status IN VARCHAR2
) AS

    VAR_client_id NUMBER;
	VAR_DATE_CHECK VARCHAR2(100);
	var_Pat_cNT NUMber;
	UNIQUE_PAT_ID EXCEPTION;
    first_name_invalid EXCEPTION;
    last_name_invalid EXCEPTION;
	date_of_birth_INVALID EXCEPTION;
	date_of_birth_INVALID_1 EXCEPTION;
    gender_invalid EXCEPTION;
    ssn_invalid EXCEPTION;
    client_name_invalid EXCEPTION;
    insurance_status_invalid EXCEPTION;
	
BEGIN
IF 
	in_client_name IS NOT NULL AND VALIDATE_CONVERSION ( TRIM(in_client_name) AS NUMBER ) = 0 
then
	SELECT CLIENT_ID INTO VAR_CLIENT_ID FROM CLIENT WHERE upper(TRIM(CLIENT_NAME))=UPPER(TRIM(IN_CLIENT_NAME));
end IF;	
Select COUNT(*) INTO var_Pat_cNT from PATIENt WHERE TRIM(FIRST_NAME)=TRIM(in_fIRST_name) AND TRIM(LAST_name)
=trim(in_last_name) and trim(gender)=trim(in_gender) and trim(date_of_birth)=trim(in_date_of_birth);

IF 
	(VAR_PAT_CNT>0)
THEN
	raise UNIQUE_PAT_ID;
ELSIF 
	IN_FIRST_NAME IS NULL Or IN_first_NAME is not NULL 
	and VALIDATE_CONVERSION(IN_FIRST_NAME AS NUMBER) = 1
THEN
    raise first_name_invalid;
ELSIF
    in_last_name IS NULL Or IN_first_NAME is not NULL 
    AND VALIDATE_CONVERSION ( in_last_name AS NUMBER ) = 1
THEN
    raise last_name_invalid;
	
elsIF in_gender IS NULL Or in_gender is not NULL 
    AND upper(in_gender) NOT IN ( 'MALE', 'FEMALE', 'OTHER' )
THEN
    raise gender_invalid;
ELSIF
    in_ssn IS NULL THEN raise ssn_invalid;
--ELSIF IN_SSN IS NOT NULL
    --AND regexp_instr(in_ssn, '^[0-9\-]*$') = 0
    --AND regexp_instr(in_ssn, '^[0-9]{3}-[0-9]{2}-[0-9]{4}*$') = 0
--THEN
    --raise ssn_invalid;
ELSIF in_date_of_birth IS NULL 
THEN
    raise date_of_birth_invalid;
ELSIF
    TRIM(in_client_name) IS NOT NULL
    AND VALIDATE_CONVERSION ( TRIM(in_client_name) AS NUMBER ) = 1
THEN
    raise client_name_invalid;    
ELSIF
    in_insurance_status IS NULL
then 
	raise insurance_status_invalid;	
elsIF 
	in_insurance_status is not NULL AND upper(in_insurance_status) NOT IN ( 'INSURED', 'UNINSURED' )
THEN
    raise insurance_status_invalid;	
ELSE
        INSERT INTO patient (
            patient_id,
            first_name,
            last_name,
            patient_number,
            date_of_birth,
            gender,
            ssn,
            client_id,
            insurance_status,
            updated_date,
            created_date,
            is_deleted,
            delete_date,
            flag
        ) VALUES (
            sequence_primary_id.NEXTVAL,
            in_first_name,
            in_last_name,
            sequence_primary_id.NEXTVAL,
            in_date_of_birth,
            in_gender,
            in_ssn,
            VAR_client_id,
            in_insurance_status,
            sysdate,
            sysdate,
            NULL,
            NULL,
            'INS'
        );

END IF;

	EXCEPTION
		WHEN UNIQUE_PAT_ID THEN
		raise_application_error (-20001,'Patient already exists IN Database');
		WHEN FIRST_NAME_invalid THEN
		raise_application_error (-20001,'First Name is NUll or Invalid');
		WHEN LAST_NAME_invalid THEN
		raise_application_error (-20002,'Last Name is NUll or Invalid');
		WHEN GENDER_invalid THEN
		raise_application_error (-20003,'Gender should be Male,Female or Other');
		WHEN SSN_invalid THEN
		raise_application_error (-20003,'SSN is NUll or Invalid');
		WHEN DATE_OF_BIRTH_INVALID THEN
		raise_application_error (-20004,'Date of Birth is Invalid');
		WHEN CLIENT_NAME_INVALID THEN
		raise_application_error (-20005,'Client Name is Null or not available in database');
		WHEN INSURANCE_STATUS_INVALID THEN
		raise_application_error (-20005,'Insurance status should be Insured or Uninsured');
		commit;
END;