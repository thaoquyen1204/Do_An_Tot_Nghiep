import 'package:flutter/material.dart';
import 'package:flutter_login_api/mausacvakichthuoc/constants1.dart';
import 'package:flutter_login_api/models/usuario.dart';
import 'package:flutter_login_api/providers/usuario_provider.dart';
import 'package:flutter_login_api/providers/usuario_provider1.dart';
import 'package:flutter_login_api/screens/kiemduyetbieumau/canhan/chitietcanhanbm.dart';
import 'package:flutter_login_api/screens/kiemduyetbieumau/canhan/danhsachcanhankd.dart';
import 'package:flutter_login_api/screens/main/components/side_menu.dart';
import 'package:flutter_login_api/screens/nguoidung/trangchuthongtincanhan.dart';
import 'package:flutter_login_api/screens/thongbao.dart';
import 'package:flutter_login_api/screens/trangchu/canhan/giaodien.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

class Trucquan extends StatefulWidget {
    final String userEmail;
  final String displayName;
  final String? photoURL;
     Trucquan({required this.userEmail, required this.displayName, this.photoURL,});  // Thêm tham số cho năm

  @override
  _TrucquanScreenState createState() => _TrucquanScreenState();
}

class _TrucquanScreenState extends State<Trucquan> {
  List<Usuario> nhanViens = [];
  bool isLoading = true; 
  final TextEditingController _yearController = TextEditingController();
  int currentYear = DateTime.now().year; 
  bool _isLoading = false; 
  Map<String, String> statusMap = {}; 

  @override
  void initState() {
    super.initState();
    _fetchNhanViens();
    _yearController.text = currentYear.toString(); 
  }

  Future<void> _fetchNhanViens() async {
    try {
      final usuarioProvider = Provider.of<Usuario_provider>(context, listen: false);
      await usuarioProvider.getNhanVien();
      setState(() {
        nhanViens = usuarioProvider.usuarios;
        isLoading = false; 
      });
      await _trangthai();
   
    } catch (error) {
      setState(() {
        isLoading = false; 
      });
      print("Lỗi khi tải dữ liệu: $error");
    }
  }

  Future<void> _trangthai() async {
    final year = int.tryParse(_yearController.text);
    if (year != null) {
      setState(() {
        _isLoading = true;
      });
      try {
        for (var nhanVien in nhanViens) {
          int trangthai = await Provider.of<Usuario_provider1>(context, listen: false)
              .KPICNTTByMaNVvaNam(nhanVien.maNv, year);
          String message;
          if (trangthai == 1) {
            message = 'Đã duyệt';
          } else if (trangthai == 2) {
            message = 'Từ chối';
          } else if (trangthai == 0) {
            message = 'Chưa phê duyệt';
        
          } else {
            message = 'Trạng thái không xác định';
          }
          statusMap[nhanVien.maNv] = message;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cập nhật trạng thái thành công!')),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $error')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập năm hợp lệ!')),
      );
    }
  }



 @override
Widget build(BuildContext context) {
  // Đếm số lượng trạng thái
  int approvedCount = statusMap.values.where((status) => status == 'Đã duyệt').length;
  int rejectedCount = statusMap.values.where((status) => status == 'Từ chối').length;
  int pendingCount = statusMap.values.where((status) => status == 'Chưa phê duyệt').length;
  int unknownCount = statusMap.values.where((status) => status == 'Trạng thái không xác định').length;
   int createdCount = statusMap.values.where((status) => status == 'Đã tạo').length;
  int notCreatedCount = statusMap.values.where((status) => status == 'Chưa tạo').length;

  return Scaffold(
    backgroundColor: bgColor,
    drawer: MediaQuery.of(context).size.width < 600 ?  SideMenu( userEmail: widget.userEmail,
                    displayName: widget.displayName,
                    photoURL: widget.photoURL!,) : null,
    body: LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.2,
              color: bgColor1,
              child: buildDrawer(),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    buildHeader(),
                    buildYearInputRow(),
                    const SizedBox(height: 20),
                    Expanded(
                      child: isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : SingleChildScrollView(
                              child: buildCharts(approvedCount, rejectedCount, pendingCount, unknownCount,createdCount,notCreatedCount,),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    ),
  );
}

Widget buildDrawer() {
  return Column(
    children: [
      DrawerHeader(
        child: Image.asset("assets/images/Tiêu_đề_Website_BV_16_-removebg-preview.png"),
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
    ],
  );
}

Widget buildHeader() {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'Biểu đồ tương quan trạng thái và nhân viên',
        style: TextStyle(fontSize: 21, color: Colors.black),
      ),
    ),
  );
}

Widget buildYearInputRow() {
  return Row(
    children: [
      const Text('Năm: ', style: TextStyle(fontSize: 20)),
      const SizedBox(width: 8),
      SizedBox(
        width: 60,
        child: TextField(
          controller: _yearController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
          ),
          onSubmitted: (value) {
            setState(() {
              currentYear = int.tryParse(value) ?? currentYear;
            });
          },
        ),
      ),
      const SizedBox(width: 16),
      ElevatedButton(
        onPressed: _trangthai,
        child: const Text('Kiểm tra'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      const Spacer(),
      ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NhanVienGridScreen(userEmail: widget.userEmail, displayName: widget.displayName,photoURL:widget.photoURL ,),
            ),
          );
        },
        child: const Text('Quay lại'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    ],
  );
}

