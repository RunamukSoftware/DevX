CREATE PROCEDURE [HL7].[uspSetAddressInformation]
    (
        @AddressID     INT,
        @AddrLocCode   NCHAR(2),
        @AddrTypCode   NCHAR(2),
        @ActiveSwitch  BIT,
        @OrgPatientID  INT           = NULL,
        @Line1Dsc      NVARCHAR(160) = NULL,
        @Line2Dsc      NVARCHAR(160) = NULL,
        @Line3Dsc      NVARCHAR(160) = NULL,
        @City          NVARCHAR(60)  = NULL,
        @CountryCodeID INT           = NULL,
        @StateCode     NVARCHAR(6)   = NULL,
        @ZipCode       NVARCHAR(30)  = NULL,
        @StartDateTime DATETIME2(7)  = NULL
    )
AS
    BEGIN
        SET NOCOUNT ON;

        IF (CAST(@StartDateTime AS VARCHAR(30)) = '')
            SET @StartDateTime = SYSUTCDATETIME();

        UPDATE
            [Intesys].[Address]
        SET
            [ActiveSwitch] = @ActiveSwitch,
            [OriginalPatientID] = ISNULL(@OrgPatientID, [OriginalPatientID]),
            [Line1Description] = ISNULL(@Line1Dsc, [Line1Description]),
            [Line2Description] = ISNULL(@Line2Dsc, [Line2Description]),
            [Line3Description] = ISNULL(@Line3Dsc, [Line3Description]),
            [City] = ISNULL(@City, [City]),
            [CountyCodeID] = ISNULL(@CountryCodeID, [CountyCodeID]),
            [StateCode] = ISNULL(@StateCode, [StateCode]),
            [PostalCode] = ISNULL(@ZipCode, [PostalCode]),
            [StartDateTime] = ISNULL(@StartDateTime, [StartDateTime])
        WHERE
            [AddressID] = @AddressID
            AND [AddressLocationCode] = @AddrLocCode
            AND [AddressTypeCode] = @AddrTypCode;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Update the HL7 address information.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'PROCEDURE', @level1name = N'uspSetAddressInformation';

