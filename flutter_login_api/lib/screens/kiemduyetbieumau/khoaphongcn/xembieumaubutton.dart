import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Thêm import cho fl_chart
import 'package:flutter/widgets.dart';
import 'package:flutter_login_api/mausacvakichthuoc/constants1.dart';
import 'package:flutter_login_api/models/modelchucdanh.dart';
import 'package:flutter_login_api/providers/usuario_provider.dart';
import 'package:flutter_login_api/screens/kiemduyetbieumau/khoaphongcn/xembieumauchucvucanhan.dart';
import 'package:flutter_login_api/screens/main/components/side_menu.dart';
import 'package:provider/provider.dart';
// Dùng để xem và chọn chức danh muốn xem
class XemBieumauButton extends StatelessWidget {
  final List<ChucDanh> chucdanhList; // Danh sách chức danh
  final String? selectedChucDanh; // Chức danh đã chọn (có thể null)
      final String userEmail;
  final String displayName;
  final String? photoURL;

  // Mapping ChucDanh to image URLs


  XemBieumauButton({
    required this.chucdanhList,
    required this.selectedChucDanh,
    required this.userEmail,
    required this.displayName,
    this.photoURL,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<Usuario_provider>(
      builder: (context, usuarioProvider1, child) {
        final kpicntt = usuarioProvider1.kpicntt;
        return Scaffold(
          backgroundColor: bgColor,
          drawer: MediaQuery.of(context).size.width < 600 ?  SideMenu( userEmail: userEmail,
                    displayName: displayName,
                    photoURL: photoURL!,) : null,
          body: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth >= 600) {
                return Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      color: bgColor1,
                      child: Column(
                        children: [
                          DrawerHeader(
                            child: Image.asset("assets/images/Tiêu_đề_Website_BV_16_-removebg-preview.png"),
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
                            title: "Quay lại",
                            svgSrc: "assets/icons/menu_setting.svg",
                            press: () {
    Navigator.pop(context); // Quay lại trang trước đó
  },
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'Danh sách biểu mẫu chức danh',
                              style: TextStyle(
                                fontSize: 21,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          // Thêm biểu đồ ở đây
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            height: 200, // Chiều cao của biểu đồ
                            child: _buildChart(), // Gọi hàm vẽ biểu đồ
                          ),
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            child: _Danhsachchucdanh(context),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 56.0, left: 16.0, right: 16.0, bottom: 16.0),
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Danh sách biểu mẫu chức danh',
                                    style: TextStyle(
                                      fontSize: 26,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                ],
                              ),
                            ),
                          ),
                          // Thêm biểu đồ ở đây
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            height: 20, // Chiều cao của biểu đồ
                            child: _buildChart(), // Gọi hàm vẽ biểu đồ
                          ),
                          const SizedBox(height: 5),
                          _Danhsachchucdanh(context),
                          const SizedBox(height: 5),
                          const Spacer(),
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
      },
    );
  }

 // Hàm vẽ biểu đồ hình tròn
Widget _buildChart() {
  Map<String, int> countByChucDanh = {};
  
  // Đếm số lượng các chức danh
  for (var chuc in chucdanhList) {
    countByChucDanh[chuc.tenChucDanh] = (countByChucDanh[chuc.tenChucDanh] ?? 0) + 1;
  }

  // Dữ liệu cho biểu đồ
  final List<PieChartSectionData> sections = countByChucDanh.entries
      .map((entry) => PieChartSectionData(
            color: Colors.primaries[entry.key.hashCode % Colors.primaries.length], // Chọn màu cho từng phần
            value: entry.value.toDouble(),
            title: '${entry.key} (${entry.value})', // Tiêu đề phần
            radius: 30, // Giảm kích thước hình
            titleStyle: const TextStyle(fontSize: 0, fontWeight: FontWeight.bold, color: Colors.white), // Ẩn tiêu đề trong phần hình
          ))
      .toList();

  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.start, // Đảm bảo căn chỉnh theo cột
    children: [
      Expanded(
        child: PieChart(
          PieChartData(
            sections: sections,
            borderData: FlBorderData(show: false),
            centerSpaceRadius: 30, // Giảm không gian giữa trung tâm
            startDegreeOffset: 180, // Đặt góc khởi đầu cho biểu đồ
          ),
        ),
      ),
      SizedBox(width: 20), // Khoảng cách giữa biểu đồ và tiêu đề
      SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Căn chỉnh phần mô tả theo cột
          children: sections.map((section) {
            final index = sections.indexOf(section);
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    color: section.color, // Màu sắc của phần
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${countByChucDanh.entries.elementAt(index).key} (${countByChucDanh.entries.elementAt(index).value})', // Tiêu đề bên ngoài
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    ],
  );
}


  Widget _Danhsachchucdanh(BuildContext context) {
  return Center(
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 230, 167, 167)),
        borderRadius: BorderRadius.circular(8),
        color: Color.fromARGB(255, 162, 249, 160),
      ),
      height: MediaQuery.of(context).size.height * 0.4, // Sử dụng phần trăm chiều cao màn hình
      width: MediaQuery.of(context).size.width * 0.84, // Sử dụng phần trăm chiều rộng màn hình
      child: LayoutBuilder(
        builder: (context, constraints) {
          int columnCount;
          if (constraints.maxWidth < 600) {
            columnCount = 2;
          } else if (constraints.maxWidth < 900) {
            columnCount = 3;
          } else {
            columnCount = 5;
          }

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columnCount,
              childAspectRatio: 1,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: chucdanhList.length,
            itemBuilder: (context, index) {
              final chuc = chucdanhList[index];
              return Card(
                color: Color.fromARGB(255, 254, 240, 235),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => XemBieumauKPCN(
                          machucdanh: chuc.maChucDanh,
                            userEmail: userEmail ?? '',
                                    displayName: displayName ?? '',
                                    photoURL: photoURL ?? '',
                        ),
                      ),
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Biểu tượng trang trí phía trên
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: const Icon(
                          Icons.star, // Biểu tượng có thể thay đổi tùy ý
                          size: 20,
                          color: Colors.amber, // Màu sắc của biểu tượng
                        ),
                      ),
                      // Container(
                      //   height: 60,
                      //   decoration: BoxDecoration(
                      //     image: DecorationImage(
                      //       image: NetworkImage(chucDanhImages[chuc.tenChucDanh] ?? ''),
                      //       fit: BoxFit.cover,
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(height: 5),
                      Text(
                        chuc.tenChucDanh,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    ),
  );
}
}
