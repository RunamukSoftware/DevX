CREATE TABLE [dbo].[int_user_contact] (
    [user_id]        UNIQUEIDENTIFIER NOT NULL,
    [seq]            INT              NOT NULL,
    [contact_descr]  NVARCHAR (80)    NOT NULL,
    [phone_num]      NVARCHAR (80)    NULL,
    [address_1]      NVARCHAR (80)    NULL,
    [address_2]      NVARCHAR (80)    NULL,
    [address_3]      NVARCHAR (80)    NULL,
    [e_mail]         NVARCHAR (40)    NULL,
    [city]           NVARCHAR (50)    NULL,
    [state_province] NVARCHAR (30)    NULL,
    [zip_postal]     NVARCHAR (15)    NULL,
    [country]        NVARCHAR (20)    NULL,
    CONSTRAINT [PK_int_user_contact_user_id_seq] PRIMARY KEY CLUSTERED ([user_id] ASC, [seq] ASC) WITH (FILLFACTOR = 100)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Table used to store contact information for a given user. It allows the system to have information about the address, phone #, etc for each user. It also allows multiple phone #''s and addresses.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_user_contact';

