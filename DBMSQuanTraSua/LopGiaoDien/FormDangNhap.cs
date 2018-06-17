using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using DBMSQuanTraSua.LopNghiepVu;

namespace DBMSQuanTraSua.LopGiaoDien
{
    public partial class FormDangNhap : Form
    {
        //cac bien dieu khien thanh tieu de
        Boolean drag = false;
        int mousex;
        int mousey;

        string userName { get; set; }
        string passWord { get; set; }
        string ip { get; set; }
        string DatabaseName { get; set; }
        //NVDangNhap nv = new NVDangNhap();
        DBMSQuanTraSuaDataContext DB = new DBMSQuanTraSuaDataContext();

        public FormDangNhap()
        {
            InitializeComponent();
        }

        private void btnClose_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }

        private void btnSignIn_Click(object sender, EventArgs e)
        {
            //Kiểm tra đã nhập đủ các dữ liệu
            if (txtUsername.TextLength > 0 && txtPassword.TextLength > 0 && txtIP.TextLength > 0)
            {
                this.userName = this.txtUsername.Text;
                this.ip = this.txtIP.Text;
                this.passWord = this.txtPassword.Text;
                string conn = "Data Source=" + this.ip + ";" + "User ID="
                    + this.userName + ";" + "Password=" + this.passWord + ";";
                DynamicConnection.connectstr = conn;
                DB = new DBMSQuanTraSuaDataContext(DynamicConnection.connectstr);
                DB.Connection.ConnectionString = conn;
                try
                {
                    DB.Connection.Open();
                }
                catch
                {
                    MessageBox.Show("KHÔNG THỂ KẾT NỐI ĐẾN SERVER NÀY!");
                    return;
                }
                if (DB.Connection.State == ConnectionState.Open)
                {
                    this.pnlFirstTextBox.Visible = false;
                    this.pnlSecondTextBox.Visible = true;
                    this.AcceptButton = this.btnConnect;
                    DataTable databases = DB.Connection.GetSchema("databases");
                    if (databases != null)
                    {
                        foreach (DataRow database in databases.Rows)
                        {
                            string databaseName = database.Field<string>("Database_Name");
                            if (databaseName != "master" && databaseName != "model"
                                && databaseName != "tempdb" && databaseName != "msdb"
                                && databaseName != "ReportServer$SQLEXPRESS"
                                && databaseName != "ReportServer$SQLEXPRESSTempDB")
                                    this.cbxDatabase.Items.Add(databaseName);
                        }
                    }

                }
            }
            else
            {
                MessageBox.Show("Vui lòng nhập đầy đủ thông tin!");
                return;
            }
        }

        private void pnlTop_MouseUp(object sender, MouseEventArgs e)
        {
            drag = false;
        }

        private void pnlTop_MouseMove(object sender, MouseEventArgs e)
        {
            if (drag == true)
            {
                this.Top = Cursor.Position.Y - mousey;
                this.Left = Cursor.Position.X - mousex;
            }
        }

        private void pnlTop_MouseDown(object sender, MouseEventArgs e)
        {
            drag = true;
            mousex = Cursor.Position.X - this.Left;
            mousey = Cursor.Position.Y - this.Top;
        }

        private void btnConnect_Click(object sender, EventArgs e)
        {
            if (this.cbxDatabase.Text == "")
            {
                MessageBox.Show("Vui lòng chọn cơ sở dữ liệu!");
                return;
            }
            this.DatabaseName = this.cbxDatabase.Text.ToString();
            DB.Connection.Close();
            string conn = "Data Source=" + this.ip + ";"
                + "Initial Catalog=" + this.DatabaseName + ";"
                + "User ID=" + this.userName + ";"
                + "Password=" + this.passWord + ";";
            DB.Connection.ConnectionString = conn;
            DynamicConnection.connectstr = conn;
            try
            {
                DB.Connection.Open();
            }
            catch
            {
                MessageBox.Show("KHÔNG ĐỦ QUYỀN HẠN KẾT NỐI ĐẾN CƠ SỞ DỮ LIỆU NÀY!");
                return;
            }
            this.Close();
        }
    }
}
