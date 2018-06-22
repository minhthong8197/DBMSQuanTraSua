-----------------------------------------------------------------------------
-------------------------------------------------------------- Tạo cơ sở dữ liệu
-----------------------------------------------------------------------------

create database QuanTraSua
GO
use QuanTraSua
GO
create table TB_DonVi
(
	MaDonVi nvarchar(10) primary key,
	TenDonVi nvarchar(30)
)
go
create table TB_Quay
(
	MaQuay nvarchar(10) primary key,
	TenQuay nvarchar(30),
	SoLuongNhanVien int check(SoLuongNhanVien >= 0),
)
go
create table TB_NguyenLieu
(
	MaNguyenLieu nvarchar(10) primary key,
	TenNguyenLieu nvarchar(30),
	MaDonVi nvarchar(10),
	Gia int check(Gia >= 0),
	TamKhoa bit default 0,
	foreign key (MaDonVi) references TB_DonVi(MaDonVi)on delete set null on update cascade
)
go
create table TB_LoaiSanPham
(
	MaLoaiSanPham nvarchar(10) primary key,
	TenLoaiSanPham nvarchar(30),
	SoLuong int check(SoLuong >= 0)
)
go
create table TB_SanPham
(
	MaSanPham nvarchar(10) primary key,
	TenSanPham nvarchar(30),
	Gia int check(Gia >= 0),
	MaDonVi nvarchar(10),
	MaLoaiSanPham nvarchar(10),
	TamKhoa bit default 0,
	foreign key (MaDonVi) references TB_DonVi(MaDonVi) on delete set null on update cascade,
	foreign key (MaLoaiSanPham) references TB_LoaiSanPham(MaLoaiSanPham) on delete set null on update cascade
)
go
create table TB_ChiTietNguyenLieu
(
	MaSanPham nvarchar(10),
	MaNguyenLieu nvarchar(10),
	SoLuong int check(SoLuong >= 0),
	primary key (MaSanPham,MaNguyenLieu),
	foreign key (MaSanPham) references TB_SanPham(MaSanPham),
	foreign key (MaNguyenLieu) references TB_NguyenLieu(MaNguyenLieu)on delete cascade on update cascade,
)
go
create table TB_NhanVien
(
	MaNhanVien nvarchar(10) primary key,
	HoTen nvarchar(30),
	GioiTinh nvarchar(30),
	NgaySinh date,
	CMND nvarchar(30),
	SoDienThoai nvarchar(30),
	DiaChi nvarchar(30),
	NgayVaoLam date,
	ChucVu nvarchar(30),
	MucLuong nvarchar(30),
	MaQuay nvarchar(10),
	TamKhoa bit default 0,
	foreign key (MaQuay) references TB_Quay(MaQuay) on delete set null on update cascade
)
go
create table TB_TaiKhoan
(
	TenDangNhap nvarchar(30) primary key,
	MatKhau nvarchar(30) not null,
	MaNhanVien nvarchar(10),
	VaiTro nvarchar(30),
	TamKhoa bit default 0,
	foreign key (MaNhanVien) references TB_NhanVien(MaNhanVien) on delete set null on update cascade
)
go
create table TB_KhachHang
(
	MaKhachHang nvarchar(10) primary key,
	HoTen nvarchar(30),
	SoDienThoai nvarchar(30),
	DiaChi nvarchar(30),
)
go
create table TB_HoaDon
(
	MaHoaDon nvarchar(10) primary key,
	MaNhanVien nvarchar(10),
	MaKhachHang nvarchar(10),
	ThoiGian date,
	TongTien int check(TongTien >= 0)
	foreign key (MaNhanVien) references TB_NhanVien(MaNhanVien) on delete set null on update cascade,
	foreign key (MaKhachHang) references TB_KhachHang(MaKhachHang)on delete set null on update cascade
)
go
create table TB_ChiTietHoaDon
(
	MaHoaDon nvarchar(10),
	MaSanPham nvarchar(10),
	SoLuong int check(SoLuong >= 0),
	ThanhTien int check(ThanhTien >= 0),
	primary key (MaHoaDon,MaSanPham),
	foreign key (MaHoaDon) references TB_HoaDon(MaHoaDon) on delete cascade on update cascade,
	foreign key (MaSanPham) references TB_SanPham(MaSanPham) on delete cascade on update cascade
)
go

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
--GRANT execute on usp
go
use QuanTraSua
If Exists (select loginname from master.dbo.syslogins where name = 'admin')
begin
	drop login admin
	drop user uradmin
