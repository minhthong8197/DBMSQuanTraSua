using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.Linq;

namespace DBMSQuanTraSua.LopNghiepVu
{
    class ConvertClass
    {
        public DataTable ToDataTable(System.Data.Linq.DataContext ctx, object query)
        {
            if (query == null)
            {
                throw new ArgumentNullException("query");
            }
            IDbCommand cmd = ctx.GetCommand((IQueryable)query);
            System.Data.SqlClient.SqlDataAdapter adapter = new System.Data.SqlClient.SqlDataAdapter();
            adapter.SelectCommand = (System.Data.SqlClient.SqlCommand)cmd;
            DataTable dt = new DataTable("dataTbl");
            cmd.Connection.ConnectionString = DynamicConnection.connectstr;
            try
            {
                cmd.Connection.Open();
                adapter.FillSchema(dt, SchemaType.Source);
                adapter.Fill(dt);
            }
            finally
            {
                adapter.FillSchema(dt, SchemaType.Source);
                adapter.Fill(dt);
                cmd.Connection.Close();
            }
            return dt;
        }
    }
}
