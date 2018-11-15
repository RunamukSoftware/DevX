using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace AsyncDataGridViewLoad
{
    public partial class AsyncDataGridViewLoadForm : Form
    {
        public AsyncDataGridViewLoadForm()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            Debug.WriteLine("Form1_Load-BEGIN");

            // TODO: This line of code loads data into the 'portalDataSet1.AuditLogData' table. You can move, or remove it, as needed.
            //this.auditLogDataTableAdapter.Fill(this.portalDataSet1.AuditLogData);

            // TODO: This line of code loads data into the 'portalDataSet2.LogData' table. You can move, or remove it, as needed.
            //this.logDataTableAdapter.Fill(this.portalDataSet2.LogData);

            this.AuditLogDataGridView.DataSource = "Loading audit log data...";

            backgroundWorker1.RunWorkerAsync();
        }

        private void tabControl1_Layout(object sender, LayoutEventArgs e)
        {
            //Debug.WriteLine($"tabControl1_Layout - {tabControl1.SelectedIndex}");
        }

        private void tabPage1_Enter(object sender, EventArgs e)
        {
            //Debug.WriteLine("tabPage1_Enter");
        }

        private void tabPage2_Enter(object sender, EventArgs e)
        {
            //Debug.WriteLine("tabPage2_Enter");
        }

        protected override void WndProc(ref Message m)
        {
            base.WndProc(ref m);

            //Trace.WriteLine(m.Msg.ToString() + ": " + m.ToString());
            //Trace.WriteLine(m.ToString());
        }

        private void backgroundWorker1_DoWork(object sender, DoWorkEventArgs e)
        {
            Debug.WriteLine("backgroundWorker1_DoWork-BEGIN");

            // TODO: This line of code loads data into the 'portalDataSet1.AuditLogData' table. You can move, or remove it, as needed.
            this.auditLogDataTableAdapter.Fill(this.portalDataSet1.AuditLogData);
            Debug.WriteLine("AuditLogData Row Count: {0}", this.portalDataSet1.AuditLogData.Rows.Count);

            // TODO: This line of code loads data into the 'portalDataSet2.LogData' table. You can move, or remove it, as needed.
            this.logDataTableAdapter.Fill(this.portalDataSet2.LogData);
            Debug.WriteLine("LogData Row Count: {0}", this.portalDataSet2.LogData.Rows.Count);
        }

        private void backgroundWorker1_RunWorkerCompleted(object sender, RunWorkerCompletedEventArgs e)
        {
            this.AuditLogDataGridView.Columns.Remove("Loading...");
            this.AuditLogDataGridView.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
                this.auditIdDataGridViewTextBoxColumn,
                this.dateTimeDataGridViewTextBoxColumn,
                this.patientIDDataGridViewTextBoxColumn,
                this.applicationDataGridViewTextBoxColumn,
                this.deviceNameDataGridViewTextBoxColumn,
                this.messageDataGridViewTextBoxColumn,
                this.itemNameDataGridViewTextBoxColumn,
                this.originalValueDataGridViewTextBoxColumn,
                this.newValueDataGridViewTextBoxColumn,
                this.changedByDataGridViewTextBoxColumn});

            this.auditLogDataBindingSource.DataSource = this.portalDataSet1;
            this.AuditLogDataGridView.DataSource = this.auditLogDataBindingSource;
            Debug.WriteLine("portalDataSet1.AuditLogData-COMPLETE");

            this.ErrorLogDataGridView.Columns.Remove("Loading...");
            this.ErrorLogDataGridView.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
                this.logIdDataGridViewTextBoxColumn,
                this.dateTimeDataGridViewTextBoxColumn1,
                this.patientIDDataGridViewTextBoxColumn1,
                this.applicationDataGridViewTextBoxColumn1,
                this.deviceNameDataGridViewTextBoxColumn1,
                this.messageDataGridViewTextBoxColumn1,
                this.localizedMessageDataGridViewTextBoxColumn,
                this.messageIdDataGridViewTextBoxColumn,
                this.logTypeDataGridViewTextBoxColumn});

            this.logDataBindingSource.DataSource = this.portalDataSet2;
            this.ErrorLogDataGridView.DataSource = this.logDataBindingSource;
            Debug.WriteLine("portalDataSet2.LogData-COMPLETE");
        }
    }
}
