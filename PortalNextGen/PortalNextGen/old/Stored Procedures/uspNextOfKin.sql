CREATE PROCEDURE [old].[uspNextOfKin] (@PatientID INT)
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [N].[PatientID],
            [N].[NotifySequenceNumber]                      AS [priority],
            [N].[RelationshipCodeID],
            [a].[Line1Description]                                 AS [ADDR1],
            [a].[Line2Description]                                 AS [ADDR2],
            [a].[Line3Description]                                 AS [ADDR3],
            [a].[City]                                   AS [CITY],
            [a].[StateCode]                                AS [STATE],
            [a].[PostalCode]                                  AS [ZIPCODE],
            [a].[CountryCodeID],
            [P].[LastName]                                  AS [LastName],
            [P].[FirstName]                                 AS [FirstName],
            [P].[MiddleName]                                AS [MiddleName],
            [T1].[TelephoneNumber] + [T1].[ExtensionNumber] AS [HOME_PHONE],
            [T2].[TelephoneNumber] + [T2].[ExtensionNumber] AS [BUSINESS_PHONE]
        FROM
            [Intesys].[NextOfKin]            AS [N]
            INNER JOIN
                [Intesys].[PersonName] AS [P]
                    ON [P].[PersonNameID] = [N].[NextOfKinPersonID]
            RIGHT OUTER JOIN
                [Intesys].[Address]    AS [a]
                    ON [N].[NextOfKinPersonID] = [a].[AddressID]
            RIGHT OUTER JOIN
                [Intesys].[Telephone]  AS [T1]
                    ON [N].[NextOfKinPersonID] = [T1].[PhoneID]
            RIGHT OUTER JOIN
                [Intesys].[Telephone]  AS [T2]
                    ON [N].[NextOfKinPersonID] = [T2].[PhoneID]
        WHERE
            [P].[RecognizeNameCode] = 'P'
            AND [N].[ActiveFlag] = 1
            AND [N].[PatientID] = @PatientID
            AND [T1].[PhoneLocationCode] = 'R'
            AND [T1].[PhoneTypeCode] = 'V'
            AND [T1].[SequenceNumber] =
                (
                    SELECT
                        MIN([t].[SequenceNumber])
                    FROM
                        [Intesys].[Telephone] AS [t]
                    WHERE
                        [t].[PhoneLocationCode] = 'R'
                        AND [t].[PhoneID] = [N].[NextOfKinPersonID]
                        AND [t].[PhoneTypeCode] = 'V'
                )
            AND [T2].[PhoneLocationCode] = 'B'
            AND [T2].[PhoneTypeCode] = 'V'
            AND [T2].[SequenceNumber] =
                (
                    SELECT
                        MIN([t3].[SequenceNumber])
                    FROM
                        [Intesys].[Telephone] AS [t3]
                    WHERE
                        [t3].[PhoneLocationCode] = 'B'
                        AND [t3].[PhoneID] = [N].[NextOfKinPersonID]
                        AND [t3].[PhoneTypeCode] = 'V'
                )
        ORDER BY
            [priority];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspNextOfKin';

