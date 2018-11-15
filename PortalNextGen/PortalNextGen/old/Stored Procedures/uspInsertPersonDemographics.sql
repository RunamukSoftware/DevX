CREATE PROCEDURE [old].[uspInsertPersonDemographics]
    (
        @PersonID          INT,
        @RecognizeNameCode CHAR(2)      = NULL,
        @SequenceNumber    INT          = NULL,
        @ActiveSwitch      BIT,
        @OrigPatientID     INT          = NULL,
        @Prefix            NVARCHAR(4)  = NULL,
        @FirstName         NVARCHAR(50) = NULL,
        @MiddleName        NVARCHAR(50) = NULL,
        @LastName          NVARCHAR(50) = NULL,
        @Suffix            NVARCHAR(5)  = NULL,
        @Degree            NVARCHAR(20) = NULL,
        @mpiLnamecons      NVARCHAR(20) = NULL,
        @mpiFnameCons      NVARCHAR(20) = NULL,
        @mpiMnameCons      NVARCHAR(20) = NULL,
        @StartDateTime     DATETIME2(7) = NULL
    )
AS
    BEGIN
        SET NOCOUNT ON;

        IF (@StartDateTime IS NULL)
            SET @StartDateTime = SYSUTCDATETIME();

        INSERT INTO [Intesys].[PersonName]
            (
                [PersonNameID],
                [RecognizeNameCode],
                [SequenceNumber],
                [ActiveSwitch],
                [OriginalPatientID],
                [Prefix],
                [FirstName],
                [MiddleName],
                [LastName],
                [Suffix],
                [Degree],
                [mpi_lname_cons],
                [mpi_fname_cons],
                [mpi_mname_cons],
                [StartDateTime]
            )
        VALUES
            (
                @PersonID, @RecognizeNameCode, @SequenceNumber, @ActiveSwitch, @OrigPatientID, @Prefix, @FirstName,
                @MiddleName, @LastName, @Suffix, @Degree, @mpiLnamecons, @mpiFnameCons, @mpiMnameCons, @StartDateTime
            );
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Insert the persons demographic information.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspInsertPersonDemographics';

