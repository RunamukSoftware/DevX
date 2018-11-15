using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using NUnit.Framework;
using System.Diagnostics;
using TestStack.White;
using TestStack.White.Factory;
using TestStack.White.UIItems.Finders;
using TestStack.White.InputDevices;
using TestStack.White.UIItems;
using TestStack.White.UIItems.MenuItems;
using TestStack.White.UIItems.TreeItems;
using TestStack.White.UIItems.WindowItems;
using TestStack.White.UIItems.ListBoxItems;
using TestStack.White.UIItems.TableItems;
using TestStack.White.UIItems.WindowStripControls;
using System.Threading;
using System.Windows.Automation;
using CommonTest;
using System.Collections;
using System.Text.RegularExpressions;
using System.IO;
using System.Windows;
using System.Globalization;
using TestStack.White.Configuration;

namespace CAWhiteTest
{
    [TestFixture]
    public class BedsideView
    {
        private static string CAExeFile;
        private static Application _CAApp;
        private static Window _CAMainWindow;
        Hashtable configHT;

        [SetUp]
        protected void SetUp()
        {
            //Console.Read();
            configHT = Config.ReadConfig();
            string CAAppPath = (string)configHT["ExePath"];
            string CAExeFile = CAAppPath + @"\ClinicalHistoryXP.exe";

            var psi = new ProcessStartInfo(CAExeFile);
            _CAApp = Application.AttachOrLaunch(psi);
            _CAMainWindow = _CAApp.GetWindow(SearchCriteria.ByAutomationId("ClinicalAccess"), InitializeOption.NoCache);
        }

        public void Prepare(string bed)
        {
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnSelectPatient")).Click();
            Window _PatientSelectDialogWindow = _CAMainWindow.ModalWindow("Patient Select Dialog");

            var PatientsTab = _PatientSelectDialogWindow.Get(SearchCriteria.ByText("Patients"));
            PatientsTab.Click();

            var comboBox = _PatientSelectDialogWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("cmbFacility"));
            comboBox.Select("Facility1");

            //make sure the selection on teh Unit row works
            _PatientSelectDialogWindow.Get(SearchCriteria.ByText("Unit Row 0")).DoubleClick();
            var DataGridView_Table = _PatientSelectDialogWindow.Get<Table>(SearchCriteria.ByAutomationId("dgvUnits"));

            //to avoid timeout=5000 exception
            CoreAppXmlConfiguration.Instance.BusyTimeout = 50000;
            bool found = false;
            TableRow testRow = null;
            //go through the units to find the testing bed
            for (int i = 0; i < DataGridView_Table.Rows.Count; i++)
            {
                string pos = i.ToString();
                _PatientSelectDialogWindow.Get(SearchCriteria.ByText("Unit Row " + pos)).DoubleClick();

                var PatientsDatagrid2 = _PatientSelectDialogWindow.Get<Table>(SearchCriteria.ByAutomationId("dgvPatients"));

                foreach (TableRow row in PatientsDatagrid2.Rows)
                {
                    if ((string)row.Cells[0].Value == (string)configHT[bed])
                    {
                        testRow = row;
                        found = true;
                        break;
                    }
                }
                if (found == true)
                    break;
            }

            //after click the row, the "Patient Select Dialog" disappear and may generate exception
            try
            {
                testRow.Click();
            }
            catch (Exception e)
            {
                Console.WriteLine("test case BedsideData exception" + e.Message.ToString());
            }

            //click Bedside
            var bedsideView = _CAMainWindow.Get(SearchCriteria.ByText("Bedside"));
            bedsideView.Click();
            Thread.Sleep(6000);
        }

        [TearDown]
        public void TearDown()
        {
            //_CAApp.Close();
            //_CAApp.Dispose();
        }

        //general case
        [Test]
        public void Bedside()
        {
            //for debug.  Attach nunit-agent process
            //Console.Read();

            //prepare for the monitoring data
            Prepare("testbed");

            TestLog.WriteLog("Start Test case: Bedside");

            var SettingsBtn = _CAMainWindow.Get(SearchCriteria.ByText("Settings"));
            SettingsBtn.Click();
            Window _DisplaySettingsWindow = _CAMainWindow.ModalWindow("Display Settings");
            //Unselect the CheckBox at position 2
            SearchCriteria searchCriteria = SearchCriteria.ByControlType(ControlType.CheckBox).AndIndex(1);
            CheckBox checkboxtest = (CheckBox)_DisplaySettingsWindow.Get(searchCriteria);
            checkboxtest.UnSelect();
            var OKBtn = _DisplaySettingsWindow.Get<Button>(SearchCriteria.ByText("OK"));
            OKBtn.Click();
            Thread.Sleep(2000);

            //has ECG
            var ECGTextField = _CAMainWindow.Get<Label>(SearchCriteria.ByAutomationId("lblChannelNameECG"));
            string result_ECG = ECGTextField.Text;

            //verify ECG
            Assert.IsTrue(true, "ECG", result_ECG);

            TestLog.WriteLog("End Test case: Bedside");
        }

        //24515 Bedside presents stored parameter data
        [Test]
        public void BedsideData()
        {
            //prepare for the displaying data
            Prepare("testbed");

            TestLog.WriteLog("Start BedsideData: 24515 Bedside presents stored parameter data");

            var ECGPanel = _CAMainWindow.Get(SearchCriteria.ByAutomationId("lblChannelNameECG"));
            Panel ECGPanelParent = ECGPanel.GetParent<Panel>();
            Label BPM = ECGPanelParent.Get<Label>(SearchCriteria.ByAutomationId("lblTrends4"));
            int BPM_result = Int32.Parse(BPM.Text);

            if (BPM_result < 20 || BPM_result > 200)
            {
                TestLog.WriteLog("Heart rate has wrong number " + BPM_result);
            }

            //Verify the result
            Assert.IsTrue((BPM_result > 20) && (BPM_result < 200));

            TestLog.WriteLog("End BedsideData: 24515 Bedside presents stored parameter data");
        }

        //22969 Patient parameter data is displayed in Bedside View.
        [Test]
        public void ETBedsideView()
        {
            //prepare for the displaying data
            Prepare("SLMBed");

            TestLog.WriteLog("Start ETBedsideView: 22969 Patient parameter data is displayed in Bedside View.");

            //verify the active vitals for I
            Regex ST_regex = new Regex(@"^ST=[-+]?[0-9](\.[0-9]{1}[0-9]*)?$");
            var ECGPanel = _CAMainWindow.Get(SearchCriteria.ByAutomationId("lblChannelNameECG"));
            Panel ECGPanelParent = ECGPanel.GetParent<Panel>();
            //"lblTrends0" for example ST=-0.25
            Label I_ST = ECGPanelParent.Get<Label>(SearchCriteria.ByAutomationId("lblTrends0"));
            string I_ST_str = I_ST.Text;
            if (!ST_regex.IsMatch(I_ST_str))
            {
                TestLog.WriteLog("I has wrong format " + I_ST_str);
            }
            Assert.IsTrue(ST_regex.IsMatch(I_ST_str));
            //"lblTrends2" for example A=0
            Regex A_regex = new Regex(@"^A=[-+]?[0-9](\.[0-9]{1}[0-9]*)?$");
            Label A = ECGPanelParent.Get<Label>(SearchCriteria.ByAutomationId("lblTrends2"));
            if (!A_regex.IsMatch(A.Text))
            {
                TestLog.WriteLog("A has wrong format " + A.Text);
            }
            Assert.IsTrue(A_regex.IsMatch(A.Text));
            //"lblTrends4" HR (heart Rate) for example 80
            Label BPM = ECGPanelParent.Get<Label>(SearchCriteria.ByAutomationId("lblTrends4"));
            int BPM_Int = Int32.Parse(BPM.Text);
            Assert.IsTrue(BPM_Int > 20);

            // II
            var ECGPanelII = _CAMainWindow.Get(SearchCriteria.ByAutomationId("lblChannelNameECG II"));
            Panel ECGPanelIIParent = ECGPanel.GetParent<Panel>();
            Label II_ST = ECGPanelIIParent.Get<Label>(SearchCriteria.ByAutomationId("lblTrends0"));
            string II_ST_str = II_ST.Text;
            if (!ST_regex.IsMatch(II_ST_str))
            {
                TestLog.WriteLog("II has wrong format " + II_ST_str);
            }
            Assert.IsTrue(ST_regex.IsMatch(II_ST_str));

            // III
            var ECGPanelIII = _CAMainWindow.Get(SearchCriteria.ByAutomationId("lblChannelNameECG III"));
            Panel ECGPanelIIIParent = ECGPanel.GetParent<Panel>();
            Label III_ST = ECGPanelIIIParent.Get<Label>(SearchCriteria.ByAutomationId("lblTrends0"));
            string III_ST_str = III_ST.Text;
            if (!ST_regex.IsMatch(III_ST_str))
            {
                TestLog.WriteLog("II has wrong format " + III_ST_str);
            }
            Assert.IsTrue(ST_regex.IsMatch(III_ST_str));

            // V1
            var ECGPanelV1 = _CAMainWindow.Get(SearchCriteria.ByAutomationId("lblChannelNameECG V1"));
            Panel ECGPanelV1Parent = ECGPanel.GetParent<Panel>();
            Label V1_ST = ECGPanelV1Parent.Get<Label>(SearchCriteria.ByAutomationId("lblTrends0"));
            string V1_ST_str = V1_ST.Text;
            if (!ST_regex.IsMatch(V1_ST_str))
            {
                TestLog.WriteLog("II has wrong format " + V1_ST_str);
            }
            Assert.IsTrue(ST_regex.IsMatch(V1_ST_str));

            // AVL
            var ECGPanelAVL = _CAMainWindow.Get(SearchCriteria.ByAutomationId("lblChannelNameECG AVL"));
            Panel ECGPanel_AVL_Parent = ECGPanel.GetParent<Panel>();
            Label AVL_ST = ECGPanel_AVL_Parent.Get<Label>(SearchCriteria.ByAutomationId("lblTrends0"));
            string AVL_ST_str = AVL_ST.Text;
            if (!ST_regex.IsMatch(AVL_ST_str))
            {
                TestLog.WriteLog("AVL has wrong format " + AVL_ST_str);
            }
            Assert.IsTrue(ST_regex.IsMatch(AVL_ST_str));

            // AVF
            var ECGPanelAVF = _CAMainWindow.Get(SearchCriteria.ByAutomationId("lblChannelNameECG AVF"));
            Panel ECGPanelAVFParent = ECGPanel.GetParent<Panel>();
            Label AVF_ST = ECGPanelAVFParent.Get<Label>(SearchCriteria.ByAutomationId("lblTrends0"));
            string AVF_ST_str = AVF_ST.Text;
            if (!ST_regex.IsMatch(AVF_ST_str))
            {
                TestLog.WriteLog("AVF has wrong format " + AVF_ST_str);
            }
            Assert.IsTrue(ST_regex.IsMatch(AVF_ST_str));

            TestLog.WriteLog("End ETBedsideView: 22969 Patient parameter data is displayed in Bedside View.");
        }

        //26125 Paused waveform
        //22972 Bedside view can be paused and restarted.
        [Test]
        public void Pausedwaveform()
        {
            //prepare for the displaying data
            Prepare("testbed");

            TestLog.WriteLog("Start Pausedwaveform: 26125 Paused waveform");

            //click Bedside
            var bedsideView = _CAMainWindow.Get(SearchCriteria.ByText("Bedside"));
            bedsideView.Click();
            Thread.Sleep(10000);
            DateTime startTime = DateTime.Now;
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnPause")).Click();
            var ECGPanel = _CAMainWindow.Get(SearchCriteria.ByAutomationId("lblChannelNameECG"));
            Panel ECGPanelParent = ECGPanel.GetParent<Panel>();
            string dateTimeStr = ECGPanelParent.Get<Label>(SearchCriteria.ByAutomationId("lblDataTime")).Text;
            string dateTimeSubStr = dateTimeStr.Substring(dateTimeStr.IndexOf(":") + 1);
            DateTime startTimeInMonitor = Convert.ToDateTime(dateTimeSubStr);

            int SecDiff1 = (int)(startTimeInMonitor - startTime).TotalSeconds;
            SecDiff1 = Math.Abs(SecDiff1);
            Assert.IsTrue(SecDiff1 < 70);

            TestLog.WriteLog("End Pausedwaveform: 26125 Paused waveform");

            TestLog.WriteLog("Start Pausedwaveform: 22972 Bedside view can be paused and restarted");

            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnPlay")).Click();
            Thread.Sleep(10000);
            DateTime startTime2 = DateTime.Now;
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnPause")).Click();
            ECGPanel = _CAMainWindow.Get(SearchCriteria.ByAutomationId("lblChannelNameECG"));
            ECGPanelParent = ECGPanel.GetParent<Panel>();
            string dateTimeStr2 = ECGPanelParent.Get<Label>(SearchCriteria.ByAutomationId("lblDataTime")).Text;
            string dateTimeSubStr2 = dateTimeStr2.Substring(dateTimeStr2.IndexOf(":") + 1);
            DateTime startTimeInMonitor2 = Convert.ToDateTime(dateTimeSubStr2);

            int SecDiff2 = (int)(startTimeInMonitor2 - startTime2).TotalSeconds;
            SecDiff2 = Math.Abs(SecDiff2);
            Assert.IsTrue(SecDiff2 < 70);

            TestLog.WriteLog("End Pausedwaveform: 22972 Bedside view can be paused and restarted");
        }

        //22973: Paused waveform display can be scrolled backward and forward
        [Test]
        public void BedsidePauseRewindForward()
        {
            //prepare for the displaying data
            Prepare("testbed");

            TestLog.WriteLog("Start BedsidePauseRewindForward: 22973 Paused waveform display can be scrolled backward and forward");

            //click Bedside
            var bedsideView = _CAMainWindow.Get(SearchCriteria.ByText("Bedside"));
            _CAMainWindow.WaitWhileBusy();
            bedsideView.Click();
            _CAMainWindow.WaitWhileBusy();
            Thread.Sleep(32000);
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnPause")).Click();

            var ECGPanel = _CAMainWindow.Get(SearchCriteria.ByAutomationId("lblChannelNameECG"));
            Panel ECGPanelParent = ECGPanel.GetParent<Panel>();
            string dateTimeStr1 = ECGPanelParent.Get<Label>(SearchCriteria.ByAutomationId("lblDataTime")).Text;
            string dateTimeStr12 = dateTimeStr1.Substring(dateTimeStr1.IndexOf(":") + 1);
            DateTime currTime1 = Convert.ToDateTime(dateTimeStr12);

            var btnRewind = _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnRewind"));
            //rewind 25 second
            for (int i = 0; i < 25; i++)
            {
                btnRewind.Click();
            }
            var btnForward = _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnForward"));
            //forward 5 second
            for (int i = 0; i < 5; i++)
            {
                btnForward.Click();
            }
            string dateTimeStr2 = ECGPanelParent.Get<Label>(SearchCriteria.ByAutomationId("lblDataTime")).Text;
            string dateTimeStr22 = dateTimeStr2.Substring(dateTimeStr2.IndexOf(":") + 1);
            DateTime currTime2 = Convert.ToDateTime(dateTimeStr22);

            int SecDiff = (int)(currTime1 - currTime2).TotalSeconds;
            Assert.IsTrue(SecDiff.ToString() == "20");

            TestLog.WriteLog("End BedsidePauseRewindForward: 22973 Paused waveform display can be scrolled backward and forward");
        }

        //21540 Maximum Bedside Parameters
        //ET patient with a wideband transmitter
        [Test]
        public void MaxParameters()
        {
            //prepare for the displaying data
            Prepare("SLMBed");

            TestLog.WriteLog("Start MaxParameters: 21540 Maximum Bedside Parameters");

            var SettingsBtn = _CAMainWindow.Get(SearchCriteria.ByText("Settings"));
            SettingsBtn.Click();
            Window _DisplaySettingsWindow = _CAMainWindow.ModalWindow("Display Settings");
            //select the CheckBox at position 7
            SearchCriteria searchCriteria = SearchCriteria.ByControlType(ControlType.CheckBox).AndIndex(6);
            CheckBox checkboxtest = (CheckBox)_DisplaySettingsWindow.Get(searchCriteria);
            checkboxtest.Select();
            _DisplaySettingsWindow.Get<Button>(SearchCriteria.ByText("OK")).Click();

            //warning window
            Window WarningWindow = _CAMainWindow.ModalWindow("Warning");
            string _WarningText = WarningWindow.Get<Label>(SearchCriteria.ByAutomationId("LblText")).Text;

            //"Number of selected channels exceeds the maximum limit [6].
            //verify: warning message
            Assert.IsTrue(_WarningText == "Number of selected channels exceeds the maximum limit [6].");
            WarningWindow.Get<Button>(SearchCriteria.ByText("OK")).Click();

            //Unselect 5
            CheckBox checkbox4 = (CheckBox)_DisplaySettingsWindow.Get(SearchCriteria.ByControlType(ControlType.CheckBox).AndIndex(4));
            checkbox4.UnSelect();
            _DisplaySettingsWindow.Get<Button>(SearchCriteria.ByText("OK")).Click();

            Panel waveViewerPanel = _CAMainWindow.Get<Panel>(SearchCriteria.ByAutomationId("waveViewerPanel"));
            Panel wave6 = null;
            wave6 = waveViewerPanel.Get<Panel>(SearchCriteria.ByAutomationId("wavepanel1").AndIndex(5));
            Panel wave7 = null;
            try
            {
                wave7 = waveViewerPanel.Get<Panel>(SearchCriteria.ByAutomationId("wavepanel1").AndIndex(6));
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
            }

            //verify: max of 6 waveforms
            Assert.IsTrue((wave6 != null) && (wave7 == null));

            TestLog.WriteLog("End MaxParameters: 21540 Maximum Bedside Parameters");
        }

