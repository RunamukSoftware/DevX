CREATE PROCEDURE [Archive].[uspInsuranceGuarantor]
    (
        @PatientID   INT,
        @EncounterID INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

    --DECLARE
    --    @AccountID INT,
    --    @GuarantorPersonID INT,
    --    @GuarantorLastName VARCHAR(50),
    --    @GuarantorFirstName VARCHAR(50),
    --    @gu_mname VARCHAR(50),
    --    @pat_rel VARCHAR(30),
    --    @pat_relID INT,
    --    @gu_addr1 VARCHAR(50),
    --    @gu_addr2 VARCHAR(50),
    --    @gu_addr3 VARCHAR(50),
    --    @gu_city VARCHAR(25),
    --    @gu_state CHAR(3),
    --    @gu_zip CHAR(10),
    --    @gu_country_codeID INT,
    --    @gu_home_ph CHAR(40),
    --    @gu_home_ext CHAR(12),
    --    @gu_work_ph CHAR(40),
    --    @gu_work_ext CHAR(12),
    --    @gu_emer_ph CHAR(40),
    --    @gu_emer_ext CHAR(5),
    --    @EmployerID INT,
    --    @Employernm VARCHAR(50),
    --    @Employeraddr1 VARCHAR(50),
    --    @Employeraddr2 VARCHAR(50),
    --    @Employeraddr3 VARCHAR(50),
    --    @Employercity VARCHAR(25),
    --    @Employerstate CHAR(3),
    --    @Employerzip CHAR(10),
    --    @Employercountry_codeID INT,
    --    @Employerwork_ph CHAR(40),
    --    @Employerwork_ext CHAR(5),
    --    @EmployerEmer_ph CHAR(40),
    --    @EmployerEmer_ext CHAR(5),
    --    @SequenceNumber INT;

    ----Look up the acctID in the encounter
    --SELECT
    --    @AccountID = [AccountID]
    --FROM
    --    [Intesys].[encounter]
    --WHERE
    --    [PatientID] = @PatientID
    --    AND [EncounterID] = @EncounterID;

    ----Look up the latest desc_key for this account
    --SELECT
    --    @SequenceNumber = MAX([SequenceNumber])
    --FROM
    --    [Intesys].[guarantor]
    --WHERE
    --    [PatientID] = @PatientID
    --    AND [EncounterID] = @EncounterID
    --    AND [ActiveSwitch] = 1;

    --SELECT
    --    @GuarantorPersonID = [ig].[GuarantorPersonID],
    --    @EmployerID = [ig].[EmployerID]
    --FROM
    --    [Intesys].[guarantor] AS [ig]
    --WHERE
    --    [ig].[PatientID] = @PatientID
    --    AND [ig].[EncounterID] = @EncounterID
    --    AND [ig].[SequenceNumber] = @SequenceNumber;

    --SELECT
    --    @pat_rel = [imc].[ShortDescription],
    --    @pat_relID = [ig].[RelationshipCodeID]
    --FROM
    --    [Intesys].[guarantor] AS [ig],
    --    [Intesys].[misc_code] AS [imc]
    --WHERE
    --    [ig].[PatientID] = @PatientID
    --    AND ([ig].[EncounterID] = @EncounterID
    --    OR [ig].[EncounterID] IS NULL
    --    )
    --    AND [ig].[GuarantorPersonID] = @guID
    --    AND [ig].[RelationshipCodeID] = [imc].[CodeID];

    --IF (@pat_relID = NULL)
    --BEGIN
    --    SELECT
    --        @pat_rel = [imc].[ShortDescription],
    --        @pat_relID = [ig].[RelationshipCodeID]
    --    FROM
    --        [Intesys].[guarantor] AS [ig],
    --        [Intesys].[misc_code] AS [imc]
    --    WHERE
    --        [ig].[PatientID] = @PatientID
    --        AND ([ig].[EncounterID] = @EncounterID
    --        OR [ig].[EncounterID] IS NULL
    --        )
    --        AND [ig].[companyID] = @guID
    --        AND [ig].[RelationshipCodeID] = [imc].[CodeID];
    --END;

    --SELECT
    --    @GuarantorLastName = [LastName],
    --    @GuarantorFirstName = [FirstName],
    --    @gu_mname = [MiddleName]
    --FROM
    --    [Intesys].[person_name]
    --WHERE
    --    [PersonNameID] = @guID
    --    AND [RecognizeNameCode] = 'P'
    --    AND [ActiveSwitch] = 1;

    ----Use the entID of the guarantor as the key to get the
    ----address from the address table
    --SELECT
    --    @gu_addr1 = [Line1Description],
    --    @gu_addr2 = [Line2Description],
    --    @gu_addr3 = [Line3Description],
    --    @gu_city = [City],
    --    @gu_state = [StateCode],
    --    @gu_zip = [PostalCode],
    --    @gu_country_codeID = [CountryCodeID]
    --FROM
    --    [Intesys].[address]
    --WHERE
    --    [AddressID] = @guID;

    --SELECT
    --    @Employeraddr1 = [a].[Line1Description],
    --    @Employeraddr2 = [a].[Line2Description],
    --    @Employeraddr3 = [a].[Line3Description],
    --    @Employercity = [a].[City],
    --    @Employerstate = [a].[StateCode],
    --    @Employerzip = [a].[PostalCode],
    --    @Employercountry_codeID = [a].[CountryCodeID]
    --FROM
    --    [Intesys].[address] AS [a]
    --WHERE
    --    [a].[AddressID] = @EmployerID
    --    AND [a].[AddressTypeCode] = N'M';

    --SELECT
    --    @Employernm = [OrganizationName]
    --FROM
    --    [Intesys].[external_organization]
    --WHERE
    --    [ExternalOrganizationID] = @EmployerID;

    ----Look up the guarantor's home phone number
    --SELECT
    --    @gu_home_ph = [telNumber],
    --    @gu_home_ext = [extNumber]
    --FROM
    --    [Intesys].[telephone]
    --WHERE
    --    @guID = [phoneID]
    --    AND [phone_locCode] = 'R'
    --    AND [phone_typeCode] = 'V'
    --ORDER BY
    --    [SequenceNumber] DESC; /* the one with min SequenceNumber */

    ----Look up the guarantor's work phone number
    --SELECT
    --    @gu_work_ph = [telNumber],
    --    @gu_work_ext = [extNumber]
    --FROM
    --    [Intesys].[telephone]
    --WHERE
    --    @guID = [phoneID]
    --    AND [phone_locCode] = 'B'
    --    AND [phone_typeCode] = 'V'
    --ORDER BY
    --    [SequenceNumber] DESC; /* the one with min SequenceNumber*/

    ----Look up the guarantor's emergency home phone number
    --SELECT
    --    @gu_emer_ph = [telNumber],
    --    @gu_emer_ext = [extNumber]
    --FROM
    --    [Intesys].[telephone]
    --WHERE
    --    @guID = [phoneID]
    --    AND [phone_locCode] = 'E'
    --    AND [phone_typeCode] = 'V'
    --ORDER BY
    --    [SequenceNumber] DESC; /* the one with min SequenceNumber */

    ----Look up the employer's work phone number
    --SELECT
    --    @EmployerWork_ph = [telNumber],
    --    @EmployerWork_ext = [extNumber]
    --FROM
    --    [Intesys].[telephone]
    --WHERE
    --    @EmployerID = [phoneID]
    --    AND [phone_locCode] = 'B'
    --    AND [phone_typeCode] = 'V'
    --ORDER BY
    --    [SequenceNumber] DESC; /* the one with min SequenceNumber */

    ----Look up the employer's emergency work phone number
    --SELECT
    --    @Employeremer_ph = [telNumber],
    --    @Employeremer_ext = [extNumber]
    --FROM
    --    [Intesys].[telephone]
    --WHERE
    --    @EmployerID = [phoneID]
    --    AND [phone_locCode] = 'M'
    --    AND [phone_typeCode] = 'V'
    --ORDER BY
    --    [SequenceNumber] DESC; /* the one with min SequenceNumber */

    --SELECT
    --    @GUID AS [GUID],
    --    @GuarantorLastName AS [LastName],
    --    @GuarantorFirstName AS [FirstName],
    --    @gu_mname AS [MiddleName],
    --    @pat_rel AS [Relation],
    --    @pat_relID AS [RelationCodeID],
    --    @gu_addr1 AS [Address1],
    --    @gu_addr2 AS [Address2],
    --    @gu_addr3 AS [Address3],
    --    @gu_city AS [City],
    --    @gu_state AS [State],
    --    @gu_zip AS [PostalCode],
    --    @gu_country_codeID AS [CountryCodeID],
    --    @gu_home_ph AS [HomePhone],
    --    @gu_home_ext AS [HomeExtension],
    --    @gu_work_ph AS [WorkPhone],
    --    @gu_work_ext AS [WorkExtension],
    --    @gu_emer_ph AS [EmrPhone],
    --    @gu_emer_ext AS [EmrExtension],
    --    @EmployerID AS [EmployeeeID],
    --    @Employernm AS [EmployeeName],
    --    @Employeraddr1 AS [EmployeeAddress1],
    --    @Employeraddr2 AS [EmployeeAddress2],
    --    @Employeraddr3 AS [EmployeeAddress3],
    --    @Employercity AS [EmployeeCity],
    --    @Employerstate AS [EmployeeState],
    --    @Employerzip AS [EmployeePostalCode],
    --    @Employercountry_codeID AS [EmployeeCountryCodeID],
    --    @EmployerWork_ph AS [EmployeePhone],
    --    @EmployerWork_ext AS [EmployeeExtension],
    --    @EmployerEmer_ph AS [EmployeeEmrPhone],
    --    @EmployerEmer_ext AS [EmployeeEMRExtension];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'Archive', @level1type = N'PROCEDURE', @level1name = N'uspInsuranceGuarantor';

