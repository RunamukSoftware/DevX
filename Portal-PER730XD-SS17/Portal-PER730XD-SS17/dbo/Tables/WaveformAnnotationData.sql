CREATE TABLE [dbo].[WaveformAnnotationData] (
    [Id]             UNIQUEIDENTIFIER NOT NULL,
    [PrintRequestId] UNIQUEIDENTIFIER NOT NULL,
    [ChannelIndex]   INT              NOT NULL,
    [Annotation]     VARCHAR (MAX)    NOT NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'WaveformAnnotationData';

