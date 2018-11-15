CREATE PROCEDURE [HL7].[uspUpdateMedicalRecordNumberInformation]
    (
        @PatientID            INT,
        @MedicalRecordNumber1 NVARCHAR(30),
        @MedicalRecordNumber2 NVARCHAR(30)
    )
AS
    BEGIN
        SET NOCOUNT ON;

        UPDATE
            [Intesys].[MedicalRecordNumberMap]
        SET
            [MedicalRecordNumberXID] = @MedicalRecordNumber1,
            [MedicalRecordNumberXID2] = @MedicalRecordNumber2
        WHERE
            [PatientID] = @PatientID
            AND [MergeCode] <> 'L';
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'PROCEDURE', @level1name = N'uspUpdateMedicalRecordNumberInformation';

