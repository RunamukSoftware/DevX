CREATE TABLE [org].[Facility] (
    [FacilityID]      INT           IDENTITY (1, 1) NOT NULL,
    [OrganizationID]  INT           NOT NULL,
    [Name]            VARCHAR (50)  NOT NULL,
    [CreatedDateTime] DATETIME2 (7) CONSTRAINT [DF_Facility_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_Facility_FacilityID] PRIMARY KEY CLUSTERED ([FacilityID] ASC),
    CONSTRAINT [FK_Facility_Organization_OrganizationID] FOREIGN KEY ([OrganizationID]) REFERENCES [org].[Organization] ([OrganizationID])
);

