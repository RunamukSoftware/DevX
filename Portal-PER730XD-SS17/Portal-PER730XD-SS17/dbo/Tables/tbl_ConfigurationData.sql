CREATE TABLE [dbo].[tbl_ConfigurationData] (
    [ApplicationName]     NVARCHAR (256) NOT NULL,
    [SectionName]         NVARCHAR (150) NOT NULL,
    [SectionData]         XML            NULL,
    [UpdatedTimeStampUTC] DATETIME       NULL,
    CONSTRAINT [PK_ConfigurationData_ApplicationName_SectionName] PRIMARY KEY CLUSTERED ([ApplicationName] ASC, [SectionName] ASC) WITH (FILLFACTOR = 100)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tbl_ConfigurationData';

