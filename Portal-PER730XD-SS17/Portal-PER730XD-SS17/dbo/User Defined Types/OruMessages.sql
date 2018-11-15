CREATE TYPE [dbo].[OruMessages] AS TABLE (
    [msg_status]       NCHAR (10)     NOT NULL,
    [msg_no]           CHAR (20)      NOT NULL,
    [HL7_text_long]    NTEXT          NULL,
    [HL7_text_short]   NVARCHAR (255) NULL,
    [patient_id]       NVARCHAR (60)  NULL,
    [msh_system]       NVARCHAR (50)  NOT NULL,
    [msh_organization] NVARCHAR (50)  NOT NULL,
    [msh_event_cd]     NCHAR (10)     NOT NULL,
    [msh_msg_type]     NCHAR (10)     NOT NULL,
    [sent_dt]          DATETIME       NULL,
    [queued_dt]        DATETIME       NOT NULL);

