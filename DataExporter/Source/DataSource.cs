// ------------------------------------------------------------------------------------------------
// File: DataSource.cs
// © Copyright 2013 Spacelabs Healthcare, Inc.
//
// This document contains proprietary trade secret and confidential information
// which is the property of Spacelabs Healthcare, Inc.  This document and the
// information it contains are not to be copied, distributed, disclosed to others,
// or used in any manner outside of Spacelabs Healthcare, Inc. without the prior
// written approval of Spacelabs Healthcare, Inc.
// ------------------------------------------------------------------------------------------------
//
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace ICSDataExport
{
    /// <summary>
    /// DataSource is static class which is designed to connect to specified database
    /// </summary>
    static public partial class DataSource
    {
        /// <summary>
        /// Gets and Sets value for SqlConn
        /// </summary>
        static public SqlConnection SqlConn { get; set; }

        /// <summary>
        /// Gets and Sets value for DB Server
        /// </summary>
        static public string DBServer { get; set; }

        /// <summary>
        /// Gets and Sets value for DB User
        /// </summary>
        static public string DBUser { get { return "Portal"; } }

        /// <summary>
        /// Gets and Sets value for DB Name
        /// </summary>
        static public string DBName { get { return "portal"; } }

        /// <summary>
        /// Gets and Sets value for DB Password
        /// </summary>
        static public string DBPassword { get; set; }

        /// <summary>
        /// Gets and Sets value for DB Connection Exist
        /// </summary>
        static public bool HaveValidDBConnInfo { get; set; }

        /// <summary>
        /// Clears database connection information
        /// </summary>
        static public void ClearDBConn()
        {
            HaveValidDBConnInfo = false;
            DBServer = string.Empty;
            DBPassword = string.Empty;
        }

        /// <summary>
        /// Assembles DB Connection string
        /// </summary>
        static public string ConnectionString
        {
            get
            {
                SqlConnectionStringBuilder DBConnectionString = new SqlConnectionStringBuilder();

                DBConnectionString.UserID = DBUser;
                DBConnectionString.Password = DBPassword;
                DBConnectionString.DataSource = DBServer;
                DBConnectionString.InitialCatalog = DBName;
                DBConnectionString.IntegratedSecurity = false;
                DBConnectionString.MultipleActiveResultSets = true;

                return DBConnectionString.ConnectionString;
            }
        }

        /// <summary>
        /// Opens DB Connection 
        /// </summary>
        static public bool OpenConnection()
        {
            if (SqlConn == null || SqlConn.State != ConnectionState.Open)
            {
                SqlConn = new SqlConnection(ConnectionString);
                SqlConn.Open();
                HaveValidDBConnInfo = true;
            }
            else if (SqlConn != null && SqlConn.State == ConnectionState.Open)
            {
                HaveValidDBConnInfo = true;
            }
            else
            {
                HaveValidDBConnInfo = false;
            }

            return HaveValidDBConnInfo;

        }

        //Checks id database connection is valid
        static public bool CheckConnection()
        {
            try
            {
                OpenConnection();
                SqlConn.Close();
                HaveValidDBConnInfo = true;
            }
            catch (Exception)
            {
                HaveValidDBConnInfo = false;

                if (SqlConn != null && SqlConn.State != ConnectionState.Closed)
                {
                    SqlConn.Close();
                }
            }
            return HaveValidDBConnInfo;
        }

        /// <summary>
        /// Gets patients by MRN
        /// </summary>
        /// <param name="externalId"></param>
        /// <param name="error"></param>
        /// <returns></returns>
        static public List<PatientData> GetPatientByExtId(string externalId, out int error)
        {
            error = -1;
            string cmdText = "SELECT mrn.patient_id as ID, mrn.mrn_xid as MRN, person.first_nm as FIRSTNAME , person.last_nm as LASTNAME FROM int_mrn_map mrn Inner Join int_person person on mrn.patient_id = person.person_id where mrn_xid ='" + externalId + "'" + " and mrn.merge_cd ='C'";
            return GetPatientData(cmdText, out error);
        }

        /// <summary>
        /// Gets patients by Last name
        /// </summary>
        /// <param name="lastName"></param>
        /// <param name="error"></param>
        /// <returns></returns>
        static public List<PatientData> GetPatientByLastName(string lastName, out int error)
        {
            error = -1;
            string cmdText = "SELECT mrn.patient_id as ID, mrn.mrn_xid as MRN, person.first_nm as FIRSTNAME , person.last_nm as LASTNAME FROM int_mrn_map mrn Inner Join int_person person on mrn.patient_id = person.person_id where last_nm ='" + lastName + "'" + " and mrn.merge_cd ='C'";
            return GetPatientData(cmdText, out error);
        }


        /// <summary>
        /// Gets patient list from the database
        /// </summary>
        /// <param name="cmdText"></param>
        /// <param name="error"></param>
        /// <returns></returns>
        static private List<PatientData> GetPatientData(string cmdText, out int error)
        {
            List<PatientData> patList = null;
            SqlDataReader reader = null;
            error = -1;

            try
            {
                if (OpenConnection())
                {
                    SqlCommand command = new SqlCommand(cmdText, SqlConn);
                    command.CommandType = CommandType.Text;

                    reader = command.ExecuteReader();

                    if (reader != null)
                    {
                        patList = new List<PatientData>();

                        int colPatID = reader.GetOrdinal("ID");
                        int colMrn = reader.GetOrdinal("MRN");
                        int colFirstN = reader.GetOrdinal("FIRSTNAME");
                        int colLastN = reader.GetOrdinal("LASTNAME");

                        while (reader.Read())
                        {
                            PatientData patData = new PatientData();
                            patData.PatientId = reader.GetValue(colPatID).ToString();
                            patData.ExternalId = reader.GetValue(colMrn).ToString();
                            if (!reader.IsDBNull(colFirstN))
                            {
                                patData.FirstName = reader.GetValue(colFirstN).ToString();
                            }
                            if (!reader.IsDBNull(colFirstN))
                            {
                                patData.LastName = reader.GetValue(colLastN).ToString();
                            }

                            patList.Add(patData);
                        }
                    }
                    error = 0;
                    SqlConn.Close();
                }
            }
            catch (Exception)
            {
                error = -1;
                if (SqlConn != null)
                {
                    SqlConn.Close();
                }
            }

            return patList;
        }

    }


}
