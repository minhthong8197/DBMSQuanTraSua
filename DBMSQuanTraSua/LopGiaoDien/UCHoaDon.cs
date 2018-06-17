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
    public partial class UCHoaDon : UserControl
    {
        DBMSQuanTraSuaDataContext DB = new DBMSQuanTraSuaDataContext(DynamicConnection.connectstr);
        NVHoaDon nv = new NVHoaDon();
        DataTable table = null;
        public event EventHandler NeedReload;


        //biến xử lí thao tác
        bool dangthem = false, dangcapnhat = false;
        public UCHoaDon()
        {
            InitializeComponent();
        }
        private void FormLoad()
        {
            //vô hiệu hóa btn
            this.btnLuu.Enabled = false;
            this.btnHuy.Enabled = false;
            //khởi động các btn
            this.btnThem.Enabled = true;
            this.btnXoa.Enabled = true;
            this.btnCapNhat.Enabled = true;
            //khoi dong panel
            pnlTextBox.Enabled = false;
            this.pnlMaHD.Enabled = true;
            //xóa các biến cờ
            this.dangthem = false;
            this.dangcapnhat = false;
            try
            {
                table = nv.LoadHoaDon();
                dgvMain.DataSource = table;
                dgvMain.AutoResizeColumns();

                cbxNguoilap.DataSource = nv.DsNhanVien();
                cbxNguoilap.DisplayMember = "TenNV";
                cbxNguoilap.ValueMember = "MaNV";
            }
            catch
            {
                MessageBox.Show("Có lỗi! Không load được dữ liệu");
            }
        }

        private void dgvMain_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            // Thứ tự dòng hiện hành
            int r = dgvMain.CurrentCell.RowIndex;
            // Chuyển thông tin lên panel
            try
            {
                if (dgvMain.Rows[r].Cells[0].Value == null) this.txtMaHD.Text = "";
                else this.txtMaHD.Text = dgvMain.Rows[r].Cells[0].Value.ToString();
            }
            catch { }
            try
            {
                if (dgvMain.Rows[r].Cells[1].Value == null) this.cbxNguoilap.Text = "";
                else this.cbxNguoilap.Text = dgvMain.Rows[r].Cells[1].Value.ToString();
            }
            catch { }
            try
            {
                if (dgvMain.Rows[r].Cells[2].Value == null) this.txtMaKH.Text = "";
                else this.txtMaKH.Text = dgvMain.Rows[r].Cells[2].Value.ToString();
            }
            catch { }
            try
            {
                if (dgvMain.Rows[r].Cells[4].Value == null) this.txtTongtien.Text = "";
                else this.txtTongtien.Text = dgvMain.Rows[r].Cells[4].Value.ToString();
            }
            catch { }

        }

        private void btnThem_Click(object sender, EventArgs e)
        {
            //khởi động panel
            this.pnlTextBox.Enabled = true;
            //khởi động cac btn
            this.btnLuu.Enabled = true;
            this.btnHuy.Enabled = true;
            //vô hiệu hóa cac btn
            this.btnThem.Enabled = false;
            this.btnCapNhat.Enabled = false;
            this.btnXoa.Enabled = false;
            //bật cờ hiệu đang thêm
            this.dangthem = true;
        }

        private void btnCapNhat_Click(object sender, EventArgs e)
        {
            //khoi dong panel
            this.pnlTextBox.Enabled = true;
            //khoi dong cac btn
            this.btnLuu.Enabled = true;
            this.btnHuy.Enabled = true;
            //vo hieu hoa cac btn
            this.btnThem.Enabled = false;
            this.btnCapNhat.Enabled = false;
            this.btnXoa.Enabled = false;
            this.pnlMaHD.Enabled = false;
            //bật cờ hiệu đang sửa
            this.dangcapnhat = true;
        }

        private void btnXoa_Click(object sender, EventArgs e)
        {
            if (this.txtMaHD.Text == "")
            {
                MessageBox.Show("Vui lòng chọn hóa đơn muốn xóa!");
                return;
            }
            DialogResult xoadialog;
            xoadialog = MessageBox.Show("Bạn thật sự muốn xóa hóa đơn này!", ""
                , MessageBoxButtons.YesNo, MessageBoxIcon.Information);
            if (xoadialog == DialogResult.Yes)
            {
                //try
                //{
                //    nv.XoaNhanVien(this.txtMaNhanVien.Text);
                //    NeedReload.Invoke(this, e);
                //    MessageBox.Show("Đã xóa thành công!");
                //}
                //catch (SqlException a)
                //{ MessageBox.Show(a.Message); }
            }
        }

        private void btnHuy_Click(object sender, EventArgs e)
        {
            NeedReload.Invoke(this, e);
        }

        private void btnLuu_Click(object sender, EventArgs e)
        {
            if (this.txtMaHD.Text != "")
            {
                if (this.dangthem == true)
                {
                    try
                    {
                        nv.ThemHoaDon(txtMaHD.Text.ToString(), cbxNguoilap.SelectedValue.ToString(), txtMaKH.Text.ToString());
                        NeedReload.Invoke(this, e);
                        MessageBox.Show("Thêm thành công!");
                    }
                    catch (SqlException a)
                    {
                        MessageBox.Show(a.Message);
                        return;
                    }
                }
                else if (this.dangcapnhat == true)
                {
                    //try
                    //{
                    //    nv.UpdateNhanVien(txtMaNhanVien.Text.ToString(), txtHoTen.Text.ToString(), cbxGioiTinh.Text.ToString(),
                    //        dtpNgaySinh.Value, txtCMND.Text.ToString(), txtSoDienThoai.Text.ToString(),
                    //        txtDiaChi.Text.ToString(), dtpNgayBatDau.Value, txtChucVu.Text.ToString(),
                    //        txtMucLuong.Text.ToString(), cbxQuayLamViec.SelectedValue.ToString());
                    //    NeedReload.Invoke(this, e);
                    //    MessageBox.Show("Cập nhật thành công!");
                    //}
                    //catch (SqlException a)
                    //{
                    //    MessageBox.Show(a.Message);
                    //    return;
                    //}
                }
            }
            else if (this.txtMaHD.Text == "") MessageBox.Show("Bạn chưa điền mã hóa đơn!");
        }

        private void UCHoaDon_Load(object sender, EventArgs e)
        {
            FormLoad();
        }

        private void btnLoc_Click(object sender, EventArgs e)
        {
            if (this.pnlBoloc.Visible == false)
            {
                this.pnlBoloc.Visible = true;
                this.pnlChiTiet.Visible = false;
            }
            else this.pnlBoloc.Visible = false;
        }

        private void btnChiTiet_Click(object sender, EventArgs e)
        {
            if (this.pnlChiTiet.Visible == false)
            {
                this.pnlChiTiet.Visible = true;
                this.pnlBoloc.Visible = false;
            }
            else this.pnlChiTiet.Visible = false;
        }

        private void btnOKLoc_Click(object sender, EventArgs e)
        {

        }

        static void conn_InfoMessage(object sender, SqlInfoMessageEventArgs e)
        {
            MessageBox.Show("Lỗi: " +
                e.Errors[0].Class.ToString() + ":" + e.Message);
        }
    }
}
