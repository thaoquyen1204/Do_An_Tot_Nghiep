import 'package:flutter/material.dart';
import 'package:flutter_login_api/mausacvakichthuoc/constants1.dart';
import 'package:flutter_login_api/models/modelchucdanh.dart';
import 'package:flutter_login_api/providers/usuario_provider.dart';
import 'package:flutter_login_api/providers/usuario_provider1.dart';
import 'package:flutter_login_api/providers/usuario_provider2.dart';
import 'package:flutter_login_api/screens/capkpi/capkpibieumauchucvu/capkpibieumauchucvu.dart';
import 'package:flutter_login_api/screens/kiemduyetbieumau/canhan/chitietcanhanbm.dart';
import 'package:flutter_login_api/screens/kiemduyetbieumau/khoaphongcn/chitietbieumauchucdanh.dart';
import 'package:flutter_login_api/screens/kiemduyetbieumau/trangchubm.dart';
import 'package:flutter_login_api/screens/kiemduyetbieumau/trangchubmcn.dart';
import 'package:flutter_login_api/screens/main/components/side_menu.dart';
import 'package:googleapis/books/v1.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;
// Dùng để xem trạng thái kpi của biểu mẫu cá nhân
class DanhsachBieuMauCaNhan extends StatefulWidget {
    final String userEmail;
  final String displayName;
  final String? photoURL;
   const DanhsachBieuMauCaNhan({
    Key? key,
    required this.userEmail,
    required this.displayName,
    this.photoURL,
  }) : super(key: key);
  @override
  _DanhsachBieuMauCaNhanGridScreenState createState() => _DanhsachBieuMauCaNhanGridScreenState();
}

class _DanhsachBieuMauCaNhanGridScreenState extends State<DanhsachBieuMauCaNhan> {
  List<ChucDanh> chucDanhs = [];
  bool isLoading = true;
  final TextEditingController _yearController = TextEditingController();
  int currentYear = DateTime.now().year;
  bool _isLoading = false;
  Map<String, String> statusMap = {};
 late String userPosition;
  @override
  void initState() {
    super.initState();
    _fetchChucDanh();
    _fetchEmployeeQuyen();
    _yearController.text = currentYear.toString();
  }

