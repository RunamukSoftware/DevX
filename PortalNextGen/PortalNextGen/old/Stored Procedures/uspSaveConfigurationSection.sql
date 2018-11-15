CREATE PROCEDURE [old].[uspSaveConfigurationSection]
    (
        @ApplicationName NVARCHAR(256),
        @SectionName     NVARCHAR(150),
        @SectionData     XML
    )
AS
    BEGIN
        SET NOCOUNT ON;

        IF EXISTS
            (
                SELECT
                    1
                FROM
                    [Configuration].[Configuration]
                WHERE
                    [ApplicationName] = @ApplicationName
                    AND [SectionName] = @SectionName
            )
            BEGIN
                UPDATE
                    [Configuration].[Configuration]
                SET
                    [SectionData] = @SectionData,
                    [UpdatedDateTime] = GETUTCDATE()
                WHERE
                    [ApplicationName] = @ApplicationName
                    AND [SectionName] = @SectionName;
            END;
        ELSE
            BEGIN
                INSERT INTO [Configuration].[Configuration]
                    (
                        [ApplicationName],
                        [SectionName],
                        [SectionData],
                        [UpdatedDateTime]
                    )
                VALUES
                    (
                        @ApplicationName, @SectionName, @SectionData, GETUTCDATE()
                    );
            END;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Used to save Configuration data', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspSaveConfigurationSection';

