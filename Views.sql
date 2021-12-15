-----------------------------------------------------------------------------------------
----------------------------------REPORT FOR SENDING ORDER DETAILS-----------------------
-----------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW ORDERS_OUT AS
SELECT
    p.patient_id,
    c.case_type,
    p.first_name
    || ' '
    || p.last_name                          AS patient_name,
    con.address
    || ','
    || con.city
    || ','
    || con.state                            AS patient_address,
    con.postal_code,
    con.phone_number,
    ord.order_id,
    pr.prescription_id,
    ord.order_status,
    m.medicine_name,
    pm.quantity,
    pm.strength,
    to_char(ord.created_date, 'MM-DD-YYYY') AS order_date
FROM
         patient p
    INNER JOIN contact        con ON p.patient_id = con.patient_id
    INNER JOIN case           c ON p.patient_id = c.patient_id
                         AND c.updated_date = (
        SELECT
            MAX(updated_date)
        FROM
            case c
        WHERE
            c.patient_id = p.patient_id
    )
    left JOIN orders         ord ON c.case_id = ord.case_id
    INNER JOIN prescription   pr ON c.case_id = pr.case_id
    INNER JOIN presc_medicine pm ON pr.prescription_id = pm.prescription_id
    INNER JOIN medicines      m ON m.medicine_id = pm.medicine_id
    INNER JOIN claims         cl ON pr.prescription_id = cl.prescription_id;
	
-----------------------------------------------------------------------------------------
------------------------------CHECKING FOR CLAIM STATUS FOR PATIENT WRT CLIENT-----------
------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW PATIENT_CLAIMS AS
SELECT 
        CL.CLIENT_ID,
        CL.CLIENT_NAME,
		P.PATIENT_ID,
		p.first_name|| ' '|| p.last_name AS patient_name,
		con.phone_number,

		CLA.CLAIM_ID,
		CLA.CLAIM_STATUS
		
FROM 

		PATIENT P INNER JOIN contact        con ON p.patient_id = con.patient_id
		INNER JOIN case c ON p.patient_id = c.patient_id
                         AND c.updated_date = (
        SELECT
            MAX(updated_date)
        FROM
            case c
        WHERE
            c.patient_id = p.patient_id
    )
		INNER JOIN prescription   pr ON c.case_id = pr.case_id
		INNER JOIN claims         clA ON pr.prescription_id = cla.prescription_id
		INNER JOIN CLIENT         cl ON CLA.CLIENT_ID = cl.CLIENT_ID order by cl.client_id;
