CREATE TABLE [Intesys].[OrganizationShiftSchedule] (
    [OrganizationShiftScheduleID] INT           IDENTITY (1, 1) NOT NULL,
    [OrganizationID]              INT           NOT NULL,
    [ShiftName]                   NVARCHAR (8)  NOT NULL,
    [ShiftStartDateTime]          DATETIME2 (7) NULL,
    [CreatedDateTime]             DATETIME2 (7) CONSTRAINT [DF_OrganizationShiftSchedule_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_OrganizationShiftSchedule_OrganizationShiftScheduleID] PRIMARY KEY CLUSTERED ([OrganizationShiftScheduleID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_OrganizationShiftSchedule_Organization_OrganizationID] FOREIGN KEY ([OrganizationID]) REFERENCES [Intesys].[Organization] ([OrganizationID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_OrganizationShiftSchedule_OrganizationID_ShiftName]
    ON [Intesys].[OrganizationShiftSchedule]([OrganizationID] ASC, [ShiftName] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table identifies the work schedule for a unit (schedule of work, determined by the SHIFT_START_TM for the ORGANIZATION). This information will initially be used by the front-end to calculate volumes for nursing asessments. It will be maintained by a System Administration tool.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'OrganizationShiftSchedule';

