import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_api/mausacvakichthuoc/constants1.dart';
import 'package:flutter_login_api/models/usuario.dart';
import 'package:flutter_login_api/providers/usuario_provider.dart';
import 'package:flutter_login_api/providers/usuario_provider1.dart';
import 'package:flutter_login_api/screens/main/components/side_menu.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_login_api/screens/trangchu/canhan/giaodien.dart';
import 'package:flutter_login_api/screens/trangchu/truongphong/truongphong.dart';
import 'package:flutter_login_api/xuatfile/pdf_export_web.dart'
    if (dart.library.io) 'package:flutter_login_api/xuatfile/pdf_export_mobile.dart';
import 'package:provider/provider.dart';
import 'dart:convert'; // Để sử dụng jsonEncode
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';
import 'package:printing/printing.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io' show Platform; // Để kiểm tra mobile, desktop// Để kiểm tra web
import 'package:flutter_login_api/xuatfile/csv_export_web.dart'
    if (dart.library.io) 'package:flutter_login_api/xuatfile/csv_export_mobile.dart';

class TongKet extends StatefulWidget {
  final String userEmail;
  final String displayName;
  final String? photoURL;

  TongKet({required this.userEmail, required this.displayName, this.photoURL});

  @override
  _TongKetScreenState createState() => _TongKetScreenState();
}

class _TongKetScreenState extends State<TongKet> {
  List<Usuario> nhanViens = [];
  bool isLoading = true;
  final TextEditingController _yearController = TextEditingController();
  int currentYear = DateTime.now().year;
  bool _isLoading = false;
  Map<String, String> statusMap = {};
  Map<String, double> tyleHoanThanhMap = {};
  String userPosition = '';

  @override
  void initState() {
    super.initState();
    _yearController.text = currentYear.toString();
    _fetchNhanViens();
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

  Future<void> _fetchNhanViens() async {
    try {
      final usuarioProvider =
          Provider.of<Usuario_provider>(context, listen: false);
      await usuarioProvider.getNhanVien();
      setState(() {
        nhanViens = usuarioProvider.usuarios;
        isLoading = false;
      });
      await _fetchStatuses();
      await _fetchTyLeHoanThanh();
    } catch (error) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchStatuses() async {
    final year = int.tryParse(_yearController.text);
    if (year != null) {
      setState(() {
        _isLoading = true;
      });
      try {
        for (var nhanVien in nhanViens) {
          int trangthai =
              await Provider.of<Usuario_provider1>(context, listen: false)
                  .KPICNTTByMaNVvaNam(nhanVien.maNv, year);
          String message;
          if (trangthai == 1) {
            message = 'Đã duyệt';
          } else if (trangthai == 2) {
            message = 'Từ chối';
          } else if (trangthai == 0) {
            message = 'Chưa phê duyệt';
          } else if (trangthai == 4) {
            message = 'Đã đánh giá';
          } else {
            message = 'Trạng thái không xác định';
          }
          statusMap[nhanVien.maNv] = message;
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Lỗi khi tải trạng thái: $error")),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showDanhSachKhenThuong(BuildContext context) {
    // Lọc danh sách nhân viên có tỷ lệ hoàn thành trên 70%
    List<String> danhSachKhenThuong = nhanViens
        .where((nhanVien) => (tyleHoanThanhMap[nhanVien.maNv] ?? 0.0) > 70.0)
        .map((nhanVien) => nhanVien.tenNv)
        .toList();

    // Hiển thị danh sách nhân viên được khen thưởng trong một AlertDialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[200],
          title: Text("Danh sách nhân viên được khen thưởng"),
          content: danhSachKhenThuong.isNotEmpty
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: danhSachKhenThuong
                      .map((tenNv) => Text("- $tenNv"))
                      .toList(),
                )
              : Text("Không có nhân viên nào đạt khen thưởng."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Đóng"),
            ),
          ],
        );
      },
    );
  }

