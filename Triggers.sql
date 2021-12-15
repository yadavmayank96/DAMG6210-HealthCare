-- TRIGGER

CREATE OR REPLACE PROCEDURE REMOVE_OBJECTS (
    NAME_OF_OBJECT VARCHAR2,
    TYPE_OF_OBJECT VARCHAR2
) IS
    CNT NUMBER := 0;
BEGIN
    IF UPPER(TYPE_OF_OBJECT) = 'TABLE' THEN
        SELECT
            COUNT(*)
        INTO CNT
        FROM
            user_tables
        WHERE
            UPPER(table_name) = upper(TRIM(NAME_OF_OBJECT));

        IF CNT > 0 THEN
            EXECUTE IMMEDIATE 'drop table '
                              || NAME_OF_OBJECT
                              || ' cascade constraints';
        END IF;
    END IF;

    IF UPPER(TYPE_OF_OBJECT) = 'PROCEDURE' THEN
        SELECT
            COUNT(*)
        INTO CNT
        FROM
            user_objects
        WHERE
                UPPER(object_type) = 'PROCEDURE'
            AND UPPER(object_name) = upper(NAME_OF_OBJECT);

        IF CNT > 0 THEN
            EXECUTE IMMEDIATE 'DROP PROCEDURE ' || NAME_OF_OBJECT;
        END IF;
    END IF;
	
	
    IF upper(TYPE_OF_OBJECT) = 'TRIGGER' THEN
        SELECT
            COUNT(*)
        INTO CNT
        FROM
            user_triggers
        WHERE
            UPPER(trigger_name) = upper(NAME_OF_OBJECT);

        IF CNT > 0 THEN
            EXECUTE IMMEDIATE 'DROP TRIGGER ' || NAME_OF_OBJECT;
        END IF;
    END IF;

    IF UPPER(TYPE_OF_OBJECT) = 'FUNCTION' THEN
        SELECT
            COUNT(*)
        INTO CNT
        FROM
            user_objects
        WHERE
                UPPER(object_type) = 'FUNCTION'
            AND UPPER(object_name) = upper(NAME_OF_OBJECT);

        IF CNt > 0 THEN
            EXECUTE IMMEDIATE 'DROP FUNCTION ' || NAME_OF_OBJECT;
        END IF;
    END IF;
	
    IF UPPER(TYPE_OF_OBJECT) = 'SEQUENCE' THEN
        SELECT
            COUNT(*)
        INTO CNT
        FROM
            user_sequences
        WHERE
            UPPER(sequence_name) = upper(NAME_OF_OBJECT);

        IF CNT > 0 THEN
            EXECUTE IMMEDIATE 'DROP SEQUENCE ' || NAME_OF_OBJECT;
        END IF;
    END IF;

    IF UPPER(TYPE_OF_OBJECT) = 'VIEW' THEN
        SELECT
            COUNT(*)
        INTO CNT
        FROM
            user_views
        WHERE
            UPPER(view_name) = upper(NAME_OF_OBJECT);

        IF CNT > 0 THEN
            EXECUTE IMMEDIATE 'DROP VIEW ' || NAME_OF_OBJECT;
        END IF;
    END IF;

END;
/


EXEC REMOVE_OBJECTS('TRG_INS_CASE','TRIGGER');

CREATE TRIGGER TRG_INS_CASE AFTER
    INSERT ON patient
    FOR EACH ROW
BEGIN
    INSERT INTO case VALUES (
        sequence_primary_id.NEXTVAL,
        'NEW',
        :new.patient_id,
        sysdate,
        sysdate,
        NULL,
        NULL
    );
END;
/
ALTER TRIGGER TRG_INS_CASE ENABLE;

EXEC REMOVE_OBJECTS('TRG_UPD_CASE','TRIGGER');

CREATE TRIGGER TRG_UPD_CASE AFTER
    UPDATE ON patient
    FOR EACH ROW
BEGIN
    INSERT INTO case VALUES (
        sequence_primary_id.NEXTVAL,
        'Re-visit',
        :new.patient_id,
        sysdate,
        sysdate,
        NULL,
        NULL
    );

END;
/

ALTER TRIGGER TRG_UPD_CASE ENABLE;