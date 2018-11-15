CREATE PROCEDURE [old].[uspGetPatientsBySearch]
    (
        @LastName                   NVARCHAR(40),
        @FirstName                  NVARCHAR(40),
        @MedicalRecordNumberID      NVARCHAR(40),
        @LoginName                  NVARCHAR(64),
        @IsVipSearchable            NVARCHAR(4),
        @IsRestrictedUnitSearchable NVARCHAR(4),
        @Debug                      BIT = 0
    )
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE
            @SqlQuery     NVARCHAR(MAX),
            @CONDITION NVARCHAR(MAX);

        SET @SqlQuery
            = N'
SELECT [imm].[PatientID] AS [PatientID],
	   [ipe].[FirstName],
       [ipe].[LastName],
       [im].[MonitorName],
       [imm].[MedicalRecordNumberXID2] AS [AccountID],
       [imm].[MedicalRecordNumberXID] AS [MedicalRecordNumberID],
       [ORG1].[OrganizationID] AS [UnitID],
       [ORG1].[OrganizationCode] AS [UnitName],
       [ORG2].[OrganizationID] AS [FacilityID],
       [ORG2].[OrganizationName] AS [FacilityName],
       [ipa].[DateOfBirth],
       [ie].[AdmitDateTime],
       [ie].[DischargeDateTime],
       [ipm].[LastResultDateTime] AS [Precedence],
       [ipm].[PatientMonitorID],
       CASE
           WHEN [ie].[DischargeDateTime] IS NULL THEN ''A''
           ELSE ''D''
       END AS [Status]
FROM [Intesys].[patient_monitor] AS [ipm]
    INNER JOIN [Intesys].[encounter] AS [ie]
        ON [ie].[EncounterID] = [ipm].[EncounterID]
    INNER JOIN [Intesys].[monitor] AS [im]
        ON [ipm].[MonitorID] = [im].[MonitorID]
    INNER JOIN [Intesys].[organization] AS [ORG1]
        ON ([im].[UnitOrganizationID] = [ORG1].[OrganizationID])
    INNER JOIN [Intesys].[MedicalRecordNumbermap] AS [imm]
        ON [ie].[PatientID] = [imm].[PatientID]
           AND [imm].[MergeCode] = ''C''
    INNER JOIN [Intesys].[person] AS [ipe]
        ON [ie].[PatientID] = [ipe].[PersonID]
    INNER JOIN [Intesys].[patient] AS [ipa]
        ON [ie].[PatientID] = [ipa].[PatientID]
    LEFT OUTER JOIN [Intesys].[account] AS [ia]
        ON [ie].[AccountID] = [ia].[AccountID]
    LEFT OUTER JOIN [Intesys].[organization] AS [ORG2]
        ON [ORG2].[OrganizationID] = [ORG1].[ParentOrganizationID]
 '      ;

        -- Convert * to percentile in variables
        SET @LastName = LTRIM(RTRIM(@LastName));

        SET @FirstName = LTRIM(RTRIM(@FirstName));

        SET @MedicalRecordNumberID = LTRIM(RTRIM(@MedicalRecordNumberID));

        SET @CONDITION = ISNULL(@CONDITION, N'');

        -- Unit accessibility
        IF (@IsRestrictedUnitSearchable <> N'1')
            BEGIN
                SET @CONDITION += N' [ORG1].[OrganizationID] NOT IN
      (
          SELECT [cro].[OrganizationID]
          FROM [old].[cdr_restricted_organization] AS [cro]
          WHERE [cro].[UserRoleID] =
          (
              SELECT [iu].[UserRoleID]
              FROM [Intesys].[user] AS [iu]
              WHERE [iu].[LoginName] =  N''' + @LoginName + '''
          )
      )
