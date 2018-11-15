CREATE PROCEDURE [Archive].[uspInsurancePolicies]
    (
        @PatientID INT,
        @AccountID INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        -- Select insurance info
        SELECT DISTINCT
            [i].[CobPriority]               AS [Priority],
            [p].[PlanXID]                   AS [PlanNumber],
            [i].[InsurancePolicyXID]        AS [PolicyNumber],
            [i].[GroupXID]                  AS [GroupNumber],
            [i].[SequenceNumber],
            CAST(SPACE(50) AS NVARCHAR(50)) AS [LastName],
            CAST(SPACE(50) AS NVARCHAR(50)) AS [FirstName],
            CAST(SPACE(50) AS NVARCHAR(50)) AS [MiddleName],
            [i].[HolderRelationshipCodeID],
            [i].[HolderID],
            SPACE(50)                       AS [Carrier],
            [p].[InsuranceCompanyID]        AS [ExternalOrganizationID]
        INTO
            [#Insurance1]
        FROM
            [Archive].[InsurancePolicy]   AS [i]
            INNER JOIN
                [Archive].[InsurancePlan] AS [p]
                    ON [i].[InsurancePlanID] = [p].[InsurancePlanID]
        WHERE
            [i].[PatientID] = @PatientID
            AND [i].[AccountID] = @AccountID
        ORDER BY
            [i].[CobPriority];

        -- Update ExternalOrganization
        UPDATE
            [#Insurance1]
        SET
            [Carrier] = [e].[OrganizationName]
        FROM
            [#Insurance1]                        AS [i]
            INNER JOIN
                [Intesys].[ExternalOrganization] AS [e]
                    ON [i].[ExternalOrganizationID] = [e].[ExternalOrganizationID];

        -- Update from person_name
        UPDATE
            [#Insurance1]
        SET
            [LastName] = ISNULL([pn].[LastName], N''),
            [MiddleName] = ISNULL([pn].[MiddleName], N''),
            [FirstName] = ISNULL([pn].[FirstName], N'')
        FROM
            [#Insurance1]
            INNER JOIN
                [Intesys].[PersonName] AS [pn]
                    ON [HolderID] = [pn].[PersonNameID]
        WHERE
            [pn].[RecognizeNameCode] = 'P'
            AND [pn].[ActiveSwitch] = 1;

        -- Contact person address
        SELECT
            [i].[LastName],
            [i].[FirstName],
            [i].[MiddleName],
            [i].[Carrier],
            [a].[Line1Description],
            [a].[Line2Description],
            [a].[Line3Description],
            [a].[City],
            [a].[StateCode],
            [a].[PostalCode],
            [a].[CountryCodeID],
            SPACE(14)         AS [TelephoneNumber],
            CAST(NULL AS INT) AS [ContactID]
        INTO
            [#Insurance2]
        FROM
            [#Insurance1]           AS [i]
            RIGHT OUTER JOIN
                [Intesys].[Address] AS [a]
                    ON [i].[ExternalOrganizationID] = [a].[AddressID];

        -- Phone
        UPDATE
            [#Insurance2]
        SET
            [TelephoneNumber] = [t].[TelephoneNumber]
        FROM
            [#Insurance2]             AS [i]
            INNER JOIN
                [Intesys].[Telephone] AS [t]
                    ON [i].[ExternalOrganizationID] = [t].[PhoneID]
        WHERE
            [t].[PhoneLocationCode] = 'B'
            AND [t].[PhoneTypeCode] = 'V'
            AND [t].[SequenceNumber] =
                (
                    SELECT
                        MIN([t2].[SequenceNumber])
                    FROM
                        [Intesys].[Telephone] AS [t2]
                    WHERE
                        [t].[PhoneID] = [t2].[PhoneID]
                        AND [t2].[PhoneLocationCode] = 'B'
                        AND [t2].[PhoneTypeCode] = 'V'
                );

        -- Contact person
        UPDATE
            [#Insurance2]
        SET
            [ContactID] = [ip].[InsuranceContactID]
        FROM
            [#Insurance2]                   AS [i]
            INNER JOIN
                [Archive].[InsurancePolicy] AS [ip]
                    ON [ip].[SequenceNumber] = [i].[SequenceNumber]
        WHERE
            [ip].[PatientID] = @PatientID
            AND [ip].[ActiveSwitch] = 1;

        SELECT
            [i].[Carrier],
            [i].[MiddleName],
            [i].[FirstName],
            [i].[LastName],
            [i].[TelephoneNumber],
            [i].[ContactID],
            [pn].[LastName]   AS [CO_LastName],
            [pn].[FirstName]  AS [CO_FirstName],
            [pn].[MiddleName] AS [CO_MiddleName]
        FROM
            [Intesys].[PersonName] AS [pn]
            RIGHT OUTER JOIN
                [#Insurance2]      AS [i]
                    ON [i].[ContactID] = [pn].[PersonNameID]
        WHERE
            [pn].[RecognizeNameCode] = 'P'
            AND [pn].[ActiveSwitch] = 1
        ORDER BY
            [priority];

        DROP TABLE [#Insurance1];

        DROP TABLE [#Insurance2];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'Archive', @level1type = N'PROCEDURE', @level1name = N'uspInsurancePolicies';

