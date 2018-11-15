CREATE PROCEDURE [old].[uspInsertSendSystemDetails]
    (
        @SystemID       INT,
        @OrganizationID INT,
        @Code           NVARCHAR(30),
        @Description    NVARCHAR(80)
    )
AS
    BEGIN
        SET NOCOUNT ON;

        INSERT INTO [Intesys].[SendSystem]
            (
                [SystemID],
                [OrganizationID],
                [Code],
                [Description]
            )
        VALUES
            (
                @SystemID, @OrganizationID, @Code, @Description
            );
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspInsertSendSystemDetails';