end
go
create login admin with password = '@Minhthong8197';
create user uradmin for login admin;
exec sp_addrolemember  administrator, uradmin;
create login taikhoan1 with password = '@Minhthong8197';
create user urtaikhoan1 for login taikhoan1;
exec sp_addrolemember  nhanvienquanly, urthong001;
create login taikhoan2 with password = '@Minhthong8197';
create user urtaikhoan2 for login taikhoan2;
exec sp_addrolemember  nhanvienthungan, urtaikhoan2;
go
-----------------------------------------------------------------------------
-------------------------------------------------------------- Trigger
-----------------------------------------------------------------------------
use QuanTraSua;go
create trigger CapNhatThoiGian on TB_HoaDon------Nhập thời gian cho hóa đơn
after insert, update
as
begin
	raiserror (N'Thời gian hiện tại sẽ được thêm vào hóa đơn!', 16, 1);
	update TB_HoaDon
	set ThoiGian = GETDATE();
end
go
create trigger TinhTongTienTuDong on TB_ChiTietHoaDon--Tính tổng tiền cho hóa đơn
after insert, update
as
	declare @MaHoaDonCanCapNhat nvarchar(10), @TongTienMoi int
	select @MaHoaDonCanCapNhat = ChiTietHoaDonMoi.MaHoaDon
	from inserted ChiTietHoaDonMoi
	--Tính toán tổng tiền
	select @TongTienMoi = sum(ThanhTien)
	from TB_ChiTietHoaDon
	where TB_ChiTietHoaDon.MaHoaDon = @MaHoaDonCanCapNhat
	--Cập nhật tổng tiền mới
	begin
		update TB_HoaDon
		set TongTien = @TongTienMoi
		where TB_HoaDon.MaHoaDon = @MaHoaDonCanCapNhat
	end
go

create trigger TinhThanhTienTuDong on TB_ChiTietHoaDon--Tính thành tiền cho chi tiết hóa đơn
after insert, update
as
	declare @GiaSP int, @SoLuong int, --dựa trên đơn giá và số lượng để tính ra tiền
			@ThanhTienMoi int, --kết quả cần tìm
			@MaSPTrongChiTietHoaDon nvarchar(10), --dùng để biết sản phẩm này là gì, từ đó tìm ra giá của nó
			@MaHoaDonTrongChiTietHoaDon nvarchar(10) --dùng để tìm đúng chi tiết hóa đơn cần cập nhật giá
	--truy vấn lấy ra các giá trị cần tìm
	select	@GiaSP = TB_SanPham.Gia, @SoLuong = ChiTietHoaDonMoi.SoLuong, 
			@MaSPTrongChiTietHoaDon = ChiTietHoaDonMoi.MaSanPham, 
			@MaHoaDonTrongChiTietHoaDon = ChiTietHoaDonMoi.MaHoaDon
	from TB_SanPham, inserted ChiTietHoaDonMoi
	where ChiTietHoaDonMoi.MaSanPham = TB_SanPham.MaSanPham
	--cập nhật thành tiền cho chi tiết hóa đơn
	begin
		if(TRY_CONVERT(int,@GiaSP * @SoLuong) is not null)
		begin
			update TB_ChiTietHoaDon
			set ThanhTien = convert(int,@GiaSP * @SoLuong)
			where TB_ChiTietHoaDon.MaSanPham = @MaSPTrongChiTietHoaDon 
			and TB_ChiTietHoaDon.MaHoaDon = @MaHoaDonTrongChiTietHoaDon
		end
		else
		begin
			raiserror (N'Lỗi! Không tính được thành tiền!', 16, 1);
			rollback tran
		end
	end
go
use QuanTraSua
go
create trigger HetGioChiTietHoaDon on TB_ChiTietHoaDon--Ngoài h làm việc thì chỉ được xem
for insert, update, delete
as
begin
	--if(datepart(hh,getdate()) <= 12 or datepart(hh,getdate()) >= 23)
	if(datepart(hh,getdate()) <= 7 or datepart(hh,getdate()) >= 23)
	begin
		raiserror (N'Đã hết giờ làm việc! Vui lòng quay lại vào ngày mai!', 16, 1);
		rollback tran
	end
end
go
create trigger HetGioHoaDon on TB_HoaDon--Ngoài h làm việc thì chỉ được xem
for insert, update, delete
as
begin
	--if(datepart(hh,getdate()) <= 12 or datepart(hh,getdate()) >= 23)
	if(datepart(hh,getdate()) <= 7 or datepart(hh,getdate()) >= 23)
	begin
		raiserror (N'Đã hết giờ làm việc! Vui lòng quay lại vào ngày mai!', 16, 1);
		rollback tran
	end
end
go
create trigger HetGioChiTietNguyenLieu on TB_ChiTietNguyenLieu--Ngoài h làm việc thì chỉ được xem
for insert, update, delete
as
begin
	--if(datepart(hh,getdate()) <= 12 or datepart(hh,getdate()) >= 23)
	if(datepart(hh,getdate()) <= 7 or datepart(hh,getdate()) >= 23)
	begin
		raiserror (N'Đã hết giờ làm việc! Vui lòng quay lại vào ngày mai!', 16, 1);
		rollback tran
	end
end
go

