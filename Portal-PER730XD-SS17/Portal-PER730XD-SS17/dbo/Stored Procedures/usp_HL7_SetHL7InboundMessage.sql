CREATE PROCEDURE [dbo].[usp_HL7_SetHL7InboundMessage]
    (
     @MsgNo INT, -- TG - should be NUMERIC(10)
     @PidMrn NVARCHAR(40) = NULL,
     @Pv1VisitNo NVARCHAR(100) = NULL,
     @MsgStatus NCHAR(2) = NULL,
     @ProcessedDt DATETIME = NULL
    )
AS
BEGIN
    IF @ProcessedDt IS NULL
        SET @ProcessedDt = GETDATE();

    UPDATE
        [dbo].[HL7_in_queue]
    SET
        [pid_mrn] = ISNULL(@PidMrn, [pid_mrn]),
        [pv1_visit_no] = ISNULL(@Pv1VisitNo, [pv1_visit_no]),
        [msg_status] = ISNULL(@MsgStatus, [msg_status]),
        [processed_dt] = @ProcessedDt
    WHERE
        [msg_no] = CAST(@MsgNo AS NUMERIC(10));
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Update HL7INQUEUE.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_HL7_SetHL7InboundMessage';

