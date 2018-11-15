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
using System.Configuration;
using TestStack.White.Configuration;

namespace caWhite
{
    class Program
    {
        private static string CAExeFile = ConfigurationManager.AppSettings["CAApp"]; //@"C:\Program Files (x86)\Spacelabs\ICS\Clinical Access\ClinicalHistoryXP.exe";
        private static Application _CAApp;
        private static Window _CAMainWindow;

        static void Main(string[] args)
        {
            //string bednames = ConfigurationManager.AppSettings["BedNames"];
            //string[] bednameArr = bednames.Split(new char[] { ','});

            //to avoid timeout=5000 exception
            CoreAppXmlConfiguration.Instance.BusyTimeout = 50000;

            var psi = new ProcessStartInfo(CAExeFile);
            _CAApp = Application.AttachOrLaunch(psi);
            _CAMainWindow = _CAApp.GetWindow(SearchCriteria.ByAutomationId("ClinicalAccess"), InitializeOption.NoCache); //.WithCache);

            CoreAppXmlConfiguration.Instance.BusyTimeout = 100000;

            //Random rnd = new Random();
            //int bedindex = rnd.Next(1, bednameArr.Length);
            PrepareTest(_CAMainWindow, "Waveforms");

            _CAApp.Close();
            _CAApp.Dispose();
        }

        public static void DoAnalysis(Window _CAMainWindow, string bedname)
        {
            int AnalysisTime = Int32.Parse(ConfigurationManager.AppSettings["AnalysisTime"]);
            int TimeInterval = Int32.Parse(ConfigurationManager.AppSettings["TimeInterval"]);
            string Duration = ConfigurationManager.AppSettings["Duration"].ToString();

            String DateTimeStr = "";
            //int errorCnt = 0;

            try
            {
                _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnCompressed")).Click();
                _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnAnalyze")).Click();
                Window AnalyzeWindow = _CAMainWindow.ModalWindow("Select Time");
                var ConfigComboBox = AnalyzeWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("CboDuration"));
                ConfigComboBox.Click();
                ConfigComboBox.Select(Duration);
                AnalyzeWindow.Get<Button>(SearchCriteria.ByText("OK")).Click();
                DateTimeStr = DateTime.Now.ToString("s");
                Thread.Sleep(AnalysisTime);

                try
                {
                    Window ErrorWindow = _CAMainWindow.ModalWindow("Error");
                    if (ErrorWindow != null)
                    {
                        InserttoFile("result", "Bedname: " + bedname + "; " + "Error" + "  " + DateTimeStr);
                        ErrorWindow.Get<Button>(SearchCriteria.ByText("OK")).Click();
                        //errorCnt++;
                        //if (errorCnt > 10)
                        //{
                        //    _CAApp.Close();
                        //    _CAApp.Dispose();
                        //    Environment.Exit(1); //exit with error
                        //}
                    }
                }
                catch (Exception e)
                {
                    InserttoFile("result", "Bedname: " + bedname + "; " + "Pass" + "  " + DateTimeStr);
                    InserttoFile("error", "Bedname: " + bedname + "; " + e.Message);
                }

                //wait 1 min 60000
                Thread.Sleep(TimeInterval);
            }
            catch (Exception e)
            {
                InserttoFile("error", "Bedname: " + bedname + "; " + e.Message);
            }

            return;
        }

