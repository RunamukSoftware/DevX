CREATE PROCEDURE [dbo].[GetPatientsBySearch]
    (
     @last_name DLAST_NAME,
     @first_name DFIRST_NAME,
     @mrn_id DMRN_ID,
     @login_name NVARCHAR(64),
     @is_vip_searchable NVARCHAR(4),
     @is_restricted_unit_searchable NVARCHAR(4)
    )
AS
BEGIN
    DECLARE
        @QUERY VARCHAR(MAX),
        @CONDITION VARCHAR(MAX);

    SET @QUERY = '
SELECT 
    int_mrn_map.patient_id AS patient_id, 
    ISNULL(int_person.last_nm,'''') + ISNULL('', '' + int_person.first_nm,'''') AS patient_name, 
    int_monitor.monitor_name AS MONITOR_NAME,
    int_mrn_map.mrn_xid2 AS ACCOUNT_ID,
    int_mrn_map.mrn_xid AS MRN_ID,
    ORG1.organization_id AS UNIT_ID,
    ORG1.organization_cd AS UNIT_NAME,
    ORG2.organization_id AS FACILITY_ID,
    ORG2.organization_nm AS FACILITY_NAME,
    int_patient.dob AS DOB,
    int_encounter.admit_dt AS ADMIT_TIME,
    int_encounter.discharge_dt AS DISCHARGED_TIME,
    int_patient_monitor.last_result_dt AS PRECEDENCE,
    int_patient_monitor.patient_monitor_id AS PATIENT_MONITOR_ID,
    STATUS = case  
        WHEN int_encounter.discharge_dt IS NULL 
      THEN ''A''
          ELSE ''D''
    END
FROM
    dbo.int_patient_monitor
    INNER JOIN dbo.int_encounter ON int_encounter.encounter_id = int_patient_monitor.encounter_id 
    INNER JOIN dbo.int_monitor ON int_patient_monitor.monitor_id = int_monitor.monitor_id 
    INNER JOIN dbo.int_organization  AS ORG1 ON (int_monitor.unit_org_id = ORG1.organization_id)                                
    INNER JOIN dbo.int_mrn_map ON int_encounter.patient_id = int_mrn_map.patient_id AND int_mrn_map.merge_cd = ''C''
    INNER JOIN dbo.int_person ON int_encounter.patient_id = int_person.person_id 
    INNER JOIN dbo.int_patient ON int_encounter.patient_id = int_patient.patient_id
    LEFT OUTER JOIN dbo.int_account ON int_encounter.account_id = int_account.account_id 
    LEFT OUTER JOIN dbo.int_organization AS ORG2 ON ORG2.organization_id=ORG1.parent_organization_id
 ';

    -- Convert * to percentile in variables
    SET @last_name = LTRIM(RTRIM(@last_name));

    SET @first_name = LTRIM(RTRIM(@first_name));

    SET @mrn_id = LTRIM(RTRIM(@mrn_id));

    SET @CONDITION = ISNULL(@CONDITION, '');

    -- Unit accessibility
    IF (@is_restricted_unit_searchable <> '1')
    BEGIN
        SET @CONDITION += ' ORG1.organization_id 
                    NOT IN (SELECT cdr_restricted_organization.organization_id FROM dbo.cdr_restricted_organization
                    WHERE cdr_restricted_organization.user_role_id = 
                    (SELECT user_role_id FROM dbo.int_user WHERE login_name =''' + @login_name + '''))';
    END;

    --Last name
    IF (LEN(@last_name) > 0)
    BEGIN
       
        SET @last_name = REPLACE(@last_name, '*', '%');
        SET @last_name = QUOTENAME(@last_name, '''');

        IF (LEN(@CONDITION) > 0)
            SET @CONDITION += ' AND ';

        SET @CONDITION += ' (int_person.last_nm like ' + @last_name + ')';
    END;

    --First name
    IF (LEN(@first_name) > 0)
    BEGIN
       
        SET @first_name = REPLACE(@first_name, '*', '%');
        SET @first_name = QUOTENAME(@first_name, '''');

        IF (LEN(@CONDITION) > 0)
            SET @CONDITION += ' AND ';

        SET @CONDITION += ' (int_person.first_nm like ' + @first_name + ')';
    END;

    /*
    IF (LEN(@patient_id) > 0)
    BEGIN
        SET @patient_id = REPLACE(@patient_id, '*', '%')

        IF (LEN(@CONDITION) > 0)
            SET @CONDITION += ' AND '
        SET @CONDITION += ' (int_patient.patient_id like ''' + @patient_id + ''')'
    END 
    */

    --MRN ID
    IF (LEN(@mrn_id) > 0)
    BEGIN
        SET @mrn_id = QUOTENAME(@mrn_id, '''');
        
        SET @mrn_id = REPLACE(@mrn_id, '\', '\\');
        SET @mrn_id = REPLACE(@mrn_id, '[', '\[');
        SET @mrn_id = REPLACE(@mrn_id, ']', '\]');
        SET @mrn_id = REPLACE(@mrn_id, '_', '\_');
        SET @mrn_id = REPLACE(@mrn_id, '%', '\%');
        SET @mrn_id = REPLACE(@mrn_id, '^', '\^');
        SET @mrn_id = REPLACE(@mrn_id, '*', '%');

        IF (LEN(@CONDITION) > 0)
            SET @CONDITION += ' AND ';

        SET @CONDITION += ' (int_mrn_map.mrn_xid like ' + @mrn_id + ' ESCAPE ''\'')';
    END;

    --Check for VIP Patient
    IF (@is_vip_searchable <> '1')
    BEGIN
        IF (LEN(@CONDITION) > 0)
        BEGIN
            SET @CONDITION += ' AND ';
        END;

        SET @CONDITION += 'int_encounter.vip_sw IS NULL';
    END;

    --Add condition
    IF (LEN(@CONDITION) > 0)
    BEGIN
        SET @QUERY += ' WHERE ';
        SET @QUERY += @CONDITION;
    END;

    -- Add a separate query for dataloader patients
    SET @QUERY += '

UNION

SELECT
    [patient_id],
    [patient_name],
    [MONITOR_NAME],
    [ACCOUNT_ID],
    [MRN_ID],
    [UNIT_ID],
    [UNIT_NAME],
    [FACILITY_ID],
    [FACILITY_NAME],
    [DOB],
    [ADMIT_TIME],
    [DISCHARGED_TIME],
    [ADMIT_TIME] AS [PRECEDENCE],
    [PATIENT_MONITOR_ID],
    [STATUS]
FROM
    [dbo].[v_StitchedPatients]
 ';

    SET @CONDITION = '';

     --Unit accessibility
    IF (@is_restricted_unit_searchable <> '1')
    BEGIN
        SET @CONDITION += ' [UNIT_ID] 
                    NOT IN (SELECT cdr_restricted_organization.organization_id FROM dbo.cdr_restricted_organization
                    WHERE cdr_restricted_organization.user_role_id = 
                    (SELECT user_role_id FROM dbo.int_user WHERE login_name =''' + @login_name + '''))';
    END;

    --Last name
    IF (LEN(@last_name) > 0)
    BEGIN
    
        IF (LEN(@CONDITION) > 0)
            SET @CONDITION += ' AND ';

        SET @CONDITION += ' (LTRIM(RTRIM([LAST_NAME])) like ' + @last_name + ')';
    END;

    --First name
    IF (LEN(@first_name) > 0)
    BEGIN

        IF (LEN(@CONDITION) > 0)
            SET @CONDITION += ' AND ';

        SET @CONDITION += ' (LTRIM(RTRIM([FIRST_NAME])) like ' + @first_name + ')';
    END;

    --MRN ID
    IF (LEN(@mrn_id) > 0)
    BEGIN

        IF (LEN(@CONDITION) > 0)
            SET @CONDITION += ' AND ';

        SET @CONDITION += ' (LTRIM(RTRIM([MRN_ID])) like ' + @mrn_id + ' ESCAPE ''\'')';
    END;

    --Add condition
    IF (LEN(@CONDITION) > 0)
    BEGIN
        SET @QUERY += ' WHERE patient_id IS NOT NULL AND ';
        SET @QUERY += @CONDITION;
    END;

    SET @QUERY += '
ORDER BY 
    [ADMIT_TIME] DESC, 
    [PRECEDENCE] DESC,
    [STATUS],
    [patient_name],
    [MONITOR_NAME]';

    EXEC (@QUERY);
END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Search for patients by last name, first name, medical record number (MRN), VIP status and restricted unit.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetPatientsBySearch';
