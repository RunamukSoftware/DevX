CREATE PROCEDURE [dbo].[GetLegacyPatientVitalsTypes]
    (
     @patient_id UNIQUEIDENTIFIER
    )
AS
BEGIN
    SELECT
        [Code].[code_id] AS [TYPE],
        [Code].[code] AS [CODE],
        [Code].[int_keystone_cd] AS [UNITS]
    FROM
        [dbo].[int_misc_code] AS [Code]
        INNER JOIN (SELECT DISTINCT
                        [test_cid]
                    FROM
                        [dbo].[int_result]
                    WHERE
                        [patient_id] = @patient_id
                   ) [result_cid] ON [result_cid].[test_cid] = [Code].[code_id];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetLegacyPatientVitalsTypes';

