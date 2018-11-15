CREATE PROCEDURE [old].[uspInsertEventLogData]
    (
        @LogID            INT,
        @PatientID        INT,
        @Application      VARCHAR(256),
        @DeviceName       VARCHAR(256),
        @Message          NVARCHAR(MAX),
        @LocalizedMessage NVARCHAR(MAX),
        @MessageID        INT,
        @LogType          VARCHAR(64)
    )
AS
    BEGIN
        SET NOCOUNT ON;

        INSERT INTO [old].[Log]
            (
                [LogID],
                [DateTime],
                [PatientID],
                [Application],
                [DeviceName],
                [Message],
                [LocalizedMessage],
                [MessageID],
                [LogType]
            )
        VALUES
            (
                @LogID,
                SYSUTCDATETIME(),
                @PatientID,
                @Application,
                @DeviceName,
                @Message,
                @LocalizedMessage,
                @MessageID,
                @LogType
            );
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspInsertEventLogData';