create trigger HetGioKhachHang on TB_KhachHang--Ngoài h làm việc thì chỉ được xem
for insert, update, delete
as
begin
	--if(datepart(hh,getdate()) <= 12 or datepart(hh,getdate()) >= 23)
	if(datepart(hh,getdate()) <= 7 or datepart(hh,getdate()) >= 23)
	begin
		raiserror (N'Đã hết giờ làm việc! Vui lòng quay lại vào ngày mai!', 16, 1);
		rollback tran
	end
end
go
create trigger HetGioLoaiSanPham on TB_LoaiSanPham--Ngoài h làm việc thì chỉ được xem
for insert, update, delete
as
begin
	--if(datepart(hh,getdate()) <= 12 or datepart(hh,getdate()) >= 23)
	if(datepart(hh,getdate()) <= 7 or datepart(hh,getdate()) >= 23)
	begin
		raiserror (N'Đã hết giờ làm việc! Vui lòng quay lại vào ngày mai!', 16, 1);
		rollback tran
	end
end
go
create trigger HetGioNguyenLieu on TB_NguyenLieu--Ngoài h làm việc thì chỉ được xem
for insert, update, delete
as
begin
	--if(datepart(hh,getdate()) <= 12 or datepart(hh,getdate()) >= 23)
	if(datepart(hh,getdate()) <= 7 or datepart(hh,getdate()) >= 23)
	begin
		raiserror (N'Đã hết giờ làm việc! Vui lòng quay lại vào ngày mai!', 16, 1);
		rollback tran
	end
end
go
create trigger HetGioNhanVien on TB_NhanVien--Ngoài h làm việc thì chỉ được xem
for insert, update, delete
as
begin
	--if(datepart(hh,getdate()) <= 12 or datepart(hh,getdate()) >= 23)
	if(datepart(hh,getdate()) <= 7 or datepart(hh,getdate()) >= 23)
	begin
		raiserror (N'Đã hết giờ làm việc! Vui lòng quay lại vào ngày mai!', 16, 1);
		rollback tran
	end
end
go
create trigger HetGioSanPham on TB_SanPham--Ngoài h làm việc thì chỉ được xem
for insert, update, delete
as
begin
	--if(datepart(hh,getdate()) <= 12 or datepart(hh,getdate()) >= 23)
	if(datepart(hh,getdate()) <= 7 or datepart(hh,getdate()) >= 23)
	begin
		raiserror (N'Đã hết giờ làm việc! Vui lòng quay lại vào ngày mai!', 16, 1);
		rollback tran
	end
end
go
create trigger KiemTraPassWord on TB_TaiKhoan	--Password mạnh phải có cả chữ thường,												--chữ hoa, số và ký tự đặc biệt
for insert, update
as
	declare @matkhaumoi nvarchar(30), @kq bit --@kq cho biết mật khẩu đạt yêu cầu hay ko
												--@kq = 1 là đạt, = 0 là không đạt
 	select @matkhaumoi = MatKhau
	from inserted TaiKhoanMoi
	--Kiểm tra
	if(@matkhaumoi like '%' + '[a-z]' + '%' 
		and @matkhaumoi like '%' + '[0-9]' + '%' 
		and (@matkhaumoi like '%' + '[:-@]' + '%' or @matkhaumoi like '%' + '[!-/]' + '%')
		and datalength(@matkhaumoi) > 6)
			set @kq = 1;
	else set @kq = 0;
	if(@kq = 0)
	begin
		raiserror('Mật khẩu phải có cả chữ thường, chữ hoa, chữ số và ký tự đặc biệt!',16,1);
		rollback tran
	end
go

-----------------------------------------------------------------------------
-------------------------------------------------------------- Function
-----------------------------------------------------------------------------

use QuanTraSua
go
--Lọc ra các hóa đơn nằm trong tầm giá truyền vào
create function ufuLocHoaDon (@inputvalue1 int, @inputvalue2 int)
returns table
as
	return (select * from TB_HoaDon where TongTien >= @inputvalue1 and TongTien <= @inputvalue2)
go

--Tìm kiếm nhân viên khi nhập vào một phần của tên
create function ufuTimKiemNhanVienTheoTen (@input nvarchar(30))
RETURNS TABLE
AS
RETURN ( SELECT MaNhanVien, HoTen, GioiTinh, NgaySinh, CMND, SoDienThoai, 
		DiaChi, NgayVaoLam, ChucVu, MucLuong, TB_Quay.TenQuay, TamKhoa
			FROM TB_NhanVien, TB_Quay
			WHERE (HoTen like '%'+@input+'%' AND TB_NhanVien.MaQuay = TB_Quay.MaQuay))
go
--Tính số nhân viên còn đang làm việc tại quán
create function ufuDemSoNhanVienConLamViec()
returns int
as
begin
	declare @soluong int
	select @soluong = count(*)
	from TB_NhanVien
	where TamKhoa = 0
	return @soluong
