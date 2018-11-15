CREATE PROCEDURE [dbo].[GetRawECGData]
    (
     @PatientId [dbo].[DPATIENT_ID], -- TG - Should be UNIQUEIDENTIFIER
     @ChannelTypeID [dbo].[DCHANNEL_TYPE_ID],
     @StartTime BIGINT,
     @EndTime BIGINT
    )
AS
BEGIN
    DECLARE @ChannelIds AS [dbo].[StringList];

    INSERT  INTO @ChannelIds
            ([Item])
    VALUES
            (@ChannelTypeID);
    
    EXEC [dbo].[usp_CA_GetPatientWaveForms] @patient_id = @PatientId, @channelIds = @ChannelIds, @start_ft = @StartTime, @end_ft = @EndTime;    
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetRawECGData';

