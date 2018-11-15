CREATE PROCEDURE [dbo].[usp_DM3_AddorUpdateVitals]
    (
     @PatientGUID NVARCHAR(50), -- TG - should be UNIQUEIDENTIFIER
     @Monitor_Id NVARCHAR(50), -- TG - should be UNIQUEIDENTIFIER
     @Collect_Date NVARCHAR(50), -- TG - should be DATETIME
     @Vital_Value NVARCHAR(4000), -- TG - should be VARCHAR(4000)
     @Vital_Time NVARCHAR(3950) = NULL -- TG - should be VARCHAR(3950)
    )
AS
BEGIN
    IF EXISTS ( SELECT
                    1
                FROM
                    [dbo].[int_vital_live]
                WHERE
                    [patient_id] = CAST(@PatientGUID AS UNIQUEIDENTIFIER)
                    AND [monitor_id] = CAST(@Monitor_Id AS UNIQUEIDENTIFIER) )
    BEGIN
        UPDATE
            [dbo].[int_vital_live]
        SET
            [collect_dt] = CAST(@Collect_Date AS DATETIME),
            [vital_value] = CAST(@Vital_Value AS VARCHAR(4000)),
            [vital_time] = CAST(@Vital_Time AS VARCHAR(3950))
        WHERE
            [patient_id] = CAST(@PatientGUID AS UNIQUEIDENTIFIER)
            AND [monitor_id] = CAST(@Monitor_Id AS UNIQUEIDENTIFIER);
    END;
    ELSE
    BEGIN
        INSERT  INTO [dbo].[int_vital_live]
                ([patient_id],
                 [monitor_id],
                 [collect_dt],
                 [vital_value],
                 [vital_time]
                )
        VALUES
                (CAST(@PatientGUID AS UNIQUEIDENTIFIER),
                 CAST(@Monitor_Id AS UNIQUEIDENTIFIER),
                 CAST(@Collect_Date AS DATETIME),
                 CAST(@Vital_Value AS VARCHAR(4000)),
                 CAST(@Vital_Time AS VARCHAR(3950))
                );
    END;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DM3_AddorUpdateVitals';

