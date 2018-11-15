CREATE PROCEDURE [dbo].[InsertEventLogData]
    (
     @LogId VARCHAR(64), -- TG - should be UNIQUEIDENTIFIER
     @PatientId [dbo].[DPATIENT_ID], -- TG - Should be UNIQUEIDENTIFIER
     @Application VARCHAR(256),
     @DeviceName VARCHAR(256),
     @Message VARCHAR(MAX), -- TG - should be NVARCHAR(MAX)
     @LocalizedMessage VARCHAR(MAX), -- TG - should be NVARCHAR(MAX)
     @MessageId INT,
     @LogType VARCHAR(64)
    )
AS
BEGIN
    SET NOCOUNT ON;

    INSERT  INTO [dbo].[LogData]
            ([LogId],
             [DateTime],
             [PatientID],
             [Application],
             [DeviceName],
             [Message],
             [LocalizedMessage],
             [MessageId],
             [LogType]
            )
    VALUES
            (CAST(@LogId AS UNIQUEIDENTIFIER),
             GETDATE(),
             @PatientId,
             @Application,
             @DeviceName,
             CAST(@Message AS NVARCHAR(MAX)),
             CAST(@LocalizedMessage AS NVARCHAR(MAX)),
             @MessageId,
             @LogType
            );
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'InsertEventLogData';

