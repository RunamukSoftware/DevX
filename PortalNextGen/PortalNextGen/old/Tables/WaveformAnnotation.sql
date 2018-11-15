CREATE TABLE [old].[WaveformAnnotation] (
    [WaveformAnnotationID] INT           IDENTITY (1, 1) NOT NULL,
    [PrintRequestID]       INT           NOT NULL,
    [ChannelIndex]         INT           NOT NULL,
    [Annotation]           VARCHAR (MAX) NOT NULL,
    [CreatedDateTime]      DATETIME2 (7) CONSTRAINT [DF_WaveformAnnotation_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_WaveformAnnotation_WaveformAnnotationID] PRIMARY KEY CLUSTERED ([WaveformAnnotationID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_WaveformAnnotation_PrintRequest_PrintRequestID] FOREIGN KEY ([PrintRequestID]) REFERENCES [old].[PrintRequest] ([PrintRequestID])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'TABLE', @level1name = N'WaveformAnnotation';

