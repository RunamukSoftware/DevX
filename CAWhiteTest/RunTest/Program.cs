using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Net.Mail;
using System.Text;
using System.Xml;
using System.IO;
using System.Collections;
using CommonTest;
using System.Threading;
using TestStack.White;
using TestStack.White.UIItems.WindowItems;
using TestStack.White.UIItems.Finders;
using System.Windows.Automation;
using TestStack.White.UIItems.WPFUIItems;
using TestStack.White.UIItems;
using TestStack.White.Factory;
using System.Configuration;
using System.Data.SqlClient;

namespace runtest
{
    class Program
    {
        static void Main(string[] args)
        {
            Hashtable configHT = Config.ReadConfig();
            string CAAppPath = (string)configHT["ExePath"];

            if ((args.Length == 0) || ((args.Length == 1) && (args[0] == "CAWhiteTest")))
            {
                //start CSApp
                SetUpCAApp(CAAppPath);

                //Run regression tests
                RunRegression(new string[] { "CAWhiteTest" });

                //Close CSApp
                CloseCSApp(CAAppPath);

                //process the result to make it more readable
                string result = ReadXMLResult();
                WriteToFile(result);

                //save result to database
                SaveToDatabase(null, result);
            }
            //if no args, just give help info
            else if ((args[0] == "h") || (args[0] == "H") || (args[0] == "help") || (args[0] == "Help"))
            {
                //for example: RunTest.exe CAWhiteTest BedsideView ParameterSelection
                Console.WriteLine(
                        "If run all the test cases in dll, run RunTest.exe dllname" + "\n" +
                        "If run the whole suite, run RunTest.exe dllname suitename; " + "\n" +
                        "If run one single test case, run RunTest.exe dllname suitename testname" + "\n" +
                        "For example: RunTest.exe CAWhiteTest BedsideView ParameterSelection");
            }
            else if ((args[0] == "CAWhiteTest"))
            {
                //start CSApp
                SetUpCAApp(CAAppPath);

                ////Run regression tests
                RunRegression(args);

                //Close CSApp
                CloseCSApp(CAAppPath);

                //process the result to make it more readable
                string result = ReadXMLResult();
                WriteToFile(result);

            }
            return;
        }

        static void SaveToDatabase(string version, string result)
        {
            Hashtable configHT = Config.ReadConfig();
            string CAAppPath = (string)configHT["ExePath"];
            string CAExeFile = CAAppPath + @"\ClinicalHistoryXP.exe"; 
            FileInfo latestExeInfo = new FileInfo(CAExeFile);
            DateTime latestExeCreationTime = latestExeInfo.LastWriteTime;

            int pass = 0;
            int fail = 0;
            string[] resultArr = result.Split(new Char[] { '\n' });
            foreach (string str in resultArr)
            {
                if (str.StartsWith("Testsuite"))
                {
                    string[] oneArr = str.Split(new Char[] { ':', ';', '\r' }, StringSplitOptions.RemoveEmptyEntries);
                    pass += Convert.ToInt32(oneArr[3]);
                    fail += Convert.ToInt32(oneArr[5]);
                }
            }

            string connectionString = ConfigurationManager.AppSettings["DBConnectStr"];
            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    if (!String.IsNullOrEmpty(version))
                    {
                        SqlCommand cmd = new SqlCommand("INSERT INTO ca(version, time, pass, fail) VALUES(@version, @time, @pass, @fail)", connection);
                        cmd.Parameters.AddWithValue("@version", version);
                        cmd.Parameters.AddWithValue("@time", latestExeCreationTime);
                        cmd.Parameters.AddWithValue("@pass", pass);
                        cmd.Parameters.AddWithValue("@fail", fail);

                        cmd.ExecuteNonQuery();
                    }
                    else
                    {
                        SqlCommand cmd = new SqlCommand("INSERT INTO ca(time, pass, fail) VALUES(@time, @pass, @fail)", connection);
                        cmd.Parameters.AddWithValue("@time", latestExeCreationTime);
                        cmd.Parameters.AddWithValue("@pass", pass);
                        cmd.Parameters.AddWithValue("@fail", fail);

                        cmd.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
            }
        }

        static void RunRegression(string[] args)
        {
            ProcessStartInfo startInfo = new ProcessStartInfo(@"nunit3-console.exe");

            //if no args, just give help info
            if (!args[0].Contains("CAWhiteTest") || (args.Length > 3))
            {
                return;
            }
            //1 args with dll name
            else if (args.Length == 1)
            {
                startInfo.Arguments = args[0] + @".dll";
            }
            //2 args with dll name, namespace and suite name
            else if (args.Length == 2)
            {
                startInfo.Arguments = args[0] + @".dll" + @" --test=" + args[0] + @"." + args[1];
            }
            //3 args with dll name, suite name, and test case name
            else if (args.Length == 3)
            {
                startInfo.Arguments = args[0] + @".dll" + @" --test=" + args[0] + @"." + args[1] + @"." + args[2];
            }

            var process = Process.Start(startInfo);

            //wait for the testing process finish
            process.WaitForExit();
        }

