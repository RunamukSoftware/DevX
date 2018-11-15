CREATE PROCEDURE [DM3].[uspGetChannelType]
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [ict].[ChannelTypeID],
            [ict].[ChannelCode],
            [ict].[Label]
        FROM
            [Intesys].[ChannelType] AS [ict];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'DM3', @level1type = N'PROCEDURE', @level1name = N'uspGetChannelType';

