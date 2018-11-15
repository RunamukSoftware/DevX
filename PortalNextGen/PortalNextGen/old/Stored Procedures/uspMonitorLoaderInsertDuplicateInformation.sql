CREATE PROCEDURE [old].[uspMonitorLoaderInsertDuplicateInformation]
    (
        @OriginalID AS       VARCHAR(20),
        @DuplicateID AS      VARCHAR(20),
        @OriginalMonitor AS  VARCHAR(5),
        @DuplicateMonitor AS VARCHAR(5)
    )
AS
    BEGIN
        SET NOCOUNT ON;

        IF NOT EXISTS
            (
                SELECT
                    [mdi].[OriginalID]
                FROM
                    [old].[MonitorLoaderDuplicateInformation] AS [mdi]
                WHERE
                    [mdi].[OriginalID] = @OriginalID
                    AND [mdi].[DuplicateID] = @DuplicateID
                    AND [mdi].[OriginalMonitor] = @OriginalMonitor
                    AND [mdi].[DuplicateMonitor] = @DuplicateMonitor
            )
            BEGIN
                INSERT INTO [old].[MonitorLoaderDuplicateInformation]
                    (
                        [OriginalID],
                        [DuplicateID],
                        [OriginalMonitor],
                        [DuplicateMonitor]
                    )
                VALUES
                    (
                        @OriginalID, @DuplicateID, @OriginalMonitor, @DuplicateMonitor
                    );
            END;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspMonitorLoaderInsertDuplicateInformation';