  Future<void> _fetchChucDanh() async {
    try {
      final usuarioProvider =
          Provider.of<Usuario_provider>(context, listen: false);
      await usuarioProvider.getChucdanh();
      setState(() {
        chucDanhs = usuarioProvider.chucdanh;
        isLoading = false;
      });
      await _trangthai();
    } catch (error) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _trangthai() async {
    final year = int.tryParse(_yearController.text);
    if (year != null) {
      setState(() {
        _isLoading = true;
      });
      try {
        chucDanhs = chucDanhs.toSet().toList();
        for (var chucdanh in chucDanhs) {
          int trangthai =
              await Provider.of<Usuario_provider2>(context, listen: false)
                  .CheckNamPhieuKpiKP(year, chucdanh.maChucDanh);
          String message;
          if (trangthai == 1) {
            message = 'Đã duyệt';
          } else if (trangthai == 2) {
            message = 'Từ chối';
          } else if (trangthai == 0) {
            message = 'Chưa phê duyệt';
          } else {
            message = 'Biễu mẫu chưa được tạo';
          }
          statusMap[chucdanh.maChucDanh] = message;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cập nhật trạng thái thành công!')),
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
    final uniqueChucDanhs = chucDanhs.toSet().toList();

    return Scaffold(
      backgroundColor: bgColor,
      drawer: MediaQuery.of(context).size.width < 600 ?  SideMenu( userEmail: widget.userEmail,
                    displayName: widget.displayName,
                    photoURL: widget.photoURL!,) : null,
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
                        title: "Xem biểu mẫu",
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
        MaterialPageRoute(builder: (context) => TrangChuBM(userEmail: widget.userEmail,
              displayName: widget.displayName,
              photoURL: widget.photoURL!,)),
      );
    } else if (userPosition == "NV") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TrangChuBMCN(userEmail: widget.userEmail,
              displayName: widget.displayName,
              photoURL: widget.photoURL!,)),
      );
    }
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Danh sách biểu mẫu',
                  style: TextStyle(
                    fontSize: 21,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        // TextField để nhập năm
        Row(
          children: [
            Text(
              'Năm: ',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(width: 8), // Khoảng cách giữa chữ "Năm:" và TextField
            Container(
              width: 60, // Độ rộng của TextField
              child: TextField(
                controller: _yearController,
                keyboardType: TextInputType.number, // Chỉ cho phép nhập số
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                ),
                onSubmitted: (value) {
                  // Hàm xử lý khi người dùng nhấn Enter
                  setState(() {
                    currentYear = int.tryParse(value) ?? currentYear; // Cập nhật năm
                  });
                },
              ),
            ),
            SizedBox(width: 16), // Khoảng cách giữa TextField và nút
            ElevatedButton(
              onPressed: _trangthai, // Gọi hàm khi nhấn nút
              child: Text('Kiểm tra'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Màu nền
                foregroundColor: Colors.white, // Màu văn bản
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Bo góc nút
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        
        Expanded(
          flex: 2,
          child: _buildStatusBarChart(), // Biểu đồ ở đây
        ),
        const SizedBox(height: 20),
        Expanded(
          flex: 5,
          child: ChucDanhGrid(context), // Đặt grid vào đây
        ),
      ],
    ),
  ),
)
              ],
            );
          } else {
            return Stack(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                      top: 56.0, left: 16.0, right: 16.0, bottom: 16.0),
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
                                'Cấp KPI BIỂU MẪU CHỨC VỤ CÁ NHÂN',
                                style: TextStyle(
                                  fontSize: 26,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 4),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                        Expanded(
                          flex: 2,
                          child: _buildStatusBarChart(), // Biểu đồ ở đây
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          flex: 5,
                          child: ChucDanhGrid(context), // Đặt grid vào đây
                        ),
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

  Widget ChucDanhGrid(BuildContext context) {
    final uniqueChucDanhs = chucDanhs.toSet().toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = constraints.maxWidth > 1200
            ? 5
            : constraints.maxWidth > 800
                ? 4
                : constraints.maxWidth > 600
                    ? 2
                    : 1;

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            childAspectRatio: 0.8,
          ),
          itemCount: uniqueChucDanhs.length,
          itemBuilder: (context, index) {
            final chucdanh = uniqueChucDanhs[index];
            String currentStatus =
                statusMap[chucdanh.maChucDanh] ?? 'Chưa kiểm tra';

            return Card(
              color: Colors.grey[200],
              elevation: 4,
              margin: EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Trạng thái: $currentStatus',
                      style: TextStyle(
                        color: currentStatus == 'Đã duyệt'
                            ? Colors.green
                            : currentStatus == 'Từ chối'
                                ? Colors.red
                                : Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    CircleAvatar(
                      radius: 40,
                      child: Icon(Icons.person, size: 40),
                    ),
                    SizedBox(height: 10),
                    Text(
                      chucdanh.tenChucDanh ?? 'Tên chưa cập nhật',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 5),
                    ElevatedButton(
                      onPressed: () {
                        final year = int.tryParse(_yearController.text) ??
                            DateTime.now().year;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChiTietBMCD(
                              maChucDanh: chucdanh.maChucDanh,
                              year: year, userEmail: widget.userEmail, displayName: widget.displayName,photoURL: widget.photoURL,
                            ),
                          ),
                        );
                      },
                      child: Text('Xem chi tiết'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
Widget _buildStatusBarChart() {
  // Chuẩn bị dữ liệu cho biểu đồ
  List<charts.Series<ChartData, String>> series = [
    charts.Series(
      id: 'ChucDanhStatus',
      domainFn: (ChartData data, _) => _shortenChucDanhName(data.tenChucDanh), // Hiển thị tên cắt ngắn
      measureFn: (ChartData data, _) => data.trangThaiIndex, // Giá trị trạng thái
      colorFn: (ChartData data, _) => data.color, // Màu sắc theo trạng thái
      data: _createChartData(), // Dữ liệu trạng thái
      labelAccessorFn: (ChartData row, _) => '${_mapStatus(row.trangThaiIndex)}', // Nhãn cho thanh
    )
  ];

  return Container(
    height: 300,
     // Đặt chiều cao của biểu đồ
    child: charts.BarChart(
      series,
      animate: true,
      vertical: true,
      barRendererDecorator: charts.BarLabelDecorator<String>(), // Hiển thị nhãn trên thanh
      domainAxis: charts.OrdinalAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(
          labelStyle: charts.TextStyleSpec(
            fontSize: 10, // Kích thước nhãn nhỏ
          ),
        ),
      ),
      behaviors: [
        charts.SelectNearest(), // Kích hoạt hành vi rê chuột
        charts.DomainHighlighter(), // Hiển thị đường kẻ khi rê chuột qua thanh
      ],
    ),
  );
}



// Hàm để tạo dữ liệu từ statusMap
List<ChartData> _createChartData() {
  return chucDanhs.map((chucDanh) {
    String status = statusMap[chucDanh.maChucDanh] ?? 'Chưa kiểm tra';
    int statusIndex;
    charts.Color barColor;

    // In thông tin chi tiết về chức danh và mã chức danh
    print('Chức danh: ${chucDanh.tenChucDanh}, Mã chức danh: ${chucDanh.maChucDanh}, Status: $status');

    switch (status) {
      case 'Đã duyệt':
        statusIndex = 3;
        barColor = charts.MaterialPalette.green.shadeDefault;
        break;
      case 'Từ chối':
        statusIndex = 2;
        barColor = charts.MaterialPalette.red.shadeDefault;
        break;
      case 'Chưa phê duyệt':
        statusIndex = 1;
        barColor = charts.MaterialPalette.yellow.shadeDefault;
        break;
      default:
        statusIndex = 0;
        barColor = charts.MaterialPalette.gray.shadeDefault;
    }

    // In thông tin về trạng thái và màu sắc của từng chức danh
    print('Trạng thái: $statusIndex, Màu: $barColor');

    return ChartData(chucDanh.tenChucDanh ?? 'Chưa có tên', statusIndex, barColor);
  }).toList();
}

String _mapStatus(int statusIndex) {
  switch (statusIndex) {
    case 3:
      return 'Đã duyệt';
    case 2:
      return 'Từ chối';
    case 1:
      return 'Chưa phê duyệt';
    default:
      return 'Chưa kiểm tra';
  }
}
// Hàm để cắt ngắn tên chức danh nếu quá dài
String _shortenChucDanhName(String tenChucDanh) {
  if (tenChucDanh.length > 10) {
    return tenChucDanh.substring(0, 8) + "..."; // Cắt ngắn tên nếu dài quá 10 ký tự
  }
  return tenChucDanh;
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
 class ChartData {
  final String tenChucDanh;
  final int trangThaiIndex;
  final charts.Color color;

  ChartData(this.tenChucDanh, this.trangThaiIndex, this.color);
}