end
go
--Tính số tiền thu vào trong một tháng trong một năm nào đó
create function ufuTinhTienThuTheoThang( @inputnam int, @inputthang int )
returns int
as
begin
	declare @kq int
	select @kq = sum(TongTien)
	from TB_HoaDon
	where DATEPART(YYYY, ThoiGian) = @inputnam and DATEPART(MM, ThoiGian) = @inputthang
	return @kq
end
go
--Trả về bảng có danh sách các tháng trong một năm, cùng với thống kê thu chi của tháng đó
create function ufuThongKeDoanhThuThang (@inputyear int)
returns @bangdoanhthu table ([Tháng] nvarchar(10), [Năm] nvarchar(10), [Tiền Thu Vào] int, [Tiền Chi Ra] int, [Tiền Lời] int)
as
begin
	insert @bangdoanhthu
		select N'Tháng '+DATEPART(MM, TB_HoaDon.ThoiGian), --Tháng
				DATEPART(YYYY, TB_HoaDon.ThoiGian), --Năm
				dbo.ufuTinhTienThuTheoThang(DATEPART(YYYY, TB_HoaDon.ThoiGian), DATEPART(MM, TB_HoaDon.ThoiGian)), --Tiền thu vào
				--sum(TB_HoaDon.TongTien), --Tiền thu vào
				sum(TB_NguyenLieu.gia*TB_ChiTietNguyenLieu.SoLuong), --tiền chi ra
				--Tiền lời = tiền thu - tiền chi
				sum(TB_HoaDon.TongTien) - sum(TB_NguyenLieu.gia*TB_ChiTietNguyenLieu.SoLuong)
		from TB_HoaDon, TB_ChiTietHoaDon, TB_NguyenLieu, TB_ChiTietNguyenLieu
		where TB_HoaDon.MaHoaDon = TB_ChiTietHoaDon.MaHoaDon
				and TB_ChiTietHoaDon.MaSanPham = TB_ChiTietNguyenLieu.MaSanPham
				and TB_NguyenLieu.MaNguyenLieu = TB_ChiTietNguyenLieu.MaNguyenLieu
				and DATEPART(YYYY, TB_HoaDon.ThoiGian) = @inputyear
		group by DATEPART(MM, TB_HoaDon.ThoiGian), DATEPART(YYYY, TB_HoaDon.ThoiGian)
	return
end
go

create function ufuLayHoaDon()-------------Load hóa đơn
returns table
as
	return (select MaHoaDon, TB_NhanVien.HoTen as TenNhanVien,
				TB_KhachHang.HoTen as TenKhachHang, ThoiGian, TongTien
			from TB_HoaDon, TB_KhachHang, TB_NhanVien
			where TB_HoaDon.MaKhachHang = TB_KhachHang.MaKhachHang
				and TB_HoaDon.MaNhanVien = TB_NhanVien.MaNhanVien)
go
-----------------------------------------------------------------------------
-------------------------------------------------------------- Procedure
-----------------------------------------------------------------------------

create procedure uspMaHoaChuoi-------------------Mã hóa chuỗi
	@inputstring nvarchar(30),
	@outputstring nvarchar(30) output	--là chuỗi nhân giá trị kết quả
										-- phải set = '' trước khi truyền vào
as
begin
	declare @vitri int = 1; --cho biết vị trí ký tự đang duyệt trên chuỗi
							--khởi gán = 1 vì vị trí 0 trên chuỗi = null
	while(@vitri <= DATALENGTH(@inputstring)) --vòng lặp trên mỗi ký tự của chuỗi
		begin
			declare @kqcharcode int,
					@subchar nvarchar(30) = N'',
					@kqchar nvarchar(30) = N'';
			set @subchar = substring(@inputstring, @vitri, 1); --lấy ra một ký tự ở vị trí hiện tại
			set @kqcharcode = unicode(@subchar) + 10; --giữ mã unicode của ký tự sau khi mã hóa
			set @kqchar = nchar(@kqcharcode); --lưu ký tự kết quả của mã unicode vừa tạo bên trên
			set @outputstring = concat(@outputstring, @kqchar); --cập nhật chuỗi kết quả
			set @vitri = @vitri + 1;
		end
end
go


create proc uspGiaiMaChuoi----------------------------------giải mã chuỗi
	@inputstring nvarchar(30),
	@outputstring nvarchar(30) output -- phải set = '' trước khi truyền vào
as
begin
	declare @vitri int = 1;
	while(@vitri <= DATALENGTH(@inputstring))
		begin
			declare @kqcharcode int,
					@subchar nvarchar(30) = N'',
					@kqchar nvarchar(30) = N'';
			set @subchar = substring(@inputstring, @vitri, 1);
			set @kqcharcode = unicode(@subchar) - 10;
			set @kqchar = nchar(@kqcharcode);
			set @outputstring = concat(@outputstring, @kqchar);
			set @vitri = @vitri + 1;
		end
end
go
create proc uspTachChuoi --------------------------Tách một chuỗi có dạng 0-1000
	@inputstring nvarchar(30), 
	@outputvalue1 int out,
	@outputvalue2 int out