        public static void PrepareTest(Window _CAMainWindow, string MainToolbarBtn)
        {
            string Facility = ConfigurationManager.AppSettings["Facility"];

            Window _PatientSelectDialogWindow = _CAMainWindow.ModalWindow("Patient Select Dialog");
            _PatientSelectDialogWindow.Close();

            string preFacility = "";
            bool IsChangeFacility = false;
            int preUnitPos = 0;
            bool IsChangeUnit = false;
            string preBedname = "";
            bool isAnalysisable = true;

            while (true)
            {
                try
                {
                    var PatientsSelectButton = _CAMainWindow.Get(SearchCriteria.ByAutomationId("btnSelectPatient"));
                    PatientsSelectButton.Click();

                    _PatientSelectDialogWindow = _CAMainWindow.ModalWindow("Patient Select Dialog");
                    var PatientsTab = _PatientSelectDialogWindow.Get(SearchCriteria.ByText("Patients"));
                    PatientsTab.Click();

                    var comboBox = _PatientSelectDialogWindow.Get<ComboBox>(SearchCriteria.ByAutomationId("cmbFacility"));
                    comboBox.Click();

                    //choose Facility
                    int cnt = comboBox.Items.Count;
                    for (int i = 0; i < cnt; i++)
                    {

                        if (String.IsNullOrEmpty(preFacility))
                        {
                            preFacility = comboBox.Items[0].Name;
                        }
                        else if (IsChangeFacility)
                        {
                            if (preFacility == comboBox.Items[i].Name)
                            {
                                if (i == cnt - 1)
                                {
                                    preFacility = comboBox.Items[0].Name;
                                }
                                else
                                {
                                    preFacility = comboBox.Items[i + 1].Name;
                                }
                                IsChangeFacility = false;
                                IsChangeUnit = false;
                            }
                            break;
                        }
                    }
                    comboBox.Click();
                    comboBox.Select(preFacility);
                    Thread.Sleep(1000);

                    _PatientSelectDialogWindow.Get(SearchCriteria.ByText("Unit Row 0")).DoubleClick();
                    var DataGridView_Table = _PatientSelectDialogWindow.Get<Table>(SearchCriteria.ByAutomationId("dgvUnits"));

                    //TableRow testRow = null;
                    int unitcnt = DataGridView_Table.Rows.Count;

                    //if there is no unit, change to next unit
                    if (unitcnt == 0)
                    {
                        IsChangeFacility = true;
                        isAnalysisable = false;
                    }
                    //else
                    //{
                    //    isAnalysisable = true;
                    //}
                  

                    for (int i = 0; i < unitcnt; i++)
                    {
                        //in case there is no beds under this unit
                        if (IsChangeFacility)
                        {
                            _PatientSelectDialogWindow.Get(SearchCriteria.ByAutomationId("mCloseButton")).Click();
                            break;
                        }
                            
                        if (i != preUnitPos)
                        {
                            continue;
                        }
                        if (IsChangeUnit)
                        {
                            if (preUnitPos == unitcnt - 1)
                            {
                                preUnitPos = 0;
                                IsChangeFacility = true;
                            }
                            else
                            {
                                preUnitPos++;
                            }
                            IsChangeUnit = false;
                            preBedname = "";
                            _PatientSelectDialogWindow.Close();
                            break;
                        }
                        string pos = i.ToString();
                        _PatientSelectDialogWindow.Get(SearchCriteria.ByText("Unit Row " + preUnitPos)).DoubleClick();
                        var PatientsDatagrid2 = _PatientSelectDialogWindow.Get<Table>(SearchCriteria.ByAutomationId("dgvPatients"));

                        //if there is no bed in this unit, change to next unit
                        if (PatientsDatagrid2.Rows.Count == 0)
                        {
                            IsChangeUnit = true;
                            isAnalysisable = false;
                            _PatientSelectDialogWindow.Get(SearchCriteria.ByAutomationId("mCloseButton")).Click();
                            break;
                        }

                        for (int j = 0; j < PatientsDatagrid2.Rows.Count; j++)  //TableRow row in PatientsDatagrid2.Rows
                        {
                            if (String.IsNullOrEmpty(preBedname))
                            {
                                preBedname = (string)PatientsDatagrid2.Rows[j].Cells[0].Value;
                                isAnalysisable = true;
                                try
                                {
                                    PatientsDatagrid2.Rows[j].Click();
                                }
                                catch (Exception e)
                                {
                                    Console.WriteLine("test case BedsideData exception" + e.Message.ToString());
                                }
                                break;
                            }
                            else if ((string)PatientsDatagrid2.Rows[j].Cells[0].Value == preBedname)
                            {
                                if (j == PatientsDatagrid2.Rows.Count - 1)
                                {
                                    IsChangeUnit = true;
                                    preBedname = "";
                                    _PatientSelectDialogWindow.Close();
                                    break;
                                }
                                preBedname = (string)PatientsDatagrid2.Rows[j + 1].Cells[0].Value;
                                isAnalysisable = true;
                                try
                                {
                                    PatientsDatagrid2.Rows[j + 1].Click();
                                }
                                catch (Exception e)
                                {
                                    Console.WriteLine("test case BedsideData exception" + e.Message.ToString());
                                }
                                break;
                            }
                        }

                        break; //unit loop
                    }

                    if (isAnalysisable)
                    {
                        //click Waveforms
                        var WaveformsView = _CAMainWindow.Get(SearchCriteria.ByText(MainToolbarBtn));
                        WaveformsView.Click();

                        DoAnalysis(_CAMainWindow, preBedname);
                    }
                    
                }
                catch (Exception e)
                {
                    Thread.Sleep(10000);
                    InserttoFile("error", e.Message);
                    Window ErrorWindow = _CAMainWindow.ModalWindow("Error");
                    ErrorWindow.Get<Button>(SearchCriteria.ByText("OK")).Click();
                }

            }
        }

        public static void InserttoFile(string file, string info)
        {
            string path = Directory.GetCurrentDirectory();
            string filename = file + @".txt";
            string filepath = path + @"\" + filename;

            if (!File.Exists(filepath))
            {
                File.Create(filepath).Dispose();
                using (TextWriter tw = new StreamWriter(filepath))
                {
                    tw.WriteLine(info);
                    tw.Close();
                }
            }
            else if (File.Exists(filepath))
            {
                using (StreamWriter w = File.AppendText(filepath))
                {
                    w.WriteLine(info);
                    w.Close();
                }
            }
        }
    }
}
