import 'package:flutter/material.dart';
import 'package:flutter_login_api/mausacvakichthuoc/constants1.dart';
import 'package:flutter_login_api/models/usuario.dart';
import 'package:flutter_login_api/providers/usuario_provider.dart';
import 'package:flutter_login_api/screens/main/components/side_menu.dart';
import 'package:flutter_login_api/screens/nguoidung/chinhsuacanhan.dart';
import 'package:flutter_login_api/screens/trangchu/canhan/giaodien.dart';
import 'package:flutter_login_api/screens/trangchu/truongphong/truongphong.dart';
import 'package:provider/provider.dart';

class XemTTNguoidung extends StatefulWidget {
    final String userEmail;
  final String displayName;
  final String? photoURL; // Mã nhân viên cần lấy thông tin
 
 XemTTNguoidung({
       Key? key,
    required this.userEmail,
    required this.displayName,
    this.photoURL,
  }) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<XemTTNguoidung> {
  bool _obscurePassword = true; // Biến kiểm soát trạng thái ẩn/hiện mật khẩu
  Usuario? nguoidung; // Biến lưu dữ liệu người dùng
 String? manv;
 late String userPosition;
  @override
  void initState() {
    super.initState();
    // Gọi API khi khởi tạo để lấy dữ liệu người dùng
    _getNhanVienData();
    _fetchEmployeeQuyen();
  
  }

Future<void> _getNhanVienData() async {
   final gmail = widget.userEmail; // Lấy giá trị từ TextField
  var resultParam =
        await Provider.of<Usuario_provider>(context, listen: false)
            .GetMaNVByEmail(gmail);
  print("Fetching data for MaNV: ${manv.toString()}");
  manv = resultParam;
  final result = await Provider.of<Usuario_provider>(context, listen: false)
      .getNhanVienByMaNv(resultParam);
  
  
  if (result != null) {
    print("Received data from API: $result");
    
    setState(() {
      nguoidung = result; // Lưu trực tiếp đối tượng `Usuario`
      print("nguoidung state updated: $nguoidung");
    });
  } else {
    print("No data found for MaNV: ${manv.toString()}");
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: Text("Thông tin cá nhân"),
        backgroundColor: Colors.green[400],
      ),
      drawer: _buildDrawer(context), // Thêm Drawer menu bên trái
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            width: 1100,
            decoration: BoxDecoration(
              color: Colors.white, // Màu nền của khung
              borderRadius: BorderRadius.circular(40.0), // Viền bo góc
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2), // Đổ bóng
                  blurRadius: 8.0,
                  offset: Offset(0, 4), // Độ lệch bóng
                ),
              ],
            ),
            child: nguoidung == null
                ? Center(child: CircularProgressIndicator()) // Hiển thị khi đang tải dữ liệu
                : _buildUserInfo(), // Hiển thị thông tin người dùng khi có dữ liệu
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditPage(
                maNV:manv.toString(),
                userEmail: widget.userEmail,
              displayName: widget.displayName,
              photoURL: widget.photoURL,
                 // Truyền mã KPI
              ),
            ),
          );
        },
        backgroundColor: Colors.green[400],
        child: Icon(Icons.edit),
      ),
    );
  }


  // Hàm xây dựng giao diện hiển thị thông tin người dùng
  Widget _buildUserInfo() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar
            Center(
              child: CircleAvatar(
                backgroundImage: nguoidung!.hinhAnhNv != null &&
                        nguoidung!.hinhAnhNv!.isNotEmpty
                    ? NetworkImage(nguoidung!.hinhAnhNv!)
                    : AssetImage('assets/images/default_avatar.png')
                        as ImageProvider,
                radius: 60,
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                nguoidung!.tenNv ?? 'Chưa có tên',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ),
            ),
            SizedBox(height: 20),
            // Thông tin người dùng
            _buildInfoCard(Icons.phone, nguoidung!.sdt ?? 'Chưa có số điện thoại'),
            _buildInfoCard(Icons.email, nguoidung!.gmail ?? 'Chưa có gmail'),
            _buildInfoCard(Icons.account_circle, nguoidung!.tenTaiKhoan ?? 'Chưa có tên tài khoản'),
            _buildPasswordCard(Icons.lock, nguoidung!.matKhau ?? 'Chưa có mật khẩu'),
            _buildInfoCard(Icons.work_outline, nguoidung!.tenChucDanh ?? 'Chưa có chức danh'),
            _buildInfoCard(Icons.security, nguoidung!.tenQuyen ?? 'Chưa có quyền'),
          ],
        ),
      ),
    );
  }

  // Hàm tạo thẻ thông tin với icon và text
  Widget _buildInfoCard(IconData icon, String text) {

    return Container(
      width: 700,
      child: Card(
        
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        elevation: 6,
         color: Colors.grey[200],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, color: Colors.green[800]),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.green[800],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Hàm tạo thẻ thông tin mật khẩu với chức năng ẩn/hiện
  Widget _buildPasswordCard(IconData icon, String password) {
    return Container(
      width: 700,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        elevation: 6,
         color: Colors.grey[200],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, color: Colors.green[800]), // Icon khóa
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  _obscurePassword ? '********' : password, // Ẩn/hiện mật khẩu
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.green[800],
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  color: Colors.green[800],
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword; // Thay đổi trạng thái ẩn/hiện
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Hàm tạo Drawer menu bên trái
  Widget _buildDrawer(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.2,
      color: bgColor1,
      child: Column(
        children: [
          DrawerHeader(
            child: Image.asset(
                "assets/images/Tiêu_đề_Website_BV_16_-removebg-preview.png"),
          ),
          DrawerListTile(
            title: "KPI",
            svgSrc: "assets/icons/menu_dashboard.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "Tài liệu",
            svgSrc: "assets/icons/menu_doc.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "Thông báo",
            svgSrc: "assets/icons/menu_notification.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "Thông tin cá nhân",
            svgSrc: "assets/icons/menu_profile.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "Cài đặt",
            svgSrc: "assets/icons/menu_setting.svg",
            press: () {},
          ),
         DrawerListTile(
  title: "Quay lại",
  svgSrc: "assets/icons/menu_setting.svg",
  press: () {
    // Kiểm tra vị trí người dùng và điều hướng đến trang tương ứng
    if (userPosition == "TKP"||userPosition == "PKP") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Giaodien1(userEmail: widget.userEmail,
              displayName: widget.displayName,
              photoURL: widget.photoURL!,)),
      );
    } else if (userPosition == "NV") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Giaodien(userEmail: widget.userEmail,
              displayName: widget.displayName,
              photoURL: widget.photoURL!,)),
      );
    }
  },
),


        ],
      ),
    );
  }
  Future<String?> _fetchEmployeeQuyen() async {
    final gmail = widget.userEmail;
    var resultParam =
        await Provider.of<Usuario_provider>(context, listen: false)
            .GetMaNVByEmail(gmail);

    print("Fetching data for MaNV: ${resultParam}");

    final maNV = resultParam;
    try {
      var result = await Provider.of<Usuario_provider>(context, listen: false)
          .getEmployeeQuyenByMaNV(maNV);
    userPosition = result;
      // Cập nhật userPosition dựa vào kết quả trả về
 

      print("xem maquyen: $userPosition");
      return result;
    } catch (e) {
      print('Đã xảy ra lỗi: $e');
      return null;
    }
  }
}