as
begin
	declare @input1 nvarchar(30)
	declare @input2 nvarchar(30)
	--tạo biến lưu kí tự gạch nối -
	declare @vitriphancach int = charindex('-',@inputstring,1);
	--tách chuỗi ban đầu thành hai chuỗi con nhờ vị trí dấu "-" vừa tìm
	set @input1 = substring(@inputstring,1,@vitriphancach - 1); 
	set @input2 = substring(@inputstring,@vitriphancach + 1,30);
	--Convert 2 chuỗi con trên thành kiểu int và lưu vào các biến output
	if(try_convert(int, @input1) is not null and try_convert(int, @input2) is not null)
		begin
			set @outputvalue1 = convert(int, @input1)
			set @outputvalue2 = convert(int, @input2)
		end
	else throw 60000,'Lỗi! Dữ liệu truyền vào không hợp lệ!',1
end
go
create procedure uspTaoTaiKhoanSQL -------------------------Tạo tài khoản
        @login varchar(30),
        @password varchar(30),
        @role varchar(30)
as
	insert into TB_TaiKhoan (TenDangNhap,MatKhau,MaNhanVien,VaiTro) values (@login,@password,@role);
	declare @sql nvarchar(max)	--lưu trữ câu lệnh sql
	declare @user nvarchar(30)
	set @user = 'ur'+@login		--tên user được lấy từ tên login thêm 'ur' vào đầu
	set @sql = 'use QuanTraSua;'+
			   'create login '+@login+' with password = ''+@password+'';'+
			   'create user '+@user+' for login '+@login+';'
	exec (@sql)	--thực thi câu lệnh đã tạo trong biến @sql
	exec sp_addrolemember  @role, @user;	--them user vào role
go
use QuanTraSua
go
create proc uspThemNhanVien	--------------------thủ tục thêm nhân viên
	@MaNhanVien nvarchar(10),
	@HoTen nvarchar(30),
	@GioiTinh nvarchar(30),
	@NgaySinh date,
	@CMND nvarchar(30),
	@SoDienThoai nvarchar(30),
	@DiaChi nvarchar(30),
	@NgayVaoLam date,
	@ChucVu nvarchar(30),
	@MucLuong nvarchar(30),
	@MaQuay nvarchar(10),
	@TamKhoa bit
as
begin
	insert into TB_NhanVien (MaNhanVien, HoTen, GioiTinh, NgaySinh, CMND, SoDienThoai, 
	DiaChi, NgayVaoLam, ChucVu, MucLuong, MaQuay, TamKhoa )
	values(@MaNhanVien, @HoTen, @GioiTinh, @NgaySinh, @CMND, @SoDienThoai, 
	@DiaChi, @NgayVaoLam, @ChucVu, @MucLuong, @MaQuay, @TamKhoa )
end
go
create proc uspSuaNhanVien	--------------------Sửa thông nhân viên nhưng giữ nguyên Mã nhân viên
	@MaNhanVien nvarchar(10),
	@HoTen nvarchar(30),
	@GioiTinh nvarchar(30),
	@NgaySinh date,
	@CMND nvarchar(30),
	@SoDienThoai nvarchar(30),
	@DiaChi nvarchar(30),
	@NgayVaoLam date,
	@ChucVu nvarchar(30),
	@MucLuong nvarchar(30),
	@MaQuay nvarchar(10)
as
begin
	update TB_NhanVien set
	HoTen = @HoTen, GioiTinh = @GioiTinh, NgaySinh = @NgaySinh, CMND = @CMND, SoDienThoai = @SoDienThoai, 
	DiaChi = @DiaChi, NgayVaoLam = @NgayVaoLam, ChucVu = @ChucVu, MucLuong = @MucLuong, MaQuay = @MaQuay
	where MaNhanVien = @MaNhanVien
end
go
create proc uspXoaNhanVien	---------------------------------------------Xóa nhân viên
	@MaNhanVien nvarchar(10)
as
begin
	delete from TB_NhanVien where MaNhanVien = @MaNhanVien
end
go
create proc uspChoNghiViec----------------------------Thiết lập cho một nhân viên nghỉ việc
	@MaNhanVien nvarchar(30)
as
begin
	--Set thuộc tính tạm khóa của nhân viên về true
	update TB_NhanVien set TamKhoa = 'true'
	where MaNhanVien = @MaNhanVien
	--Truy vấn lấy ra login từ mã nhân viên truyền vào
	declare @TenDangNhap nvarchar(30)
	select @TenDangNhap = TenDangNhap
	from TB_TaiKhoan
	where TB_TaiKhoan.MaNhanVien = @MaNhanVien
	--Tạo câu lệnh sql
	declare @user nvarchar(30)
	declare @sql nvarchar(max)
	set @user = 'ur'+@TenDangNhap
	set @sql =	'use QuanTraSua;'+
				'alter login '+@TenDangNhap+' disable;'
	exec (@sql) --Thực thi câu lệnh
