using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;

namespace DBMSQuanTraSua.LopNghiepVu
{
   
    class NVHoaDon
    {
        DBMSQuanTraSuaDataContext DB = new DBMSQuanTraSuaDataContext();

        public DataTable LoadHoaDon()
        {
            DB.Connection.ConnectionString = DynamicConnection.connectstr;
            ConvertClass convert = new ConvertClass();
            var query = DB.ufuLayHoaDon();
            return convert.ToDataTable(DB, query);
        }

        //public DataTable LocHoaDon()
        //{
        //    ConvertClass convert = new ConvertClass();
        //    //var query = DB.ufuLocHoaDon();
        //    //return convert.ToDataTable(DB, query);
        //}

        public void ThemHoaDon(string MaHoaDon, string MaNhanVien, string MaKhachHang)
        {
            if (MaNhanVien == "") return;

            DB.uspThemHoaDon(MaHoaDon, MaNhanVien, MaKhachHang, 0);
        }

        public object DsNhanVien()
        {
            var dsNhanVien = from nv in DB.TB_NhanViens
                             where nv.ChucVu != "Nhân viên"
                                select new
                                {
                                    MaNV = nv.MaNhanVien,
                                    TenNV = nv.HoTen,
                                };
            return dsNhanVien;
        }
    }
}
