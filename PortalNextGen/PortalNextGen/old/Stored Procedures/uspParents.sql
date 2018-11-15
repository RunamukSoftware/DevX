CREATE PROCEDURE [old].[uspParents] (@PersonID INT)
AS /*------------------------------------------------------------
* $ID: p_parents.sql,v 1.4 1997/09/10 16:19:14 dipti Exp $
*
* Select the record with relationship code of MOTHER and
* role code of a Next Of Kin if one exists otherwise (b Guardian 
* Since there could be multiple records with same role code and
* relationship code id, select the one with min desc key.
* The use the ent id to get the mother's name 
*------------------------------------------------------------*/
    BEGIN
        SET NOCOUNT ON;

        DECLARE
            @mom_entID INT,
            @dad_entID INT;

        SELECT
            [imc].[CodeID],
            [imc].[KeystoneCode]
        INTO
            [#MiscellaneousCode]
        FROM
            [Intesys].[MiscellaneousCode] AS [imc]
        WHERE
            [imc].[KeystoneCode] IN (
                                        N'MOTHER', N'FATHER'
                                    )
            AND [imc].[CategoryCode] = 'RELA';

        SELECT
            @mom_entID = [N].[NextOfKinPersonID]
        FROM
            [Intesys].[NextOfKin]      AS [N]
            INNER JOIN
                [#MiscellaneousCode] AS [t]
                    ON [N].[RelationshipCodeID] = [t].[CodeID]
        WHERE
            [N].[PatientID] = @PersonID
            AND [t].[KeystoneCode] = N'MOTHER'
        ORDER BY
            [N].[SequenceNumber] DESC;

        IF (@mom_entID = NULL)
            BEGIN
                SELECT
                    @mom_entID = [G].[GuarantorPersonID]
                FROM
                    [Archive].[Guarantor] AS [G]
                    INNER JOIN
                        [#MiscellaneousCode]  AS [t]
                            ON [G].[RelationshipCodeID] = [t].[CodeID]
                WHERE
                    [G].[PatientID] = @PersonID
                    AND [t].[int_keystone_code] = N'MOTHER'
                ORDER BY
                    [G].[SequenceNumber] DESC;
            END;

        /* select the one with max role_code and msx SequenceNumber*/
        SELECT
            @dad_entID = [N].[NextOfKinPersonID]
        FROM
            [Intesys].[NextOfKin]      AS [N]
            INNER JOIN
                [#MiscellaneousCode] AS [t]
                    ON [N].[RelationshipCodeID] = [t].[CodeID]
        WHERE
            [N].[PatientID] = @PersonID
            AND [t].[KeystoneCode] = N'FATHER'
        ORDER BY
            [N].[SequenceNumber] DESC;

        IF (@dad_entID = NULL)
            BEGIN
                SELECT
                    @dad_entID = [G].[GuarantorPersonID]
                FROM
                    [Archive].[Guarantor] AS [G]
                    INNER JOIN
                        [#MiscellaneousCode]  AS [t]
                            ON [G].[RelationshipCodeID] = [t].[CodeID]
                WHERE
                    [G].[PatientID] = @PersonID
                    AND [t].[int_keystone_code] = N'FATHER'
                ORDER BY
                    [G].[SequenceNumber] DESC;
            END;

        /* select the one with max role_code and min desc_key */
        SELECT
            [PN].[LastName],
            [PN].[FirstName],
            [PN].[MiddleName],
            [PN].[Suffix],
            'MOM' AS [CODE]
        FROM
            [Intesys].[PersonName] AS [PN]
        WHERE
            [PN].[PersonNameID] = @mom_entID
            AND [PN].[RecognizeNameCode] = 'P'
            AND [PN].[ActiveSwitch] = 1
        UNION
        SELECT
            [PN].[LastName],
            [PN].[FirstName],
            [PN].[MiddleName],
            [PN].[Suffix],
            'DAD' AS [CODE]
        FROM
            [Intesys].[PersonName] AS [PN]
        WHERE
            [PN].[PersonNameID] = @dad_entID
            AND [PN].[RecognizeNameCode] = 'P'
            AND [PN].[ActiveSwitch] = 1;

        DROP TABLE [#MiscellaneousCode];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspParents';

