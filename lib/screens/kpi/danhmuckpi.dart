import 'package:flutter/material.dart';
import 'package:flutter_login_api/mausacvakichthuoc/constants1.dart';
import 'package:flutter_login_api/models/kpiphongcntt.dart';
import 'package:flutter_login_api/screens/capkpi/capkpicanhan/capkpicanhan.dart';
import 'package:flutter_login_api/screens/kiemduyetbieumau/khoaphong/xembieumaukp.dart';
import 'package:flutter_login_api/screens/kpi/kpidetails.dart';
import 'package:flutter_login_api/screens/main/components/side_menu.dart';
import 'package:flutter_login_api/screens/nguoidung/trangchuthongtincanhan.dart';
import 'package:flutter_login_api/screens/thongbao.dart';
import 'package:flutter_login_api/screens/trangchu/canhan/giaodien.dart';
import 'package:flutter_login_api/screens/trangchu/truongphong/truongphong.dart';
import 'package:provider/provider.dart';
import 'package:flutter_login_api/providers/usuario_provider.dart';

class Kpi extends StatefulWidget {
  final String userEmail;
  final String displayName;
  final String? photoURL;
  const Kpi(
      {Key? key,
      required this.userEmail,
      required this.displayName,
      this.photoURL})
      : super(key: key);
  @override
  _KpiBankScreenState createState() => _KpiBankScreenState();
}

class _KpiBankScreenState extends State<Kpi>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String userPosition = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _fetchEmployeeQuyen();
    Future.microtask(() => Provider.of<Usuario_provider>(context, listen: false)
        .getKpiPhongKhoa());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: bgColor,
      drawer: MediaQuery.of(context).size.width < 600
          ? SideMenu(
              userEmail: widget.userEmail,
              displayName: widget.displayName,
              photoURL: widget.photoURL!,
            )
          : null, // Slide menu
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 600) {
            return Row(
              children: [
                // Bên trái: Menu
                Container(
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
                          Navigator.pop(context); // Quay lại trang trước
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Danh sách ngân hàng KPI',
                              style: TextStyle(
                                fontSize: 21,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 0),
                        Expanded(
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              _buildKpiTable(context,
                                  screenSize), // Nội dung của tab Cá nhân
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            // Cho màn hình nhỏ hơn
            return Stack(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                      top: 56.0, left: 16.0, right: 16.0, bottom: 16.0),
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildKpiTable(
                          context, screenSize), // Nội dung tab Cá nhân
                    ],
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: IconButton(
                    icon: const Icon(Icons.menu, size: 32, color: Colors.black),
                    onPressed: () {
                      Scaffold.of(context).openDrawer(); // Mở Drawer
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildKpiTable(BuildContext context, Size screenSize) {
    return Consumer<Usuario_provider>(
        builder: (context, usuarioProvider1, child) {
      final kpicntt = usuarioProvider1.kpicntt;

      if (kpicntt.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      return Center(
        child: SizedBox(
          width: screenSize.width * 0.9,
          child: Container(
              decoration: BoxDecoration(
                color: Colors.white, // Màu trắng cho DataTable
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 247, 244, 244)
                        .withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Theme(
                  data: Theme.of(context).copyWith(
                    iconTheme: const IconThemeData(
                      color: Colors
                          .green, // Đặt màu cho các icon của nút phân trang (next, previous, etc.)
                    ),
                    textTheme: const TextTheme(
                      labelLarge: TextStyle(
                          color:
                              Colors.green), // Đặt màu cho số trang phân trang
                    ),
                    buttonTheme: const ButtonThemeData(
                      buttonColor: Colors
                          .green, // Đặt màu nền cho các nút phân trang (nút next, previous)
                    ),
                    colorScheme: ColorScheme.fromSwatch().copyWith(
                      primary: Colors
                          .green, // Đặt màu chính (ảnh hưởng đến các nút và các phần liên quan)
                      background: Colors
                          .green[50], // Đặt màu nền cho toàn bộ vùng phân trang
                    ),
                  ),
                  child: PaginatedDataTable(
                    columns: [
                      const DataColumn(
                        label: Text(
                          'Số thứ tự',
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                      const DataColumn(
                        label: Text(
                          'Nội dung',
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                      const DataColumn(
                        label: Text(
                          'Chi tiết',
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                    ],
                    source: KpiDataTableSource(kpicntt, context),
                    rowsPerPage: 10,
                    columnSpacing: 40,
                    headingRowColor: MaterialStateProperty.all(
                        Colors.green[100]), // Màu nền của tiêu đề cột
                    //dataRowColor: MaterialStateProperty.all(Colors.white), // Màu nền của các dòng dữ liệu
                  ),
                ),
              )),
        ),
      );
    });
  }
}

class KpiDataTableSource extends DataTableSource {
  final List<Kpiphongcntt> kpicntt;
  final BuildContext context;

  KpiDataTableSource(this.kpicntt, this.context);

  @override
  DataRow getRow(int index) {
    if (index >= kpicntt.length) return null!;
    final usuario = kpicntt[index];

    return DataRow(
      color:
          MaterialStateProperty.all(Colors.white), // Màu nền của dòng dữ liệu
      cells: [
        DataCell(
          Text(
            (index + 1).toString(),
            style: const TextStyle(
                color: Colors.black), // Màu chữ đen cho số thứ tự
          ),
        ),
        DataCell(
          Container(
            constraints: const BoxConstraints(maxWidth: 300),
            child: Text(
              usuario.noidung ?? 'N/A',
              style: const TextStyle(
                  color: Colors.black), // Màu chữ đen cho nội dung
              overflow: TextOverflow.ellipsis,
              maxLines: 2, // Giới hạn số dòng hiển thị
            ),
          ),
        ),
        DataCell(
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  const Color.fromARGB(255, 110, 187, 117), // Màu nền của nút
              foregroundColor: Colors.white, // Màu chữ và icon
              padding: const EdgeInsets.symmetric(
                  vertical: 10, horizontal: 20), // Padding cho nút
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), // Bo tròn góc nút
              ),
              shadowColor:
                  Colors.grey.withOpacity(0.5), // Màu của shadow dưới nút
              elevation: 5, // Độ cao của shadow
            ),
            icon: const Icon(Icons.edit, size: 20), // Kích thước icon
            label: const Text(
              'Chi tiết',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold), // Cỡ chữ và kiểu chữ
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      KpiDetailsScreen(usuario), // Điều hướng đến chi tiết KPI
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => kpicntt.length;

  @override
  int get selectedRowCount => 0;
}
