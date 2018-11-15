CREATE PROCEDURE [dbo].[GetPatientsList]
    (
     @unit_id DUNIT_ID,
     @status NVARCHAR(40)
    )
AS
BEGIN
    DECLARE @return_value TABLE
        (
         [patient_id] UNIQUEIDENTIFIER,
         [patient_name] NVARCHAR(100),
         [MONITOR_NAME] NVARCHAR(30),
         [ACCOUNT_ID] NVARCHAR(30),
         [MRN_ID] NVARCHAR(30),
         [UNIT_ID] UNIQUEIDENTIFIER,
         [organization_cd] NVARCHAR(20),
         [FACILITY_ID] UNIQUEIDENTIFIER,
         [FACILITY_NAME] NVARCHAR(20),
         [DOB] DATETIME,
         [ADMIT_TIME] DATETIME,
         [DISCHARGED_TIME] DATETIME,
         [PATIENT_MONITOR_ID] UNIQUEIDENTIFIER,
         [STATUS] VARCHAR(40)
        );

    INSERT  @return_value
            EXEC [dbo].[GetUserPatientsList] @unit_id = @unit_id, @status = @status;
 
    SELECT
        [patient_id],
        [patient_name],
        [MONITOR_NAME],
        [ACCOUNT_ID],
        [MRN_ID],
        [UNIT_ID],
        [organization_cd],
        [FACILITY_ID],
        [FACILITY_NAME],
        [DOB],
        [ADMIT_TIME],
        [DISCHARGED_TIME],
        [PATIENT_MONITOR_ID],
        [STATUS]
    FROM
        @return_value;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetPatientsList';

