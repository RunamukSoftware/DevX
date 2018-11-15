CREATE PROCEDURE [dbo].[GetvsvAccess]
    (
     @patient_monitor_id UNIQUEIDENTIFIER
    )
AS
BEGIN
    SELECT
        1
    FROM
        [dbo].[int_patient_monitor] AS [PM]
        INNER JOIN [dbo].[int_monitor] AS [M] ON [M].[monitor_id] = [PM].[monitor_id]
                                        AND [PM].[patient_monitor_id] = @patient_monitor_id
        INNER JOIN [dbo].[int_product_access] AS [PA] ON [PA].[organization_id] = [M].[unit_org_id]
                                                AND [PA].[product_cd] = 'vsv';
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetvsvAccess';

