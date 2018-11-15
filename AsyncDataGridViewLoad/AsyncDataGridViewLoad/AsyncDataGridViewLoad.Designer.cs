using System.Data;
using System.Windows.Forms;

namespace AsyncDataGridViewLoad
{
    partial class AsyncDataGridViewLoadForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        private BindingSource bindingSource1 = new BindingSource();

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
            this.components = new System.ComponentModel.Container();
            this.tabControl1 = new System.Windows.Forms.TabControl();
            this.tabPage1 = new System.Windows.Forms.TabPage();
            this.AuditLogDataGridView = new System.Windows.Forms.DataGridView();
            this.auditIdDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.dateTimeDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.patientIDDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.applicationDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.deviceNameDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.messageDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.itemNameDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.originalValueDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.newValueDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.changedByDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.auditLogDataBindingSource = new System.Windows.Forms.BindingSource(this.components);
            this.portalDataSet1 = new AsyncDataGridViewLoad.portalDataSet1();
            this.tabPage2 = new System.Windows.Forms.TabPage();
            this.ErrorLogDataGridView = new System.Windows.Forms.DataGridView();
            this.logIdDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.dateTimeDataGridViewTextBoxColumn1 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.patientIDDataGridViewTextBoxColumn1 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.applicationDataGridViewTextBoxColumn1 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.deviceNameDataGridViewTextBoxColumn1 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.messageDataGridViewTextBoxColumn1 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.localizedMessageDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.messageIdDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.logTypeDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.logDataBindingSource = new System.Windows.Forms.BindingSource(this.components);
            this.portalDataSet2 = new AsyncDataGridViewLoad.portalDataSet2();
            this.auditLogDataTableAdapter = new AsyncDataGridViewLoad.portalDataSet1TableAdapters.AuditLogDataTableAdapter();
            this.logDataTableAdapter = new AsyncDataGridViewLoad.portalDataSet2TableAdapters.LogDataTableAdapter();
            this.backgroundWorker1 = new System.ComponentModel.BackgroundWorker();
            this.tabControl1.SuspendLayout();
            this.tabPage1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.AuditLogDataGridView)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.auditLogDataBindingSource)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.portalDataSet1)).BeginInit();
            this.tabPage2.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.ErrorLogDataGridView)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.logDataBindingSource)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.portalDataSet2)).BeginInit();
            this.SuspendLayout();
            // 
            // tabControl1
            // 
            this.tabControl1.Controls.Add(this.tabPage1);
            this.tabControl1.Controls.Add(this.tabPage2);
            this.tabControl1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tabControl1.Location = new System.Drawing.Point(0, 0);
            this.tabControl1.Name = "tabControl1";
            this.tabControl1.SelectedIndex = 0;
            this.tabControl1.Size = new System.Drawing.Size(1406, 450);
            this.tabControl1.TabIndex = 0;
            this.tabControl1.Layout += new System.Windows.Forms.LayoutEventHandler(this.tabControl1_Layout);
            // 
            // tabPage1
            // 
            this.tabPage1.Controls.Add(this.AuditLogDataGridView);
            this.tabPage1.Location = new System.Drawing.Point(4, 22);
            this.tabPage1.Name = "tabPage1";
            this.tabPage1.Padding = new System.Windows.Forms.Padding(3);
            this.tabPage1.Size = new System.Drawing.Size(1398, 424);
            this.tabPage1.TabIndex = 0;
            this.tabPage1.Text = "Audit Log Data";
            this.tabPage1.UseVisualStyleBackColor = true;
            this.tabPage1.Enter += new System.EventHandler(this.tabPage1_Enter);
            // 
            // AuditLogDataGridView
            // 
            this.AuditLogDataGridView.AllowUserToAddRows = false;
            this.AuditLogDataGridView.AllowUserToDeleteRows = false;
            this.AuditLogDataGridView.AutoGenerateColumns = false;
            this.AuditLogDataGridView.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.AuditLogDataGridView.Dock = System.Windows.Forms.DockStyle.Fill;
            //this.AuditLogDataGridView.Location = new System.Drawing.Point(3, 3);
            this.AuditLogDataGridView.Name = "AuditLogDataGridView";
            this.AuditLogDataGridView.ReadOnly = true;
            //this.AuditLogDataGridView.Size = new System.Drawing.Size(1392, 418);
            //this.AuditLogDataGridView.TabIndex = 1;
            //this.AuditLogDataGridView.AutoGenerateColumns = false;
            this.AuditLogDataGridView.Columns.Add("Loading...", "Loading data...");
            // 
            // ErrorLogDataGridView
            // 
            this.ErrorLogDataGridView.AllowUserToAddRows = false;
            this.ErrorLogDataGridView.AllowUserToDeleteRows = false;
            this.ErrorLogDataGridView.AutoGenerateColumns = false;
            this.ErrorLogDataGridView.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.ErrorLogDataGridView.Dock = System.Windows.Forms.DockStyle.Fill;
            //this.ErrorLogDataGridView.Location = new System.Drawing.Point(3, 3);
            this.ErrorLogDataGridView.Name = "ErrorLogDataGridView";
            this.ErrorLogDataGridView.ReadOnly = true;
            //this.ErrorLogDataGridView.Size = new System.Drawing.Size(1392, 418);
            //this.ErrorLogDataGridView.TabIndex = 0;
            this.ErrorLogDataGridView.Columns.Add("Loading...", "Loading data...");
            // 
            // auditIdDataGridViewTextBoxColumn
            // 
            this.auditIdDataGridViewTextBoxColumn.DataPropertyName = "AuditId";
            this.auditIdDataGridViewTextBoxColumn.HeaderText = "AuditId";
            this.auditIdDataGridViewTextBoxColumn.Name = "auditIdDataGridViewTextBoxColumn";
            this.auditIdDataGridViewTextBoxColumn.ReadOnly = true;
            this.auditIdDataGridViewTextBoxColumn.Width = 220;
            // 
            // dateTimeDataGridViewTextBoxColumn
            // 
            this.dateTimeDataGridViewTextBoxColumn.DataPropertyName = "DateTime";
            this.dateTimeDataGridViewTextBoxColumn.HeaderText = "DateTime";
            this.dateTimeDataGridViewTextBoxColumn.Name = "dateTimeDataGridViewTextBoxColumn";
            this.dateTimeDataGridViewTextBoxColumn.ReadOnly = true;
            // 
            // patientIDDataGridViewTextBoxColumn
            // 
            this.patientIDDataGridViewTextBoxColumn.DataPropertyName = "PatientID";
            this.patientIDDataGridViewTextBoxColumn.HeaderText = "PatientID";
            this.patientIDDataGridViewTextBoxColumn.Name = "patientIDDataGridViewTextBoxColumn";
            this.patientIDDataGridViewTextBoxColumn.ReadOnly = true;
            this.patientIDDataGridViewTextBoxColumn.Width = 220;
            // 
            // applicationDataGridViewTextBoxColumn
            // 
            this.applicationDataGridViewTextBoxColumn.DataPropertyName = "Application";
            this.applicationDataGridViewTextBoxColumn.HeaderText = "Application";
            this.applicationDataGridViewTextBoxColumn.Name = "applicationDataGridViewTextBoxColumn";
            this.applicationDataGridViewTextBoxColumn.ReadOnly = true;
            // 
            // deviceNameDataGridViewTextBoxColumn
            // 
            this.deviceNameDataGridViewTextBoxColumn.DataPropertyName = "DeviceName";
            this.deviceNameDataGridViewTextBoxColumn.HeaderText = "DeviceName";
            this.deviceNameDataGridViewTextBoxColumn.Name = "deviceNameDataGridViewTextBoxColumn";
            this.deviceNameDataGridViewTextBoxColumn.ReadOnly = true;
            // 
            // messageDataGridViewTextBoxColumn
            // 
            this.messageDataGridViewTextBoxColumn.DataPropertyName = "Message";
            this.messageDataGridViewTextBoxColumn.HeaderText = "Message";
            this.messageDataGridViewTextBoxColumn.Name = "messageDataGridViewTextBoxColumn";
            this.messageDataGridViewTextBoxColumn.ReadOnly = true;
            // 
            // itemNameDataGridViewTextBoxColumn
            // 
            this.itemNameDataGridViewTextBoxColumn.DataPropertyName = "ItemName";
            this.itemNameDataGridViewTextBoxColumn.HeaderText = "ItemName";
            this.itemNameDataGridViewTextBoxColumn.Name = "itemNameDataGridViewTextBoxColumn";
            this.itemNameDataGridViewTextBoxColumn.ReadOnly = true;
            // 
            // originalValueDataGridViewTextBoxColumn
            // 
            this.originalValueDataGridViewTextBoxColumn.DataPropertyName = "OriginalValue";
            this.originalValueDataGridViewTextBoxColumn.HeaderText = "OriginalValue";
            this.originalValueDataGridViewTextBoxColumn.Name = "originalValueDataGridViewTextBoxColumn";
            this.originalValueDataGridViewTextBoxColumn.ReadOnly = true;
            // 
            // newValueDataGridViewTextBoxColumn
            // 
            this.newValueDataGridViewTextBoxColumn.DataPropertyName = "NewValue";
            this.newValueDataGridViewTextBoxColumn.HeaderText = "NewValue";
            this.newValueDataGridViewTextBoxColumn.Name = "newValueDataGridViewTextBoxColumn";
            this.newValueDataGridViewTextBoxColumn.ReadOnly = true;
            // 
            // changedByDataGridViewTextBoxColumn
            // 
            this.changedByDataGridViewTextBoxColumn.DataPropertyName = "ChangedBy";
            this.changedByDataGridViewTextBoxColumn.HeaderText = "ChangedBy";
            this.changedByDataGridViewTextBoxColumn.Name = "changedByDataGridViewTextBoxColumn";
            this.changedByDataGridViewTextBoxColumn.ReadOnly = true;
            this.changedByDataGridViewTextBoxColumn.Width = 150;
            // 
            // auditLogDataBindingSource
            // 
            this.auditLogDataBindingSource.DataMember = "AuditLogData";
            // 
            // portalDataSet1
            // 
            this.portalDataSet1.DataSetName = "portalDataSet1";
            this.portalDataSet1.SchemaSerializationMode = System.Data.SchemaSerializationMode.IncludeSchema;
            // 
            // tabPage2
            // 
            this.tabPage2.Controls.Add(this.ErrorLogDataGridView);
            this.tabPage2.Location = new System.Drawing.Point(4, 22);
            this.tabPage2.Name = "tabPage2";
            this.tabPage2.Padding = new System.Windows.Forms.Padding(3);
            this.tabPage2.Size = new System.Drawing.Size(1398, 424);
            this.tabPage2.TabIndex = 1;
            this.tabPage2.Text = "Log Data";
            this.tabPage2.UseVisualStyleBackColor = true;
            this.tabPage2.Enter += new System.EventHandler(this.tabPage2_Enter);
            // 
            // logIdDataGridViewTextBoxColumn
            // 
            this.logIdDataGridViewTextBoxColumn.DataPropertyName = "LogId";
            this.logIdDataGridViewTextBoxColumn.HeaderText = "LogId";
            this.logIdDataGridViewTextBoxColumn.Name = "logIdDataGridViewTextBoxColumn";
            this.logIdDataGridViewTextBoxColumn.ReadOnly = true;
            this.logIdDataGridViewTextBoxColumn.Width = 220;
            // 
            // dateTimeDataGridViewTextBoxColumn1
            // 
            this.dateTimeDataGridViewTextBoxColumn1.DataPropertyName = "DateTime";
            this.dateTimeDataGridViewTextBoxColumn1.HeaderText = "DateTime";
            this.dateTimeDataGridViewTextBoxColumn1.Name = "dateTimeDataGridViewTextBoxColumn1";
            this.dateTimeDataGridViewTextBoxColumn1.ReadOnly = true;
            // 
            // patientIDDataGridViewTextBoxColumn1
            // 
            this.patientIDDataGridViewTextBoxColumn1.DataPropertyName = "PatientID";
            this.patientIDDataGridViewTextBoxColumn1.HeaderText = "PatientID";
            this.patientIDDataGridViewTextBoxColumn1.Name = "patientIDDataGridViewTextBoxColumn1";
            this.patientIDDataGridViewTextBoxColumn1.ReadOnly = true;
            this.patientIDDataGridViewTextBoxColumn1.Width = 220;
            // 
            // applicationDataGridViewTextBoxColumn1
            // 
            this.applicationDataGridViewTextBoxColumn1.DataPropertyName = "Application";
            this.applicationDataGridViewTextBoxColumn1.HeaderText = "Application";
            this.applicationDataGridViewTextBoxColumn1.Name = "applicationDataGridViewTextBoxColumn1";
            this.applicationDataGridViewTextBoxColumn1.ReadOnly = true;
            // 
            // deviceNameDataGridViewTextBoxColumn1
            // 
            this.deviceNameDataGridViewTextBoxColumn1.DataPropertyName = "DeviceName";
            this.deviceNameDataGridViewTextBoxColumn1.HeaderText = "DeviceName";
            this.deviceNameDataGridViewTextBoxColumn1.Name = "deviceNameDataGridViewTextBoxColumn1";
            this.deviceNameDataGridViewTextBoxColumn1.ReadOnly = true;
            // 
            // messageDataGridViewTextBoxColumn1
            // 
            this.messageDataGridViewTextBoxColumn1.DataPropertyName = "Message";
            this.messageDataGridViewTextBoxColumn1.HeaderText = "Message";
            this.messageDataGridViewTextBoxColumn1.Name = "messageDataGridViewTextBoxColumn1";
            this.messageDataGridViewTextBoxColumn1.ReadOnly = true;
            // 
            // localizedMessageDataGridViewTextBoxColumn
            // 
            this.localizedMessageDataGridViewTextBoxColumn.DataPropertyName = "LocalizedMessage";
            this.localizedMessageDataGridViewTextBoxColumn.HeaderText = "LocalizedMessage";
            this.localizedMessageDataGridViewTextBoxColumn.Name = "localizedMessageDataGridViewTextBoxColumn";
            this.localizedMessageDataGridViewTextBoxColumn.ReadOnly = true;
            // 
            // messageIdDataGridViewTextBoxColumn
            // 
            this.messageIdDataGridViewTextBoxColumn.DataPropertyName = "MessageId";
            this.messageIdDataGridViewTextBoxColumn.HeaderText = "MessageId";
            this.messageIdDataGridViewTextBoxColumn.Name = "messageIdDataGridViewTextBoxColumn";
            this.messageIdDataGridViewTextBoxColumn.ReadOnly = true;
            // 
            // logTypeDataGridViewTextBoxColumn
            // 
            this.logTypeDataGridViewTextBoxColumn.DataPropertyName = "LogType";
            this.logTypeDataGridViewTextBoxColumn.HeaderText = "LogType";
            this.logTypeDataGridViewTextBoxColumn.Name = "logTypeDataGridViewTextBoxColumn";
            this.logTypeDataGridViewTextBoxColumn.ReadOnly = true;
            // 
            // logDataBindingSource
            // 
            this.logDataBindingSource.DataMember = "LogData";
            // 
            // portalDataSet2
            // 
            this.portalDataSet2.DataSetName = "portalDataSet2";
            this.portalDataSet2.SchemaSerializationMode = System.Data.SchemaSerializationMode.IncludeSchema;
            // 
            // auditLogDataTableAdapter
            // 
            this.auditLogDataTableAdapter.ClearBeforeFill = true;
            // 
            // logDataTableAdapter
            // 
            this.logDataTableAdapter.ClearBeforeFill = true;
            // 
            // backgroundWorker1
            // 
            this.backgroundWorker1.DoWork += new System.ComponentModel.DoWorkEventHandler(this.backgroundWorker1_DoWork);
            this.backgroundWorker1.RunWorkerCompleted += new System.ComponentModel.RunWorkerCompletedEventHandler(this.backgroundWorker1_RunWorkerCompleted);
            // 
            // AsyncDataGridViewLoadForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1406, 450);
            this.Controls.Add(this.tabControl1);
            this.Name = "AsyncDataGridViewLoadForm";
            this.Text = "AsyncDataGridViewLoadForm";
            this.Load += new System.EventHandler(this.Form1_Load);
            this.tabControl1.ResumeLayout(false);
            this.tabPage1.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.AuditLogDataGridView)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.auditLogDataBindingSource)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.portalDataSet1)).EndInit();
            this.tabPage2.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.ErrorLogDataGridView)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.logDataBindingSource)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.portalDataSet2)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.TabControl tabControl1;
        private System.Windows.Forms.TabPage tabPage1;
        private System.Windows.Forms.TabPage tabPage2;

        private portalDataSet1 portalDataSet1;
        private System.Windows.Forms.BindingSource auditLogDataBindingSource;
        private portalDataSet1TableAdapters.AuditLogDataTableAdapter auditLogDataTableAdapter;
        private System.Windows.Forms.DataGridView AuditLogDataGridView;

        private portalDataSet2 portalDataSet2;
        private System.Windows.Forms.BindingSource logDataBindingSource;
        private portalDataSet2TableAdapters.LogDataTableAdapter logDataTableAdapter;
        private System.Windows.Forms.DataGridView ErrorLogDataGridView;

        private System.Windows.Forms.DataGridViewTextBoxColumn auditIdDataGridViewTextBoxColumn;
        private System.Windows.Forms.DataGridViewTextBoxColumn dateTimeDataGridViewTextBoxColumn;
        private System.Windows.Forms.DataGridViewTextBoxColumn patientIDDataGridViewTextBoxColumn;
        private System.Windows.Forms.DataGridViewTextBoxColumn applicationDataGridViewTextBoxColumn;
        private System.Windows.Forms.DataGridViewTextBoxColumn deviceNameDataGridViewTextBoxColumn;
        private System.Windows.Forms.DataGridViewTextBoxColumn messageDataGridViewTextBoxColumn;
        private System.Windows.Forms.DataGridViewTextBoxColumn itemNameDataGridViewTextBoxColumn;
        private System.Windows.Forms.DataGridViewTextBoxColumn originalValueDataGridViewTextBoxColumn;
        private System.Windows.Forms.DataGridViewTextBoxColumn newValueDataGridViewTextBoxColumn;
        private System.Windows.Forms.DataGridViewTextBoxColumn changedByDataGridViewTextBoxColumn;

        private System.Windows.Forms.DataGridViewTextBoxColumn logIdDataGridViewTextBoxColumn;
        private System.Windows.Forms.DataGridViewTextBoxColumn dateTimeDataGridViewTextBoxColumn1;
        private System.Windows.Forms.DataGridViewTextBoxColumn patientIDDataGridViewTextBoxColumn1;
        private System.Windows.Forms.DataGridViewTextBoxColumn applicationDataGridViewTextBoxColumn1;
        private System.Windows.Forms.DataGridViewTextBoxColumn deviceNameDataGridViewTextBoxColumn1;
        private System.Windows.Forms.DataGridViewTextBoxColumn messageDataGridViewTextBoxColumn1;
        private System.Windows.Forms.DataGridViewTextBoxColumn localizedMessageDataGridViewTextBoxColumn;
        private System.Windows.Forms.DataGridViewTextBoxColumn messageIdDataGridViewTextBoxColumn;
        private System.Windows.Forms.DataGridViewTextBoxColumn logTypeDataGridViewTextBoxColumn;
        private System.ComponentModel.BackgroundWorker backgroundWorker1;
    }
}

