CREATE PROCEDURE [CEI].[uspInsertLog]
    (
        @EventID        INT,
        @PatientID      INT          = NULL,
        @Type           NVARCHAR(30),
        @EventDateTime  DATETIME2(7),
        @SequenceNumber INT,
        @Client         NVARCHAR(50),
        @Description    NVARCHAR(300),
        @Status         INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        INSERT INTO [Intesys].[EventLog]
            (
                [EventID],
                [PatientID],
                [Type],
                [EventDateTime],
                [SequenceNumber],
                [Client],
                [Description],
                [Status]
            )
        VALUES
            (
                @EventID, @PatientID, @Type, @EventDateTime, @SequenceNumber, @Client, @Description, @Status
            );
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'CEI', @level1type = N'PROCEDURE', @level1name = N'uspInsertLog';

