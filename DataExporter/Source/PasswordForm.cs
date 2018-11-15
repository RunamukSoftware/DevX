// ------------------------------------------------------------------------------------------------
// File: PasswordForm.cs
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
using System.Windows.Forms;

namespace ICSDataExport
{
    public partial class PasswordForm : Form
    {
        private const string mSecurityKey = "GTSwave";

        public PasswordForm()
        {
            InitializeComponent();
        }

        private void btnOk_Click(object sender, EventArgs e)
        {
                if (String.Compare(txtAppPassword.Text, mSecurityKey) == 0)
                {
                    this.DialogResult = DialogResult.OK;
                    this.Close();
                }
                else
                {
                    MessageBox.Show("Password is not valid.", "Error",
                                    MessageBoxButtons.OK, MessageBoxIcon.Error);
                    txtAppPassword.SelectAll();
                    txtAppPassword.Focus();

                }
        }

        private void btnCancel_Click(object sender, EventArgs e)
        {
            this.DialogResult = DialogResult.Cancel;
            this.Close();
        }
    }
}
