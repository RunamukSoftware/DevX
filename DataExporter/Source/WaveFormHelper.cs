using ICSharpCode.SharpZipLib.Zip.Compression;
// ------------------------------------------------------------------------------------------------
// File: WaveFormHelper.cs
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
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Text;
using System.Windows.Forms;

namespace ICSDataExport
{
    public class WaveFormHelper
    {
        private const long mTicksPerSecond = 10000000;
        private string fileExportPath;
        private string labelData;
        private char letter = 'a';

        /// <summary>
        /// Gets file path
        /// </summary>
        public string FilePath { get; set; }

        public Dictionary<string, object> PatChannelToChannelType = new Dictionary<string, object>();


        private bool FileExists(string rootpath, string filename)
        {
            bool status = false;
            if (File.Exists(Path.Combine(rootpath, filename)))
                status = true;

            return status;
        }


        private bool NewFileExists(string rootpath, string Nfilename)
        {
            bool status = false;
            if (File.Exists(Path.Combine(rootpath, Nfilename)))
            {
                letter = Convert.ToChar(Convert.ToInt32(letter) + 1);
                status = true;
            }

            return status;
        }


        public long GetPatientWaveform(string patientId, int samplesPerSecond, Int64 startft, Int64 endft)
        {
            return ComputeFtDiff(endft, startft, samplesPerSecond);
        }
        
        /// <summary>
        /// Compute the sample count difference between two filetime values
        /// </summary>
        /// <param name="bigInt"></param>
        /// <param name="smallInt"></param>
        /// <param name="sampleRate"></param>
        /// <returns></returns>
        public long ComputeFtDiff(Int64 bigInt, Int64 smallInt, int sampleRate)
        {
            long diff = (bigInt - smallInt) * sampleRate;
            diff += mTicksPerSecond / 2;			// round up
            diff /= mTicksPerSecond;
            return diff;
        }

                /// <summary>
        /// 
        /// </summary>
        /// <param name="patientId"></param>
        /// <param name="fileID"></param>
        public void LoadPatientChannels(string patientId, string fileID, string dateTimeValue)
        {
            if (DataSource.OpenConnection())
            {
                SqlDataReader sqlDataReader = null;

                string LoadPatChID = ConfigurationManager.AppSettings["LoadPatChQuery"].ToString();
                SqlCommand sqlcmd = new SqlCommand(LoadPatChID, DataSource.SqlConn);

                SqlParameter patientidParam = new SqlParameter("@patient_id", SqlDbType.UniqueIdentifier, 50);
                Guid guidPatientId = new Guid(patientId);
                patientidParam.Value = guidPatientId;
                sqlcmd.Parameters.Add(patientidParam);
                sqlDataReader = sqlcmd.ExecuteReader();

                while (sqlDataReader.Read())
                {
                    Guid patient_channel_id = (Guid)sqlDataReader["patient_channel_id"];
                    string label = (string)sqlDataReader["label"];
                    Guid channel_type_id = (Guid)sqlDataReader["channel_type_id"];
                    Int32 freq = Convert.ToInt32(sqlDataReader["freq"]);
                    load_binary_waveform(patient_channel_id, patientId, channel_type_id, freq, label, FilePath, fileID, dateTimeValue);
                    ChannelInformation channel = new ChannelInformation(patient_channel_id, labelData, freq, channel_type_id, guidPatientId);
                    PatChannelToChannelType.Add(patient_channel_id.ToString(), channel);
                }
            }
        }

        private const int mBytesPerSample = 2;
        private const int mBlankDataFlag = 0x1000;

        public static void BlankFill(ref int[] buffer, ref long offset, long numSamples)
        {
            while (numSamples > 0)
            {
                buffer[offset++] = mBlankDataFlag;
                numSamples--;
            }
        }

        /// <summary>
        /// Add samples to a filetime value
        /// </summary>
        /// <param name="startFt"></param>
        /// <param name="numSamples"></param>
        /// <param name="sampleRate"></param>
        /// <returns></returns>
        public static Int64 AddSamplesToFileTime(Int64 startFt, long numSamples, int sampleRate)
        {
            Int64 endFt = startFt + (mTicksPerSecond * numSamples) / sampleRate;
            return endFt;
        }


