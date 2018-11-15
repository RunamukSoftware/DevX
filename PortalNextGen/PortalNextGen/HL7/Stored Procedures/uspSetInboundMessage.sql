CREATE PROCEDURE [HL7].[uspSetInboundMessage]
    (
        @MessageNumber                NUMERIC(10),
        @PatientIDMedicalRecordNumber NVARCHAR(40)  = NULL,
        @Pv1VisitNo                   NVARCHAR(100) = NULL,
        @MessageStatus                NCHAR(2)      = NULL,
        @ProcessedDateTime            DATETIME2(7)  = NULL
    )
AS
    BEGIN
        SET NOCOUNT ON;

        IF (@ProcessedDateTime IS NULL)
            SET @ProcessedDateTime = SYSUTCDATETIME();

        UPDATE
            [HL7].[InputQueue]
        SET
            [PatientIDMedicalRecordNumber] = ISNULL(@PatientIDMedicalRecordNumber, [PatientIDMedicalRecordNumber]),
            [pv1_visitNumber] = ISNULL(@Pv1VisitNo, [pv1_visitNumber]),
            [MessageStatus] = ISNULL(@MessageStatus, [MessageStatus]),
            [ProcessedDateTime] = @ProcessedDateTime
        WHERE
            [MessageNumber] = @MessageNumber;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Update HL7INQUEUE.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'PROCEDURE', @level1name = N'uspSetInboundMessage';

