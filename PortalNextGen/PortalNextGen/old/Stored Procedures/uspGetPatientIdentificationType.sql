CREATE PROCEDURE [old].[uspGetPatientIdentificationType]
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [ig].[PatientIDType] AS [IdentificationType]
        FROM
            [Intesys].[Gateway] AS [ig]
        WHERE
            [ig].[GatewayType] = 'UVN';
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Gets the Patient Identification for the ICS Application.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetPatientIdentificationType';