  void _showDanhSachKyLuat(BuildContext context) {
    // Lọc danh sách nhân viên có tỷ lệ hoàn thành trên 70%
    List<String> danhSachKhenThuong = nhanViens
        .where((nhanVien) => (tyleHoanThanhMap[nhanVien.maNv] ?? 0.0) < 50)
        .map((nhanVien) => nhanVien.tenNv)
        .toList();

    // Hiển thị danh sách nhân viên được khen thưởng trong một AlertDialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[200],
          title: Text("Danh sách nhân viên bị kỷ luật"),
          content: danhSachKhenThuong.isNotEmpty
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: danhSachKhenThuong
                      .map((tenNv) => Text("- $tenNv"))
                      .toList(),
                )
              : Text("Không có nhân viên nào bị kỉ luật."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Đóng"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _fetchTyLeHoanThanh() async {
    final year = int.tryParse(_yearController.text);
    print("Year: $year");

    if (year != null) {
      for (var nhanVien in nhanViens) {
        print("Fetching tỷ lệ cho nhân viên: ${nhanVien.maNv}");
        try {
          double tyLeHoanThanh =
              await Provider.of<Usuario_provider1>(context, listen: false)
                  .GetTyLeHoanThanhByMaNVvaNam(nhanVien.maNv, year);
          if (tyLeHoanThanh < 0) {
            tyLeHoanThanh = 0.0;
          }
          tyleHoanThanhMap[nhanVien.maNv] = tyLeHoanThanh;
          print("Tỷ lệ hoàn thành cho ${nhanVien.maNv}: $tyLeHoanThanh");
        } catch (error) {
          print("Lỗi khi lấy tỷ lệ: $error");
          tyleHoanThanhMap[nhanVien.maNv] = 0.0;
        }
      }
      print("Bản đồ tỷ lệ hoàn thành: $tyleHoanThanhMap");
      setState(() {});
    } else {
      print("Year không hợp lệ.");
    }
  }

