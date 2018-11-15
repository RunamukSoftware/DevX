namespace SqlBulkCopyExample
{
    using System;
    using System.Collections.Generic;
    using System.Data;
    using System.Data.SqlClient;
    using System.Diagnostics;
    using System.Linq;
    using SqlBulkCopyExample.Properties;

    class Program
    {
        static void Main(string[] args)
        {
            var people = CreateSamplePeople(10000);
            //var server = "localhost";
            var server = "PER730XD"; // 48ms and 4053ms

            using (var connection = new SqlConnection($"Server={server};Database=MostWanted;Integrated Security=SSPI"))
            {
                connection.Open();

                var stopwatch = new Stopwatch();

                // ------ SQL Bulk Insert
                // Warm up...
                //RecreateDatabase(connection);
                //InsertDataUsingSqlBulkCopy(people, connection);

                // Measure
                stopwatch.Start();
                InsertDataUsingSqlBulkCopy(people, connection);
                Console.WriteLine("Bulk copy: {0}ms", stopwatch.ElapsedMilliseconds);

                // ------ Insert statements
                // Warm up...
                //RecreateDatabase(connection);
                //InsertDataUsingInsertStatements(people, connection);

                // Measure
                stopwatch.Reset();
                stopwatch.Start();
                InsertDataUsingInsertStatements(people, connection);
                Console.WriteLine("Individual insert statements: {0}ms", stopwatch.ElapsedMilliseconds);
            }

            Console.ReadLine();
        }

        private static void InsertDataUsingInsertStatements(IEnumerable<Person> people, SqlConnection connection)
        {
            using (var command = connection.CreateCommand())
            {
                command.CommandText = "INSERT INTO dbo.Person (Name, DateOfBirth) VALUES (@Name, @DateOfBirth)";
                var nameParam = command.Parameters.Add("@Name", SqlDbType.NVarChar);
                var dobParam = command.Parameters.Add("@DateOfBirth", SqlDbType.DateTime);
                foreach (var person in people)
                {
                    nameParam.Value = person.Name;
                    dobParam.Value = person.DateOfBirth;
                    command.ExecuteNonQuery();
                }
            }
        }

        private static void InsertDataUsingSqlBulkCopy(IEnumerable<Person> people, SqlConnection connection)
        {
            var bulkCopy = new SqlBulkCopy(connection);
            bulkCopy.DestinationTableName = "dbo.Person";
            bulkCopy.ColumnMappings.Add("Name", "Name");
            bulkCopy.ColumnMappings.Add("DateOfBirth", "DateOfBirth");

            using (var dataReader = new ObjectDataReader<Person>(people))
            {
                bulkCopy.WriteToServer(dataReader);
            }
        }

        private static void RecreateDatabase(SqlConnection connection)
        {
            using (var command = connection.CreateCommand())
            {
                command.CommandText = Resources.CreateDatabase;
                command.CommandType = CommandType.Text;
                command.ExecuteNonQuery();
            }
        }

        private static IEnumerable<Person> CreateSamplePeople(int count)
        {
            return Enumerable.Range(0, count)
                .Select(i => new Person
                {
                    Name = "Person" + i,
                    DateOfBirth = new DateTime(1950 + (i % 50), ((i * 3) % 12) + 1, ((i * 7) % 29) + 1)
                });
        }
    }
}
