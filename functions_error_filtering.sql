CREATE OR REPLACE FUNCTION status_update (
    o_id NUMBER
) RETURN NUMBER IS
    valid NUMBER := 2;
BEGIN
    UPDATE orders
    SET
        order_status = (
            SELECT
                order_status
            FROM
                in_file
            WHERE
                order_number = o_id
        )
    WHERE
        order_id = o_id;

    DELETE FROM in_file
    WHERE
        order_number = o_id;

    COMMIT;
    valid := 1;
    RETURN valid;
END;

-----------------------------------------------------------------

CREATE OR REPLACE FUNCTION error_records_transfer (
    o_id      NUMBER,
    p_id      NUMBER,
    error_txt VARCHAR
) RETURN NUMBER IS
    record_present NUMBER:=0;

    valid NUMBER := 2;

BEGIN

            SELECT
            COUNT(*)
            INTO record_present
            FROM
                error_records
            WHERE
                order_number = o_id;
    IF record_present=0 THEN

    INSERT INTO error_records (
        order_number,
        patient_number,
        error,
        err_desc,
        created_date,
        updated_date
    ) VALUES (
        o_id,
        p_id,
        error_txt,
        error_txt,
        sysdate,
        sysdate
    );

    DELETE FROM in_file
    WHERE
        order_number = o_id;
    valid := 1;
    COMMIT;
    
    ELSE
        DELETE FROM in_file
    WHERE
        order_number = o_id;
    valid := 2;
    COMMIT;
    END IF;
    
    RETURN valid;
    
    EXCEPTION
WHEN OTHERS THEN
   raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
    
END;
COMMIT;
-----------------------------------------------------------------


CREATE OR REPLACE FUNCTION date_check (
    change_date IN DATE
) RETURN NUMBER IS
    valid NUMBER := 2;
BEGIN
    IF change_date <= sysdate THEN
        valid := 1;
    END IF;
    RETURN valid;
END;

COMMIT;