CREATE PROCEDURE [old].[uspGetLegacyPatientStartftFromVitals] (@PatientID INT)
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            MIN([ir].[ResultDateTime]) AS [StartDateTime]
        FROM
            [Intesys].[Result] AS [ir]
        WHERE
            [ir].[PatientID] = @PatientID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetLegacyPatientStartftFromVitals';

