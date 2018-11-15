CREATE TABLE [dbo].[MyClassBinary]
    (
        [MyClassBinaryID] INT            IDENTITY(1, 1) NOT NULL
            CONSTRAINT [PK_MyClassBinary_MyClassBinaryID] PRIMARY KEY CLUSTERED,
        [DataBytes]       VARBINARY(MAX) NOT NULL
    );
