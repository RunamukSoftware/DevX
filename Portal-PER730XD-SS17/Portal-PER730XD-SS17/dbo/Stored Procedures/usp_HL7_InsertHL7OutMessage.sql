CREATE PROCEDURE [dbo].[usp_HL7_InsertHL7OutMessage]
    (
     @msg_no CHAR(20),
     @msg_status NCHAR(20), -- TG - should be NCHAR(10)
     @HL7_text_long NVARCHAR(MAX),
     @patient_id NVARCHAR(120), -- TG - should be NVARCHAR(60)
     @msh_system NVARCHAR(100), -- TG - should be NVARCHAR(50)
     @msh_organization NCHAR(100), -- TG - should be NVARCHAR(50)
     @msh_event_cd NCHAR(20), -- TG - should be NCHAR(10)
     @msh_msg_type NCHAR(20), -- TG - should be NCHAR(10)
     @realQueryVitalDT DATETIME
    )
AS
BEGIN
    INSERT  INTO [dbo].[HL7_out_queue]
            ([msg_no],
             [msg_status],
             [HL7_text_long],
             [patient_id],
             [msh_system],
             [msh_organization],
             [msh_event_cd],
             [msh_msg_type],
             [queued_dt]
            )
    VALUES
            (@msg_no,
             CAST(@msg_status AS NCHAR(10)),
             @HL7_text_long,
             CAST(@patient_id AS NVARCHAR(60)),
             CAST(@msh_system AS NVARCHAR(50)),
             CAST(@msh_organization AS NVARCHAR(50)),
             CAST(@msh_event_cd AS NCHAR(10)),
             CAST(@msh_msg_type AS NCHAR(10)),
             @realQueryVitalDT
            );
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Insert the HL7 outbound message.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_HL7_InsertHL7OutMessage';

