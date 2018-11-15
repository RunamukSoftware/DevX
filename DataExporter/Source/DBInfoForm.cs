// ------------------------------------------------------------------------------------------------
// File: DBInfoForm.cs
// © Copyright 2013 Spacelabs Healthcare, Inc.
//
// This document contains proprietary trade secret and confidential information
// which is the property of Spacelabs Healthcare, Inc.  This document and the
// information it contains are not to be copied, distributed, disclosed to others,
// or used in any manner outside of Spacelabs Healthcare, Inc. without the prior
// written approval of Spacelabs Healthcare, Inc.
// ------------------------------------------------------------------------------------------------
//
using System.Windows.Forms;

namespace ICSDataExport
{
    /// <summary>
    /// DBInfoForm is designed to prompt user for the database connection information and 
    /// set this data to DataSourse object.
    /// </summary>
    public partial class DBInfoForm : Form
    {
        public DBInfoForm()
        {
            InitializeComponent();

            txtServer.Text = DataSource.DBServer;
            txtPassword.Text = DataSource.DBPassword;
        }

        /// <summary>
        /// Checks for db connection data at text boxes.
        /// Assigned db connection data to DataSourse object.
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void btnOK_Click(object sender, System.EventArgs e)
        {
            if (txtServer.Text.Equals(string.Empty) || txtDatabase.Text.Equals(string.Empty)
                || txtUser.Text.Equals(string.Empty) || txtPassword.Text.Equals(string.Empty))
            {
                MessageBox.Show("Database information is not valid.", "Error",
                                MessageBoxButtons.OK, MessageBoxIcon.Error);
                this.txtServer.SelectAll();
                this.txtServer.Focus();
            }
            else
            {
                DataSource.DBServer = txtServer.Text;
                DataSource.DBPassword = txtPassword.Text;

                this.Cursor = Cursors.WaitCursor;
                if (DataSource.CheckConnection())
                {
                    this.Cursor = Cursors.Default;
                    this.DialogResult = DialogResult.OK;
                    this.Close();
                }
                else
                {
                    this.Cursor = Cursors.Default;
                    DataSource.ClearDBConn();
                    MessageBox.Show("Failed to establish database connection.", "Error",
                                    MessageBoxButtons.OK, MessageBoxIcon.Error);
                    this.txtServer.SelectAll();
                    this.txtServer.Focus();
                }
            }
        }

        /// <summary>
        /// Closes form
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void btnCancel_Click(object sender, System.EventArgs e)
        {
            this.DialogResult = DialogResult.Cancel;
            this.Close();
        }
    }

}