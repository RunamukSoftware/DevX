CREATE TABLE [PHI].[PatientDemographics] (
    [PatientID]            BIGINT        NOT NULL,
    [FirstName]            NVARCHAR (50) NOT NULL,
    [LastName]             NVARCHAR (50) NOT NULL,
    [DateOfBirth]          DATE          CONSTRAINT [DF_PatientDemographics_DateOfBirth] DEFAULT ('1000-01-01') NOT NULL,
    [SocialSecurityNumber] VARCHAR (12)  CONSTRAINT [DF_PatientDemographics_SocialSecurityNumber] DEFAULT ('') NOT NULL,
    [MedicalRecordNumber]  NVARCHAR (30) NOT NULL,
    [GenderID]             TINYINT       NOT NULL,
    PRIMARY KEY CLUSTERED ([PatientID] ASC),
    CONSTRAINT [FK_PatientDemographics_Gender_GenderID] FOREIGN KEY ([GenderID]) REFERENCES [dbo].[Gender] ([GenderID]),
    CONSTRAINT [FK_PatientDemographics_Patient_PatientID] FOREIGN KEY ([PatientID]) REFERENCES [dbo].[Patient] ([PatientID])
);

