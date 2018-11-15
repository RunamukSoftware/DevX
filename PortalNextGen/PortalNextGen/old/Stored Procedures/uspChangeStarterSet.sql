CREATE PROCEDURE [old].[uspChangeStarterSet]
    (
        @LanguageCode VARCHAR(5),
        @Debug        BIT = 0
    )
AS
    BEGIN
        /*************************************************************************************************
        Procedure Name: Change_Starter_Set
            
        Parameters: 
            Language Column ex: fra --French, deu -- German, nld -- Dutch, etc
        Output Parameter: Null                  
        Purpose: To Change the UI from one Language to other, this procedure is Executed, to update the 
                 respective strings in respective columns. If we want to change the language from English 
                 to French, then we have to give 'FRA' as the parameter
        Tables Involved: int_misc_code, int_test_group, int_test_group_detail,
                         int_order_group, int_site_link, int_environment and int_starter_set
        Date of  Modification        :    30 June 2006                                                     
        Modification/Add: For localization of ICS, we need to implement some more strings from int_misc_code 
                          to complete the process. For this we have to included these strings in int_starter_set 
                          table for translation. After translation we have to update the relative strings in  
                          int_misc_code table. This modified procedure updates the relative fields in int_misc_code table.
  
                          Modified SQL Injections are Commented in format 
        **************************************************************************************************/

        SET NOCOUNT ON;

        DECLARE @SqlQuery VARCHAR(2000);

        -- Build an empty temp table
        SELECT
            [ss].[SetTypeCode],
            [ss].[Guid],
            [ss].[ID1],
            [ss].[ID2],
            [ss].[ID3],
            [ss].[Enu],
            [ss].[Enu] AS [ToLanguage]
        INTO
            [#StarterSet]
        FROM
            [Intesys].[StarterSet] AS [ss]
        WHERE
            1 = 0;

        -- Fill up temp table, [ToLanguage] column contains the value for the language we are going to
        SET @SqlQuery
            = '
SELECT [SetTypeCode], [GUID], [ID1], [ID2], [ID3], [enu], [' + @LanguageCode
              + '] AS [ToLanguage] FROM [Intesys].[starter_set];';

        IF (@Debug = 1)
            PRINT @SqlQuery;

        INSERT INTO [#StarterSet]
            (
                [SetTypeCode],
                [Guid],
                [ID1],
                [ID2],
                [ID3],
                [Enu],
                [ToLanguage]
            )
        EXEC (@SqlQuery);

        -- UPDATE the tables
        UPDATE
            [Intesys].[MiscellaneousCode]
        SET
            [KeystoneCode] = [ToLanguage]
        FROM
            [#StarterSet]
        WHERE
            [SetTypeCode] = N'GDS-U'
            AND [imc].[CodeID] = [ID1]
            AND [imc].[CodeID] = [ID2]
            AND [imc].[CodeID] = [ID3];

        UPDATE
            [Intesys].[MiscellaneousCode]
        SET
            [ShortDescription] = [ToLanguage]
        FROM
            [#StarterSet]
        WHERE
            [SetTypeCode] = N'GDS'
            AND [imc].[CodeID] = [ID1]
            AND [imc].[CodeID] = [ID2]
            AND [imc].[CodeID] = [ID3];

        UPDATE
            [Intesys].[MiscellaneousCode]
        SET
            [KeystoneCode] = [ToLanguage]
        FROM
            [#StarterSet]
        WHERE
            [SetTypeCode] = N'HL7-U'
            AND [imc].[CodeID] = [ID1]
            AND [imc].[CodeID] = [ID2]
            AND [imc].[CodeID] = [ID3];

        UPDATE
            [Intesys].[MiscellaneousCode]
        SET
            [ShortDescription] = [ToLanguage]
        FROM
            [#StarterSet]
        WHERE
            [SetTypeCode] = N'HL7'
            AND [imc].[CodeID] = [ID1]
            AND [imc].[CodeID] = [ID2]
            AND [imc].[CodeID] = [ID3];

        UPDATE
            [Intesys].[MiscellaneousCode]
        SET
            [ShortDescription] = [ToLanguage]
        FROM
            [#StarterSet]
        WHERE
            [SetTypeCode] = N'S5N'
            AND [imc].[CodeID] = [ID1]
            AND [imc].[CodeID] = [ID2]
            AND [imc].[CodeID] = [ID3];

        UPDATE
            [Intesys].[MiscellaneousCode]
        SET
            [KeystoneCode] = [ToLanguage]
        FROM
            [#StarterSet]
        WHERE
            [SetTypeCode] = N'S5N-U'
            AND [imc].[CodeID] = [ID1]
            AND [imc].[CodeID] = [ID2]
            AND [imc].[CodeID] = [ID3];

        UPDATE
            [Intesys].[MiscellaneousCode]
        SET
            [ShortDescription] = [ToLanguage]
        FROM
            [#StarterSet]
        WHERE
            [SetTypeCode] = N'SLOG'
            AND [imc].[CodeID] = [ID1]
            AND [imc].[CodeID] = [ID2]
            AND [imc].[CodeID] = [ID3];

        UPDATE
            [Intesys].[Organization]
        SET
            [OrganizationName] = [ToLanguage]
        FROM
            [#StarterSet]
        WHERE
            [SetTypeCode] = N'ORG'
            AND [int_organization].[OrganizationID] = [Guid];

        UPDATE
            [Intesys].[TestGroup]
        SET
            [NodeName] = ISNULL([ToLanguage], N'')
        FROM
            [#StarterSet]
        WHERE
            [SetTypeCode] = N'TG'
            AND [ID1] = [int_test_group].[NodeID];

        UPDATE
            [Intesys].[TestGroupDetail]
        SET
            [Name] = ISNULL([ToLanguage], N'')
        FROM
            [#StarterSet]
        WHERE
            [SetTypeCode] = N'TGD'
            AND [ID1] = [int_test_group_detail].[NodeID]
            AND ISNULL([ID2], -999) = ISNULL([int_test_group_detail].[univwsvcCodeID], -999)
            AND ISNULL([ID3], -999) = ISNULL([int_test_group_detail].[TestCodeID], -999);

        UPDATE
            [Intesys].[MiscellaneousCode]
        SET
            [ShortDescription] = ISNULL([ToLanguage], N'')
        FROM
            [#StarterSet]
        WHERE
            [SetTypeCode] = N'TGD'
            AND [ID2] = [imc].[CodeID]
            AND [ID3] IS NULL
            AND [imc].[CategoryCode] = 'USID';

        UPDATE
            [Intesys].[MiscellaneousCode]
        SET
            [ShortDescription] = ISNULL([ToLanguage], N'')
        FROM
            [#StarterSet]
        WHERE
            [SetTypeCode] = N'TGD'
            AND [ID2] IS NULL
            AND [ID3] = [imc].[CodeID]
            AND [imc].[CategoryCode] = 'ATST';

        UPDATE
            [Intesys].[OrderGroup]
        SET
            [NodeName] = ISNULL([ToLanguage], N'')
        FROM
            [#StarterSet]
        WHERE
            [SetTypeCode] = N'OG'
            AND [ID1] = [NodeID];

        UPDATE
            [Intesys].[MiscellaneousCode]
        SET
            [ShortDescription] = ISNULL([ToLanguage], N'')
        FROM
            [#StarterSet]
        WHERE
            [SetTypeCode] = N'OGD'
            AND [ID1] = [imc].[CodeID]
            AND [imc].[CategoryCode] = 'USID';

        UPDATE
            [Intesys].[SiteLink]
        SET
            [GroupName] = ISNULL([ToLanguage], N'')
        FROM
            [#StarterSet]
        WHERE
            [SetTypeCode] = N'SLG'
            AND [ID1] = [int_site_link].[group_rank];

        UPDATE
            [Intesys].[SiteLink]
        SET
            [display_name] = ISNULL([ToLanguage], N'')
        FROM
            [#StarterSet]
        WHERE
            [SetTypeCode] = N'SL'
            AND [Guid] = [int_site_link].[LinkID];

        UPDATE
            [Intesys].[Environment]
        SET
            [DisplayName] = ISNULL([ToLanguage], N'')
        FROM
            [#StarterSet]
        WHERE
            [SetTypeCode] = N'EL'
            AND [Guid] = [int_environment].[envwid];

        DROP TABLE [#StarterSet];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'To Change the UI from one Language to other, this procedure is Executed, to update the respective strings in respective columns. If we want to change the language from English to French, then we have to give ''FRA'' as the parameter.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspChangeStarterSet';

