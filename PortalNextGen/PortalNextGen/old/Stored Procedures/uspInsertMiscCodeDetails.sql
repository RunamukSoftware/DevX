CREATE PROCEDURE [old].[uspInsertMiscCodeDetails]
    (
        @CodeID             INT,
        @OrganizationID     INT,
        @SystemID           INT,
        @CategoryCode       CHAR(4),
        @MethodCode         NVARCHAR(10),
        @code               NVARCHAR(80),
        @VerificationSwitch BIT,
        @KeystoneCode       NVARCHAR(80)  = NULL,
        @ShortDescription   NVARCHAR(100) = NULL,
        @spc_pcs_code       CHAR(1)       = NULL
    )
AS
    BEGIN
        SET NOCOUNT ON;

        INSERT INTO [Intesys].[MiscellaneousCode]
            (
                [CodeID],
                [OrganizationID],
                [SystemID],
                [CategoryCode],
                [MethodCode],
                [Code],
                [VerificationSwitch],
                [KeystoneCode],
                [ShortDescription],
                [spc_pcs_code]
            )
        VALUES
            (
                @CodeID, @OrganizationID, @SystemID, @CategoryCode, @MethodCode, @code, @VerificationSwitch,
                @KeystoneCode, @ShortDescription, @spc_pcs_code
            );
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspInsertMiscCodeDetails';

