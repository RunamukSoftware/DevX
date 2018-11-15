using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
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
using System.Text.RegularExpressions;
using NUnit.Framework;
using System.IO;
using TestStack.White.UIItems.Scrolling;
using System.Windows;
using System.Globalization;
using TestStack.White.Configuration;

namespace caWhite
{
    class Program
    {
        // source exe file path. here it is calculator exe path
        private const string ExeSourceFile = @"C:\Windows\system32\calc.exe";
        //Global Variable to for Application launch
        private static Application _application;
        //Global variable to get the Main window of calculator from application.
        private static Window _mainWindow;

        //CA setup
        private const string CAExeFile = @"C:\Program Files (x86)\Spacelabs\ICS\Clinical Access\ClinicalHistoryXP.exe";
        private static Application _CAApp;
        private static TestStack.White.UIItems.WindowItems.Window _CAMainWindow;
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


        static void Main(string[] args)
        {
            //setup
            var psi = new ProcessStartInfo(CAExeFile);
            _CAApp = Application.AttachOrLaunch(psi);
            _CAMainWindow = _CAApp.GetWindow(SearchCriteria.ByAutomationId("ClinicalAccess"), InitializeOption.NoCache);

            //prepare
            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnSelectPatient")).Click();
            Window _PatientSelectDialogWindow = _CAMainWindow.ModalWindow("Patient Select Dialog");

            var PatientsTab = _PatientSelectDialogWindow.Get(SearchCriteria.ByText("Patients"));
            PatientsTab.Click();

            var cmbFacility = _PatientSelectDialogWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("cmbFacility"));
            //int tryCnt = 0;
            //string FacilitySelectedValue = null;
            //while ((tryCnt < 3) && (FacilitySelectedValue != "XTRSim"))
            //{
            //    cmbFacility.Select("XTRSim");
            //    FacilitySelectedValue = cmbFacility.SelectedItem.Text;
            //    tryCnt++;
            //}

            //make sure the selection on the Unit row works
            _PatientSelectDialogWindow = _CAMainWindow.ModalWindow("Patient Select Dialog");
            _PatientSelectDialogWindow.Get(SearchCriteria.ByText("Unit Row 0")).DoubleClick();
            var DataGridView_Table = _PatientSelectDialogWindow.Get<Table>(SearchCriteria.ByAutomationId("dgvUnits"));
            cmbFacility.Select("XTRSim");

            //to avoid timeout=5000 exception
            CoreAppXmlConfiguration.Instance.BusyTimeout = 100000;//50000
            bool found = false;
            TableRow testRow = null;

