using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using DBMSQuanTraSua.LopNghiepVu;
using System.Data.SqlClient;

namespace DBMSQuanTraSua.LopGiaoDien
{
    public partial class UCTaiKhoan : UserControl
    {
        DBMSQuanTraSuaDataContext DB = new DBMSQuanTraSuaDataContext(DynamicConnection.connectstr);
        NVTaiKhoan nv = new NVTaiKhoan();
        DataTable table = null;
        public event EventHandler NeedReload;

        public UCTaiKhoan()
        {
            InitializeComponent();
        }

        private void btnTaoTaiKhoan_Click(object sender, EventArgs e)
        {
            try
            {
                nv.TaoTaiKhoan(txtMaNV.Text.ToString(), txtpass.Text.ToString(), cbxVaiTro.Text);
            }
            catch (SqlException a)
            {
                MessageBox.Show(a.Message);
            }
        }

        static void conn_InfoMessage(object sender, SqlInfoMessageEventArgs e)
        {
            MessageBox.Show("Lỗi: " +
                e.Errors[0].Class.ToString() + ":" + e.Message);
        }

        private void btnDoiPass_Click(object sender, EventArgs e)
        {
            if (this.pnlDoipass.Visible == false)
            {
                this.pnlDoipass.Visible = true;
            }
            else this.pnlDoipass.Visible = false;
        }

        private void btnOKDoi_Click(object sender, EventArgs e)
        {
            nv.DoiPass(cbxLogin.Text.ToString(), cbxNewPass.Text.ToString());
        }
    }
}
