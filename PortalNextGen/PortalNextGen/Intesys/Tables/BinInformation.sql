CREATE TABLE [Intesys].[BinInformation] (
    [BinInformationID]         INT             IDENTITY (1, 1) NOT NULL,
    [UserID]                   INT             NOT NULL,
    [PatientID]                INT             NOT NULL,
    [TemplateSetIndex]         INT             NOT NULL,
    [TemplateIndex]            INT             NOT NULL,
    [TemplateSetInformationID] INT             NOT NULL,
    [BinNumber]                INT             NOT NULL,
    [Source]                   INT             NOT NULL,
    [BeatCount]                INT             NOT NULL,
    [FirstBeatNumber]          INT             NOT NULL,
    [NonIgnoredCount]          INT             NOT NULL,
    [FirstNonIgnoredBeat]      INT             NOT NULL,
    [iso_offset]               INT             NOT NULL,
    [st_offset]                INT             NOT NULL,
    [i_point]                  INT             NOT NULL,
    [j_point]                  INT             NOT NULL,
    [st_class]                 INT             NOT NULL,
    [SinglesBin]               INT             NOT NULL,
    [EditBin]                  INT             NOT NULL,
    [SubclassNumber]           INT             NOT NULL,
    [BinImage]                 VARBINARY (MAX) NULL,
    [CreatedDateTime]          DATETIME2 (7)   CONSTRAINT [DF_BinInformation_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_BinInformation_BinInformationID] PRIMARY KEY CLUSTERED ([BinInformationID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_BinInformation_Patient_PatientID] FOREIGN KEY ([PatientID]) REFERENCES [old].[Patient] ([PatientID]),
    CONSTRAINT [FK_BinInformation_TemplateSetInformation_TemplateSetInformationID] FOREIGN KEY ([TemplateSetInformationID]) REFERENCES [Intesys].[TemplateSetInformation] ([TemplateSetInformationID]),
    CONSTRAINT [FK_BinInformation_User_UserID] FOREIGN KEY ([UserID]) REFERENCES [User].[User] ([UserID])
);


GO
CREATE NONCLUSTERED INDEX [IX_BinInformation_UserID_PatientID_TemplateSetIndex_TemplateIndex]
    ON [Intesys].[BinInformation]([UserID] ASC, [PatientID] ASC, [TemplateSetIndex] ASC, [TemplateIndex] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Contains template/bin information. It contains 2 additional PKs:  template_set_index and template_index. The template_set_index column will refer back to a template set in the int_template_set_info table. This table will contain multiple rows per user/patient analysis (one row for each template). I think we should consider renaming it to int_template_info (or some variation of that).', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'BinInformation';

