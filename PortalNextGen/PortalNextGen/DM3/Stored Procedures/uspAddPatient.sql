CREATE PROCEDURE [DM3].[uspAddPatient]
    (
        @PatientID       INT,
        @DateOfBirth     DATE      = NULL,
        @Height          FLOAT(53) = NULL,
        @Weight          FLOAT(53) = NULL,
        @BodySurfaceArea FLOAT(53) = NULL
    )
AS
    BEGIN
        SET NOCOUNT ON;

        INSERT INTO [Intesys].[Patient]
            (
                [PatientID],
                [NewPatientID],
                [DateOfBirth],
                [GenderCodeID],
                [Height],
                [Weight],
                [BodySurfaceArea]
            )
        VALUES
            (
                @PatientID, NULL, @DateOfBirth, NULL, @Height, @Weight, @BodySurfaceArea
            );
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'DM3', @level1type = N'PROCEDURE', @level1name = N'uspAddPatient';

