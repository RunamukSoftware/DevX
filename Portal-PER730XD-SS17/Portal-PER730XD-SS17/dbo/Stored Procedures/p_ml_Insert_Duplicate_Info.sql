CREATE PROCEDURE [dbo].[p_ml_Insert_Duplicate_Info]
    (
     @Original_ID AS VARCHAR(20),
     @Duplicate_Id AS VARCHAR(20),
     @Original_Monitor AS VARCHAR(5),
     @Duplicate_Monitor AS VARCHAR(5)
    )
AS
BEGIN
    IF NOT EXISTS ( SELECT
                        [Original_ID]
                    FROM
                        [dbo].[ml_duplicate_info]
                    WHERE
                        [Original_ID] = @Original_ID
                        AND [Duplicate_Id] = @Duplicate_Id
                        AND [Original_Monitor] = @Original_Monitor
                        AND [Duplicate_Monitor] = @Duplicate_Monitor )
    BEGIN
        INSERT  INTO [dbo].[ml_duplicate_info]
                ([Original_ID],
                 [Duplicate_Id],
                 [Original_Monitor],
                 [Duplicate_Monitor]
                )
        VALUES
                (@Original_ID,
                 @Duplicate_Id,
                 @Original_Monitor,
                 @Duplicate_Monitor
                );
    END;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'p_ml_Insert_Duplicate_Info';

