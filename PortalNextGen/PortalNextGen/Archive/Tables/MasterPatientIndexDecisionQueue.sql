CREATE TABLE [Archive].[MasterPatientIndexDecisionQueue] (
    [MasterPatientIndexDecisionQueueID] INT           IDENTITY (1, 1) NOT NULL,
    [CandidateID]                       INT           NOT NULL,
    [ModifiedDateTime]                  DATETIME2 (7) NOT NULL,
    [ProcessedDateTime]                 DATETIME2 (7) NULL,
    [CreatedDateTime]                   DATETIME2 (7) CONSTRAINT [DF_MasterPatientIndexDecisionQueue_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_MasterPatientIndexDecisionQueue_MasterPatientIndexDecisionQueueID] PRIMARY KEY CLUSTERED ([MasterPatientIndexDecisionQueueID] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_MasterPatientIndexDecisionQueue_CandidateID_ProcessedDateTime]
    ON [Archive].[MasterPatientIndexDecisionQueue]([CandidateID] ASC, [ProcessedDateTime] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Patients that needs to be "scored"(i.e. similar patients (if any) need to be located). An MPI search is necessary to be run against this patient. If similar patients are found, then row(s) are inserted into the decision_log table.', @level0type = N'SCHEMA', @level0name = N'Archive', @level1type = N'TABLE', @level1name = N'MasterPatientIndexDecisionQueue';

