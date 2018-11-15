CREATE TABLE [dbo].[int_hcp_specialty] (
    [hcp_id]             UNIQUEIDENTIFIER NOT NULL,
    [specialty_cid]      INT              NOT NULL,
    [govern_board]       NVARCHAR (50)    NULL,
    [certification_code] NVARCHAR (20)    NULL,
    [certification_dt]   DATETIME         NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_hcp_specialty_hcp_id_specialty_cid]
    ON [dbo].[int_hcp_specialty]([hcp_id] ASC, [specialty_cid] ASC) WITH (FILLFACTOR = 100);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_int_hcp_specialty_specialty_cid_hcp_id]
    ON [dbo].[int_hcp_specialty]([specialty_cid] ASC, [hcp_id] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores the specialty(s) for each HCP. It includes information about what group/board certified the HCP.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_hcp_specialty';

