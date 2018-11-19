using System;
using System.Data;
using System.Data.SqlClient;

namespace GetOriginalLogin
{
    internal class Program
    {
        private static void Main(string[] args)
        {
            SqlConnectionStringBuilder connectionBuilder = new SqlConnectionStringBuilder();

            connectionBuilder.ApplicationName = "GetOriginalLogin";
            connectionBuilder.DataSource = @"PER730XD.etlabnet.local\SS17";
            connectionBuilder.InitialCatalog = "portal";
            connectionBuilder.UserID = "portal";
            connectionBuilder.Password = "Portal_1";

            SqlConnection connection = new SqlConnection(connectionBuilder.ConnectionString);
            connection.Open();

            SqlCommand command = new SqlCommand(@"SELECT ORIGINAL_LOGIN(), USER_ID(), USER_NAME(), SYSTEM_USER, SUSER_NAME(), SUSER_SNAME(), SUSER_SID();", connection);

            SqlDataReader reader = command.ExecuteReader(CommandBehavior.CloseConnection);
            while (reader.Read())
            {
                Console.WriteLine(@"ORIGINAL_LOGIN(): {0}", reader.GetSqlString(0));
                Console.WriteLine(@"USER_ID(): {0}", reader.GetSqlInt16(1));
                Console.WriteLine(@"USER_NAME(): {0}", reader.GetSqlString(2));
                Console.WriteLine(@"SYSTEM_USER: {0}", reader.GetSqlString(3));
                Console.WriteLine(@"SUSER_NAME(): {0}", reader.GetSqlString(4));
                Console.WriteLine(@"SUSER_SNAME(): {0}", reader.GetSqlString(5));

                //SqlBytes suserSid = reader.GetSqlBytes(6);
                //Console.WriteLine(@"SUSER_SID(): {0}", suserSid);
            }

            Console.WriteLine("\r\nPress Enter to finish.");
            Console.ReadLine();
        }
    }
}