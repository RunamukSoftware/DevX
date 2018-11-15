CREATE PROCEDURE [dbo].[Change_Starter_Set] (@lang_code VARCHAR(5))
AS
BEGIN
/*************************************************************************************************
    Procedure Name            :    Change_Starter_Set
            
    Parameters:    Language Column    ex:   fra --French, deu -- German, nld -- Dutch, etc
    Output Parameter:    Null                  
    Purpose: To Change the UI from one Language to other, this procedure is Executed, to update the 
             respective strings in respective columns. If we want to change the language from English 
             to French, then we have to give 'FRA' as the parameter
    Tables Involved: int_misc_code, int_test_group, int_test_group_detail,
                         int_order_group, int_site_link, int_environment and int_starter_set
    Date of  Modification        :    30 June 2006                                                     
    Modification/Add:    For localization of ICS, we need to implement some more strings from int_misc_code 
                      to complete the process. For this we have to included these strings in int_starter_set 
                      table for translation. After translation we have to update the relative strings in  
                      int_misc_code table. This modified procedure updates the relative fields in int_misc_code table.
  
                          Modified SQL Injections are Commented in format 
  **************************************************************************************************/
    DECLARE @sql VARCHAR(2000);

    -- Build an empty temp table
    SELECT
        [set_type_cd],
        [guid],
        [int_id1],
        [int_id2],
        [int_id3],
        [enu],
        [enu] AS [TO_LANG]
    INTO
        [#TMP_STARTER_SET]
    FROM
        [dbo].[int_starter_set]
    WHERE
        1 = 0;

    -- Fill up temp table, TO_LANG column contains the value for the language we are going to
    SET @sql = 'SELECT [set_type_cd], [guid], [int_id1], [int_id2], [int_id3], [enu], [' + @lang_code + '] AS [TO_LANG] FROM [dbo].[int_starter_set];';

    INSERT  INTO [#TMP_STARTER_SET]
            EXEC (@sql
            );

    -- UPDATE the tables
    UPDATE
        [dbo].[int_misc_code]
    SET
        [int_keystone_cd] = [TO_LANG]
    FROM
        [#TMP_STARTER_SET]
    WHERE
        [set_type_cd] = N'GDS-U'
        AND [int_misc_code].[code_id] = [#TMP_STARTER_SET].[int_id1]
        AND [int_misc_code].[code_id] = [#TMP_STARTER_SET].[int_id2]
        AND [int_misc_code].[code_id] = [#TMP_STARTER_SET].[int_id3];

    UPDATE
        [dbo].[int_misc_code]
    SET
        [short_dsc] = [TO_LANG]
    FROM
        [#TMP_STARTER_SET]
    WHERE
        [set_type_cd] = N'GDS'
        AND [int_misc_code].[code_id] = [#TMP_STARTER_SET].[int_id1]
        AND [int_misc_code].[code_id] = [#TMP_STARTER_SET].[int_id2]
        AND [int_misc_code].[code_id] = [#TMP_STARTER_SET].[int_id3];

    UPDATE
        [dbo].[int_misc_code]
    SET
        [int_keystone_cd] = [TO_LANG]
    FROM
        [#TMP_STARTER_SET]
    WHERE
        [set_type_cd] = N'HL7-U'
        AND [int_misc_code].[code_id] = [#TMP_STARTER_SET].[int_id1]
        AND [int_misc_code].[code_id] = [#TMP_STARTER_SET].[int_id2]
        AND [int_misc_code].[code_id] = [#TMP_STARTER_SET].[int_id3];

    UPDATE
        [dbo].[int_misc_code]
    SET
        [short_dsc] = [TO_LANG]
    FROM
        [#TMP_STARTER_SET]
    WHERE
        [set_type_cd] = N'HL7'
        AND [int_misc_code].[code_id] = [#TMP_STARTER_SET].[int_id1]
        AND [int_misc_code].[code_id] = [#TMP_STARTER_SET].[int_id2]
        AND [int_misc_code].[code_id] = [#TMP_STARTER_SET].[int_id3];

    UPDATE
        [dbo].[int_misc_code]
    SET
        [short_dsc] = [TO_LANG]
    FROM
        [#TMP_STARTER_SET]
    WHERE
        [set_type_cd] = N'S5N'
        AND [int_misc_code].[code_id] = [#TMP_STARTER_SET].[int_id1]
        AND [int_misc_code].[code_id] = [#TMP_STARTER_SET].[int_id2]
        AND [int_misc_code].[code_id] = [#TMP_STARTER_SET].[int_id3];

    UPDATE
        [dbo].[int_misc_code]
    SET
        [int_keystone_cd] = [TO_LANG]
    FROM
        [#TMP_STARTER_SET]
    WHERE
        [set_type_cd] = N'S5N-U'
        AND [int_misc_code].[code_id] = [#TMP_STARTER_SET].[int_id1]
        AND [int_misc_code].[code_id] = [#TMP_STARTER_SET].[int_id2]
        AND [int_misc_code].[code_id] = [#TMP_STARTER_SET].[int_id3];

    UPDATE
        [dbo].[int_misc_code]
    SET
        [short_dsc] = [TO_LANG]
    FROM
        [#TMP_STARTER_SET]
    WHERE
        [set_type_cd] = N'SLOG'
        AND [int_misc_code].[code_id] = [#TMP_STARTER_SET].[int_id1]
        AND [int_misc_code].[code_id] = [#TMP_STARTER_SET].[int_id2]
        AND [int_misc_code].[code_id] = [#TMP_STARTER_SET].[int_id3];

    UPDATE
        [dbo].[int_organization]
    SET
        [organization_nm] = [TO_LANG]
    FROM
        [#TMP_STARTER_SET]
    WHERE
        [set_type_cd] = N'ORG'
        AND [int_organization].[organization_id] = [#TMP_STARTER_SET].[guid];

    UPDATE
        [dbo].[int_test_group]
    SET
        [node_name] = ISNULL([TO_LANG], N'')
    FROM
        [#TMP_STARTER_SET]
    WHERE
        [set_type_cd] = N'TG'
        AND [#TMP_STARTER_SET].[int_id1] = [int_test_group].[node_id];

    UPDATE
        [dbo].[int_test_group_detail]
    SET
        [nm] = ISNULL([TO_LANG], N'')
    FROM
        [#TMP_STARTER_SET]
    WHERE
        [set_type_cd] = N'TGD'
        AND [#TMP_STARTER_SET].[int_id1] = [int_test_group_detail].[node_id]
        AND ISNULL([#TMP_STARTER_SET].[int_id2], -999) = ISNULL([int_test_group_detail].[univ_svc_cid], -999)
        AND ISNULL([#TMP_STARTER_SET].[int_id3], -999) = ISNULL([int_test_group_detail].[test_cid], -999);

    UPDATE
        [dbo].[int_misc_code]
    SET
        [short_dsc] = ISNULL([TO_LANG], N'')
    FROM
        [#TMP_STARTER_SET]
    WHERE
        [set_type_cd] = N'TGD'
        AND [#TMP_STARTER_SET].[int_id2] = [int_misc_code].[code_id]
        AND [#TMP_STARTER_SET].[int_id3] IS NULL
        AND [int_misc_code].[category_cd] = 'USID';

    UPDATE
        [dbo].[int_misc_code]
    SET
        [short_dsc] = ISNULL([TO_LANG], N'')
    FROM
        [#TMP_STARTER_SET]
    WHERE
        [set_type_cd] = N'TGD'
        AND [#TMP_STARTER_SET].[int_id2] IS NULL
        AND [#TMP_STARTER_SET].[int_id3] = [int_misc_code].[code_id]
        AND [int_misc_code].[category_cd] = 'ATST';

    UPDATE
        [dbo].[int_order_group]
    SET
        [node_name] = ISNULL([TO_LANG], N'')
    FROM
        [#TMP_STARTER_SET]
    WHERE
        [set_type_cd] = N'OG'
        AND [#TMP_STARTER_SET].[int_id1] = [int_order_group].[node_id];

    UPDATE
        [dbo].[int_misc_code]
    SET
        [short_dsc] = ISNULL([TO_LANG], N'')
    FROM
        [#TMP_STARTER_SET]
    WHERE
        [set_type_cd] = N'OGD'
        AND [#TMP_STARTER_SET].[int_id1] = [int_misc_code].[code_id]
        AND [int_misc_code].[category_cd] = 'USID';

    UPDATE
        [dbo].[int_site_link]
    SET
        [group_name] = ISNULL([TO_LANG], N'')
    FROM
        [#TMP_STARTER_SET]
    WHERE
        [set_type_cd] = N'SLG'
        AND [#TMP_STARTER_SET].[int_id1] = [int_site_link].[group_rank];

    UPDATE
        [dbo].[int_site_link]
    SET
        [display_name] = ISNULL([TO_LANG], N'')
    FROM
        [#TMP_STARTER_SET]
    WHERE
        [set_type_cd] = N'SL'
        AND [#TMP_STARTER_SET].[guid] = [int_site_link].[link_id];

    UPDATE
        [dbo].[int_environment]
    SET
        [display_name] = ISNULL([TO_LANG], N'')
    FROM
        [#TMP_STARTER_SET]
    WHERE
        [set_type_cd] = N'EL'
        AND [#TMP_STARTER_SET].[guid] = [int_environment].[env_id];

    DROP TABLE
             [#TMP_STARTER_SET];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'Change_Starter_Set';

