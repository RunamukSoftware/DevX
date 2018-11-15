CREATE PROCEDURE [Intesys].[uspGetAllProducts]
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [ip].[ProductCode],
            [ip].[Description],
            [ip].[HasAccess]
        FROM
            [Intesys].[Product] AS [ip]
        ORDER BY
            [ip].[ProductCode];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'PROCEDURE', @level1name = N'uspGetAllProducts';

