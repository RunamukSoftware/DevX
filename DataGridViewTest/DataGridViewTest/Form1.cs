using System.Collections;
using System.Data;
using System.Data.SqlClient;
using System.Threading;
using System.Windows.Forms;

namespace DataGridViewTest
{
    public partial class Form1 : System.Windows.Forms.Form
    {
        private BindingSource bindingSource1 = new BindingSource();

        public Form1()
        {
            InitializeComponent();

            this.Controls.Add(dataGridView1);
            InitializeDataGridView();

            //Thread.Sleep(5000);

            //LoadData();
        }

        private void InitializeDataGridView()
        {
            try
            {
                DataTable dt = new DataTable("DataGridData");
                dt.Columns.Add("Loading...");
                dt.Rows.Add("Log Data...");

                bindingSource1.DataSource = dt;
                dataGridView1.DataSource = bindingSource1;
            }
            catch (SqlException ex)
            {
                MessageBox.Show("Exception: " + ex.ToString(), "FATAL ERROR",
                    MessageBoxButtons.OK, MessageBoxIcon.Exclamation);

                //System.Threading.Thread.CurrentThread.Abort();
            }
        }

        private void LoadData()
        {
            // Set up the data source.
            bindingSource1.DataSource = GetData("SELECT * FROM [dbo].[int_starter_set];");
            dataGridView1.DataSource = bindingSource1;
        }

        private static DataTable GetData(string sqlCommand)
        {
            string connectionString = "Integrated Security=SSPI;Persist Security Info=False;" +
                "Initial Catalog=portal;Data Source=localhost";

            SqlConnection connection = new SqlConnection(connectionString);

            SqlCommand command = new SqlCommand(sqlCommand, connection);
            SqlDataAdapter adapter = new SqlDataAdapter();
            adapter.SelectCommand = command;

            DataTable table = new DataTable();
            table.Locale = System.Globalization.CultureInfo.InvariantCulture;
            adapter.Fill(table);

            return table;
        }
    }
}
