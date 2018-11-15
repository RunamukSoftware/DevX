using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Runtime.Serialization;
using System.Runtime.Serialization.Formatters.Binary;
using System.Text;
using System.Threading.Tasks;

namespace Serialize
{
    class Program
    {
        const string ConnectionString = @"Server=PER730XD.etlabnet.local\SS17;Database=SerialData;Trusted_Connection=True;";
        const int MaxCount = 100000;

        static void Main(string[] args)
        {
            int rowsWritten = MaxCount;
            DateTime startDateTime;
            DateTime endDateTime;

            //Console.WriteLine(DateTime.Now);
            startDateTime = DateTime.Now;

            for (int count = 0; count < MaxCount; count++)
            {
                WriteSqlData();
            }

            endDateTime = DateTime.Now;
            WritePerformance("WriteSqlData", rowsWritten, startDateTime, endDateTime);

            //Console.WriteLine(DateTime.Now);
            startDateTime = DateTime.Now;

            for (int count = 0; count < MaxCount; count++)
            {
                WriteSqlDataBinary();
            }

            endDateTime = DateTime.Now;
            WritePerformance("WriteSqlDataBinary", rowsWritten, startDateTime, endDateTime);

            //Console.WriteLine(DateTime.Now);

            //SerializeMe();
        }

        private static void WriteSqlData()
        {
            SqlConnection conn = new SqlConnection(ConnectionString);
            conn.Open();
            SqlCommand cmd = new SqlCommand(@"
INSERT INTO [dbo].[MyClass] ([FirstName], [LastName], [DateOfBirth], [Gender], [Ethnicity], [DecimalData], [Notes])
VALUES (@FirstName, @Lastname, @DateOfBirth, @Gender, @Ethnicity, @DecimalData, @Notes);
", conn);

            MyClass myClass = new MyClass();
            //myClass.MyClassID = 1000000;
            myClass.FirstName = "Anthony";
            myClass.LastName = "Green";
            myClass.DateOfBirth = DateTime.Parse("1962-08-04");
            myClass.Gender = "Male";
            myClass.Ethnicity = "Caucasian";
            myClass.DecimalData = 3.14159M;
            myClass.Notes = "Awesome SQL Server database programmer!" + new String('X', 700);

            //cmd.Parameters.AddWithValue("@MyClassID", myClass.MyClassID);
            cmd.Parameters.AddWithValue("@FirstName", myClass.FirstName);
            cmd.Parameters.AddWithValue("@LastName", myClass.LastName);
            cmd.Parameters.AddWithValue("@DateOfBirth", myClass.DateOfBirth);
            cmd.Parameters.AddWithValue("@Gender", myClass.Gender);
            cmd.Parameters.AddWithValue("@Ethnicity", myClass.Ethnicity);
            cmd.Parameters.AddWithValue("@DecimalData", myClass.DecimalData);
            cmd.Parameters.AddWithValue("@Notes", myClass.Notes);

            cmd.ExecuteNonQuery();

            conn.Close();
        }

        private static void WriteSqlDataBinary()
        {
            SqlConnection conn = new SqlConnection(ConnectionString);
            conn.Open();
            SqlCommand cmd = new SqlCommand(@"
INSERT INTO [dbo].[MyClassBinary]([DataBytes])
VALUES (@DataBytes);
", conn);

            MyClass myClass = new MyClass();
            myClass.MyClassID = 1000000;
            myClass.FirstName = "Anthony";
            myClass.LastName = "Green";
            myClass.DateOfBirth = DateTime.Parse("1962-08-04");
            myClass.Gender = "Male";
            myClass.Ethnicity = "Caucasian";
            myClass.DecimalData = 3.14159M;
            myClass.Notes = "Awesome SQL Server database programmer!" + new String('X', 700);

            //cmd.Parameters.AddWithValue("@MyClassBinaryID", myClass.MyClassID);
            IFormatter formatter = new BinaryFormatter();
            MemoryStream stream = new MemoryStream();
            formatter.Serialize(stream, myClass);
            SqlParameter parameter = cmd.Parameters.Add("@DataBytes", SqlDbType.VarBinary);
            parameter.Value = stream.ToArray();

            cmd.ExecuteNonQuery();

            conn.Close();
        }

        public static void WritePerformance(string dataType, int rowsWritten, DateTime startDateTime, DateTime endDateTime)
        {
            Console.WriteLine(@"Data Type: {0}  Rows Written: {1}  Start: {2}  End: {3}", dataType, rowsWritten, startDateTime, endDateTime);

            SqlConnection conn = new SqlConnection(ConnectionString);
            conn.Open();
            SqlCommand cmd = new SqlCommand(@"
INSERT INTO [dbo].[Performance]
    (
        [DataType],
        [RowsWritten],
        [StartDateTime],
        [EndDateTime]
    )
VALUES
    (
        @DataType,
        @RowsWritten,
        @StartDateTime,
        @EndDateTime
    );
", conn);
            cmd.Parameters.AddWithValue("@DataType", dataType);
            cmd.Parameters.AddWithValue("@RowsWritten", rowsWritten);
            cmd.Parameters.AddWithValue("@StartDateTime", startDateTime);
            cmd.Parameters.AddWithValue("@EndDateTime", endDateTime);

            cmd.ExecuteNonQuery();

            conn.Close();
        }

        private static void SerializeMe()
        {
            MyClass myClass = new MyClass();
            myClass.MyClassID = 10000;
            myClass.FirstName = "Anthony";
            myClass.LastName = "Green";
            myClass.DateOfBirth = DateTime.Parse("1962-08-04");
            myClass.Gender = "Male";
            myClass.Ethnicity = "Caucasian";
            myClass.Notes = "Awesome SQL Server database programmer!";

            IFormatter formatter = new BinaryFormatter();
            MemoryStream stream = new MemoryStream();
            formatter.Serialize(stream, myClass);

            Console.WriteLine(Encoding.Default.GetString(stream.ToArray()));

            stream.Position = 0;
            MyClass newClass = (MyClass)formatter.Deserialize(serializationStream: stream);
            Console.WriteLine(newClass.MyClassID);
            Console.WriteLine(newClass.FirstName);
            Console.WriteLine(newClass.LastName);
            Console.WriteLine(newClass.DateOfBirth);
            Console.WriteLine(newClass.Gender);
            Console.WriteLine(newClass.Ethnicity);
            Console.WriteLine(newClass.Notes);
        }
    }
}
