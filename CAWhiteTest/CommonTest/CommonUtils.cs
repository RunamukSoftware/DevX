using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CommonTest
{
    public class Config
    {
        static public Hashtable ReadConfig()
        {
            Hashtable configHT = new Hashtable();
            //string configFile = Path.GetFullPath(Path.Combine(Directory.GetCurrentDirectory(), @"..\..\..\")) + @"config.txt";
            string configFile = @"config.txt";

            if (File.Exists(configFile))
            {
                string[] lines = File.ReadAllLines(configFile);

                foreach (string line in lines)
                {
                    string[] pairs = line.Split(new[] { "\t", "=" }, StringSplitOptions.RemoveEmptyEntries);
                    if (pairs.Length > 1)
                    {
                        configHT.Add(pairs[0], pairs[1]);
                    }
                }
            }
            return configHT;
        }
    }
    public class TestLog
    {
        static public void WriteLog(string testinfo)
        {
            string dateStr = DateTime.Now.ToString("yyyyMMdd");
            string path = @".\" + "TestLog_" + dateStr + @".txt";

            if (!File.Exists(path))
            {
                File.Create(path).Dispose();
                using (TextWriter tw = new StreamWriter(path))
                {
                    tw.WriteLine(testinfo);
                    tw.Close();
                }
            }
            else if (File.Exists(path))
            {
                using (StreamWriter w = File.AppendText(path))
                {
                    w.WriteLine(testinfo);
                    w.Close();
                }
            }
        }
    }
}
