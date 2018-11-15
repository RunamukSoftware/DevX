using System;
using System.Collections.Generic;
using System.Linq;
using System.ServiceProcess;
using System.Text;
using System.Threading.Tasks;

//namespace WindowsService1
//{
//    static class Program
//    {
//        /// <summary>
//        /// The main entry point for the application.
//        /// </summary>
//        static void Main()
//        {
//            ServiceBase[] ServicesToRun;
//            ServicesToRun = new ServiceBase[]
//            {
//                new WindowsServiceHarness()
//            };
//
//            ServiceBase.Run(ServicesToRun);
//        }
//    }
//}

 
namespace WindowsService1
{
    static class Program
    {
        // The main entry point for the windows service application.
        static void Main(string[] args)
        {
            using(var implementation = new ServiceImplementation())
            {
                // if started from console, file explorer, etc, run as console app.
                if (Environment.UserInteractive)
                {
                    ConsoleHarness.Run(args, implementation);
                }
                else // otherwise run as a windows service
                {
                    ServiceBase.Run(new WindowsServiceHarness(implementation));
                }
                }
        }
    }
}
