CREATE PROCEDURE [dbo].[p_Get_Lang]
AS
BEGIN
    DECLARE @my_keyvalue NVARCHAR(100);

    SELECT
        @my_keyvalue = [keyvalue]
    FROM
        [dbo].[int_cfg_values]
    WHERE
        ([keyname] = 'Language');

    IF @my_keyvalue = ''
    BEGIN
        UPDATE
            [dbo].[int_cfg_values]
        SET
            [keyvalue] = 'ENU'
        WHERE
            ([keyname] = 'Language');

        SET @my_keyvalue = 'ENU';
    END;
    ELSE
        IF @my_keyvalue IS NULL
        BEGIN
            INSERT  INTO [dbo].[int_cfg_values]
            VALUES
                    ('Language', 'ENU');

            SET @my_keyvalue = 'ENU';
        END;

    SELECT
        @my_keyvalue AS [keyvalue];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'p_Get_Lang';

