CREATE TABLE [TechSupport].[InputRate] (
    [InputRateID]     INT           IDENTITY (1, 1) NOT NULL,
    [InputType]       VARCHAR (20)  NOT NULL,
    [PeriodStart]     DATETIME2 (7) NOT NULL,
    [PeriodLength]    INT           NOT NULL,
    [RateCounter]     INT           NOT NULL,
    [CreatedDateTime] DATETIME2 (7) CONSTRAINT [DF_InputRate_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_InputRate_InputRateID] PRIMARY KEY CLUSTERED ([InputRateID] ASC) WITH (FILLFACTOR = 100)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Stores input rate for monitored tables. This data can be used to evaluate for possible DataLoader problems', @level0type = N'SCHEMA', @level0name = N'TechSupport', @level1type = N'TABLE', @level1name = N'InputRate';

