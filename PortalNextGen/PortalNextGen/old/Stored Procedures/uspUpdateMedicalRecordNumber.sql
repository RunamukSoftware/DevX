CREATE PROCEDURE [old].[uspUpdateMedicalRecordNumber]
    (
        @MedicalRecordNumberXID  NVARCHAR(30),
        @MedicalRecordNumberXID2 NVARCHAR(30),
        @PatientID               INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        UPDATE
            [Intesys].[MedicalRecordNumberMap]
        SET
            [MedicalRecordNumberXID] = @MedicalRecordNumberXID,
            [MedicalRecordNumberXID2] = @MedicalRecordNumberXID2
        WHERE
            [PatientID] = @PatientID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspUpdateMedicalRecordNumber';

