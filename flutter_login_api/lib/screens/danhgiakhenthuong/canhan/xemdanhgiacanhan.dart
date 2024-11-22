import 'package:flutter/material.dart';
import 'package:flutter_login_api/mausacvakichthuoc/constants1.dart';
import 'package:flutter_login_api/models/kpibenhvien.dart';
import 'package:flutter_login_api/models/kpicanhan.dart';
import 'package:flutter_login_api/providers/usuario_provider.dart';
import 'package:flutter_login_api/providers/usuario_provider1.dart';
import 'package:flutter_login_api/providers/usuario_provider2.dart';
import 'package:flutter_login_api/screens/capkpi/capkpicanhan/themmuctieukpicanhan.dart';
import 'package:flutter_login_api/screens/capkpi/capkpikhoaphong/themmuctieukpi.dart';
import 'package:flutter_login_api/screens/danhgiakhenthuong/canhan/danhgiacanhan.dart';
import 'package:flutter_login_api/screens/kiemduyetbieumau/nutkiemduyet.dart';
import 'package:flutter_login_api/screens/main/components/side_menu.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Để lấy năm hiện tại
import 'package:fl_chart/fl_chart.dart';

class XemDanhGiaCN extends StatefulWidget {
  final String userEmail;
  final String displayName;
  final String? photoURL;
  final String maNV;
  final int year;
  const XemDanhGiaCN({
    Key? key,
    required this.userEmail,
    required this.displayName,
    this.photoURL,
    required this.maNV,
    required this.year,
  }) : super(key: key);
  @override
  _XemKhoaPhongCNState createState() => _XemKhoaPhongCNState();
}

class _XemKhoaPhongCNState extends State<XemDanhGiaCN> {
  final _yearController = TextEditingController();
  bool _isLoading = false; // Để hiển thị trạng thái đang tải
  bool _isDataVisible = false;
  bool _kiemduyet = true;
  final int currentYear = DateTime.now().year;
  String maphieukpi = '';
  int sotrangthai = 0;
  String _maNVController = '';
  String _employeeName = '';
  List<int> currentSelectedMaqpList = [];
  late int nam;
  final now = DateTime.now();
  Usuario_provider1 kpiProvider = Usuario_provider1();
  @override
  void initState() {
    super.initState();
    // Lấy năm hiện tại và đặt làm giá trị mặc định cho ô năm
    _yearController.text = currentYear.toString();
    _maNVController = widget.maNV;
    nam = widget.year;
    _fetchEmployeeQuyen();
  }

  /// Hàm để lấy chức vụ dựa trên mã nhân viên
  /// Hàm để lấy chức vụ dựa trên mã nhân viên
  Future<String?> _fetchEmployeeQuyen() async {
    // final gmail = widget.userEmail;
    // var result = await Provider.of<Usuario_provider>(context, listen: false)
    //     .GetMaNVByEmail(gmail);

    // print("Fetching data for MaNV: ${result}");
    // _maNVController = result;
    try {
      var resultParam =
          await Provider.of<Usuario_provider>(context, listen: false)
              .getEmployeeQuyenByMaNV(_maNVController);
      _employeeName = resultParam;
      print("xem maquyen: $_employeeName");
      return resultParam; // Trả về giá trị để có thể sử dụng sau này
    } catch (e) {
      print('Đã xảy ra lỗi: $e');
      return null;
    }
  }

