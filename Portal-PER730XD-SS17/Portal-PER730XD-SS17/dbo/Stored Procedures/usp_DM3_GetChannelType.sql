CREATE PROCEDURE [dbo].[usp_DM3_GetChannelType]
AS
BEGIN
    SELECT
        [channel_type_id],
        [channel_code],
        [label]
    FROM
        [dbo].[int_channel_type];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DM3_GetChannelType';

