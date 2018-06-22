-----------------------------------------------------------------------------
-------------------------------------------------------------- Phân quyền
-----------------------------------------------------------------------------

use QuanTraSua;
create ROLE administrator;
GRANT select,update,delete,insert ON TB_ChiTietHoaDon to administrator
GRANT select,update,delete,insert ON TB_ChiTietNguyenLieu to administrator
GRANT select,update,delete,insert ON TB_HoaDon to administrator
GRANT select,update,delete,insert ON TB_KhachHang to administrator
GRANT select,update,delete,insert ON TB_LoaiSanPham to administrator
GRANT select,update,delete,insert ON TB_NguyenLieu to administrator
GRANT select,update,delete,insert ON TB_NhanVien to administrator
GRANT select,update,delete,insert ON TB_SanPham to administrator
GRANT select,update,delete,insert ON TB_TaiKhoan to administrator
--GRANT execute on usp
--GRANT 
go
create ROLE nhanvienquanly;
GRANT select,update,delete,insert ON TB_ChiTietHoaDon to nhanvienquanly
GRANT select,update,delete,insert ON TB_ChiTietNguyenLieu to nhanvienquanly
GRANT select,update,delete,insert ON TB_HoaDon to nhanvienquanly
GRANT select,update,delete,insert ON TB_KhachHang to nhanvienquanly
GRANT select,update,delete,insert ON TB_LoaiSanPham to nhanvienquanly
GRANT select,update,delete,insert ON TB_NguyenLieu to nhanvienquanly
GRANT select,update,delete,insert ON TB_NhanVien to nhanvienquanly
GRANT select,update,delete,insert ON TB_SanPham to nhanvienquanly
--GRANT execute on usp
go
create ROLE nhanvienthungan;
GRANT select,update,delete,insert ON TB_ChiTietHoaDon to nhanvienthungan
GRANT select,update,delete,insert ON TB_HoaDon to nhanvienthungan
GRANT select,update,delete,insert ON TB_KhachHang to nhanvienthungan
GRANT select,update,delete,insert ON TB_SanPham to nhanvienthungan
go
--GRANT execute on usp
If Exists (select loginname from master.dbo.syslogins where name = 'chuquan')
begin try
	drop login admin
	drop user urchuquan
end try
begin catch
end catch
go
create login admin with password = '@Minhthong8197';
create user urchuquan for login chuquan;
exec sp_addrolemember  administrator, urchuquan;
go

use QuanTraSua;
GRANT EXECUTE ON DATABASE::QuanTraSua TO administrator

GRANT execute ON uspSuaNhanVien to nhanvienquanly
GRANT execute ON uspThemNhanVien to nhanvienquanly
GRANT execute ON uspTinhThoiGianLamViecTaiQuan to nhanvienquanly
GRANT execute ON uspTachChuoi to nhanvienquanly
GRANT execute ON uspDoiMatKhau to nhanvienquanly
GRANT execute ON uspMaHoaChuoi to nhanvienquanly
GRANT execute ON uspGiaiMaChuoi to nhanvienquanly
GRANT select ON ufuLayHoaDon to nhanvienquanly
GRANT select ON ufuLocHoaDon to nhanvienquanly
GRANT select ON ufuThongKeDoanhThuThang to nhanvienquanly
GRANT select ON ufuTimKiemNhanVienTheoTen to nhanvienquanly
GRANT execute ON ufuDemSoNhanVienConLamViec to nhanvienquanly
GRANT execute ON ufuTinhTienThuTheoThang to nhanvienquanly

GRANT execute ON uspTachChuoi to nhanvienthungan
GRANT execute ON uspDoiMatKhau to nhanvienthungan
GRANT execute ON uspMaHoaChuoi to nhanvienthungan
GRANT execute ON uspGiaiMaChuoi to nhanvienthungan
GRANT select ON ufuLayHoaDon to nhanvienthungan
GRANT select ON ufuLocHoaDon to nhanvienthungan
GRANT select ON ufuThongKeDoanhThuThang to nhanvienthungan
GRANT execute ON ufuTinhTienThuTheoThang to nhanvienthungan
go