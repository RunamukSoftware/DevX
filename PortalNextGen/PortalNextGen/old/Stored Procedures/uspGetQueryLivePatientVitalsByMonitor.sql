CREATE PROCEDURE [old].[uspGetQueryLivePatientVitalsByMonitor]
    (
        @PatientID    INT,
        @MonitorID AS INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        -- Create the equivalent date time to (GETDATE( ) - 0.002)
        DECLARE @LowerTimeLimit DATETIME2(7) = DATEADD(MILLISECOND, -172800, SYSUTCDATETIME());

        SELECT DISTINCT
            [VL].[PatientID],
            [VL].[MonitorID],
            [VL].[CollectionDateTime],
            [VL].[VitalValue],
            [VL].[VitalTime],
            [imrnm].[OrganizationID],
            [imrnm].[MedicalRecordNumberXID] AS [MedicalRecordNumber]
        FROM
            [Intesys].[VitalLiveTemporary]              AS [VL]
            INNER JOIN
                [Intesys].[MedicalRecordNumberMap] AS [imrnm]
                    ON [VL].[PatientID] = [imrnm].[PatientID]
            INNER JOIN
                [Intesys].[PatientMonitor]         AS [PM]
                    ON [PM].[PatientID] = [VL].[PatientID]
        WHERE
            (
                @PatientID = CAST('00000000-0000-0000-0000-000000000000' AS INT)
                OR [VL].[PatientID] = @PatientID
            )
            AND [imrnm].[MergeCode] = 'C'
            AND [PM].[MonitorID] = @MonitorID
            AND [VL].[CreatedDateTime] =
                (
                    SELECT
                        MAX([VL_SUBTAB].[CreatedDateTime])
                    FROM
                        [Intesys].[VitalLiveTemporary] AS [VL_SUBTAB]
                    WHERE
                        [VL_SUBTAB].[MonitorID] = @MonitorID
                        AND [VL_SUBTAB].[PatientID] = [VL].[PatientID]
                        AND [VL_SUBTAB].[CreatedDateTime] > @LowerTimeLimit
                );
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get Live Patient Vitals By Monitor', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetQueryLivePatientVitalsByMonitor';

