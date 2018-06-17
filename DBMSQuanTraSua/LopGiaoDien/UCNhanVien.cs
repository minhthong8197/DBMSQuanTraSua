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
    public partial class UCNhanVien : UserControl
    {
        DBMSQuanTraSuaDataContext DB = new DBMSQuanTraSuaDataContext(DynamicConnection.connectstr);
        NVNhanVien nv = new NVNhanVien();
        DataTable table = null;
        public event EventHandler NeedReload;

        //biến xử lí thao tác
        bool dangthem = false, dangcapnhat = false;

        public UCNhanVien()
        {
            InitializeComponent();
        }

        private void FormLoad()
        {
            //vô hiệu hóa btn
            this.btnLuu.Enabled = false;
            this.btnHuy.Enabled = false;
            //khởi động các btn
            this.btnCapNhat.Enabled = true;
            this.btnThem.Enabled = true;
            this.btnXoa.Enabled = true;
            this.pnlMaNhanVien.Enabled = true;
            //điều chỉnh dữ liệu trong panel

            this.dtpNgaySinh.Value = dtpNgaySinh.MinDate;

            //vô hiệu hóa panel
            this.pnlTextBox.Enabled = false;
            this.pnlTextBox2.Enabled = false;
            //xóa các biến cờ
            this.dangthem = false;
            this.dangcapnhat = false;
            try
            {
                dgvMain.DataSource = nv.LoadNhanVien();
                dgvMain.AutoResizeColumns();

                cbxQuayLamViec.DataSource = nv.DsQuayLamViec();
                cbxQuayLamViec.DisplayMember = "TenQuay";
                cbxQuayLamViec.ValueMember = "MaQuay";
            }
            catch
            {
                MessageBox.Show("Có lỗi! Không load được dữ liệu");
            }
        }

        private void btnThem_Click(object sender, EventArgs e)
        {
            //khởi động panel
            this.pnlTextBox.Enabled = true;
            this.pnlTextBox2.Enabled = true;
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
            this.pnlTextBox2.Enabled = true;
            //khoi dong cac btn
            this.btnLuu.Enabled = true;
            this.btnHuy.Enabled = true;
            //vo hieu hoa cac btn
            this.btnThem.Enabled = false;
            this.btnCapNhat.Enabled = false;
            this.btnXoa.Enabled = false;
            this.pnlMaNhanVien.Enabled = false;
            //bật cờ hiệu đang sửa
            this.dangcapnhat = true;
        }

        private void btnXoa_Click(object sender, EventArgs e)
        {
            if (this.txtMaNhanVien.Text == "")
            {
                MessageBox.Show("Vui lòng chọn nhân viên muốn xóa!");
                return;
            }
            DialogResult xoadialog;
            xoadialog = MessageBox.Show("Bạn thật sự muốn xóa nhân viên này!", ""
                , MessageBoxButtons.YesNo, MessageBoxIcon.Information);
            if (xoadialog == DialogResult.Yes)
            {
                try
                {
                    nv.XoaNhanVien(this.txtMaNhanVien.Text);
                    NeedReload.Invoke(this, e);
                    MessageBox.Show("Đã xóa thành công!");
                }
                catch (SqlException a)
                { MessageBox.Show(a.Message); }
            }
        }

        private void btnHuy_Click(object sender, EventArgs e)
        {
            NeedReload.Invoke(this, e);
        }

        private void dgvMain_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            // Thứ tự dòng hiện hành
            int r = dgvMain.CurrentCell.RowIndex;
            // Chuyển thông tin lên panel
            try
            {
                if (dgvMain.Rows[r].Cells[0].Value == null) this.txtMaNhanVien.Text = "";
                else this.txtMaNhanVien.Text = dgvMain.Rows[r].Cells[0].Value.ToString();
            }
            catch { }

            try
            {
                if (dgvMain.Rows[r].Cells[1].Value == null) this.txtHoTen.Text = "";
                else this.txtHoTen.Text = dgvMain.Rows[r].Cells[1].Value.ToString();
            }
            catch { }

            try
            {
                if (dgvMain.Rows[r].Cells[2].Value == null) this.cbxGioiTinh.Text = "";
                else this.cbxGioiTinh.Text = dgvMain.Rows[r].Cells[2].Value.ToString();
            }
            catch { }

            try
            {
                if (dgvMain.Rows[r].Cells[3].Value == null) this.dtpNgaySinh.Value = dtpNgaySinh.MinDate;
                else this.dtpNgaySinh.Value = System.Convert.ToDateTime(dgvMain.Rows[r].Cells[3].Value);
            }
            catch { }

            try
            {
                if (dgvMain.Rows[r].Cells[4].Value == null) this.txtCMND.Text = "";
                else this.txtCMND.Text = dgvMain.Rows[r].Cells[4].Value.ToString();
            }
            catch { }

            try
            {
                if (dgvMain.Rows[r].Cells[5].Value == null) this.txtSoDienThoai.Text = "";
                else this.txtSoDienThoai.Text = dgvMain.Rows[r].Cells[5].Value.ToString();
            }
            catch { }

            try
            {
                if (dgvMain.Rows[r].Cells[6].Value == null) this.txtDiaChi.Text = "";
                else this.txtDiaChi.Text = dgvMain.Rows[r].Cells[6].Value.ToString();
            }
            catch { }

            try
            {
                if (dgvMain.Rows[r].Cells[7].Value == null) this.dtpNgayBatDau.Value = dtpNgayBatDau.MinDate;
                else this.dtpNgayBatDau.Value = Convert.ToDateTime(dgvMain.Rows[r].Cells[7].Value);
            }
            catch { }

            try
            {
                if (dgvMain.Rows[r].Cells[8].Value == null) this.txtChucVu.Text = "";
                else this.txtChucVu.Text = dgvMain.Rows[r].Cells[8].Value.ToString();
            }
            catch { }

            try
            {
                if (dgvMain.Rows[r].Cells[9].Value == null) this.txtMucLuong.Text = "";
                else this.txtMucLuong.Text = dgvMain.Rows[r].Cells[9].Value.ToString();
            }
            catch { }

            try
            {
                if (dgvMain.Rows[r].Cells[10].Value == null) this.cbxQuayLamViec.Text = "";
                else this.cbxQuayLamViec.Text = dgvMain.Rows[r].Cells[10].Value.ToString();
            }
            catch { }

            try
            {
                if (dgvMain.Rows[r].Cells[11].Value == null) this.cbxNghiViec.Text = "";
                else this.cbxNghiViec.Text = dgvMain.Rows[r].Cells[11].Value.ToString();
            }
            catch { }
        }

        private void btnLuu_Click(object sender, EventArgs e)
        {
            if (this.txtMaNhanVien.Text != "")
            {
                if (this.dangthem == true)
                {
                    try
                    {
                        nv.ThemNhanVien(txtMaNhanVien.Text.ToString(), txtHoTen.Text.ToString(), cbxGioiTinh.Text.ToString(),
                            dtpNgaySinh.Value, txtCMND.Text.ToString(), txtSoDienThoai.Text.ToString(),
                            txtDiaChi.Text.ToString(), dtpNgayBatDau.Value, txtChucVu.Text.ToString(),
                            txtMucLuong.Text.ToString(), cbxQuayLamViec.SelectedValue.ToString());

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
                    try
                    {
                        nv.UpdateNhanVien(txtMaNhanVien.Text.ToString(), txtHoTen.Text.ToString(), cbxGioiTinh.Text.ToString(),
                            dtpNgaySinh.Value, txtCMND.Text.ToString(), txtSoDienThoai.Text.ToString(),
                            txtDiaChi.Text.ToString(), dtpNgayBatDau.Value, txtChucVu.Text.ToString(),
                            txtMucLuong.Text.ToString(), cbxQuayLamViec.SelectedValue.ToString());
                        NeedReload.Invoke(this, e);
                        MessageBox.Show("Cập nhật thành công!");
                    }
                    catch (SqlException a)
                    {
                        MessageBox.Show(a.Message);
                        return;
                    }
                }
            }
            else if (this.txtMaNhanVien.Text == "") MessageBox.Show("Bạn chưa điền mã nhân viên!");
        }
        static void conn_InfoMessage(object sender, SqlInfoMessageEventArgs e)
        {
            MessageBox.Show("Lỗi: " +
                e.Errors[0].Class.ToString() + ":" + e.Message);
        }
        //private void btnBoLoc_Click(object sender, EventArgs e)
        //{
        //    if (this.pnlBoloc.Visible == false)
        //    {
        //        this.pnlTimKiem.Visible = false;
        //        this.pnlBoloc.Visible = true;
        //        cbxLocKhoaDV.DataSource = nghiepvu.DsKhoaDV();
        //        cbxLocKhoaDV.DisplayMember = "KhoaDV";
        //        cbxLocKhoaDV.ResetText();

        //        cbxLocKhoa.DataSource = nghiepvu.DsKhoa();
        //        cbxLocKhoa.DisplayMember = "TenKhoa";
        //        cbxLocKhoa.ValueMember = "MaKhoa";
        //        cbxLocKhoa.ResetText();
        //        cbxLocKhoa.SelectedText = null;

        //        cbxLocNamSinh.DataSource = nghiepvu.DsNamSinh();
        //        cbxLocNamSinh.DisplayMember = "NamSinh";
        //        cbxLocNamSinh.ResetText();
        //    }
        //    else this.pnlBoloc.Visible = false;
        //}

        private void btnOKTimKiem_Click(object sender, EventArgs e)
        {
            this.dgvMain.DataSource = nv.TimKiemNhanVien(this.txtTimKiem.Text);
        }

        //private void btnOKLoc_Click(object sender, EventArgs e)
        //{
        //    if (this.cbxLocKhoaDV.Text != "")
        //    {
        //        this.dgvMain.DataSource = nv.LocTheoKhoaDV(cbxLocKhoaDV.Text);
        //    }
        //    else if (this.cbxLocKhoa.Text != "")
        //    {
        //        this.dgvMain.DataSource = nghiepvu.LocTheoKhoa(cbxLocKhoa.SelectedValue.ToString());
        //    }
        //    else if (this.cbxLocNamSinh.Text != "")
        //    {
        //        this.dgvMain.DataSource = nghiepvu.LocTheoNamSinh(cbxLocNamSinh.Text);
        //    }
        //}

        //private void cbxLocKhoaDV_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    this.cbxLocKhoa.ResetText();
        //    this.cbxLocKhoa.SelectedText = null;
        //    this.cbxLocNamSinh.ResetText();
        //}

        //private void cbxLocKhoa_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    this.cbxLocNamSinh.ResetText();
        //    this.cbxLocKhoaDV.ResetText();
        //}

        //private void cbxLocNamSinh_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    this.cbxLocKhoa.ResetText();
        //    this.cbxLocKhoa.SelectedText = null;
        //    this.cbxLocKhoaDV.ResetText();
        //}

        private void UCNhanVien_Load(object sender, EventArgs e)
        {
            FormLoad();
        }

        private void btnDinhChi_Click(object sender, EventArgs e)
        {
            if (this.txtMaNhanVien.Text != "")
                try
                {
                    nv.DinhChiNhanVien(this.txtMaNhanVien.Text.ToString());
                    MessageBox.Show("Đã xong!");
                }
                catch (SqlException a)
                {
                    MessageBox.Show(a.Message);
                    return;
                }
            else MessageBox.Show("Bạn chưa nhập mã nhân viên");
        }

        private void btnTim_Click(object sender, EventArgs e)
        {
            if (this.pnlTimKiem.Visible == false)
            {
                this.pnlTimKiem.Visible = true;
                this.pnlBoloc.Visible = false;
            }
            else this.pnlTimKiem.Visible = false;
        }
    }
}