Widget buildCharts(int approvedCount, int rejectedCount, int pendingCount, int unknownCount, int createdCount, int notCreatedCount) {
  return Column(
    children: [
      buildPieChart(approvedCount, rejectedCount, pendingCount, unknownCount),
      const SizedBox(height: 16),
      buildBarChart(approvedCount, rejectedCount, pendingCount, unknownCount),
       const SizedBox(height: 16),
            // buildBarChart1(createdCount, notCreatedCount),
    //   const SizedBox(height: 16),
    //  // buildLineChart(approvedCount, rejectedCount, pendingCount, unknownCount, true),
    ],
  );
}

Widget buildPieChart(int approvedCount, int rejectedCount, int pendingCount, int unknownCount) {
  return Column(
    children: [
      const Text(
        'Biểu đồ tròn trạng thái nhân viên',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      Container(
        height: 250,
        child: PieChart(
          PieChartData(
            sections: [
              PieChartSectionData(
                value: approvedCount.toDouble(),
                title: 'Đã duyệt',
                color: Colors.green,
                radius: 100,
                titleStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              PieChartSectionData(
                value: rejectedCount.toDouble(),
                title: 'Từ chối',
                color: Colors.red,
                radius: 100,
                titleStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              PieChartSectionData(
                value: pendingCount.toDouble(),
                title: 'Chưa phê duyệt',
                color: Colors.orange,
                radius: 100,
                titleStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              PieChartSectionData(
                value: unknownCount.toDouble(),
                title: 'Không xác định',
                color: Colors.grey,
                radius: 100,
                titleStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

Widget buildBarChart(int approvedCount, int rejectedCount, int pendingCount, int unknownCount) {
  return Column(
    children: [
      const Text(
        'Biểu đồ cột so sánh trạng thái',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      Container(
        height: 200,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            barGroups: [
              BarChartGroupData(
                x: 0,
                barRods: [
                  BarChartRodData(
                    toY: approvedCount.toDouble(),
                    color: Colors.green,
                    width: 20,
                  ),
                ],
                showingTooltipIndicators: [0],
              ),
              BarChartGroupData(
                x: 1,
                barRods: [
                  BarChartRodData(
                    toY: rejectedCount.toDouble(),
                    color: Colors.red,
                    width: 20,
                  ),
                ],
                showingTooltipIndicators: [0],
              ),
              BarChartGroupData(
                x: 2,
                barRods: [
                  BarChartRodData(
                    toY: pendingCount.toDouble(),
                    color: Colors.orange,
                    width: 20,
                  ),
                ],
                showingTooltipIndicators: [0],
              ),
              BarChartGroupData(
                x: 3,
                barRods: [
                  BarChartRodData(
                    toY: unknownCount.toDouble(),
                    color: Colors.grey,
                    width: 20,
                  ),
                ],
                showingTooltipIndicators: [0],
              ),
            ],
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (double value, TitleMeta meta) {
                    switch (value.toInt()) {
                      case 0:
                        return const Text('Đã duyệt', style: TextStyle(fontSize: 10));
                      case 1:
                        return const Text('Từ chối', style: TextStyle(fontSize: 10));
                      case 2:
                        return const Text('Chưa phê duyệt', style: TextStyle(fontSize: 10));
                      case 3:
                        return const Text('Không xác định', style: TextStyle(fontSize: 10));
                      default:
                        return const Text('');
                    }
                  },
                  reservedSize: 30,
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

Widget buildLineChart(int approvedCount, int rejectedCount, int pendingCount, int unknownCount, bool isAnnual) {
  return Column(
    children: [
      Text(
        isAnnual ? 'Biểu đồ đường trạng thái năm' : 'Biểu đồ đường trạng thái tháng',
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      Container(
        height: 200,
        child: LineChart(
          LineChartData(
            titlesData: FlTitlesData(show: true),
            borderData: FlBorderData(show: true),
            gridData: FlGridData(show: true),
            lineBarsData: [
              LineChartBarData(
                spots: [
                  FlSpot(0, approvedCount.toDouble()),
                  FlSpot(1, rejectedCount.toDouble()),
                  FlSpot(2, pendingCount.toDouble()),
                  FlSpot(3, unknownCount.toDouble()),
                ],
                isCurved: true,
                color: Colors.blue,
                dotData: FlDotData(show: false),
                belowBarData: BarAreaData(show: false),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
Widget buildBarChart1(int createdCount, int notCreatedCount) {
  return Column(
    children: [
      const Text(
        'Biểu đồ cột số người đã tạo và chưa tạo KPI',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      Container(
        height: 200,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    switch (value.toInt()) {
                      case 0:
                        return const Text('Đã tạo', style: TextStyle(fontSize: 10));
                      case 1:
                        return const Text('Chưa tạo', style: TextStyle(fontSize: 10));
                      default:
                        return const Text('');
                    }
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true),
              ),
            ),
            borderData: FlBorderData(show: true),
            barGroups: [
              BarChartGroupData(
                x: 0,
                barRods: [
                  BarChartRodData(
                    toY: createdCount.toDouble(),
                    color: Colors.green,
                    width: 20,
                  ),
                ],
              ),
              BarChartGroupData(
                x: 1,
                barRods: [
                  BarChartRodData(
                    toY: notCreatedCount.toDouble(),
                    color: Colors.red,
                    width: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

}