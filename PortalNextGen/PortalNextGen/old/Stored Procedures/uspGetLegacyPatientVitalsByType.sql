CREATE PROCEDURE [old].[uspGetLegacyPatientVitalsByType]
    (
        @PatientID INT,
        @Type      INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [ir].[ResultValue],
            [ir].[ResultID],
            [ir].[ResultDateTime],
            CAST(1 AS BIT) AS [IsResultLocalized]
        FROM
            [Intesys].[Result]                AS [ir]
            INNER JOIN
                [Intesys].[MiscellaneousCode] AS [Code]
                    ON [ir].[TestCodeID] = [Code].[CodeID]
        WHERE
            [ir].[PatientID] = @PatientID
            AND [Code].[CodeID] = @Type
        ORDER BY
            [ir].[ResultDateTime] ASC;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get the vitals of one patient for one given Type, only from the legacy tables.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetLegacyPatientVitalsByType';

