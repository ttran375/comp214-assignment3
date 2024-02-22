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
 -- Declaration of variables to store the pledge status and the number of payment months.
    STATUS  NUMBER;
    MON_PAY NUMBER;
BEGIN
 -- Retrieving pledge status and the number of payment months from the DD_PLEDGE table based on the provided pledge ID.
    SELECT
        IDSTATUS,
        PAYMONTHS INTO STATUS,
        MON_PAY
    FROM
        DD_PLEDGE
    WHERE
        IDPLEDGE = P_ID;
 -- Checking conditions to determine the payment status and setting P_RESP accordingly.
    IF STATUS != 10 AND MON_PAY > 1 THEN
        P_RESP := FALSE;
    ELSIF STATUS = 10 AND MON_PAY > 0 THEN
        P_RESP := TRUE;
    END IF;
END DDPAY_SP;
/

-- This is an anonymous PL/SQL block that demonstrates the usage of the DDPAY_SP procedure.

DECLARE
 -- Declaration of a variable P_ID with a sample pledge ID (105).
    P_ID   DD_PLEDGE.IDPLEDGE%type := 105;
 -- Declaration of a variable P_RESP to store the output of the procedure.
    P_RESP BOOLEAN;
BEGIN
 -- Calling the DDPAY_SP procedure with the provided pledge ID (105) and storing the output in the P_RESP variable.
    DDPAY_SP(P_ID, P_RESP);
 -- Displaying the result using DBMS_OUTPUT.
    dbms_output.put_line(
        CASE
            WHEN P_RESP THEN
                'TRUE'
            ELSE
                'FALSE'
        END );
END;
/
