CREATE PROCEDURE [old].[uspGetSendSystemList]
    (
        @OrganizationID INT = NULL,
        @Debug          BIT = 0
    )
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE @SqlQuery NVARCHAR(MAX)
            = N'
        SELECT 
            code,
            dsc,
            SystemID 
        FROM 
            dbo.int_send_sys ';

        DECLARE @Query1 NVARCHAR(MAX) = N' ORDER BY code';

        IF (LEN(@OrganizationID) > 0)
            BEGIN
                SET @SqlQuery += N' WHERE OrganizationID = ';
                SET @SqlQuery += N'''' + CAST(@OrganizationID AS NVARCHAR(MAX)) + N'''';
            END;

        SET @SqlQuery += @Query1;

        IF (@Debug = 1)
            PRINT @SqlQuery;

        EXEC (@SqlQuery);
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetSendSystemList';

