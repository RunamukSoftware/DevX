CREATE PROCEDURE [Intesys].[uspUpdateOrganization]
    (
        @OrganizationCode NVARCHAR(20),
        @OrganizationName NVARCHAR(50),
        @OrganizationID   INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        UPDATE
            [Intesys].[Organization]
        SET
            [OrganizationCode] = @OrganizationCode,
            [OrganizationName] = @OrganizationName
        WHERE
            [OrganizationID] = @OrganizationID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'PROCEDURE', @level1name = N'uspUpdateOrganization';

