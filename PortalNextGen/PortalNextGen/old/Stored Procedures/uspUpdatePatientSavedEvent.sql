CREATE PROCEDURE [old].[uspUpdatePatientSavedEvent]
    (
        @PatientID INT,
        @EventID   INT,
        @Title     NVARCHAR(50),
        @Comment   NVARCHAR(200)
    )
AS
    BEGIN
        SET NOCOUNT ON;

        UPDATE
            [Intesys].[PatientSavedEvent]
        SET
            [Title] = @Title,
            [Comment] = @Comment
        WHERE
            [PatientID] = @PatientID
            AND [EventID] = @EventID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspUpdatePatientSavedEvent';

