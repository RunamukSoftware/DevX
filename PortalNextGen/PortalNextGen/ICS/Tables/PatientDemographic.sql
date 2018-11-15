CREATE TABLE [ICS].[PatientDemographic] (
    [PatientID]               INT           NOT NULL,
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
    [HeightUnitOfMeasure]     VARCHAR (25)  NULL,
    [Weight]                  FLOAT (53)    NULL,
    [WeightUnitOfMeasure]     VARCHAR (25)  NULL,
    [BodySurfaceArea]         FLOAT (53)    NOT NULL,
    [Timestamp]               DATETIME2 (7) NOT NULL,
    [CreatedDateTime]         DATETIME2 (7) CONSTRAINT [DF_PatientDemographic_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_PatientDemographic_PatientID] PRIMARY KEY CLUSTERED ([PatientID] ASC),
    CONSTRAINT [FK_PatientDemographic_Patient_PatientID] FOREIGN KEY ([PatientID]) REFERENCES [ICS].[Patient] ([PatientID])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'ICS', @level1type = N'TABLE', @level1name = N'PatientDemographic';

