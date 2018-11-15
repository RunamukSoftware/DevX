using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Grpc.Core;

namespace gRPCConsoleApp1
{
    class Program
    {
        static void Main(string[] args)
        {
            ServerServiceDefinition.Builder builder = new ServerServiceDefinition.Builder();
            Grpc.Core.Server server = new Server();
            server.Services.Add(ServerServiceDefinition.Builder

        }
    }
}
