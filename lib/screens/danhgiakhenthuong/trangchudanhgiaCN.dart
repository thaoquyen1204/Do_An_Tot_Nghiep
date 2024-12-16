import 'package:flutter/material.dart';
import 'package:flutter_login_api/mausacvakichthuoc/constants1.dart';
import 'package:flutter_login_api/models/usuario.dart';
import 'package:flutter_login_api/providers/usuario_provider.dart';
import 'package:flutter_login_api/providers/usuario_provider1.dart';
import 'package:flutter_login_api/screens/danhgiakhenthuong/canhan/danhgiacanhan.dart';
import 'package:flutter_login_api/screens/danhgiakhenthuong/canhan/danhsachcanhandanhgia.dart';
import 'package:flutter_login_api/screens/danhgiakhenthuong/canhan/trucquandanhgia.dart';
import 'package:flutter_login_api/screens/danhgiakhenthuong/canhan/xemdanhgiacanhan.dart';
import 'package:flutter_login_api/screens/danhgiakhenthuong/tongket.dart';
import 'package:flutter_login_api/screens/kiemduyetbieumau/canhan/danhsachcanhankd.dart';
import 'package:flutter_login_api/screens/kiemduyetbieumau/khoaphong/khoaphongbm.dart';
import 'package:flutter_login_api/screens/kiemduyetbieumau/khoaphongcn/danhsachbieumauchucvu.dart';
import 'package:flutter_login_api/screens/kiemduyetbieumau/timkiem.dart';
import 'package:flutter_login_api/screens/kpi/danhmuckpi.dart';
import 'package:flutter_login_api/screens/main/components/side_menu.dart';
import 'package:flutter_login_api/screens/nguoidung/trangchuthongtincanhan.dart';
import 'package:flutter_login_api/screens/thongbao.dart';
import 'package:flutter_login_api/screens/trangchu/canhan/giaodien.dart';
import 'package:flutter_login_api/screens/trangchu/truongphong/truongphong.dart';
import 'package:provider/provider.dart';

const String manLookRightImageUrl =
    'https://media.istockphoto.com/id/1208313447/vi/vec-to/kh%C3%A1i-ni%E1%BB%87m-l%C3%A0m-vi%E1%BB%87c-nh%C3%B3m-v%E1%BB%9Bi-c%C3%A2u-%C4%91%E1%BB%91-x%C3%A2y-d%E1%BB%B1ng-m%E1%BB%8Di-ng%C6%B0%E1%BB%9Di-l%C3%A0m-vi%E1%BB%87c-c%C3%B9ng-v%E1%BB%9Bi-c%C3%A1c-y%E1%BA%BFu-t%E1%BB%91-c%C3%A2u-%C4%91%E1%BB%91.jpg?s=1024x1024&w=is&k=20&c=DXGA_sVC8tgYd_cdMMb5eiQOBq511dXt5x24b3zXRME=';
const String dogImageUrl =
    'https://png.pngtree.com/png-clipart/20230330/original/pngtree-form-line-icon-png-image_9010067.png';
const String womanLookLeftImageUrl =
    'https://www.bsc.com.vn/Sites/STOCK/SiteRoot/quan-ly-tai-chinh-ca-nhan-vo-cung-quan-trong.jpg';

final kGreyBackground = Colors.grey[200];

class TrangChuDGCN extends StatefulWidget {
  final String userEmail;
  final String displayName;
  final String? photoURL;

  const TrangChuDGCN({
    Key? key,
    required this.userEmail,
    required this.displayName,
    this.photoURL,
  }) : super(key: key);

  @override
  State<TrangChuDGCN> createState() => _TrangChuBMState();
}

class _TrangChuBMState extends State<TrangChuDGCN> {
  late String searchString;
  List<Widget> searchResultTiles = [];
  List<Usuario> nhanViens = [];
  bool isLoading = true;

  int currentYear = DateTime.now().year;

  Map<String, String> statusMap = {};
  Map<String, double> tyleHoanThanhMap = {};
  String maNV = '';
  int year = DateTime.now().year;

  @override
  void initState() {
    searchString = '';
    super.initState();
    _fetchNhanViens();
    _fetchEmployeeMaNV();
  }

  Future<String?> _fetchEmployeeMaNV() async {
    final gmail = widget.userEmail;
    var resultParam =
        await Provider.of<Usuario_provider>(context, listen: false)
            .GetMaNVByEmail(gmail);

    print("Fetching data for MaNV: ${resultParam}");

    maNV = resultParam;
  }

