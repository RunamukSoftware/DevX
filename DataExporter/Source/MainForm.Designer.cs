// ------------------------------------------------------------------------------------------------
// File: MainForm.Designer.cs
// © Copyright 2013 Spacelabs Healthcare, Inc.
//
// This document contains proprietary trade secret and confidential information
// which is the property of Spacelabs Healthcare, Inc.  This document and the
// information it contains are not to be copied, distributed, disclosed to others,
// or used in any manner outside of Spacelabs Healthcare, Inc. without the prior
// written approval of Spacelabs Healthcare, Inc.
// ------------------------------------------------------------------------------------------------
//
namespace ICSDataExport
{
    partial class MainForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(MainForm));
            this.grbPath = new System.Windows.Forms.GroupBox();
            this.btnBrowse = new System.Windows.Forms.Button();
            this.txtPath = new System.Windows.Forms.TextBox();
            this.lblPath = new System.Windows.Forms.Label();
            this.btnExportData = new System.Windows.Forms.Button();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.groupBox2 = new System.Windows.Forms.GroupBox();
            this.optLastName = new System.Windows.Forms.RadioButton();
            this.optPatientID = new System.Windows.Forms.RadioButton();
            this.btnSearch = new System.Windows.Forms.Button();
            this.txtSearch = new System.Windows.Forms.TextBox();
            this.cboPatient = new System.Windows.Forms.ComboBox();
            this.lblPatient = new System.Windows.Forms.Label();
            this.btnDBConn = new System.Windows.Forms.Button();
            this.btnExportWave = new System.Windows.Forms.Button();
            this.grbPath.SuspendLayout();
            this.groupBox1.SuspendLayout();
            this.groupBox2.SuspendLayout();
            this.SuspendLayout();
            // 
            // grbPath
            // 
            this.grbPath.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.grbPath.Controls.Add(this.btnBrowse);
            this.grbPath.Controls.Add(this.txtPath);
            this.grbPath.Controls.Add(this.lblPath);
            this.grbPath.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.grbPath.ForeColor = System.Drawing.SystemColors.ControlText;
            this.grbPath.Location = new System.Drawing.Point(10, 417);
            this.grbPath.Margin = new System.Windows.Forms.Padding(3, 4, 3, 4);
            this.grbPath.Name = "grbPath";
            this.grbPath.Padding = new System.Windows.Forms.Padding(3, 4, 3, 4);
            this.grbPath.Size = new System.Drawing.Size(919, 121);
            this.grbPath.TabIndex = 2;
            this.grbPath.TabStop = false;
            this.grbPath.Text = "Folder";
            // 
            // btnBrowse
            // 
            this.btnBrowse.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.btnBrowse.Font = new System.Drawing.Font("Arial", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnBrowse.Location = new System.Drawing.Point(725, 45);
            this.btnBrowse.Margin = new System.Windows.Forms.Padding(3, 4, 3, 4);
            this.btnBrowse.Name = "btnBrowse";
            this.btnBrowse.Size = new System.Drawing.Size(150, 30);
            this.btnBrowse.TabIndex = 2;
            this.btnBrowse.Text = "Browse";
            this.btnBrowse.UseVisualStyleBackColor = true;
            this.btnBrowse.Click += new System.EventHandler(this.btnBrowse_Click);
            // 
            // txtPath
            // 
            this.txtPath.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.txtPath.BackColor = System.Drawing.SystemColors.Window;
            this.txtPath.Font = new System.Drawing.Font("Arial", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.txtPath.ForeColor = System.Drawing.SystemColors.WindowText;
            this.txtPath.Location = new System.Drawing.Point(152, 47);
            this.txtPath.Margin = new System.Windows.Forms.Padding(3, 4, 3, 4);
            this.txtPath.Name = "txtPath";
            this.txtPath.Size = new System.Drawing.Size(547, 29);
            this.txtPath.TabIndex = 1;
            // 
            // lblPath
            // 
            this.lblPath.AutoSize = true;
            this.lblPath.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.8F);
            this.lblPath.Location = new System.Drawing.Point(20, 51);
            this.lblPath.Name = "lblPath";
            this.lblPath.Size = new System.Drawing.Size(52, 24);
            this.lblPath.TabIndex = 0;
            this.lblPath.Text = "Path:";
            // 
            // btnExportData
            // 
            this.btnExportData.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.btnExportData.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnExportData.ForeColor = System.Drawing.SystemColors.ControlText;
            this.btnExportData.Location = new System.Drawing.Point(504, 556);
            this.btnExportData.Margin = new System.Windows.Forms.Padding(3, 4, 3, 4);
            this.btnExportData.Name = "btnExportData";
            this.btnExportData.Size = new System.Drawing.Size(150, 30);
            this.btnExportData.TabIndex = 4;
            this.btnExportData.Text = "Export Data";
            this.btnExportData.UseVisualStyleBackColor = true;
            this.btnExportData.Click += new System.EventHandler(this.btnExportData_Click);
            // 
            // groupBox1
            // 
            this.groupBox1.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.groupBox1.Controls.Add(this.groupBox2);
            this.groupBox1.Controls.Add(this.cboPatient);
            this.groupBox1.Controls.Add(this.lblPatient);
            this.groupBox1.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.groupBox1.ForeColor = System.Drawing.SystemColors.ControlText;
            this.groupBox1.Location = new System.Drawing.Point(10, 60);
            this.groupBox1.Margin = new System.Windows.Forms.Padding(3, 4, 3, 4);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Padding = new System.Windows.Forms.Padding(3, 4, 3, 4);
            this.groupBox1.Size = new System.Drawing.Size(919, 320);
            this.groupBox1.TabIndex = 1;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "Patient Search";
            // 
            // groupBox2
            // 
            this.groupBox2.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.groupBox2.Controls.Add(this.optLastName);
            this.groupBox2.Controls.Add(this.optPatientID);
            this.groupBox2.Controls.Add(this.btnSearch);
            this.groupBox2.Controls.Add(this.txtSearch);
            this.groupBox2.Location = new System.Drawing.Point(23, 111);
            this.groupBox2.Name = "groupBox2";
            this.groupBox2.Size = new System.Drawing.Size(864, 177);
            this.groupBox2.TabIndex = 2;
            this.groupBox2.TabStop = false;
            this.groupBox2.Text = "Patient Search";
            // 
            // optLastName
            // 
            this.optLastName.AutoSize = true;
            this.optLastName.Font = new System.Drawing.Font("Arial", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.optLastName.Location = new System.Drawing.Point(221, 49);
            this.optLastName.Name = "optLastName";
            this.optLastName.Size = new System.Drawing.Size(117, 26);
            this.optLastName.TabIndex = 1;
            this.optLastName.Text = "LastName";
            this.optLastName.UseVisualStyleBackColor = true;
            this.optLastName.CheckedChanged += new System.EventHandler(this.optLastName_CheckedChanged);
            // 
            // optPatientID
            // 
            this.optPatientID.AutoSize = true;
            this.optPatientID.Checked = true;
            this.optPatientID.Font = new System.Drawing.Font("Arial", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.optPatientID.Location = new System.Drawing.Point(28, 49);
            this.optPatientID.Name = "optPatientID";
            this.optPatientID.Size = new System.Drawing.Size(114, 26);
            this.optPatientID.TabIndex = 0;
            this.optPatientID.TabStop = true;
            this.optPatientID.Text = "Patient ID";
            this.optPatientID.UseVisualStyleBackColor = true;
            this.optPatientID.CheckedChanged += new System.EventHandler(this.optPatientID_CheckedChanged);
            // 
            // btnSearch
            // 
            this.btnSearch.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.btnSearch.Font = new System.Drawing.Font("Arial", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnSearch.Location = new System.Drawing.Point(702, 114);
            this.btnSearch.Margin = new System.Windows.Forms.Padding(3, 4, 3, 4);
            this.btnSearch.Name = "btnSearch";
            this.btnSearch.Size = new System.Drawing.Size(150, 30);
            this.btnSearch.TabIndex = 3;
            this.btnSearch.Text = "Search";
            this.btnSearch.UseVisualStyleBackColor = true;
            this.btnSearch.Click += new System.EventHandler(this.btnSearch_Click);
            // 
            // txtSearch
            // 
            this.txtSearch.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.txtSearch.BackColor = System.Drawing.SystemColors.Window;
            this.txtSearch.Font = new System.Drawing.Font("Arial", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.txtSearch.ForeColor = System.Drawing.SystemColors.WindowText;
            this.txtSearch.Location = new System.Drawing.Point(129, 115);
            this.txtSearch.Margin = new System.Windows.Forms.Padding(3, 4, 3, 4);
            this.txtSearch.Name = "txtSearch";
            this.txtSearch.Size = new System.Drawing.Size(547, 29);
            this.txtSearch.TabIndex = 2;
            // 
            // cboPatient
            // 
            this.cboPatient.BackColor = System.Drawing.SystemColors.Window;
            this.cboPatient.Font = new System.Drawing.Font("Arial", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.cboPatient.ForeColor = System.Drawing.SystemColors.WindowText;
            this.cboPatient.FormattingEnabled = true;
            this.cboPatient.Location = new System.Drawing.Point(152, 41);
            this.cboPatient.Margin = new System.Windows.Forms.Padding(3, 4, 3, 4);
            this.cboPatient.Name = "cboPatient";
            this.cboPatient.Size = new System.Drawing.Size(547, 30);
            this.cboPatient.TabIndex = 1;
            this.cboPatient.SelectedIndexChanged += new System.EventHandler(this.cboPatient_SelectedIndexChanged);
            // 
            // lblPatient
            // 
            this.lblPatient.AutoSize = true;
            this.lblPatient.Font = new System.Drawing.Font("Arial", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblPatient.Location = new System.Drawing.Point(20, 46);
            this.lblPatient.Name = "lblPatient";
            this.lblPatient.Size = new System.Drawing.Size(73, 22);
            this.lblPatient.TabIndex = 0;
            this.lblPatient.Text = "Patient:";
            // 
            // btnDBConn
            // 
            this.btnDBConn.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.btnDBConn.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnDBConn.ForeColor = System.Drawing.SystemColors.ControlText;
            this.btnDBConn.Location = new System.Drawing.Point(735, 18);
            this.btnDBConn.Margin = new System.Windows.Forms.Padding(3, 4, 3, 4);
            this.btnDBConn.Name = "btnDBConn";
            this.btnDBConn.Size = new System.Drawing.Size(150, 30);
            this.btnDBConn.TabIndex = 0;
            this.btnDBConn.Text = "DB Connection";
            this.btnDBConn.UseVisualStyleBackColor = true;
            this.btnDBConn.Click += new System.EventHandler(this.btnDBConn_Click);
            // 
            // btnExportWave
            // 
            this.btnExportWave.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.btnExportWave.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnExportWave.ForeColor = System.Drawing.SystemColors.ControlText;
            this.btnExportWave.Location = new System.Drawing.Point(237, 556);
            this.btnExportWave.Margin = new System.Windows.Forms.Padding(3, 4, 3, 4);
            this.btnExportWave.Name = "btnExportWave";
            this.btnExportWave.Size = new System.Drawing.Size(190, 30);
            this.btnExportWave.TabIndex = 3;
            this.btnExportWave.Text = "Export Waveform";
            this.btnExportWave.UseVisualStyleBackColor = true;
            this.btnExportWave.Click += new System.EventHandler(this.btnExportWave_Click);
            // 
            // MainForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(10F, 20F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.SystemColors.Control;
            this.ClientSize = new System.Drawing.Size(943, 609);
            this.Controls.Add(this.btnExportWave);
            this.Controls.Add(this.btnExportData);
            this.Controls.Add(this.btnDBConn);
            this.Controls.Add(this.grbPath);
            this.Controls.Add(this.groupBox1);
            this.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.Margin = new System.Windows.Forms.Padding(3, 4, 3, 4);
            this.MaximizeBox = false;
            this.MaximumSize = new System.Drawing.Size(1077, 772);
            this.MinimizeBox = false;
            this.MinimumSize = new System.Drawing.Size(827, 536);
            this.Name = "MainForm";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Data Exporter v4.03";
            this.Load += new System.EventHandler(this.MainForm_Load);
            this.grbPath.ResumeLayout(false);
            this.grbPath.PerformLayout();
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.groupBox2.ResumeLayout(false);
            this.groupBox2.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.GroupBox grbPath;
        private System.Windows.Forms.Button btnBrowse;
        private System.Windows.Forms.Button btnExportData;
        private System.Windows.Forms.TextBox txtPath;
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.ComboBox cboPatient;
        private System.Windows.Forms.Label lblPatient;
        private System.Windows.Forms.GroupBox groupBox2;
        private System.Windows.Forms.Button btnSearch;
        private System.Windows.Forms.TextBox txtSearch;
        private System.Windows.Forms.RadioButton optLastName;
        private System.Windows.Forms.RadioButton optPatientID;
        private System.Windows.Forms.Button btnDBConn;
        private System.Windows.Forms.Label lblPath;
        private System.Windows.Forms.Button btnExportWave;

    }
}


