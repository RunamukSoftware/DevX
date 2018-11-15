CREATE PROCEDURE [dbo].[p_Parents]
    (
     @person_id UNIQUEIDENTIFIER
    )
AS /*------------------------------------------------------------
* $Id: p_parents.sql,v 1.4 1997/09/10 16:19:14 dipti Exp $
*
* Select the record with relationship code of MOTHER and
* role code of a NOK if one exists otherwise (b Guardian 
* Since there could be multiple records with same role code and
* relationship code id, select the one with min desc key.
* The use the ent id to get the mother's name 
*------------------------------------------------------------*/
BEGIN
    DECLARE
        @mom_ent_id UNIQUEIDENTIFIER,
        @dad_ent_id UNIQUEIDENTIFIER;

    SELECT
        [code_id],
        [int_keystone_cd]
    INTO
        [#TMP_MISC_CODE]
    FROM
        [dbo].[int_misc_code]
    WHERE
        [int_keystone_cd] IN (N'MOTHER', N'FATHER')
        AND [category_cd] = 'RELA';

    SELECT
        @mom_ent_id = [nok_person_id]
    FROM
        [dbo].[int_nok] AS [N]
        INNER JOIN [#TMP_MISC_CODE] AS [T] ON [N].[relationship_cid] = [T].[code_id]
    WHERE
        [N].[patient_id] = @person_id
        AND [T].[int_keystone_cd] = N'MOTHER'
    ORDER BY
        [seq_no] DESC;

    IF (@mom_ent_id = NULL)
    BEGIN
        SELECT
            @mom_ent_id = [guarantor_person_id]
        FROM
            [dbo].[int_guarantor] AS [G]
            INNER JOIN [#TMP_MISC_CODE] AS [T] ON [G].[relationship_cid] = [T].[code_id]
        WHERE
            [G].[patient_id] = @person_id
            AND [T].[int_keystone_code] = N'MOTHER'
        ORDER BY
            [seq_no] DESC;
    END;

  /* select the one with max role_code and msx seq_no*/
    SELECT
        @dad_ent_id = [nok_person_id]
    FROM
        [dbo].[int_nok] AS [N]
        INNER JOIN [#TMP_MISC_CODE] AS [T] ON [N].[relationship_cid] = [T].[code_id]
    WHERE
        [N].[patient_id] = @person_id
        AND [T].[int_keystone_cd] = N'FATHER'
    ORDER BY
        [seq_no] DESC;

    IF (@dad_ent_id = NULL)
    BEGIN
        SELECT
            @dad_ent_id = [guarantor_person_id]
        FROM
            [dbo].[int_guarantor] AS [G]
            INNER JOIN [#TMP_MISC_CODE] AS [T] ON [G].[relationship_cid] = [T].[code_id]
        WHERE
            [G].[patient_id] = @person_id
            AND [T].[int_keystone_code] = N'FATHER'
        ORDER BY
            [seq_no] DESC;
    END;

  /* select the one with max role_code and min desc_key */
    SELECT
        [PN].[last_nm],
        [PN].[first_nm],
        [PN].[middle_nm],
        [PN].[suffix],
        'MOM' AS [CODE]
    FROM
        [dbo].[int_person_name] AS [PN]
    WHERE
        [PN].[person_nm_id] = @mom_ent_id
        AND [PN].[recognize_nm_cd] = 'P'
        AND [active_sw] = 1
    UNION
    SELECT
        [PN].[last_nm],
        [PN].[first_nm],
        [PN].[middle_nm],
        [PN].[suffix],
        'DAD' AS [CODE]
    FROM
        [dbo].[int_person_name] AS [PN]
    WHERE
        [PN].[person_nm_id] = @dad_ent_id
        AND [PN].[recognize_nm_cd] = 'P'
        AND [active_sw] = 1;

    DROP TABLE [#TMP_MISC_CODE];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'p_Parents';

