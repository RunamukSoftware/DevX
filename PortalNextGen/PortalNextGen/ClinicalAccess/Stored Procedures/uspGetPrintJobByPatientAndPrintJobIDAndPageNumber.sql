CREATE PROCEDURE [ClinicalAccess].[uspGetPrintJobByPatientAndPrintJobIDAndPageNumber]
    (
        @PatientID  INT,
        @PrintJobID INT,
        @PageNumber INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [ipj].[Description],
            [ipj].[SweepSpeed],
            [ipj].[Duration],
            [ipj].[NumberOfChannels],
            [ipj].[RecordingTime],
            [ipj].[JobNetDateTime],
            [ipj].[JobType],
            [ipj].[PageNumber],
            [ipj].[Annotation1],
            [ipj].[Annotation2],
            [ipj].[Annotation3],
            [ipj].[Annotation4]
        FROM
            [Intesys].[PrintJob] AS [ipj]
        WHERE
            [ipj].[PatientID] = @PatientID
            AND [ipj].[PrintJobID] = @PrintJobID
            AND [ipj].[PageNumber] = @PageNumber

        /* This will need to be added back when UVSL print job are handled by DataLoader

    UNION ALL

    SELECT 
        [Description], 
        [SweepSpeed],
        [Duration], 
        [NumberOfChannels], 
        [RecordingTime], 
        [JobNetDateTime], 
        [JobType], 
        [page_number], 
        [annotation1], 
        [annotation2], 
        [annotation3], 
        [annotation4]
    FROM 
        [old].[vwPrintJobs]
    WHERE 
        [PatientID] = @PatientID 
        AND [PrintJobID] = @PrintJobID 
        AND [page_number] = @PageNumber
*/
        ORDER BY
            [ipj].[JobNetDateTime];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'ClinicalAccess', @level1type = N'PROCEDURE', @level1name = N'uspGetPrintJobByPatientAndPrintJobIDAndPageNumber';

