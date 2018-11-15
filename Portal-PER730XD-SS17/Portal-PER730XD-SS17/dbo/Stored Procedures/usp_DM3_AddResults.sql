CREATE PROCEDURE [dbo].[usp_DM3_AddResults]
    (
     @ResultGUID NVARCHAR(50) = NULL, -- TG - should be UNIQUEIDENTIFIER
     @PatientGUID NVARCHAR(50) = NULL, -- TG - should be UNIQUEIDENTIFIER
     @OrderIDGUID NVARCHAR(50) = NULL, -- TG - should be UNIQUEIDENTIFIER
     @Result_usid NVARCHAR(50) = NULL, -- TG - should be INT
     @Test_cid NVARCHAR(50) = NULL, -- TG - should be INT
     @BTime NVARCHAR(50) = NULL, -- TG - should be DATETIME
     @BFileTime NVARCHAR(50) = NULL, -- TG - should be BIGINT
     @ResultVal NVARCHAR(50) = NULL
    )
AS
BEGIN
    INSERT  INTO [dbo].[int_result]
            ([result_id],
             [patient_id],
             [order_id],
             [univ_svc_cid],
             [test_cid],
             [obs_start_dt],
             [result_dt],
             [result_ft],
             [value_type_cd],
             [result_value],
             [mod_dt],
             [has_history],
             [is_history],
             [monitor_sw]
            )
    VALUES
            (CAST(@ResultGUID AS UNIQUEIDENTIFIER),
             CAST(@PatientGUID AS UNIQUEIDENTIFIER),
             CAST(@OrderIDGUID AS UNIQUEIDENTIFIER),
             CAST(@Result_usid AS INT),
             CAST(@Test_cid AS INT),
             CAST(@BTime AS DATETIME),
             CAST(@BTime AS DATETIME),
             CAST(@BFileTime AS BIGINT),
             N'NM',
             @ResultVal,
             CAST(@BTime AS DATETIME),
             0,
             0,
             1
            );
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Add or Update Encounter Table values in DM3 Loader.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DM3_AddResults';

