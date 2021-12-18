
create or replace PROCEDURE ins_patient (
    in_first_name       IN VARCHAR2,
    in_last_name        IN VARCHAR2,
    in_gender           IN VARCHAR2,
    in_ssn              IN VARCHAR2,	
    in_client_name      IN VARCHAR2,
    in_date_of_birth    IN DATE,
    in_insurance_status IN VARCHAR2
) AS

    VAR_client_id NUMBER;
	VAR_DATE_CHECK VARCHAR2(100);
	var_Pat_cNT NUMber;
	cntSSN number;
	UNIQUE_PAT_ID EXCEPTION;
    first_name_invalid EXCEPTION;
    last_name_invalid EXCEPTION;
	date_of_birth_INVALID EXCEPTION;
	date_of_birth_INVALID_1 EXCEPTION;
    gender_invalid EXCEPTION;
    SSN_unique EXCEPTION;
    client_name_invalid EXCEPTION;
    insurance_status_invalid EXCEPTION;
	
BEGIN
IF 
	in_client_name IS NOT NULL AND VALIDATE_CONVERSION ( TRIM(in_client_name) AS NUMBER ) = 0 
then
	SELECT CLIENT_ID INTO VAR_CLIENT_ID FROM CLIENT WHERE upper(TRIM(CLIENT_NAME))=UPPER(TRIM(IN_CLIENT_NAME));
end IF;	
select count(*) into cntSSN from patient where ssn = in_ssn;
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
    AND upper(in_gender) NOT IN ( 'M', 'F', 'O' )
THEN
    raise gender_invalid;
ELSIF 
	in_sSN IS Not null aND (cntSSN>0)
then 
	raise SSN_unique;
ELSIF 
	in_date_of_birth IS NULL 
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
            initcap(in_first_name),
            initcap(in_last_name),
            sequence_primary_id.NEXTVAL,
            in_date_of_birth,
            in_gender,
            in_ssn,
            VAR_client_id,
            initcap(in_insurance_status),
            sysdate,
            sysdate,
            NULL,
            NULL,
            'INS'
        );

END IF;

	EXCEPTION
		WHEN UNIQUE_PAT_ID THEN
		raise_application_error (-20001,'Patient already exists in Database');
		WHEN FIRST_NAME_invalid THEN
		raise_application_error (-20002,'First Name is NUll or Invalid');
		WHEN LAST_NAME_invalid THEN
		raise_application_error (-20003,'Last Name is NUll or Invalid');
		WHEN GENDER_invalid THEN
		raise_application_error (-20004,'Gender should be Male,Female or Other');
		WHEN SSN_unique THEN
		raise_application_error (-20005,'SSN is NOT unique');
		WHEN DATE_OF_BIRTH_INVALID THEN
		raise_application_error (-20006,'Date of Birth is Invalid');
		WHEN CLIENT_NAME_INVALID THEN
		raise_application_error (-20007,'Client Name is Null or not available in database');
		WHEN INSURANCE_STATUS_INVALID THEN
		raise_application_error (-20008,'Insurance status should be Insured or Uninsured');
		commit;
END;

---------------------------------

CREATE OR REPLACE PROCEDURE ins_pat_contact (
    in_patient_id   IN NUMBER,
    in_address      IN VARCHAR2,
    in_city         IN VARCHAR2,
    in_state        IN VARCHAR2,
    in_postal_code  IN VARCHAR2,
    in_phone_type   IN VARCHAR2, -- Not Mandatory
    in_phone_number IN VARCHAR2
) AS

    var_patient_id NUMBER;
    var_pat_cnt    NUMBER;
    unique_pat_id EXCEPTION;
    address_invalid EXCEPTION;
    city_invalid EXCEPTION;
    state_invalid EXCEPTION;
    postal_code_invalid EXCEPTION;
    phone_type_invalid EXCEPTION;
    phone_number_invalid EXCEPTION;
    phone_length_invalid EXCEPTION;
BEGIN
    IF in_address IS NULL THEN
        RAISE address_invalid;
    ELSIF in_city IS NULL THEN
        RAISE city_invalid;
    ELSIF in_state IS NULL THEN
        RAISE state_invalid;
	ELSIf in_stATE IS not nuLL AND LENGTH(in_stATE)!=2 THEN
		raise state_invalid;
    ELSIF in_postal_code IS NULL THEN
        RAISE postal_code_invalid;
    ELSIF VALIDATE_CONVERSION(in_postal_code as number)=0 THEN
        RAISE postal_code_invalid;
	ELSIF length(in_postal_code) <> 5 THEN
        raise postal_code_invalid;
    ELSIF in_phone_type IS NULL THEN
        RAISE phone_type_invalid;
    ELSIF
        in_phone_type IS NOT NULL
        AND upper(in_phone_type) NOT IN ( 'HOME', 'MOBILE', 'OFFICE' )
    THEN
        RAISE phone_type_invalid;
    ELSIF in_phone_number IS NULL THEN
        RAISE phone_number_invalid;
    ELSIF length(in_phone_number) <> 10 THEN
        raise phone_length_invalid;
	ELSiF VALIDATE_CONVERSION(in_phone_number as nUMBER)=0 then
		Raise phone_number_invalid;
    ELSE
        SELECT
            COUNT(1)
        INTO var_patient_id
        FROM
            patient
        WHERE
            patient_id = in_patient_id;

        IF var_patient_id > 0 THEN
            INSERT INTO contact VALUES (
                sequence_primary_id.NEXTVAL,
                in_patient_id,
                in_address,
                INITCAP(in_city),
                UPPER(in_state),
                in_postal_code,
                initcaP(in_phone_type),
                in_phone_number,
                sysdate,
                sysdate,
                NULL,
                NULL
            );
                -- do something here if exists
                --dbms_output.put_line('record exists.');
        ELSE
            RAISE unique_pat_id;
                -- do something here if not exists
                ---dbms_output.put_line('record does not exists.');
        END IF;

        COMMIT;
    END IF;
