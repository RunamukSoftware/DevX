CREATE PROCEDURE [dbo].[usp_CEI_InsertLog]
    (
     @eventId UNIQUEIDENTIFIER,
     @PatientId UNIQUEIDENTIFIER = NULL,
     @type NVARCHAR(30),
     @eventDt DATETIME,
     @seqNum INT,
     @client NVARCHAR(50),
     @description NVARCHAR(300),
     @status INT
    )
AS
BEGIN
    INSERT  INTO [dbo].[int_event_log]
            ([event_id],
             [patient_id],
             [type],
             [event_dt],
             [seq_num],
             [client],
             [description],
             [status]
            )
    VALUES
            (@eventId,
             @PatientId,
             @type,
             @eventDt,
             @seqNum,
             @client,
             @description,
             @status
            );
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_CEI_InsertLog';

