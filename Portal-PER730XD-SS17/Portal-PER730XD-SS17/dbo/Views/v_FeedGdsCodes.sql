
CREATE VIEW [dbo].[v_FeedGdsCodes]
AS
SELECT distinct TypeId as FeedTypeId, Value as GdsCode
  FROM [dbo].[v_MetaData]
  where Name='GdsCode'

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<View description here>', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'v_FeedGdsCodes';

