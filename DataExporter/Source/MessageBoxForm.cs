//*******************************************************************************************************************
//                                          Spacelabs Healthcare, Inc. 2009
//This document contains proprietary trade secret and confidential information which is the property of Spacelabs 
//Healthcare Inc.  This document and the information it contains are not to be copied, distributed, disclosed to 
//others, or used in any manner outside of Spacelabs Healthcare without the prior written approval of Spacelabs 
//Healthcare, Inc. Copyright Spacelabs Healthcare, Inc. 2009.
//*******************************************************************************************************************
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace Spacelabs.DataExporter
{
    public partial class MessageBoxForm: Form
    {
        public MessageBoxForm()
        {
            InitializeComponent();
            this.btnButton.BackColor = Color.DarkSlateBlue;
            this.StartPosition = FormStartPosition.CenterScreen;
        }

        public string Message
        {
            set { lblText.Text = value; }
        }

        public Image MessageIcon
        {
            set
            {
                this.lblText.Image = value;
            }
        }

        public void Initialize(string text, MessageBoxIcon icon)
        {
            this.lblIcon.ImageAlign = ContentAlignment.TopLeft;
            this.lblText.Text = text;

            switch (icon)
            {
                case MessageBoxIcon.Information:
                    this.Text = MessageBoxIcon.Information.ToString();
                    this.lblIcon.Image = Properties.Resources.Icon_Information;
                    break;

                case MessageBoxIcon.Exclamation:
                    this.Text = MessageBoxIcon.Exclamation.ToString();
                    this.lblIcon.Image = Properties.Resources.Icon_Exclamation;
                    break;

                case MessageBoxIcon.Error:
                    this.Text = MessageBoxIcon.Error.ToString();
                    this.lblIcon.Image = Properties.Resources.Icon_Error;
                    break;
            }
        }

        private void btnButton_Click(object sender, EventArgs e)
        {
            this.Close();
        }
    }

    // Summary:
    //     Specifies constants defining which information to display.
    public enum MessageBoxIcon
    {
        None = 0,
        Error = 1,
        Information = 2,
        Exclamation = 3,
    }

    public static class MessageForm
    {
        private static MessageBoxForm mForm = null;

        static MessageForm(){}

        public static void Show(string text, MessageBoxIcon icon)
        {
            try
            {
                if (mForm == null)
                {
                    mForm = new MessageBoxForm();
                }

                mForm.Initialize(text, icon);
                mForm.Show();

#if DEBUG
                mForm = null;
                GC.Collect();
#endif
            }
            catch (Exception ex)
            {
            }
        }
       

    }
}