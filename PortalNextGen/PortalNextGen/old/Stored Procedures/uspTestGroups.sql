CREATE PROCEDURE [old].[uspTestGroups] (@NodeID INT)
AS
    BEGIN
        SET NOCOUNT ON;

    -- TG - code commented out due to missing table cdr_test_group
    --DECLARE @level INT = 0;

    --SELECT
    --    [NodeID],
    --    [Rank],
    --    [ParentNodeID],
    --    [NodeName],
    --    @level AS [LEVEL]
    --INTO
    --    [#Nodes]
    --FROM
    --    [old].[cdr_test_group] AS [ctg]
    --WHERE
    --    [NodeID] = @NodeID;

    --WHILE (@@ROWCOUNT <> 0)
    --BEGIN
    --    SET @level += 1;

    --    INSERT  INTO [#Nodes]
    --    SELECT
    --        [NodeID],
    --        [Rank],
    --        [ParentNodeID],
    --        [NodeName],
    --        @level
    --    FROM
    --        [old].[cdr_test_group] AS [ctg]
    --    WHERE
    --        [ParentNodeID] IN (SELECT
    --                                [NodeID]
    --                             FROM
    --                                [#Nodes])
    --        AND [NodeID] NOT IN (SELECT
    --                                [NodeID]
    --                              FROM
    --                                [#Nodes]);
    --END;

    --SELECT
    --    [LEVEL]
    --FROM
    --    [#Nodes]
    --ORDER BY
    --    [Rank];

    --DROP TABLE [#Nodes];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspTestGroups';

