CREATE TABLE [User].[Contact] (
    [ContactID]       INT           IDENTITY (1, 1) NOT NULL,
    [UserID]          INT           NOT NULL,
    [Description]     NVARCHAR (80) NOT NULL,
    [PhoneNumber]     NVARCHAR (80) NULL,
    [Address1]        NVARCHAR (80) NULL,
    [Address2]        NVARCHAR (80) NULL,
    [Address3]        NVARCHAR (80) NULL,
    [Email]           NVARCHAR (40) NULL,
    [City]            NVARCHAR (50) NULL,
    [StateProvince]   NVARCHAR (30) NULL,
    [PostalCode]      NVARCHAR (15) NULL,
    [Country]         NVARCHAR (20) NULL,
    [CreatedDateTime] DATETIME2 (7) CONSTRAINT [DF_Contact_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_Contact_ContactID] PRIMARY KEY CLUSTERED ([ContactID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_Contact_User_UserID] FOREIGN KEY ([UserID]) REFERENCES [User].[User] ([UserID])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Table used to store contact information for a given user. It allows the system to have information about the address, phone number, etc for each user. It also allows multiple phone #''s and addresses.', @level0type = N'SCHEMA', @level0name = N'User', @level1type = N'TABLE', @level1name = N'Contact';

