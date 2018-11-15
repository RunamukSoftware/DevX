// ------------------------------------------------------------------------------------------------
// File: IDForm.cs
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
    /// <summary>
    /// IDForm class is designed to capture user defined file unique id
    /// </summary>
    public partial class IDForm : Form
    {
        private bool mCharKey = false;

        public IDForm()
        {
            InitializeComponent();
        }

        /// <summary>
        /// Gets File ID
        /// </summary>
        public string ID
        {
            get { return txtID.Text; }
        }

        /// <summary>
        /// Handles OK click event
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void btnOK_Click(object sender, EventArgs e)
        {
            if (!txtID.Equals(string.Empty))
            {
                this.DialogResult = DialogResult.OK;
            }
            else
            {
                MessageBox.Show("File ID is required.", "Error",
                                MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        /// <summary>
        /// Handles Cancel click event
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void btnCancel_Click(object sender, EventArgs e)
        {
            this.DialogResult = DialogResult.Cancel;
            this.Close();
        }

        /// <summary>
        /// Handles the KeyDown event to determine the type of character entered into the control.
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void txtID_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.Modifiers == Keys.Shift)
            {
                mCharKey = false;
                return;
            }

            mCharKey = true;

            //// Determine whether the keystroke is a backspace.
            if (e.KeyCode == Keys.Back || e.KeyCode == Keys.Delete)
            {
                return;
            }

            // Determine whether the keystroke is a number from the top of the keyboard.
            if (e.KeyCode < Keys.D0 || e.KeyCode > Keys.D9)
            {

                // Determine whether the keystroke is a number from the keypad.
                if (e.KeyCode < Keys.NumPad0 || e.KeyCode > Keys.NumPad9)
                {
                    // A non-numerical keystroke was pressed.
                    // Set the flag to true and evaluate in KeyPress event.
                    mCharKey = false;
                }
            }
        }

        /// <summary>
        /// Handles Key press event
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void txtID_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (!char.IsLetter(e.KeyChar) && !mCharKey)
            {
                e.Handled = true;
            }
        }
    }
}