CREATE PROCEDURE [dbo].[usp_HL7_UpdatePersonDemographics]
    (
     @PersonId UNIQUEIDENTIFIER,
     @FirstNm NVARCHAR(100), -- TG - Should be NVARCHAR(50)
     @LastNm NVARCHAR(100), -- TG - Should be NVARCHAR(50)
     @MiddleNm NVARCHAR(100), -- TG - Should be NVARCHAR(50)
     @TelNo NVARCHAR(80), -- TG - Should be NVARCHAR(40)
     @CityNm NVARCHAR(50), -- TG - Should be NVARCHAR(30)
     @StateCode NVARCHAR(60), -- TG - Should be NVARCHAR(3)
     @ZipCode NVARCHAR(6),
     @Suffix NVARCHAR(10), -- TG - Should be NVARCHAR(5)
     @Line1Dsc NVARCHAR(160), -- TG - Should be NVARCHAR(80)
     @Line2Dsc NVARCHAR(160), -- TG - Should be NVARCHAR(80)
     @CountryCid INT
    )
AS
BEGIN
    UPDATE
        [dbo].[int_person]
    SET
        [first_nm] = CAST(@FirstNm AS NVARCHAR(50)),
        [last_nm] = CAST(@LastNm AS NVARCHAR(50)),
        [middle_nm] = CAST(@MiddleNm AS NVARCHAR(50)),
        [tel_no] = CAST(@TelNo AS NVARCHAR(40)),
        [city_nm] = CAST(@CityNm AS NVARCHAR(30)),
        [state_code] = CAST(@StateCode AS NVARCHAR(3)),
        [zip_code] = @ZipCode,
        [suffix] = CAST(@Suffix AS NVARCHAR(5)),
        [line1_dsc] = CAST(@Line1Dsc AS NVARCHAR(80)),
        [line2_dsc] = CAST(@Line2Dsc AS NVARCHAR(80)),
        [country_cid] = @CountryCid
    WHERE
        [person_id] = @PersonId;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Update the persons demographics.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_HL7_UpdatePersonDemographics';

