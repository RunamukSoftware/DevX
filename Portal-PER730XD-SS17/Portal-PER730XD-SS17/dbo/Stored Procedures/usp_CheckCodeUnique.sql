CREATE PROCEDURE [dbo].[usp_CheckCodeUnique]
    (
     @value NVARCHAR(20),
     @orgID UNIQUEIDENTIFIER,
     @parentID UNIQUEIDENTIFIER
    )
AS
BEGIN
    SELECT
        COUNT(*) AS [TotalCount]
    FROM
        [dbo].[int_organization]
    WHERE
        [organization_cd] = @value
        AND [organization_id] <> @orgID
        AND [parent_organization_id] = @parentID;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_CheckCodeUnique';

