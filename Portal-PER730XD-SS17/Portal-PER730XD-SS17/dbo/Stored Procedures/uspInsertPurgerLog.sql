CREATE PROCEDURE [dbo].[uspInsertPurgerLog]
    (
    @ProcedureName NVARCHAR(128),
    @TableName NVARCHAR(128),
    @PurgeDate DATETIME2(7),
    @Parameters NVARCHAR(128),
    @ChunkSize INT,
    @Rows BIGINT,
    @ErrorNumber INT,
    @ErrorMessage NVARCHAR(MAX),
    @StartDateTimeUTC DATETIME2(7) = '1900-01-01T00:00:00.0000000' -- Default to extreme early date until all procedures are updated.
)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO [dbo].[PurgerLog] ([ProcedureName],
                                   [TableName],
                                   [PurgeDateTime],
                                   [Parameters],
                                   [ChunkSize],
                                   [Rows],
                                   [ErrorNumber],
                                   [ErrorMessage],
                                   [StartDateTimeUTC])
    VALUES (
           @ProcedureName, @TableName, @PurgeDate, @Parameters, @ChunkSize, @Rows, @ErrorNumber, @ErrorMessage, @StartDateTimeUTC
           );
END;
