-- Question 1 (5 marks)
-- Create a procedure named DDPROJ_SP that retrieves project information for a specific project
-- based on a project ID. The procedure should have two parameters: one to accept a project ID
-- value and another to return all data for the specified project. Use a record variable to have the
-- procedure return all database column values for the selected project. Test the procedure with an
-- anonymous block.
CREATE OR REPLACE PROCEDURE DDPROJ_SP (
    Pro_ID IN DD_PROJECT.IDPROJ%type,
    d_project OUT DD_PROJECT%ROWTYPE
) IS
 -- Defining a record type PRO to store the individual project attributes.
    TYPE PRO IS RECORD(
        IDPROJ DD_PROJECT.IDPROJ%TYPE,
        PROJNAME DD_PROJECT.PROJNAME%TYPE,
        PROJSTARTDATE DD_PROJECT.PROJSTARTDATE%TYPE,
        PROJENDDATE DD_PROJECT.PROJENDDATE%TYPE,
        PROJFUNDGOAL DD_PROJECT.PROJFUNDGOAL%TYPE,
        PROJCOORD DD_PROJECT.PROJCOORD%TYPE
    );
 -- Declaring a variable D_PRO of type PRO to store the project details.
    D_PRO PRO;
BEGIN
 -- Fetching project details from the DD_PROJECT table based on the provided project ID.
    SELECT
        * INTO d_project
    FROM
        DD_PROJECT
    WHERE
        IDPROJ = Pro_ID;
END DDPROJ_SP;
/

-- This is an anonymous PL/SQL block that demonstrates the usage of the DDPROJ_SP procedure.

DECLARE
 -- Declaring a record type PRO to store the project details.
    TYPE PRO IS RECORD(
        IDPROJ DD_PROJECT.IDPROJ%TYPE,
        PROJNAME DD_PROJECT.PROJNAME%TYPE,
        PROJSTARTDATE DD_PROJECT.PROJSTARTDATE%TYPE,
        PROJENDDATE DD_PROJECT.PROJENDDATE%TYPE,
        PROJFUNDGOAL DD_PROJECT.PROJFUNDGOAL%TYPE,
        PROJCOORD DD_PROJECT.PROJCOORD%TYPE
    );
 -- Declaring a variable d_project of type PRO to store the output of the procedure.
    d_project PRO;
BEGIN
 -- Calling the DDPROJ_SP procedure with a specific project ID (501) and storing the output in the d_project variable.
    DDPROJ_SP(501, d_project );
 -- Displaying individual project attributes using DBMS_OUTPUT.
    DBMS_OUTPUT.PUT_LINE(d_project.IDPROJ);
    DBMS_OUTPUT.PUT_LINE(d_project.PROJNAME);
    DBMS_OUTPUT.PUT_LINE(d_project.PROJSTARTDATE);
    DBMS_OUTPUT.PUT_LINE(d_project.PROJENDDATE);
    DBMS_OUTPUT.PUT_LINE(d_project.PROJFUNDGOAL);
    DBMS_OUTPUT.PUT_LINE(d_project.PROJCOORD);
END;
/

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
    -- Declaration of variables to store pledge details, the number of planned payment months, and the final planned payment amount.
    M_MONTH   DD_PLEDGE.PAYMONTHS%TYPE;
    M_ID      DD_PLEDGE.IDPLEDGE%TYPE;
    M_AMT     DD_PLEDGE.PLEDGEAMT%TYPE;
    FINAL_AMT DD_PLEDGE.PLEDGEAMT%TYPE;
    
    -- Custom exception for the case when the planned payment months are zero.
    NO_MONTH EXCEPTION;
BEGIN
    -- Retrieving pledge details (ID, amount, and planned months) based on the provided pledge ID.
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
    
    -- Checking if the planned payment months are zero and raising the NO_MONTH exception if true.
    IF M_MONTH = 0 THEN
        RAISE NO_MONTH;
    END IF;

    -- Calculating the final planned payment amount per month.
    FINAL_AMT := M_AMT / M_MONTH;
    
    -- Validating the payment amount and setting the RESPONCE accordingly.
    IF P_AMT = FINAL_AMT THEN
        RESPONCE := 'CORRECT PAYMENT';
    ELSIF P_AMT != FINAL_AMT THEN
        RAISE_APPLICATION_ERROR(-20050, 'Incorrect payment amount - planned payment = '
                                        || FINAL_AMT);
    END IF;