  Future<void> _validateAndFetchData() async {
    if (_yearController.text.isEmpty ||
        int.tryParse(_yearController.text) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Vui lòng nhập năm hợp lệ")),
      );
      return;
    }
    setState(() {
      isLoading = true;
    });
    await _fetchNhanViens();
  }

  Widget _buildBarChart() {
    return charts.BarChart(
      _createChartData(),
      animate: true,
      vertical: false, // Đặt thành false để hiển thị biểu đồ thanh ngang
      behaviors: [
        charts.ChartTitle('Tỷ lệ hoàn thành (%)',
            behaviorPosition: charts.BehaviorPosition.start,
            titleOutsideJustification: charts.OutsideJustification.middle),
      ],
    );
  }

  List<charts.Series<ChartData, String>> _createChartData() {
    int countDat = 0; // Số lượng nhân viên đạt
    int countKhongDat = 0; // Số lượng nhân viên không đạt

    for (var nhanVien in nhanViens) {
      double tyLe = tyleHoanThanhMap[nhanVien.maNv] ?? 0.0;
      if (tyLe >= 70) {
        countDat++; // Nhân viên đạt
      } else {
        countKhongDat++; // Nhân viên không đạt
      }
    }

    List<ChartData> data = [
      ChartData('Đạt', countDat), // Nhân viên đạt
      ChartData('Không đạt', countKhongDat), // Nhân viên không đạt
    ];

    return [
      charts.Series<ChartData, String>(
        id: 'Tỷ lệ hoàn thành',
        colorFn: (ChartData sales, _) => sales.category == 'Đạt'
            ? charts.MaterialPalette.green.shadeDefault // Màu cho đạt
            : charts.MaterialPalette.red.shadeDefault, // Màu cho không đạt
        domainFn: (ChartData sales, _) =>
            sales.category, // Sử dụng nhãn 'Đạt' hoặc 'Không đạt'
        measureFn: (ChartData sales, _) => sales.count, // Số lượng nhân viên
        data: data,
      ),
    ];
  }

  Future<Uint8List> generatePDF() async {
    final pdf = pw.Document();

    // Tải phông chữ hỗ trợ tiếng Việt
    final fontData = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
    final robotoFont = pw.Font.ttf(fontData);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Báo cáo Tỷ lệ Hoàn Thành Nhân Viên',
                style: pw.TextStyle(
                  font: robotoFont,
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Tên Nhân Viên, Tỷ lệ Hoàn Thành',
                style: pw.TextStyle(font: robotoFont, fontSize: 16),
              ),
              pw.Divider(),
              ...nhanViens.map((nhanVien) {
                double tyLe = tyleHoanThanhMap[nhanVien.maNv] ?? 0.0;
                return pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 4.0),
                  child: pw.Text(
                    '${nhanVien.tenNv}, $tyLe%',
                    style: pw.TextStyle(font: robotoFont, fontSize: 14),
                  ),
                );
              }).toList(),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  Future<void> exportPDF() async {
    final pdfBytes = await generatePDF();

    // Lưu PDF trên Web
    savePdf(context, pdfBytes);
  }

  Future<void> exportCSVHandler(
      List<dynamic> nhanViens, Map<String, double> tyleHoanThanhMap) async {
    List<List<dynamic>> rows = [];

    // Dòng tiêu đề
    rows.add(["Tên Nhân Viên", "Tỷ lệ Hoàn Thành"]);

    // Dữ liệu từ danh sách nhân viên
    for (var nhanVien in nhanViens) {
      double tyLe = tyleHoanThanhMap[nhanVien.maNv] ?? 0.0;
      rows.add([nhanVien.tenNv, tyLe]);
    }

    // Kiểm tra nền tảng
    if (kIsWeb) {
      print("Đang chạy trên nền tảng Web.");
    } else if (Platform.isAndroid) {
      print("Đang chạy trên nền tảng Android.");
    } else if (Platform.isIOS) {
      print("Đang chạy trên nền tảng iOS.");
    } else if (Platform.isLinux) {
      print("Đang chạy trên nền tảng Linux.");
    } else if (Platform.isMacOS) {
      print("Đang chạy trên nền tảng macOS.");
    } else if (Platform.isWindows) {
      print("Đang chạy trên nền tảng Windows.");
    } else {
      print("Nền tảng không xác định.");
    }

    // Gọi hàm export dựa trên nền tảng
    await exportCSV(context, "Danh sách kết quả đánh giá sinh viên.csv", rows);
  }

  @override
  Widget build(BuildContext context) {
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
                      title: "In báo cáo",
                      svgSrc: "assets/icons/menu_doc.svg",
                      press: exportPDF,
                    ),
                    DrawerListTile(
                      title: "Xuất CSV",
                      svgSrc: "assets/icons/menu_notification.svg",
                      press: () async {
                        await exportCSVHandler(nhanViens, tyleHoanThanhMap);
                      },
                    ),
                    DrawerListTile(
                      title: "Danh sách khen thưởng",
                      svgSrc: "assets/icons/menu_profile.svg",
                      press: () {
                        _showDanhSachKhenThuong(context);
                      },
                    ),
                    DrawerListTile(
                      title: "Danh sách kỷ luật",
                      svgSrc: "assets/icons/menu_setting.svg",
                      press: () {
                        _showDanhSachKyLuat(context);
                      },
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
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _yearController,
                        decoration: InputDecoration(
                          labelText: 'Nhập năm',
                          labelStyle: TextStyle(color: Colors.blue),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _validateAndFetchData,
                        child: Text('Lấy dữ liệu'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor:
                              const Color.fromARGB(255, 110, 187, 117),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: isLoading
                            ? Center(child: CircularProgressIndicator())
                            : Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: ListView.builder(
                                      itemCount: nhanViens.length,
                                      itemBuilder: (context, index) {
                                        final nhanVien = nhanViens[index];
                                        final trangthai =
                                            statusMap[nhanVien.maNv] ??
                                                'Chưa xác định';
                                        final tyleHoanThanh =
                                            tyleHoanThanhMap[nhanVien.maNv] ??
                                                0.0;

                                        return ListTile(
                                          title: Text(
                                            nhanVien.tenNv,
                                            style: TextStyle(
                                                color: Colors
                                                    .blue), // Color for employee name
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Trạng thái: $trangthai',
                                                style: TextStyle(
                                                  color: trangthai == 'Đã duyệt'
                                                      ? Colors.green
                                                      : trangthai == 'Từ chối'
                                                          ? Colors.red
                                                          : Colors
                                                              .orange, // Color based on status
                                                ),
                                              ),
                                              Text(
                                                'Tỷ lệ hoàn thành: $tyleHoanThanh%',
                                                style: TextStyle(
                                                  color: tyleHoanThanh == 100
                                                      ? Color.fromARGB(
                                                          255, 205, 29, 29)
                                                      : Color.fromARGB(
                                                          255,
                                                          107,
                                                          137,
                                                          227), // Color based on completion rate
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: charts.BarChart(
                                            _createChartData(),
                                            animate: true,
                                            behaviors: [
                                              charts.ChartTitle(
                                                'Tỷ lệ hoàn thành (%)',
                                                behaviorPosition: charts
                                                    .BehaviorPosition.start,
                                                titleOutsideJustification:
                                                    charts.OutsideJustification
                                                        .middle,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                      ],
                                    ),
                                  ),
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
                      title: "In báo cáo",
                      svgSrc: "assets/icons/menu_doc.svg",
                      press: exportPDF,
                    ),
                    DrawerListTile(
                      title: "Xuất CSV",
                      svgSrc: "assets/icons/menu_notification.svg",
                      press: () async {
                        await exportCSVHandler(nhanViens, tyleHoanThanhMap);
                      },
                    ),
                    DrawerListTile(
                      title: "Danh sách khen thưởng",
                      svgSrc: "assets/icons/menu_profile.svg",
                      press: () {
                        _showDanhSachKhenThuong(context);
                      },
                    ),
                    DrawerListTile(
                      title: "Danh sách kỷ luật",
                      svgSrc: "assets/icons/menu_setting.svg",
                      press: () {
                        _showDanhSachKyLuat(context);
                      },
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
            ),
            appBar: AppBar(
              title: Row(
                children: [
                  const Icon(Icons.assessment,
                      color: Colors.green, size: 28), // Thêm icon trang trí
                  const SizedBox(width: 10),
                  const Text(
                    'TỔNG KẾT',
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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _yearController,
                    decoration: InputDecoration(
                      labelText: 'Nhập năm',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _validateAndFetchData,
                    child: Text('Lấy dữ liệu'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 110, 187, 117),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: isLoading
                        ? Center(child: CircularProgressIndicator())
                        : LayoutBuilder(
                            builder: (context, constraints) {
                              // Kiểm tra chiều rộng màn hình
                              if (constraints.maxWidth < 600) {
                                // Với màn hình nhỏ: Sắp xếp dọc
                                return Column(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: ListView.builder(
                                        itemCount: nhanViens.length,
                                        itemBuilder: (context, index) {
                                          final nhanVien = nhanViens[index];
                                          final trangthai =
                                              statusMap[nhanVien.maNv] ??
                                                  'Chưa xác định';
                                          final tyleHoanThanh =
                                              tyleHoanThanhMap[nhanVien.maNv] ??
                                                  0.0;

                                          return ListTile(
                                            title: Text(
                                              nhanVien.tenNv,
                                              style:
                                                  TextStyle(color: Colors.blue),
                                            ),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Trạng thái: $trangthai',
                                                  style: TextStyle(
                                                    color: trangthai ==
                                                            'Đã duyệt'
                                                        ? Colors.green
                                                        : trangthai == 'Từ chối'
                                                            ? Colors.red
                                                            : Colors.orange,
                                                  ),
                                                ),
                                                Text(
                                                  'Tỷ lệ hoàn thành: $tyleHoanThanh%',
                                                  style: TextStyle(
                                                    color: tyleHoanThanh == 100
                                                        ? Color.fromARGB(
                                                            255, 205, 29, 29)
                                                        : Color.fromARGB(
                                                            255, 107, 137, 227),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Expanded(
                                      flex: 1,
                                      child: charts.BarChart(
                                        _createChartData(),
                                        animate: true,
                                        behaviors: [
                                          charts.ChartTitle(
                                            'Tỷ lệ hoàn thành (%)',
                                            behaviorPosition:
                                                charts.BehaviorPosition.start,
                                            titleOutsideJustification: charts
                                                .OutsideJustification.middle,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                // Với màn hình lớn: Sắp xếp ngang
                                return Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: ListView.builder(
                                        itemCount: nhanViens.length,
                                        itemBuilder: (context, index) {
                                          final nhanVien = nhanViens[index];
                                          final trangthai =
                                              statusMap[nhanVien.maNv] ??
                                                  'Chưa xác định';
                                          final tyleHoanThanh =
                                              tyleHoanThanhMap[nhanVien.maNv] ??
                                                  0.0;

                                          return ListTile(
                                            title: Text(
                                              nhanVien.tenNv,
                                              style:
                                                  TextStyle(color: Colors.blue),
                                            ),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Trạng thái: $trangthai',
                                                  style: TextStyle(
                                                    color: trangthai ==
                                                            'Đã duyệt'
                                                        ? Colors.green
                                                        : trangthai == 'Từ chối'
                                                            ? Colors.red
                                                            : Colors.orange,
                                                  ),
                                                ),
                                                Text(
                                                  'Tỷ lệ hoàn thành: $tyleHoanThanh%',
                                                  style: TextStyle(
                                                    color: tyleHoanThanh == 100
                                                        ? Color.fromARGB(
                                                            255, 205, 29, 29)
                                                        : Color.fromARGB(
                                                            255, 107, 137, 227),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: charts.BarChart(
                                        _createChartData(),
                                        animate: true,
                                        behaviors: [
                                          charts.ChartTitle(
                                            'Tỷ lệ hoàn thành (%)',
                                            behaviorPosition:
                                                charts.BehaviorPosition.start,
                                            titleOutsideJustification: charts
                                                .OutsideJustification.middle,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                  ),
                ],
              ),
            ),
          );
        }
      }),
    );
  }
}

class ChartData {
  final String category; // Nhãn cho đạt hoặc không đạt
  final int count; // Số lượng nhân viên

  ChartData(this.category, this.count);
}
