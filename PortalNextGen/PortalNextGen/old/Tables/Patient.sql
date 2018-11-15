CREATE TABLE [old].[Patient] (
    [PatientID]               INT           IDENTITY (1, 1) NOT NULL,
    [PatientSessionID]        INT           NOT NULL,
    [DeviceSessionID]         INT           NULL,
    [FirstName]               NVARCHAR (50) NOT NULL,
    [MiddleName]              NVARCHAR (50) NULL,
    [LastName]                NVARCHAR (50) NOT NULL,
    [Gender]                  CHAR (1)      NOT NULL,
    [ID1]                     VARCHAR (30)  NULL,
    [ID2]                     VARCHAR (30)  NULL,
    [DateOfBirth]             DATE          NULL,
    [DeathDate]               DATE          NOT NULL,
    [Location]                NVARCHAR (50) NULL,
    [PatientType]             VARCHAR (150) NULL,
    [SocialSecurityNumber]    VARCHAR (15)  NOT NULL,
    [DriversLicenseNumber]    VARCHAR (25)  NOT NULL,
    [DriversLicenseStateCode] VARCHAR (3)   NOT NULL,
    [NationalityCodeID]       INT           NOT NULL,
    [CitizenshipCodeID]       INT           NOT NULL,
    [EthnicGroupCodeID]       INT           NOT NULL,
    [PrimaryLanguageCodeID]   INT           NOT NULL,
    [MaritalStatusCodeID]     INT           NOT NULL,
    [ReligionCodeID]          INT           NOT NULL,
    [VeteranStatusCodeID]     INT           NOT NULL,
    [OrganDonorSwitch]        BIT           NOT NULL,
    [LivingWillSwitch]        BIT           NOT NULL,
    [Height]                  FLOAT (53)    NULL,
    [HeightUnitOfMeasure]     VARCHAR (25)  CONSTRAINT [DF_Patient_HeightUnitOfMeasure] DEFAULT ('Inches') NULL,
    [Weight]                  FLOAT (53)    NULL,
    [WeightUnitOfMeasure]     VARCHAR (25)  CONSTRAINT [DF_Patient_WeightUnitOfMeasure] DEFAULT ('Pounds') NULL,
    [BodySurfaceArea]         FLOAT (53)    NOT NULL,
    [Timestamp]               DATETIME2 (7) NOT NULL,
    [CreatedDateTime]         DATETIME2 (7) CONSTRAINT [DF_Patient_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_Patient_PatientID] PRIMARY KEY CLUSTERED ([PatientID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [CK_Patient_Gender] CHECK ([Gender]='F' OR [Gender]='M'),
    CONSTRAINT [FK_Patient_DeviceSession_DeviceSessionID] FOREIGN KEY ([DeviceSessionID]) REFERENCES [old].[DeviceSession] ([DeviceSessionID]),
    CONSTRAINT [FK_Patient_PatientSession_PatientSessionID] FOREIGN KEY ([PatientSessionID]) REFERENCES [old].[PatientSession] ([PatientSessionID])
);


GO
CREATE NONCLUSTERED INDEX [IX_Patient_TimestampUTC_PatientID_PatientSessionID]
    ON [old].[Patient]([Timestamp] ASC)
    INCLUDE([PatientID], [PatientSessionID]) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_Patient_DeviceSessionID_PatientSessionID_Timestamp]
    ON [old].[Patient]([DeviceSessionID] ASC)
    INCLUDE([PatientSessionID], [Timestamp]) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_Patient_PatientSessionID_TimestampUTC_ID1]
    ON [old].[Patient]([PatientSessionID] ASC, [Timestamp] DESC)
    INCLUDE([ID1]) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_Patient_PatientSessionID_TimestampUTC_DeviceSessionID_ID1]
    ON [old].[Patient]([PatientSessionID] ASC, [Timestamp] DESC)
    INCLUDE([DeviceSessionID], [ID1]) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Information about a patient in the hospital.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'TABLE', @level1name = N'Patient';

