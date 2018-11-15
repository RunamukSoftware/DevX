using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Serialize
{
    [Serializable]
    public class MyClass
    {
        public int MyClassID { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public DateTime DateOfBirth { get; set; }
        public string Gender { get; set; }
        public string Ethnicity { get; set; }
        public decimal DecimalData { get; set; }
        public string Notes { get; set; }

        public MyClass()
        {
            MyClassID = 0;
            FirstName = "";
            LastName = "";
            DateOfBirth = DateTime.MinValue;
            Gender = "Male";
            Ethnicity = "Caucasian";
            Notes = "";
        }
    }
}
