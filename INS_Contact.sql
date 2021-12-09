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
    ELSIF in_postal_code IS NULL THEN
        RAISE postal_code_invalid;
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
                in_city,
                in_state,
                in_postal_code,
                in_phone_type,
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
        raise_application_error(-20001, 'Address is NUll or Invalid');
    WHEN city_invalid THEN
        raise_application_error(-20002, 'City is NUll or Invalid');
    WHEN state_invalid THEN
        raise_application_error(-20003, 'State is NUll or Invalid');
    WHEN postal_code_invalid THEN
        raise_application_error(-20003, 'Postal Code NUll or Invalid');
    WHEN phone_type_invalid THEN
        raise_application_error(-20004, 'Phone type should be Mobile, Home or Office');
    WHEN phone_number_invalid THEN
        raise_application_error(-20005, 'Phone Number is Null or not available in database');
    WHEN phone_length_invalid THEN
        raise_application_error(-20005, 'PHONE NUMBER IS NOT IN VALID FORMAT');
        COMMIT;
END;