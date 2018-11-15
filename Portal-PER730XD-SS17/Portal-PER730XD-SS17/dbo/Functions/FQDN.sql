-- Usage: 
-- [dbo].[cfgValuesFactory] - ReferenceData\CfgValuesFactory.Data.sql
CREATE FUNCTION [dbo].[FQDN] ()
RETURNS VARCHAR(30)
AS
BEGIN
    DECLARE @Domain NVARCHAR(100);

    EXEC [master].[sys].[xp_regread]
        @rootkey = N'HKEY_LOCAL_MACHINE',
        @key = N'SYSTEM\CurrentControlSet\services\Tcpip\Parameters',
        @value_name = N'Domain',
        @value = @Domain OUTPUT;

    RETURN
        CASE
            WHEN @Domain IS NOT NULL THEN CAST(SERVERPROPERTY('MachineName') AS NVARCHAR(30)) + N'.' + @Domain
            ELSE CAST(SERVERPROPERTY('MachineName') AS NVARCHAR(30))
        END; 
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Retrieve the fully qualified domain name in which the SQL Server resides.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'FUNCTION', @level1name = N'FQDN';

