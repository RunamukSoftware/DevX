// ------------------------------------------------------------------------------------------------
// File: MainForm.cs
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
using System.IO;
using System.Windows.Forms;

namespace ICSDataExport
{
    /// <summary>
    /// ICSDataExport is designed to export predefined data from SQL database to data files.
    /// </summary>
    public partial class MainForm : Form
    {
        private string PatientID = string.Empty; //contains current Patient ID
        private List<PatientData> mPatList = null; //contains current list of Patients
        private ICSDataExporter mExporter = null;

        public MainForm()
        {
            InitializeComponent();
        }

        /// <summary>
        /// Initializes controls
        /// </summary>
        private void Initialize()
        {
            try
            {
                PasswordForm passwordForm = new PasswordForm();
                DialogResult result = passwordForm.ShowDialog();

                if (result != DialogResult.OK)
                {
                    this.Close();
                }
            }
            catch (Exception)
            {
                this.Close();
            }

            try
            {
                mExporter = new ICSDataExporter();
                mExporter.Initialize();
                mExporter.OnDataExportEvent += new ICSDataExporter.DataExportHandler(HandleDataExportEvent);

                //prompt to set database connection info
                DBInfoForm dbInfoForm = new DBInfoForm();
                dbInfoForm.ShowDialog();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Failed to load configuration data." + Environment.NewLine + "Error: " + ex.Message,
                    "Error", MessageBoxButtons.OKCancel, MessageBoxIcon.Error);
                this.Close();
            }
        }

        private void CheckSecurityPassword()
        {
            PasswordForm passwordForm = new PasswordForm();
            passwordForm.ShowDialog();
        }

        /// <summary>
        /// Allows user to choose path for saving files with exported data.
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void btnBrowse_Click(object sender, EventArgs e)
        {
            FolderBrowserDialog dlg = new FolderBrowserDialog();
            DialogResult result = dlg.ShowDialog();

            if (result == DialogResult.OK)
            {
                txtPath.Text = dlg.SelectedPath;
            }
        }

