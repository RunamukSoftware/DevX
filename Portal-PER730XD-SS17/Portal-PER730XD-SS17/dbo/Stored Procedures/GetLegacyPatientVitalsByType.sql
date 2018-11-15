CREATE PROCEDURE [dbo].[GetLegacyPatientVitalsByType]
    (
     @patient_id UNIQUEIDENTIFIER,
     @type INT
    )
AS
BEGIN
    SELECT
        [Result].[result_value] AS [VALUE],
        CAST(NULL AS DATETIME) AS [RESULT_TIME],
        [Result].[Sequence] AS [SEQ_NUM],
        [Result].[result_ft] AS [RESULT_FILE_TIME],
        CAST(1 AS BIT) AS [IS_RESULT_LOCALIZED]
    FROM
        [dbo].[int_result] AS [Result]
        INNER JOIN [dbo].[int_misc_code] AS [Code] ON [Result].[test_cid] = [Code].[code_id]
    WHERE
        ([Result].[patient_id] = @patient_id)
        AND ([Code].[code_id] = @type)
    ORDER BY
        [RESULT_FILE_TIME] ASC;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get the vitals of one patient for one given type, only from the legacy tables.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetLegacyPatientVitalsByType';

