CREATE PROCEDURE [dbo].[ClearEventLogData]
    (
     @PatientId [dbo].[DPATIENT_ID], -- TG - Should be UNIQUEIDENTIFIER
     @StartDate DATETIME
    )
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CheckedStartDate DATETIME;
    SET @CheckedStartDate = ISNULL(@StartDate, CAST('9999-12-31' AS DATETIME));

    IF (@PatientId IS NULL)
    BEGIN
        DELETE
            [ld]
        FROM
            [dbo].[LogData] AS [ld]
        WHERE
            [ld].[DateTime] < @CheckedStartDate;
    END;
    ELSE
    BEGIN
        DELETE
            [ld]
        FROM
            [dbo].[LogData] AS [ld]
        WHERE
            [ld].[PatientID] = @PatientId
            AND [ld].[DateTime] < @CheckedStartDate;
    END;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Clear event log data for a patient or all patients where date less than start date or all dates if start date is null.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'ClearEventLogData';

