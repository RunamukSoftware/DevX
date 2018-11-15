CREATE TABLE [dbo].[CreateUpdateDelete] (
    [CreateUpdateDeleteID] INT          IDENTITY (1, 1) NOT NULL,
    [Column01]             VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_CreateUpdateDelete_CreateUpdateDeleteID] PRIMARY KEY CLUSTERED ([CreateUpdateDeleteID] ASC)
);

