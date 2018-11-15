CREATE FUNCTION [old].[ufnHL7GetPatientIDFromQueryItemType]
    (
        @QueryItem NVARCHAR(80),
        @QueryType INT
    )
RETURNS INT
WITH SCHEMABINDING
AS
    BEGIN
        DECLARE @PatientID INT;

        IF (@QueryType = 0)
            BEGIN
                SELECT
                    @PatientID = [PatientID].[PatientID]
                FROM
                    (
                        --SELECT [imm].[PatientID] AS [PatientID]
                        --FROM [Intesys].[MedicalRecordNumbermap] AS [imm]
                        --    INNER JOIN [Intesys].[patient_monitor] AS [PATMON]
                        --        ON [PATMON].[PatientID] = [imm].[PatientID]
                        --    INNER JOIN [Intesys].[monitor] AS [MONITOR]
                        --        ON [MONITOR].[MonitorID] = [PATMON].[MonitorID]
                        --    INNER JOIN [Intesys].[product_access] AS [ACCESS]
                        --        ON [ACCESS].[OrganizationID] = [MONITOR].[UnitOrganizationID]
                        --    INNER JOIN [Intesys].[organization] AS [ORG]
                        --        ON [ORG].[OrganizationID] = [MONITOR].[UnitOrganizationID]
                        --WHERE [imm].[MedicalRecordNumberXID] = @QueryItem
                        --      AND [MergeCode] = 'C'
                        --      AND [ACCESS].[productCode] = 'outHL7'
                        --      AND [ORG].[CategoryCode] = 'D'
                        --UNION
                        SELECT
                            [DLPAT].[PatientID] AS [PatientID]
                        FROM
                            [old].[vwPatientSessions]     AS [DLPAT]
                            INNER JOIN
                                [Intesys].[ProductAccess] AS [Access]
                                    ON [Access].[OrganizationID] = [DLPAT].[UnitID]
                            INNER JOIN
                                [Intesys].[Organization]  AS [ORG]
                                    ON [ORG].[OrganizationID] = [DLPAT].[UnitID]
                        WHERE
                            [DLPAT].[MedicalRecordNumberID] = @QueryItem
                            AND [Access].[ProductCode] = 'outHL7'
                            AND [ORG].[CategoryCode] = 'D'
                    ) AS [PatientID];
            END;

        IF (@QueryType = 1)
            BEGIN

                SELECT
                    @PatientID = [PatientID].[PatientID]
                FROM
                    (
                        --SELECT [imm].[PatientID] AS [PatientID]
                        --FROM [Intesys].[MedicalRecordNumbermap] AS [imm]
                        --    INNER JOIN [Intesys].[patient_monitor] AS [PATMON]
                        --        ON [PATMON].[PatientID] = [imm].[PatientID]
                        --    INNER JOIN [Intesys].[monitor] AS [MONITOR]
                        --        ON [MONITOR].[MonitorID] = [PATMON].[MonitorID]
                        --    INNER JOIN [Intesys].[product_access] AS [ACCESS]
                        --        ON [ACCESS].[OrganizationID] = [MONITOR].[UnitOrganizationID]
                        --    INNER JOIN [Intesys].[organization] AS [ORG]
                        --        ON [ORG].[OrganizationID] = [MONITOR].[UnitOrganizationID]
                        --WHERE [imm].[MedicalRecordNumberXID2] = @QueryItem
                        --      AND [MergeCode] = 'C'
                        --      AND [ACCESS].[productCode] = 'outHL7'
                        --      AND [ORG].[CategoryCode] = 'D'
                        --UNION
                        SELECT
                            [DLPAT].[PatientID] AS [PatientID]
                        FROM
                            [old].[vwPatientSessions]     AS [DLPAT]
                            INNER JOIN
                                [Intesys].[ProductAccess] AS [ACCESS]
                                    ON [ACCESS].[OrganizationID] = [DLPAT].[UnitID]
                            INNER JOIN
                                [Intesys].[Organization]  AS [ORG]
                                    ON [ORG].[OrganizationID] = [DLPAT].[UnitID]
                        WHERE
                            [DLPAT].[AccountID] = @QueryItem
                            AND [ACCESS].[ProductCode] = 'outHL7'
                            AND [ORG].[CategoryCode] = 'D'
                    ) AS [PatientID];
            END;

        IF (@QueryType = 2)
            BEGIN
                SELECT
                    @PatientID = [PatientID].[PatientID]
                FROM
                    (
                        --SELECT [imm].[PatientID] AS [PatientID]
                        --FROM [Intesys].[MedicalRecordNumbermap] AS [imm]
                        --    INNER JOIN [Intesys].[patient_monitor] AS [PATMON]
                        --        ON [PATMON].[PatientID] = [imm].[PatientID]
                        --    INNER JOIN [Intesys].[monitor] AS [MONITOR]
                        --        ON [MONITOR].[MonitorID] = [PATMON].[MonitorID]
                        --    INNER JOIN [Intesys].[product_access] AS [ACCESS]
                        --        ON [ACCESS].[OrganizationID] = [MONITOR].[UnitOrganizationID]
                        --    INNER JOIN [Intesys].[organization] AS [ORG]
                        --        ON [ORG].[OrganizationID] = [MONITOR].[UnitOrganizationID]
                        --WHERE [MONITOR].[NodeID] = @QueryItem
                        --      AND [PATMON].[ActiveSwitch] = 1
                        --      AND [MergeCode] = 'C'
                        --      AND [ORG].[OrganizationID] = [MONITOR].[UnitOrganizationID]
                        --      AND [ACCESS].[productCode] = 'outHL7'
                        --      AND [ORG].[CategoryCode] = 'D'
                        --UNION
                        SELECT
                            [DLPAT].[PatientID] AS [PatientID]
                        FROM
                            [old].[vwPatientSessions]     AS [DLPAT]
                            INNER JOIN
                                [Intesys].[ProductAccess] AS [ACCESS]
                                    ON [ACCESS].[OrganizationID] = [DLPAT].[UnitID]
                            INNER JOIN
                                [old].[Device]            AS [DEV]
                                    ON [DEV].[DeviceID] = [DLPAT].[PatientMonitorID]
                            INNER JOIN
                                [Intesys].[Organization]  AS [ORG]
                                    ON [ORG].[OrganizationID] = [DLPAT].[UnitID]
                        WHERE
                            [DEV].[Name] = @QueryItem
                            AND [DLPAT].[Status] = 'A'
                            AND [ACCESS].[ProductCode] = 'outHL7'
                            AND [ORG].[CategoryCode] = 'D'
                    ) AS [PatientID];
            END;

        IF (@QueryType = 3)
            BEGIN
                SELECT
                    @PatientID = [PatientID].[PatientID]
                FROM
                    (
                        --SELECT [imm].[PatientID] AS [PatientID]
                        --FROM [Intesys].[MedicalRecordNumbermap] AS [imm]
                        --    INNER JOIN [Intesys].[patient_monitor] AS [PATMON]
                        --        ON [PATMON].[PatientID] = [imm].[PatientID]
                        --    INNER JOIN [Intesys].[monitor] AS [MONITOR]
                        --        ON [MONITOR].[MonitorID] = [PATMON].[MonitorID]
                        --    INNER JOIN [Intesys].[product_access] AS [ACCESS]
                        --        ON [ACCESS].[OrganizationID] = [MONITOR].[UnitOrganizationID]
                        --    INNER JOIN [Intesys].[organization] AS [ORG]
                        --        ON [ORG].[OrganizationID] = [MONITOR].[UnitOrganizationID]
                        --WHERE [MONITOR].[MonitorName] = @QueryItem
                        --      AND [PATMON].[ActiveSwitch] = 1
                        --      AND [MergeCode] = 'C'
                        --      AND [ORG].[OrganizationID] = [MONITOR].[UnitOrganizationID]
                        --      AND [ACCESS].[productCode] = 'outHL7'
                        --      AND [ORG].[CategoryCode] = 'D'
                        --UNION
                        SELECT
                            [DLPAT].[PatientID] AS [PatientID]
                        FROM
                            [old].[vwPatientSessions]     AS [DLPAT]
                            INNER JOIN
                                [Intesys].[ProductAccess] AS [ACCESS]
                                    ON [ACCESS].[OrganizationID] = [DLPAT].[UnitID]
                            INNER JOIN
                                [old].[Device]            AS [DEV]
                                    ON [DEV].[DeviceID] = [DLPAT].[DeviceID]
                            INNER JOIN
                                [Intesys].[Organization]  AS [ORG]
                                    ON [ORG].[OrganizationID] = [DLPAT].[UnitID]
                        WHERE
                            [DLPAT].[Bed] = @QueryItem
                            AND [DLPAT].[Status] = 'A'
                            AND [ACCESS].[ProductCode] = 'outHL7'
                            AND [ORG].[CategoryCode] = 'D'
                    ) AS [PatientID];
            END;

        RETURN @PatientID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'To get the patient details inserted from ADTA01 FOR QRY - HL7 BEGIN - Retrieves the patient ID from given query item Type (MRN, ACC, NODE ID or NODE NAME)', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'FUNCTION', @level1name = N'ufnHL7GetPatientIDFromQueryItemType';

