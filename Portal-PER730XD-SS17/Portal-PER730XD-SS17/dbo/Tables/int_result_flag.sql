CREATE TABLE [dbo].[int_result_flag] (
    [flag_id]          UNIQUEIDENTIFIER NOT NULL,
    [flag]             NVARCHAR (10)    NOT NULL,
    [display_front]    NVARCHAR (10)    NULL,
    [display_back]     NVARCHAR (10)    NULL,
    [bitmap_ndx_front] INT              NULL,
    [bitmap_ndx_back]  INT              NULL,
    [color_foreground] VARCHAR (20)     NULL,
    [color_background] VARCHAR (20)     NULL,
    [sys_id]           UNIQUEIDENTIFIER NULL,
    [comment]          NVARCHAR (30)    NULL,
    [legend_rank]      INT              NOT NULL,
    [severity_rank]    INT              NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_result_flag_flag_sys_id]
    ON [dbo].[int_result_flag]([flag] ASC, [sys_id] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores the information about indication of abnormal result flags to be displayed by the front end. Whenever an abnormal result ''flag'' is sent by a feeder system identified by ''sys_ent_id'', the front end will use this table to decide if a text message is to be displayed in front or back of the result or the result is to be colored with the ''color'' or a bitmap is to be placed in front or back of the result.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_result_flag';

