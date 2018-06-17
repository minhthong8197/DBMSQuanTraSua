using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using DBMSQuanTraSua.LopGiaoDien;
using DBMSQuanTraSua.LopNghiepVu;

namespace DBMSQuanTraSua
{
    public partial class FormMain : Form
    {
        DBMSQuanTraSuaDataContext DB;
        FormDangNhap dangNhap;
        UCBanHang banhang;
        UCDoanhSo doanhso;
        UCHoaDon hoadon;
        UCKhachHang khachhang;
        UCNguyenLieu nguyenlieu;
        UCNhanVien nhanvien;
        UCSanPham sanpham;
        UCTaiKhoan taikhoan;

        //cac bien ho tro xu li keo re form
        Boolean drag = false;
        int mousex;
        int mousey;

        public FormMain()
        {
            InitializeComponent();
            dangNhap = new FormDangNhap();
        }

        private void btnClose_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void btnMaximize_Click(object sender, EventArgs e)
        {
            if (WindowState == FormWindowState.Maximized)
                WindowState = FormWindowState.Normal;
            else if (WindowState == FormWindowState.Normal)
                WindowState = FormWindowState.Maximized;
        }

        private void btnMinimize_Click(object sender, EventArgs e)
        {
            WindowState = FormWindowState.Minimized;
        }

        private void btnMore_Click(object sender, EventArgs e)
        {
            if (this.pnlLeft.Width == 250)
            {
                this.pnlLeft.Width = 50;
                this.btnMore.Dock = DockStyle.Left;
                this.pnlLogo_Info.Visible = false;
                this.pnlMain.Width = 1228;
            }
            else if (this.pnlLeft.Width == 50)
            {
                this.pnlLeft.Width = 250;
                this.btnMore.Dock = DockStyle.Right;
                this.pnlLogo_Info.Visible = true;
                this.pnlMain.Width = 1028;
            }
        }

        private void FormMain_Load(object sender, EventArgs e)
        {
            dangNhap.ShowDialog();
            DB = new DBMSQuanTraSuaDataContext(DynamicConnection.connectstr);
            this.pnlMain.Controls.Clear();
        }

        private void pnlTitleBar_MouseMove(object sender, MouseEventArgs e)
        {
            if (drag == true)
            {
                this.Top = Cursor.Position.Y - mousey;
                this.Left = Cursor.Position.X - mousex;
            }
        }

        private void pnlTitleBar_MouseDown(object sender, MouseEventArgs e)
        {
            drag = true;
            mousex = Cursor.Position.X - this.Left;
            mousey = Cursor.Position.Y - this.Top;
        }

        private void pnlTitleBar_MouseUp(object sender, MouseEventArgs e)
        {
            drag = false;
        }

        private void btnNhanSu_Click(object sender, EventArgs e)
        {
            if (this.pnlListNhanSu.Visible == true)
                this.pnlListNhanSu.Visible = false;
            else this.pnlListNhanSu.Visible = true;
        }

        private void btnKinhDoanh_Click(object sender, EventArgs e)
        {
            if (this.pnlListKinhDoanh.Visible == true)
                this.pnlListKinhDoanh.Visible = false;
            else this.pnlListKinhDoanh.Visible = true;
        }

        private void btnPhanQuyen_Click_1(object sender, EventArgs e)
        {
            if (this.pnlListPhanQuyen.Visible == true)
                this.pnlListPhanQuyen.Visible = false;
            else this.pnlListPhanQuyen.Visible = true;
        }

        private void btnNhanVien_Click(object sender, EventArgs e)
        {
            this.pnlMain.Controls.Clear();
            nhanvien = new UCNhanVien();
            this.pnlMain.Controls.Add(nhanvien);
            nhanvien.Dock = DockStyle.Fill;
            nhanvien.NeedReload += new EventHandler(btnNhanVien_Click);
        }

        private void btnHoaDon_Click(object sender, EventArgs e)
        {
            this.pnlMain.Controls.Clear();
            hoadon = new UCHoaDon();
            this.pnlMain.Controls.Add(hoadon);
            hoadon.Dock = DockStyle.Fill;
            hoadon.NeedReload += new EventHandler(btnHoaDon_Click);
        }

        private void btnDoanhSo_Click(object sender, EventArgs e)
        {
            this.pnlMain.Controls.Clear();
            doanhso = new UCDoanhSo();
            this.pnlMain.Controls.Add(doanhso);
            doanhso.Dock = DockStyle.Fill;
            //nhanvien.NeedReload += new EventHandler(btnCongTacVien_Click);
        }

        private void btnTaiKhoan_Click(object sender, EventArgs e)
        {
            this.pnlMain.Controls.Clear();
            taikhoan = new UCTaiKhoan();
            this.pnlMain.Controls.Add(taikhoan);
            taikhoan.Dock = DockStyle.Fill;
            //nhanvien.NeedReload += new EventHandler(btnCongTacVien_Click);
        }
    }
}