EXCEPTION
    WHEN unique_pat_id THEN
        raise_application_error(-20001, 'Patiet doesn''t exist in databse  Database');
    WHEN address_invalid THEN
        raise_application_error(-20001, 'Address should not be null or Invalid');
    WHEN city_invalid THEN
        raise_application_error(-20002, 'City should not be NUll');
    WHEN state_invalid THEN
        raise_application_error(-20003, 'State should not be NUll and length must be 2');
    WHEN postal_code_invalid THEN
        raise_application_error(-20003, 'Postal Code should not be Null and must be 5 digits');
    WHEN phone_type_invalid THEN
        raise_application_error(-20004, 'Phone type should be Mobile, Home or Office');
    WHEN phone_number_invalid THEN
        raise_application_error(-20005, 'Phone Number should not be Null or invalid');
    WHEN phone_length_invalid THEN
        raise_application_error(-20005, 'Phone Number length must be 10');
        COMMIT;
END;

----------------------------------------
----------------------------------------

CREATE OR REPLACE PROCEDURE ins_pat_prescription (
    in_Case_ID      IN NUMBER,
    in_disease_name         IN VARCHAR2,
    in_disease_type        IN VARCHAR2,
	in_medicine_name  in varchar2,
	in_Manufacturer in varchar2,
	in_quantity in number,
	in_strength in varchar2
) AS
	cnt_medicine_id number;
	var_medicine_id number;
	var_CASE_id NUMBer;
	CASE_ID_INVALID EXCEPTION;
	CASE_ID_NAD EXCEPTION;
    disease_name_null EXCEPTION;
	medicine_name_null exception;
	manufacturer_null exception;
	quantity_null exception;
	strength_null exception;
	medicine_name_NAD exception;
    BEGIN
        IF in_case_id IS NULL THEN
            RAISE case_id_invalid;
        ELSIF in_disease_name IS NULL THEN
            RAISE disease_name_null;
        ELSIF in_medicine_name IS NULL THEN
            RAISE medicine_name_null;
        ELSIF in_manufacturer IS NULL THEN
            RAISE manufacturer_null;
        ELSIF in_quantity IS NULL THEN
            RAISE quantity_null;
        ELSIF in_strength IS NULL THEN
            RAISE strength_null;
        ELSE
            dbms_output.put_line('Null check passed');
        END IF;

        SELECT
            COUNT(*)
        INTO cnt_medicine_id
        FROM
            medicines
        WHERE
                medicine_name = in_medicine_name
            AND manufacturer = TRIM(in_manufacturer)
                AND strength = trim(in_strength);

    IF ( cnt_medicine_id > 0 ) THEN
        SELECT
            medicine_id
        INTO var_medicine_id
        FROM
            medicines
        WHERE
                medicine_name = in_medicine_name
            AND manufacturer = TRIM(in_manufacturer)
			 AND strength = trim(in_strength);

    ELSE
        RAISE medicine_name_nad;
    END IF;

    SELECT
        COUNT(*)
    INTO var_case_id
    FROM
        case
    WHERE
        case_id = in_case_id;

    IF var_case_id = 1 THEN
        dbms_output.put_line('Case is found in database, Creating prescription');
        INSERT ALL INTO prescription VALUES (
            sequence_primary_id.NEXTVAL,
            in_case_id,
            initcap(in_disease_name),
            initcap(in_disease_type),
            sysdate,
            sysdate,
            NULL,
            NULL
        ) INTO presc_medicine (
            order_med_id,
            prescription_id,
            medicine_id,
            quantity,
            strength,
            created_date,
            updated_date
        ) VALUES (
            sequence_next_key.NEXTVAL,
            sequence_primary_id.NEXTVAL,
            var_medicine_id,
            in_quantity,
            in_strength,
            sysdate,
            sysdate
        ) SELECT
              in_case_id,
              in_disease_name,
              in_disease_type,
              var_medicine_id,
              in_quantity,
              in_strength
          FROM
              dual;
        COMMIT;
		else
		raise case_id_nad;
    END IF;
		dbms_output.put_line('after if');
EXCEPTION
    WHEN disease_name_null THEN
        raise_application_error(-20001, 'Disease name is required');
    WHEN CASE_ID_INVALID THEN
        raise_application_error(-20002, 'Case id should not be null or invalid');
	WHEN CASE_ID_NAD THEN
        raise_application_error(-20003, 'Please Create the Case first');
	WHEN medicine_name_null THEN
        raise_application_error(-20005, 'Medicine Name should not be null');
	WHEN manufacturer_null THEN
        raise_application_error(-20006, 'manufacturer should not be null');
	WHEN quantity_null THEN
        raise_application_error(-20007, 'quantity should not be null');
	WHEN strength_null THEN
        raise_application_error(-20008, 'strength should not be null');
	WHEN medicine_name_NAD THEN
        raise_application_error(-20009, 'medicine name not available in database');
    COMMIT;
END;


