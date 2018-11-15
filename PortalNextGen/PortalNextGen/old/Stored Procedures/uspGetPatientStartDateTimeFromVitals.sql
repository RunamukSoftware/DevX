CREATE PROCEDURE [old].[uspGetPatientStartDateTimeFromVitals] (@PatientID INT)
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            MIN([StartDateTime].[StartDateTime]) AS [StartDateTime]
        FROM
            (
                SELECT
                    MIN([ir].[ResultDateTime]) AS [StartDateTime]
                FROM
                    [Intesys].[Result] AS [ir]
                WHERE
                    [ir].[PatientID] = @PatientID
                UNION ALL
                SELECT
                    MIN([vd].[Timestamp]) AS [StartDateTime]
                FROM
                    [old].[Vital] AS [vd]
                WHERE
                    [vd].[TopicSessionID] IN (
                                                 SELECT
                                                     [vpts].[TopicSessionID]
                                                 FROM
                                                     [old].[vwPatientTopicSessions] AS [vpts]
                                                 WHERE
                                                     [vpts].[PatientID] = @PatientID
                                             )
            ) AS [StartDateTime];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetPatientStartDateTimeFromVitals';

