CREATE PROCEDURE [old].[uspUpdatePatient]
    (
        @DateOfBirth  DATE,
        @GenderCodeID INT,
        @PatientID    INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        UPDATE
            [Intesys].[Patient]
        SET
            [DateOfBirth] = @DateOfBirth,
            [GenderCodeID] = @GenderCodeID
        WHERE
            [PatientID] = @PatientID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspUpdatePatient';

