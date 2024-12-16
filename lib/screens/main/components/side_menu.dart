import 'package:flutter/material.dart';
import 'package:flutter_login_api/mausacvakichthuoc/constants1.dart';
import 'package:flutter_login_api/models/thongbao.dart';
import 'package:flutter_login_api/providers/usuario_provider.dart';
import 'package:flutter_login_api/screens/capkpi/capkpicanhan/capkpicanhan.dart';
import 'package:flutter_login_api/screens/kpi/danhmuckpi.dart';
import 'package:flutter_login_api/screens/login_screen.dart';
import 'package:flutter_login_api/screens/nguoidung/trangchuthongtincanhan.dart';
import 'package:flutter_login_api/screens/thongbao.dart';
import 'package:flutter_login_api/screens/trangchu/canhan/giaodien.dart';
import 'package:flutter_login_api/screens/trangchu/truongphong/truongphong.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SideMenu extends StatefulWidget {
  final String userEmail;
  final String displayName;
  final String? photoURL;
  const SideMenu({
    Key? key,
    required this.userEmail,
    required this.displayName,
    this.photoURL,
  }) : super(key: key);
  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  String userPosition = '';

  @override
  void initState() {
    super.initState();
    _fetchEmployeeQuyen();
  }

  Future<void> _fetchEmployeeQuyen() async {
    try {
      final gmail = widget.userEmail;
      final maNV = await Provider.of<Usuario_provider>(context, listen: false)
          .GetMaNVByEmail(gmail);

      final result = await Provider.of<Usuario_provider>(context, listen: false)
          .getEmployeeQuyenByMaNV(maNV);

      setState(() {
        userPosition = result;
      });
    } catch (e) {
      print('Lỗi khi lấy quyền: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: bgColor1,
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset(
                "assets/images/Tiêu_đề_Website_BV_16_-removebg-preview.png"),
          ),
          DrawerListTile(
            title: "Trang chủ",
            svgSrc: "assets/icons/menu_dashboard.svg",
            press: () {
              // Kiểm tra vị trí người dùng và điều hướng đến trang tương ứng
              if (userPosition == "TKP" || userPosition == "PKP") {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Giaodien1(
                            userEmail: widget.userEmail,
                            displayName: widget.displayName,
                            photoURL: widget.photoURL!,
                          )),
                );
              } else if (userPosition == "NV") {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Giaodien(
                            userEmail: widget.userEmail,
                            displayName: widget.displayName,
                            photoURL: widget.photoURL!,
                          )),
                );
              }
            },
          ),
          DrawerListTile(
            title: "Danh sách KPI",
            svgSrc: "assets/icons/menu_doc.svg",
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Kpi(
                    userEmail: widget.userEmail,
                    displayName: widget.displayName,
                    photoURL: widget.photoURL!,
                  ),
                ),
              );
            },
          ),
          DrawerListTile(
            title: "Cấp KPI cá nhân",
            svgSrc: "assets/icons/menu_tran.svg",
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CapKpiCN(
                    userEmail: widget.userEmail,
                    displayName: widget.displayName,
                    photoURL: widget.photoURL!,
                  ),
                ),
              );
            },
          ),
          DrawerListTile(
            title: "Thông báo",
            svgSrc: "assets/icons/menu_notification.svg",
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ThongBaoScreen(
                    userEmail: widget.userEmail,
                    displayName: widget.displayName,
                    photoURL: widget.photoURL!,
                  ),
                ),
              );
            },
          ),
          DrawerListTile(
            title: "Thông tin cá nhân",
            svgSrc: "assets/icons/menu_profile.svg",
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => XemTTNguoidung(
                    userEmail: widget.userEmail,
                    displayName: widget.displayName,
                    photoURL: widget.photoURL!,
                  ),
                ),
              );
            },
          ),
          DrawerListTile(
            title: "Đăng xuất",
            svgSrc: "assets/icons/menu_setting.svg",
            press: () async {
              // Hiển thị hộp thoại xác nhận
              bool confirmLogout = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Colors.grey[200],
                    title: Text("Xác nhận"),
                    content: Text("Bạn có chắc chắn muốn đăng xuất không?"),
                    actions: [
                      TextButton(
                        child: Text("Hủy"),
                        onPressed: () {
                          Navigator.of(context)
                              .pop(false); // Đóng hộp thoại và không đăng xuất
                        },
                      ),
                      TextButton(
                        child: Text("Đồng ý"),
                        onPressed: () {
                          Navigator.of(context).pop(
                              true); // Đóng hộp thoại và tiếp tục đăng xuất
                        },
                      ),
                    ],
                  );
                },
              );

              // Kiểm tra nếu người dùng xác nhận đăng xuất
              if (confirmLogout == true) {
                // Lấy instance của SharedPreferences
                final prefs = await SharedPreferences.getInstance();

                // Xóa tất cả dữ liệu người dùng
                await prefs.remove('email');
                await prefs.remove('displayName');
                await prefs.remove('photoURL');

                // Đảm bảo tất cả dữ liệu được xóa trước khi điều hướng
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      //màu biểu tương
      leading: SvgPicture.asset(
        svgSrc,
        colorFilter:
            ColorFilter.mode(Color.fromARGB(136, 9, 0, 0), BlendMode.srcIn),
        height: 16,
      ),
      //Màu chữ thanh menu bên trái
      title: Text(
        title,
        style: TextStyle(color: Color.fromARGB(136, 9, 0, 0)),
      ),
    );
  }
}
