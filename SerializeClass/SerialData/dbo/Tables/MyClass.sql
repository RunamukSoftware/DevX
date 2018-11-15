CREATE TABLE [dbo].[MyClass]
    (
        [MyClassID]   INT            IDENTITY(1, 1) NOT NULL
            CONSTRAINT [PK_MyClass_MyClassID] PRIMARY KEY CLUSTERED,
        [FirstName]   NVARCHAR(50)   NOT NULL,
        [LastName]    NVARCHAR(50)   NOT NULL,
        [DateOfBirth] DATETIME       NOT NULL,
        [Gender]      VARCHAR(20)    NOT NULL,
        [Ethnicity]   VARCHAR(20)    NOT NULL,
        [DecimalData] DECIMAL(15, 3) NOT NULL,
        [Notes]       VARCHAR(MAX)   NOT NULL
    );
