CREATE FUNCTION fn_AcademicYear
(
    -- Add the parameters for the function here
    @StartDate DateTime
)
RETURNS 
@AcademicYear TABLE 
(
    AcademicYear int
)
AS
BEGIN

DECLARE @YearOffset int, @AcademicStartDate DateTime 

    -- Lookup Academic Year Starting Date
    SELECT @AcademicStartDate = CONVERT(DateTime,[Value])
    FROM dbo.SystemSetting
    WHERE [Key] = 'AcademicYear.StartDate'

    SET @YearOffset = DATEPART(YYYY,@StartDate) - DATEPART(YYYY,@AcademicStartDate);
    -- try setting academic looking start date to year of the date passed in
    SET @AcademicStartDate = DATEADD(YYYY, @YearOffset, @AcademicStartDate);

    IF @StartDate < @AcademicStartDate
    BEGIN
        SET @AcademicStartDate = DATEADD(YYYY, @YearOffset-1, @AcademicStartDate);
    END

      INSERT @AcademicYear
      SELECT YEAR(@AcademicStartDate)

    RETURN 
END
