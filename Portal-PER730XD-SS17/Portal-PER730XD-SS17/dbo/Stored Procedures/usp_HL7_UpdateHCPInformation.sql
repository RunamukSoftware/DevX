CREATE PROCEDURE [dbo].[usp_HL7_UpdateHCPInformation]
    (
     @hcpId UNIQUEIDENTIFIER,
     @LastNm NVARCHAR(100) = NULL, -- TG - should be NVARCHAR(50)
     @FirstNm NVARCHAR(100) = NULL, -- TG - should be NVARCHAR(50)
     @MiddleNm NVARCHAR(100) = NULL, -- TG - should be NVARCHAR(50)
     @Degree NVARCHAR(40) = NULL -- TG - should be NVARCHAR(20)
    )
AS
BEGIN
    UPDATE
        [dbo].[int_hcp]
    SET
        [last_nm] = CAST(@LastNm AS NVARCHAR(50)),
        [first_nm] = CAST(@FirstNm AS NVARCHAR(50)),
        [middle_nm] = CAST(@MiddleNm AS NVARCHAR(50)),
        [degree] = CAST(@Degree AS NVARCHAR(20))
    WHERE
        [hcp_id] = @hcpId;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_HL7_UpdateHCPInformation';

