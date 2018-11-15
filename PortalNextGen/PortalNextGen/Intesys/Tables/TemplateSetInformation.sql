CREATE TABLE [Intesys].[TemplateSetInformation] (
    [TemplateSetInformationID] INT           IDENTITY (1, 1) NOT NULL,
    [UserID]                   INT           NOT NULL,
    [PatientID]                INT           NOT NULL,
    [TemplateSetIndex]         INT           NOT NULL,
    [lead_one]                 INT           NOT NULL,
    [lead_two]                 INT           NOT NULL,
    [number_of_bins]           INT           NOT NULL,
    [number_of_templates]      INT           NOT NULL,
    [AnalysisTimeID]           INT           NOT NULL,
    [CreatedDateTime]          DATETIME2 (7) CONSTRAINT [DF_TemplateSetInformation_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_TemplateSetInformation_TemplateSetInformationID] PRIMARY KEY CLUSTERED ([TemplateSetInformationID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_TemplateSetInformation_AnalysisTime_AnalysisTimeID] FOREIGN KEY ([AnalysisTimeID]) REFERENCES [old].[AnalysisTime] ([AnalysisTimeID]),
    CONSTRAINT [FK_TemplateSetInformation_Patient_PatientID] FOREIGN KEY ([PatientID]) REFERENCES [old].[Patient] ([PatientID]),
    CONSTRAINT [FK_TemplateSetInformation_User_UserID] FOREIGN KEY ([UserID]) REFERENCES [User].[User] ([UserID])
);


GO
CREATE NONCLUSTERED INDEX [IX_TemplateSetInformation_UserID_PatientID_TemplateSetIndex]
    ON [Intesys].[TemplateSetInformation]([UserID] ASC, [PatientID] ASC, [TemplateSetIndex] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Contains template set information. Can have up to 4 template sets per user/patient analysis.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'TemplateSetInformation';

