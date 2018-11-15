CREATE PROCEDURE [dbo].[usp_GetSystemLog]
    (
     @filters NVARCHAR(MAX),
     @FromDate NVARCHAR(MAX),
     @ToDate NVARCHAR(MAX)
    )
AS
BEGIN
    DECLARE @Query NVARCHAR(MAX) = N'
        SELECT
            msg_dt AS [Date], 
            product AS [Product],
            type AS [Status],
            msg_text AS [Message]
        FROM
            dbo.int_msg_log
        WHERE
            msg_dt BETWEEN ';
    SET @Query += N'''' + @FromDate + N'''';
    SET @Query += N' AND ';
    SET @Query += N'''' + @ToDate + N'''';
                                        
    IF (LEN(@filters) > 0)
        SET @Query += N' AND ';
    SET @Query += @filters;

    EXEC(@Query);
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_GetSystemLog';

