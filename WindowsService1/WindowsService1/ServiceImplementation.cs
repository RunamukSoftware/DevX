using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WindowsService1
{
    public class ServiceImplementation : IWindowsService
    {
        // This method is called when the service gets a request to start.
        public void OnStart(string[] args)
        {
            Console.WriteLine("OnStart");
        }

        // This method is called when the service gets a request to stop.
        public void OnStop()
        {
            Console.WriteLine("OnStop");
        }

        // This method is called when a service gets a request to pause, 
        // but not stop completely.
        public void OnPause()
        {
            Console.WriteLine("OnPause");
        }

        // This method is called when a service gets a request to resume 
        public void OnContinue()
        {
            Console.WriteLine("OnContinue");
        }

        // This method is called when the machine the service is running on
        public void OnShutdown()
        {
            Console.WriteLine("OnShutdown");
        }

        // dispose any resources
        public void Dispose()
        {
            Console.WriteLine("Dispose");
        }
    }
}
