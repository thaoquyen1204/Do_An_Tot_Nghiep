import 'package:flutter/material.dart';
import 'package:flutter_login_api/mausacvakichthuoc/constants1.dart';
import 'package:flutter_login_api/providers/usuario_provider.dart';
import 'package:flutter_login_api/screens/kiemduyetbieumau/canhan/danhsachcanhankd.dart';
import 'package:flutter_login_api/screens/kiemduyetbieumau/canhan/xembieumaucanhan.dart';
import 'package:flutter_login_api/screens/kiemduyetbieumau/khoaphong/khoaphongbm.dart';
import 'package:flutter_login_api/screens/kiemduyetbieumau/khoaphong/xembieumaukp.dart';
import 'package:flutter_login_api/screens/kiemduyetbieumau/khoaphongcn/danhsachbieumauchucvu.dart';
import 'package:flutter_login_api/screens/kiemduyetbieumau/khoaphongcn/xembieumauchucvucanhan.dart';
import 'package:flutter_login_api/screens/kiemduyetbieumau/timkiem.dart';
import 'package:flutter_login_api/screens/main/components/side_menu.dart';
import 'package:flutter_login_api/screens/nguoidung/trangchuthongtincanhan.dart';
import 'package:flutter_login_api/screens/thongbao.dart';
import 'package:flutter_login_api/screens/trangchu/canhan/giaodien.dart';
import 'package:flutter_login_api/screens/trangchu/truongphong/truongphong.dart';
import 'package:provider/provider.dart';

const String manLookRightImageUrl =
    'https://hcmiu.edu.vn/wp-content/uploads/2017/08/computer-sci.jpg';
const String dogImageUrl =
    'https://cdn.thuvienphapluat.vn/uploads/tintuc/2022/05/20/chung-tu-ke-toan.jpg';
const String womanLookLeftImageUrl =
    'https://img.pikbest.com/png-images/20240819/set-of-simple-linear-icons-personal-avatar-people-vector_10738270.png!f305cw';

final kGreyBackground = Colors.grey[200];

class TrangChuBMCN extends StatefulWidget {
  final String userEmail;
  final String displayName;
  final String? photoURL;

  const TrangChuBMCN({
    Key? key,
    required this.userEmail,
    required this.displayName,
    this.photoURL,
  }) : super(key: key);

  @override
  State<TrangChuBMCN> createState() => _TrangChuBMState();
}

class _TrangChuBMState extends State<TrangChuBMCN> {
  late String searchString;
  List<Widget> searchResultTiles = [];
  String ChucDanh = ' ';

  @override
  void initState() {
    searchString = '';
    _fetchEmployeeMaNV();
    super.initState();
  }

  Future<String?> _fetchEmployeeMaNV() async {
    final gmail = widget.userEmail;
    var resultParam =
        await Provider.of<Usuario_provider>(context, listen: false)
            .getChucDanhByEmail(gmail);

    print("Fetching data for MaNV: ${resultParam}");

    ChucDanh = resultParam;
  }

  void setSearchString(String value) => setState(() {
        searchString = value;
      });

  @override
  Widget build(BuildContext context) {
    var listViewPadding =
        const EdgeInsets.symmetric(horizontal: 16, vertical: 24);
    return Scaffold(
      backgroundColor: bgColor,
      drawer: MediaQuery.of(context).size.width < 600
          ? SideMenu(
              userEmail: widget.userEmail,
              displayName: widget.displayName,
              photoURL: widget.photoURL!,
            )
          : null,
      body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth >= 600) {
          return Row(
            children: [
              _buildSideMenu(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildContent(listViewPadding),
                ),
              ),
            ],
          );
        } else {
          return Scaffold(
            backgroundColor: bgColor,
            drawer: Drawer(
              child: Container(
                color: bgColor1, // Màu nền cho Drawer
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    DrawerHeader(
                      child: Image.asset(
                          "assets/images/Tiêu_đề_Website_BV_16_-removebg-preview.png"),
                    ),
                    DrawerListTile(
                      title: "Trang chủ",
                      svgSrc: "assets/icons/menu_dashboard.svg",
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Giaodien(
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
                      title: "Quay lại",
                      svgSrc: "assets/icons/menu_setting.svg",
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Giaodien(
                              userEmail: widget.userEmail,
                              displayName: widget.displayName,
                              photoURL: widget.photoURL!,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            appBar: AppBar(
              title: Row(
                children: [
                  const Icon(Icons.assessment,
                      color: Colors.green, size: 28), // Thêm icon trang trí
                  const SizedBox(width: 10),
                  const Text(
                    'BIỂU MẪU KPI',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold, // Làm chữ đậm hơn
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              centerTitle: false, // Tùy chỉnh tiêu đề không căn giữa
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 4, // Tăng hiệu ứng nổi
              shadowColor: Colors.grey.withOpacity(0.3), // Thêm màu bóng
              toolbarHeight: 70, // Tăng chiều cao AppBar
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ), // Bo tròn góc dưới AppBar
              ),
              leading: Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu, color: Colors.black),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
              ),
            ),
            body: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: _buildContent(listViewPadding),
            ),
          );
        }
      }),
    );
  }

  Widget _buildSideMenu() {
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
            title: "Trang chủ",
            svgSrc: "assets/icons/menu_dashboard.svg",
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Giaodien(
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
            title: "Quay lại",
            svgSrc: "assets/icons/menu_setting.svg",
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Giaodien(
                    userEmail: widget.userEmail,
                    displayName: widget.displayName,
                    photoURL: widget.photoURL!,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContent(EdgeInsets listViewPadding) {
    return searchString.isNotEmpty
        ? GridView.count(
            padding: listViewPadding,
            crossAxisCount: 2,
            mainAxisSpacing: 24,
            crossAxisSpacing: 24,
            childAspectRatio: .78,
            children: searchResultTiles,
          )
        : ListView(
            padding: listViewPadding,
            children: [
              Text(
                'Biểu mẫu KPI',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              _buildUserTile(
                imageUrl: manLookRightImageUrl,
                title: 'Khoa phòng',
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => XemKhoaPhongBM(
                              userEmail: widget.userEmail ?? '',
                              displayName: widget.displayName ?? '',
                              photoURL: widget.photoURL ?? '',
                            ))),
              ),
              const SizedBox(height: 16),
              _buildUserTile(
                imageUrl: dogImageUrl,
                title: 'Biểu mẫu cá nhân',
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => XemBieumauKPCN(
                              userEmail: widget.userEmail,
                              displayName: widget.displayName,
                              photoURL: widget.photoURL,
                              machucdanh: ChucDanh.toString(),
                            ))),
              ),
              const SizedBox(height: 16),
              _buildUserTile(
                imageUrl: womanLookLeftImageUrl,
                title: 'Cá nhân',
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => XemBieumauCN(
                              userEmail: widget.userEmail,
                              displayName: widget.displayName,
                              photoURL: widget.photoURL,
                            ))),
              ),
              const SizedBox(height: 16),
            ],
          );
  }

  Widget _buildUserTile(
      {required String imageUrl,
      required String title,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4.0,
              spreadRadius: 1.0,
              offset: Offset(2, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              imageUrl,
              color: kGreyBackground,
              colorBlendMode: BlendMode.darken,
              alignment: Alignment.topCenter,
              fit: BoxFit.cover,
            ),
            Container(
              color: Colors.black.withOpacity(0.5),
              alignment: Alignment.center,
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
