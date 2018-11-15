using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ParseNumberSet_TEST
{
    class Program
    {
        static void Main(string[] args)
        {
            HashSet<string> numberset = ParseNumberSet(@"1000-1100, 2000", "key");

        }

        /// <summary>
        /// Parses string containing comma-delimited list of integers, or integer ranges.
        /// Duplicate numbers are stripped out.
        /// </summary>
        /// <param name="strNumberSet">string to convert</param>
        /// <returns>A Hash set with all the numbers</returns>
        /// <exception cref="ConfigurationErrorsException">When more then 2 values are included in the range, when values are not integers</exception>
        private static HashSet<string> ParseNumberSet(string strNumberSet, string key)
        {
            var allNodeIds = new List<string>();

            if (string.IsNullOrWhiteSpace(strNumberSet))
                return new HashSet<string>();

            try
            {
                var entries = new HashSet<string>(strNumberSet.Split(new string[] { "," },
                                                                StringSplitOptions.RemoveEmptyEntries));
                foreach (var entry in entries)
                {
                    if (entry.Contains("-"))// range
                    {
                        var range = entry.Split(new string[] { "-" }, StringSplitOptions.RemoveEmptyEntries);
                        //if (range.Length != 2) throw new ConfigurationErrorsException(
                        //    string.Format(CultureInfo.InvariantCulture, "Invalid configuration entry for {0}: {1}", key, entry));
                        if (range.Length != 2) throw new Exception(string.Format(CultureInfo.InvariantCulture, "Invalid configuration entry for {0}: {1}", key, entry));

                        var rangeBegin = int.Parse(range[0], CultureInfo.InvariantCulture);
                        var rangeEnd = int.Parse(range[1], CultureInfo.InvariantCulture);

                        allNodeIds.AddRange(Enumerable.Range(Math.Min(rangeBegin, rangeEnd), Math.Abs(rangeEnd - rangeBegin) + 1).Select(intValue => intValue.ToString(CultureInfo.InvariantCulture)));
                    }
                    else
                        allNodeIds.Add(entry);
                }
            }
            catch (FormatException ex)
            {
                //throw new ConfigurationErrorsException("Non-integer node IDs are not allowed in " + key + ".\n Error: " + ex);
                throw new Exception("Non-integer node IDs are not allowed in " + key + ".\n Error: " + ex);
            }

            return new HashSet<string>(allNodeIds.Distinct());
        }
    }
}
