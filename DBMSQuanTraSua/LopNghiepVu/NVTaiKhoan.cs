using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DBMSQuanTraSua.LopNghiepVu
{
    class NVTaiKhoan
    {
        DBMSQuanTraSuaDataContext DB = new DBMSQuanTraSuaDataContext();

        public void TaoTaiKhoan(string login, string pass, string role)
        {
            DB.uspTaoTaiKhoanSQL(login, pass, role);
            //DB.uspMaHoaChuoi(login, pass, role);
        }

        public void DoiPass(string login, string pass)
        {
            DB.uspDoiMatKhau(login, pass);
            //DB.uspMaHoaChuoi(login, pass, role);
        }
    }
}
