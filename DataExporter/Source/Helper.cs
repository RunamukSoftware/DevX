// ------------------------------------------------------------------------------------------------
// File: Helper.cs
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
using System.IO;
using System.Xml;

namespace ICSDataExport
{
    /// <summary>
    /// Helper class is designed to handle ICSDataExport tasks
    /// </summary>
    public partial class Helper
    {
        private const string c_FileName = @"Dependencies\DataExporterConfig.xml";//config file name
        private const string c_ExportTag = "*/export_data";

        /// <summary>
        /// Loads xml document
        /// </summary>
        /// <param name="doc"></param>
        private void Load(out XmlDocument doc)
        {
            doc = null;
            FileStream xmlStream = null;

            try
            {
                string path = GetPath() + "\\" + c_FileName;

                if (File.Exists(path))
                {
                    xmlStream = new FileStream(path, FileMode.Open, FileAccess.Read, FileShare.Read);
                    doc = new XmlDocument();
                    doc.Load(xmlStream);
                }
            }
            finally
            {
                if (xmlStream != null)
                {
                    xmlStream.Close();
                }
            }
        }

        /// <summary>
        /// Gets executable location
        /// </summary>
        /// <returns></returns>
        private string GetPath()
        {
            System.Reflection.Assembly a = System.Reflection.Assembly.GetEntryAssembly();
            return Path.GetDirectoryName(a.Location);
        }

        /// <summary>
        /// Gets configuration data
        /// </summary>
        /// <param name="error"></param>
        /// <returns></returns>
        public List<DataInfo> GetConfiguration(out int error)
        {
            error = 0;
            XmlDocument doc = null;
            List<DataInfo> list = null;
            try
            {
                Load(out doc);

                if (doc != null)
                {
                    XmlNode node = doc.SelectSingleNode("*/export_data");

                    if (node != null)
                    {
                        list = new List<DataInfo>();
                        if (node.HasChildNodes)
                        {
                            string id = null;
                            foreach (XmlNode child in node.ChildNodes)
                            {
                                DataInfo expData = new DataInfo();
                                if (child.Attributes["tbl"] != null)
                                {
                                    expData.TableName = child.Attributes["tbl"].Value;
                                }
                                expData.FilterByID = false;
                                if (child.Attributes["patient_ID_filter"] != null)
                                {
                                    id = child.Attributes["patient_ID_filter"].Value;
                                    expData.FilterByID = Convert.ToBoolean(id);
                                }
                                if (child.Attributes["depend_table"] != null)
                                {
                                    id = child.Attributes["depend_table"].Value;
                                    expData.DependTable = id;
                                }
                                if (child.Attributes["depend_table_colm"] != null)
                                {
                                    id = child.Attributes["depend_table_colm"].Value;
                                    expData.DependColumn = id;
                                }

                                list.Add(expData);
                            }
                        }
                    }
                }
                else
                {
                    error = -1;
                }

            }
            catch (Exception)
            {
                error = -1;
            }

            return list;
        }
    }
}
