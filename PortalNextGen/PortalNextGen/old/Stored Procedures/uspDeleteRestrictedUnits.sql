CREATE PROCEDURE [old].[uspDeleteRestrictedUnits] (@RoleID INT)
AS
    BEGIN
        SET NOCOUNT ON;

        DELETE FROM
        [CDR].[RestrictedOrganization]
        WHERE
            [RoleID] = @RoleID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Delete all the restricted organizations based on role ID.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspDeleteRestrictedUnits';

