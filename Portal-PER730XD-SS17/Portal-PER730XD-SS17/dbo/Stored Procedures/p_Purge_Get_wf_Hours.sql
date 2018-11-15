CREATE PROCEDURE [dbo].[p_Purge_Get_wf_Hours]
AS
BEGIN
    SELECT
        [setting]
    FROM
        [dbo].[int_sysgen]
    WHERE
        [product_cd] = 'fulldiscl'
        AND [feature_cd] = 'NUMBER_OF_HOURS';
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Purge Waveform Hours.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'p_Purge_Get_wf_Hours';

