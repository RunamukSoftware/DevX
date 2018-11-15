CREATE PROCEDURE [old].[uspInsertSendingSystemInformation]
    (
        @SystemID       INT,
        @OrganizationID INT,
        @Code           NVARCHAR(180),
        @Description    NVARCHAR(180)
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
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Insert the sending system details.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspInsertSendingSystemInformation';

