CREATE PROCEDURE [dbo].[usp_InsertPersonDemographics]
    (
     @PersonId UNIQUEIDENTIFIER,
     @RecognizeNmCd NVARCHAR(10) = NULL, -- TG - Should be CHAR(2)
     @SeqNo INT = NULL,
     @ActiveSw TINYINT,
     @OrigPatientId UNIQUEIDENTIFIER = NULL,
     @Prefix NVARCHAR(8) = NULL, -- TG - Should be NVARCHAR(4)
     @FirstNm NVARCHAR(100) = NULL, -- TG - Should be NVARCHAR(50)
     @MiddleNm NVARCHAR(100) = NULL, -- TG - Should be NVARCHAR(50)
     @LastNm NVARCHAR(100) = NULL, -- TG - Should be NVARCHAR(50)
     @Suffix NVARCHAR(10) = NULL, -- TG - Should be NVARCHAR(5)
     @Degree NVARCHAR(40) = NULL, -- TG - Should be NVARCHAR(20)
     @mpiLnamecons NVARCHAR(40) = NULL, -- TG - Should be NVARCHAR(20)
     @mpiFnameCons NVARCHAR(40) = NULL, -- TG - Should be NVARCHAR(20)
     @mpiMnameCons NVARCHAR(40) = NULL, -- TG - Should be NVARCHAR(20)
     @startDt DATETIME = NULL
    )
AS
BEGIN
    IF (@startDt IS NULL)
        SET @startDt = GETDATE(); 

    INSERT  INTO [dbo].[int_person_name]
            ([person_nm_id],
             [recognize_nm_cd],
             [seq_no],
             [active_sw],
             [orig_patient_id],
             [prefix],
             [first_nm],
             [middle_nm],
             [last_nm],
             [suffix],
             [degree],
             [mpi_lname_cons],
             [mpi_fname_cons],
             [mpi_mname_cons],
             [start_dt]
            )
    VALUES
            (@PersonId,
             CAST(@RecognizeNmCd AS CHAR(2)),
             @SeqNo,
             @ActiveSw,
             @OrigPatientId,
             CAST(@Prefix AS NVARCHAR(4)),
             CAST(@FirstNm AS NVARCHAR(50)),
             CAST(@MiddleNm AS NVARCHAR(50)),
             CAST(@LastNm AS NVARCHAR(50)),
             CAST(@Suffix AS NVARCHAR(5)),
             CAST(@Degree AS NVARCHAR(20)),
             CAST(@mpiLnamecons AS NVARCHAR(20)),
             CAST(@mpiFnameCons AS NVARCHAR(20)),
             CAST(@mpiMnameCons AS NVARCHAR(20)),
             @startDt
            );
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Insert the persons demographic information.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_InsertPersonDemographics';

