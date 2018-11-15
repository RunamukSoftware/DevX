CREATE PROCEDURE [dbo].[usp_SaveCfgValues]
    (
     @keyname VARCHAR(40),
     @keyvalue VARCHAR(100)
    )
AS
BEGIN
    IF NOT EXISTS ( SELECT
                        [keyname]
                    FROM
                        [dbo].[int_cfg_values]
                    WHERE
                        [keyname] = @keyname )
        INSERT  INTO [dbo].[int_cfg_values]
                ([keyname], [keyvalue])
        VALUES
                (@keyname, @keyvalue); 
    ELSE
        UPDATE
            [dbo].[int_cfg_values]
        SET
            [keyvalue] = @keyvalue
        WHERE
            [keyname] = @keyname;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_SaveCfgValues';

