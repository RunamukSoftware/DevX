CREATE PROCEDURE [old].[uspGetNetwork]
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT DISTINCT
            [im].[NetworkID]
        FROM
            [Intesys].[Monitor] AS [im]
        ORDER BY
            [im].[NetworkID];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetNetwork';

