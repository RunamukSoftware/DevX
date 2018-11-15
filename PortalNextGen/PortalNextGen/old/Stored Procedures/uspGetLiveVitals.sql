CREATE PROCEDURE [old].[uspGetLiveVitals]
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [vlvd].[Name],
            [vlvd].[ResultValue],
            [vlvd].[GlobalDataSystemCode],
            [imc].[KeystoneCode]          AS [UnitOfMeasure],
            [imc].[ShortDescription],
            [vlvd].[PatientID],
            [vps].[MedicalRecordNumberID] AS [ID1],
            [vps].[AccountID]             AS [ID2],
            [vps].[UnitCode]              AS [OrganizationCode],
            [vps].[MonitorName],
            [vps].[MonitorName]           AS [NodeID]
        FROM
            [old].[vwLiveVitalsData]          AS [vlvd]
            INNER JOIN
                (
                    SELECT
                        [vlvd].[TopicInstanceID],
                        MAX([vlvd].[DateTimeStamp]) AS [MaxVitalTime]
                    FROM
                        [old].[vwLiveVitalsData] AS [vlvd]
                    GROUP BY
                        [vlvd].[TopicInstanceID]
                )                             AS [MaxLiveVital]
                    ON [MaxLiveVital].[TopicInstanceID] = [vlvd].[TopicInstanceID]
                       AND [MaxLiveVital].[MaxVitalTime] = [vlvd].[DateTimeStamp]
            LEFT OUTER JOIN
                [old].[vwPatientSessions]     AS [vps]
                    ON [vps].[PatientID] = [vlvd].[PatientID]
            INNER JOIN
                [Intesys].[MiscellaneousCode] AS [imc]
                    ON [imc].[Code] = [vlvd].[GlobalDataSystemCode]
        WHERE
            [vlvd].[GlobalDataSystemCode] IS NOT NULL
            AND [imc].[MethodCode] = N'GDS';
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetLiveVitals';

