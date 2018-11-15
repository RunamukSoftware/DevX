CREATE PROCEDURE [old].[uspGetMinMaxPatientTimesFromVitals]
    (
        @PatientID INT,
        @GetAll    BIT = 1
    )
AS
    BEGIN
        SET NOCOUNT ON;

        IF (@GetAll = 0)
            BEGIN
                SELECT
                    MIN([ir].[ResultDateTime]) AS [StartDateTime],
                    MAX([ir].[ResultDateTime]) AS [EndDateTime],
                    MIN([ir].[ResultDateTime]) AS [StartDateTime],
                    MAX([ir].[ResultDateTime]) AS [EndDateTime]
                FROM
                    [Intesys].[Result] AS [ir]
                WHERE
                    [ir].[PatientID] = @PatientID;
            END;
        ELSE
            BEGIN
                SELECT
                    MIN([ComboVitals].[StartDateTime]) AS [StartDateTime],
                    MAX([ComboVitals].[EndDateTime])   AS [EndDateTime]
                FROM
                    (
                        SELECT
                            MIN([vd].[Timestamp]) AS [StartDateTime],
                            MAX([vd].[Timestamp]) AS [EndDateTime]
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
                        UNION ALL
                        SELECT
                            MIN([RowNumber].[ResultDateTime]) AS [StartDateTime],
                            MAX([RowNumber].[ResultDateTime]) AS [EndDateTime]
                        FROM
                            [Intesys].[Result] AS [RowNumber]
                        WHERE
                            [RowNumber].[PatientID] = @PatientID
                    ) AS [ComboVitals];
            END;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetMinMaxPatientTimesFromVitals';

