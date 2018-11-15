CREATE PROCEDURE [old].[uspUgTest]
    (
        @Table  VARCHAR(80),
        @Column VARCHAR(80),
        @Debug  BIT = 0
    )
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE @SqlQuery VARCHAR(MAX);

        SET @SqlQuery = 'SELECT ' + @Column + ' FROM ' + @Table;

        IF (@Debug = 1)
            PRINT @SqlQuery;

        EXEC (@SqlQuery);
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspUgTest';

