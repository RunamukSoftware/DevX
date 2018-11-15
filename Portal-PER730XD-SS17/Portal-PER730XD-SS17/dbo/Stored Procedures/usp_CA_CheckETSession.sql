CREATE PROCEDURE [dbo].[usp_CA_CheckETSession]  
(
@patient_id UNIQUEIDENTIFIER
)
AS
  BEGIN
    SELECT TOP 1 Sequence
    FROM dbo.PatientSessionsMap
    INNER JOIN
    (
    SELECT MAX(Sequence) AS MaxSeq
        FROM dbo.PatientSessionsMap
        GROUP BY PatientSessionId
    ) AS PatientSessionMaxSeq
        ON Sequence = PatientSessionMaxSeq.MaxSeq
    WHERE PatientId = @patient_id
  END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Check the latest electronic transmitter sequence number for a patient.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_CA_CheckETSession';

