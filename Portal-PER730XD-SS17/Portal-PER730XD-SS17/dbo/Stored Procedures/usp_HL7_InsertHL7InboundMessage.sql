CREATE PROCEDURE [dbo].[usp_HL7_InsertHL7InboundMessage]
    (
     @msg_status NCHAR(2), -- TG - should be NCHAR(1)
     @msh_msg_type NCHAR(6), -- TG - should be NCHAR(3)
     @msh_event_cd NCHAR(6), -- TG - should be NCHAR(3)
     @msh_organization NVARCHAR(72), -- TG - should be NVARCHAR(36)
     @msh_system NVARCHAR(72), -- TG - should be NVARCHAR(36)
     @msh_dt DATETIME,
     @msh_control_id NVARCHAR(72), -- TG - should be NVARCHAR(36)
     @msh_version NVARCHAR(10), -- TG - should be NVARCHAR(5)
     @HL7TextShort NVARCHAR(510) = NULL, -- TG - should be NVARCHAR(255)
     @HL7TextLong NVARCHAR(MAX) = NULL,
     @msg_no NUMERIC(9) OUTPUT
    )
AS
BEGIN
    IF (@HL7TextShort IS NOT NULL)
    BEGIN
        INSERT  INTO [dbo].[HL7_in_queue]
                ([msg_status],
                 [queued_dt],
                 [msh_msg_type],
                 [msh_event_cd],
                 [msh_organization],
                 [msh_system],
                 [msh_dt],
                 [msh_control_id],
                 [msh_version],
                 [HL7_text_short]
                )
        VALUES
                (CAST(@msg_status AS NCHAR(1)),
                 GETDATE(),
                 CAST(@msh_msg_type AS NCHAR(3)),
                 CAST(@msh_event_cd AS NCHAR(3)),
                 CAST(@msh_organization AS NVARCHAR(36)),
                 CAST(@msh_system AS NVARCHAR(36)),
                 @msh_dt,
                 CAST(@msh_control_id AS NVARCHAR(36)),
                 CAST(@msh_version AS NVARCHAR(5)),
                 CAST(@HL7TextShort AS NVARCHAR(255))
                );
            
    END;
    ELSE
    BEGIN
        INSERT  INTO [dbo].[HL7_in_queue]
                ([msg_status],
                 [queued_dt],
                 [msh_msg_type],
                 [msh_event_cd],
                 [msh_organization],
                 [msh_system],
                 [msh_dt],
                 [msh_control_id],
                 [msh_version],
                 [HL7_text_long]
                )
        VALUES
                (CAST(@msg_status AS NCHAR(1)),
                 GETDATE(),
                 CAST(@msh_msg_type AS NCHAR(3)),
                 CAST(@msh_event_cd AS NCHAR(3)),
                 CAST(@msh_organization AS NVARCHAR(36)),
                 CAST(@msh_system AS NVARCHAR(36)),
                 @msh_dt,
                 CAST(@msh_control_id AS NVARCHAR(36)),
                 CAST(@msh_version AS NVARCHAR(5)),
                 @HL7TextLong
                );  
    END;

    SET @msg_no = SCOPE_IDENTITY();
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Insert HL7 inbound message', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_HL7_InsertHL7InboundMessage';

