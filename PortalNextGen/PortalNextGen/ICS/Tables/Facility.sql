CREATE TABLE [ICS].[Facility] (
    [FacilityID]      INT           IDENTITY (1, 1) NOT NULL,
    [OrganizationID]  INT           NOT NULL,
    [Name]            NVARCHAR (50) NOT NULL,
    [CreatedDateTime] DATETIME2 (7) CONSTRAINT [DF_Facility_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_Facility_FacilityID] PRIMARY KEY CLUSTERED ([FacilityID] ASC),
    CONSTRAINT [FK_Facility_Organization_OrganizationID] FOREIGN KEY ([OrganizationID]) REFERENCES [ICS].[Organization] ([OrganizationID])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'ICS', @level1type = N'TABLE', @level1name = N'Facility';

