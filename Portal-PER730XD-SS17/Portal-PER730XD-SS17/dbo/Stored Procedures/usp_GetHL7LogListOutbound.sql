CREATE PROCEDURE [dbo].[usp_GetHL7LogListOutbound]
    (
     @FromDate NVARCHAR(MAX),
     @ToDate NVARCHAR(MAX),
     @MessageNumber NVARCHAR(40) = NULL,
     @PatientId NVARCHAR(40) = NULL,
     @MsgEventCode NCHAR(6) = NULL,
     @MsgEventType NCHAR(6) = NULL,
     @MsgSystem NVARCHAR(100) = NULL,
     @MsgStatusRead BIT,
     @MsgStatusError BIT,
     @MsgStatusNotProcessed BIT
    )
AS
BEGIN
    DECLARE
        @Query NVARCHAR(MAX),
        @SubQuery NVARCHAR(200);

    SET @Query = N'
        SELECT 
            queued_dt AS [Date], 
            msg_no AS [HL7#], 
            patient_id AS [Patient ID],
            msg_status AS [Status],
            msh_system AS [Send System], 
            msh_event_cd AS [Event],
            ISNULL(HL7_text_short,
            HL7_text_long) AS [Message],
            ''O'' AS [Direction]
        FROM dbo.HL7_out_queue 
        WHERE queued_dt BETWEEN ';

    SET @Query += N'''' + @FromDate + N'''';

    SET @Query += N' AND ';

    SET @Query += N'''' + @ToDate + N'''';

    IF (@MessageNumber IS NOT NULL
        AND @MessageNumber <> '')
        SET @Query += N' AND msg_no=' + N'''' + @MessageNumber + N'''';

    IF (@PatientId IS NOT NULL
        AND @PatientId <> N'')
        SET @Query += N' AND patient_id=' + N'''' + @PatientId + N'''';

    IF (@MsgEventCode IS NOT NULL
        AND @MsgEventCode <> N'')
        SET @Query += N' AND msh_event_cd=' + N'''' + @MsgEventCode + N'''';

    IF (@MsgEventType IS NOT NULL
        AND @MsgEventType <> N'')
        SET @Query += N' AND msh_msg_type=' + N'''' + @MsgEventType + N'''';

    IF (@MsgSystem IS NOT NULL
        AND @MsgSystem <> N'')
        SET @Query += N' AND msh_system=' + N'''' + @MsgSystem + N'''';

    IF (@MsgStatusRead = 1
        OR @MsgStatusError = 1
        OR @MsgStatusNotProcessed = 1)
    BEGIN
        SET @Query += N' AND ';
        SET @SubQuery = N'(';

        IF (@MsgStatusRead = 1)
        BEGIN
            SET @SubQuery += N' msg_status=''R'' ';
        END;

        IF (@MsgStatusError = 1)
        BEGIN
            IF (LEN(@SubQuery) > 1)
                SET @SubQuery += N' OR ';
            SET @SubQuery += N' msg_status=''E'' ';
        END;

        IF (@MsgStatusNotProcessed = 1)
        BEGIN
            IF (LEN(@SubQuery) > 1)
                SET @SubQuery += N' OR ';
            SET @SubQuery += N' msg_status=''N'' ';
        END;

        SET @SubQuery += N')';
        SET @Query += @SubQuery;
    END;

    EXEC(@Query);
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get HL7 Log List Outbound', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_GetHL7LogListOutbound';