'               ;
            END;

        --Last name
        IF (LEN(@LastName) > 0)
            BEGIN

                SET @LastName = REPLACE(@LastName, N'*', N'%');
                SET @LastName = QUOTENAME(@LastName, N'''');

                IF (LEN(@CONDITION) > 0)
                    SET @CONDITION += N' AND ';

                SET @CONDITION += N' ([ipe].[LastName] LIKE ' + @LastName + ')';
            END;

        --First name
        IF (LEN(@FirstName) > 0)
            BEGIN

                SET @FirstName = REPLACE(@FirstName, N'*', N'%');
                SET @FirstName = QUOTENAME(@FirstName, N'''');

                IF (LEN(@CONDITION) > 0)
                    SET @CONDITION += N' AND ';

                SET @CONDITION += N' ([ipe].[FirstName] LIKE ' + @FirstName + N')';
            END;

        --/
        --IF (LEN(@PatientID) > 0)
        --BEGIN
        --    SET @PatientID = REPLACE(@PatientID, N'*', N'%')

        --    IF (LEN(@CONDITION) > 0)
        --        SET @CONDITION += N' AND '
        --    SET @CONDITION += ' (int_patient.PatientID LIKE N''' + @PatientID + N''')'
        --END 
        --/

        --MedicalRecordNumberID
        IF (LEN(@MedicalRecordNumberID) > 0)
            BEGIN
                SET @MedicalRecordNumberID = QUOTENAME(@MedicalRecordNumberID, N'''');

                SET @MedicalRecordNumberID = REPLACE(@MedicalRecordNumberID, N'\', N'\\');
                SET @MedicalRecordNumberID = REPLACE(@MedicalRecordNumberID, N'[', N'\[');
                SET @MedicalRecordNumberID = REPLACE(@MedicalRecordNumberID, N']', N'\]');
                SET @MedicalRecordNumberID = REPLACE(@MedicalRecordNumberID, N'_', N'\_');
                SET @MedicalRecordNumberID = REPLACE(@MedicalRecordNumberID, N'%', N'\%');
                SET @MedicalRecordNumberID = REPLACE(@MedicalRecordNumberID, N'^', N'\^');
                SET @MedicalRecordNumberID = REPLACE(@MedicalRecordNumberID, N'*', N'%');

                IF (LEN(@CONDITION) > 0)
                    SET @CONDITION += N' AND ';

                SET @CONDITION += N' ([imm].[MedicalRecordNumberXID] LIKE ' + @MedicalRecordNumberID
                                  + N' ESCAPE ''\'')';
            END;

        --Check for VIP Patient
        IF (@IsVipSearchable <> N'1')
            BEGIN
                IF (LEN(@CONDITION) > 0)
                    BEGIN
                        SET @CONDITION += N' AND ';
                    END;

                SET @CONDITION += N'[ie].[vipSwitch] IS NULL';
            END;

        --Add condition
        IF (LEN(@CONDITION) > 0)
            BEGIN
                SET @SqlQuery += N' WHERE ';
                SET @SqlQuery += @CONDITION;
            END;

        -- Add a separate query for dataloader patients
        SET @SqlQuery += N'

UNION

SELECT [vsp].[PatientID],
       [vsp].[patient_name],
       [vsp].[MonitorName],
       [vsp].[AccountID],
       [vsp].[MedicalRecordNumberID],
       [vsp].[UnitID],
       [vsp].[UNIT_NAME],
       [vsp].[FacilityID],
       [vsp].[FACILITY_NAME],
       [vsp].[DateOfBirth],
       [vsp].[AdmitTime],
       [vsp].[DischargedTime],
       [vsp].[AdmitTime] AS [PRECEDENCE],
       [vsp].[PatientMonitorID],
       [vsp].[Status]
FROM [old].[vwStitchedPatients] AS [vsp]
'       ;

        SET @CONDITION = N'';

        --Unit accessibility
        IF (@IsRestrictedUnitSearchable <> N'1')
            BEGIN
                SET @CONDITION += N' [vsp].[UnitID] NOT IN
          (
              SELECT [cro].[OrganizationID]
              FROM [old].[cdr_restricted_organization] AS [cro]
              WHERE [cro].[UserRoleID] =
              (
                  SELECT [iu].[UserRoleID]
                  FROM [Intesys].[user] AS [iu]
                  WHERE [iu].[LoginName] = N''' + @LoginName + N'''))';
            END;

        --Last name
        IF (LEN(@LastName) > 0)
            BEGIN

                IF (LEN(@CONDITION) > 0)
                    SET @CONDITION += N' AND ';

                SET @CONDITION += N' (LTRIM(RTRIM([vsp].[LAST_NAME])) LIKE ' + @LastName + N')';
            END;

        --First name
        IF (LEN(@FirstName) > 0)
            BEGIN

                IF (LEN(@CONDITION) > 0)
                    SET @CONDITION += N' AND ';

                SET @CONDITION += N' (LTRIM(RTRIM([vsp].[FIRST_NAME])) LIKE ' + @FirstName + N')';
            END;

        --MedicalRecordNumberID
        IF (LEN(@MedicalRecordNumberID) > 0)
            BEGIN

                IF (LEN(@CONDITION) > 0)
                    SET @CONDITION += N' AND ';

                SET @CONDITION += N' (LTRIM(RTRIM([vsp].[MedicalRecordNumberID])) LIKE ' + @MedicalRecordNumberID
                                  + N' ESCAPE ''\'')';
            END;

        --Add condition
        IF (LEN(@CONDITION) > 0)
            BEGIN
                SET @SqlQuery += N' WHERE [vsp].[PatientID] IS NOT NULL AND ';
                SET @SqlQuery += @CONDITION;
            END;

        SET @SqlQuery += N'
ORDER BY [AdmitTime] DESC,
         [PRECEDENCE] DESC,
         [Status],
         [patient_name],
         [MonitorName];
'       ;

        IF (@Debug = 1)
            PRINT @SqlQuery;

        EXEC (@SqlQuery);
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Search for patients by last name, first name, medical record number (MRN), VIP status and restricted unit.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetPatientsBySearch';

