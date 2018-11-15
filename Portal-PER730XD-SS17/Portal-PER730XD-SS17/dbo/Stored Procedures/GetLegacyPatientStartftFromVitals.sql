CREATE PROCEDURE [dbo].[GetLegacyPatientStartftFromVitals]
    (
     @patient_id UNIQUEIDENTIFIER
    )
AS
BEGIN
    SELECT
        MIN([result_ft]) AS [start_ft]
    FROM
        [dbo].[int_result]
    WHERE
        ([patient_id] = @patient_id);
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetLegacyPatientStartftFromVitals';

