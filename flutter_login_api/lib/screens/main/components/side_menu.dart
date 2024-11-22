import 'package:flutter/material.dart';
import 'package:flutter_login_api/mausacvakichthuoc/constants1.dart';
import 'package:flutter_login_api/models/thongbao.dart';
import 'package:flutter_login_api/screens/login_screen.dart';
import 'package:flutter_login_api/screens/nguoidung/trangchuthongtincanhan.dart';
import 'package:flutter_login_api/screens/thongbao.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SideMenu extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: bgColor1,
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/Tiêu_đề_Website_BV_16_-removebg-preview.png"),
          ),
          DrawerListTile(
            title: "KPI",
            svgSrc: "assets/icons/menu_dashboard.svg",
            press: () {},
          ),
          // DrawerListTile(
          //   title: "Transaction",
          //   svgSrc: "assets/icons/menu_tran.svg",
          //   press: () {},
          // ),
          // DrawerListTile(
          //   title: "Task",
          //   svgSrc: "assets/icons/menu_task.svg",
          //   press: () {},
          // ),
          DrawerListTile(
            title: "Tài liệu",
            svgSrc: "assets/icons/menu_doc.svg",
            press: () {},
          ),
          // DrawerListTile(
          //   title: "Store",
          //   svgSrc: "assets/icons/menu_store.svg",
          //   press: () {},
          // ),
          DrawerListTile(
            title: "Thông báo",
            svgSrc: "assets/icons/menu_notification.svg",
             press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ThongBaoScreen(
  userEmail: userEmail,
                    displayName: displayName,
                    photoURL: photoURL!,
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
                    userEmail: userEmail,
                    displayName: displayName,
                    photoURL: photoURL!,
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
                Navigator.of(context).pop(false); // Đóng hộp thoại và không đăng xuất
              },
            ),
            TextButton(
              child: Text("Đồng ý"),
              onPressed: () {
                Navigator.of(context).pop(true); // Đóng hộp thoại và tiếp tục đăng xuất
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
        colorFilter: ColorFilter.mode(Color.fromARGB(136, 9, 0, 0), BlendMode.srcIn),
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
