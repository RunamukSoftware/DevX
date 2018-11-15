CREATE PROCEDURE [dbo].[p_Test_Groups] (@node_id INT)
AS
BEGIN
    SET NOCOUNT ON;
-- TG - code commented out due to missing table cdr_test_group
    --DECLARE @level INT = 0;

    --SELECT
    --    [node_id],
    --    [rank],
    --    [parent_node_id],
    --    [node_name],
    --    @level AS [LEVEL]
    --INTO
    --    [#TMP_NODES]
    --FROM
    --    [dbo].[cdr_test_group] AS [ctg]
    --WHERE
    --    [node_id] = @node_id;

    --WHILE (@@ROWCOUNT <> 0)
    --BEGIN
    --    SET @level += 1;

    --    INSERT  INTO [#TMP_NODES]
    --    SELECT
    --        [node_id],
    --        [rank],
    --        [parent_node_id],
    --        [node_name],
    --        @level
    --    FROM
    --        [dbo].[cdr_test_group] AS [ctg]
    --    WHERE
    --        [parent_node_id] IN (SELECT
    --                                [node_id]
    --                             FROM
    --                                [#TMP_NODES])
    --        AND [node_id] NOT IN (SELECT
    --                                [node_id]
    --                              FROM
    --                                [#TMP_NODES]);
    --END;

    --SELECT
    --    [LEVEL]
    --FROM
    --    [#TMP_NODES]
    --ORDER BY
    --    [rank];

    --DROP TABLE [#TMP_NODES];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'p_Test_Groups';

