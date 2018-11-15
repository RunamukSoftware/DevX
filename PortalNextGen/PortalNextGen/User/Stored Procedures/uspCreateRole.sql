CREATE PROCEDURE [User].[uspCreateRole]
    (
        @RoleID      INT,
        @Name        NVARCHAR(32),
        @Description NVARCHAR(255),
        @XmlData     XML
    )
AS
    BEGIN
        SET NOCOUNT ON;

        INSERT INTO [User].[Role]
            (
                [RoleID],
                [Name],
                [Description]
            )
        VALUES
            (
                @RoleID, @Name, @Description
            );

        INSERT INTO [Intesys].[Security]
            (
                [RoleID],
                [XmlData]
            )
        VALUES
            (
                @RoleID, @XmlData
            );
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Create a role.', @level0type = N'SCHEMA', @level0name = N'User', @level1type = N'PROCEDURE', @level1name = N'uspCreateRole';

