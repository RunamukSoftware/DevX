CREATE PROCEDURE [dbo].[usp_HL7_InsertHL7Ack]
    (
     @msgControlId NCHAR(40), -- TG - should be NCHAR(20)
     @msgStatus NCHAR(20), -- TG - should be NCHAR(10)
     @clientIP NCHAR(60), -- TG - should be NCHAR(30)
     @ackMsgControlId NCHAR(40), -- TG - should be NCHAR(20)
     @ackSystem NCHAR(100), -- TG - should be NCHAR(50)
     @ackOrganization NCHAR(100) -- TG - should be NCHAR(50)
    )
AS
BEGIN
    INSERT  INTO [dbo].[HL7_msg_ack]
            ([msg_control_id],
             [msg_status],
             [clientIP],
             [ack_msg_control_id],
             [ack_system],
             [ack_organization],
             [received_dt],
             [num_retries]
            )
    VALUES
            (CAST(@msgControlId AS NCHAR(20)),
             CAST(@msgStatus AS NCHAR(10)),
             CAST(@clientIP AS NCHAR(30)),
             CAST(@ackMsgControlId AS NCHAR(20)),
             CAST(@ackSystem AS NCHAR(50)),
             CAST(@ackOrganization AS NVARCHAR(50)),
             GETDATE(),
             0
            );
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Insert HL7 Ack Message.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_HL7_InsertHL7Ack';

