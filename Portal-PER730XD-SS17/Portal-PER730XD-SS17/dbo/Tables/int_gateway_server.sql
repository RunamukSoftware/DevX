CREATE TABLE [dbo].[int_gateway_server] (
    [gateway_id]  UNIQUEIDENTIFIER NOT NULL,
    [server_name] NVARCHAR (50)    NOT NULL,
    [port]        INT              NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_gateway_server_gateway_id_server_name]
    ON [dbo].[int_gateway_server]([gateway_id] ASC, [server_name] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table contains data about the S5 central workstations.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_gateway_server';