        public void load_binary_waveform(Guid patient_channel_id, string patientId, Guid channel_type_id, int samplesPerSecond,
                                         string label, string filePath, string fileId, string dateTimeValue)
        {
            if (DataSource.OpenConnection())
            {
                LabelInfo labelText = new LabelInfo();
                labelText.Label = label;
                labelText.FileID = fileId;
                labelText.Letter = letter;
                labelText.date = dateTimeValue;

                bool exist = FileExists(filePath, labelText.FileName);
                bool newfileexist = NewFileExists(filePath, labelText.NewFileName);
                while (newfileexist == true)
                {
                    labelText.Letter = letter;
                    newfileexist = NewFileExists(filePath, labelText.NewFileName);
                }
                labelText.Letter = letter;

                SqlDataReader sqlDataReader;
                string LoadWaveformdata = ConfigurationManager.AppSettings["LoadBinWaveform"].ToString();
                SqlCommand sqlcmd = new SqlCommand(LoadWaveformdata, DataSource.SqlConn);

                SqlParameter patientidParam = new SqlParameter("@patient_id", SqlDbType.UniqueIdentifier, 50);
                Guid guidPatientId = new Guid(patientId);
                patientidParam.Value = guidPatientId;
                sqlcmd.Parameters.Add(patientidParam);

                SqlParameter patientchannelParam = new SqlParameter("@patient_channel_id", SqlDbType.UniqueIdentifier, 50);
                patientchannelParam.Value = patient_channel_id;
                sqlcmd.Parameters.Add(patientchannelParam);

                sqlDataReader = sqlcmd.ExecuteReader();


                int waveFormDataColPos = sqlDataReader.GetOrdinal("waveform_data");
                while (sqlDataReader.Read())
                {
                    object waveformobj = sqlDataReader["waveform_data"];
                    byte[] waveformbyte = (Byte[])waveformobj;
                    long StartFt = (long)sqlDataReader["start_ft"];
                    long EndFt = (long)sqlDataReader["end_ft"];

                    long rowSamples = ComputeFtDiff(EndFt, StartFt, samplesPerSecond);

                    Inflater inflate = new Inflater();
                    long uncomprLen = rowSamples * mBytesPerSample;
                    byte[] newBuffer = new byte[uncomprLen];
                    inflate.Reset();

                    // decompress the waveform buffer
                    inflate.SetInput(waveformbyte);
                    long rowBytes = inflate.Inflate(newBuffer);

                    FileStream writeStream;
                    try
                    {
                        if (exist == false && newfileexist == false)
                            fileExportPath = filePath + "\\" + labelText.FileName;
                        else
                            fileExportPath = filePath + "\\" + labelText.NewFileName;
                        writeStream = new FileStream(fileExportPath, FileMode.Append);
                        BinaryWriter writeBinay = new BinaryWriter(writeStream);
                        writeBinay.Write(newBuffer);
                        writeBinay.Close();

                    }
                    catch (Exception ex)
                    {
                        MessageBox.Show("Failed to write binary data." + Environment.NewLine + "Error: " + ex.Message, 
                            "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);

                    }
                }

                FileInfo f = new FileInfo(fileExportPath);
                labelData = f.Name;
                int i = labelData.IndexOf('_');
                labelData = labelData.Remove(i);
            }
        }

        public Int64 GetPatientStartFt(string patId, string channel)
        {
            Int64 start = Int64.MinValue;
            Object obj = ExecuteScalar("select min(start_ft) from int_waveform where patient_id =" + "'" + patId + "'" + " and patient_channel_id=" + "'" + channel + "'");
            if (obj != null || !(obj is DBNull))
                start = Convert.ToInt64(obj);
            return start;
        }

        public Int64 GetPatientEndFt(string patId, string channel)
        {
            Int64 end = Int64.MinValue;
            Object obj = ExecuteScalar("select max(end_ft) from int_waveform where patient_id =" + "'" + patId + "'" + " and patient_channel_id=" + "'" + channel + "'");
            if (obj != null || !(obj is DBNull))
                end = Convert.ToInt64(obj);
            return end;
        }

        public object ExecuteScalar(string query)
        {
            SqlCommand commd = new SqlCommand(query);
            commd.Connection = DataSource.SqlConn;
            return commd.ExecuteScalar();
        }
    }

    public class ChannelInformation
    {
        public string Label { get; set; }
        public Guid Channel_Type_Id { get; set; }
        public int Rate { get; set; }
        public Guid Patient_Channel_Id { get; set; }
        public Guid Patient_Id { get; set; }

        public ChannelInformation(Guid patient_channel_id, string label, int samplerate, Guid channelTypeId, Guid patient_id)
        {
            this.Patient_Channel_Id = patient_channel_id;
            this.Label = label;
            this.Channel_Type_Id = channelTypeId;
            this.Rate = samplerate;
            this.Patient_Id = patient_id;
        }
    }

    public struct LabelInfo
    {
        public string Label { get; set; }
        public string FileID { get; set; }
        public char Letter { get; set; }
        public string date;

        public string NewFileName
        {
            get
            {
                StringBuilder strBuilder = new StringBuilder();
                strBuilder.Append(Label);
                if (!(Letter.Equals('z')))
                {
                    strBuilder.Append(Letter);
                }
                strBuilder.Append("_");
                strBuilder.Append(FileID);
                strBuilder.Append("_");
                strBuilder.Append(date);
                strBuilder.Append(".bin");

                return strBuilder.ToString();
            }
        }

        public string FileName
        {
            get
            {
                StringBuilder strBuilder = new StringBuilder();
                strBuilder.Append(Label);
                strBuilder.Append("_");
                strBuilder.Append(FileID);
                strBuilder.Append("_");
                strBuilder.Append(date);
                strBuilder.Append(".bin");
                return strBuilder.ToString();
            }
        }
    }
}