end
go
create proc uspThangChuc @MaNhanVien nvarchar(30)-----------Nâng nhân viên lên Quản lý
as
begin
	declare @chucvuhientai nvarchar(30)
	select @chucvuhientai = ChucVu	--Truy vẫn chức vụ hiện tại
	from TB_NhanVien
	where MaNhanVien = @MaNhanVien
	if(@chucvuhientai != N'Quản Lý')--Kiểm tra hiện tại là quản lý chưa, nếu rồi thì khỏi làm
	begin
		update TB_NhanVien --Đổi chức vụ nhân viên thành Quản lý
		set ChucVu = N'Quản Lý'
		declare @TenDangNhap nvarchar(30) --Truy vấn xem tài khoản login sql hiện tại là gì
		select @TenDangNhap = TenDangNhap
		from TB_TaiKhoan
		where TB_TaiKhoan.MaNhanVien = @MaNhanVien
		--Kiểm tra có tồn tại tài khoản sql của nhân viên chưa
		if(@TenDangNhap != '' or @TenDangNhap is null)
		begin
			declare @user nvarchar(30) --Tìm ra tên user từ login tìm được bên trên
			set @user = 'ur'+@TenDangNhap
			exec sp_droprolemember nhanvienthungan, @user--Loại user khỏi role cũ và add vào role mới
			exec sp_addrolemember nhanvienquanly, @user
		end
		else throw 80000,'Lỗi! Nhân viên không này chưa có tài khoản',1
	end
	else throw 70000,'Lỗi! Nhân viên này đã là quản lý!',1
end
go
create proc uspDoiMatKhau------------------------Đổi mật khẩu
	@forlogin nvarchar(30),
	@newpass nvarchar(30)
as
begin
	declare @sql nvarchar(max)
	set @sql = 'alter login '+@forlogin+' with password = ''+@newpass+'';'
	exec (@sql)
end
go
create proc uspTinhThoiGianLamViecTaiQuan-----------Tính thời gian làm việc từ ngày vào làm
	@inputMaNhanVien nvarchar(30),
	@kq nvarchar(50) out
as
begin
	declare @nam int, @thang int -- biến lưu trữ số năm và số tháng làm việc
	--Truy vấn tìm ngày vào làm của nhân viên
	declare @inputdate date
	select @inputdate = NgayVaoLam
	from TB_NhanVien
	where MaNhanVien = @inputMaNhanVien
	--dùng hàm datediff để tính khoảng thời gian
	set @thang = DATEDIFF( MM, @inputdate , getdate() );
	set @nam = DATEDIFF(YYYY, @inputdate, GETDATE() );
	--Thiết lập câu kết quả
	set @kq = N'Đã làm việc '
	if(@nam > 0) set @kq = @kq + @nam+' năm '
	if(@thang > 0) set @kq = @kq + @thang%@nam+' tháng'
end
go
create proc uspThemHoaDon	--------------------thủ tục thêm hóa đơn
	@MaHoaDon nvarchar(10),
	@MaNhanVien nvarchar(30),
	@MaKhachHang nvarchar(30),
	@TongTien int = 0
as
begin
	insert into TB_HoaDon(MaHoaDon, MaNhanVien, MaKhachHang, TongTien)
	values(@MaHoaDon, @MaNhanVien, @MaKhachHang, @TongTien)
end
go
-----------------------------------------------------------------------------
-------------------------------------------------------------- Nhập liệu
-----------------------------------------------------------------------------
insert into dbo.TB_DonVi values
('1','Kg'),
('2','Gam'),
('3',N'Hộp'),
('4',N'Thùng'),
('5',N'Cái'),
('6',N'Cặp'),
('7',N'Bịch'),
('8',N'Chai'),
('9',N'Đĩa'),
('10',N'Tô(Chén)'),
('11',N'Ly')
go

insert into dbo.TB_Quay values
('Q1',N'Thu ngân',2),
('Q2',N'Phục vụ',4),
('Q3',N'Gửi xe',2),
('Q4',N'Tạp vụ',1),
('Q5',N'Bếp',3)
go

insert into dbo.TB_NguyenLieu values
('NL1',N'Cà phê','1',50000,'false'),
('NL2',N'Matcha','1',100000,'false'),
('NL3',N'Sữa','1',12000,'false'),
('NL4',N'Rượu','1',54000,'false'),
('NL5',N'Bơ','1',50000,'false'),
('NL6',N'Cà rốt','1',50000,'false'),
('NL7',N'Cam','1',30000,'false'),
('NL8',N'Soda','1',100000,'false'),
('NL9',N'Trà sữa','1',170000,'false'),
('NL10',N'Việt quất','1',90000,'false'),
('NL11',N'NL khác','1',50000,'false')
go

insert into dbo.TB_LoaiSanPham values
('LSP1',N'Đồ uống',5),
('LSP2',N'Thức ăn',5),
('LSP3',N'Món nhậu',5),
('LSP4',N'món tráng miệng',5),
('LSP5',N'Đồ gọi thêm',5)
go

