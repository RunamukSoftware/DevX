CREATE TABLE [Archive].[MasterPatientIndexDecisionField] (
    [MasterPatientIndexDecisionFieldID] INT           IDENTITY (1, 1) NOT NULL,
    [CandidateID]                       INT           NOT NULL,
    [MatchedID]                         INT           NOT NULL,
    [FieldID]                           INT           NOT NULL,
    [Score]                             TINYINT       NOT NULL,
    [CreatedDateTime]                   DATETIME2 (7) CONSTRAINT [DF_MasterPatientIndexDecisionField_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_MasterPatientIndexDecisionField_MasterPatientIndexDecisionFieldID] PRIMARY KEY CLUSTERED ([MasterPatientIndexDecisionFieldID] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_MasterPatientIndexDecisionField_CandidateID_MatchedID_FieldID]
    ON [Archive].[MasterPatientIndexDecisionField]([CandidateID] ASC, [MatchedID] ASC, [FieldID] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores the results of the score for each field for each decision_log row. These scores are combined to create a total score that is stored in the decision_log record.', @level0type = N'SCHEMA', @level0name = N'Archive', @level1type = N'TABLE', @level1name = N'MasterPatientIndexDecisionField';

