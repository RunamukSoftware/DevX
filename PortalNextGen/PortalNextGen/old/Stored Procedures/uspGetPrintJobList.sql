CREATE PROCEDURE [old].[uspGetPrintJobList]
    (
        @Filters      NVARCHAR(MAX),
        @FromDateTime DATETIME2(7),
        @ToDateTime   DATETIME2(7),
        @Debug        BIT = 0
    )
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE @SqlQuery NVARCHAR(MAX)
            = N'
SELECT
    [ipj].[PrintSwitch],
    [ipj].[PrinterName],
    [ipj].[Description],
    [ipj].[PageNumber],
    [ipj].[RowDateTime],
    [imrnm].[MedicalRecordNumberXID],
    [ipj].[StatusCode],
    [ipj].[StatusMessage],
    [ipj].[JobType],
    [imrnm].[PatientID]
FROM
    [Intesys].[PrintJob]                   AS [ipj]
    INNER JOIN
        [Intesys].[MedicalRecordNumberMap] AS [imrnm]
            ON [ipj].[PatientID] = [imrnm].[PatientID]
WHERE [ipj].[JobNetDateTime] BETWEEN @FromDateTime AND @ToDateTime ';

        IF (LEN(@Filters) > 0)
            SET @SqlQuery += N' AND ' + @Filters;
        ELSE
            SET @Filters = N'';

        IF (@Debug = 1)
            PRINT @SqlQuery;

        EXEC [sys].[sp_executesql]
            @SqlQuery,
            N'@FromDateTime DATETIME2(7),
@ToDateTime DATETIME2(7)',
            @FromDateTime,
            @ToDateTime;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetPrintJobList';

