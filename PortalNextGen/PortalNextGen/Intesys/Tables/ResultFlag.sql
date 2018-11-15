CREATE TABLE [Intesys].[ResultFlag] (
    [ResultFlagID]     INT           IDENTITY (1, 1) NOT NULL,
    [FlagID]           INT           NOT NULL,
    [Flag]             NVARCHAR (10) NOT NULL,
    [DisplayFront]     NVARCHAR (10) NULL,
    [DisplayBack]      NVARCHAR (10) NULL,
    [BitmapIndexFront] INT           NULL,
    [BitmapIndexBack]  INT           NULL,
    [ColorForeground]  VARCHAR (20)  NULL,
    [ColorBackground]  VARCHAR (20)  NULL,
    [SystemID]         INT           NULL,
    [Comment]          NVARCHAR (30) NULL,
    [LegendRank]       INT           NOT NULL,
    [SeverityRank]     INT           NULL,
    [CreatedDateTime]  DATETIME2 (7) CONSTRAINT [DF_ResultFlag_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_ResultFlag_ResultFlagID] PRIMARY KEY CLUSTERED ([ResultFlagID] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_ResultFlag_Flag_SystemID]
    ON [Intesys].[ResultFlag]([Flag] ASC, [SystemID] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores the information about indication of abnormal result flags to be displayed by the front end. Whenever an abnormal result ''flag'' is sent by a feeder system identified by ''sys_entID'', the front end will use this table to decide if a text message is to be displayed in front or back of the result or the result is to be colored with the ''color'' or a bitmap is to be placed in front or back of the result.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'ResultFlag';

