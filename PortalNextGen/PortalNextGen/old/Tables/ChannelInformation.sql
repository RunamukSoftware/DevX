CREATE TABLE [old].[ChannelInformation] (
    [ChannelInformationID] INT           IDENTITY (1, 1) NOT NULL,
    [PrintRequestID]       INT           NOT NULL,
    [ChannelIndex]         INT           NOT NULL,
    [IsPrimaryECG]         BIT           NOT NULL,
    [IsSecondaryECG]       BIT           NOT NULL,
    [IsNonWaveformType]    BIT           NOT NULL,
    [SampleRate]           INT           NULL,
    [Scale]                INT           NULL,
    [ScaleValue]           FLOAT (53)    NULL,
    [ScaleMin]             FLOAT (53)    NULL,
    [ScaleMax]             FLOAT (53)    NULL,
    [ScaleTypeEnumValue]   INT           NULL,
    [Baseline]             INT           NULL,
    [YPointsPerUnit]       INT           NULL,
    [ChannelTypeID]        INT           NOT NULL,
    [CreatedDateTime]      DATETIME2 (7) CONSTRAINT [DF_ChannelInformation_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_ChannelInformation_ChannelInformationID] PRIMARY KEY CLUSTERED ([ChannelInformationID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_ChannelInformation_ChannelType_ChannelTypeID] FOREIGN KEY ([ChannelTypeID]) REFERENCES [Intesys].[ChannelType] ([ChannelTypeID]),
    CONSTRAINT [FK_ChannelInformation_PrintRequest_PrintRequestID] FOREIGN KEY ([PrintRequestID]) REFERENCES [old].[PrintRequest] ([PrintRequestID])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'TABLE', @level1name = N'ChannelInformation';

