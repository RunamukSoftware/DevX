CREATE PROCEDURE [HL7].[uspSaveOruMessages] (@MessageList [old].[utpOruMessage] READONLY)
AS
    BEGIN
        SET NOCOUNT ON;

        INSERT INTO [HL7].[OutputQueue]
            (
                [MessageStatus],
                [MessageNumber],
                [LongText],
                [ShortText],
                [PatientID],
                [MshSystem],
                [MshOrganization],
                [MshEventCode],
                [MshMessageType],
                [SentDateTime],
                [QueuedDateTime]
            )
                    SELECT
                        [MessageStatus],
                        [MessageNumber],
                        [LongText],
                        [ShortText],
                        [PatientID],
                        [MshSystem],
                        [MshOrganization],
                        [MshEventCode],
                        [MshMessageType],
                        [SentDateTime],
                        [QueuedDateTime]
                    FROM
                        @MessageList;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Retrieves the legacy Global Data System (GDS) codes', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'PROCEDURE', @level1name = N'uspSaveOruMessages';

