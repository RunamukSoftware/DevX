CREATE PROCEDURE [dbo].[usp_CEI_UpdateLog]
    (
     @status INT,
     @description NVARCHAR(300),
     @eventId UNIQUEIDENTIFIER,
     @seqNum INT,
     @client NVARCHAR(50)
    )
AS
BEGIN
    UPDATE
        [dbo].[int_event_log]
    SET
        [status] = @status,
        [description] = @description
    WHERE
        [event_id] = @eventId
        AND [seq_num] = @seqNum
        AND [client] = @client;
END;
--Inline Queries from CA

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_CEI_UpdateLog';

