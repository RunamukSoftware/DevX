CREATE PROCEDURE [ClinicalAccess].[uspGetPrintJobsListByPatientIDAndStartAndEndDateTime]
    (
        @PatientID     INT,
        @StartDateTime DATETIME2(7)
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [ipj].[PrintJobID],
            [ipj].[Description],
            [ipj].[RecordingTime],
            [ipj].[JobNetDateTime],
            [ipj].[JobType],
            [ipj].[PageNumber]
        FROM
            [Intesys].[PrintJob] AS [ipj]
        WHERE
            [ipj].[PatientID] = @PatientID
            AND [ipj].[JobNetDateTime] >= @StartDateTime
            AND [ipj].[PageNumber] = 1
        UNION
        SELECT
            [ipj].[PrintJobID],
            [ipj].[Description],
            [ipj].[RecordingTime],
            [ipj].[JobNetDateTime],
            [ipj].[JobType],
            [ipj].[PageNumber]
        FROM
            [Intesys].[PrintJob] AS [ipj]
        WHERE
            [ipj].[PatientID] = @PatientID
            AND [ipj].[JobNetDateTime] >= @StartDateTime
            AND [ipj].[PageNumber] =
                (
                    SELECT
                        COUNT(*)
                    FROM
                        [Intesys].[PrintJob] AS [print1]
                    WHERE
                        [print1].[PrintJobID] = [ipj].[PrintJobID]
                )
        ORDER BY
            [ipj].[JobNetDateTime] DESC,
            [ipj].[PrintJobID];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'ClinicalAccess', @level1type = N'PROCEDURE', @level1name = N'uspGetPrintJobsListByPatientIDAndStartAndEndDateTime';

