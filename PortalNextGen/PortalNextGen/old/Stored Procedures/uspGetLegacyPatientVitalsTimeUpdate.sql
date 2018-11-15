CREATE PROCEDURE [old].[uspGetLegacyPatientVitalsTimeUpdate]
    (
        @PatientID     INT,
        @AfterDateTime DATETIME2(7)
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [ir].[ResultDateTime]
        FROM
            [Intesys].[Result] AS [ir]
        WHERE
            [ir].[PatientID] = @PatientID
            AND [ir].[ResultDateTime] > @AfterDateTime
        ORDER BY
            [ir].[ResultDateTime];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetLegacyPatientVitalsTimeUpdate';

