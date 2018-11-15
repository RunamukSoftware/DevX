CREATE PROCEDURE [old].[uspDeleteSendSystem] (@SystemID INT)
AS
    BEGIN
        SET NOCOUNT ON;

        DELETE FROM
        [Intesys].[SendSystem]
        WHERE
            [SystemID] = @SystemID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspDeleteSendSystem';

