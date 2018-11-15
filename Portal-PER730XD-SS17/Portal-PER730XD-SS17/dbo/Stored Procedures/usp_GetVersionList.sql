CREATE PROCEDURE [dbo].[usp_GetVersionList]
AS
BEGIN
    SELECT
        [ver_code],
        [install_dt],
        [status_cd],
        [install_pgm]
    FROM
        [dbo].[int_db_ver];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_GetVersionList';

