CREATE PROCEDURE [dbo].[usp_HL7_SaveOruMessages]
    (
     @messageList [dbo].[OruMessages] READONLY
    )
AS
BEGIN
    INSERT  INTO [dbo].[HL7_out_queue]
    SELECT
        [msg_status],
        [msg_no],
        [HL7_text_long],
        [HL7_text_short],
        [patient_id],
        [msh_system],
        [msh_organization],
        [msh_event_cd],
        [msh_msg_type],
        [sent_dt],
        [queued_dt]
    FROM
        @messageList;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Retrieves the legacy Gds codes', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_HL7_SaveOruMessages';

