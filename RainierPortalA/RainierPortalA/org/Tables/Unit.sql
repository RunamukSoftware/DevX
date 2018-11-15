CREATE TABLE [org].[Unit] (
    [UnitID]          INT           IDENTITY (1, 1) NOT NULL,
    [FacilityID]      INT           NOT NULL,
    [Name]            VARCHAR (50)  NOT NULL,
    [CreatedDateTime] DATETIME2 (7) CONSTRAINT [DF_Unit_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    PRIMARY KEY CLUSTERED ([UnitID] ASC),
    CONSTRAINT [FK_Unit_Facility_FacilityID] FOREIGN KEY ([FacilityID]) REFERENCES [org].[Facility] ([FacilityID])
);

