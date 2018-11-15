CREATE PROCEDURE [old].[uspUpdateMiscellaneousCode]
    (
        @OrganizationID     INT,
        @SystemID           INT,
        @CategoryCode       CHAR(4),
        @MethodCode         NVARCHAR(10),
        @code               NVARCHAR(80),
        @KeystoneCode       NVARCHAR(80),
        @ShortDescription   NVARCHAR(100),
        @VerificationSwitch BIT,
        @CodeID             INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        UPDATE
            [Intesys].[MiscellaneousCode]
        SET
            [OrganizationID] = @OrganizationID,
            [SystemID] = @SystemID,
            [CategoryCode] = @CategoryCode,
            [MethodCode] = @MethodCode,
            [Code] = @code,
            [KeystoneCode] = @KeystoneCode,
            [ShortDescription] = @ShortDescription,
            [VerificationSwitch] = @VerificationSwitch
        WHERE
            [CodeID] = @CodeID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspUpdateMiscellaneousCode';

