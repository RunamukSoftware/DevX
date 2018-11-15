CREATE PROCEDURE [dbo].[usp_HL7_GetLegacyGdsCodes]
AS
BEGIN
    SELECT
        [code_id] AS [CodeId],
        [code] AS [Gds_Code],
        [short_dsc] AS [Gds_Description],
        [int_keystone_cd] AS [Gds_UoM]
    FROM
        [dbo].[int_misc_code];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Retrieve the legacy Gds codes.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_HL7_GetLegacyGdsCodes';

