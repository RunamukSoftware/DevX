CREATE PROCEDURE [old].[uspRestrictUnit]
    (
        @RoleID         INT,
        @OrganizationID INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        INSERT INTO [CDR].[RestrictedOrganization]
            (
                [RoleID],
                [OrganizationID]
            )
        VALUES
            (
                @RoleID, @OrganizationID
            );
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Save the restricted organization of a role.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspRestrictUnit';

