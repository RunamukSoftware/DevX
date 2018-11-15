CREATE PROCEDURE [dbo].[p_Set_Lang] (@ICSLang NVARCHAR(10)) -- TG - should be VARCHAR(100)
AS
BEGIN
    IF NOT EXISTS ( SELECT
                        [keyvalue]
                    FROM
                        [dbo].[int_cfg_values]
                    WHERE
                        [keyname] = 'Language' )
    BEGIN
        INSERT  INTO [dbo].[int_cfg_values]
                ([keyname],
                 [keyvalue]
                )
        VALUES
                ('Language',
                 CAST(@ICSLang AS VARCHAR(100))
                );
    END;
    ELSE
        UPDATE
            [dbo].[int_cfg_values]
        SET
            [keyvalue] = CAST(@ICSLang AS VARCHAR(100))
        WHERE
            [keyname] = 'Language';
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'p_Set_Lang';