insert into dbo.TB_SanPham values
('SP1',N'Cà phê đen',10000,'10','LSP1','false'),
('SP2',N'Cà phê sữa',12000,'10','LSP1','false'),
('SP3',N'Bạc xỉu',16000,'10','LSP1','false'),
('SP4',N'Trà sữa thái',16000,'10','LSP1','false'),
('SP5',N'Trà sữa truyền thống',16000,'10','LSP1','false'),
('SP6',N'Trà sữa chocolate',16000,'10','LSP1','false'),
('SP7',N'Trà sữa việt quất',16000,'10','LSP1','false'),
('SP8',N'Trà sữa rum',16000,'10','LSP1','false'),
('SP9',N'Matcha',16000,'10','LSP1','false'),
('SP10',N'Bơ dằm',16000,'10','LSP4','false'),
('SP11',N'Cam vắt',200000,'10','LSP1','false'),
('SP12',N'Trái cây tô',200000,'9','LSP4','false'),
('SP13',N'Xúc xích',120000,'5','LSP2','false'),
('SP14',N'Tiramishu',600000,'5','LSP2','false'),
('SP15',N'Cocktail',590000,'10','LSP1','false')
go

insert into dbo.TB_ChiTietNguyenLieu values
('SP1','NL1',5),
('SP2','NL1',5),
('SP3','NL1',5),
('SP4','NL9',5),
('SP5','NL9',5),
('SP6','NL9',5),
('SP7','NL9',5),
('SP8','NL9',5),
('SP9','NL2',5),
('SP10','NL5',5),
('SP11','NL7',5),
('SP12','NL11',5),
('SP13','NL11',5),
('SP14','NL11',5),
('SP15','NL4',5)
GO

insert into dbo.TB_NhanVien values
('NV1',N'Z',N'Nam','1997-10-10','225592750','0123456789',N'Nha Trang','2016-1-1',N'Trưởng phòng','5000000','Q1','false'),
('NV2',N'A',N'Nam','1997-9-10','225592751','0122456789',N'Nha Trang','2016-1-1',N'Phó phòng','5000000','Q1','false'),
('NV3',N'Q',N'Nữ','1997-8-10','225592752','0123456789',N'Nha Trang','2016-1-1',N'Nhân viên','2000000','Q2','false'),
('NV4',N'W',N'Nữ','1996-7-10','225592753','0124456789',N'Nha Trang','2016-1-1',N'Nhân viên','2000000','Q2','false'),
('NV5',N'E',N'Nam','1996-6-10','225592754','0125456789',N'Nha Trang','2016-1-1',N'Nhân viên','2000000','Q2','false'),
('NV6',N'R',N'Nam','1996-5-10','225592755','0126456789',N'Nha Trang','2016-1-1',N'Nhân viên','2000000','Q2','false'),
('NV7',N'T',N'Nữ','1995-4-10','225592756','0127456789',N'Nha Trang','2016-1-1',N'Nhân viên','2000000','Q5','false'),
('NV8',N'Y',N'Nữ','1995-3-10','225592757','0128456789',N'Nha Trang','2016-1-1',N'Nhân viên','2000000','Q5','false'),
('NV9',N'U',N'Nam','1995-2-10','225592758','0129456789',N'Nha Trang','2016-1-1',N'Nhân viên','2000000','Q5','false'),
('NV10',N'I',N'Nam','1994-1-10','225592759','0923456789',N'Nha Trang','2016-1-1',N'Nhân viên','2000000','Q3','false'),
('NV11',N'O',N'Nữ','1994-10-19','225592770','0933456789',N'Nha Trang','2016-1-1',N'Nhân viên','2000000','Q4','false')
go

insert into dbo.TB_TaiKhoan values
('taikhoan1','@Minhthong8197','NV1','nhanvienquanly','false'),
('taikhoan2','@Minhthong8197','NV2','nhanvienthungan','false')
go



