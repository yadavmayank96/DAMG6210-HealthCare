
CREATE OR REPLACE PROCEDURE filter_order_inputs IS

    CURSOR records IS
    SELECT
        *
    FROM
        in_file;

    record_i    in_file%rowtype;
    records_to_filter NUMBER := 0;
    n_orders          NUMBER := 0;
    no_records_to_filter EXCEPTION;
    no_orders EXCEPTION;


BEGIN
    SELECT
        COUNT(*)
    INTO records_to_filter
    FROM
        in_file;

    SELECT
        COUNT(*)
    INTO n_orders
    FROM
        orders;

    IF records_to_filter = 0 THEN
        RAISE no_records_to_filter;
    ELSIF n_orders = 0 THEN
        RAISE no_orders;
    END IF;

    OPEN records;
    LOOP
        FETCH records INTO record_i;
        EXIT WHEN records%notfound;

        DECLARE
            record_present NUMBER := 0;
            flag NUMBER:=0;
            record_status VARCHAR2(255) :='NEW';
        BEGIN
            dbms_output.put_line('---BEGIN---');
            SELECT
                COUNT(*)
            INTO record_present
            FROM
                orders
            WHERE
                order_id = record_i.order_number;
                
            SELECT
                ORDER_STATUS
            INTO  record_status
            FROM
                orders
            WHERE
                order_id = record_i.order_number;
            
            IF record_i.order_number IS NULL OR record_present = 0 THEN
--                dbms_output.put_line('---BEGIN---');
                flag:=error_records_transfer(record_i.order_number,record_i.patient_number,'order_number_null');
            END IF;

            IF record_i.order_status IS NULL OR upper(record_i.order_status) NOT IN ( 'SHIPPED', 'DELIVERED' ) THEN
                flag:=error_records_transfer(record_i.order_number,record_i.patient_number,'order_status_null');
                END IF;

            IF record_i.patient_number IS NULL THEN
                flag:=error_records_transfer(record_i.order_number,record_i.patient_number,'patient_number_null');
                END IF;

            IF upper(record_status) = 'DELIVERED' THEN
                flag:=error_records_transfer(record_i.order_number,record_i.patient_number,'order_already_delivered');
            END IF;
            
            IF upper(record_i.order_status) = 'SHIPPED' THEN
                flag:=date_check(record_i.SHIP_DATE);
--                dbms_output.put_line('---Checking SHIPPING Date---');

                IF flag = 2 THEN
                    flag:=error_records_transfer(record_i.order_number,record_i.patient_number,'shipping_date_invalid');
                ELSE
                    flag:=status_update(record_i.order_number);
                    IF flag = 1 THEN
                        dbms_output.put_line('Order Status Updated');
                        dbms_output.put_line(record_i.order_number);
                    ELSE
                        dbms_output.put_line('Error Occured');
                    END IF;
                END IF;
            END IF;
            IF upper(record_i.order_status) = 'DELIVERED' THEN
                flag := date_check(record_i.delivery_date);
--                dbms_output.put_line('---Checking Date---');

                IF flag = 2 THEN
                    flag:=error_records_transfer(record_i.order_number,record_i.patient_number,'delivered_date_invalid');
                ELSE
                    flag:=status_update(record_i.order_number);
                    IF flag = 1 THEN
                        dbms_output.put_line('Order Status Updated');
                        dbms_output.put_line(record_i.order_number);
                    ELSE
                        dbms_output.put_line('Error Occured');
                    END IF;
                END IF;
            END IF;

            
        END;

    END LOOP;

EXCEPTION
    WHEN no_records_to_filter THEN
        dbms_output.put_line('---No data found in in_file table---');
    WHEN no_orders THEN
        dbms_output.put_line('---No orders data found---');
    WHEN OTHERS THEN
        dbms_output.put_line(sqlerrm);
END;


SET SERVEROUTPUT ON;
EXEC FILTER_ORDER_INPUTS;