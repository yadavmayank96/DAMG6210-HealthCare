CREATE OR REPLACE TRIGGER trg_ins_case AFTER
    INSERT ON patient
    FOR EACH ROW
BEGIN
    INSERT INTO case VALUES (
        sequence_primary_id.NEXTVAL,
        'New',
        :new.patient_id,
        sysdate,
        sysdate,
        NULL,
        NULL
    );

END;
/
CREATE OR REPLACE TRIGGER trg_upd_case AFTER
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

CREATE OR REPLACE TRIGGER trg_ins_claims AFTER
    INSERT ON prescription
    FOR EACH ROW
BEGIN
    INSERT INTO claims VALUES (
        sequence_claim_id.NEXTVAL,
        'Claim Requested',
		'New',
		get_pat_client_id(:new.case_id),
		:new.prescription_id,
        sysdate,
        sysdate,
        NULL,
        NULL
    );
END;
/


   create or replace FUNCTION get_pat_client_id(i_case_id in number) RETURN NUMBER IS
        cli_id NUMBER;
    BEGIN
        SELECT
            cl.client_id
        INTO cli_id
        FROM
            client cl
        WHERE cl.client_id = (select p.client_id from patient p where patient_id= (select patient_id from case where case_id=i_case_id))
                ;

        RETURN cli_id;
    END get_pat_client_id;
	
	
	CREATE OR REPLACE TRIGGER trg_claim_appproval AFTER
    INSERT ON claims
    FOR EACH ROW
	BEGIN
		IF :new.CLaim_sTATUS='New' then
		EXEC claims_approval (:new.client_ID,:new.prescription_id,:new.claim_id);
		end if;
	END;
	
	
		CREATE OR REPLACE TRIGGER trg_create_order AFTER
    UPDATE ON claims
    FOR EACH ROW
    declare
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
	IF upper(:new.CLAIM_status)='APPROVED' then
	create_orders(:new.prescription_id,:new.client_id,:new.claim_status);
	else
	dbms_output.put_line('Order will not be created');
	end if;
    commit;

END;
/



    CREATE or REPLACE FUNCTION allocate_pharmacy(in_cLIENT_id NUMber)
	
		RETURN number IS
		pharma_id number;
    BEGIN
        IF In_cLIENT_id IN (1,4,6,8) then
		pharma_id :=64639;
		elsif In_cLIENT_id in (11,12,13,14) then
		pharma_id :=47322;
		elsif In_cLIENT_id in (15,16,18,19) then
		pharma_id :=46947;
		elsif In_cLIENT_id in (20,21,24) then
		pharma_id :=62012;
		else 
		SELECT pharmacy_id into pharma_id FROM pharmacy SAMPLE(1) where rownum=1 and UPPER(STATUS)='ACTIVE' and is_deleted is null;
		end if;
        RETURN pharma_id;
    END allocate_pharmacy;
	

	
