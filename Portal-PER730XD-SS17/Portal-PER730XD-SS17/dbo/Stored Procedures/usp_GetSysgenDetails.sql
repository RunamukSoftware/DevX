CREATE PROCEDURE [dbo].[usp_GetSysgenDetails]
    (
     @product_cd VARCHAR(25)
    )
AS
BEGIN
    SELECT
        [int_sysgen].[product_cd],
        [int_sysgen].[feature_cd],
        [int_sysgen].[setting]
    FROM
        [dbo].[int_sysgen]
    WHERE
        [product_cd] = @product_cd
    ORDER BY
        [feature_cd];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_GetSysgenDetails';

