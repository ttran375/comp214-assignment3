CREATE OR REPLACE PROCEDURE DDCKBAL_SP (
    p_pledgeid IN dd_pledge.idpledge%TYPE,
    p_pledgeamt OUT dd_pledge.pledgeamt%TYPE,
    p_TOTAL OUT dd_payment.payamt%TYPE,
    p_REMAIN OUT dd_payment.payamt%TYPE
) IS
    Z_MPMT dd_pledge.pledgeamt%TYPE;
    Z_PID  dd_pledge.idpledge%TYPE;
    Z_PMT  dd_pledge.pledgeamt%TYPE;
    Z_MON  DD_PLEDGE.IDSTATUS%TYPE;
    TOTALP NUMBER;
BEGIN
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
    IF Z_MON = 10 THEN
        p_pledgeamt := Z_MPMT;
 /* p_pledgeamt :=  1;*/
        p_TOTAL := TOTALP * Z_MPMT;
        p_REMAIN := Z_PMT - p_TOTAL;
    ELSE
        p_pledgeamt := Z_MON;
        DBMS_OUTPUT.PUT_LINE('NODATA FOUND FOR YOU');
    END IF;
END DDCKBAL_SP;
/

DECLARE
    AMT    NUMBER(30);
    TATAL  NUMBER(30);
    REMAIN NUMBER(30);
BEGIN
    DDCKBAL_SP('110', AMT, TATAL, REMAIN);
    DBMS_OUTPUT.PUT_LINE('PAYMENT PER MONTH IS '
                         || AMT);
    DBMS_OUTPUT.PUT_LINE('TOTAL PAYMENT TO DATE IS IS '
                         || TATAL);
    DBMS_OUTPUT.PUT_LINE('REMAINING BAL IS '
                         || REMAIN);
END;
/
