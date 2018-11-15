CREATE PROCEDURE [HL7].[uspInsertInboundMessage]
    (
        @MessageStatus   CHAR(1),
        @MshMessageType  NCHAR(3),
        @MshEventCode    NCHAR(3),
        @MshOrganization NVARCHAR(36),
        @MshSystem       NVARCHAR(36),
        @MshDateTime     DATETIME2(7),
        @MshControlID    NVARCHAR(36),
        @MshVersion      NVARCHAR(5),
        @HL7TextShort    NVARCHAR(255) = NULL,
        @HL7TextLong     NVARCHAR(MAX) = NULL,
        @MessageNumber   NUMERIC(9)    OUTPUT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        IF (@HL7TextShort IS NOT NULL)
            BEGIN
                INSERT INTO [HL7].[InputQueue]
                    (
                        [MessageStatus],
                        [QueuedDateTime],
                        [MshMessageType],
                        [MshEventCode],
                        [MshOrganization],
                        [MshSystem],
                        [MshDateTime],
                        [MshControlID],
                        [MshVersion],
                        [HL7TextShort]
                    )
                VALUES
                    (
                        @MessageStatus,
                        SYSUTCDATETIME(),
                        @MshMessageType,
                        @MshEventCode,
                        @MshOrganization,
                        @MshSystem,
                        @MshDateTime,
                        @MshControlID,
                        @MshVersion,
                        @HL7TextShort
                    );

            END;
        ELSE
            BEGIN
                INSERT INTO [HL7].[InputQueue]
                    (
                        [MessageStatus],
                        [QueuedDateTime],
                        [MshMessageType],
                        [MshEventCode],
                        [MshOrganization],
                        [MshSystem],
                        [MshDateTime],
                        [MshControlID],
                        [MshVersion],
                        [HL7TextLong]
                    )
                VALUES
                    (
                        @MessageStatus,
                        SYSUTCDATETIME(),
                        @MshMessageType,
                        @MshEventCode,
                        @MshOrganization,
                        @MshSystem,
                        @MshDateTime,
                        @MshControlID,
                        @MshVersion,
                        @HL7TextLong
                    );
            END;

        SET @MessageNumber = SCOPE_IDENTITY();
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Insert HL7 inbound message', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'PROCEDURE', @level1name = N'uspInsertInboundMessage';

