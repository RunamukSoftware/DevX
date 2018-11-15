CREATE PROCEDURE [CEI].[uspUpdateLog]
    (
        @Status         INT,
        @Description    NVARCHAR(300),
        @EventID        INT,
        @SequenceNumber INT,
        @Client         NVARCHAR(50)
    )
AS
    BEGIN
        SET NOCOUNT ON;

        UPDATE
            [Intesys].[EventLog]
        SET
            [Status] = @Status,
            [Description] = @Description
        WHERE
            [EventID] = @EventID
            AND [SequenceNumber] = @SequenceNumber
            AND [Client] = @Client;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'CEI', @level1type = N'PROCEDURE', @level1name = N'uspUpdateLog';