insert into dbo.TB_KhachHang values
('KH1',N'Jennie Nguyễn','0987654322',N'Migook'),
('KH2',N'Jisoo Trần','0987654323',N'Migook'),
('KH3',N'Rose Dan','0987654321',N'TPHCM'),
('KH4',N'Lisa Nguyễn','0956654321',N'Nha Trang'),
('KH5',N'Sunmi Phạm','0987745321',N'Nha Trang'),
('KH6',N'Jihyo','09876543461',N'TPHCM'),
('KH7',N'Dans Hôi','0987765321',N'TPHCM'),
('KH8',N'Amanda','0987653451',N'Nha Trang'),
('KH9',N'Nguyễn Thành Sơn','0975954321',N'TPHCM'),
('KH10',N'Sếp Trưởng Khoa','098768321',N'Thái Bình')
go
use QuanTraSua
insert into dbo.TB_HoaDon values
('HD01','NV1','KH1',null,0),
('HD02','NV1','KH2',null,0),
('HD03','NV1','KH3',null,0),
('HD04','NV1','KH4',null,0),
('HD05','NV1','KH5',null,0),
('HD06','NV1','KH6',null,0),
('HD07','NV1','KH7',null,0),
('HD08','NV1','KH8',null,0),
('HD09','NV1','KH9',null,0),
('HD10','NV1','KH10',null,0)
go
use QuanTraSua
insert into dbo.TB_ChiTietHoaDon (MaHoaDon,MaSanPham,SoLuong) values ('HD01','SP1',5)
insert into dbo.TB_ChiTietHoaDon (MaHoaDon,MaSanPham,SoLuong) values ('HD02','SP1',5)
insert into dbo.TB_ChiTietHoaDon (MaHoaDon,MaSanPham,SoLuong) values ('HD03','SP1',5)
insert into dbo.TB_ChiTietHoaDon (MaHoaDon,MaSanPham,SoLuong) values ('HD04','SP2',5)
insert into dbo.TB_ChiTietHoaDon (MaHoaDon,MaSanPham,SoLuong) values ('HD05','SP2',5)
insert into dbo.TB_ChiTietHoaDon (MaHoaDon,MaSanPham,SoLuong) values ('HD06','SP2',5)
insert into dbo.TB_ChiTietHoaDon (MaHoaDon,MaSanPham,SoLuong) values ('HD07','SP3',5)
insert into dbo.TB_ChiTietHoaDon (MaHoaDon,MaSanPham,SoLuong) values ('HD08','SP3',5)
insert into dbo.TB_ChiTietHoaDon (MaHoaDon,MaSanPham,SoLuong) values ('HD09','SP3',5)
insert into dbo.TB_ChiTietHoaDon (MaHoaDon,MaSanPham,SoLuong) values ('HD10','SP4',5)
insert into dbo.TB_ChiTietHoaDon (MaHoaDon,MaSanPham,SoLuong) values ('HD01','SP4',5)
insert into dbo.TB_ChiTietHoaDon (MaHoaDon,MaSanPham,SoLuong) values ('HD02','SP4',5)
insert into dbo.TB_ChiTietHoaDon (MaHoaDon,MaSanPham,SoLuong) values ('HD03','SP5',5)
insert into dbo.TB_ChiTietHoaDon (MaHoaDon,MaSanPham,SoLuong) values ('HD04','SP5',5)
insert into dbo.TB_ChiTietHoaDon (MaHoaDon,MaSanPham,SoLuong) values ('HD05','SP5',5)
insert into dbo.TB_ChiTietHoaDon (MaHoaDon,MaSanPham,SoLuong) values ('HD06','SP6',5)
insert into dbo.TB_ChiTietHoaDon (MaHoaDon,MaSanPham,SoLuong) values ('HD07','SP6',5)
insert into dbo.TB_ChiTietHoaDon (MaHoaDon,MaSanPham,SoLuong) values ('HD08','SP6',5)
insert into dbo.TB_ChiTietHoaDon (MaHoaDon,MaSanPham,SoLuong) values ('HD09','SP7',5)
insert into dbo.TB_ChiTietHoaDon (MaHoaDon,MaSanPham,SoLuong) values ('HD10','SP7',5)
insert into dbo.TB_ChiTietHoaDon (MaHoaDon,MaSanPham,SoLuong) values ('HD01','SP7',5)
insert into dbo.TB_ChiTietHoaDon (MaHoaDon,MaSanPham,SoLuong) values ('HD02','SP8',5)
insert into dbo.TB_ChiTietHoaDon (MaHoaDon,MaSanPham,SoLuong) values ('HD03','SP8',5)
insert into dbo.TB_ChiTietHoaDon (MaHoaDon,MaSanPham,SoLuong) values ('HD04','SP8',5)
insert into dbo.TB_ChiTietHoaDon (MaHoaDon,MaSanPham,SoLuong) values ('HD05','SP9',5)
insert into dbo.TB_ChiTietHoaDon (MaHoaDon,MaSanPham,SoLuong) values ('HD06','SP9',5)
insert into dbo.TB_ChiTietHoaDon (MaHoaDon,MaSanPham,SoLuong) values ('HD07','SP9',5)
insert into dbo.TB_ChiTietHoaDon (MaHoaDon,MaSanPham,SoLuong) values ('HD08','SP10',5)
insert into dbo.TB_ChiTietHoaDon (MaHoaDon,MaSanPham,SoLuong) values ('HD09','SP10',5)
insert into dbo.TB_ChiTietHoaDon (MaHoaDon,MaSanPham,SoLuong) values ('HD10','SP10',5)
go
----------------------------------------------------------------------
--------------------------------------Gắn chức năng thực thi vào các role
----------------------------------------------------------------------
use QuanTraSua;
GRANT EXECUTE ON DATABASE::QuanTraSua TO administrator
GRANT DELETE, INSERT, SELECT, UPDATE ON DATABASE::QuanTraSua TO administrator

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