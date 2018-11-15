// ------------------------------------------------------------------------------------------------
// File: DataExporter.cs
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
using System.ComponentModel;
using System.Diagnostics;
using System.IO;
using System.Text;
using System.Threading;

namespace ICSDataExport
{
    /// <summary>
    /// The ICSDataExporter class is designed to export waveform related to data files
    /// </summary>
    public class ICSDataExporter
    {
        /// <summary>
        /// Gets patient id
        /// </summary>
        public string PatientId { get; set; }

        /// <summary>
        /// Gets file path
        /// </summary>
        public string FilePath { get; set; }

        public delegate void DataExportHandler(object sender, int error);
        public event DataExportHandler OnDataExportEvent;

        internal const string c_LogFileName = "DataExporterLog.txt"; //contains log file name
        internal const string c_ProcessFileName = "bcp"; //contains process type info
        
        private List<DataInfo> _dataInfoList = null;
        private ProcessStartInfo _processInfo = null; //contains process start info
        private Process _processHandle = null; //contains process object

        /// <summary>
        /// Initializes ICSDataExport
        /// </summary>
        public void Initialize()
        {
            int error = -1;

            Helper helper = new Helper();
            _dataInfoList = helper.GetConfiguration(out error);

            if (error < 0 || _dataInfoList == null)
            {
                throw new Exception();
            }
        }

        /// <summary>
        /// Creates process
        /// </summary>
        private void CreateProcess()
        {
            if (_processHandle == null)
            {
                _processInfo = new ProcessStartInfo(c_ProcessFileName);
                _processInfo.CreateNoWindow = true;
                _processInfo.UseShellExecute = false;
                _processInfo.RedirectStandardOutput = true;
                _processInfo.RedirectStandardError = true;
                _processHandle = new Process();
            }
        }

        /// <summary>
        /// Exports data
        /// </summary>
        /// <param name="text"></param>
        public void ExportData(string text)
        {
            if (_dataInfoList != null && PatientId != null && FilePath != null)
            {
                try
                {
                    LogResult("Data export started: " + DateTime.Now.ToShortDateString() + DateTime.Now.ToLongTimeString());
                    //creates process
                    CreateProcess();
                    Execute(text);
                    //sends event
                    SendEvent(0);
                }
                catch (Win32Exception)
                {
                    Exit();
                    SendEvent(-1);
                }
                catch (Exception)
                {
                    Exit();
                    SendEvent(-1);
                }
            }
        }

        /// <summary>
        /// Sends event on error or failure
        /// </summary>
        /// <param name="error"></param>
        private void SendEvent(int error)
        {
            if (OnDataExportEvent != null)
            {
                OnDataExportEvent(this, error);
            }
        }

        /// <summary>
        /// Sets arguments
        /// </summary>
        /// <param name="text"></param>
        private void Execute(string text)
        {
            for (int count = 0; count < _dataInfoList.Count; count++)
            {
                DataInfo data = _dataInfoList[count];
                data.FileID = text;
                _processInfo.Arguments = GetExpression(data);
                LogResult("Start exporting data into  " + data.TableName + ".dat file");
                Start();
                Thread.Sleep(200);
            }
            LogResult("Data export is complete: " + DateTime.Now.ToShortDateString() + DateTime.Now.ToLongTimeString());
        }

        /// <summary>
        /// Gets expression
        /// </summary>
        /// <param name="data"></param>
        /// <returns></returns>
        private string GetExpression(DataInfo data)
        {
            string selectClause = @"SELECT {0}.* FROM {1}.dbo.{0}";
            string joinClause = @" INNER JOIN {0} ON {0}.{2}={1}.{2}";
            string whereClause = @" WHERE patient_id ='{0}'";

            selectClause = string.Format(selectClause, data.TableName, DataSource.DBName);
            if (!string.IsNullOrEmpty(data.DependTable))
            {
                joinClause = string.Format(joinClause, data.DependTable, data.TableName, data.DependColumn);
                selectClause = selectClause + joinClause;
            }

            whereClause = string.Format(whereClause, PatientId);
            string whereExpression = string.Empty;
            string bcpArg = " -S " + DataSource.DBServer + " -U " + DataSource.DBUser + " -P " + DataSource.DBPassword + " -t -n";//" -c  -t -n";
            string filePath = FilePath + "\\" + data.FileName;
            if (data.FilterByID)
            {
                whereExpression = whereClause;
            }
            string sqlExpression = "\" " + selectClause + whereExpression + "\"" + " queryout " + filePath + bcpArg;
            return sqlExpression;
        }

        ///<summary>
        ///Run process for specific table
        ///</summary>
        ///<param name="table_name"></param>
        private void Start()
        {
            _processHandle.StartInfo = _processInfo;
            _processHandle.Start();
            LogResult("Total Processor Time: " + _processHandle.TotalProcessorTime.ToString());
            LogResult("Result: " + _processHandle.StandardOutput.ReadToEnd());
        }

        private void LogResult(string text)
        {
            try
            {
                FileStream stream = new FileStream(FilePath + "\\" + c_LogFileName, FileMode.Append, FileAccess.Write);
                StringBuilder strBuilder = new StringBuilder();
                strBuilder.Append(text);
                strBuilder.AppendLine();
                strBuilder.AppendLine();

                string msg = strBuilder.ToString();
                stream.Write(ASCIIEncoding.Unicode.GetBytes(msg), 0, ASCIIEncoding.Unicode.GetByteCount(msg));

                stream.Close();
            }
            catch (Exception) { }
        }

        /// <summary>
        /// Releases process resources
        /// </summary>
        public void Exit()
        {
            if (_processHandle != null)
            {
                _processHandle.Close();
            }
            _processHandle = null;
        }
    }
}
