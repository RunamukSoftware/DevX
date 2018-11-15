using System;
using System.Data.SqlClient;
using System.Text;

namespace NetCoreConsoleApp1
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                SqlConnectionStringBuilder builder = new SqlConnectionStringBuilder();
                builder.DataSource = "localhost";
                builder.InitialCatalog = "portal";
                builder.UserID = "sa";
                builder.Password = "Sl_service";
                //builder.IntegratedSecurity = true;

                using (SqlConnection connection = new SqlConnection(builder.ConnectionString))
                {
                    Console.WriteLine("\nQuery data example:");
                    Console.WriteLine("=========================================\n");

                    connection.Open();
                    StringBuilder sb = new StringBuilder();
                    sb.Append("SELECT TOP (10) [Sequence], [CategoryValue], [Type], [Subtype], [Value1], [Value2], [Status], [Valid_Leads], [TopicSessionId], [FeedTypeId], [TimestampUTC] FROM [dbo].[EventsData] AS [ed];");
                    String sql = sb.ToString();

                    using (SqlCommand command = new SqlCommand(sql, connection))
                    {
                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                Console.WriteLine("{0} {1} {2} {3} {4} {5} {6} {7} {8} {9} {10}",
                                    reader.GetInt64(0), reader.GetInt32(1), reader.GetInt32(2), reader.GetInt32(3), reader.GetSqlSingle(4), reader.GetSqlSingle(5), reader.GetSqlInt32(6), reader.GetSqlInt32(7), reader.GetSqlGuid(8), reader.GetSqlGuid(9), reader.GetSqlDateTime(10));
                            }
                        }
                    }
                }
            }
            catch (SqlException e)
            {
                Console.WriteLine(e.ToString());
            }

            Console.ReadLine();
        }
    }
}
