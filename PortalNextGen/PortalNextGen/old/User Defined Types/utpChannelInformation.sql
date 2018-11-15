CREATE TYPE [old].[utpChannelInformation] AS TABLE (
    [ChannelInformationID] INT        NOT NULL,
    [PrintRequestID]       INT        NOT NULL,
    [ChannelIndex]         INT        NOT NULL,
    [IsPrimaryECG]         BIT        NOT NULL,
    [IsSecondaryECG]       BIT        NOT NULL,
    [IsNonWaveformType]    BIT        NOT NULL,
    [SampleRate]           INT        NULL,
    [Scale]                INT        NULL,
    [ScaleValue]           FLOAT (53) NULL,
    [ScaleMin]             FLOAT (53) NULL,
    [ScaleMax]             FLOAT (53) NULL,
    [ScaleTypeEnumValue]   INT        NULL,
    [Baseline]             INT        NULL,
    [YPointsPerUnit]       INT        NULL,
    [ChannelType]          INT        NOT NULL);

