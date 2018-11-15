CREATE TABLE [Archive].[MasterPatientIndexDecisionLog] (
    [MasterPatientIndexDecisionLogID] INT           IDENTITY (1, 1) NOT NULL,
    [CandidateID]                     INT           NOT NULL,
    [MatchedID]                       INT           NOT NULL,
    [Score]                           INT           NOT NULL,
    [ModifiedDateTime]                DATETIME2 (7) NOT NULL,
    [StatusCode]                      VARCHAR (3)   NULL,
    [CreatedDateTime]                 DATETIME2 (7) CONSTRAINT [DF_MasterPatientIndexDecisionLog_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_MasterPatientIndexDecisionLog_MasterPatientIndexDecisionLogID] PRIMARY KEY CLUSTERED ([MasterPatientIndexDecisionLogID] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_MasterPatientIndexDecisionLog_CandidateID_MatchedID]
    ON [Archive].[MasterPatientIndexDecisionLog]([CandidateID] ASC, [MatchedID] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores the results of scoring for each inexact search. Any patients that score above a certain threshold will cause records to be added to this table.', @level0type = N'SCHEMA', @level0name = N'Archive', @level1type = N'TABLE', @level1name = N'MasterPatientIndexDecisionLog';

