CREATE TABLE [Intesys].[PersonName] (
    [PersonNameID]      INT           IDENTITY (1, 1) NOT NULL,
    [RecognizeNameCode] CHAR (2)      NOT NULL,
    [SequenceNumber]    INT           NOT NULL,
    [OriginalPatientID] INT           NULL,
    [ActiveSwitch]      BIT           NOT NULL,
    [Prefix]            NVARCHAR (4)  NULL,
    [FirstName]         NVARCHAR (50) NULL,
    [MiddleName]        NVARCHAR (50) NULL,
    [LastName]          NVARCHAR (50) NULL,
    [Suffix]            NVARCHAR (5)  NULL,
    [Degree]            NVARCHAR (20) NULL,
    [mpi_lname_cons]    NVARCHAR (50) NULL,
    [mpi_fname_cons]    NVARCHAR (50) NULL,
    [mpi_mname_cons]    NVARCHAR (50) NULL,
    [StartDateTime]     DATETIME2 (7) NULL,
    [CreatedDateTime]   DATETIME2 (7) CONSTRAINT [DF_PersonName_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_PersonName_PersonNameID] PRIMARY KEY CLUSTERED ([PersonNameID] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_PersonName_PersonNameID_RecognizeNameCode_SequenceNumber_ActiveSwitch]
    ON [Intesys].[PersonName]([PersonNameID] ASC, [RecognizeNameCode] ASC, [SequenceNumber] ASC, [ActiveSwitch] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores all names.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'PersonName';

