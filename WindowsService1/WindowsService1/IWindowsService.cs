using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WindowsService1
{
    // The interface that any windows service should implement to be used
    // with the GenericWindowsService executable.
    public interface IWindowsService : IDisposable
    {
        // This method is called when the service gets a request to start.
        void OnStart(string[] args);

        // This method is called when the service gets a request to stop.
        void OnStop();

        // This method is called when a service gets a request to pause, 
        // but not stop completely.
        void OnPause();

        // This method is called when a service gets a request to resume 
        void OnContinue();

        // This method is called when the machine the service is running on
        void OnShutdown();
    }
}
