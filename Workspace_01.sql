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
    TYPE PRO IS RECORD(
        IDPROJ DD_PROJECT.IDPROJ%TYPE,
        PROJNAME DD_PROJECT.PROJNAME%TYPE,
        PROJSTARTDATE DD_PROJECT.PROJSTARTDATE%TYPE,
        PROJENDDATE DD_PROJECT.PROJENDDATE%TYPE,
        PROJFUNDGOAL DD_PROJECT.PROJFUNDGOAL%TYPE,
        PROJCOORD DD_PROJECT.PROJCOORD%TYPE
    );
    D_PRO PRO;
BEGIN
    SELECT
        * INTO d_project
    FROM
        DD_PROJECT
    WHERE
        IDPROJ = Pro_ID;
END DDPROJ_SP;
/

DECLARE
 -- d_project DD_PROJECT%ROWTYPE;
    TYPE PRO IS RECORD(
        IDPROJ DD_PROJECT.IDPROJ%TYPE,
        PROJNAME DD_PROJECT.PROJNAME%TYPE,
        PROJSTARTDATE DD_PROJECT.PROJSTARTDATE%TYPE,
        PROJENDDATE DD_PROJECT.PROJENDDATE%TYPE,
        PROJFUNDGOAL DD_PROJECT.PROJFUNDGOAL%TYPE,
        PROJCOORD DD_PROJECT.PROJCOORD%TYPE
    );
    d_project PRO;
BEGIN
    DDPROJ_SP(501, d_project );
    DBMS_OUTPUT.PUT_LINE(d_project.IDPROJ);
    DBMS_OUTPUT.PUT_LINE(d_project.PROJNAME);
    DBMS_OUTPUT.PUT_LINE(d_project.PROJSTARTDATE);
    DBMS_OUTPUT.PUT_LINE(d_project.PROJENDDATE);
    DBMS_OUTPUT.PUT_LINE(d_project.PROJFUNDGOAL);
    DBMS_OUTPUT.PUT_LINE(d_project.PROJCOORD);
END;
/