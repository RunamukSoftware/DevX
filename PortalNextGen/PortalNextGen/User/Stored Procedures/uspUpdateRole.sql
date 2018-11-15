CREATE PROCEDURE [User].[uspUpdateRole]
    (
        @RoleID      INT,
        @Name        NVARCHAR(32),
        @Description NVARCHAR(255),
        @XmlData     XML
    )
AS
    BEGIN
        SET NOCOUNT ON;

        UPDATE
            [User].[Role]
        SET
            [Name] = @Name,
            [Description] = @Description
        WHERE
            [RoleID] = @RoleID;

        UPDATE
            [Intesys].[Security]
        SET
            [XmlData] = @XmlData
        WHERE
            [RoleID] = @RoleID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Update Role and Security tables', @level0type = N'SCHEMA', @level0name = N'User', @level1type = N'PROCEDURE', @level1name = N'uspUpdateRole';

