CREATE PROCEDURE [old].[uspEncounterDetailDrs] (@EncounterID INT)
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE
            @AttHealthCareProviderID INT,
            @RefHealthCareProviderID INT,
            @AdmHealthCareProviderID INT;

        CREATE TABLE [#EncounterDetail]
            (
                [HealthCareProviderID] INT,
                [Priority]             INT,
                [LastName]             NVARCHAR(50) NULL,
                [FirstName]            NVARCHAR(50) NULL,
                [MiddleName]           NVARCHAR(50) NULL,
                [RoleCode]             NCHAR(1)
            );

        SELECT
            @AttHealthCareProviderID = [ie].[AttendHealthCareProviderID],
            @RefHealthCareProviderID = [ie].[ReferringHealthCareProviderID],
            @AdmHealthCareProviderID = [ie].[AdmitHealthCareProviderID]
        FROM
            [Intesys].[Encounter] AS [ie]
        WHERE
            [ie].[EncounterID] = @EncounterID;

        -- Attending
        IF (@AttHealthCareProviderID IS NOT NULL)
            BEGIN
                INSERT INTO [#EncounterDetail]
                    (
                        [HealthCareProviderID],
                        [Priority],
                        [LastName],
                        [FirstName],
                        [MiddleName],
                        [RoleCode]
                    )
                            SELECT
                                @AttHealthCareProviderID,
                                1,
                                [H].[LastName],
                                [H].[FirstName],
                                [H].[MiddleName],
                                N'T'
                            FROM
                                [Intesys].[HealthCareProvider] AS [H]
                            WHERE
                                [H].[HealthCareProviderID] = @AttHealthCareProviderID;
            END;

        -- Admitting
        IF (@AdmHealthCareProviderID IS NOT NULL)
            BEGIN
                INSERT INTO [#EncounterDetail]
                    (
                        [HealthCareProviderID],
                        [Priority],
                        [LastName],
                        [FirstName],
                        [MiddleName],
                        [RoleCode]
                    )
                            SELECT
                                @AdmHealthCareProviderID,
                                1,
                                [H].[LastName],
                                [H].[FirstName],
                                [H].[MiddleName],
                                N'A'
                            FROM
                                [Intesys].[HealthCareProvider] AS [H]
                            WHERE
                                [H].[HealthCareProviderID] = @AdmHealthCareProviderID;
            END;

        -- Referring
        IF (@RefHealthCareProviderID IS NOT NULL)
            BEGIN
                INSERT INTO [#EncounterDetail]
                    (
                        [HealthCareProviderID],
                        [Priority],
                        [LastName],
                        [FirstName],
                        [MiddleName],
                        [RoleCode]
                    )
                            SELECT
                                @RefHealthCareProviderID,
                                2,
                                [H].[LastName],
                                [H].[FirstName],
                                [H].[MiddleName],
                                N'R'
                            FROM
                                [Intesys].[HealthCareProvider] AS [H]
                            WHERE
                                [H].[HealthCareProviderID] = @RefHealthCareProviderID;
            END;

        -- Consulting docs
        INSERT INTO [#EncounterDetail]
            (
                [HealthCareProviderID],
                [Priority],
                [LastName],
                [FirstName],
                [MiddleName],
                [RoleCode]
            )
                    SELECT DISTINCT
                        ([e].[HealthCareProviderID]),
                        3,
                        [H].[LastName],
                        [H].[FirstName],
                        [H].[MiddleName],
                        [e].[HealthCareProviderRoleCode]
                    FROM
                        [Intesys].[EncounterToDiagnosisHealthCareProviderInt] AS [e]
                        INNER JOIN
                            [Intesys].[HealthCareProvider]                    AS [H]
                                ON [e].[HealthCareProviderID] = [H].[HealthCareProviderID]
                    WHERE
                        [e].[HealthCareProviderRoleCode] = N'C'
                        AND [e].[EncounterID] = @EncounterID;

        -- Select out data
        SELECT
            [RoleCode],
            [LastName],
            [FirstName],
            [MiddleName]
        FROM
            [#EncounterDetail]
        ORDER BY
            [Priority],
            [LastName];

        DROP TABLE [#EncounterDetail];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspEncounterDetailDrs';

