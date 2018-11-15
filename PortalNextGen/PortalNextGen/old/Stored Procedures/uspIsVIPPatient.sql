CREATE PROCEDURE [old].[uspIsVIPPatient] (@MedicalRecordNumberXID NVARCHAR(30))
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [ie].[VipSwitch]
        FROM
            [Intesys].[Encounter]                  AS [ie]
            INNER JOIN
                [Intesys].[MedicalRecordNumberMap] AS [imrnm]
                    ON [imrnm].[PatientID] = [ie].[PatientID]
        WHERE
            [imrnm].[MedicalRecordNumberXID] = @MedicalRecordNumberXID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspIsVIPPatient';

