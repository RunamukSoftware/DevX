// ------------------------------------------------------------------------------------------------
// File: DataStruct.cs
// © Copyright 2013 Spacelabs Healthcare, Inc.
//
// This document contains proprietary trade secret and confidential information
// which is the property of Spacelabs Healthcare, Inc.  This document and the
// information it contains are not to be copied, distributed, disclosed to others,
// or used in any manner outside of Spacelabs Healthcare, Inc. without the prior
// written approval of Spacelabs Healthcare, Inc.
// ------------------------------------------------------------------------------------------------
//
using System.Text;

namespace ICSDataExport
{
    /// <summary>
    /// PatientData contains patient data
    /// </summary>
    public partial class PatientData
    {
        /// <summary>
        /// Gets and Sets patient internal unique identifier
        /// </summary>
        public string PatientId { get; set; }

        /// <summary>
        /// Gets and sets patient external id
        /// </summary>
        public string ExternalId { get; set; }

        /// <summary>
        /// Gets and sets patient first name
        /// </summary>
        public string FirstName { get; set; }

        /// <summary>
        /// Gets and sets patient last name
        /// </summary>
        public string LastName { get; set; }

        /// <summary>
        /// Gets patient full name
        /// </summary>
        public string FullName
        {
            get
            {
                StringBuilder strBuilder = new StringBuilder();
                strBuilder.Append(ExternalId);

                if (!string.IsNullOrEmpty(LastName))
                {
                    strBuilder.Append(" - ");
                    strBuilder.Append(LastName);

                    if (!string.IsNullOrEmpty(FirstName))
                    {
                        strBuilder.Append(",");
                        strBuilder.Append(FirstName);
                    }
                }
                else if (string.IsNullOrEmpty(LastName) && !string.IsNullOrEmpty(FirstName))
                {
                    strBuilder.Append(" - ");
                    strBuilder.Append(FirstName);
                }

                return strBuilder.ToString();
            }
        }
    }

    /// <summary>
    /// DataInfo class is designed to hold table/file related data
    /// </summary>
    public struct DataInfo
    {
        public string TableName { get; set; }
        public string FileID { get; set; }
        public bool FilterByID { get; set; }
        public string DependTable { get; set; }
        public string DependColumn { get; set; }

        public string FileName
        {
            get
            {
                StringBuilder strBuilder = new StringBuilder();
                strBuilder.Append(TableName);
                strBuilder.Append("_");
                strBuilder.Append(FileID);
                strBuilder.Append(".dat");
                return strBuilder.ToString();
            }
        }
    }
}