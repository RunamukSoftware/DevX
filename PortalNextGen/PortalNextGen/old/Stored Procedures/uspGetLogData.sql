CREATE PROCEDURE [old].[uspGetLogData]
    (
        @StartDateTime DATETIME2(7),
        @EndDateTime   DATETIME2(7),
        @LogType       VARCHAR(64),
        @PatientID     INT,
        @Application   VARCHAR(256),
        @DeviceName    VARCHAR(256)
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [l].[LogID],
            [l].[DateTime],
            [l].[PatientID],
            [l].[Application],
            [l].[DeviceName],
            [l].[Message],
            [l].[LocalizedMessage],
            [l].[MessageID],
            [l].[LogType]
        FROM
            [old].[Log] AS [l]
        WHERE
            [l].[DateTime] >= @StartDateTime
            AND [l].[DateTime] <= @EndDateTime
            AND (
                    [l].[LogType] = @LogType
                    OR @LogType IS NULL
                )
            AND (
                    [l].[PatientID] = @PatientID
                    OR @PatientID IS NULL
                )
            AND (
                    [l].[DeviceName] = @DeviceName
                    OR @DeviceName IS NULL
                )
            AND (
                    [l].[Application] = @Application
                    OR @Application IS NULL
                );
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetLogData';

