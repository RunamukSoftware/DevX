CREATE PROCEDURE [old].[uspGetLegacyPatientVitalsTypes] (@PatientID INT)
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [Code].[CodeID]       AS [Type],
            [Code].[Code],
            [Code].[KeystoneCode] AS [UNITS]
        FROM
            [Intesys].[MiscellaneousCode] AS [Code]
            INNER JOIN
                (
                    SELECT DISTINCT
                        [ir].[TestCodeID]
                    FROM
                        [Intesys].[Result] AS [ir]
                    WHERE
                        [ir].[PatientID] = @PatientID
                )                         AS [resultCodeID]
                    ON [resultCodeID].[TestCodeID] = [Code].[CodeID];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetLegacyPatientVitalsTypes';

