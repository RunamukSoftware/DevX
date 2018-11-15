CREATE PROCEDURE [old].[uspClearEventLogData]
    (
        @PatientID INT,
        @StartDate DATETIME2(7)
    )
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE @CheckedStartDate DATETIME2(7);
        SET @CheckedStartDate = ISNULL(@StartDate, CAST('9999-12-31' AS DATETIME2(7)));

        IF (@PatientID IS NULL)
            BEGIN
                DELETE
                [l]
                FROM
                    [old].[Log] AS [l]
                WHERE
                    [l].[DateTime] < @CheckedStartDate;
            END;
        ELSE
            BEGIN
                DELETE
                [l]
                FROM
                    [old].[Log] AS [l]
                WHERE
                    [l].[PatientID] = @PatientID
                    AND [l].[DateTime] < @CheckedStartDate;
            END;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Clear event log data for a patient or all patients where date less than start date or all dates if start date is null.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspClearEventLogData';

