-- Question 2 (5 marks)
-- Create a procedure named DDPAY_SP that identifies whether a donor currently has an active
-- pledge with monthly payments. A donor ID is the input to the procedure. Using the donor ID, the
-- procedure needs to determine whether the donor has any currently active pledges based on the
-- status field and is on a monthly payment plan. If so, the procedure is to return the Boolean value
-- TRUE. Otherwise, the value FALSE should be returned. Test the procedure with an anonymous
-- block.
CREATE OR REPLACE PROCEDURE DDPAY_SP (
    P_ID IN NUMBER,
    P_RESP OUT BOOLEAN
) IS
    STATUS  NUMBER;
    MON_PAY NUMBER;
BEGIN
    SELECT
        IDSTATUS,
        PAYMONTHS INTO STATUS,
        MON_PAY
    FROM
        DD_PLEDGE
    WHERE
        IDPLEDGE = P_ID;
    IF STATUS != 10 AND MON_PAY > 1 THEN
        P_RESP := FALSE;
    ELSIF STATUS = 10 AND MON_PAY > 0 THEN
        P_RESP := TRUE;
    END IF;
END DDPAY_SP;
/

DECLARE
    P_ID   DD_PLEDGE.IDPLEDGE%type := 105;
    P_RESP BOOLEAN;
BEGIN
    DDPAY_SP(P_ID, P_RESP);
    dbms_output.put_line(
        CASE
            WHEN P_RESP THEN
                'TRUE'
            ELSE
                'FALSE'
        END );
END;
/
