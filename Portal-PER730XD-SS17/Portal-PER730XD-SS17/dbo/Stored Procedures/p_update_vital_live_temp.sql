CREATE PROCEDURE [dbo].[p_update_vital_live_temp]
AS
BEGIN
    SET NOCOUNT ON;

    DELETE
        [ivlt]
    FROM
        [dbo].[int_vital_live_temp] AS [ivlt]
    WHERE
        [createdDT] < GETDATE() - 0.002; 
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'p_update_vital_live_temp';

