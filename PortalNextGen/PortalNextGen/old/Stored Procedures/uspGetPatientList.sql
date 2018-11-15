CREATE PROCEDURE [old].[uspGetPatientList]
    (
        @Filters           NVARCHAR(MAX) = N'',
        @ShowADTEncounters BIT,
        @Debug             BIT           = 0
    )
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE @SqlQuery NVARCHAR(MAX);

        SET @SqlQuery
            = N'
SELECT
    [vce].[FIRST_NAME] AS [First Name],
    [vce].[LAST_NAME] AS [Last Name],
    [vce].[MedicalRecordNumberID] AS [Patient ID],
    [vce].[AccountID] AS [Patient ID2],
    [vce].[DateOfBirth] AS [DateOfBirth],
    ISNULL([org1].[OrganizationCode], N''-'') + N'' '' + ISNULL([org2].[OrganizationCode], N''-'') + N'' ''
    + ISNULL([vce].[Room], N''-'') + N'' '' + ISNULL([vce].[Bed], N''-'') AS [Location],
    [vce].[MonitorName] AS [Device],
    [vce].[LastResult] AS [Last Result],
    [vce].[Admit] AS [Admitted],
    [vce].[Discharged] AS [Discharged],
    [vce].[Subnet] AS [Subnet],
    [vce].[PatientID] AS [GUID],
    [vce].[FacilityParentID] AS [ParentOrganizationID]
FROM [old].[vwCombinedEncounters] AS [vce]
    INNER JOIN [Intesys].[organization] AS [org1]
        ON [org1].[OrganizationID] = [vce].[FacilityID]
    INNER JOIN [Intesys].[organization] AS [org2]
        ON [org2].[OrganizationID] = [vce].[UnitID]
WHERE [vce].[MergeCode] = ''C''
'       ;

        IF (@ShowADTEncounters <> 1)
            SET @SqlQuery += N' AND [vce].[PatientMonitorID] IS NOT NULL AND [vce].[MonitorCreated] = 1';

        IF (LEN(@Filters) > 0)
            BEGIN
                SET @SqlQuery += N' AND ' + @Filters;
            END;

        IF (@Debug = 1)
            PRINT @SqlQuery;

        EXEC [sys].[sp_executesql]
            @SqlQuery;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetPatientList';

