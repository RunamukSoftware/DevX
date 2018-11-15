CREATE PROCEDURE [DM3].[uspAddResults]
    (
        @ResultID    INT          = NULL,
        @PatientID   INT          = NULL,
        @OrderID     INT          = NULL,
        @Result_usid INT          = NULL,
        @TestCodeID  INT          = NULL,
        @BTime       DATETIME2(7) = NULL,
        @BDateTime   DATETIME2(7) = NULL,
        @ResultVal   NVARCHAR(50) = NULL
    )
AS
    BEGIN
        SET NOCOUNT ON;

        INSERT INTO [Intesys].[Result]
            (
                [ResultID],
                [PatientID],
                [OrderID],
                [TestCodeID],
                [ObservationStartDateTime],
                [ResultDateTime],
                [ValueTypeCode],
                [ResultValue],
                [ModifiedDateTime],
                [HasHistory],
                [IsHistory],
                [MonitorSwitch]
            )
        VALUES
            (
                @ResultID, @PatientID, @OrderID, @TestCodeID, @BTime, @BDateTime, N'NM', @ResultVal, @BTime, 0, 0, 1
            );
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Add or Update Encounter Table values in DM3 Loader.', @level0type = N'SCHEMA', @level0name = N'DM3', @level1type = N'PROCEDURE', @level1name = N'uspAddResults';

