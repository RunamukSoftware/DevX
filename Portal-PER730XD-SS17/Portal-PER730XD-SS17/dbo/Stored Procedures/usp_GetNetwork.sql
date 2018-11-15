CREATE PROCEDURE [dbo].[usp_GetNetwork]
AS
BEGIN
    SELECT DISTINCT
        [network_id]
    FROM
        [dbo].[int_monitor]
    ORDER BY
        [network_id];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_GetNetwork';