        static void WriteToFile(string result)
        {
            string dateStr = DateTime.Now.ToString("yyyyMMdd");
            string path = @".\" + "TestResult" + "_" + dateStr + @".txt";

            if (!File.Exists(path))
            {
                File.Create(path).Dispose();
                using (TextWriter tw = new StreamWriter(path))
                {
                    string[] resultArr = result.Split(new Char[] { '\n' });
                    foreach (string line in resultArr)
                    {
                        tw.WriteLine(line);
                    }
                    tw.Close();
                }
            }
            else if (File.Exists(path))
            {
                using (StreamWriter w = File.AppendText(path))
                {
                    string[] resultArr = result.Split(new Char[] { '\n' });
                    foreach (string line in resultArr)
                    {
                        w.WriteLine(line);
                    }
                    w.Close();
                }
            }
        }

        static string ReadXMLResult()
        {
            StringBuilder sb = new StringBuilder();
            Dictionary<string, string> tmp = new Dictionary<string, string>();

            XmlTextReader reader = new XmlTextReader("TestResult.xml");
            while (reader.Read())
            {
                switch (reader.NodeType)
                {
                    case XmlNodeType.Element: // The node is an element.
                        {
                            if (reader.Name == "test-suite")
                            {
                                tmp = new Dictionary<string, string>();
                                while (reader.MoveToNextAttribute())
                                {
                                    tmp.Add(reader.Name, reader.Value);
                                }
                                if (tmp["type"] == "TestFixture")
                                {
                                    string suitename = tmp["fullname"];
                                    string passedStr = tmp["passed"];
                                    int passed = Convert.ToInt32(passedStr);
                                    string failedStr = tmp["failed"];
                                    int failed = Convert.ToInt32(failedStr);
                                    double successrate = (passed) / (passed + failed);  //Math.round(value,2); 
                                    successrate = Math.Round(successrate, 2);

                                    sb.AppendLine("Testsuite: " + suitename + ";  Num of Passed: " + passedStr + "; num of Failed: " + failedStr);
                                }
                            }
                            else if (reader.Name == "test-case")
                            {
                                tmp = new Dictionary<string, string>();
                                while (reader.MoveToNextAttribute())
                                {
                                    tmp.Add(reader.Name, reader.Value);
                                }
                                if (tmp["result"] == "Failed")
                                {
                                    string failedcase = tmp["fullname"];
                                    sb.AppendLine("Failed case: " + failedcase);
                                }
                            }
                        }
                        break;
                    case XmlNodeType.Text: //Display the text in each element.
                        Console.WriteLine(reader.Value);
                        break;
                    case XmlNodeType.EndElement: //Display the end of the element.
                        Console.Write("");

                        break;
                }
            }

            return sb.ToString();
        }

        static void SetUpCAApp(string CAAppPath)
        {
            string exeArg = "ClinicalHistoryXP.exe";
            Process process = new Process();

            var startInfo = new ProcessStartInfo
            {
                WorkingDirectory = CAAppPath, 
                WindowStyle = System.Diagnostics.ProcessWindowStyle.Normal,
                FileName = "cmd.exe",
                RedirectStandardInput = true,
                UseShellExecute = false
            };
            process.StartInfo = startInfo;
            process.Start();

            process.StandardInput.WriteLine(exeArg);

            Thread.Sleep(2000);

            process.StandardInput.WriteLine("exit");

            //CLose "Patient Select Dialog" Window
            string CAAppExe = CAAppPath + @"\ClinicalHistoryXP.exe";
            var psi = new ProcessStartInfo(CAAppExe);
            Application _CAApp = Application.AttachOrLaunch(psi);
            Window _CAMainWindow = _CAApp.GetWindow(SearchCriteria.ByAutomationId("ClinicalAccess"), InitializeOption.NoCache);
            Window _PatientSelectDialogWindow = _CAMainWindow.ModalWindow("Patient Select Dialog");
            _PatientSelectDialogWindow.Get(SearchCriteria.ByAutomationId("buCancel")).Click();
        }

        static void CloseCSApp(string CAAppPath)
        {
            string CAAppExe = CAAppPath + @"\ClinicalHistoryXP.exe";
            var psi = new ProcessStartInfo(CAAppExe);
            Application _CAApp = Application.AttachOrLaunch(psi);
            Window _CAMainWindow = _CAApp.GetWindow(SearchCriteria.ByAutomationId("ClinicalAccess"), InitializeOption.NoCache);

            _CAApp.Close();
            _CAApp.Dispose();

        }

    }
}