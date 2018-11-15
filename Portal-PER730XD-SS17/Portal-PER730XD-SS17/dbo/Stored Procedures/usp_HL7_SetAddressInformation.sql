CREATE PROCEDURE [dbo].[usp_HL7_SetAddressInformation]
    (
     @AddressId UNIQUEIDENTIFIER,
     @AddrLocCd NCHAR(2),
     @AddrTypCd NCHAR(2),
     @SeqNo INT,
     @ActiveSw TINYINT = NULL,
     @OrgPatientId UNIQUEIDENTIFIER = NULL,
     @Line1Dsc NVARCHAR(160) = NULL,
     @Line2Dsc NVARCHAR(160) = NULL,
     @Line3Dsc NVARCHAR(160) = NULL,
     @CityNm NVARCHAR(60) = NULL,
     @CountryCid INT = NULL,
     @StateCode NVARCHAR(6) = NULL,
     @ZipCode NVARCHAR(30) = NULL,
     @StartDt DATETIME = NULL
    )
AS
BEGIN
    IF (@StartDt = '')
        SET @StartDt = GETDATE(); 

    UPDATE
        [dbo].[int_address]
    SET
        [active_sw] = ISNULL(@ActiveSw, [active_sw]),
        [orig_patient_id] = ISNULL(@OrgPatientId, [orig_patient_id]),
        [line1_dsc] = ISNULL(@Line1Dsc, [line1_dsc]),
        [line2_dsc] = ISNULL(@Line2Dsc, [line2_dsc]),
        [line3_dsc] = ISNULL(@Line3Dsc, [line3_dsc]),
        [city_nm] = ISNULL(@CityNm, [city_nm]),
        [county_cid] = ISNULL(@CountryCid, [county_cid]),
        [state_code] = ISNULL(@StateCode, [state_code]),
        [zip_code] = ISNULL(@ZipCode, [zip_code]),
        [start_dt] = ISNULL(@StartDt, [start_dt])
    WHERE
        [address_id] = @AddressId
        AND [addr_loc_cd] = @AddrLocCd
        AND [addr_type_cd] = @AddrTypCd
        AND [seq_no] = @SeqNo;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Update the HL7 address information.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_HL7_SetAddressInformation';

