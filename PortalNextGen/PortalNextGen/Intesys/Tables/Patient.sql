CREATE TABLE [Intesys].[Patient] (
    [PatientID]                INT           IDENTITY (1, 1) NOT NULL,
    [NewPatientID]             INT           NOT NULL,
    [OrganDonorSwitch]         BIT           NOT NULL,
    [LivingWillSwitch]         BIT           NOT NULL,
    [BirthOrder]               TINYINT       NOT NULL,
    [VeteranStatusCodeID]      INT           NOT NULL,
    [BirthPlace]               NVARCHAR (50) NOT NULL,
    [SocialSecurityNumber]     VARCHAR (15)  NOT NULL,
    [MpiSocialSecurityNumber1] INT           NOT NULL,
    [MpiSocialSecurityNumber2] INT           NOT NULL,
    [MpiSocialSecurityNumber3] INT           NOT NULL,
    [MpiSocialSecurityNumber4] INT           NOT NULL,
    [DriversLicenseNumber]     NVARCHAR (25) NOT NULL,
    [MpiDriversLicenseNumber1] NVARCHAR (3)  NOT NULL,
    [MpiDriversLicenseNumber2] NVARCHAR (3)  NOT NULL,
    [MpiDriversLicenseNumber3] NVARCHAR (3)  NOT NULL,
    [MpiDriversLicenseNumber4] NVARCHAR (3)  NOT NULL,
    [DriversLicenseStateCode]  NVARCHAR (3)  NOT NULL,
    [DateOfBirth]              DATE          NOT NULL,
    [DeathDate]                DATE          NOT NULL,
    [NationalityCodeID]        INT           NOT NULL,
    [CitizenshipCodeID]        INT           NOT NULL,
    [EthnicGroupCodeID]        INT           NOT NULL,
    [RaceCodeID]               INT           NOT NULL,
    [GenderCodeID]             INT           NOT NULL,
    [PrimaryLanguageCodeID]    INT           NOT NULL,
    [MaritalStatusCodeID]      INT           NOT NULL,
    [ReligionCodeID]           INT           NOT NULL,
    [MonitorInterval]          INT           NOT NULL,
    [Height]                   FLOAT (53)    NOT NULL,
    [Weight]                   FLOAT (53)    NOT NULL,
    [BodySurfaceArea]          FLOAT (53)    NOT NULL,
    [CreatedDateTime]          DATETIME2 (7) CONSTRAINT [DF_Patient_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_Patient_PatientID] PRIMARY KEY CLUSTERED ([PatientID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_Patient_Patient_PatientID] FOREIGN KEY ([PatientID]) REFERENCES [old].[Patient] ([PatientID])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores each patient record. Every patient is assigned a unique internal ID (GUID) that can never be duplicated. This table also has MPI specific fields used by the MPI engine to ensure that patients are not duplicated because of minor data-entry errors.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Patient';

