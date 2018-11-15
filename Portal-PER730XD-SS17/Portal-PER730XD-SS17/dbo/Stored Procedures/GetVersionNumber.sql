CREATE PROCEDURE [dbo].[GetVersionNumber]
AS
BEGIN
    SELECT TOP (1)
        [ver_code] AS [VERSION],
        [install_dt] AS [DT]
    FROM
        [dbo].[int_db_ver]
    ORDER BY
        [install_dt] DESC;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Returns the latest version number of the ICS database using the [install_dt] column to get the most recent record.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetVersionNumber';

