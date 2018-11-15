CREATE TABLE [dbo].[PortalErrors] (
    [name]            NVARCHAR (MAX)     NULL,
    [timestamp]       DATETIMEOFFSET (7) NULL,
    [timestamp (UTC)] DATETIMEOFFSET (7) NULL,
    [error_number]    INT                NULL,
    [severity]        INT                NULL,
    [state]           INT                NULL,
    [user_defined]    BIT                NULL,
    [category]        NVARCHAR (MAX)     NULL,
    [destination]     NVARCHAR (MAX)     NULL,
    [is_intercepted]  BIT                NULL,
    [message]         NVARCHAR (MAX)     NULL,
    [sql_text]        NVARCHAR (MAX)     NULL,
    [is_system]       BIT                NULL,
    [database_name]   NVARCHAR (MAX)     NULL,
    [client_hostname] NVARCHAR (MAX)     NULL,
    [client_app_name] NVARCHAR (MAX)     NULL
);