EXCEPTION
    -- Handling exceptions, including the case when no data or no payment information is found.
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No payment information');
    WHEN NO_MONTH THEN
        DBMS_OUTPUT.PUT_LINE('No payment information');
END DDCKPAY_SP;
/

-- Question 4 (5 marks)
-- As a shopper selects products on the Brewbean’s site, a procedure is needed to add a newly
-- selected item to the current shopper’s basket. Create a procedure named BASKET_ADD_SP that
-- accepts a product ID, basket ID, price, quantity, size code option (1 or 2), and form code option
-- (3 or 4) and uses this information to add a new item to the BB_BASKETITEM table. The table’s
-- PRIMARY KEY column is generated by BB_IDBASKETITEM_SEQ. Run the procedure with
-- the following values:
-- • Basket ID—14
-- • Product ID—8
-- • Price—10.80
-- • Quantity—1
-- • Size code—2
-- • Form code—4
CREATE OR REPLACE PROCEDURE DDCKBAL_SP (
    p_pledgeid IN dd_pledge.idpledge%TYPE,
    p_pledgeamt OUT dd_pledge.pledgeamt%TYPE,
    p_TOTAL OUT dd_payment.payamt%TYPE,
    p_REMAIN OUT dd_payment.payamt%TYPE
) IS
    -- Declaration of variables to store pledge and payment details.
    Z_MPMT dd_pledge.pledgeamt%TYPE;
    Z_PID  dd_pledge.idpledge%TYPE;
    Z_PMT  dd_pledge.pledgeamt%TYPE;
    Z_MON  DD_PLEDGE.IDSTATUS%TYPE;
    TOTALP NUMBER;
BEGIN
    -- Query to retrieve pledge and payment details using a JOIN between DD_PLEDGE and DD_PAYMENT.
    SELECT
        MT.PAYAMT,
        PL.IDPLEDGE,
        PL.PLEDGEAMT,
        PL.IDSTATUS,
        COUNT(MT.PAYAMT) INTO Z_MPMT,
        Z_PID,
        Z_PMT,
        Z_MON,
        TOTALP
    FROM
        DD_PLEDGE  PL
        JOIN DD_PAYMENT MT
        ON PL.IDPLEDGE = MT.IDPLEDGE
    WHERE
        MT.IDPLEDGE = p_pledgeid
    GROUP BY
        MT.PAYAMT,
        PL.IDPLEDGE,
        PL.PLEDGEAMT,
        PL.IDSTATUS;

    -- Checking the pledge status and calculating the balance accordingly.
    IF Z_MON = 10 THEN
        p_pledgeamt := Z_MPMT;
        p_TOTAL := TOTALP * Z_MPMT;
        p_REMAIN := Z_PMT - p_TOTAL;
    ELSE
        p_pledgeamt := Z_MON;
        DBMS_OUTPUT.PUT_LINE('NODATA FOUND FOR YOU');
    END IF;
END DDCKBAL_SP;
/

-- This is an anonymous PL/SQL block that demonstrates the usage of the DDCKBAL_SP procedure.

DECLARE
    -- Declaration of variables to store the results of the procedure.
    AMT    NUMBER(30);
    TATAL  NUMBER(30);
    REMAIN NUMBER(30);
BEGIN
    -- Calling the DDCKBAL_SP procedure with a specific pledge ID ('110') and storing the results in the declared variables.
    DDCKBAL_SP('110', AMT, TATAL, REMAIN);
    
    -- Displaying the results using DBMS_OUTPUT.
    DBMS_OUTPUT.PUT_LINE('PAYMENT PER MONTH IS ' || AMT);
    DBMS_OUTPUT.PUT_LINE('TOTAL PAYMENT TO DATE IS ' || TATAL);
    DBMS_OUTPUT.PUT_LINE('REMAINING BAL IS ' || REMAIN);
END;
/
