CREATE PROCEDURE [old].[uspCheckCodeUnique]
    (
        @Value          NVARCHAR(20),
        @OrganizationID INT,
        @ParentID       INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            COUNT(*) AS [TotalCount]
        FROM
            [Intesys].[Organization] AS [io]
        WHERE
            [io].[OrganizationCode] = @Value
            AND [io].[OrganizationID] <> @OrganizationID
            AND [io].[ParentOrganizationID] = @ParentID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspCheckCodeUnique';

