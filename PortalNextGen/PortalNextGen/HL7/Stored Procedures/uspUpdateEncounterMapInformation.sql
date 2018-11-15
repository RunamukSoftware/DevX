CREATE PROCEDURE [HL7].[uspUpdateEncounterMapInformation]
    (
        @EncounterID INT,
        @AccountID   INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        UPDATE
            [Intesys].[EncounterMap]
        SET
            [AccountID] = @AccountID
        WHERE
            [EncounterID] = @EncounterID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'PROCEDURE', @level1name = N'uspUpdateEncounterMapInformation';