  Future<void> _trangthai() async {
    final year = int.tryParse(_yearController.text); // Nhận năm từ TextField

    if (year != null) {
      setState(() {
        _isLoading = true; // Hiển thị vòng tròn tải trong khi gọi API
      });

      try {
        // Gọi API để lấy trạng thái KPI cá nhân dựa trên mã NV và năm
        int trangthai =
            await Provider.of<Usuario_provider1>(context, listen: false)
                .KPICNTTByMaNVvaNam(_maNVController, year); // Lấy trạng thái

        // Kiểm tra giá trị trạng thái
        if (trangthai != null && trangthai != -1) {
          // Nếu trạng thái không phải -1
          setState(() {
            sotrangthai = trangthai; // Cập nhật trạng thái
            print(sotrangthai); // In trạng thái để debug
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Không tìm thấy KPI cá nhân cho nhân viên này!')),
          );
        }
      } catch (error) {
        // Hiển thị lỗi nếu có lỗi xảy ra trong quá trình gọi API
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $error')),
        );
      } finally {
        setState(() {
          _isLoading = false; // Tắt vòng tròn tải sau khi gọi API xong
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập năm hợp lệ!')),
      );
    }
  }

  @override
  void dispose() {
    _yearController.dispose();
    super.dispose();
  }

  // Hàm lấy chi tiết KPI cá nhân
  Future<void> _fetchKPI() async {
    final year = int.tryParse(_yearController.text);
    final manv = _maNVController;
    print('Year input: $year'); // Kiểm tra giá trị nhập từ TextField
    print('Year input: $manv');
    if (year != null) {
      setState(() {
        _isLoading = true;
      });

      try {
        print('Fetching data for year: $year'); // Bắt đầu gọi API với year

        // Lấy chi tiết KPI cá nhân chỉ dựa trên năm
        await Provider.of<Usuario_provider1>(context, listen: false)
            .ChiTietKPICNByMaNVvaNamAll(manv, year);

        print(
            'Data fetched successfully'); // Kiểm tra nếu dữ liệu được fetch thành công

        setState(() {
          _isDataVisible = true;
        });
      } catch (error) {
        print('Error fetching data: $error'); // In ra lỗi nếu có
        setState(() {
          _isDataVisible = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Dữ liệu không tồn tại')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
        print(
            'Loading completed'); // Xác nhận hoàn thành quá trình fetch dữ liệu
      }
    } else {
      print('Invalid year input'); // Kiểm tra trường hợp nhập không hợp lệ
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập năm hợp lệ!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Usuario_provider1 usuarioProvider1 =
        Provider.of<Usuario_provider1>(context, listen: false);
    String? selectedChucDanh;

    return Consumer<Usuario_provider1>(
      builder: (context, usuarioProvider1, child) {
        final kpicntt = usuarioProvider1.chitiietkpicanhan;

        return Scaffold(
          backgroundColor: bgColor,
          drawer: MediaQuery.of(context).size.width < 600
              ? SideMenu(
                  userEmail: widget.userEmail,
                  displayName: widget.displayName,
                  photoURL: widget.photoURL!,
                )
              : null,
          body: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth >= 600) {
                return Row(
                  children: [
                    // Menu bên trái
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
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                    // Nội dung bên phải
                    Expanded(
                      child: Column(
                        children: [
                          // Phần biểu đồ trên _Laydulieu
                          Container(
                            padding: const EdgeInsets.all(16),
                            height: 150, // Chiều cao biểu đồ
                            child: _buildCompletionChart(usuarioProvider1
                                .chitiietkpicanhan
                                .map((kpi) =>
                                    kpi.tylehoanthanh?.toDouble() ??
                                    0.0) // Gán giá trị mặc định nếu null
                                .toList()),
                          ),
                          const SizedBox(height: 5),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(16.0),
                              child: _Laydulieu(), // Gọi _Laydulieu() bên dưới
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                // Bố cục cho màn hình nhỏ hơn
                return Stack(
                  children: [
                    Column(
                      children: [
                        // Phần biểu đồ cho màn hình nhỏ
                        Container(
                          padding: const EdgeInsets.only(top: 16),
                          height: 150,
                          child: _buildCompletionChart(usuarioProvider1
                              .chitiietkpicanhan
                              .map((kpi) => kpi.tylehoanthanh!.toDouble())
                              .toList()),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(
                                top: 56.0,
                                left: 16.0,
                                right: 16.0,
                                bottom: 16.0),
                            child: _Laydulieu(),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: 16,
                      left: 16,
                      child: IconButton(
                        icon: const Icon(Icons.menu,
                            size: 32, color: Colors.black),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
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

  Widget _Laydulieu() {
    return Center(
      child: SingleChildScrollView(
        // Bọc toàn bộ nội dung trong SingleChildScrollView để tránh tràn
        child: Container(
          padding: const EdgeInsets.all(16),
          width: MediaQuery.of(context).size.width * 0.85,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            border: Border.all(color: Colors.blueAccent),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 0.2,
                blurRadius: 2,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  'Đánh giá biểu mẫu KPI cá nhân năm $nam',
                  style: TextStyle(fontSize: 21, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _yearController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Năm',
                        labelStyle: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () async {
                      await _fetchKPI();
                      await _trangthai();
                    },
                    child: const Text('Lấy Chi Tiết biểu mẫu',
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: Color.fromARGB(255, 110, 187, 117),
                      shadowColor: Colors.greenAccent,
                      elevation: 5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (_isDataVisible)
                SingleChildScrollView(
                  child: Center(
                    child: Consumer<Usuario_provider1>(
                      builder: (ctx, kpiProvider, child) {
                        return Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              width: MediaQuery.of(context).size.width * 0.85,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                border: Border.all(color: Colors.blueAccent),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 0.2,
                                    blurRadius: 2,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                    columnSpacing: 20.0,
                                    columns: const [
                                      DataColumn(label: Text('Nội Dung KPI')),
                                      DataColumn(label: Text('Tiêu chí')),
                                      DataColumn(label: Text('Kế hoạch')),
                                      DataColumn(label: Text('Thực hiện')),
                                      DataColumn(
                                          label: Text('Tỷ lệ hoàn thành')),
                                    ],
                                    rows: kpiProvider.chitiietkpicanhan.isEmpty
                                        ? []
                                        : kpiProvider.chitiietkpicanhan.map(
                                            (kpiDetail) {
                                              maphieukpi =
                                                  kpiDetail.maphieukpicanhan;
                                              currentSelectedMaqpList
                                                  .add(kpiDetail.makpi);
                                              return DataRow(cells: [
                                                DataCell(
                                                  Container(
                                                    width: 250,
                                                    child: Text(
                                                      kpiDetail
                                                          .noidungkpicanhan,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      softWrap: true,
                                                    ),
                                                  ),
                                                ),
                                                DataCell(
                                                  Text(
                                                    kpiDetail
                                                            .tieuchidanhgiaketqua ??
                                                        '',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                ),
                                                DataCell(
                                                  Text(
                                                    kpiDetail.kehoach ?? '',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                ),
                                                DataCell(
                                                  Text(
                                                    kpiDetail.thuchien ?? '',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                ),
                                                DataCell(
                                                  Text(
                                                    kpiDetail.tylehoanthanh
                                                        .toString(),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                ),
                                              ]);
                                            },
                                          ).toList(),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            if (_isDataVisible && sotrangthai == 0)
                              const Text(
                                  'Biểu mẫu chưa đủ điều kiện được phê duyệt.'),
                            if (_isDataVisible && sotrangthai == 2)
                              const Text(
                                  'Biểu mẫu chưa đủ điều kiện được phê duyệt.'),
                            if (_isDataVisible && sotrangthai == 3)
                              const Text(
                                  'Biểu mẫu chưa đủ điều kiện được phê duyệt.'),
                            if (_isDataVisible && sotrangthai == 4) ...[
                              const Text('Biểu mẫu đã được đánh giá.'),
                            ],
                            if (_isDataVisible && sotrangthai == 1)
                              const Text('Biểu mẫu chưa đánh giá.'),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

// Widget to build the chart
  Widget _buildCompletionChart(List<double> completionRates) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 100, // Giới hạn trục Y để tỷ lệ hoàn thành 100% là tối đa
        barGroups: completionRates.asMap().entries.map((entry) {
          int index = entry.key;
          double completionRate = entry.value;
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: completionRate,
                color: completionRate >= 80
                    ? Color.fromARGB(255, 244, 112, 18)
                    : completionRate >= 50
                        ? Colors.yellow
                        : Colors.red, // Màu thay đổi theo tỷ lệ hoàn thành
                width: 20,
                borderRadius: BorderRadius.circular(5),
              ),
            ],
          );
        }).toList(),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                return Text(
                  'KPI ${value.toInt() + 1}', // Hiển thị tên cột
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (double value, TitleMeta meta) {
                return Text(
                  '${value.toInt()}%',
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 10,
                  ),
                );
              },
            ),
          ),
        ),
        gridData: FlGridData(
          show: true,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.shade300,
              strokeWidth: 0.5,
            );
          },
        ),
      ),
    );
  }
}
