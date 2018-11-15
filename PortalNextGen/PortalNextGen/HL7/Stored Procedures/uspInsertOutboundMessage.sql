CREATE PROCEDURE [HL7].[uspInsertOutboundMessage]
    (
        @MessageNumber          VARCHAR(20),
        @MessageStatus          CHAR(1),
        @HL7TextLong            NVARCHAR(MAX),
        @PatientID              INT,
        @MshSystem              NVARCHAR(50),
        @MshOrganization        NVARCHAR(50),
        @MshEventCode           NVARCHAR(10),
        @MshMessageType         NVARCHAR(10),
        @RealQueryVitalDateTime DATETIME2(7)
    )
AS
    BEGIN
        SET NOCOUNT ON;

        INSERT INTO [HL7].[OutputQueue]
            (
                [MessageNumber],
                [MessageStatus],
                [LongText],
                [PatientID],
                [MshSystem],
                [MshOrganization],
                [MshEventCode],
                [MshMessageType],
                [QueuedDateTime]
            )
        VALUES
            (
                @MessageNumber, @MessageStatus, @HL7TextLong, @PatientID, @MshSystem, @MshOrganization, @MshEventCode,
                @MshMessageType, @RealQueryVitalDateTime
            );
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Insert the HL7 outbound message.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'PROCEDURE', @level1name = N'uspInsertOutboundMessage';

