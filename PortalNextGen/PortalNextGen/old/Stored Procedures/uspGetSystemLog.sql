CREATE PROCEDURE [old].[uspGetSystemLog]
    (
        @Filters  NVARCHAR(MAX),
        @FromDate NVARCHAR(MAX),
        @ToDate   NVARCHAR(MAX),
        @Debug    BIT = 0
    )
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE @SqlQuery NVARCHAR(MAX)
            = N'
SELECT
    MessageDateTime AS [Date], 
    product AS [Product],
    Type AS [Status],
    MessageText AS [Message]
FROM
    dbo.int_msg_log
WHERE
    MessageDateTime BETWEEN ';
        SET @SqlQuery += N'''' + @FromDate + N'''';
        SET @SqlQuery += N' AND ';
        SET @SqlQuery += N'''' + @ToDate + N'''';

        IF (LEN(@Filters) > 0)
            SET @SqlQuery += N' AND ';

        SET @SqlQuery += @Filters;

        IF (@Debug = 1)
            PRINT @SqlQuery;

        EXEC (@SqlQuery);
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetSystemLog';