        /// <summary>
        /// Exports data to files.
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void btnExportData_Click(object sender, EventArgs e)
        {
            DialogResult result = DialogResult.OK;
            //check if patient is is selected
            if (string.IsNullOrEmpty(PatientID))
            {
                MessageBox.Show("Patient id is required.", "Error",
                                MessageBoxButtons.OK, MessageBoxIcon.Error);
                result = DialogResult.Cancel;
            }
            //check if file path is defined
            else if (string.IsNullOrEmpty(txtPath.Text) || !Directory.Exists(txtPath.Text))
            {
                MessageBox.Show("File directory is not valid.", "Error",
                                MessageBoxButtons.OK, MessageBoxIcon.Error);
                result = DialogResult.Cancel;
            }
            else if (!DataSource.HaveValidDBConnInfo)
            {
                DBInfoForm dbInfoForm = new DBInfoForm();
                result = dbInfoForm.ShowDialog();
            }

            if (result == DialogResult.OK)
            {
                try
                {
                    //get unique file id
                    string text = GetFileID();
                    if (text != null && text != string.Empty)
                    {
                        mExporter.FilePath = txtPath.Text;
                        mExporter.PatientId = PatientID;

                        SetButtonState(false);
                        this.Cursor = Cursors.WaitCursor;
                        mExporter.ExportData(text);
                    }
                    else
                    {
                        MessageBox.Show("File ID is required.", "Error",
                                        MessageBoxButtons.OK, MessageBoxIcon.Error);
                    }
                }
                catch (Exception ex)
                {
                    this.Cursor = Cursors.Default;
                    MessageBox.Show("Failed to export data." + Environment.NewLine + "Error: " + ex.Message, 
                        "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                }
            }
        }

        /// <summary>
        /// Get Unique file id
        /// </summary>
        /// <returns></returns>
        private string GetFileID()
        {
            string fileID = string.Empty;

            IDForm idForm = new IDForm();
            DialogResult result = idForm.ShowDialog();

            if (result == DialogResult.OK)
            {
                fileID = idForm.ID;
            }
            idForm.Close();
            this.Update();

            return fileID;
        }

        /// <summary>
        /// Close the form
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void OnClose(object sender, EventArgs e)
        {
            if (mExporter != null)
            {
                mExporter.Exit();
            }
            DataSource.ClearDBConn();
            this.Close();
        }

        /// <summary>
        /// Closing form
        /// </summary>
        /// <param name="e"></param>
        protected override void OnClosing(CancelEventArgs e)
        {
            if (mExporter != null)
            {
                mExporter.Exit();
            }
            base.OnClosing(e);
        }

        /// <summary>
        /// Selects current patient
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void cboPatient_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (cboPatient.SelectedIndex > -1)
            {
                try
                {
                    //get selected patient id
                    PatientID = ((PatientData)cboPatient.SelectedValue).PatientId;
                }
                catch (Exception)
                {
                    PatientID = string.Empty;
                    cboPatient.DataSource = null;
                    cboPatient.Items.Clear();
                }
            }
        }

        /// <summary>
        /// Searches for the patient
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void btnSearch_Click(object sender, EventArgs e)
        {
            PatientID = string.Empty;

            //list may changes, so clear combobox
            cboPatient.DataSource = null;
            cboPatient.Items.Clear();

            if (!string.IsNullOrEmpty(txtSearch.Text))
            {
                try
                {
                    DialogResult result = DialogResult.OK;

                    if (!DataSource.HaveValidDBConnInfo)
                    {
                        DBInfoForm dbInfoForm = new DBInfoForm();
                        result = dbInfoForm.ShowDialog();
                    }
                    if (result == DialogResult.OK)
                    {
                        //get patient list
                        GetPatientList(out mPatList);

                        if (mPatList != null && mPatList.Count > 0)
                        {
                            cboPatient.DataSource = mPatList;
                            cboPatient.DisplayMember = "FullName";
                            cboPatient.SelectedIndex = 0;
                        }
                        else
                        {
                            MessageBox.Show("Patient is not found.", "Information",
                                            MessageBoxButtons.OK, MessageBoxIcon.Information);
                        }
                    }
                }
                catch (Exception ex)
                {
                    MessageBox.Show("Failed to load patient data." + Environment.NewLine + "Error: " + ex.Message, 
                        "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                }
            }
            else
            {
                MessageBox.Show("Search data is required.", "Error",
                                MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        /// <summary>
        /// Gets patient list
        /// </summary>
        /// <param name="list"></param>
        private void GetPatientList(out List<PatientData> list)
        {
            list = null;
            int error = -1;

            //get patient list from data storage
            if (optPatientID.Checked)
            {
                // Search patient by MRN
                list = DataSource.GetPatientByExtId(txtSearch.Text, out error);
            }
            else
            {
                // Search patient by Last Name
                list = DataSource.GetPatientByLastName(txtSearch.Text, out error);
            }

            if (error < 0)
            {
                MessageBox.Show("Failed to load patient data.", "Error",
                                MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        /// <summary>
        /// Selects patient search by MRN
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void optPatientID_CheckedChanged(object sender, EventArgs e)
        {
            if (optPatientID.Checked)
            {
                optLastName.Checked = false;
            }
        }

        /// <summary>
        /// Selects patient search by Last Name
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void optLastName_CheckedChanged(object sender, EventArgs e)
        {
            if (optLastName.Checked)
            {
                optPatientID.Checked = false;
            }
        }

        /// <summary>
        /// Load the form
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void MainForm_Load(object sender, EventArgs e)
        {
            mPatList = new List<PatientData>();
            Initialize();

            this.txtSearch.Focus();
        }

        /// <summary>
        /// Creates DBInfo form
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void btnDBConn_Click(object sender, EventArgs e)
        {
            DBInfoForm dbInfoForm = new DBInfoForm();
            dbInfoForm.ShowDialog();
            this.Update();
            this.Activate();
        }

        /// <summary>
        /// Handles ICSDataExport event
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="error"></param>
        private void HandleDataExportEvent(object sender, int error)
        {
            SetButtonState(true);
            if (error < 0)
            {
                MessageBox.Show("Data export is complete with errors.", "Error",
                                MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            else
            {
                MessageBox.Show("Data export is complete. Check log file.", "Information",
                                MessageBoxButtons.OK, MessageBoxIcon.Information);
            }
            this.Cursor = Cursors.Default;
        }

        /// <summary>
        /// Sets button state
        /// </summary>
        /// <param name="state"></param>
        private void SetButtonState(bool state)
        {
            btnDBConn.Enabled = state;
            btnSearch.Enabled = state;
            btnExportData.Enabled = state;
            btnBrowse.Enabled = state;
        }

        private void btnExportWave_Click(object sender, EventArgs e)
        {
            DialogResult result = DialogResult.OK;
            //check if patient is is selected
            if (string.IsNullOrEmpty(PatientID))
            {
                MessageBox.Show("Patient id is required.", "Error",
                                MessageBoxButtons.OK, MessageBoxIcon.Error);
                result = DialogResult.Cancel;
            }
            //check if file path is defined
            else if (string.IsNullOrEmpty(txtPath.Text) || !Directory.Exists(txtPath.Text))
            {
                MessageBox.Show("File directory is not valid.", "Error",
                                MessageBoxButtons.OK, MessageBoxIcon.Error);
                result = DialogResult.Cancel;
            }
            else if (!DataSource.HaveValidDBConnInfo)
            {
                DBInfoForm dbInfoForm = new DBInfoForm();
                result = dbInfoForm.ShowDialog();
            }

            if (result == DialogResult.OK)
            {
                try
                { //get unique file id
                    string fileID = GetFileID();

                    if (!string.IsNullOrEmpty(fileID))
                    {
                        WaveFormHelper waveFormHelper = new WaveFormHelper();
                        string path = txtPath.Text;
                        string DateTimeValue;
                        DateTime now = DateTime.Now;
                        string dformat = "yyyy-MM-dd_hh-mm-ss-tt";
                        DateTimeValue = now.ToString(dformat);

                        string filePathName = path + "\\" + "WaveformSampleInfo" + "_" + fileID + "_" + DateTimeValue + ".txt";
                        waveFormHelper.FilePath = path;

                        long startft = 0;
                        long endft = 0;
                        StreamWriter writer = File.AppendText(filePathName);
                        writer.AutoFlush = true;
                        writer.WriteLine("\r\n");
                        writer.WriteLine("\r\n");
                        writer.WriteLine("\r\n");
                        writer.WriteLine("ChannelName\tSampleRate\tStartFT\t\t\t\tEndFT\t\t\t\tSampleCount\r\n");
                        writer.WriteLine("=================================================================================================================");

                        //for each channel
                        //  helper.LoadPatientChannels(mPatID);
                        waveFormHelper.LoadPatientChannels(PatientID, fileID, DateTimeValue);

                        foreach (Object obj in waveFormHelper.PatChannelToChannelType.Keys)
                        {
                            ChannelInformation channelinfo = (ChannelInformation)waveFormHelper.PatChannelToChannelType[obj as string];
                            startft = waveFormHelper.GetPatientStartFt(PatientID, obj as string);
                            endft = waveFormHelper.GetPatientEndFt(PatientID, obj as string);

                            long samples = waveFormHelper.GetPatientWaveform(PatientID, channelinfo.Rate, startft, endft);

                            writer.WriteLine(string.Format("{0}\t\t{1}\t\t{2}\t\t{3}\t\t{4}", channelinfo.Label, channelinfo.Rate.ToString(), 
                                startft.ToString(), endft.ToString(), samples.ToString()));
                        }

                        writer.Close();

                        MessageBox.Show("Binary WaveForm data and 'WaveformSampleInfo.txt' files are exported. Check Folder Path Location.",
                                         "Information", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    }
                    else
                    {
                        MessageBox.Show("File ID is required.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    }
                }

                catch (Exception ex)
                {
                    this.Cursor = Cursors.Default;
                    MessageBox.Show("Failed to export waveform data." + Environment.NewLine + "Error: " + ex.Message, 
                        "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                }
            }
        }
    }
}
