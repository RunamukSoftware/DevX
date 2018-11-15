CREATE PROCEDURE [old].[uspSaveEventVitals]
    (
        @PatientID            INT,
        @EventID              INT,
        @GlobalDataSystemCode NVARCHAR(80),
        @ResultDateTime       DATETIME2(7),
        @ResultValue          NVARCHAR(200)
    )
AS
    BEGIN
        SET NOCOUNT ON;

        INSERT INTO [Intesys].[SavedEventVital]
            (
                [PatientID],
                [EventID],
                [GlobalDataSystemCode],
                [ResultDateTime],
                [ResultValue]
            )
        VALUES
            (
                @PatientID, @EventID, @GlobalDataSystemCode, @ResultDateTime, @ResultValue
            );
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspSaveEventVitals';