  Future<void> _fetchNhanViens() async {
    try {
      final usuarioProvider =
          Provider.of<Usuario_provider>(context, listen: false);
      await usuarioProvider.getNhanVien();
      setState(() {
        nhanViens = usuarioProvider.usuarios;
        isLoading = false;
      });
      // await _fetchStatuses();
      await _fetchTyLeHoanThanh();
    } catch (error) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchTyLeHoanThanh() async {
    final year = DateTime.now().year;
    if (year != null) {
      for (var nhanVien in nhanViens) {
        try {
          double tyLeHoanThanh =
              await Provider.of<Usuario_provider1>(context, listen: false)
                  .GetTyLeHoanThanhByMaNVvaNam(nhanVien.maNv, year);
          if (tyLeHoanThanh < 0) {
            tyLeHoanThanh = 0.0;
          }
          tyleHoanThanhMap[nhanVien.maNv] = tyLeHoanThanh;
          print(tyleHoanThanhMap);
        } catch (error) {
          tyleHoanThanhMap[nhanVien.maNv] = 0.0;
        }
      }
      setState(() {});
    }
  }

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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeaderSection(),
                      Expanded(child: _buildContent(listViewPadding)),
                    ],
                  ),
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
              title: const Row(
                children: [
                  Icon(Icons.assessment,
                      color: Colors.green, size: 28), // Thêm icon trang trí
                  SizedBox(width: 10),
                  Text(
                    'TRANG CHỦ ĐÁNH GIÁ KPI',
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
              child: Column(
                children: [
                  _buildHeaderSection(),
                  Expanded(child: _buildContent(listViewPadding)),
                ],
              ),
            ),
          );
        }
      }),
    );
  }

  Widget _buildHeaderSection() {
    // Tính toán số KPI hoàn thành và chưa hoàn thành

    int soNhanVienKhenThuong = nhanViens
        .where((nhanVien) =>
            (tyleHoanThanhMap[nhanVien.maNv] ?? 0.0.toDouble()) > 70.0)
        .length;
    int soNhanVienKyLuat = nhanViens
        .where((nhanVien) =>
            (tyleHoanThanhMap[nhanVien.maNv] ?? 0.0.toDouble()) < 50.0)
        .length;
    int soKPIHoanThanh = soNhanVienKhenThuong + soNhanVienKyLuat;
    // int soKPICHuaHoanThanh = nhanViens.length - soKPIHoanThanh;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Xin chào, ${widget.displayName}!',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF62825D),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Đây là bảng quản lý đánh giá KPI theo phòng. Hãy xem qua các nhiệm vụ và kết quả.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 16),

        // KPI Statistics Row
        Wrap(
          spacing: 16.0, // Space between items on the same line
          runSpacing: 8.0, // Space between lines
          children: [
            _buildStatisticTile(
              'Số lượng nhân viên',
              '$soKPIHoanThanh',
              icon: Icons.people,
            ),
            _buildStatisticTile(
              'Số nhân viên đạt khen thưởng',
              '$soNhanVienKhenThuong',
              icon: Icons.star,
            ),
            _buildStatisticTile(
              'Số nhân viên kỷ luật',
              '$soNhanVienKyLuat',
              icon: Icons.warning,
            ),
          ],
        ),

        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildStatisticTile(String title, String value, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF9EDF9C),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: value,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  WidgetSpan(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 6), // Khoảng cách giữa text và icon
                      child: Icon(icon, color: Colors.white, size: 24),
                    ),
                  ),
                ],
              ),
            )
          else
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          const SizedBox(
              height: 4), // Khoảng cách giữa giá trị + icon và tiêu đề
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),
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
            crossAxisCount: 2, // Số cột của lưới
            mainAxisSpacing: 16, // Khoảng cách giữa các hàng
            crossAxisSpacing: 16, // Khoảng cách giữa các cột
            childAspectRatio: 1.0, // Tỉ lệ khung hình để tạo hình vuông
            children: searchResultTiles,
          )
        : GridView.count(
            padding: listViewPadding,
            crossAxisCount: 2, // Số cột của lưới
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.0, // Tỉ lệ khung hình để tạo hình vuông
            children: [
              _buildUserTile(
                imageUrl: manLookRightImageUrl,
                title: 'Khoa phòng',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TongKet(
                      userEmail: widget.userEmail ?? '',
                      displayName: widget.displayName ?? '',
                      photoURL: widget.photoURL ?? '',
                    ),
                  ),
                ),
              ),
              _buildUserTile(
                imageUrl: womanLookLeftImageUrl,
                title: 'Cá nhân',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => XemDanhGiaCN(
                      maNV: maNV,
                      year: year,
                      userEmail: widget.userEmail,
                      displayName: widget.displayName,
                      photoURL: widget.photoURL,
                    ),
                  ),
                ),
              ),
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
          boxShadow: const [
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
