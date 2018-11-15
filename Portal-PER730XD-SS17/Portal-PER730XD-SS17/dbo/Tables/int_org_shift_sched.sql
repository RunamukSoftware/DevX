CREATE TABLE [dbo].[int_org_shift_sched] (
    [organization_id] UNIQUEIDENTIFIER NOT NULL,
    [shift_nm]        NVARCHAR (8)     NOT NULL,
    [shift_start_tm]  DATETIME         NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_org_shift_sched_organization_id_shift_nm]
    ON [dbo].[int_org_shift_sched]([organization_id] ASC, [shift_nm] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table identifies the work schedule for a unit (schedule of work, determined by the SHIFT_START_TM for the ORGANIZATION). This information will initially be used by the front-end to calculate volumes for nursing asessments. It will be maintained by a System Administration tool.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_org_shift_sched';

