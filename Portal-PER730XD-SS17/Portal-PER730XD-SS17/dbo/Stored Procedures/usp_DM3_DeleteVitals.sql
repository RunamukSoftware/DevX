CREATE PROCEDURE [dbo].[usp_DM3_DeleteVitals]
    (
     @COLLECTDATE NVARCHAR(30) -- TG - should be DATETIME
    )
AS
BEGIN
    DELETE
        [ivl]
    FROM
        [dbo].[int_vital_live] AS [ivl]
    WHERE
        [collect_dt] < CAST(@COLLECTDATE AS DATETIME);
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DM3_DeleteVitals';