        //22975 Sweep speed can be changed
        [Test]
        public void ChangeSweepSpeed()
        {
            //prepare for the displaying data
            Prepare("testbed");

            TestLog.WriteLog("Start ChangeSweepSpeed: 22975 Sweep speed can be changed");

            //click on ECG for setting up configuration
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("lblChannelNameECG")).Click();
            Window _ConfigWindow = _CAMainWindow.ModalWindow("Configuration Tool: ECG");
            var ConfigComboBox = _ConfigWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("cboSweepSpeed"));

            //"1.56 mm/sec"
            ConfigComboBox.Click();
            ConfigComboBox.Select("1.56 mm/sec");
            _ConfigWindow.Get<Button>(SearchCriteria.ByText("OK")).Click();
            Thread.Sleep(2000);

            //"6.25 mm/sec"
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("lblChannelNameECG")).Click();
            _ConfigWindow = _CAMainWindow.ModalWindow("Configuration Tool: ECG");
            ConfigComboBox = _ConfigWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("cboSweepSpeed"));
            ConfigComboBox.Click();
            ConfigComboBox.Select("6.25 mm/sec");
            _ConfigWindow.Get<Button>(SearchCriteria.ByText("OK")).Click();
            Thread.Sleep(2000);

            //"12.5 mm/sec"
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("lblChannelNameECG")).Click();
            _ConfigWindow = _CAMainWindow.ModalWindow("Configuration Tool: ECG");
            ConfigComboBox = _ConfigWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("cboSweepSpeed"));
            ConfigComboBox.Click();
            ConfigComboBox.Select("12.5 mm/sec");
            _ConfigWindow.Get<Button>(SearchCriteria.ByText("OK")).Click();
            Thread.Sleep(2000);

            //"50 mm/sec"
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("lblChannelNameECG")).Click();
            _ConfigWindow = _CAMainWindow.ModalWindow("Configuration Tool: ECG");
            ConfigComboBox = _ConfigWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("cboSweepSpeed"));
            ConfigComboBox.Click();
            ConfigComboBox.Select("50 mm/sec");
            _ConfigWindow.Get<Button>(SearchCriteria.ByText("OK")).Click();
            Thread.Sleep(10000);

            //verify sweep speed selection
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("lblChannelNameECG")).Click();
            _ConfigWindow = _CAMainWindow.ModalWindow("Configuration Tool: ECG");
            string result = _ConfigWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("cboSweepSpeed")).SelectedItemText;

            //verify the selected Sweepspeed
            Assert.IsTrue(result == "50 mm/sec");
            _ConfigWindow.Get<Button>(SearchCriteria.ByText("OK")).Click();

            TestLog.WriteLog("End ChangeSweepSpeed: 22975 Sweep speed can be changed");
        }

        //24576 Size can be adjusted in Bedside view.
        [Test]
        public void AdjustSize()
        {
            //prepare for the displaying data
            Prepare("testbed");

            TestLog.WriteLog("Start AdjustSize: 24576 Size can be adjusted in Bedside view.");

            _CAMainWindow.Get(SearchCriteria.ByAutomationId("lblChannelNameECG")).Click();
            Window _ConfigWindow = _CAMainWindow.ModalWindow("Configuration Tool: ECG");
            var ConfigComboBox = _ConfigWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("cboSize"));

            //"25%"
            ConfigComboBox.Click();
            ConfigComboBox.Select("25%");
            _ConfigWindow.Get<Button>(SearchCriteria.ByText("OK")).Click();
            Thread.Sleep(2000);

            //"50%"
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("lblChannelNameECG")).Click();
            _ConfigWindow = _CAMainWindow.ModalWindow("Configuration Tool: ECG");
            ConfigComboBox = _ConfigWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("cboSize"));
            ConfigComboBox.Click();
            ConfigComboBox.Select("50%");
            _ConfigWindow.Get<Button>(SearchCriteria.ByText("OK")).Click();
            Thread.Sleep(2000);

            //"75%"
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("lblChannelNameECG")).Click();
            _ConfigWindow = _CAMainWindow.ModalWindow("Configuration Tool: ECG");
            ConfigComboBox = _ConfigWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("cboSize"));
            ConfigComboBox.Click();
            ConfigComboBox.Select("75%");
            _ConfigWindow.Get<Button>(SearchCriteria.ByText("OK")).Click();
            Thread.Sleep(2000);

            //"100%"
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("lblChannelNameECG")).Click();
            _ConfigWindow = _CAMainWindow.ModalWindow("Configuration Tool: ECG");
            ConfigComboBox = _ConfigWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("cboSize"));
            ConfigComboBox.Click();
            ConfigComboBox.Select("100%");
            _ConfigWindow.Get<Button>(SearchCriteria.ByText("OK")).Click();
            Thread.Sleep(2000);

            //"150%"
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("lblChannelNameECG")).Click();
            _ConfigWindow = _CAMainWindow.ModalWindow("Configuration Tool: ECG");
            ConfigComboBox = _ConfigWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("cboSize"));
            ConfigComboBox.Click();
            ConfigComboBox.Select("150%");
            _ConfigWindow.Get<Button>(SearchCriteria.ByText("OK")).Click();
            Thread.Sleep(2000);

            //"200%"
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("lblChannelNameECG")).Click();
            _ConfigWindow = _CAMainWindow.ModalWindow("Configuration Tool: ECG");
            ConfigComboBox = _ConfigWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("cboSize"));
            ConfigComboBox.Click();
            ConfigComboBox.Select("200%");
            _ConfigWindow.Get<Button>(SearchCriteria.ByText("OK")).Click();
            Thread.Sleep(2000);

            //"300%"
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("lblChannelNameECG")).Click();
            _ConfigWindow = _CAMainWindow.ModalWindow("Configuration Tool: ECG");
            ConfigComboBox = _ConfigWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("cboSize"));
            ConfigComboBox.Click();
            ConfigComboBox.Select("300%");
            _ConfigWindow.Get<Button>(SearchCriteria.ByText("OK")).Click();
            Thread.Sleep(2000);

            //verify sweep speed selection
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("lblChannelNameECG")).Click();
            _ConfigWindow = _CAMainWindow.ModalWindow("Configuration Tool: ECG");
            string result = _ConfigWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("cboSize")).SelectedItemText;

            //verify the selected Sweepspeed
            Assert.IsTrue(result == "300%");
            _ConfigWindow.Get<Button>(SearchCriteria.ByText("OK")).Click();

            TestLog.WriteLog("End AdjustSize: 24576 Size can be adjusted in Bedside view.");
        }

        //22976 Parameters can be selected for display.
        [Test]
        public void ParameterSelection()
        {
            //prepare for the displaying data
            Prepare("SLMBed");

            TestLog.WriteLog("Start ParameterSelection: 22976 Parameters can be selected for display");

            var SettingsBtn = _CAMainWindow.Get(SearchCriteria.ByText("Settings"));
            SettingsBtn.Click();
            Window _DisplaySettingsWindow = _CAMainWindow.ModalWindow("Display Settings");
            //select the CheckBox at position 7 AVR
            CheckBox SPO2checkbox = (CheckBox)_DisplaySettingsWindow.Get(SearchCriteria.ByControlType(ControlType.CheckBox).AndIndex(6));
            SPO2checkbox.Select();
            //Unselect ECG
            CheckBox ECGcheckbox = (CheckBox)_DisplaySettingsWindow.Get(SearchCriteria.ByControlType(ControlType.CheckBox).AndIndex(0));
            ECGcheckbox.UnSelect();
            _DisplaySettingsWindow.Get<Button>(SearchCriteria.ByText("OK")).Click();

            //verify the Unselected ECG and selected SPO2
            Panel waveViewerPanel = _CAMainWindow.Get<Panel>(SearchCriteria.ByAutomationId("waveViewerPanel"));
            Panel wave1 = null;
            wave1 = waveViewerPanel.Get<Panel>(SearchCriteria.ByAutomationId("wavepanel1").AndIndex(0));
            string wave1Label = wave1.Get<Label>(SearchCriteria.ByControlType(ControlType.Text)).Text;
            Panel wave6 = waveViewerPanel.Get<Panel>(SearchCriteria.ByAutomationId("wavepanel1").AndIndex(5));
            string AVRLabel = wave6.Get<Label>(SearchCriteria.ByControlType(ControlType.Text)).Text; //"SPO2").Text;

            //verify: max of 6 waveforms
            Assert.IsTrue((wave1Label != "I") && (AVRLabel == "AVR"));

            TestLog.WriteLog("End ParameterSelection: 21540 Maximum Bedside Parameters");
        }

        //22974 Print the paused waveform
        [Test]
        public void PrintPausedwaveform()
        {
            //prepare for the displaying data
            Prepare("testbed");

            TestLog.WriteLog("Start PrintPausedwaveform: 22974 Print Paused waveform");

            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnPause")).Click();
            var SettingsBtn = _CAMainWindow.Get(SearchCriteria.ByText("Print"));
            SettingsBtn.Click();
            Window PrintWindow = _CAMainWindow.ModalWindow("Print");
            CheckBox PrinttoFileCheckbox = (CheckBox)PrintWindow.Get(SearchCriteria.ByText("Print to file"));
            PrinttoFileCheckbox.Select();
            PrintWindow.Get(SearchCriteria.ByText("OK")).Click();

            Window PrintingWindow = _CAApp.GetWindow(SearchCriteria.ByText("Printing"), InitializeOption.NoCache);
            Window PrinttoFileWindow = PrintingWindow.ModalWindow("Print to File");
            PrinttoFileWindow.Get(SearchCriteria.ByControlType(ControlType.Edit)).SetValue(@"C:\test.gif");
            if (File.Exists(@"C:\test.gif"))
            {
                File.Delete(@"C:\test.gif");
            }
            PrinttoFileWindow.Get<Button>(SearchCriteria.ByText("OK")).Click();

            //verify the printed file
            Assert.IsTrue(File.Exists(@"C:\test.gif"));

            //clean the print file
            if (File.Exists(@"C:\test.gif"))
            {
                File.Delete(@"C:\test.gif");
            }

            TestLog.WriteLog("End PrintPausedwaveform: 22974 Print Paused waveform");
        }

    }

    public class WaveformsView
    {
        private static string CAExeFile;
        private static Application _CAApp;
        private static Window _CAMainWindow;
        Hashtable configHT;

        [SetUp]
        protected void SetUp()
        {
            configHT = Config.ReadConfig();
            string CAAppPath = (string)configHT["ExePath"];
            string CAExeFile = CAAppPath + @"\ClinicalHistoryXP.exe";

            var psi = new ProcessStartInfo(CAExeFile);
            _CAApp = Application.AttachOrLaunch(psi);
            _CAMainWindow = _CAApp.GetWindow(SearchCriteria.ByAutomationId("ClinicalAccess"), InitializeOption.NoCache);
        }

        public void Prepare(string bed)
        {
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnSelectPatient")).Click();
            Window _PatientSelectDialogWindow = _CAMainWindow.ModalWindow("Patient Select Dialog");

            var PatientsTab = _PatientSelectDialogWindow.Get(SearchCriteria.ByText("Patients"));
            PatientsTab.Click();

            var comboBox = _PatientSelectDialogWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("cmbFacility"));
            comboBox.Select("Facility1");

            _PatientSelectDialogWindow.Get(SearchCriteria.ByText("Unit Row 0")).DoubleClick();
            var DataGridView_Table = _PatientSelectDialogWindow.Get<Table>(SearchCriteria.ByAutomationId("dgvUnits"));

            //to avoid timeout=5000 exception
            CoreAppXmlConfiguration.Instance.BusyTimeout = 50000;
            bool found = false;
            TableRow testRow = null;
            //go through the units to find the testing bed
            for (int i = 0; i < DataGridView_Table.Rows.Count; i++)
            {
                string pos = i.ToString();
                _PatientSelectDialogWindow.Get(SearchCriteria.ByText("Unit Row " + pos)).DoubleClick();

                var PatientsDatagrid2 = _PatientSelectDialogWindow.Get<Table>(SearchCriteria.ByAutomationId("dgvPatients"));

                foreach (TableRow row in PatientsDatagrid2.Rows)
                {
                    if ((string)row.Cells[0].Value == (string)configHT[bed])
                    {
                        testRow = row;
                        found = true;
                        break;
                    }
                }
                if (found == true)
                    break;
            }

            //after click the row, the "Patient Select Dialog" disappear and may generate exception
            try
            {
                testRow.Click();
            }
            catch (Exception e)
            {
                Console.WriteLine("test case BedsideData exception" + e.Message.ToString());
            }

            //click Waveforms
            var WaveformsView = _CAMainWindow.Get(SearchCriteria.ByText("Waveforms"));
            WaveformsView.Click();
        }

        [TearDown]
        public void TearDown()
        {
            //_CAApp.Close();
            //_CAApp.Dispose();
        }

        //21719: Waveforms review tab shall label all displayed waveform correctly.
        [Test]
        public void WaveformsReview()
        {
            //prepare for the monitoring data
            Prepare("testbed");

            TestLog.WriteLog("Start WaveformsReview: 21719: Waveforms review tab shall label all displayed waveform correctly.");

            //Clieck on Compressed, there is only one result in the FullSizeWaveformContainer
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnCompressed")).Click();
            Panel FullSizeWaveformContainer = _CAMainWindow.Get<Panel>("FullSizeWaveformContainer");
            Panel WaveControl0 = FullSizeWaveformContainer.Get<Panel>("WaveControl.0");
            Panel WaveControl1 = null;
            try
            {
                WaveControl1 = FullSizeWaveformContainer.Get<Panel>("WaveControl.1");
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message.ToString());
            }
            Assert.IsTrue((WaveControl0 != null) && (WaveControl1 == null));

            //Clieck on Compressed, there is only one result in the FullSizeWaveformContainer
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnStrip")).Click();
            FullSizeWaveformContainer = _CAMainWindow.Get<Panel>("FullSizeWaveformContainer");
            WaveControl0 = FullSizeWaveformContainer.Get<Panel>("WaveControl.0");
            WaveControl1 = FullSizeWaveformContainer.Get<Panel>("WaveControl.1");
            Assert.IsTrue((WaveControl0 != null) && (WaveControl1 != null));

            TestLog.WriteLog("End WaveformsReview: 21719: Waveforms review tab shall label all displayed waveform correctly.");
        }

        //24403 The user can change the waveform scales individually for each waveform channel.
        //include 24404 The user shall have the option of overriding the default waveform scale for a particular waveform channel.
        //the testing bed needs to have Art data at 4th position
        [Test]
        public void ChangeWaveformScale()
        {
            //prepare for the displaying data
            Prepare("ChangeWaveformScale");

            TestLog.WriteLog("Start ChangeWaveformScale: 24403 The user can change the waveform scales individually for each waveform channel.");

            //Clieck on Compressed, there is only one result in the FullSizeWaveformContainer
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnCompressed")).Click();
            _CAMainWindow.Get<Button>(SearchCriteria.ByAutomationId("btnDispSettings")).Click();
            Window DisplaySettingsWindow = _CAMainWindow.ModalWindow("Display Settings");
            CheckBox ECGCheckBox = DisplaySettingsWindow.Get<CheckBox>(SearchCriteria.ByControlType(ControlType.CheckBox).AndIndex(0));
            ECGCheckBox.UnSelect();
            ECGCheckBox.Select();
            ComboBox ECGScales = DisplaySettingsWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("cboScaleValue"));
            ECGScales.Click();
            ECGScales.Select("60 mm/mV");
            DisplaySettingsWindow.Get<Button>(SearchCriteria.ByText("OK")).Click();
            Panel ScaleControl = _CAMainWindow.Get<Panel>(SearchCriteria.ByAutomationId("ScaleControl.0"));
            string ScaleLabelStr = ScaleControl.Get<Label>(SearchCriteria.ByAutomationId("Label.1")).Text;

            //verify the selected value
            Assert.IsTrue(ScaleLabelStr.Contains("60 mm/mV"));

            //scroll Art scale
            //the testing bed needs to have Art data at 4th position
            _CAMainWindow.Get<Button>(SearchCriteria.ByAutomationId("btnDispSettings")).Click();
            DisplaySettingsWindow = _CAMainWindow.ModalWindow("Display Settings");
            CheckBox ARTBox = DisplaySettingsWindow.Get<CheckBox>(SearchCriteria.ByControlType(ControlType.CheckBox).AndIndex(3));
            ARTBox.UnSelect();
            ARTBox.Select();
            Panel pnlScalePreview = DisplaySettingsWindow.Get<Panel>(SearchCriteria.ByAutomationId("pnlScalePreview"));
            string maxStr = pnlScalePreview.Get<Label>(SearchCriteria.ByAutomationId("lblMaxScale")).Text;
            int maxvalue = Convert.ToInt32(maxStr.Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries)[0]);

            Panel maxScrollBar = (Panel)DisplaySettingsWindow.Get(SearchCriteria.ByAutomationId("scbMaxScale"));
            maxStr = pnlScalePreview.Get<Label>(SearchCriteria.ByAutomationId("lblMaxScale")).Text;
            maxvalue = Convert.ToInt32(maxStr.Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries)[0]);

            //run ScrollBar, scroll the max value to 168
            while (maxvalue < 168)
            {
                maxScrollBar.RightClick();
                List<Window> windows = WindowFactory.Desktop.DesktopWindows();
                foreach (Window w in windows)
                {
                    //popup window has no name
                    if (w.Name == "")
                    {
                        w.Popup.Item("Scroll Right").Click();
                        break;
                    }
                }
                pnlScalePreview = DisplaySettingsWindow.Get<Panel>(SearchCriteria.ByAutomationId("pnlScalePreview"));
                maxStr = pnlScalePreview.Get<Label>(SearchCriteria.ByAutomationId("lblMaxScale")).Text;
                maxvalue = Convert.ToInt32(maxStr.Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries)[0]);
            }
            while (maxvalue > 168)
            {
                maxScrollBar.RightClick();
                List<Window> windows = WindowFactory.Desktop.DesktopWindows();
                foreach (Window w in windows)
                {
                    if (w.Name == "")
                    {
                        w.Popup.Item("Scroll Left").Click();
                        break;
                    }
                }
                pnlScalePreview = DisplaySettingsWindow.Get<Panel>(SearchCriteria.ByAutomationId("pnlScalePreview"));
                maxStr = pnlScalePreview.Get<Label>(SearchCriteria.ByAutomationId("lblMaxScale")).Text;
                maxvalue = Convert.ToInt32(maxStr.Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries)[0]);
            }
            DisplaySettingsWindow = _CAMainWindow.ModalWindow("Display Settings");
            DisplaySettingsWindow.Get<Button>(SearchCriteria.ByText("OK")).Click();

            //verify the max scale result
            _CAMainWindow.Get<Button>(SearchCriteria.ByAutomationId("btnDispSettings")).Click();
            DisplaySettingsWindow = _CAMainWindow.ModalWindow("Display Settings");
            ARTBox = DisplaySettingsWindow.Get<CheckBox>(SearchCriteria.ByControlType(ControlType.CheckBox).AndIndex(3));
            ARTBox.UnSelect();
            ARTBox.Select();
            pnlScalePreview = DisplaySettingsWindow.Get<Panel>(SearchCriteria.ByAutomationId("pnlScalePreview"));
            maxStr = pnlScalePreview.Get<Label>(SearchCriteria.ByAutomationId("lblMaxScale")).Text;
            maxvalue = Convert.ToInt32(maxStr.Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries)[0]);
            Assert.IsTrue(maxvalue == 168);

            DisplaySettingsWindow.Get(SearchCriteria.ByText("OK")).Click();

            TestLog.WriteLog("End ChangeWaveformScale: 24403 The user can change the waveform scales individually for each waveform channel.");
        }

        //24401: After certain part of the ECG waveform data is ignored, the waveform display shall represent the ignored part of the waveform by
        // ??? can't do mouse click on the waveform
        [Test]
        public void AnaysizeIgnoreRestore()
        {
            //prepare for the monitoring data
            Prepare("testbed");

            TestLog.WriteLog("Start AnaysizeIgnoreRestore: 24401: After certain part of the ECG waveform data is ignored, the waveform display shall represent the ignored part of the waveform by");

            //click Compressed and then Analyze
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnCompressed")).Click();
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnAnalyze")).Click();
            Window AnalyzeWindow = _CAMainWindow.ModalWindow("Select Time");
            var ConfigComboBox = AnalyzeWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("CboDuration"));
            ConfigComboBox.Click();
            ConfigComboBox.Select("Previous 2 Hours");
            AnalyzeWindow.Get<Button>(SearchCriteria.ByText("OK")).Click();
            //wait for Analyze finish
            Thread.Sleep(10000);
            //CLick Ignore then Restore
            _CAMainWindow.Get<Button>(SearchCriteria.ByAutomationId("btnIgnore")).Click();
            Window IgnoreMessageWindow = _CAMainWindow.ModalWindow("Waveform ignore message");
            Panel wave1 = _CAMainWindow.Get<Panel>(SearchCriteria.ByAutomationId("WaveControl.0"));
            IgnoreMessageWindow.Get<Button>(SearchCriteria.ByText("OK")).Click();
            Mouse.Instance.DoubleClick(wave1.ClickablePoint);
            Mouse.Instance.MoveOut();
            Mouse.Instance.DoubleClick(wave1.ClickablePoint);
            _CAMainWindow.Get<Button>(SearchCriteria.ByAutomationId("btnRestore")).Click();
            Window RestoreMessageWindow = _CAMainWindow.ModalWindow("Waveform restore message");
            RestoreMessageWindow.Get<Button>(SearchCriteria.ByText("OK")).Click();
            wave1 = _CAMainWindow.Get<Panel>(SearchCriteria.ByAutomationId("WaveControl.0"));
            Mouse.Instance.DoubleClick(wave1.ClickablePoint);
            Mouse.Instance.MoveOut();
            Mouse.Instance.DoubleClick(wave1.ClickablePoint);

            TestLog.WriteLog("End AnaysizeIgnoreRestore: 24401: After certain part of the ECG waveform data is ignored, the waveform display shall represent the ignored part of the waveform by");
        }

        //24400: Clinical Access user has Ignore/Restore option
        [Test]
        public void CheckIgnoreRestoreOption()
        {
            //prepare for the monitoring data
            Prepare("testbed");

            TestLog.WriteLog("Start CheckIgnoreRestoreOption: 24400: Clinical Access user has Ignore/Restore option");

            //click Compressed and then Analyze
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnCompressed")).Click();
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnAnalyze")).Click();
            Window AnalyzeWindow = _CAMainWindow.ModalWindow("Select Time");
            var ConfigComboBox = AnalyzeWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("CboDuration"));
            ConfigComboBox.Click();
            ConfigComboBox.Select("Previous 2 Hours");
            AnalyzeWindow.Get<Button>(SearchCriteria.ByText("OK")).Click();
            //wait for Analyze finish
            Thread.Sleep(10000);
            //CLick Ignore then Restore
            _CAMainWindow.Get<Button>(SearchCriteria.ByAutomationId("btnIgnore")).Click();
            Window IgnoreMessageWindow = _CAMainWindow.ModalWindow("Waveform ignore message");
            IgnoreMessageWindow.Get<Button>(SearchCriteria.ByText("Cancel")).Click();
            _CAMainWindow.Get<Button>(SearchCriteria.ByAutomationId("btnRestore")).Click();
            Window RestoreMessageWindow = _CAMainWindow.ModalWindow("Waveform restore message");
            RestoreMessageWindow.Get<Button>(SearchCriteria.ByText("Cancel")).Click();

            //Click Strip, then, CLick Ignore then Restore
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnStrip")).Click();
            _CAMainWindow.Get<Button>(SearchCriteria.ByAutomationId("btnIgnore")).Click();
            IgnoreMessageWindow = _CAMainWindow.ModalWindow("Waveform ignore message");
            IgnoreMessageWindow.Get<Button>(SearchCriteria.ByText("Cancel")).Click();
            _CAMainWindow.Get<Button>(SearchCriteria.ByAutomationId("btnRestore")).Click();
            RestoreMessageWindow = _CAMainWindow.ModalWindow("Waveform restore message");
            RestoreMessageWindow.Get<Button>(SearchCriteria.ByText("Cancel")).Click();

            TestLog.WriteLog("End CheckIgnoreRestoreOption: 24400: Clinical Access user has Ignore/Restore option");
        }

        //24396: Waveform view can be switched between Compressed and Strip view format with the same beginning time
        [Test]
        public void SwitchCompressedStrip()
        {
            //prepare for the monitoring data
            Prepare("testbed");

            TestLog.WriteLog("Start SwitchCompressedStrip: 24396: Waveform view can be switched between Compressed and Strip view format with the same beginning time");

            //click Compressed
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnCompressed")).Click();
            //Panel WaveformReview = _CAMainWindow.Get<Panel>(SearchCriteria.ByAutomationId("WaveformReview"));
            string CompressedStartTimeStr = _CAMainWindow.Get<Label>(SearchCriteria.ByAutomationId("lblTime")).Text.ToString();

            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnStrip")).Click();
            string StripTimeStr = _CAMainWindow.Get<Label>(SearchCriteria.ByAutomationId("lblTime")).Text.ToString();

            //compare the start time at Compressed and Strip 
            Assert.IsTrue(CompressedStartTimeStr == StripTimeStr);

            TestLog.WriteLog("End SwitchCompressedStrip: 24396: Waveform view can be switched between Compressed and Strip view format with the same beginning time");
        }

        //24395: Select or de-select the waveforms to view
        [Test]
        public void SelectDeselect()
        {
            //prepare for the monitoring data
            Prepare("SLMBed");

            TestLog.WriteLog("Start SelectDeselect: 24395: Select or de-select the waveforms to view");

            var SettingsBtn = _CAMainWindow.Get(SearchCriteria.ByText("Settings"));
            SettingsBtn.Click();
            Window _DisplaySettingsWindow = _CAMainWindow.ModalWindow("Display Settings");

            //select 0 ECG (I) and deselect 6 EVG (AVF)
            CheckBox checkbox0 = (CheckBox)_DisplaySettingsWindow.Get(SearchCriteria.ByControlType(ControlType.CheckBox).AndIndex(0));
            checkbox0.Select();
            CheckBox checkbox1 = (CheckBox)_DisplaySettingsWindow.Get(SearchCriteria.ByControlType(ControlType.CheckBox).AndIndex(1));
            checkbox1.Select();
            CheckBox checkbox2 = (CheckBox)_DisplaySettingsWindow.Get(SearchCriteria.ByControlType(ControlType.CheckBox).AndIndex(2));
            checkbox2.Select();
            CheckBox checkbox3 = (CheckBox)_DisplaySettingsWindow.Get(SearchCriteria.ByControlType(ControlType.CheckBox).AndIndex(3));
            checkbox3.Select();
            CheckBox checkbox4 = (CheckBox)_DisplaySettingsWindow.Get(SearchCriteria.ByControlType(ControlType.CheckBox).AndIndex(4));
            checkbox4.Select();
            CheckBox checkbox6 = (CheckBox)_DisplaySettingsWindow.Get(SearchCriteria.ByControlType(ControlType.CheckBox).AndIndex(5));
            checkbox6.UnSelect();
            _DisplaySettingsWindow.Get<Button>(SearchCriteria.ByText("OK")).Click();

            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnStrip")).Click();
            Panel FullSizeWaveformContainer = _CAMainWindow.Get<Panel>(SearchCriteria.ByAutomationId("FullSizeWaveformContainer"));
            Panel wave1Panel = FullSizeWaveformContainer.Get<Panel>(SearchCriteria.ByAutomationId("ScaleControl.0"));
            string wave1Str = wave1Panel.Get<Label>(SearchCriteria.ByAutomationId("Label.0")).Text;
            Panel wave1Pane5 = FullSizeWaveformContainer.Get<Panel>(SearchCriteria.ByAutomationId("ScaleControl.5"));
            string wave5Str = wave1Pane5.Get<Label>(SearchCriteria.ByAutomationId("Label.0")).Text;

            //verify
            Assert.IsTrue(wave1Str.Contains("ECG (I)") && !wave5Str.Contains("ECG (AVF)"));

            TestLog.WriteLog("End SelectDeselect: 24395: Select or de-select the waveforms to view");
        }

        //24394: Waveforms shall include parameter label names for all displayed waveforms 
        [Test]
        public void WaveformsLabel()
        {
            //prepare for the monitoring data
            Prepare("SLMBed");

            TestLog.WriteLog("Start WaveformsLabel: 24394: Waveforms shall include parameter label names for all displayed waveforms");

            //Compressed, verify the labels
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnCompressed")).Click();
            Panel CompressedPanel = _CAMainWindow.Get<Panel>(SearchCriteria.ByAutomationId("CompressedWaveformContainer"));
            Panel wave1Panel = CompressedPanel.Get<Panel>(SearchCriteria.ByAutomationId("ScaleControl.0"));
            string wave1Str = wave1Panel.Get<Label>(SearchCriteria.ByAutomationId("Label.1")).Text;
            Panel wave2Panel = CompressedPanel.Get<Panel>(SearchCriteria.ByAutomationId("ScaleControl.1"));
            string wave2Str = wave2Panel.Get<Label>(SearchCriteria.ByAutomationId("Label.1")).Text;
            Panel wave3Panel = CompressedPanel.Get<Panel>(SearchCriteria.ByAutomationId("ScaleControl.2"));
            string wave3Str = wave3Panel.Get<Label>(SearchCriteria.ByAutomationId("Label.1")).Text;

            //verify
            Assert.IsTrue((wave1Str == " ECG (I) ") && (wave2Str == " ECG (II) ") && (wave3Str == " ECG (III) "));

            //Strip, verify the labels
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnStrip")).Click();
            Panel StripPanel = _CAMainWindow.Get<Panel>(SearchCriteria.ByAutomationId("FullSizeWaveformContainer"));
            wave1Panel = StripPanel.Get<Panel>(SearchCriteria.ByAutomationId("ScaleControl.0"));
            wave1Str = wave1Panel.Get<Label>(SearchCriteria.ByAutomationId("Label.0")).Text;
            wave2Panel = StripPanel.Get<Panel>(SearchCriteria.ByAutomationId("ScaleControl.1"));
            wave2Str = wave2Panel.Get<Label>(SearchCriteria.ByAutomationId("Label.0")).Text;
            wave3Panel = StripPanel.Get<Panel>(SearchCriteria.ByAutomationId("ScaleControl.2"));
            wave3Str = wave3Panel.Get<Label>(SearchCriteria.ByAutomationId("Label.0")).Text;

            Assert.IsTrue((wave1Str == " ECG (I) ") && (wave2Str == " ECG (II) ") && (wave3Str == " ECG (III) "));

            TestLog.WriteLog("End SelectDeselect: 24394: Waveforms shall include parameter label names for all displayed waveforms ");
        }

        //24393: Beat annotation can be turned ON/OFF in Waveform settings
        // ??? can't verify the Beat
        [Test]
        public void BeatAnnotation()
        {
            //prepare for the monitoring data
            Prepare("testbed");

            TestLog.WriteLog("Start WaveformsLabel: 24393: Beat annotation can be turned ON/OFF in Waveform settings");

            //click Strip and then Analyze
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnStrip")).Click();
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnAnalyze")).Click();
            Window AnalyzeWindow = _CAMainWindow.ModalWindow("Select Time");
            var ConfigComboBox = AnalyzeWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("CboDuration"));
            ConfigComboBox.Click();
            ConfigComboBox.Select("Previous 12 Hours");
            AnalyzeWindow.Get<Button>(SearchCriteria.ByText("OK")).Click();
            //wait for Analyze finish
            Thread.Sleep(15000);
            _CAMainWindow.Get(SearchCriteria.ByText("Settings")).Click();
            Window _DisplaySettingsWindow = _CAMainWindow.ModalWindow("Display Settings");

            //Compressed, verify the labels
            _CAMainWindow.Get(SearchCriteria.ByText("Beat Annotation")).Click();
            _DisplaySettingsWindow.Get(SearchCriteria.ByText("OK")).Click();
            _CAMainWindow.Get(SearchCriteria.ByText("Settings")).Click();
            _DisplaySettingsWindow = _CAMainWindow.ModalWindow("Display Settings");
            _CAMainWindow.Get(SearchCriteria.ByText("Beat Annotation")).Click();
            _DisplaySettingsWindow.Get(SearchCriteria.ByText("OK")).Click();

            TestLog.WriteLog("End SelectDeselect: 24393: Beat annotation can be turned ON/OFF in Waveform settings");
        }


        ////24392: Waveform View Date - Compressed view over two dates.
        //[Test]
        //public void ViewTwoDate()
        //{
        //    //prepare for the monitoring data
        //    Prepare("SLMBed");

        //    TestLog.WriteLog("Start ViewTwoDate: 24392: Waveform View Date - Compressed view over two dates.");

        //    _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnCompressed")).Click();
        //    _CAMainWindow.Get(SearchCriteria.ByText("Settings")).Click();
        //    Window _DisplaySettingsWindow = _CAMainWindow.ModalWindow("Display Settings");
        //    CheckBox checkbox0 = (CheckBox)_DisplaySettingsWindow.Get(SearchCriteria.ByControlType(ControlType.CheckBox).AndIndex(0));
        //    checkbox0.Select();
        //    CheckBox checkbox1 = (CheckBox)_DisplaySettingsWindow.Get(SearchCriteria.ByControlType(ControlType.CheckBox).AndIndex(1));
        //    checkbox1.Select();
        //    CheckBox checkbox2 = (CheckBox)_DisplaySettingsWindow.Get(SearchCriteria.ByControlType(ControlType.CheckBox).AndIndex(2));
        //    checkbox2.Select();
        //    CheckBox checkbox3 = (CheckBox)_DisplaySettingsWindow.Get(SearchCriteria.ByControlType(ControlType.CheckBox).AndIndex(3));
        //    checkbox3.UnSelect();
        //    CheckBox checkbox4 = (CheckBox)_DisplaySettingsWindow.Get(SearchCriteria.ByControlType(ControlType.CheckBox).AndIndex(4));
        //    checkbox4.UnSelect();
        //    CheckBox checkbox5 = (CheckBox)_DisplaySettingsWindow.Get(SearchCriteria.ByControlType(ControlType.CheckBox).AndIndex(5));
        //    checkbox5.UnSelect();
        //    _DisplaySettingsWindow.Get<Button>(SearchCriteria.ByText("OK")).Click();

        //    //change the MinPerPage to 5
        //    var cboMinPerPageComboBox = _CAMainWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("cboMinPerPage"));
        //    cboMinPerPageComboBox.Click();
        //    cboMinPerPageComboBox.Select("5");

        //    //decide the time after move
        //    Panel WaveformReviewPanel = _CAMainWindow.Get<Panel>(SearchCriteria.ByAutomationId("WaveformReview"));
        //    string CurrentTime = WaveformReviewPanel.Get<Label>(SearchCriteria.ByAutomationId("lblTime")).Text;
        //    DateTime CurrentDateTime = Convert.ToDateTime(CurrentTime);
        //    //DateTime ToDateTime = CurrentDateTime.AddDays(-1);
        //    DateTime ToDateTime = new DateTime(CurrentDateTime.Year, CurrentDateTime.Month, CurrentDateTime.Day, 00, 05, 01);
        //    DateTime ToDateTime2 = new DateTime(CurrentDateTime.Year, CurrentDateTime.Month, CurrentDateTime.Day, 0, 0, 0);

        //    Panel scTimePanel = _CAMainWindow.Get<Panel>(SearchCriteria.ByAutomationId("scTime"));
        //    Button PageBwBtn = scTimePanel.Get<Button>(SearchCriteria.ByAutomationId("PageBw"));
        //    Button StepBwBtn = scTimePanel.Get<Button>(SearchCriteria.ByAutomationId("StepBw"));

        //    //move the time bar at the bottom to just below the 1 day earlier time
        //    DateTime beginTime = DateTime.Now;
        //    //use PageBw button to move the time 5 min each time
        //    while (CurrentDateTime > ToDateTime)
        //    {
        //        PageBwBtn.Click();
        //        CurrentTime = WaveformReviewPanel.Get<Label>(SearchCriteria.ByAutomationId("lblTime")).Text;
        //        CurrentDateTime = Convert.ToDateTime(CurrentTime);
        //        DateTime endTime = DateTime.Now;
        //        if (endTime.Subtract(beginTime).TotalMinutes > 3)
        //            break;
        //    }
        //    //use StepBw button to move the time 10 sec each time
        //    beginTime = DateTime.Now;
        //    while (CurrentDateTime > ToDateTime2)
        //    {
        //        StepBwBtn.Click();
        //        CurrentTime = WaveformReviewPanel.Get<Label>(SearchCriteria.ByAutomationId("lblTime")).Text;
        //        CurrentDateTime = Convert.ToDateTime(CurrentTime);
        //        DateTime endTime = DateTime.Now;
        //        if (endTime.Subtract(beginTime).TotalMinutes > 3)
        //            break;
        //    }


        //    //should have two date time displayed at 0 and 1 or 2 position
        //    Panel CompressedWaveformContainer = _CAMainWindow.Get<Panel>(SearchCriteria.ByAutomationId("CompressedWaveformContainer"));
        //    Panel TimePanel1 = CompressedWaveformContainer.Get<Panel>(SearchCriteria.ByAutomationId("TimeControl.0"));
        //    string DateTimeStr1 = TimePanel1.Get<Label>(SearchCriteria.ByAutomationId("Label.0")).Text;
        //    DateTime DateTime1 = Convert.ToDateTime(DateTimeStr1);
        //    Panel TimePanel2 = CompressedWaveformContainer.Get<Panel>(SearchCriteria.ByAutomationId("TimeControl.1"));
        //    string DateTimeStr2 = TimePanel2.Get<Label>(SearchCriteria.ByAutomationId("Label.0")).Text;
        //    Panel TimePanel3 = CompressedWaveformContainer.Get<Panel>(SearchCriteria.ByAutomationId("TimeControl.2"));
        //    string DateTimeStr3 = TimePanel2.Get<Label>(SearchCriteria.ByAutomationId("Label.0")).Text;
        //    DateTime DateTime2 = DateTime.Now;
        //    if (DateTimeStr2 != "")
        //    {
        //        DateTime2 = Convert.ToDateTime(DateTimeStr2);
        //    }
        //    else if (DateTimeStr3 != "")
        //    {
        //        DateTime2 = Convert.ToDateTime(DateTimeStr3);
        //    }

        //    Assert.IsTrue((DateTime2 - DateTime1).Days == 1);

        //    TestLog.WriteLog("End ViewTwoDate: 24392: Waveform View Date - Compressed view over two dates.");
        //}

        //24391: Waveform View Date -Compressed and Strip
        [Test]
        public void WaveformViewDate()
        {
            //prepare for the monitoring data
            Prepare("testbed");

            TestLog.WriteLog("Start WaveformViewDate: 24391: Waveform View Date -Compressed and Strip");

            //regular expression for date format mm/day/yyyy  9/21/2016
            Regex dateRegEx = new Regex(@"(([1-9])|(1[0-2]))\/(([1-9])|(1[0-9])|(2[0-9])|(3[0-1]))\/(\d{4})");
            //Compressed
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnCompressed")).Click();
            Panel CompressedWaveformContainer = _CAMainWindow.Get<Panel>(SearchCriteria.ByAutomationId("CompressedWaveformContainer"));
            Panel TimePanel1 = CompressedWaveformContainer.Get<Panel>(SearchCriteria.ByAutomationId("TimeControl.0"));
            string DateTimeStr1 = TimePanel1.Get<Label>(SearchCriteria.ByAutomationId("Label.0")).Text;
            Assert.IsTrue(dateRegEx.IsMatch(DateTimeStr1));

            //Strip
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnStrip")).Click();
            Panel FullSizeWaveformContainer = _CAMainWindow.Get<Panel>(SearchCriteria.ByAutomationId("FullSizeWaveformContainer"));
            Panel TimePanel2 = FullSizeWaveformContainer.Get<Panel>(SearchCriteria.ByAutomationId("TimeControl.0"));
            string DateTimeStr2 = TimePanel2.Get<Label>(SearchCriteria.ByAutomationId("Label.0")).Text;
            Assert.IsTrue(dateRegEx.IsMatch(DateTimeStr2));

            TestLog.WriteLog("End SelectDeselect: 24391: Waveform View Date -Compressed and Strip");
        }

        //24390: Waveform View timestamps - Compressed and Strip
        [Test]
        public void WaveformViewTimestamp()
        {
            //prepare for the monitoring data
            Prepare("testbed");

            TestLog.WriteLog("Start WaveformViewTimestamp: 24390: Waveform View timestamps - Compressed and Strip");

            //regular expression for timestamp format hh:mm:ss PM
            Regex timestampRegEx = new Regex(@"[0-9]{1,2}:[0-9]{1,2}:[0-9]{1,2}\s[A|P]M");
            //Compressed
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnCompressed")).Click();
            Panel CompressedWaveformContainer = _CAMainWindow.Get<Panel>(SearchCriteria.ByAutomationId("CompressedWaveformContainer"));
            Panel TimePanel1 = CompressedWaveformContainer.Get<Panel>(SearchCriteria.ByAutomationId("TimeControl.0"));
            string TimeStampStr1 = TimePanel1.Get<Label>(SearchCriteria.ByAutomationId("Label.1")).Text;
            Assert.IsTrue(timestampRegEx.IsMatch(TimeStampStr1));

            //Strip
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnStrip")).Click();
            Panel FullSizeWaveformContainer = _CAMainWindow.Get<Panel>(SearchCriteria.ByAutomationId("FullSizeWaveformContainer"));
            Panel TimePanel2 = FullSizeWaveformContainer.Get<Panel>(SearchCriteria.ByAutomationId("TimeControl.0"));
            string timestampStr2 = TimePanel2.Get<Label>(SearchCriteria.ByAutomationId("Label.1")).Text;
            Assert.IsTrue(timestampRegEx.IsMatch(timestampStr2));

            TestLog.WriteLog("End WaveformViewTimestamp: 24390: Waveform View timestamps - Compressed and Strip");
        }

        //24387: Waveform View timestamps - Compressed and Strip
        [Test]
        public void DisplayRecentData()
        {
            //prepare for the monitoring data
            Prepare("testbed");

            TestLog.WriteLog("Start DisplayRecentData: 24387: Waveform View timestamps - Compressed and Strip");

            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnCompressed")).Click();
            Panel CompressedWaveformContainer = _CAMainWindow.Get<Panel>(SearchCriteria.ByAutomationId("CompressedWaveformContainer"));
            Panel TimePanel1 = CompressedWaveformContainer.Get<Panel>(SearchCriteria.ByAutomationId("TimeControl.0"));
            string DateStr = TimePanel1.Get<Label>(SearchCriteria.ByAutomationId("Label.0")).Text;
            string TimeStampStr = TimePanel1.Get<Label>(SearchCriteria.ByAutomationId("Label.1")).Text;
            DateTime displayedTime = Convert.ToDateTime(DateStr + " " + TimeStampStr);

            //Display most recent data < 15  ?
            Assert.IsTrue((DateTime.Now - displayedTime).TotalMinutes < 10);

            TestLog.WriteLog("End DisplayRecentData: 24387: Waveform View timestamps - Compressed and Strip");
        }

        //21727: Message is prompted to select six-second range when a strip waveform is saved.
        [Test]
        public void SaveWithSelectedSixSecond()
        {
            //prepare for the monitoring data
            Prepare("testbed");

            TestLog.WriteLog("Start SaveWithSelectedSixSecond: 21727: Message is prompted to select six-second range when a strip waveform is saved.");

            //Strip
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnStrip")).Click();
            _CAMainWindow.Get(SearchCriteria.ByText("Settings")).Click();
            Window _DisplaySettingsWindow = _CAMainWindow.ModalWindow("Display Settings");
            CheckBox sixsecondCheckbox = _DisplaySettingsWindow.Get<CheckBox>(SearchCriteria.ByAutomationId("chkStrip"));
            sixsecondCheckbox.Select();
            _DisplaySettingsWindow.Get<Button>(SearchCriteria.ByText("OK")).Click();
            _CAMainWindow.Get(SearchCriteria.ByText("Save")).Click();
            Window InformationWindow = _CAMainWindow.ModalWindow("Information");
            string message = InformationWindow.Get<Label>(SearchCriteria.ByAutomationId("LblText")).Text;
            Assert.IsTrue(message == "Please select midpoint of six-second range.");
            InformationWindow.Get<Button>(SearchCriteria.ByText("OK")).Click();

            Panel CompressedWaveformContainer = _CAMainWindow.Get<Panel>(SearchCriteria.ByAutomationId("FullSizeWaveformContainer"));
            Panel wave1 = CompressedWaveformContainer.Get<Panel>(SearchCriteria.ByAutomationId("WaveControl.0"));
            Point point1 = wave1.ClickablePoint;
            Mouse.Instance.DoubleClick(point1);

            Window SaveWindow = _CAMainWindow.ModalWindow("Save");
            var textComments = SaveWindow.Get<TextBox>(SearchCriteria.ByAutomationId("textComments"));
            textComments.Text = "test";
            var labelComment = SaveWindow.Get<TextBox>(SearchCriteria.ByAutomationId("textTitle"));
            labelComment.Text = "ECGTest1";
            SaveWindow.Get<Button>(SearchCriteria.ByText("OK")).Click();

            _CAMainWindow.Get(SearchCriteria.ByText("Saved Events")).Click();

            bool foundSavedEvent = false;
            var cboSavedEvents = _CAMainWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("cboSavedEvents"));
            cboSavedEvents.Click();
            foreach (var item in cboSavedEvents.Items)
            {
                if (item.Name.Contains("ECGTest1"))
                {
                    foundSavedEvent = true;
                    cboSavedEvents.Select(item.Name);
                }
            }

            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnThumbnails")).Click();

            Panel thumbnailContainer = _CAMainWindow.Get<Panel>(SearchCriteria.ByAutomationId("thumbnailContainer"));
            thumbnailContainer.Get<Button>(SearchCriteria.ByControlType(ControlType.CheckBox)).Click();
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnDelete")).Click();
            InformationWindow = _CAMainWindow.ModalWindow("Information");
            InformationWindow.Get<Button>(SearchCriteria.ByText("Yes")).Click();

            //verify found the save waveform
            Assert.IsTrue(foundSavedEvent);

            TestLog.WriteLog("End SaveWithSelectedSixSecond: 21727: Message is prompted to select six-second range when a strip waveform is saved.");
        }

        //21728: Message is prompted to select six-second range when a compressed waveform is saved.
        [Test]
        public void SaveWithSelectedSixSecond2()
        {
            //prepare for the monitoring data
            Prepare("testbed");

            TestLog.WriteLog("Start SaveWithSelectedSixSecond2: 21728: Message is prompted to select six-second range when a compressed waveform is saved.");

            //Compressed
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnCompressed")).Click();
            _CAMainWindow.Get(SearchCriteria.ByText("Settings")).Click();
            Window _DisplaySettingsWindow = _CAMainWindow.ModalWindow("Display Settings");
            CheckBox sixsecondCheckbox = _DisplaySettingsWindow.Get<CheckBox>(SearchCriteria.ByAutomationId("chkStrip"));
            sixsecondCheckbox.Select();
            _DisplaySettingsWindow.Get<Button>(SearchCriteria.ByText("OK")).Click();
            _CAMainWindow.Get(SearchCriteria.ByText("Save")).Click();
            Window InformationWindow = _CAMainWindow.ModalWindow("Information");
            string message = InformationWindow.Get<Label>(SearchCriteria.ByAutomationId("LblText")).Text;
            Assert.IsTrue(message == "Please select start and end points.");
            InformationWindow.Get<Button>(SearchCriteria.ByText("OK")).Click();

            TestLog.WriteLog("End SaveWithSelectedSixSecond2: 21728: Message is prompted to select six-second range when a compressed waveform is saved.");
        }

        //21731: Print while saving option enabled for strip view.
        [Test]
        public void PrintWithSelectedSixSecond()
        {
            //prepare for the monitoring data
            Prepare("testbed");

            TestLog.WriteLog("Start PrintWithSelectedSixSecond: 21731: Print while saving option enabled for strip view.");

            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnStrip")).Click();
            _CAMainWindow.Get(SearchCriteria.ByText("Settings")).Click();
            Window _DisplaySettingsWindow = _CAMainWindow.ModalWindow("Display Settings");
            CheckBox sixsecondCheckbox = _DisplaySettingsWindow.Get<CheckBox>(SearchCriteria.ByAutomationId("chkStrip"));
            sixsecondCheckbox.Select();
            _DisplaySettingsWindow.Get<Button>(SearchCriteria.ByText("OK")).Click();
            _CAMainWindow.Get(SearchCriteria.ByText("Print")).Click();
            Window InformationWindow = _CAMainWindow.ModalWindow("Information");
            string message = InformationWindow.Get<Label>(SearchCriteria.ByAutomationId("LblText")).Text;
            Assert.IsTrue(message == "Please select midpoint of six-second range.");
            InformationWindow.Get<Button>(SearchCriteria.ByText("OK")).Click();

            TestLog.WriteLog("End PrintWithSelectedSixSecond: 21731: Print while saving option enabled for strip view.");
        }

        //21723: Each type of measurement caliper shall be differentiated by color.
        [Test]
        public void CaliperOpeation()
        {
            //prepare for the monitoring data
            Prepare("testbed");

            TestLog.WriteLog("Start CaliperOpeation: 21723: Each type of measurement caliper shall be differentiated by color.");

            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnStrip")).Click();
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnCalipers")).DoubleClick();
            Panel CaliperPanel = _CAMainWindow.Get<Panel>(SearchCriteria.ByAutomationId("CaliperPanel"));
            Panel FullSizeWaveformContainer = _CAMainWindow.Get<Panel>(SearchCriteria.ByAutomationId("FullSizeWaveformContainer"));
            Panel wave1 = FullSizeWaveformContainer.Get<Panel>(SearchCriteria.ByAutomationId("WaveControl.0"));
            Panel wave2 = FullSizeWaveformContainer.Get<Panel>(SearchCriteria.ByAutomationId("WaveControl.1"));
            //Click on Rate button
            RadioButton Rate = CaliperPanel.Get<RadioButton>(SearchCriteria.ByText("Rate"));
            Rate.Click();
            Point point1 = wave1.ClickablePoint;
            Mouse.Instance.Click(point1);
            Mouse.LeftDown();
            Mouse.Instance.Location = new Point(point1.X + 10, point1.Y);
            Mouse.LeftUp();
            Mouse.Instance.Click(point1);
            //QRS
            RadioButton QRS = CaliperPanel.Get<RadioButton>(SearchCriteria.ByText("QRS"));
            QRS.Click();
            Point point2 = wave1.ClickablePoint;
            Mouse.Instance.Click(point2);
            Mouse.LeftDown();
            Mouse.Instance.Location = new Point(point2.X + 10, point2.Y);
            Mouse.LeftUp();
            Mouse.Instance.Click(point2);
            //QT
            RadioButton QT = CaliperPanel.Get<RadioButton>(SearchCriteria.ByText("QT"));
            QT.Click();
            Point point3 = wave1.ClickablePoint;
            Mouse.Instance.Click(point3);
            Mouse.LeftDown();
            Mouse.Instance.Location = new Point(point3.X + 10, point3.Y);
            Mouse.LeftUp();
            Mouse.Instance.Click(point3);
            //PR
            RadioButton PR = CaliperPanel.Get<RadioButton>(SearchCriteria.ByText("PR"));
            PR.Click();
            Point point4 = wave1.ClickablePoint;
            Mouse.Instance.Click(point4);
            Mouse.LeftDown();
            Mouse.Instance.Location = new Point(point4.X + 10, point4.Y);
            Mouse.LeftUp();
            Mouse.Instance.Click(point4);
            //Amplitute
            RadioButton Amplitude = CaliperPanel.Get<RadioButton>(SearchCriteria.ByText("Amplitude"));
            Amplitude.Click();
            Point point5 = wave1.ClickablePoint;
            Mouse.LeftDown();
            Mouse.LeftUp();
            Mouse.Instance.Click(point5);
            Mouse.LeftDown();
            Mouse.Instance.Location = new Point(point5.X, point5.Y + 20);
            Mouse.LeftUp();
            Mouse.Instance.Click(point5);

            //verify the results
            wave1 = FullSizeWaveformContainer.Get<Panel>(SearchCriteria.ByAutomationId("WaveControl.0"));
            string Str1 = wave1.Get<Label>(SearchCriteria.ByControlType(ControlType.Text).AndIndex(0)).Text;
            string Str2 = wave1.Get<Label>(SearchCriteria.ByControlType(ControlType.Text).AndIndex(1)).Text;
            string Str3 = wave1.Get<Label>(SearchCriteria.ByControlType(ControlType.Text).AndIndex(2)).Text;
            string Str4 = wave1.Get<Label>(SearchCriteria.ByControlType(ControlType.Text).AndIndex(3)).Text;
            string Str5 = wave1.Get<Label>(SearchCriteria.ByControlType(ControlType.Text).AndIndex(4)).Text;
            string[] strArr = new string[] { Str1, Str2, Str3, Str4, Str5 };
            foreach (string str in strArr)
            {
                Assert.IsTrue(str.StartsWith("Rate") || str.StartsWith("QRS") || str.StartsWith("QT") || str.StartsWith("PR") || str.StartsWith("Amplitude"));
            }

            //Amplitute on wave2
            Amplitude.Click();
            Amplitude.Click();
            Point point6 = wave2.ClickablePoint;
            Mouse.Instance.Click(point6);
            Mouse.LeftDown();
            Mouse.Instance.Location = new Point(point6.X, point6.Y + 10);
            Mouse.LeftUp();
            Mouse.Instance.Click(point6);

            string AmplitudeStr2 = wave2.Get<Label>(SearchCriteria.ByControlType(ControlType.Text).AndIndex(0)).Text;
            Assert.IsTrue(AmplitudeStr2.StartsWith("Amplitude"));

            TestLog.WriteLog("End CaliperOpeation: 21723: Each type of measurement caliper shall be differentiated by color.");
        }

        //24389: Change position on the time line by clicking timeline when viewing patient's waveform data
        [Test]
        public void TimelineChange()
        {
            //prepare for the monitoring data
            Prepare("testbed");

            TestLog.WriteLog("Start TimelineChange: 24389: Change position on the time line by clicking timeline when viewing patient's waveform data");

            //Compressed
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnCompressed")).Click();
            Panel CompressedWaveformContainer = _CAMainWindow.Get<Panel>(SearchCriteria.ByAutomationId("CompressedWaveformContainer"));

            Panel wave1 = CompressedWaveformContainer.Get<Panel>(SearchCriteria.ByAutomationId("WaveControl.0"));
            Point point1 = wave1.ClickablePoint;
            Mouse.Instance.Click(point1);

            Panel FullSizeWaveformContainer = _CAMainWindow.Get<Panel>(SearchCriteria.ByAutomationId("FullSizeWaveformContainer"));
            Panel TimeControl = FullSizeWaveformContainer.Get<Panel>(SearchCriteria.ByAutomationId("TimeControl.0"));
            string timestampStr1 = TimeControl.Get<Label>(SearchCriteria.ByAutomationId("Label.1")).Text;

            Mouse.Instance.Location = new Point(point1.X + 200, point1.Y);
            Mouse.Instance.DoubleClick(Mouse.Instance.Location);
            string timestampStr2 = TimeControl.Get<Label>(SearchCriteria.ByAutomationId("Label.1")).Text;

            Assert.IsTrue(timestampStr1 != timestampStr2);

            //Strip
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnStrip")).Click();
            CompressedWaveformContainer = _CAMainWindow.Get<Panel>(SearchCriteria.ByAutomationId("CompressedWaveformContainer"));

            wave1 = CompressedWaveformContainer.Get<Panel>(SearchCriteria.ByAutomationId("WaveControl.0"));
            Point point2 = wave1.ClickablePoint;
            Mouse.Instance.Click(point2);

            FullSizeWaveformContainer = _CAMainWindow.Get<Panel>(SearchCriteria.ByAutomationId("FullSizeWaveformContainer"));
            TimeControl = FullSizeWaveformContainer.Get<Panel>(SearchCriteria.ByAutomationId("TimeControl.0"));
            timestampStr1 = TimeControl.Get<Label>(SearchCriteria.ByAutomationId("Label.1")).Text;

            Mouse.Instance.Location = new Point(point2.X + 200, point2.Y);
            Mouse.Instance.Click(Mouse.Instance.Location);
            timestampStr2 = TimeControl.Get<Label>(SearchCriteria.ByAutomationId("Label.1")).Text;

            Assert.IsTrue(timestampStr1 != timestampStr2);

            TestLog.WriteLog("End TimelineChange: 24389: Change position on the time line by clicking timeline when viewing patient's waveform data");
        }

        //21757: Save Compressed waveform data with maximum data displayed in compressed format.
        [Test]
        public void SaveWaveform()
        {
            //prepare for the monitoring data
            Prepare("testbed");

            TestLog.WriteLog("Start SaveWaveform: 21757: Save Compressed waveform data with maximum data displayed in compressed format.");

            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnCompressed")).Click();
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnSave")).Click();

            Window InformationWindow = _CAMainWindow.ModalWindow("Information");
            InformationWindow.Get<Button>(SearchCriteria.ByText("OK")).Click();

            Panel CompressedWaveformContainer = _CAMainWindow.Get<Panel>(SearchCriteria.ByAutomationId("CompressedWaveformContainer"));
            Panel wave1 = CompressedWaveformContainer.Get<Panel>(SearchCriteria.ByAutomationId("WaveControl.0"));
            Point point1 = wave1.ClickablePoint;
            Mouse.Instance.Click(point1);
            Mouse.Instance.Location = new Point(point1.X + 200, point1.Y);
            Mouse.Instance.Click(Mouse.Instance.Location);

            Window SaveWindow = _CAMainWindow.ModalWindow("Save");
            var textComments = SaveWindow.Get<TextBox>(SearchCriteria.ByAutomationId("textComments"));
            textComments.Text = "test";
            var labelComment = SaveWindow.Get<TextBox>(SearchCriteria.ByAutomationId("textTitle"));
            labelComment.Text = "ECGTest1";
            SaveWindow.Get<Button>(SearchCriteria.ByText("OK")).Click();

            _CAMainWindow.Get(SearchCriteria.ByText("Saved Events")).Click();

            bool found = false;
            var cboSavedEvents = _CAMainWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("cboSavedEvents"));
            cboSavedEvents.Click();
            foreach (var item in cboSavedEvents.Items)
            {
                if (item.Name.Contains("ECGTest1"))
                {
                    found = true;
                    cboSavedEvents.Select(item.Name);
                }
            }

            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnThumbnails")).Click();

            Panel thumbnailContainer = _CAMainWindow.Get<Panel>(SearchCriteria.ByAutomationId("thumbnailContainer"));
            thumbnailContainer.Get<Button>(SearchCriteria.ByControlType(ControlType.CheckBox)).Click();
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnDelete")).Click();
            InformationWindow = _CAMainWindow.ModalWindow("Information");
            InformationWindow.Get<Button>(SearchCriteria.ByText("Yes")).Click();

            //verify found the save waveform
            Assert.IsTrue(found);

            TestLog.WriteLog("End SaveWaveform: 21757: Save Compressed waveform data with maximum data displayed in compressed format.");
        }

        //21736: Print compressed waveform data.
        [Test]
        public void PrintWaveform()
        {
            //prepare for the monitoring data
            Prepare("testbed");

            TestLog.WriteLog("Start PrintWaveform: 21736: Print compressed waveform data.");

            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnCompressed")).Click();
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnPrint")).Click();

            Window InformationWindow = _CAMainWindow.ModalWindow("Information");
            InformationWindow.Get<Button>(SearchCriteria.ByText("OK")).Click();

            Panel CompressedWaveformContainer = _CAMainWindow.Get<Panel>(SearchCriteria.ByAutomationId("CompressedWaveformContainer"));
            Panel wave1 = CompressedWaveformContainer.Get<Panel>(SearchCriteria.ByAutomationId("WaveControl.0"));
            Point point1 = wave1.ClickablePoint;
            Mouse.Instance.Click(point1);
            Mouse.Instance.Location = new Point(point1.X + 200, point1.Y);
            Mouse.Instance.Click(Mouse.Instance.Location);
            //wait for print to file
            Thread.Sleep(10000);

            bool foundFile = false;
            string[] files = Directory.GetFiles(@"C:\SLReports");
            foreach (string file in files)
            {
                if (file.Contains("COMPRESSEDWAVEFORM"))
                {
                    // File name like "COMPRESSEDWAVEFORM~FOR_10815_SD~~2016-09-26_10-16-08~1.pdf"
                    int pos = file.IndexOf("~~");
                    string subStr = file.Substring(pos + 2, 19);
                    string[] strArr = subStr.Split(new char[] { '-', '_' });
                    DateTime printTime = new DateTime(Convert.ToInt32(strArr[0]), Convert.ToInt32(strArr[1]), Convert.ToInt32(strArr[2]),
                        Convert.ToInt32(strArr[3]), Convert.ToInt32(strArr[4]), Convert.ToInt32(strArr[5]));
                    DateTime NowTime = DateTime.Now;
                    int SecDiff = (int)(NowTime - printTime).TotalSeconds;
                    //if find the recent file assumed from this test case
                    if (SecDiff < 20)
                    {
                        foundFile = true;
                        File.Delete(file);
                        break;
                    }
                }
            }

            //verify found the save waveform
            Assert.IsTrue(foundFile == true);

            TestLog.WriteLog("End PrintWaveform: 21736: Print compressed waveform data.");
        }
    }

    public class TwelveLeadsView
    {
        private static string CAExeFile;
        private static Application _CAApp;
        private static Window _CAMainWindow;
        Hashtable configHT;

        [SetUp]
        protected void SetUp()
        {
            configHT = Config.ReadConfig();
            string CAAppPath = (string)configHT["ExePath"];
            string CAExeFile = CAAppPath + @"\ClinicalHistoryXP.exe";

            var psi = new ProcessStartInfo(CAExeFile);
            _CAApp = Application.AttachOrLaunch(psi);
            _CAMainWindow = _CAApp.GetWindow(SearchCriteria.ByAutomationId("ClinicalAccess"), InitializeOption.NoCache);
        }

        public void Prepare(string bed)
        {
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnSelectPatient")).Click();
            Window _PatientSelectDialogWindow = _CAMainWindow.ModalWindow("Patient Select Dialog");

            var PatientsTab = _PatientSelectDialogWindow.Get(SearchCriteria.ByText("Patients"));
            PatientsTab.Click();

            var comboBox = _PatientSelectDialogWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("cmbFacility"));
            comboBox.Select("Facility1");

            _PatientSelectDialogWindow.Get(SearchCriteria.ByText("Unit Row 0")).DoubleClick();
            var DataGridView_Table = _PatientSelectDialogWindow.Get<Table>(SearchCriteria.ByAutomationId("dgvUnits"));

            //to avoid timeout=5000 exception
            CoreAppXmlConfiguration.Instance.BusyTimeout = 50000;
            bool found = false;
            TableRow testRow = null;
            //go through the units to find the testing bed
            for (int i = 0; i < DataGridView_Table.Rows.Count; i++)
            {
                string pos = i.ToString();
                _PatientSelectDialogWindow.Get(SearchCriteria.ByText("Unit Row " + pos)).DoubleClick();

                var PatientsDatagrid2 = _PatientSelectDialogWindow.Get<Table>(SearchCriteria.ByAutomationId("dgvPatients"));

                foreach (TableRow row in PatientsDatagrid2.Rows)
                {
                    if ((string)row.Cells[0].Value == (string)configHT[bed])  //"RW164"  "XTQ15(2360)") "CP116"
                    {
                        testRow = row;
                        found = true;
                        break;
                    }
                }
                if (found == true)
                    break;
            }

            //after click the row, the "Patient Select Dialog" disappear and may generate exception
            try
            {
                testRow.Click();
            }
            catch (Exception e)
            {
                Console.WriteLine("test case BedsideData exception" + e.Message.ToString());
            }

            //click Waveforms
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btn12Lead")).Click();
        }

        [TearDown]
        public void TearDown()
        {
            //_CAApp.Close();
            //_CAApp.Dispose();
        }

        //22746: CA 12-Lead - Compare two 12-Lead Reports
        [Test]
        public void CompareReports()
        {
            //prepare for the monitoring data
            Prepare("12leads");

            TestLog.WriteLog("Start CompareReports: 22746: CA 12-Lead - Compare two 12-Lead Reports");

            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnCmpSetup")).Click();
            Window TwelveLeadCompareSetupForm = _CAMainWindow.ModalWindow("Compare Setup");

            var ReportComboboxA = _CAMainWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("cboReportListA"));

            ReportComboboxA.Click();
            string reportA = ReportComboboxA.Items[0].Name;
            ReportComboboxA.Select(reportA);
            string reportB = "";
            var ReportComboboxB = _CAMainWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("cboReportListB"));
            ReportComboboxB.Click();
            if (ReportComboboxB.Items[0].Name == reportA)
            {
                ReportComboboxB.Select(ReportComboboxB.Items[1].Name);
                reportB = ReportComboboxB.Items[1].Name;
            }
            else
            {
                ReportComboboxB.Select(ReportComboboxB.Items[0].Name);
                reportB = ReportComboboxB.Items[0].Name;
            }

            //switch Compare button, the viewed report is also switched
            TwelveLeadCompareSetupForm.Get<Button>(SearchCriteria.ByAutomationId("btnOK")).Click();
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnCompare")).Click();
            string cboReportList1 = _CAMainWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("cboReportList")).SelectedItemText;
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnCompare")).Click();
            string cboReportList2 = _CAMainWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("cboReportList")).SelectedItemText;

            if (cboReportList1 == reportA)
            {
                Assert.IsTrue(cboReportList2 == reportB);
            }
            else
            {
                Assert.IsTrue((cboReportList1 == reportB) && (cboReportList2 == reportA));
            }

            TestLog.WriteLog("End CompareReports: 22746: CA 12-Lead - Compare two 12-Lead Reports");
        }

        //22747: CA 12-Lead - 12-Lead report saved to local machine 
        [Test]
        public void PrintReports()
        {
            //prepare for the monitoring data
            Prepare("12leads");

            TestLog.WriteLog("Start PrintReports: 22747: CA 12-Lead - 12-Lead report saved to local machine");

            _CAMainWindow.Get<Button>(SearchCriteria.ByAutomationId("btnPrinterSettings")).Click();
            Window PrintSettingWindow = _CAMainWindow.ModalWindow("Printer Settings");
            PrintSettingWindow.Get(SearchCriteria.ByText("Printer Select")).Click();
            PrintSettingWindow.Get<RadioButton>(SearchCriteria.ByAutomationId("btnPdfFile")).Click();
            PrintSettingWindow.Get<Button>(SearchCriteria.ByAutomationId("btnOk")).Click();

            _CAMainWindow.Get(SearchCriteria.ByText("Print")).Click();
            //wait for 5 sec for print job finished
            Thread.Sleep(5000);

            bool found = false;
            string[] files = Directory.GetFiles(@"C:\SLReports");
            foreach (string file in files)
            {
                if (file.Contains("TWELVELEAD"))
                {
                    // File name like "TWELVELEAD~FOR_10815_SD~~2016-09-23_08-57-55~2.pdf"
                    int pos = file.IndexOf("~~");
                    string subStr = file.Substring(pos + 2, 19);
                    string[] strArr = subStr.Split(new char[] { '-', '_' });
                    DateTime printTime = new DateTime(Convert.ToInt32(strArr[0]), Convert.ToInt32(strArr[1]), Convert.ToInt32(strArr[2]),
                        Convert.ToInt32(strArr[3]), Convert.ToInt32(strArr[4]), Convert.ToInt32(strArr[5]));
                    DateTime NowTime = DateTime.Now;
                    int SecDiff = (int)(NowTime - printTime).TotalSeconds;
                    //if find the recent file assumed from this test case
                    if (SecDiff < 10)
                    {
                        found = true;
                        File.Delete(file);
                    }
                }
            }
            Assert.IsTrue(found == true);

            TestLog.WriteLog("End PrintReports: 22747: CA 12-Lead - 12-Lead report saved to local machine");
        }

        //24566: Delete a 12-Lead report 
        [Test]
        public void DeleteReport()
        {
            //prepare for the monitoring data
            Prepare("12leads");

            TestLog.WriteLog("Start DeleteReport: 24566: Delete a 12-Lead report");

            ComboBox cboReportList = _CAMainWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("cboReportList"));
            cboReportList.Click();
            int num = cboReportList.Items.Count;
            //select the earlist item
            string earliestName = cboReportList.Items[num - 1].Name;
            cboReportList.Select(earliestName);

            _CAMainWindow.Get<Button>(SearchCriteria.ByAutomationId("btnDelete")).Click();
            Window PrintSettingWindow = _CAMainWindow.ModalWindow("Information");
            string warningMessage = PrintSettingWindow.Get<Label>(SearchCriteria.ByAutomationId("LblText")).Text;

            Assert.IsTrue(warningMessage == "Are you sure you want to delete the selected report?");

            PrintSettingWindow.Get<Button>(SearchCriteria.ByText("Yes")).Click();

            //the deleteded 12-Lead report is no longer listed in the drop down list.
            foreach (var item in cboReportList.Items)
            {
                Assert.IsFalse(item.Name == earliestName);
            }

            TestLog.WriteLog("End DeleteReport: 24566: Delete a 12-Lead report");
        }

        //24567: Edit 12-Lead report Interpretation text
        [Test]
        public void EditInterpretation()
        {
            //prepare for the monitoring data
            Prepare("12leads");

            TestLog.WriteLog("Start EditInterpretation: 24567: Edit 12-Lead report Interpretation text");

            _CAMainWindow.Get<Button>(SearchCriteria.ByAutomationId("btnEditInterpretation")).Click();

            Window EditInterpretationWindow = _CAMainWindow.ModalWindow("Edit Interpretation");
            var edit = EditInterpretationWindow.Get<TextBox>(SearchCriteria.ByAutomationId("tbMDInterpretation"));

            string OriginalText = edit.Text;
            string editedText = OriginalText + " test ";
            edit.Text = editedText;
            EditInterpretationWindow.Get<Button>(SearchCriteria.ByText("OK")).Click();

            //verify that the changed interpretation text
            var edited = _CAMainWindow.Get<TextBox>(SearchCriteria.ByAutomationId("tbInterpretation"));
            Assert.IsTrue(edited.Text == editedText);

            //change back to original interpretation text
            _CAMainWindow.Get<Button>(SearchCriteria.ByAutomationId("btnEditInterpretation")).Click();
            EditInterpretationWindow = _CAMainWindow.ModalWindow("Edit Interpretation");
            edit = EditInterpretationWindow.Get<TextBox>(SearchCriteria.ByAutomationId("tbMDInterpretation"));
            edit.Text = OriginalText;
            EditInterpretationWindow.Get<Button>(SearchCriteria.ByText("OK")).Click();

            TestLog.WriteLog("End EditInterpretation: 24567: Edit 12-Lead report Interpretation text");
        }

        //24585: Original Interpretation text can be viewed on a edited 12-Lead report
        [Test]
        public void ShowOriginalEdits()
        {
            //prepare for the monitoring data
            Prepare("12leads");

            TestLog.WriteLog("Start ShowOriginalEdits: 24585: Original Interpretation text can be viewed on a edited 12-Lead report");

            _CAMainWindow.Get<Button>(SearchCriteria.ByAutomationId("btnEditInterpretation")).Click();

            Window EditInterpretationWindow = _CAMainWindow.ModalWindow("Edit Interpretation");
            var edit = EditInterpretationWindow.Get<TextBox>(SearchCriteria.ByAutomationId("tbMDInterpretation")); //.ByControlType(ControlType.Edit)); 

            string OriginalText = edit.Text;
            string editedText = OriginalText + " test ";
            edit.Text = "";
            edit.Text = editedText;
            EditInterpretationWindow.Get<Button>(SearchCriteria.ByText("OK")).Click();
            var edited = _CAMainWindow.Get<TextBox>(SearchCriteria.ByAutomationId("tbInterpretation"));

            //check Show Original and Edits button
            _CAMainWindow.Get<Button>(SearchCriteria.ByAutomationId("btnShowInterpretation")).Click();
            Assert.IsTrue(edited.Text == OriginalText);
            _CAMainWindow.Get<Button>(SearchCriteria.ByAutomationId("btnShowInterpretation")).Click();
            Assert.IsTrue(edited.Text == editedText);

            //change to original
            _CAMainWindow.Get<Button>(SearchCriteria.ByAutomationId("btnEditInterpretation")).Click();
            EditInterpretationWindow = _CAMainWindow.ModalWindow("Edit Interpretation");
            edit = EditInterpretationWindow.Get<TextBox>(SearchCriteria.ByAutomationId("tbMDInterpretation"));
            edit.Text = OriginalText;
            EditInterpretationWindow.Get<Button>(SearchCriteria.ByText("OK")).Click();

            TestLog.WriteLog("End ShowOriginalEdits: 24585: Original Interpretation text can be viewed on a edited 12-Lead report");
        }

        //24622: Display the 12-Lead report
        [Test]
        public void DisplayReport()
        {
            //prepare for the monitoring data
            Prepare("12leads");

            TestLog.WriteLog("Start DisplayReport: 24622: Display the 12-Lead report");

            var ReportCombobox = _CAMainWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("cboReportList"));
            ReportCombobox.Click();
            Random random = new Random();
            int randomNumber = random.Next(0, ReportCombobox.Items.Count);
            string report = ReportCombobox.Items[randomNumber].Name;
            ReportCombobox.Select(report);

            string VentRateStr = _CAMainWindow.Get<Label>(SearchCriteria.ByAutomationId("lblVentrRate")).Text;
            int VentRate = Convert.ToInt32(VentRateStr);
            Assert.IsTrue((VentRate > 10) && (VentRate < 200));

            string PRIntervalStr = _CAMainWindow.Get<Label>(SearchCriteria.ByAutomationId("lblPRInterval")).Text;
            int PRInterval = Convert.ToInt32(PRIntervalStr);
            Assert.IsTrue(PRInterval > 0);

            string QTStr = _CAMainWindow.Get<Label>(SearchCriteria.ByAutomationId("lblQT")).Text;
            int QT = Convert.ToInt32(QTStr);
            Assert.IsTrue(QT > 0);

            string QTcStr = _CAMainWindow.Get<Label>(SearchCriteria.ByAutomationId("lblQTC")).Text;
            int QTc = Convert.ToInt32(QTcStr);
            Assert.IsTrue(QTc > 0);

            string QRSDurationStr = _CAMainWindow.Get<Label>(SearchCriteria.ByAutomationId("lblQRSDuration")).Text;
            int QRSDuration = Convert.ToInt32(QRSDurationStr);
            Assert.IsTrue(QRSDuration > 0);

            string PAxisStr = _CAMainWindow.Get<Label>(SearchCriteria.ByAutomationId("lblPAxis")).Text;
            int PAxis = Convert.ToInt32(PAxisStr);
            Assert.IsTrue((PAxis > -100) && (PAxis < 100));

            string QRSAxisStr = _CAMainWindow.Get<Label>(SearchCriteria.ByAutomationId("lblQRSAxis")).Text;
            int QRSAxis = Convert.ToInt32(QRSAxisStr);
            Assert.IsTrue((QRSAxis > -100) && (QRSAxis < 100));

            string TAxisStr = _CAMainWindow.Get<Label>(SearchCriteria.ByAutomationId("lblTAxis")).Text;
            int TAxis = Convert.ToInt32(TAxisStr);
            Assert.IsTrue((TAxis > -100) && (TAxis < 100));

            TestLog.WriteLog("End DisplayReport: 24622: Display the 12-Lead report");
        }
    }

    public class ArrhythmiaView
    {
        private static string CAExeFile;
        private static Application _CAApp;
        private static Window _CAMainWindow;
        Hashtable configHT;
        private static Dictionary<string, int> EventPriority = new Dictionary<string, int>
        {
            { "Pause", 1 },
            { "Undiagnosed Pause", 2 },
            { "Bradycardia", 12 },
            { "Tachycardia", 13 },
            { "Maximum Overall Rate", 19 },
            { "Minimum Overall Rate", 20 },
            { "Maximum Normal Rate", 21 },
            { "Minimum Normal Rate", 22 },
            { "Longest R-R", 23 },
            { "Shortest R-R", 24 },
            { "SVE Run", 9 },
            { "SVE Couplet", 10 },
            { "Isolated SVE", 11 },
            { "Ventricular Run", 3 },
            { "Undiagnosed Run", 4 },
            { "Ventricular Couplet", 5 },
            { "Ventricular Bigeminy", 6 },
            { "VentricularTrigeminy", 7 },
            { "Isolated VE", 8 },
            { "Shortest Coupling Interval", 25 },
            { "Atrial-paced Beats", 14 },
            { "Ventricular-paced Beats", 15 },
            { "Dual-paced Beats", 16 },
            { "Non-pacing Spikes", 17 },
            { "Undefined Spike", 18 },
            { "Paced Beat sequence", 28 },
            { "Ignored Region", 26 },
            { "Undiagnosed Sequence", 27 },
            { "Lead Changes", 29 }
        };

        [SetUp]
        protected void SetUp()
        {
            configHT = Config.ReadConfig();
            string CAAppPath = (string)configHT["ExePath"];
            string CAExeFile = CAAppPath + @"\ClinicalHistoryXP.exe";

            var psi = new ProcessStartInfo(CAExeFile);
            _CAApp = Application.AttachOrLaunch(psi);
            _CAMainWindow = _CAApp.GetWindow(SearchCriteria.ByAutomationId("ClinicalAccess"), InitializeOption.NoCache);
        }

        public void Prepare(string bed)
        {
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnSelectPatient")).Click();
            Window _PatientSelectDialogWindow = _CAMainWindow.ModalWindow("Patient Select Dialog");

            var PatientsTab = _PatientSelectDialogWindow.Get(SearchCriteria.ByText("Patients"));
            PatientsTab.Click();

            var comboBox = _PatientSelectDialogWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("cmbFacility"));
            comboBox.Select("Facility1");

            _PatientSelectDialogWindow.Get(SearchCriteria.ByText("Unit Row 0")).DoubleClick();
            var DataGridView_Table = _PatientSelectDialogWindow.Get<Table>(SearchCriteria.ByAutomationId("dgvUnits"));

            //to avoid timeout=5000 exception
            CoreAppXmlConfiguration.Instance.BusyTimeout = 50000;
            bool found = false;
            TableRow testRow = null;
            //go through the units to find the testing bed
            for (int i = 0; i < DataGridView_Table.Rows.Count; i++)
            {
                string pos = i.ToString();
                _PatientSelectDialogWindow.Get(SearchCriteria.ByText("Unit Row " + pos)).DoubleClick();

                var PatientsDatagrid2 = _PatientSelectDialogWindow.Get<Table>(SearchCriteria.ByAutomationId("dgvPatients"));

                foreach (TableRow row in PatientsDatagrid2.Rows)
                {
                    if ((string)row.Cells[0].Value == (string)configHT[bed])  //"RW164"  "XTQ15(2360)") "CP116"
                    {
                        testRow = row;
                        found = true;
                        break;
                    }
                }
                if (found == true)
                    break;
            }

            //after click the row, the "Patient Select Dialog" disappear and may generate exception
            try
            {
                testRow.Click();
            }
            catch (Exception e)
            {
                Console.WriteLine("test case BedsideData exception" + e.Message.ToString());
            }

            //click Waveforms
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnArrhythmiaReview")).Click();
        }

        [TearDown]
        public void TearDown()
        {
            //_CAApp.Close();
            //_CAApp.Dispose();
        }

        //24337: User can scroll through the different recorded event categories presented in thumbnail format
        //Also cover 24341
        [Test]
        public void ScrollThumbnail()
        {
            //prepare for the monitoring data
            Prepare("testbed");

            TestLog.WriteLog("Start ScrollThumbnail: 24337: User can scroll through the different recorded event categories presented in thumbnail format");

            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnAnalyze")).Click();
            Window SelectTimeWindow = _CAMainWindow.ModalWindow("Select Time");
            var DurationCombobox = SelectTimeWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("CboDuration"));
            DurationCombobox.Click();
            DurationCombobox.Select("Previous 12 Hours");
            SelectTimeWindow.Get(SearchCriteria.ByAutomationId("BtnOk")).Click();

            Thread.Sleep(5000);
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnRhythm")).Click();
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnThumbnails")).Click();
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnNext")).Click();
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnLast")).Click();
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnPrev")).Click();
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnFirst")).Click();

            TestLog.WriteLog("End ScrollThumbnail: 24337: User can scroll through the different recorded event categories presented in thumbnail format");
        }

        //24342: User can change the selection of event to view events under different event category, through Type combo box
        [Test]
        public void ChangeEventType()
        {
            //prepare for the monitoring data
            Prepare("testbed");

            TestLog.WriteLog("Start ChangeEventType: 24342: User can change the selection of event to view events under different event category, through Type combo box");

            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnAnalyze")).Click();
            Window SelectTimeWindow = _CAMainWindow.ModalWindow("Select Time");
            var DurationCombobox = SelectTimeWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("CboDuration"));
            DurationCombobox.Click();
            DurationCombobox.Select("Previous 12 Hours");
            SelectTimeWindow.Get(SearchCriteria.ByAutomationId("BtnOk")).Click();

            Thread.Sleep(10000);
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnRhythm")).Click();
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnThumbnails")).Click();

            var EventTypeCombobox = _CAMainWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("cboEventType"));
            EventTypeCombobox.Click();
            EventTypeCombobox.Select("Maximum Overall Rate");
            string CountStr = _CAMainWindow.Get<Label>(SearchCriteria.ByAutomationId("lblCount")).Text;
            int count = Convert.ToInt32(CountStr.Split(new char[] { ' ' })[2]);
            Assert.IsTrue(count > 0);
            //cover 24654
            Panel pnlThumbnails = _CAMainWindow.Get<Panel>(SearchCriteria.ByAutomationId("pnlThumbnails"));
            Panel panel1 = pnlThumbnails.Get<Panel>(SearchCriteria.ByControlType(ControlType.Pane).AndIndex(0));
            string panel1name = panel1.Get<Label>(SearchCriteria.ByControlType(ControlType.Text).AndIndex(0)).Text;
            Assert.IsTrue(panel1name.Contains("Maximum Overall Rate"));

            EventTypeCombobox.Select("Minimum Overall Rate");
            CountStr = _CAMainWindow.Get<Label>(SearchCriteria.ByAutomationId("lblCount")).Text;
            count = Convert.ToInt32(CountStr.Split(new char[] { ' ' })[2]);
            Assert.IsTrue(count > 0);

            EventTypeCombobox.Select("Maximum Normal Rate");
            CountStr = _CAMainWindow.Get<Label>(SearchCriteria.ByAutomationId("lblCount")).Text;
            count = Convert.ToInt32(CountStr.Split(new char[] { ' ' })[2]);
            Assert.IsTrue(count > 0);

            EventTypeCombobox.Select("Minimum Normal Rate");
            CountStr = _CAMainWindow.Get<Label>(SearchCriteria.ByAutomationId("lblCount")).Text;
            count = Convert.ToInt32(CountStr.Split(new char[] { ' ' })[2]);
            Assert.IsTrue(count > 0);

            EventTypeCombobox.Select("Longest R-R");
            CountStr = _CAMainWindow.Get<Label>(SearchCriteria.ByAutomationId("lblCount")).Text;
            count = Convert.ToInt32(CountStr.Split(new char[] { ' ' })[2]);
            Assert.IsTrue(count > 0);

            EventTypeCombobox.Select("Shortest R-R");
            CountStr = _CAMainWindow.Get<Label>(SearchCriteria.ByAutomationId("lblCount")).Text;
            count = Convert.ToInt32(CountStr.Split(new char[] { ' ' })[2]);
            Assert.IsTrue(count > 0);

            EventTypeCombobox.Select("Ignored Region");
            CountStr = _CAMainWindow.Get<Label>(SearchCriteria.ByAutomationId("lblCount")).Text;
            count = Convert.ToInt32(CountStr.Split(new char[] { ' ' })[2]);
            Assert.IsTrue(count > 0);

            TestLog.WriteLog("End ChangeEventType: 24342: User can change the selection of event to view events under different event category, through Type combo box");
        }

        //24343: Select All and Save functionality in Rhythm
        [Test]
        public void SaveinRhythm()
        {
            //prepare for the monitoring data
            Prepare("testbed");

            TestLog.WriteLog("Start SaveinRhythm: 24343: Select All and Save functionality in Rhythm");

            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnAnalyze")).Click();
            Window SelectTimeWindow = _CAMainWindow.ModalWindow("Select Time");
            var DurationCombobox = SelectTimeWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("CboDuration"));
            DurationCombobox.Click();
            DurationCombobox.Select("Previous 12 Hours");
            SelectTimeWindow.Get(SearchCriteria.ByAutomationId("BtnOk")).Click();

            //wait until finishing analysis
            Thread.Sleep(10000);
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnRhythm")).Click();
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnThumbnails")).Click();

            var EventTypeCombobox = _CAMainWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("cboEventType"));
            EventTypeCombobox.Click();
            EventTypeCombobox.Select("Maximum Overall Rate");
            string CountStr = _CAMainWindow.Get<Label>(SearchCriteria.ByAutomationId("lblCount")).Text;
            int count = Convert.ToInt32(CountStr.Split(new char[] { ' ' })[2]);

            //Save
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("selectAllCheck")).Click();
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnSave")).Click();

            Window SaveWindow2 = _CAMainWindow.ModalWindow("Save");
            while (SaveWindow2 != null)
            {
                SaveWindow2.Get(SearchCriteria.ByText("OK")).Click();
                try
                {
                    SaveWindow2 = _CAMainWindow.ModalWindow("Save");
                }
                catch (Exception e)
                {
                    break;
                }
            }

            //verify the saved events
            _CAMainWindow.Get(SearchCriteria.ByText("Saved Events")).Click();
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnThumbnails")).Click();
            string savedCountStr = _CAMainWindow.Get<Label>(SearchCriteria.ByAutomationId("lblCount")).Text;
            int Savedcount = Convert.ToInt32(savedCountStr.Split(new char[] { ' ' })[2]);

            //verify the saved count
            Assert.IsTrue(count <= Savedcount);

            //clean up  No delete button
            //_CAMainWindow.Get(SearchCriteria.ByAutomationId("selectAllCheck")).Click();
            //_CAMainWindow.Get(SearchCriteria.ByAutomationId("btnDelete")).Click();
            //Window InformationWindow = _CAMainWindow.ModalWindow("Information");
            //InformationWindow.Get(SearchCriteria.ByText("Yes")).Click();

            TestLog.WriteLog("End SaveinRhythm: 24343: Select All and Save functionality in Rhythm");
        }

        //24344: Select All and Print functionality in Rhythm
        [Test]
        public void PrintEventinRhythm()
        {
            //prepare for the monitoring data
            Prepare("testbed");

            TestLog.WriteLog("Start PrintEventinRhythm: 24344: Select All and Print functionality in Rhythm");

            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnAnalyze")).Click();
            Window SelectTimeWindow = _CAMainWindow.ModalWindow("Select Time");
            var DurationCombobox = SelectTimeWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("CboDuration"));
            DurationCombobox.Click();
            DurationCombobox.Select("Previous 12 Hours");
            SelectTimeWindow.Get(SearchCriteria.ByAutomationId("BtnOk")).Click();

            //wait until finishing analysis
            Thread.Sleep(10000);
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnRhythm")).Click();
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnThumbnails")).Click();

            var EventTypeCombobox = _CAMainWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("cboEventType"));
            EventTypeCombobox.Click();
            EventTypeCombobox.Select("Maximum Overall Rate");
            string CountStr = _CAMainWindow.Get<Label>(SearchCriteria.ByAutomationId("lblCount")).Text;
            int count = Convert.ToInt32(CountStr.Split(new char[] { ' ' })[2]);

            //Print
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("selectAllCheck")).Click();
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnPrint")).Click();
            Thread.Sleep(10000);

            bool found = false;
            string[] files = Directory.GetFiles(@"C:\SLReports");
            foreach (string file in files)
            {
                if (file.Contains("EVENTREPORT"))
                {
                    // File name like "PRIORITYEVENTREPORT~FOR_10815_SD~~2016-09-26_10-16-08~1.pdf"
                    int pos = file.IndexOf("~~");
                    string subStr = file.Substring(pos + 2, 19);
                    string[] strArr = subStr.Split(new char[] { '-', '_' });
                    DateTime printTime = new DateTime(Convert.ToInt32(strArr[0]), Convert.ToInt32(strArr[1]), Convert.ToInt32(strArr[2]),
                        Convert.ToInt32(strArr[3]), Convert.ToInt32(strArr[4]), Convert.ToInt32(strArr[5]));
                    DateTime NowTime = DateTime.Now;
                    int SecDiff = (int)(NowTime - printTime).TotalSeconds;
                    //if find the recent file assumed from this test case
                    if (SecDiff < 60)
                    {
                        found = true;
                        File.Delete(file);
                    }
                }
            }
            Assert.IsTrue(found == true);

            TestLog.WriteLog("End PrintEventinRhythm: 24344: Select All and Print functionality in Rhythm");
        }

        //24345: User can select or un-select waveforms of an event in Strip view
        //??? can't verify the displayed chart view
        [Test]
        public void SelectInStripView()
        {
            //prepare for the monitoring data
            Prepare("testbed");

            TestLog.WriteLog("Start SelectInStripView: 24345: User can select or un-select waveforms of an event in Strip view");

            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnAnalyze")).Click();
            Window SelectTimeWindow = _CAMainWindow.ModalWindow("Select Time");
            var DurationCombobox = SelectTimeWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("CboDuration"));
            DurationCombobox.Click();
            DurationCombobox.Select("Previous 12 Hours");
            SelectTimeWindow.Get(SearchCriteria.ByAutomationId("BtnOk")).Click();

            //wait until finishing analysis
            Thread.Sleep(10000);
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnRhythm")).Click();
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnThumbnails")).Click();

            var EventTypeCombobox = _CAMainWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("cboEventType"));
            EventTypeCombobox.Click();
            EventTypeCombobox.Select("Maximum Overall Rate");
            var EventListCombobox = _CAMainWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("cboEventList"));
            EventListCombobox.Click();
            EventListCombobox.Select(0);
            string CountStr = _CAMainWindow.Get<Label>(SearchCriteria.ByAutomationId("lblCount")).Text;
            int count = Convert.ToInt32(CountStr.Split(new char[] { ' ' })[2]);

            //Strip
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("selectAllCheck")).Click();
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnStrip")).Click();
            _CAMainWindow.Get(SearchCriteria.ByText("Settings")).Click();
            Window DisplaySettingsWindow = _CAMainWindow.ModalWindow("Display Settings");
            //Unselect the CheckBox at position 2
            CheckBox checkboxtest = (CheckBox)DisplaySettingsWindow.Get(SearchCriteria.ByControlType(ControlType.CheckBox).AndIndex(1));
            checkboxtest.UnSelect();
            DisplaySettingsWindow.Get<Button>(SearchCriteria.ByText("OK")).Click();

            TestLog.WriteLog("End SelectInStripView: 24345: User can select or un-select waveforms of an event in Strip view");
        }

        //24353: User can scroll available waveforms forward or backward when viewing event data in full size waveform format
        [Test]
        public void ScrollinStrip()
        {
            //prepare for the monitoring data
            Prepare("testbed");

            TestLog.WriteLog("Start ScrollinStrip: 24353: User can scroll available waveforms forward or backward when viewing event data in full size waveform format");

            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnAnalyze")).Click();
            Window SelectTimeWindow = _CAMainWindow.ModalWindow("Select Time");
            var DurationCombobox = SelectTimeWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("CboDuration"));
            DurationCombobox.Click();
            DurationCombobox.Select("Previous 12 Hours");
            SelectTimeWindow.Get(SearchCriteria.ByAutomationId("BtnOk")).Click();

            //wait until finishing analysis
            Thread.Sleep(10000);
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnRhythm")).Click();
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnThumbnails")).Click();

            var EventTypeCombobox = _CAMainWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("cboEventType"));
            EventTypeCombobox.Click();
            EventTypeCombobox.Select("Maximum Overall Rate");
            var EventListCombobox = _CAMainWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("cboEventList"));
            EventListCombobox.Click();
            EventListCombobox.Select(0);
            string CountStr = _CAMainWindow.Get<Label>(SearchCriteria.ByAutomationId("lblCount")).Text;
            int count = Convert.ToInt32(CountStr.Split(new char[] { ' ' })[2]);

            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnStrip")).Click();
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnNext")).Click();
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnLast")).Click();
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnPrev")).Click();
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnFirst")).Click();

            TestLog.WriteLog("End ScrollinStrip: 24353: User can scroll available waveforms forward or backward when viewing event data in full size waveform format");
        }

        //24354: Print an event in Strip view
        [Test]
        public void PrintEventInStrip()
        {
            //prepare for the monitoring data
            Prepare("testbed");

            TestLog.WriteLog("Start PrintEventinStrip: 24354: Print an event in Strip view");

            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnAnalyze")).Click();
            Window SelectTimeWindow = _CAMainWindow.ModalWindow("Select Time");
            var DurationCombobox = SelectTimeWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("CboDuration"));
            DurationCombobox.Click();
            DurationCombobox.Select("Previous 12 Hours");
            SelectTimeWindow.Get(SearchCriteria.ByAutomationId("BtnOk")).Click();

            //wait until finishing analysis
            Thread.Sleep(10000);
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnRhythm")).Click();
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnThumbnails")).Click();

            var EventTypeCombobox = _CAMainWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("cboEventType"));
            EventTypeCombobox.Click();
            EventTypeCombobox.Select("Maximum Overall Rate");
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("selectAllCheck")).Click();
            string CountStr = _CAMainWindow.Get<Label>(SearchCriteria.ByAutomationId("lblCount")).Text;
            int count = Convert.ToInt32(CountStr.Split(new char[] { ' ' })[2]);

            //Print in Strip
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnStrip")).Click();
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnPrint")).Click();
            Thread.Sleep(10000);

            bool foundFile = false;
            string[] files = Directory.GetFiles(@"C:\SLReports");
            foreach (string file in files)
            {
                if (file.Contains("EVENTREPORT"))
                {
                    // File name like "PRIORITYEVENTREPORT~FOR_10815_SD~~2016-09-26_10-16-08~1.pdf"
                    int pos = file.IndexOf("~~");
                    string subStr = file.Substring(pos + 2, 19);
                    string[] strArr = subStr.Split(new char[] { '-', '_' });
                    DateTime printTime = new DateTime(Convert.ToInt32(strArr[0]), Convert.ToInt32(strArr[1]), Convert.ToInt32(strArr[2]),
                        Convert.ToInt32(strArr[3]), Convert.ToInt32(strArr[4]), Convert.ToInt32(strArr[5]));
                    DateTime NowTime = DateTime.Now;
                    int SecDiff = (int)(NowTime - printTime).TotalSeconds;
                    //if find the recent file assumed from this test case
                    if (SecDiff < 20)
                    {
                        foundFile = true;
                        File.Delete(file);
                        break;
                    }
                }
            }
            Assert.IsTrue(foundFile);

            TestLog.WriteLog("End PrintEventinStrip: 24354: Print an event in Strip view");
        }

        //24356: View different event categories (Type combo box) in Histograms
        //include cases 24364 and 24365
        [Test]
        public void ViewHistograms()
        {
            //prepare for the monitoring data
            Prepare("testbed");

            TestLog.WriteLog("Start ViewHistograms: 24356: View different event categories (Type combo box) in Histograms");

            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnAnalyze")).Click();
            Window SelectTimeWindow = _CAMainWindow.ModalWindow("Select Time");
            var DurationCombobox = SelectTimeWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("CboDuration"));
            DurationCombobox.Click();
            DurationCombobox.Select("Previous 12 Hours");
            SelectTimeWindow.Get(SearchCriteria.ByAutomationId("BtnOk")).Click();

            //wait until finishing analysis
            Thread.Sleep(10000);
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnHistograms")).Click();

            //Choose different Histograms Type
            var HistogramTypesCombobox = _CAMainWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("cboHistogramTypes"));
            HistogramTypesCombobox.Click();
            HistogramTypesCombobox.Select("Overall Rate");
            HistogramTypesCombobox.Click();
            HistogramTypesCombobox.Select("Normal Rate");
            HistogramTypesCombobox.Click();
            HistogramTypesCombobox.Select("Ignored Region");

            //24364 Scroll through the data presented in Histograms
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("PageFw")).Click();
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("StepFw")).Click();
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("PageBw")).Click();
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("StepBw")).Click();

            // 24365 Changing duration of the histogram's time bar
            var TrendTypeCombobox = _CAMainWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("cboTrendType"));
            TrendTypeCombobox.Click();
            TrendTypeCombobox.Select("1 hour");
            TrendTypeCombobox.Click();
            TrendTypeCombobox.Select("24 hours");
            TrendTypeCombobox.Click();
            TrendTypeCombobox.Select("4 hours");
            TrendTypeCombobox.Click();
            TrendTypeCombobox.Select("8 hours");

            TestLog.WriteLog("End ViewHistograms: 24356: View different event categories (Type combo box) in Histograms");
        }

        //24366: rint an event's data in Histograms
        [Test]
        public void PrintHistograms()
        {
            //prepare for the monitoring data
            Prepare("testbed");

            TestLog.WriteLog("Start PrintHistograms: 24366: rint an event's data in Histograms");

            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnAnalyze")).Click();
            Window SelectTimeWindow = _CAMainWindow.ModalWindow("Select Time");
            var DurationCombobox = SelectTimeWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("CboDuration"));
            DurationCombobox.Click();
            DurationCombobox.Select("Previous 12 Hours");
            SelectTimeWindow.Get(SearchCriteria.ByAutomationId("BtnOk")).Click();

            //wait until finishing analysis
            Thread.Sleep(10000);
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnHistograms")).Click();
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnPrint")).Click();
            Thread.Sleep(5000);

            bool found = false;
            string[] files = Directory.GetFiles(@"C:\SLReports");
            foreach (string file in files)
            {
                if (file.Contains("HISTOGRAM"))
                {
                    // File name like "PRIORITYEVENTREPORT~FOR_10815_SD~~2016-09-26_10-16-08~1.pdf"
                    int pos = file.IndexOf("~~");
                    string subStr = file.Substring(pos + 2, 19);
                    string[] strArr = subStr.Split(new char[] { '-', '_' });
                    DateTime printTime = new DateTime(Convert.ToInt32(strArr[0]), Convert.ToInt32(strArr[1]), Convert.ToInt32(strArr[2]),
                        Convert.ToInt32(strArr[3]), Convert.ToInt32(strArr[4]), Convert.ToInt32(strArr[5]));
                    DateTime NowTime = DateTime.Now;
                    int SecDiff = (int)(NowTime - printTime).TotalSeconds;
                    //if find the recent file assumed from this test case
                    if (SecDiff < 10)
                    {
                        found = true;
                        File.Delete(file);
                    }
                }
            }
            Assert.IsTrue(found == true);

            TestLog.WriteLog("End PrintHistograms: 24366: rint an event's data in Histograms");
        }

        //24653: Recorded event categories presented in a sorted list, based on priority of event type
        [Test]
        public void EventTypeOrder()
        {
            //prepare for the monitoring data
            Prepare("testbed");

            TestLog.WriteLog("Start EventTypeOrder: 24653: Recorded event categories presented in a sorted list, based on priority of event type");

            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnAnalyze")).Click();
            Window SelectTimeWindow = _CAMainWindow.ModalWindow("Select Time");
            var DurationCombobox = SelectTimeWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("CboDuration"));
            DurationCombobox.Click();
            DurationCombobox.Select("Previous 2 Hours");
            SelectTimeWindow.Get(SearchCriteria.ByAutomationId("BtnOk")).Click();

            //wait until finishing analysis
            Thread.Sleep(10000);
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnRhythm")).Click();
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnStrip")).Click();

            var EventTypeCombobox = _CAMainWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("cboEventType"));
            int order = 0;
            Assert.IsTrue(EventPriority[EventTypeCombobox.Items[0].Name.Trim()] > order);
            order = EventPriority[EventTypeCombobox.Items[0].Name.Trim()];
            Assert.IsTrue(EventPriority[EventTypeCombobox.Items[1].Name.Trim()] > order);
            order = EventPriority[EventTypeCombobox.Items[1].Name.Trim()];
            Assert.IsTrue(EventPriority[EventTypeCombobox.Items[2].Name.Trim()] > order);
            order = EventPriority[EventTypeCombobox.Items[2].Name.Trim()];
            Assert.IsTrue(EventPriority[EventTypeCombobox.Items[3].Name.Trim()] > order);
            order = EventPriority[EventTypeCombobox.Items[3].Name.Trim()];
            Assert.IsTrue(EventPriority[EventTypeCombobox.Items[4].Name.Trim()] > order);
            order = EventPriority[EventTypeCombobox.Items[4].Name.Trim()];
            Assert.IsTrue(EventPriority[EventTypeCombobox.Items[5].Name.Trim()] > order);
            order = EventPriority[EventTypeCombobox.Items[5].Name.Trim()];
            Assert.IsTrue(EventPriority[EventTypeCombobox.Items[6].Name.Trim()] > order);
            order = EventPriority[EventTypeCombobox.Items[6].Name.Trim()];

            //cover 24659
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnRhythm")).Click();
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnThumbnails")).Click();
            EventTypeCombobox = _CAMainWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("cboEventType"));
            order = 0;
            Assert.IsTrue(EventPriority[EventTypeCombobox.Items[0].Name.Trim()] > order);
            order = EventPriority[EventTypeCombobox.Items[0].Name.Trim()];
            Assert.IsTrue(EventPriority[EventTypeCombobox.Items[1].Name.Trim()] > order);
            order = EventPriority[EventTypeCombobox.Items[1].Name.Trim()];
            Assert.IsTrue(EventPriority[EventTypeCombobox.Items[2].Name.Trim()] > order);
            order = EventPriority[EventTypeCombobox.Items[2].Name.Trim()];
            Assert.IsTrue(EventPriority[EventTypeCombobox.Items[3].Name.Trim()] > order);
            order = EventPriority[EventTypeCombobox.Items[3].Name.Trim()];
            Assert.IsTrue(EventPriority[EventTypeCombobox.Items[4].Name.Trim()] > order);
            order = EventPriority[EventTypeCombobox.Items[4].Name.Trim()];
            Assert.IsTrue(EventPriority[EventTypeCombobox.Items[5].Name.Trim()] > order);
            order = EventPriority[EventTypeCombobox.Items[5].Name.Trim()];
            Assert.IsTrue(EventPriority[EventTypeCombobox.Items[6].Name.Trim()] > order);
            order = EventPriority[EventTypeCombobox.Items[6].Name.Trim()];


            TestLog.WriteLog("End EventTypeOrder: 24653: Recorded event categories presented in a sorted list, based on priority of event type");
        }

        //24660: After analysis,event categories displayed with event category name, date and time
        [Test]
        public void EventTypeFormat()
        {
            //prepare for the monitoring data
            Prepare("testbed");

            TestLog.WriteLog("Start EventTypeFormat: 24660: After analysis,event categories displayed with event category name, date and time");

            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnAnalyze")).Click();
            Window SelectTimeWindow = _CAMainWindow.ModalWindow("Select Time");
            var DurationCombobox = SelectTimeWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("CboDuration"));
            DurationCombobox.Click();
            DurationCombobox.Select("Previous 2 Hours");
            SelectTimeWindow.Get(SearchCriteria.ByAutomationId("BtnOk")).Click();

            //wait until finishing analysis
            Thread.Sleep(10000);
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnHome")).Click();

            var EventTypeCombobox = _CAMainWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("cboEventType"));
            //match "9/25 11:30:11pm - Maximum Overall Rate";
            string eventtype1 = EventTypeCombobox.Items[0].Name;
            string[] strArr = eventtype1.Split(new char[] { '-' });
            Assert.IsTrue(EventPriority.Keys.Contains(strArr[1].Trim()));
            Regex regExp = new Regex(@"(([1-9])|(1[0-2]))\/((0[1-9])|(1[0-9])|(2[0-9])|(3[0-1]))\s[0-9]{1,2}:[0-9]{1,2}:[0-9]{1,2}[a|p]m");
            bool match = regExp.IsMatch(strArr[0]);
            Assert.IsTrue(match);

            TestLog.WriteLog("End EventTypeFormat: 24660: After analysis,event categories displayed with event category name, date and time");
        }

        //24662: The user can apply QRS calipers on the ECG waveforms of an event.
        //Cover case 24663: Each caliper measurement will also display the measurement unit for that particular caliper.
        [Test]
        public void Calipers_QRS()
        {
            //prepare for the monitoring data
            Prepare("testbed");

            TestLog.WriteLog("Start Calipers_QRS: 24662: The user can apply QRS calipers on the ECG waveforms of an event.");

            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnAnalyze")).Click();
            Window SelectTimeWindow = _CAMainWindow.ModalWindow("Select Time");
            var DurationCombobox = SelectTimeWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("CboDuration"));
            DurationCombobox.Click();
            DurationCombobox.Select("Previous 2 Hours");
            SelectTimeWindow.Get(SearchCriteria.ByAutomationId("BtnOk")).Click();

            //wait until finishing analysis
            Thread.Sleep(10000);
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnRhythm")).Click();
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnStrip")).Click();

            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnCalipers")).DoubleClick();
            Panel CaliperPanel = _CAMainWindow.Get<Panel>(SearchCriteria.ByAutomationId("CaliperPanel"));
            Panel FullSizeWaveformContainer = _CAMainWindow.Get<Panel>(SearchCriteria.ByAutomationId("FullSizeWaveformContainer"));
            Panel wave1 = FullSizeWaveformContainer.Get<Panel>(SearchCriteria.ByAutomationId("WaveControl.0"));
            Panel scale1 = FullSizeWaveformContainer.Get<Panel>(SearchCriteria.ByAutomationId("ScaleControl.0"));
            string type1_1 = scale1.Get<Label>(SearchCriteria.ByAutomationId("Label.0")).Text;
            string type1_2 = scale1.Get<Label>(SearchCriteria.ByAutomationId("Label.1")).Text;
            Panel wave2 = FullSizeWaveformContainer.Get<Panel>(SearchCriteria.ByAutomationId("WaveControl.1"));
            Panel scale2 = FullSizeWaveformContainer.Get<Panel>(SearchCriteria.ByAutomationId("ScaleControl.1"));
            string type2_1 = scale2.Get<Label>(SearchCriteria.ByAutomationId("Label.0")).Text;
            string type2_2 = scale2.Get<Label>(SearchCriteria.ByAutomationId("Label.1")).Text;
            //Click on Rate button in ECG panel
            RadioButton QRS = CaliperPanel.Get<RadioButton>(SearchCriteria.ByText("QRS"));
            if (type1_1.Contains("ECG") || type1_2.Contains("ECG"))
            {
                QRS.Click();
                Point point1 = wave1.ClickablePoint;
                Mouse.Instance.Click(point1);
                Mouse.LeftDown();
                Mouse.Instance.Location = new Point(point1.X + 10, point1.Y);
                Mouse.LeftUp();
                Mouse.Instance.Click(point1);
                string unitText = wave1.Get<Label>(SearchCriteria.ByControlType(ControlType.Text)).Text;
                // 24663 
                Regex regex = new Regex(@"^QRS\s[-+]?[0-9](\.[0-9]{1}[0-9]*)?\ssec$");
                Assert.IsTrue(regex.IsMatch(unitText));
            }
            else
            {
                TestLog.WriteLog("Calipers_QRS: 24662: No ECG panel to click on");
                Assert.IsTrue(false);
            }

            //click QRS on a non-ECG panel
            QRS.Click();
            if (!type2_1.Contains("ECG") || !type2_2.Contains("ECG"))
            {
                QRS.Click();
                Point point2 = wave2.ClickablePoint;
                Mouse.Instance.Click(point2);
                Mouse.LeftDown();
                Mouse.Instance.Location = new Point(point2.X + 10, point2.Y);
                Mouse.LeftUp();
                Mouse.Instance.Click(point2);
                Window InformationWindow = _CAMainWindow.ModalWindow("Information");
                string information = InformationWindow.Get<Label>(SearchCriteria.ByAutomationId("LblText")).Text;
                Assert.IsTrue(information == "Cannot create calipers of this type on a non-ECG waveform.");
                InformationWindow.Get<Button>(SearchCriteria.ByText("OK")).Click();
            }

            TestLog.WriteLog("End Calipers_QRS: 24662: The user can apply QRS calipers on the ECG waveforms of an event.");
        }

        //24664: The user can apply Rate calipers on the ECG waveforms in an event.
        [Test]
        public void Calipers_RT()
        {
            //prepare for the monitoring data
            Prepare("testbed");

            TestLog.WriteLog("Start Calipers_RT: 24664: The user can apply Rate calipers on the ECG waveforms in an event.");

            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnAnalyze")).Click();
            Window SelectTimeWindow = _CAMainWindow.ModalWindow("Select Time");
            var DurationCombobox = SelectTimeWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("CboDuration"));
            DurationCombobox.Click();
            DurationCombobox.Select("Previous 2 Hours");
            SelectTimeWindow.Get(SearchCriteria.ByAutomationId("BtnOk")).Click();

            //wait until finishing analysis
            Thread.Sleep(10000);
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnRhythm")).Click();
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnStrip")).Click();

            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnCalipers")).DoubleClick();
            Panel CaliperPanel = _CAMainWindow.Get<Panel>(SearchCriteria.ByAutomationId("CaliperPanel"));
            Panel FullSizeWaveformContainer = _CAMainWindow.Get<Panel>(SearchCriteria.ByAutomationId("FullSizeWaveformContainer"));
            Panel wave1 = FullSizeWaveformContainer.Get<Panel>(SearchCriteria.ByAutomationId("WaveControl.0"));
            Panel scale1 = FullSizeWaveformContainer.Get<Panel>(SearchCriteria.ByAutomationId("ScaleControl.0"));
            string type1_1 = scale1.Get<Label>(SearchCriteria.ByAutomationId("Label.0")).Text;
            string type1_2 = scale1.Get<Label>(SearchCriteria.ByAutomationId("Label.1")).Text;
            Panel wave2 = FullSizeWaveformContainer.Get<Panel>(SearchCriteria.ByAutomationId("WaveControl.1"));
            Panel scale2 = FullSizeWaveformContainer.Get<Panel>(SearchCriteria.ByAutomationId("ScaleControl.1"));
            string type2_1 = scale2.Get<Label>(SearchCriteria.ByAutomationId("Label.0")).Text;
            string type2_2 = scale2.Get<Label>(SearchCriteria.ByAutomationId("Label.1")).Text;
            //Click on Rate button in ECG panel
            RadioButton RT = CaliperPanel.Get<RadioButton>(SearchCriteria.ByText("Rate"));
            if (type1_1.Contains("ECG") || type1_2.Contains("ECG"))
            {
                RT.Click();
                Point point1 = wave1.ClickablePoint;
                Mouse.Instance.Click(point1);
                Mouse.LeftDown();
                Mouse.Instance.Location = new Point(point1.X + 10, point1.Y);
                Mouse.LeftUp();
                Mouse.Instance.Click(point1);
                string unitText = wave1.Get<Label>(SearchCriteria.ByControlType(ControlType.Text)).Text;
                Assert.IsTrue(unitText.Contains("Rate"));
            }
            else
            {
                TestLog.WriteLog("Calipers_QRS: 24662: No ECG panel to click on");
                Assert.IsTrue(false);
            }
            RT.Click();
            //click on non ECG panel
            if (!type2_1.Contains("ECG") || !type2_2.Contains("ECG"))
            {
                RT.Click();
                Point point2 = wave2.ClickablePoint;
                Mouse.Instance.Click(point2);
                Mouse.LeftDown();
                Mouse.Instance.Location = new Point(point2.X + 10, point2.Y);
                Mouse.LeftUp();
                Mouse.Instance.Click(point2);
                Window InformationWindow = _CAMainWindow.ModalWindow("Information");
                string information = InformationWindow.Get<Label>(SearchCriteria.ByAutomationId("LblText")).Text;
                Assert.IsTrue(information == "Cannot create calipers of this type on a non-ECG waveform.");
                InformationWindow.Get<Button>(SearchCriteria.ByText("OK")).Click();
            }

            TestLog.WriteLog("End Calipers_RT: 24664: The user can apply Rate calipers on the ECG waveforms in an event.");
        }
    }

    public class TrendsView
    {
        private static string CAExeFile;
        private static Application _CAApp;
        private static Window _CAMainWindow;
        Hashtable configHT;


        [SetUp]
        protected void SetUp()
        {
            configHT = Config.ReadConfig();
            string CAAppPath = (string)configHT["ExePath"];
            string CAExeFile = CAAppPath + @"\ClinicalHistoryXP.exe";

            var psi = new ProcessStartInfo(CAExeFile);
            _CAApp = Application.AttachOrLaunch(psi);
            _CAMainWindow = _CAApp.GetWindow(SearchCriteria.ByAutomationId("ClinicalAccess"), InitializeOption.NoCache);
        }

        public void Prepare(string bed)
        {
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnSelectPatient")).Click();
            Window _PatientSelectDialogWindow = _CAMainWindow.ModalWindow("Patient Select Dialog");

            var PatientsTab = _PatientSelectDialogWindow.Get(SearchCriteria.ByText("Patients"));
            PatientsTab.Click();

            var comboBox = _PatientSelectDialogWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("cmbFacility"));
            comboBox.Select("Facility1");

            _PatientSelectDialogWindow.Get(SearchCriteria.ByText("Unit Row 0")).DoubleClick();
            var DataGridView_Table = _PatientSelectDialogWindow.Get<Table>(SearchCriteria.ByAutomationId("dgvUnits"));

            //to avoid timeout=5000 exception
            CoreAppXmlConfiguration.Instance.BusyTimeout = 50000;
            bool found = false;
            TableRow testRow = null;
            //go through the units to find the testing bed
            for (int i = 0; i < DataGridView_Table.Rows.Count; i++)
            {
                string pos = i.ToString();
                _PatientSelectDialogWindow.Get(SearchCriteria.ByText("Unit Row " + pos)).DoubleClick();

                var PatientsDatagrid2 = _PatientSelectDialogWindow.Get<Table>(SearchCriteria.ByAutomationId("dgvPatients"));

                foreach (TableRow row in PatientsDatagrid2.Rows)
                {
                    if ((string)row.Cells[0].Value == (string)configHT[bed])  //"RW164"  "XTQ15(2360)") "CP116"
                    {
                        testRow = row;
                        found = true;
                        break;
                    }
                }
                if (found == true)
                    break;
            }

            //after click the row, the "Patient Select Dialog" disappear and may generate exception
            try
            {
                testRow.Click();
            }
            catch (Exception e)
            {
                Console.WriteLine("test case BedsideData exception" + e.Message.ToString());
            }

            //click Waveforms
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnTrends")).Click();
        }

        [TearDown]
        public void TearDown()
        {
            //_CAApp.Close();
            //_CAApp.Dispose();
        }

        //21872: Trends View defaults
        [Test]
        public void DefaultView()
        {

            TestLog.WriteLog("Start DefaultView: 21872: Trends View defaults");

            //prepare for the monitoring data
            Prepare("SLMBed");

            Assert.IsTrue(_CAMainWindow.Get<CheckBox>(SearchCriteria.ByText("Tabular")).Checked);
            Assert.IsTrue(_CAMainWindow.Get<CheckBox>(SearchCriteria.ByText("Vitals")).Checked);
            Assert.IsFalse(_CAMainWindow.Get<CheckBox>(SearchCriteria.ByAutomationId("autoRefreshChk")).Checked);

            var viewCombobox = _CAMainWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("layoutCombo"));
            Assert.IsTrue(viewCombobox.SelectedItemText == "Adult");
            var trendDurationCombobox = _CAMainWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("trendDurationCombo"));
            Assert.IsTrue(trendDurationCombobox.SelectedItemText == "4 hours");
            var trendResolutionCombobox = _CAMainWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("trendResolutionCombo"));
            Assert.IsTrue(trendResolutionCombobox.SelectedItemText == "15 minutes");

            TestLog.WriteLog("End DefaultView: 21872: Trends View defaults");
        }

        //21873: Graphical trend with a fixed scale.
        //23655 Tabular remove graph
        //[Test]
        //public void CreateGraphicalTrend()
        //{
        //    //prepare for the monitoring data
        //    Prepare("testbed");

        //    TestLog.WriteLog("Start CreateGraphicalTrend: 21873: Graphical trend with a fixed scale.");

        //    _CAMainWindow.Get<Button>(SearchCriteria.ByAutomationId("settingsBtn")).Click();
        //    _CAMainWindow.Get(SearchCriteria.ByText("Graphs")).Click();

        //    _CAMainWindow.Get(SearchCriteria.ByAutomationId("graphNewGraphBtn")).Click();
        //    Window AddNewGraghWindow = _CAMainWindow.ModalWindow(SearchCriteria.ByAutomationId("RenameForm"));
        //    var edit = AddNewGraghWindow.Get<TextBox>(SearchCriteria.ByAutomationId("newNameText")); //SearchCriteria.ByControlType(ControlType.Edit));
        //    edit.Text = "DEF Graph1";
        //    AddNewGraghWindow.Get<Button>(SearchCriteria.ByText("OK")).Click();

        //    _CAMainWindow.Get<Button>(SearchCriteria.ByAutomationId("graphAddParamsBtn")).Click();
        //    Window TrendCategoriesandParametersWindow = _CAMainWindow.ModalWindow("Trend Categories and Parameters");
        //    //no automatioon for the button, only by checkbox
        //    var checkbox = TrendCategoriesandParametersWindow.Get<CheckBox>(SearchCriteria.ByControlType(ControlType.CheckBox).AndIndex(0)); //.AndIndex(0)
        //    checkbox.Click();
        //    //unselect top two 
        //    TrendCategoriesandParametersWindow.Get<CheckBox>(SearchCriteria.ByControlType(ControlType.CheckBox).AndIndex(1)).Click();
        //    TrendCategoriesandParametersWindow.Get<CheckBox>(SearchCriteria.ByControlType(ControlType.CheckBox).AndIndex(2)).Click();
        //    TrendCategoriesandParametersWindow.Get<Button>(SearchCriteria.ByText("OK")).Click();

        //    //verify the "GraphTrendControl"
        //    Panel GraphTrendControl = _CAMainWindow.Get<Panel>(SearchCriteria.ByAutomationId("GraphTrendControl").AndIndex(1));
        //    string str1 = GraphTrendControl.Get<Label>(SearchCriteria.ByControlType(ControlType.Text).AndIndex(1)).Text;
        //    Assert.IsTrue(str1 == "RR, br/min");
        //    string str2 = GraphTrendControl.Get<Label>(SearchCriteria.ByControlType(ControlType.Text).AndIndex(2)).Text;
        //    Assert.IsTrue(str2 == "ST Primary, mm");
        //    string str3 = GraphTrendControl.Get<Label>(SearchCriteria.ByControlType(ControlType.Text).AndIndex(3)).Text;
        //    Assert.IsTrue(str3 == "ST Secondary, mm");

        //    //clean up newly created Graph
        //    GraphTrendControl.Click();
        //    _CAMainWindow.Get(SearchCriteria.ByAutomationId("graphRemoveGraphBtn")).Click();
        //    Window RemoveGraghWindow = _CAMainWindow.ModalWindow(SearchCriteria.ByAutomationId("MessageBoxForm"));
        //    RemoveGraghWindow.Get<Button>(SearchCriteria.ByText("Yes")).Click();

        //    TestLog.WriteLog("End CreateGraphicalTrend: 21873: Graphical trend with a fixed scale.");
        //}

        //21875: Tabular trend Duration and Interval options
        [Test]
        public void DurationIntervalOptions()
        {
            //prepare for the monitoring data
            Prepare("testbed");

            TestLog.WriteLog("Start DurationIntervalOptions: 21875: Tabular trend Duration and Interval options");

            var ResolutionCombobox = _CAMainWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("trendResolutionCombo"));
            var DurationCombobox = _CAMainWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("trendDurationCombo"));

            //When set to 1 minute Interval, only 15,30 minute and 1, and 2 hour Duration is accepted.
            ResolutionCombobox.Click();
            ResolutionCombobox.Select("1 minute");
            DurationCombobox.Click();
            DurationCombobox.Select("15 minutes");
            Assert.IsTrue(DurationCombobox.SelectedItemText == "15 minutes");
            DurationCombobox.Select("30 minutes");
            Assert.IsTrue(DurationCombobox.SelectedItemText == "30 minutes");
            DurationCombobox.Select("1 hour");
            Assert.IsTrue(DurationCombobox.SelectedItemText == "1 hour");
            DurationCombobox.Select("2 hours");
            Assert.IsTrue(DurationCombobox.SelectedItemText == "2 hours");
            DurationCombobox.Select("4 hours");
            Assert.IsTrue(DurationCombobox.SelectedItemText == "2 hours");
            DurationCombobox.Select("8 hours");
            Assert.IsTrue(DurationCombobox.SelectedItemText == "2 hours");
            DurationCombobox.Select("12 hours");
            Assert.IsTrue(DurationCombobox.SelectedItemText == "2 hours");
            DurationCombobox.Select("24 hours");
            Assert.IsTrue(DurationCombobox.SelectedItemText == "2 hours");

            //When set to 5 minutes Interval, only 15,30 minute and 1,2,4, and 8 hours Duration is accepted.
            ResolutionCombobox.Select("5 minutes");
            DurationCombobox.Select("15 minutes");
            Assert.IsTrue(DurationCombobox.SelectedItemText == "15 minutes");
            DurationCombobox.Select("30 minutes");
            Assert.IsTrue(DurationCombobox.SelectedItemText == "30 minutes");
            DurationCombobox.Select("1 hour");
            Assert.IsTrue(DurationCombobox.SelectedItemText == "1 hour");
            DurationCombobox.Select("2 hours");
            Assert.IsTrue(DurationCombobox.SelectedItemText == "2 hours");
            DurationCombobox.Select("4 hours");
            Assert.IsTrue(DurationCombobox.SelectedItemText == "4 hours");
            DurationCombobox.Select("8 hours");
            Assert.IsTrue(DurationCombobox.SelectedItemText == "8 hours");
            DurationCombobox.Select("12 hours");
            Assert.IsTrue(DurationCombobox.SelectedItemText == "8 hours");
            DurationCombobox.Select("24 hours");
            Assert.IsTrue(DurationCombobox.SelectedItemText == "8 hours");

            //When set to 10 minutes Interval, only 15,30 minute and 1,2,4,8 and 12 hours Duration is accepted.
            ResolutionCombobox.Select("10 minutes");
            DurationCombobox.Select("15 minutes");
            Assert.IsTrue(DurationCombobox.SelectedItemText == "15 minutes");
            DurationCombobox.Select("30 minutes");
            Assert.IsTrue(DurationCombobox.SelectedItemText == "30 minutes");
            DurationCombobox.Select("1 hour");
            Assert.IsTrue(DurationCombobox.SelectedItemText == "1 hour");
            DurationCombobox.Select("2 hours");
            Assert.IsTrue(DurationCombobox.SelectedItemText == "2 hours");
            DurationCombobox.Select("4 hours");
            Assert.IsTrue(DurationCombobox.SelectedItemText == "4 hours");
            DurationCombobox.Select("8 hours");
            Assert.IsTrue(DurationCombobox.SelectedItemText == "8 hours");
            DurationCombobox.Select("12 hours");
            Assert.IsTrue(DurationCombobox.SelectedItemText == "12 hours");
            DurationCombobox.Select("24 hours");
            Assert.IsTrue(DurationCombobox.SelectedItemText == "12 hours");

            //When set to 15 minutes Interval,all Duration settings are accepted.
            ResolutionCombobox.Select("15 minutes");
            DurationCombobox.Select("15 minutes");
            Assert.IsTrue(DurationCombobox.SelectedItemText == "15 minutes");
            DurationCombobox.Select("30 minutes");
            Assert.IsTrue(DurationCombobox.SelectedItemText == "30 minutes");
            DurationCombobox.Select("1 hour");
            Assert.IsTrue(DurationCombobox.SelectedItemText == "1 hour");
            DurationCombobox.Select("2 hours");
            Assert.IsTrue(DurationCombobox.SelectedItemText == "2 hours");
            DurationCombobox.Select("4 hours");
            Assert.IsTrue(DurationCombobox.SelectedItemText == "4 hours");
            DurationCombobox.Select("8 hours");
            Assert.IsTrue(DurationCombobox.SelectedItemText == "8 hours");
            DurationCombobox.Select("12 hours");
            Assert.IsTrue(DurationCombobox.SelectedItemText == "12 hours");
            DurationCombobox.Select("24 hours");
            Assert.IsTrue(DurationCombobox.SelectedItemText == "24 hours");

            //When set to 30 minutes Interval,all Duration settings are accepted.
            ResolutionCombobox.Select("30 minutes");
            DurationCombobox.Select("15 minutes");
            Assert.IsTrue(DurationCombobox.SelectedItemText == "15 minutes");
            DurationCombobox.Select("30 minutes");
            Assert.IsTrue(DurationCombobox.SelectedItemText == "30 minutes");
            DurationCombobox.Select("1 hour");
            Assert.IsTrue(DurationCombobox.SelectedItemText == "1 hour");
            DurationCombobox.Select("2 hours");
            Assert.IsTrue(DurationCombobox.SelectedItemText == "2 hours");
            DurationCombobox.Select("4 hours");
            Assert.IsTrue(DurationCombobox.SelectedItemText == "4 hours");
            DurationCombobox.Select("8 hours");
            Assert.IsTrue(DurationCombobox.SelectedItemText == "8 hours");
            DurationCombobox.Select("12 hours");
            Assert.IsTrue(DurationCombobox.SelectedItemText == "12 hours");
            DurationCombobox.Select("24 hours");
            Assert.IsTrue(DurationCombobox.SelectedItemText == "24 hours");

            //When set to 60 minutes Interval,all Duration settings are accepted.
            ResolutionCombobox.Select("60 minutes");
            DurationCombobox.Select("15 minutes");
            Assert.IsTrue(DurationCombobox.SelectedItemText == "15 minutes");
            DurationCombobox.Select("30 minutes");
            Assert.IsTrue(DurationCombobox.SelectedItemText == "30 minutes");
            DurationCombobox.Select("1 hour");
            Assert.IsTrue(DurationCombobox.SelectedItemText == "1 hour");
            DurationCombobox.Select("2 hours");
            Assert.IsTrue(DurationCombobox.SelectedItemText == "2 hours");
            DurationCombobox.Select("4 hours");
            Assert.IsTrue(DurationCombobox.SelectedItemText == "4 hours");
            DurationCombobox.Select("8 hours");
            Assert.IsTrue(DurationCombobox.SelectedItemText == "8 hours");
            DurationCombobox.Select("12 hours");
            Assert.IsTrue(DurationCombobox.SelectedItemText == "12 hours");
            DurationCombobox.Select("24 hours");
            Assert.IsTrue(DurationCombobox.SelectedItemText == "24 hours");

            //When set to 2 hours Interval,all Duration settings are accepted.
            ResolutionCombobox.Select("2 hours");
            DurationCombobox.Select("15 minutes");
            Assert.IsTrue(DurationCombobox.SelectedItemText == "15 minutes");
            DurationCombobox.Select("30 minutes");
            Assert.IsTrue(DurationCombobox.SelectedItemText == "30 minutes");
            DurationCombobox.Select("1 hour");
            Assert.IsTrue(DurationCombobox.SelectedItemText == "1 hour");
            DurationCombobox.Select("2 hours");
            Assert.IsTrue(DurationCombobox.SelectedItemText == "2 hours");
            DurationCombobox.Select("4 hours");
            Assert.IsTrue(DurationCombobox.SelectedItemText == "4 hours");
            DurationCombobox.Select("8 hours");
            Assert.IsTrue(DurationCombobox.SelectedItemText == "8 hours");
            DurationCombobox.Select("12 hours");
            Assert.IsTrue(DurationCombobox.SelectedItemText == "12 hours");
            DurationCombobox.Select("24 hours");
            Assert.IsTrue(DurationCombobox.SelectedItemText == "24 hours");

            //When set to 4 hours Interval,all Duration settings are accepted.
            ResolutionCombobox.Select("4 hours");
            DurationCombobox.Select("15 minutes");
            Assert.IsTrue(DurationCombobox.SelectedItemText == "15 minutes");
            DurationCombobox.Select("30 minutes");
            Assert.IsTrue(DurationCombobox.SelectedItemText == "30 minutes");
            DurationCombobox.Select("1 hour");
            Assert.IsTrue(DurationCombobox.SelectedItemText == "1 hour");
            DurationCombobox.Select("2 hours");
            Assert.IsTrue(DurationCombobox.SelectedItemText == "2 hours");
            DurationCombobox.Select("4 hours");
            Assert.IsTrue(DurationCombobox.SelectedItemText == "4 hours");
            DurationCombobox.Select("8 hours");
            Assert.IsTrue(DurationCombobox.SelectedItemText == "8 hours");
            DurationCombobox.Select("12 hours");
            Assert.IsTrue(DurationCombobox.SelectedItemText == "12 hours");
            DurationCombobox.Select("24 hours");
            Assert.IsTrue(DurationCombobox.SelectedItemText == "24 hours");

            TestLog.WriteLog("End DurationIntervalOptions: 21875: Tabular trend Duration and Interval options");
        }

        //??? 23525: Timeline synchronization between Waveform views and Trends 
        [Test]
        public void TimelineSync()
        {
            //prepare for the monitoring data
            Prepare("testbed");

            TestLog.WriteLog("Start TimelineSync: 23525: Timeline synchronization between Waveform views and Trends");

            _CAMainWindow.Get(SearchCriteria.ByText("Waveforms")).Click();
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnCompressed")).Click();

            Panel WaveformReviewPanel = _CAMainWindow.Get<Panel>(SearchCriteria.ByAutomationId("WaveformReview"));
            string CurrentTime = WaveformReviewPanel.Get<Label>(SearchCriteria.ByAutomationId("lblTime")).Text;
            DateTime CurrentDateTime = Convert.ToDateTime(CurrentTime);
            DateTime ToDateTime = CurrentDateTime.AddHours(-1);

            Panel scTimePanel = _CAMainWindow.Get<Panel>(SearchCriteria.ByAutomationId("scTime"));
            Button PageBwBtn = scTimePanel.Get<Button>(SearchCriteria.ByAutomationId("PageBw"));

            //move the time bar at the bottom to 1 hour earlier
            while (CurrentDateTime > ToDateTime)
            {
                PageBwBtn.Click();
                CurrentTime = WaveformReviewPanel.Get<Label>(SearchCriteria.ByAutomationId("lblTime")).Text;
                CurrentDateTime = Convert.ToDateTime(CurrentTime);
            }

            //Go back to Trends
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnTrends")).Click();
            Panel GraphPanel = _CAMainWindow.Get<Panel>(SearchCriteria.ByAutomationId("GraphPanel"));
            Panel GraphControl = GraphPanel.Get<Panel>(SearchCriteria.ByAutomationId("GraphControl"));
            //hard to verify the timeline position in Trends 
            //string timeStr = GraphControl.Get<Label>(SearchCriteria.ByAutomationId("GraphControl")).Text;

            TestLog.WriteLog("End TimelineSync: 23525: Timeline synchronization between Waveform views and Trends");
        }

        //23615: Tabular trend durations and intervals available for user selection
        [Test]
        public void DurationsIntervals()
        {
            //prepare for the monitoring data
            Prepare("testbed");

            TestLog.WriteLog("Start DurationsIntervals: 23615: Tabular trend durations and intervals available for user selection");

            var DurationCombobox = _CAMainWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("trendDurationCombo"));
            var ResolutionCombobox = _CAMainWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("trendResolutionCombo"));
            List<string> DurationLst = DurationCombobox.Items.Select(s => s.Text).ToList();
            List<string> ResolutionLst = ResolutionCombobox.Items.Select(s => s.Text).ToList();

            List<string> ExpectedDurationLst = new List<string>(new string[] { "15 minutes", "30 minutes", "1 hour", "2 hours", "4 hours", "8 hours", "12 hours", "24 hours" });
            List<string> ExpectedIntervalLst = new List<string>(new string[] { "1 minute", "5 minutes", "10 minutes", "15 minutes", "30 minutes", "60 minutes", "2 hours", "4 hours" });

            Assert.IsTrue(DurationLst.SequenceEqual(ExpectedDurationLst));
            Assert.IsTrue(ResolutionLst.SequenceEqual(ExpectedIntervalLst));

            TestLog.WriteLog("End DurationsIntervals: 23615: Tabular trend durations and intervals available for user selection");
        }

        //23657: Tabular and Graphical trends can be enabled/disabled
        [Test]
        public void CheckTabularVitals()
        {
            TestLog.WriteLog("Start CheckTabularVitals: 23657: Tabular and Graphical trends can be enabled/disabled");

            //prepare for the monitoring data
            Prepare("SLMBed");

            if (_CAMainWindow.Get<CheckBox>(SearchCriteria.ByText("Tabular")).Checked)
            {
                _CAMainWindow.Get<CheckBox>(SearchCriteria.ByText("Tabular")).UnSelect();
            }
            _CAMainWindow.Get<CheckBox>(SearchCriteria.ByText("Tabular")).Select();
            Assert.IsTrue(_CAMainWindow.Get<CheckBox>(SearchCriteria.ByText("Tabular")).Checked);

            if (_CAMainWindow.Get<CheckBox>(SearchCriteria.ByText("Vitals")).Checked)
            {
                _CAMainWindow.Get<CheckBox>(SearchCriteria.ByText("Vitals")).UnSelect();
            }
            _CAMainWindow.Get<CheckBox>(SearchCriteria.ByText("Vitals")).Select();
            Assert.IsTrue(_CAMainWindow.Get<CheckBox>(SearchCriteria.ByText("Vitals")).Checked);

            TestLog.WriteLog("End CheckTabularVitals: 23657: Tabular and Graphical trends can be enabled/disabled");
        }

        //23698 Add more Trends Graph
        //assume: 1) there is only one existing Graph. 2) First Catagory has 5 parameters
        //[Test]
        //public void AddGraph()
        //{
        //    //prepare for the monitoring data
        //    Prepare("testbed");

        //    TestLog.WriteLog("Start AddGraph: 23698 Add more Trends Graph");

        //    _CAMainWindow.Get<Button>(SearchCriteria.ByAutomationId("settingsBtn")).Click();
        //    _CAMainWindow.Get(SearchCriteria.ByText("Graphs")).Click();

        //    //add 1 new graph
        //    _CAMainWindow.Get(SearchCriteria.ByAutomationId("graphNewGraphBtn")).Click();
        //    Window AddNewGraghWindow = _CAMainWindow.ModalWindow(SearchCriteria.ByAutomationId("RenameForm"));
        //    var edit = AddNewGraghWindow.Get<TextBox>(SearchCriteria.ByAutomationId("newNameText"));
        //    edit.Text = "Graph1";
        //    AddNewGraghWindow.Get<Button>(SearchCriteria.ByText("OK")).Click();

        //    _CAMainWindow.Get<Button>(SearchCriteria.ByAutomationId("graphAddParamsBtn")).Click();
        //    Window TrendCategoriesandParametersWindow = _CAMainWindow.ModalWindow("Trend Categories and Parameters");
        //    //no automatioon for the button, only by checkbox
        //    var checkbox = TrendCategoriesandParametersWindow.Get<CheckBox>(SearchCriteria.ByControlType(ControlType.CheckBox).AndIndex(0));
        //    checkbox.Click();
        //    //unselect top 1, add 4 parameters to the Graph 
        //    TrendCategoriesandParametersWindow.Get<CheckBox>(SearchCriteria.ByControlType(ControlType.CheckBox).AndIndex(1)).Click();
        //    TrendCategoriesandParametersWindow.Get<Button>(SearchCriteria.ByText("OK")).Click();

        //    //add 2 new graph
        //    _CAMainWindow.Get(SearchCriteria.ByAutomationId("graphNewGraphBtn")).Click();
        //    AddNewGraghWindow = _CAMainWindow.ModalWindow(SearchCriteria.ByAutomationId("RenameForm"));
        //    edit = AddNewGraghWindow.Get<TextBox>(SearchCriteria.ByAutomationId("newNameText"));
        //    edit.Text = "Graph2";
        //    AddNewGraghWindow.Get<Button>(SearchCriteria.ByText("OK")).Click();
        //    _CAMainWindow.Get<Button>(SearchCriteria.ByAutomationId("graphAddParamsBtn")).Click();
        //    TrendCategoriesandParametersWindow = _CAMainWindow.ModalWindow("Trend Categories and Parameters");
        //    //no automatioon for the button, only by checkbox
        //    checkbox = TrendCategoriesandParametersWindow.Get<CheckBox>(SearchCriteria.ByControlType(ControlType.CheckBox).AndIndex(0));
        //    checkbox.Click();
        //    TrendCategoriesandParametersWindow.Get<Button>(SearchCriteria.ByText("OK")).Click();
        //    ////check the error messager after excceed 4 parameters  
        //    Window ErrorWindow = _CAMainWindow.ModalWindow("Error");
        //    string errorStr = ErrorWindow.Get<Label>(SearchCriteria.ByControlType(ControlType.Text).AndIndex(3)).Text;
        //    Assert.IsTrue(errorStr.Contains("Number of parameters selected (5) exceeds the available slots on a graph (4)."));
        //    ErrorWindow.Get<Button>(SearchCriteria.ByText("OK")).Click();
        //    TrendCategoriesandParametersWindow.Get<CheckBox>(SearchCriteria.ByControlType(ControlType.CheckBox).AndIndex(1)).Click();
        //    TrendCategoriesandParametersWindow.Get<Button>(SearchCriteria.ByText("OK")).Click();

        //    //add 3 Graph
        //    _CAMainWindow.Get(SearchCriteria.ByAutomationId("graphNewGraphBtn")).Click();
        //    AddNewGraghWindow = _CAMainWindow.ModalWindow(SearchCriteria.ByAutomationId("RenameForm"));
        //    edit = AddNewGraghWindow.Get<TextBox>(SearchCriteria.ByAutomationId("newNameText"));
        //    edit.Text = "Graph3";
        //    AddNewGraghWindow.Get<Button>(SearchCriteria.ByText("OK")).Click();
        //    _CAMainWindow.Get<Button>(SearchCriteria.ByAutomationId("graphAddParamsBtn")).Click();
        //    TrendCategoriesandParametersWindow = _CAMainWindow.ModalWindow("Trend Categories and Parameters");
        //    //no automatioon for the button, only by checkbox
        //    checkbox = TrendCategoriesandParametersWindow.Get<CheckBox>(SearchCriteria.ByControlType(ControlType.CheckBox).AndIndex(0));
        //    checkbox.Click();
        //    TrendCategoriesandParametersWindow.Get<CheckBox>(SearchCriteria.ByControlType(ControlType.CheckBox).AndIndex(1)).Click();
        //    TrendCategoriesandParametersWindow.Get<Button>(SearchCriteria.ByText("OK")).Click();

        //    //since already 4 Graph, the New Graph button is Unenabled
        //    Assert.IsFalse(_CAMainWindow.Get(SearchCriteria.ByAutomationId("graphNewGraphBtn")).Enabled);

        //    //clean up newly created Graph
        //    Panel GraphTrendControl = _CAMainWindow.Get<Panel>(SearchCriteria.ByAutomationId("GraphTrendControl").AndIndex(3));
        //    GraphTrendControl.Click();
        //    _CAMainWindow.Get(SearchCriteria.ByAutomationId("graphRemoveGraphBtn")).Click();
        //    Window RemoveGraghWindow = _CAMainWindow.ModalWindow(SearchCriteria.ByAutomationId("MessageBoxForm"));
        //    RemoveGraghWindow.Get<Button>(SearchCriteria.ByText("Yes")).Click();

        //    _CAMainWindow.Get<Panel>(SearchCriteria.ByAutomationId("GraphTrendControl").AndIndex(2)).Click();
        //    _CAMainWindow.Get(SearchCriteria.ByAutomationId("graphRemoveGraphBtn")).Click();
        //    RemoveGraghWindow = _CAMainWindow.ModalWindow(SearchCriteria.ByAutomationId("MessageBoxForm"));
        //    RemoveGraghWindow.Get<Button>(SearchCriteria.ByText("Yes")).Click();

        //    _CAMainWindow.Get<Panel>(SearchCriteria.ByAutomationId("GraphTrendControl").AndIndex(1)).Click();
        //    _CAMainWindow.Get(SearchCriteria.ByAutomationId("graphRemoveGraphBtn")).Click();
        //    RemoveGraghWindow = _CAMainWindow.ModalWindow(SearchCriteria.ByAutomationId("MessageBoxForm"));
        //    RemoveGraghWindow.Get<Button>(SearchCriteria.ByText("Yes")).Click();

        //    //the New Graph button is Enabled again
        //    Assert.IsTrue(_CAMainWindow.Get(SearchCriteria.ByAutomationId("graphNewGraphBtn")).Enabled);

        //    TestLog.WriteLog("End AddGraph: 23698 Add more Trends Graph");
        //}
    }

    public class AlarmsView
    {
        private static string CAExeFile;
        private static Application _CAApp;
        private static Window _CAMainWindow;
        Hashtable configHT;


        [SetUp]
        protected void SetUp()
        {
            configHT = Config.ReadConfig();
            string CAAppPath = (string)configHT["ExePath"];
            string CAExeFile = CAAppPath + @"\ClinicalHistoryXP.exe";

            var psi = new ProcessStartInfo(CAExeFile);
            _CAApp = Application.AttachOrLaunch(psi);
            _CAMainWindow = _CAApp.GetWindow(SearchCriteria.ByAutomationId("ClinicalAccess"), InitializeOption.NoCache);
        }

        public void Prepare(string bed)
        {
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnSelectPatient")).Click();
            Window _PatientSelectDialogWindow = _CAMainWindow.ModalWindow("Patient Select Dialog");

            var PatientsTab = _PatientSelectDialogWindow.Get(SearchCriteria.ByText("Patients"));
            PatientsTab.Click();

            var comboBox = _PatientSelectDialogWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("cmbFacility"));
            comboBox.Select("Facility1");

            _PatientSelectDialogWindow.Get(SearchCriteria.ByText("Unit Row 0")).DoubleClick();
            var DataGridView_Table = _PatientSelectDialogWindow.Get<Table>(SearchCriteria.ByAutomationId("dgvUnits"));

            //to avoid timeout=5000 exception
            CoreAppXmlConfiguration.Instance.BusyTimeout = 50000;
            bool found = false;
            TableRow testRow = null;
            //go through the units to find the testing bed
            for (int i = 0; i < DataGridView_Table.Rows.Count; i++)
            {
                string pos = i.ToString();
                _PatientSelectDialogWindow.Get(SearchCriteria.ByText("Unit Row " + pos)).DoubleClick();

                var PatientsDatagrid2 = _PatientSelectDialogWindow.Get<Table>(SearchCriteria.ByAutomationId("dgvPatients"));

                foreach (TableRow row in PatientsDatagrid2.Rows)
                {
                    if ((string)row.Cells[0].Value == (string)configHT[bed])  //"RW164"  "XTQ15(2360)") "CP116"
                    {
                        testRow = row;
                        found = true;
                        break;
                    }
                }
                if (found == true)
                    break;
            }

            //after click the row, the "Patient Select Dialog" disappear and may generate exception
            try
            {
                testRow.Click();
            }
            catch (Exception e)
            {
                Console.WriteLine("test case BedsideData exception" + e.Message.ToString());
            }

            //click Waveforms
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnAlarmHistory")).Click();
        }

        [TearDown]
        public void TearDown()
        {
            //_CAApp.Close();
            //_CAApp.Dispose();
        }

        //22115: Generated Alarm Events are seen in Thumbnails view
        //make suree the bed has alarms ECG (VE/MIN LIMIT=5)
        [Test]
        public void ThumbnailsView()
        {
            //prepare for the monitoring data
            Prepare("alarmsview");

            TestLog.WriteLog("Start ThumbnailsView: 22115: Generated Alarm Events are seen in Thumbnails view");

            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnThumbnails")).Click();
            var thumbnailContainer = _CAMainWindow.Get<Panel>(SearchCriteria.ByAutomationId("thumbnailContainer"));
            var firstPanel = thumbnailContainer.Get<Panel>(SearchCriteria.ByControlType(ControlType.Pane).AndIndex(0));
            string ECGTxt = firstPanel.Get<Label>(SearchCriteria.ByControlType(ControlType.Text).AndIndex(0)).Text;  //ECG (VE/MIN LIMIT=5)

            Assert.IsTrue(ECGTxt.Contains("LIMIT="));

            TestLog.WriteLog("End ThumbnailsView: 22115: Generated Alarm Events are seen in Thumbnails view");
        }

        //22116: Generated alarm events can be viewed as per the selected parameter
        //22117 Generated alarm events can be viewed as per the selected alarm type
        //make suree the bed has alarms ECG (VE/MIN LIMIT=5)
        [Test]
        public void ParameterType()
        {
            //prepare for the monitoring data
            Prepare("alarmsview");

            TestLog.WriteLog("Start ParameterType: 22116: Generated alarm events can be viewed as per the selected parameter");

            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnThumbnails")).Click();
            var parameterCombo = _CAMainWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("parameterCombo"));
            parameterCombo.SetValue("ECG");
            var thumbnailContainer = _CAMainWindow.Get<Panel>(SearchCriteria.ByAutomationId("thumbnailContainer"));
            var firstPanel = thumbnailContainer.Get<Panel>(SearchCriteria.ByControlType(ControlType.Pane).AndIndex(0));
            string ECGTxt = firstPanel.Get<Label>(SearchCriteria.ByControlType(ControlType.Text).AndIndex(0)).Text;  //ECG (VE/MIN LIMIT=5)
            Assert.IsTrue(ECGTxt.StartsWith("ECG"));

            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnStrip")).Click();
            parameterCombo = _CAMainWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("parameterCombo"));
            parameterCombo.SetValue("ECG");
            var alarmCombo = _CAMainWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("alarmCombo"));
            string currentValue = alarmCombo.SelectedItemText;
            Assert.IsTrue(currentValue.Contains("ECG"));

            TestLog.WriteLog("End ParameterType: 22116: Generated alarm events can be viewed as per the selected parameter");
        }

        //24529: The alarm events are presented in chronological order
        //make suree the bed has alarms ECG (VE/MIN LIMIT=5)
        [Test]
        public void AlarmEventOrder()
        {
            //prepare for the monitoring data
            Prepare("alarmsview");

            TestLog.WriteLog("Start AlarmEventOrder: 24529: The alarm events are presented in chronological order");

            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnThumbnails")).Click();
            var parameterCombo = _CAMainWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("parameterCombo"));
            parameterCombo.SetValue("All");
            var alarmCombo = _CAMainWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("alarmCombo"));

            DateTime preDate = DateTime.Now;
            int order = 0;
            int count = alarmCombo.Items.Count;
            while (order < count - 1)
            {
                // has format 10/11 11:25:46am 
                string dateStr = alarmCombo.Items[order].Name.Split(new char[] { '-' }, StringSplitOptions.RemoveEmptyEntries)[0];
                string[] dateStrs = dateStr.Split(new char[] { ' ' });
                DateTime eventDate = DateTime.ParseExact(dateStrs[0] + @"/" + DateTime.Now.Year + " " + dateStrs[1].Substring(0, dateStrs[1].Length - 2) + " " + dateStrs[1].Substring(dateStrs[1].Length - 2, 2).ToUpper(), "M/dd/yyyy h:mm:ss tt", CultureInfo.InvariantCulture);
                //the event order should from latest to earliest
                Assert.IsTrue(preDate > eventDate);
                preDate = eventDate;
                order++;
            }

            TestLog.WriteLog("End AlarmEventOrder: 24529: The alarm events are presented in chronological order");
        }

        //24530: The user can scroll through the list of available alarm events in Strip view
        //make suree the bed has alarms ECG (VE/MIN LIMIT=5)
        [Test]
        public void ScrollEventsInStrip()
        {
            //prepare for the monitoring data
            Prepare("alarmsview");

            TestLog.WriteLog("Start ScrollEventsInStrip: 24530: The user can scroll through the list of available alarm events in Strip view");

            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnStrip")).Click();
            var parameterCombo = _CAMainWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("parameterCombo"));
            parameterCombo.SetValue("All");
            var alarmCombo = _CAMainWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("alarmCombo"));

            int eventcount = alarmCombo.Items.Count;
            //1 of 8
            string[] countStrs = _CAMainWindow.Get<Label>(SearchCriteria.ByAutomationId("lblCount")).Text.Split(new char[] { ' ' });
            int allCount = Convert.ToInt32(countStrs[2]);
            int preNum = Convert.ToInt32(countStrs[0]);
            Assert.IsTrue(allCount == eventcount);

            //click on button Next once
            _CAMainWindow.Get<Button>(SearchCriteria.ByAutomationId("btnNext")).Click();
            countStrs = _CAMainWindow.Get<Label>(SearchCriteria.ByAutomationId("lblCount")).Text.Split(new char[] { ' ' });
            int curNum = Convert.ToInt32(countStrs[0]);
            Assert.IsTrue(curNum == preNum + 1);
            string ExpectSelectedTxt = alarmCombo.Items[curNum - 1].Text;
            Assert.IsTrue(ExpectSelectedTxt == alarmCombo.SelectedItemText);

            //click on button Last 
            _CAMainWindow.Get<Button>(SearchCriteria.ByAutomationId("btnLast")).Click();
            countStrs = _CAMainWindow.Get<Label>(SearchCriteria.ByAutomationId("lblCount")).Text.Split(new char[] { ' ' });
            curNum = Convert.ToInt32(countStrs[0]);
            Assert.IsTrue(curNum == allCount);
            ExpectSelectedTxt = alarmCombo.Items[curNum - 1].Text;
            Assert.IsTrue(ExpectSelectedTxt == alarmCombo.SelectedItemText);

            //click on button Prev 
            _CAMainWindow.Get<Button>(SearchCriteria.ByAutomationId("btnPrev")).Click();
            countStrs = _CAMainWindow.Get<Label>(SearchCriteria.ByAutomationId("lblCount")).Text.Split(new char[] { ' ' });
            curNum = Convert.ToInt32(countStrs[0]);
            Assert.IsTrue(curNum == allCount - 1);
            ExpectSelectedTxt = alarmCombo.Items[curNum - 1].Text;
            Assert.IsTrue(ExpectSelectedTxt == alarmCombo.SelectedItemText);

            //click on button First 
            _CAMainWindow.Get<Button>(SearchCriteria.ByAutomationId("btnFirst")).Click();
            countStrs = _CAMainWindow.Get<Label>(SearchCriteria.ByAutomationId("lblCount")).Text.Split(new char[] { ' ' });
            curNum = Convert.ToInt32(countStrs[0]);
            Assert.IsTrue(curNum == 1);
            ExpectSelectedTxt = alarmCombo.Items[0].Text;
            Assert.IsTrue(ExpectSelectedTxt == alarmCombo.SelectedItemText);

            TestLog.WriteLog("End ScrollEventsInStrip: 24530: The user can scroll through the list of available alarm events in Strip view");
        }

        //24531: The user can scroll through the list of available alarm events in Thumbnails view
        //make suree the bed has alarms ECG (VE/MIN LIMIT=5)
        [Test]
        public void ScrollEventsInThumbnails()
        {
            //prepare for the monitoring data
            Prepare("alarmsview");

            TestLog.WriteLog("Start ScrollEventsInThumbnails: 24531: The user can scroll through the list of available alarm events in Strip view");

            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnThumbnails")).Click();
            var parameterCombo = _CAMainWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("parameterCombo"));
            parameterCombo.SetValue("All");
            var alarmCombo = _CAMainWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("alarmCombo"));

            int eventcount = alarmCombo.Items.Count;
            //1 of 8
            string[] countStrs = _CAMainWindow.Get<Label>(SearchCriteria.ByAutomationId("lblCount")).Text.Split(new char[] { ' ' });
            int allCount = Convert.ToInt32(countStrs[2]);
            int preNum = Convert.ToInt32(countStrs[0]);
            Assert.IsTrue(allCount == eventcount);

            //click on button Next once
            _CAMainWindow.Get<Button>(SearchCriteria.ByAutomationId("btnNext")).Click();
            countStrs = _CAMainWindow.Get<Label>(SearchCriteria.ByAutomationId("lblCount")).Text.Split(new char[] { ' ' });
            int curNum = Convert.ToInt32(countStrs[0]);
            Assert.IsTrue(curNum == preNum + 1);
            string ExpectSelectedTxt = alarmCombo.Items[curNum - 1].Text;
            Assert.IsTrue(ExpectSelectedTxt == alarmCombo.SelectedItemText);

            //click on button Last 
            _CAMainWindow.Get<Button>(SearchCriteria.ByAutomationId("btnLast")).Click();
            countStrs = _CAMainWindow.Get<Label>(SearchCriteria.ByAutomationId("lblCount")).Text.Split(new char[] { ' ' });
            curNum = Convert.ToInt32(countStrs[0]);
            Assert.IsTrue(curNum == allCount);
            ExpectSelectedTxt = alarmCombo.Items[curNum - 1].Text;
            Assert.IsTrue(ExpectSelectedTxt == alarmCombo.SelectedItemText);

            //click on button Prev 
            _CAMainWindow.Get<Button>(SearchCriteria.ByAutomationId("btnPrev")).Click();
            countStrs = _CAMainWindow.Get<Label>(SearchCriteria.ByAutomationId("lblCount")).Text.Split(new char[] { ' ' });
            curNum = Convert.ToInt32(countStrs[0]);
            Assert.IsTrue(curNum == allCount - 1);
            ExpectSelectedTxt = alarmCombo.Items[curNum - 1].Text;
            Assert.IsTrue(ExpectSelectedTxt == alarmCombo.SelectedItemText);

            //click on button First 
            _CAMainWindow.Get<Button>(SearchCriteria.ByAutomationId("btnFirst")).Click();
            countStrs = _CAMainWindow.Get<Label>(SearchCriteria.ByAutomationId("lblCount")).Text.Split(new char[] { ' ' });
            curNum = Convert.ToInt32(countStrs[0]);
            Assert.IsTrue(curNum == 1);
            ExpectSelectedTxt = alarmCombo.Items[0].Text;
            Assert.IsTrue(ExpectSelectedTxt == alarmCombo.SelectedItemText);

            TestLog.WriteLog("End ScrollEventsInThumbnails: 24531: The user can scroll through the list of available alarm events in Strip view");
        }
    }
}
    
    

