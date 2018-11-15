CREATE PROCEDURE [Purger].[uspInsertLog]
    (
        @Procedure     NVARCHAR(128),
        @Table         NVARCHAR(128),
        @PurgeDate     DATETIME2(7),
        @Parameters    NVARCHAR(255),
        @ChunkSize     INT,
        @Rows          INT,
        @ErrorNumber   INT,
        @ErrorMessage  NVARCHAR(MAX),
        @StartDateTime DATETIME2(7)
    )
AS
    BEGIN
        SET NOCOUNT ON;

        -- Default to extreme early date until all procedures are updated.
        IF (@StartDateTime IS NULL)
            SET @StartDateTime = CAST('1900-01-01T00:00:00.0000000' AS DATETIME2(7));


        INSERT INTO [Purger].[Log]
            (
                [Procedure],
                [Table],
                [PurgeDate],
                [Parameters],
                [ChunkSize],
                [Rows],
                [ErrorNumber],
                [ErrorMessage],
                [StartDateTime]
            )
        VALUES
            (
                @Procedure,
                @Table,
                @PurgeDate,
                @Parameters,
                @ChunkSize,
                @Rows,
                @ErrorNumber,
                @ErrorMessage,
                @StartDateTime
            );
    END;