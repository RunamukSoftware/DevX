CREATE PROCEDURE [HL7].[uspGetHL7LogListOutbound]
    (
        @FromDate              NVARCHAR(MAX),
        @ToDate                NVARCHAR(MAX),
        @MessageNumber         NVARCHAR(40)  = NULL,
        @PatientID             NVARCHAR(40)  = NULL,
        @MsgEventCode          NCHAR(6)      = NULL,
        @MsgEventType          NCHAR(6)      = NULL,
        @MsgSystem             NVARCHAR(100) = NULL,
        @MsgStatusRead         BIT,
        @MsgStatusError        BIT,
        @MsgStatusNotProcessed BIT,
        @Debug                 BIT           = 0
    )
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE
            @SqlQuery NVARCHAR(MAX),
            @SubQuery NVARCHAR(MAX);

        SET @SqlQuery
            = N'
SELECT 
    QueuedDateTime AS [Date], 
    MessageNumber AS [HL7#], 
    PatientID AS [Patient ID],
    MessageStatus AS [Status],
    msh_system AS [Send System], 
    MshEventCode AS [Event],
    ISNULL(HL7TextShort,
    HL7TextLong) AS [Message],
    ''O'' AS [Direction]
FROM dbo.HL7_out_queue 
WHERE QueuedDateTime BETWEEN ';

        SET @SqlQuery += N'''' + @FromDate + N'''';

        SET @SqlQuery += N' AND ';

        SET @SqlQuery += N'''' + @ToDate + N'''';

        IF (
               @MessageNumber IS NOT NULL
               AND @MessageNumber <> ''
           )
            SET @SqlQuery += N' AND MessageNumber=' + N'''' + @MessageNumber + N'''';

        IF (
               @PatientID IS NOT NULL
               AND @PatientID <> N''
           )
            SET @SqlQuery += N' AND PatientID=' + N'''' + @PatientID + N'''';

        IF (
               @MsgEventCode IS NOT NULL
               AND @MsgEventCode <> N''
           )
            SET @SqlQuery += N' AND MshEventCode=' + N'''' + @MsgEventCode + N'''';

        IF (
               @MsgEventType IS NOT NULL
               AND @MsgEventType <> N''
           )
            SET @SqlQuery += N' AND msh_msg_type=' + N'''' + @MsgEventType + N'''';

        IF (
               @MsgSystem IS NOT NULL
               AND @MsgSystem <> N''
           )
            SET @SqlQuery += N' AND msh_system=' + N'''' + @MsgSystem + N'''';

        IF (
               @MsgStatusRead = 1
               OR @MsgStatusError = 1
               OR @MsgStatusNotProcessed = 1
           )
            BEGIN
                SET @SqlQuery += N' AND ';
                SET @SubQuery = N'(';

                IF (@MsgStatusRead = 1)
                    BEGIN
                        SET @SubQuery += N' MessageStatus=''R'' ';
                    END;

                IF (@MsgStatusError = 1)
                    BEGIN
                        IF (LEN(@SubQuery) > 1)
                            SET @SubQuery += N' OR ';
                        SET @SubQuery += N' MessageStatus=''E'' ';
                    END;

                IF (@MsgStatusNotProcessed = 1)
                    BEGIN
                        IF (LEN(@SubQuery) > 1)
                            SET @SubQuery += N' OR ';
                        SET @SubQuery += N' MessageStatus=''N'' ';
                    END;

                SET @SubQuery += N')';
                SET @SqlQuery += @SubQuery;
            END;

        IF (@Debug = 1)
            PRINT @SqlQuery;

        EXEC (@SqlQuery);
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get HL7 Log List Outbound', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'PROCEDURE', @level1name = N'uspGetHL7LogListOutbound';

