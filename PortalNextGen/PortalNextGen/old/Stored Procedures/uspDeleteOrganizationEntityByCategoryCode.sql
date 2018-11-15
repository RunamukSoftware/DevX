CREATE PROCEDURE [old].[uspDeleteOrganizationEntityByCategoryCode]
    (
        @OrganizationID INT,
        @CategoryCode  CHAR(1)
    )
AS
    BEGIN
        SET NOCOUNT ON;

        DELETE
        [io]
        FROM
            [Intesys].[Organization] AS [io]
        WHERE
            [io].[OrganizationID] = @OrganizationID
            AND [io].[CategoryCode] = @CategoryCode;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspDeleteOrganizationEntityByCategoryCode';

