using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AdoNetTest
{
    class Program
    {
        static void Main(string[] args)
        {
            SqlConnection conn = new SqlConnection();

            //conn.ConnectionString = @"Provider=SQLNCLI11;Server=PER730XD.etlabnet.local\SS17;Database=portal;Integrated Security=SSPI;DataTypeCompatibility=80;MARS Connection=True;";
            //conn.ConnectionString = @"Server=PER730XD.etlabnet.local\SS17;Database=portal;Integrated Security=SSPI;";
            //conn.ConnectionString = @"Server=PER730XD.etlabnet.local\SS17;Database=portal;User Id=portal;Password=Portal_1;";
            conn.ConnectionString = @"Provider=SQLNCLI12;Server=PER730XD.etlabnet.local\SS17;Database=portal;User Id=portal;Password=Portal_1;";
            conn.Open();
            Console.WriteLine(conn);

            conn.Close();
        }
    }
}
