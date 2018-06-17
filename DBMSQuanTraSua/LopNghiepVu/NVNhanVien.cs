using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DBMSQuanTraSua.LopNghiepVu;
using System.Data;

namespace DBMSQuanTraSua.LopNghiepVu
{
    class NVNhanVien
    {
        DBMSQuanTraSuaDataContext DB = new DBMSQuanTraSuaDataContext();
        ConvertClass convert = null;

        public DataTable LoadNhanVien()
        {
            DB.Connection.ConnectionString = DynamicConnection.connectstr;
            convert = new ConvertClass();
            var query = DB.ufuTimKiemNhanVienTheoTen("");
            return convert.ToDataTable(DB, query);
        }

        public void ThemNhanVien(string MaNhanVien,string HoTen,string GioiTinh,DateTime NgaySinh,
            string CMND,string SoDienThoai,string DiaChi,DateTime NgayVaoLam,
            string ChucVu,string MucLuong,string MaQuay)
        {
            string SafeMaQuay;
            if (MaQuay == "") SafeMaQuay = null;
            else SafeMaQuay = MaQuay;
            
            DB.uspThemNhanVien(MaNhanVien, HoTen, GioiTinh, NgaySinh,
            CMND, SoDienThoai, DiaChi, NgayVaoLam,
            ChucVu, MucLuong, MaQuay, false);
        }

        public void XoaNhanVien(string manv)
        {
            DB.uspXoaNhanVien(manv);
        }

        public void UpdateNhanVien(string MaNhanVien, string HoTen, string GioiTinh, DateTime NgaySinh,
            string CMND, string SoDienThoai, string DiaChi, DateTime NgayVaoLam,
            string ChucVu, string MucLuong, string MaQuay)
        {
            string SafeMaQuay;
            if (MaQuay == "") SafeMaQuay = null;
            else SafeMaQuay = MaQuay;

            DB.uspSuaNhanVien(MaNhanVien, HoTen, GioiTinh, NgaySinh,
            CMND, SoDienThoai, DiaChi, NgayVaoLam,
            ChucVu, MucLuong, MaQuay);
        }

        public DataTable TimKiemNhanVien(string hoten)
        {
            convert = new ConvertClass();
            var query = DB.ufuTimKiemNhanVienTheoTen(hoten);
            return convert.ToDataTable(DB, query);
        }

        public object DsQuayLamViec()
        {
            var dsQuayLamViec = from q in DB.TB_Quays
                           select new
                           {
                               MaQuay = q.MaQuay,
                               TenQuay = q.TenQuay,
                           };
            return dsQuayLamViec;
        }

        public void DinhChiNhanVien(string manv)
        {
            DB.uspChoNghiViec(manv);
        }

        //public object DsNganh()
        //{
        //    var dsNganh = from n in doiCTXH.Thanhviens
        //                  group n by n.Nganh into g
        //                  select new
        //                  {
        //                      Nganh = g.Key,
        //                  };
        //    return dsNganh;
        //}

        //public object DsQueQuan()
        //{
        //    var dsQueQuan = from tv in doiCTXH.Thanhviens
        //                    group tv by tv.Quequan into g
        //                    select new { QueQuan = g.Key };
        //    return dsQueQuan;
        //}

        //public object DsNamSinh()
        //{
        //    var dsNamSinh = from tv in doiCTXH.Thanhviens
        //                    group tv by tv.Ngaysinh.Value.Year into g
        //                    select new
        //                    {
        //                        NamSinh = g.Key.ToString()
        //                    };
        //    return dsNamSinh;
        //}

        //public DataTable LocTheoKhoaDV(string makhoadv)
        //{
        //    ConvertClass convert = new ConvertClass();
        //    var query = doiCTXH.fu_Loc_TheoKhoaDV(makhoadv);
        //    return convert.ToDataTable(doiCTXH, query);
        //}

        //public DataTable LocTheoKhoa(string khoadaotao)
        //{
        //    ConvertClass convert = new ConvertClass();
        //    var query = doiCTXH.fu_Loc_TheoKhoahoc(khoadaotao);
        //    return convert.ToDataTable(doiCTXH, query);
        //}

        //public DataTable LocTheoNamSinh(string namsinh)
        //{
        //    int temp = int.Parse(namsinh);
        //    ConvertClass convert = new ConvertClass();
        //    var query = doiCTXH.fu_Loc_TheoNamsinh(temp);
        //    return convert.ToDataTable(doiCTXH, query);
        //}
    }
}