            //go through the units to find the testing bed
            for (int i = 0; i < DataGridView_Table.Rows.Count; i++)
            {
                string pos = i.ToString();
                _PatientSelectDialogWindow.Get(SearchCriteria.ByText("Unit Row " + pos)).DoubleClick();

                var PatientsDatagrid2 = _PatientSelectDialogWindow.Get<Table>(SearchCriteria.ByAutomationId("dgvPatients"));
                var rows = PatientsDatagrid2.Rows;

                foreach (TableRow row in rows)
                {
                    if ((string)row.Cells[0].Value == "BD002(2140)") //"Room3(2666)") ; //"CP255")
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

            //_CAMainWindow.Get(SearchCriteria.ByAutomationId("btnArrhythmiaReview")).Click();
            //click Bedside
            //var bedsideView = _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnBedSide"));
            //bedsideView.Click();
            var WaveformsView = _CAMainWindow.Get(SearchCriteria.ByText("Waveforms"));
            WaveformsView.Click();
            //_CAMainWindow.Get(SearchCriteria.ByAutomationId("btn12Lead")).Click();
            //_CAMainWindow.Get(SearchCriteria.ByAutomationId("btnAlarmHistory")).Click();
            Thread.Sleep(2000);

            //Test codes

            _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnCompressed")).Click();
            Panel CompressedWaveformContainer = _CAMainWindow.Get<Panel>(SearchCriteria.ByAutomationId("CompressedWaveformContainer"));
            Panel TimePanel1 = CompressedWaveformContainer.Get<Panel>(SearchCriteria.ByAutomationId("TimeControl.0"));
            string DateStr = TimePanel1.Get<Label>(SearchCriteria.ByAutomationId("Label.0")).Text;
            string TimeStampStr = TimePanel1.Get<Label>(SearchCriteria.ByAutomationId("Label.1")).Text;
            DateTime displayedTime = Convert.ToDateTime(DateStr + " " + TimeStampStr);

            //Display most recent data < 15  ?
            Assert.IsTrue((DateTime.Now - displayedTime).TotalMinutes < 15);

            //end test codes

            _CAApp.Close();
            _CAApp.Dispose();
        }


        public static void runCalculate()
        {
            try
            {

                //strat process for the above exe file location
                var psi = new ProcessStartInfo(ExeSourceFile);
                // launch the process through white application
                _application = TestStack.White.Application.AttachOrLaunch(psi);
                //Get the window of calculator from white application 
                _mainWindow = _application.GetWindow(SearchCriteria.ByText("Calculator"), InitializeOption.NoCache);
                //Convert the open calculator into Date calculator using key board Hot Key(Ctrl+E)
                DateDifferenceCalculation();
                //Return back to Basic using Key Board Hot Key
                ReturnToBasicCalculatorUsingHotKey();
                //Return back to Basic using Menu Option
                ReturnToBasicCalculatorUsingMenu();
                //Open Help option in Calculator
                OpenHelpOptionInCalculator();
                //Perform Addition of few numbers
                PerformSummationOnCalculator();
                //Dispose the main window
                _mainWindow.Dispose();
                //Dispose the application
                _application.Dispose();
            }
            catch (Exception)
            {

                throw;
            }
        }

        private static void PerformSummationOnCalculator()
        {
            //Button with Numerical value 1
            TestStack.White.UIItems.Button btn1 = _mainWindow.Get<TestStack.White.UIItems.Button>(SearchCriteria.ByText("1"));
            //Button with Numerical value 2
            TestStack.White.UIItems.Button btn2 = _mainWindow.Get<TestStack.White.UIItems.Button>(SearchCriteria.ByText("2"));
            //Button with Numerical value 3
            TestStack.White.UIItems.Button btn3 = _mainWindow.Get<TestStack.White.UIItems.Button>(SearchCriteria.ByText("3"));
            //Button with Numerical value 4
            TestStack.White.UIItems.Button btn4 = _mainWindow.Get<TestStack.White.UIItems.Button>(SearchCriteria.ByText("4"));
            //Button with Numerical value 5
            TestStack.White.UIItems.Button btn5 = _mainWindow.Get<TestStack.White.UIItems.Button>(SearchCriteria.ByText("5"));
            //Button with Numerical value 6
            TestStack.White.UIItems.Button btn6 = _mainWindow.Get<TestStack.White.UIItems.Button>(SearchCriteria.ByText("6"));
            //Button with Numerical value 7
            TestStack.White.UIItems.Button btn7 = _mainWindow.Get<TestStack.White.UIItems.Button>(SearchCriteria.ByText("7"));
            //Button with Numerical value 8
            TestStack.White.UIItems.Button btn8 = _mainWindow.Get<TestStack.White.UIItems.Button>(SearchCriteria.ByText("8"));
            //Button with Numerical value 9
            TestStack.White.UIItems.Button btn9 = _mainWindow.Get<TestStack.White.UIItems.Button>(SearchCriteria.ByText("9"));
            //Button with Numerical value 0
            TestStack.White.UIItems.Button btn0 = _mainWindow.Get<TestStack.White.UIItems.Button>(SearchCriteria.ByText("0"));
            //Button with text as +(for sum)
            TestStack.White.UIItems.Button btnSum = _mainWindow.Get<TestStack.White.UIItems.Button>(SearchCriteria.ByText("Add"));
            //Read button to get the result
            TestStack.White.UIItems.Button btnResult = _mainWindow.Get<TestStack.White.UIItems.Button>(SearchCriteria.ByText("Equals"));
            //add two numbers 1234 and 5678 and get the result.
            //Type First Numbers 1234
            btn1.Click();
            btn2.Click();
            btn3.Click();
            btn4.Click();
            //Press Add button
            btnSum.Click();
            //Type 2nd number 
            btn5.Click();
            btn6.Click();
            btn7.Click();
            btn8.Click();
            //Get the result
            btnResult.Click();
            //read the result
            TestStack.White.UIItems.Label resultLable = _mainWindow.Get<TestStack.White.UIItems.Label>(SearchCriteria.ByAutomationId("150"));
            string result = resultLable.Text;
            if (result == "6912")
            {
                Console.WriteLine("Addition of numbers is correct.the result is {0}", result);
            }
            //  Assert.AreEqual("6912", resultLable, "Sorry Summation is wrong!!");
        }
        /// <summary>
        /// Open help File from calculator menu
        /// </summary>
        private static void OpenHelpOptionInCalculator()
        {
            //Click on Help at Menu item
            var help = _mainWindow.Get<TestStack.White.UIItems.MenuItems.Menu>(SearchCriteria.ByText("Help"));
            help.Click();
            //Click on View Help guide to open new window from menu bar
            var viewHelp = _mainWindow.Get<TestStack.White.UIItems.MenuItems.Menu>(SearchCriteria.ByText("View Help"));
            viewHelp.Click();
        }
        /// <summary>
        /// Operate the Calculator in to basic mode through Menu option
        /// </summary>
        private static void ReturnToBasicCalculatorUsingMenu()
        {
            var menuView = _mainWindow.Get<TestStack.White.UIItems.MenuItems.Menu>(SearchCriteria.ByText("View"));
            menuView.Click();
            //select Basic
            var menuViewBasic = _mainWindow.Get<TestStack.White.UIItems.MenuItems.Menu>(SearchCriteria.ByText("Basic"));
            menuViewBasic.Click();

        }
        /// <summary>
        /// Change the calculator mode in basic using Key Board Hot Key
        /// </summary>
        private static void ReturnToBasicCalculatorUsingHotKey()
        {

            Keyboard.Instance.HoldKey(TestStack.White.WindowsAPI.KeyboardInput.SpecialKeys.CONTROL);
            Keyboard.Instance.PressSpecialKey(TestStack.White.WindowsAPI.KeyboardInput.SpecialKeys.F4);
            Keyboard.Instance.LeaveKey(TestStack.White.WindowsAPI.KeyboardInput.SpecialKeys.CONTROL);
        }
        /// <summary>
        /// Find difference between dates through calculator
        /// </summary>
        private static void DateDifferenceCalculation()
        {
            Keyboard.Instance.HoldKey(TestStack.White.WindowsAPI.KeyboardInput.SpecialKeys.CONTROL);
            Keyboard.Instance.Enter("E");
            Keyboard.Instance.LeaveKey(TestStack.White.WindowsAPI.KeyboardInput.SpecialKeys.CONTROL);
            //On Date window find the difference between dates.
            //Set value into combobox
            var comboBox = _mainWindow.Get<TestStack.White.UIItems.ListBoxItems.ComboBox>(SearchCriteria.ByAutomationId("4003"));
            comboBox.Select("Calculate the difference between two dates");
            //Click on Calculate button
            TestStack.White.UIItems.Button caclButton =
                _mainWindow.Get<TestStack.White.UIItems.Button>(SearchCriteria.ByAutomationId("4009"));
            caclButton.Click();
        }
    }
}
