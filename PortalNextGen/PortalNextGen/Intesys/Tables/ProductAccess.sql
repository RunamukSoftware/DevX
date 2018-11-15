CREATE TABLE [Intesys].[ProductAccess] (
    [ProductAccessID] INT           IDENTITY (1, 1) NOT NULL,
    [ProductCode]     VARCHAR (25)  NOT NULL,
    [OrganizationID]  INT           NULL,
    [LicenseNumber]   VARCHAR (120) NULL,
    [CreatedDateTime] DATETIME2 (7) CONSTRAINT [DF_ProductAccess_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_ProductAccess_ProductAccessID] PRIMARY KEY CLUSTERED ([ProductAccessID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_ProductAccess_Organization_OrganizationID] FOREIGN KEY ([OrganizationID]) REFERENCES [Intesys].[Organization] ([OrganizationID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_ProductAccess_ProductCode_OrganizationID]
    ON [Intesys].[ProductAccess]([ProductCode] ASC, [OrganizationID] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores the product access information.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'ProductAccess';

