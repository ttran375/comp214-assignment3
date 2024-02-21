-- Question 3 (5 marks)
-- Create a procedure named DDCKPAY_SP that confirms whether a monthly pledge payment is
-- the correct amount. The procedure needs to accept two values as input: a payment amount and a
-- pledge ID. Based on these inputs, the procedure should confirm that the payment is the correct
-- monthly increment amount, based on pledge data in the database. If it isn’t, a custom Oracle
-- error using error number 20050 and the message “Incorrect payment amount - planned payment
-- = ??” should be raised. The ?? should be replaced by the correct payment amount. The database
-- query in the procedure should be formulated so that no rows are returned if the pledge isn’t on a
-- monthly payment plan or the pledge isn’t found. If the query returns no rows, the procedure
-- should display the message “No payment information.” Test the procedure with the pledge ID
-- 104 and the payment amount $25. Then test with the same pledge ID but the payment amount
-- $20. Finally, test the procedure with a pledge ID for a pledge that doesn’t have monthly
-- payments associated with it.
CREATE OR REPLACE PROCEDURE DDCKPAY_SP (
    P_ID IN NUMBER,
    P_AMT IN NUMBER,
    RESPONCE OUT VARCHAR2
) IS
    M_MONTH   DD_PLEDGE.PAYMONTHS%TYPE;
    M_ID      DD_PLEDGE.IDPLEDGE%TYPE;
    M_AMT     DD_PLEDGE.PLEDGEAMT%TYPE;
    FINAL_AMT DD_PLEDGE.PLEDGEAMT%TYPE;
    NO_MONTH EXCEPTION;
BEGIN
    SELECT
        IDPLEDGE,
        PLEDGEAMT,
        PAYMONTHS INTO M_ID,
        M_AMT,
        M_MONTH
    FROM
        DD_PLEDGE
    WHERE
        IDPLEDGE = P_ID;
    IF M_MONTH = 0 THEN
        RAISE NO_MONTH;
    END IF;

    FINAL_AMT := M_AMT /M_MONTH;
    IF P_AMT = FINAL_AMT THEN
        RESPONCE := 'CORRECT PAYMENT';
    ELSIF P_AMT != FINAL_AMT THEN
        RAISE_APPLICATION_ERROR(-20050, 'Incorrect payment amount - planned payment = '
                                        || FINAL_AMT);
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No payment information');
    WHEN NO_MONTH THEN
        DBMS_OUTPUT.PUT_LINE('No payment information');
END DDCKPAY_SP;
/