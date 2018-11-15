CREATE TABLE [Intesys].[Result] (
    [ResultID]                        BIGINT         IDENTITY (-9223372036854775808, 1) NOT NULL,
    [PatientID]                       INT            NOT NULL,
    [OriginalPatientID]               INT            NULL,
    [ObservationStartDateTime]        DATETIME2 (7)  NOT NULL,
    [OrderID]                         INT            NOT NULL,
    [IsHistory]                       BIT            NOT NULL,
    [MonitorSwitch]                   BIT            NOT NULL,
    [UniversalServiceCodeID]          INT            NOT NULL,
    [TestCodeID]                      INT            NOT NULL,
    [HistorySequence]                 INT            NOT NULL,
    [test_subID]                      NVARCHAR (20)  NOT NULL,
    [OrderLineSequenceNumber]         SMALLINT       NOT NULL,
    [TestResultSequenceNumber]        SMALLINT       NOT NULL,
    [ResultDateTime]                  DATETIME2 (7)  NOT NULL,
    [ValueTypeCode]                   NVARCHAR (10)  NOT NULL,
    [SpecimenID]                      INT            NOT NULL,
    [SourceCodeID]                    INT            NOT NULL,
    [StatusCodeID]                    INT            NOT NULL,
    [LastNormalDateTime]              DATETIME2 (7)  NOT NULL,
    [Probability]                     FLOAT (53)     NOT NULL,
    [ObservationID]                   INT            NOT NULL,
    [PrincipalResultInterpretationID] INT            NOT NULL,
    [AssistantResultInterpretationID] INT            NOT NULL,
    [TechnicianID]                    INT            NOT NULL,
    [TranscriberID]                   INT            NOT NULL,
    [ResultUnitsCodeID]               INT            NOT NULL,
    [ReferenceRangeID]                INT            NOT NULL,
    [AbnormalCode]                    NVARCHAR (10)  NOT NULL,
    [AbnormalNatureCode]              NVARCHAR (10)  NOT NULL,
    [prov_svcCodeID]                  INT            NOT NULL,
    [nsurv_tfr_ind]                   NVARCHAR (10)  NOT NULL,
    [ResultValue]                     NVARCHAR (255) NOT NULL,
    [ResultText]                      NVARCHAR (MAX) NOT NULL,
    [ResultComment]                   NVARCHAR (MAX) NOT NULL,
    [HasHistory]                      TINYINT        NOT NULL,
    [ModifiedDateTime]                DATETIME2 (7)  NOT NULL,
    [ModifiedUserID]                  INT            NOT NULL,
    [CreatedDateTime]                 DATETIME2 (7)  CONSTRAINT [DF_Result_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_Result_ResultID] PRIMARY KEY CLUSTERED ([ResultID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_Result_Order_OrderID] FOREIGN KEY ([OrderID]) REFERENCES [Intesys].[Order] ([OrderID]),
    CONSTRAINT [FK_Result_Patient_PatientID] FOREIGN KEY ([PatientID]) REFERENCES [old].[Patient] ([PatientID])
);


GO
CREATE NONCLUSTERED INDEX [IX_Result_ObservationStartDateTime]
    ON [Intesys].[Result]([ObservationStartDateTime] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Result_PatientID_TestCodeID_ResultDateTime_ResultDateTime_ResultValue]
    ON [Intesys].[Result]([PatientID] ASC, [TestCodeID] ASC, [ResultDateTime] DESC)
    INCLUDE([ResultValue]);


GO
CREATE NONCLUSTERED INDEX [IX_Result_PatientID_TestCodeID_ResultDateTime_ResultID]
    ON [Intesys].[Result]([PatientID] ASC, [TestCodeID] ASC, [ResultDateTime] ASC)
    INCLUDE([ResultID]) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Result-based information, most of which comes from OBX segments. The CUR_RSLT_xxxx table holds all current results, hence the name. When a result is updated the original CUR_RSLT_xxxx is copied into the HIST_RSLT_xxxx table. The two tables are exactly the same to facilitate easily coping one table to the other. Seven current result data stores are used by CDR: - CUR_RSLT_LAB (Laboratory/Microbiology) - CUR_RSLT_RAD (Radiology/X-ray/Nuclear Medicine) - CUR_RSLT_VITL (Vital Signs/Statistics) - CUR_RSLT_RPT (Reports/Transcriptions/Progress Reports) - CUR_RSLT_IO (Intake/Ouput) - CUR_RSLT_ASSMT (Nursing Assessments) - CUR_RSLT_ECG (Ecg) In the HIST_RSLT_xxxx table the DESC_KEY should be used to display reverse chronological history of changes. Note that the DESC_KEY is a surrogate primary key for all result tables. HL7 to database mappings: ORC -> ORDER_TBL OBR -> ORDER_LINE,SPECIMEN OBX -> CUR_RSLT_xxxx Relationship between tests and results: Panels and Test Groups: Panels and Test Groups must be transmitted in OBR segments, since the ORC does not contain any Type of identifier or name, the ORC is entirely optional in ORUs, and the OBX only contains TEST/RESULTS. In the database, we do not deal with these since HL7 does not transmit enough information to determine the relationships necessary. The ORDER_TBL has two fields that attempt to deal with order groups at a gross level, PARENT_ORDID and CHILD_ORDSwitch. When ORDER ENTRY is developed this will need to be re-investigated. Batteries: Batteries are collections of tests that are given a single name and are generally ordered (i.e. OBR''s). An HL7 battery is equivalent to a display panel. Each battery processed by CDR will have a unique batteryID value', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Result';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Sequence of data insertion', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Result', @level2type = N'COLUMN', @level2name = N'ResultID';

