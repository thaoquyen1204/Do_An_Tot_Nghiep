import 'package:flutter/material.dart';
import 'package:flutter_login_api/mausacvakichthuoc/constants1.dart';
import 'package:flutter_login_api/models/chitiettieuchimuctieubv.dart';
import 'package:flutter_login_api/models/kpibenhvien.dart';
import 'package:flutter_login_api/providers/usuario_provider1.dart';
import 'package:flutter_login_api/screens/capkpi/capkpikhoaphong/capkpi.dart';
import 'package:flutter_login_api/screens/capkpi/capkpikhoaphong/datatablekpichitiet.dart';
import 'package:flutter_login_api/screens/capkpi/capkpikhoaphong/themmuctieukpi.dart';
import 'package:flutter_login_api/screens/kiemduyetbieumau/khoaphong/xembieumaukp.dart';
import 'package:flutter_login_api/screens/main/components/side_menu.dart';
import 'package:provider/provider.dart';
import 'package:flutter_login_api/models/kpiphongcntt.dart';
import 'package:flutter_login_api/providers/usuario_provider.dart';
import 'package:flutter/services.dart';
import 'dart:core';

class KpiDetailsScreen extends StatefulWidget {
  final List<int> selectedMaqpList; // Danh sách mã KPI đã chọn
  final String userEmail;
  final String displayName;
  final String? photoURL;

  const KpiDetailsScreen(
      {Key? key,
      required this.userEmail,
      required this.displayName,
      this.photoURL,
      required this.selectedMaqpList})
      : super(key: key);

  @override
  _KpiDetailsScreenState createState() => _KpiDetailsScreenState();
}

class _KpiDetailsScreenState extends State<KpiDetailsScreen> {
  late List<int> currentSelectedMaqpList;
  Map<int, Map<String, String>> kpiDetailsMap = {};
  late Map<int, TextEditingController>
      kehoachControllers; // Quản lý các controller cho kế hoạch
  late Map<int, TextEditingController>
      trongsoControllers; // Quản lý các controller cho trọng số
  Map<int, FocusNode> kehoachFocusNodes =
      {}; // Quản lý FocusNode cho các kế hoạch
  String? kpiCode;
  String? maphieukpi;
  List<Kpiphongcntt> uniqueKpis = [];
  final Usuario_provider1 _kpiApiService = Usuario_provider1();
  int year = DateTime.now().year;
  List<Kpiphongcntt> test = [];

  @override
  void initState() {
    super.initState();
    currentSelectedMaqpList = List.from(widget.selectedMaqpList);
    kehoachControllers = {};
    trongsoControllers = {};
    _fetchKpiCode();
  }

  @override
  void dispose() {
    // Giải phóng tất cả các controller và FocusNode khi không sử dụng
    kehoachControllers.values.forEach((controller) => controller.dispose());
    trongsoControllers.values.forEach((controller) => controller.dispose());
    kehoachFocusNodes.values.forEach((focusNode) => focusNode.dispose());
    super.dispose();
  }

  bool _isDateFormat(String chitieu) {
    final dateRegEx = RegExp(
      r'^(?:(?:[0-2][0-9]|3[01])/(0[1-9]|1[0-2])/\d{4}|' // DD/MM/YYYY
      r'(0[1-9]|1[0-2])/(?:[0-2][0-9]|3[01])/\d{4}|' // MM/DD/YYYY
      r'\d{4}-(0[1-9]|1[0-2])-(?:[0-2][0-9]|3[01])|' // YYYY-MM-DD
      r'(?:[0-2][0-9]|3[01])-(0[1-9]|1[0-2])-\d{4|' // DD-MM-YYYY
      r'(0[1-9]|1[0-2])-(?:[0-2][0-9]|3[01])-\d{4)$', // MM-DD-YYYY
      caseSensitive: false,
    );
    return dateRegEx.hasMatch(chitieu);
  }

  bool _isValidTrongsso(String value) {
    final doubleValue = double.tryParse(value);
    return doubleValue != null && doubleValue >= 0.0 && doubleValue <= 100.0;
  }

  void _removeKpi(int maKpi) {
    setState(() {
      currentSelectedMaqpList.remove(maKpi);
      kpiDetailsMap.remove(maKpi);
      kehoachControllers.remove(maKpi)?.dispose();
      trongsoControllers.remove(maKpi)?.dispose();
      kehoachFocusNodes.remove(maKpi)?.dispose();
    });
  }

  void _removeAllKpis() {
    setState(() {
      currentSelectedMaqpList.clear();
      kpiDetailsMap.clear();
      kehoachControllers.values.forEach((controller) => controller.dispose());
      trongsoControllers.values.forEach((controller) => controller.dispose());
      kehoachFocusNodes.values.forEach((focusNode) => focusNode.dispose());
      kehoachControllers.clear();
      trongsoControllers.clear();
      kehoachFocusNodes.clear();
    });
  }

  void _updateKpiField(int maKpi, String field, String value) {
    setState(() {
      if (kpiDetailsMap.containsKey(maKpi)) {
        kpiDetailsMap[maKpi]![field] = value;
      } else {
        kpiDetailsMap[maKpi] = {field: value};
      }
    });
  }

  Future<void> _fetchKpiCode() async {
    DateTime today = DateTime.now(); // Sử dụng ngày hiện tại
    String? result = await _kpiApiService.getKpiCode(today);

    if (result != null) {
      setState(() {
        kpiCode = result;
      });
    } else {
      setState(() {
        kpiCode = 'Không thể lấy mã phiếu';
      });
    }
  }

  Future<void> _saveKpiData() async {
    try {
      // Đảm bảo rằng ngày nằm trong khoảng hợp lệ của SQL Server
      DateTime validDateTime(DateTime date) {
        DateTime minDate = DateTime(1753, 1, 1);
        if (date.isBefore(minDate)) {
          return minDate;
        }
        return date;
      }

      // Tạo đối tượng Kpibenhvien để lưu dữ liệu
      final kpibenhvien = Kpibenhvien(
        maphieukpibenhvien: kpiCode.toString(),
        namphieu: DateTime.now().year,
        nguoilap: widget.displayName,
        nguoipheduyet: null, // Thay vì null, đặt giá trị mặc định là chuỗi rỗng
        ngaylapphieukpibv:
            validDateTime(DateTime.now()), // Sử dụng hàm kiểm tra
        ngaypheduyet: null,
        idbieumau: 71,
        trangthai: 0,
      );

      // Gọi Provider để lưu thông tin KPI Bệnh Viện
      await Provider.of<Usuario_provider1>(context, listen: false)
          .addKPIBenhVien(kpibenhvien);

      // Hiển thị thông báo thành công
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Đã lưu thông tin KPI.')),
      // );
    } catch (e) {
      // Xử lý khi gặp lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Thêm mới thất bại111: $e')),
      );
    }
  }

  Future<bool> checkKpiStatus(BuildContext context) async {
    try {
      int resultParam =
          await Provider.of<Usuario_provider1>(context, listen: false)
              .CheckNamPhieuKpiBV(DateTime.now().year);

      if (resultParam == 0) {
        // Trạng thái chờ duyệt
        bool? shouldContinue = await _showConfirmationDialog(
            context,
            'Biểu mẫu đang ở trạng thái chờ duyệt.',
            'Bạn có muốn xem lại biểu mẫu không?');

        // Nếu người dùng chọn xem lại, dừng lại (trả về false)
        if (shouldContinue == true) {
          return false;
        }
        return false;
      } else if (resultParam == 1) {
        // Trạng thái đã duyệt
        bool? shouldContinue = await _showConfirmationDialog(context,
            'Biểu mẫu đã được duyệt.', 'Bạn có muốn xem lại biểu mẫu không?');

        // Nếu người dùng chọn xem lại, dừng lại (trả về false)
        if (shouldContinue == true) {
          return false;
        }
        return false;
      } else if (resultParam == 2) {
        // Trạng thái bị từ chối
        bool? shouldReview = await _showConfirmationDialog1(
            context,
            'Biểu mẫu bị từ chối.',
            'Bạn muốn xem lại biểu mẫu hay lưu chỉnh sửa không?');

        if (shouldReview == true) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => XemKhoaPhongBM(
                userEmail: widget.userEmail,
                displayName: widget.displayName,
                photoURL: widget.photoURL,
              ),
            ),
          );
          return false; // Dừng lại nếu người dùng chọn xem lại
        } else {
          // Người dùng chọn lưu chỉnh sửa
          await saveEdits(); // Gọi hàm để lưu chỉnh sửa
          return false; // Cho phép tiếp tục
        }
      } else if (resultParam == 3) {
        // Trạng thái hợp lệ, cho phép tiếp tục
        return true;
      }
    } catch (e) {
      // Gặp lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kiểm tra trạng thái thất bại: $e')),
      );
      return false; // Không cho phép tiếp tục khi gặp lỗi
    }

    return false; // Mặc định dừng lại nếu không có điều kiện nào thỏa mãn
  }

  Future<void> deletechitietKPIBV(String maphieukpi) async {
    final usuarioProvider =
        Provider.of<Usuario_provider1>(context, listen: false);

    try {
      await usuarioProvider.deletecchitietKPIBenhVien(maphieukpi);
    } catch (e) {
      // Có thể hiển thị thêm một thông báo lỗi cho người dùng nếu cần
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi xóa chi tiết KPI: $e')),
      );
    }
  }

  Future<void> saveEditsKPIBV() async {
    if (maphieukpi!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không có mã phiếu để thông qua.')),
      );
      return;
    }

    final usuarioProvider =
        Provider.of<Usuario_provider1>(context, listen: false);

    // Lấy đối tượng Kpicanhan dựa trên mã phiếu
    Kpibenhvien? kpibenhvien =
        await usuarioProvider.getKpibenhvienByMaphieu(maphieukpi!);

    if (kpibenhvien == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không tìm thấy biễu mẫu khoa phòng.')),
      );
      return;
    }

    // Hàm để đảm bảo ngày hợp lệ cho SQL Server
    DateTime validDateTime(DateTime date) {
      DateTime minDate = DateTime(1753, 1, 1);
      return date.isBefore(minDate) ? minDate : date;
    }

    // Cập nhật các trường cần thiết
    kpibenhvien.nguoilap = widget.displayName;
    kpibenhvien.nguoipheduyet = null;
    kpibenhvien.ngaylapphieukpibv = validDateTime(DateTime.now());
    kpibenhvien.ngaypheduyet = null;
    kpibenhvien.trangthai = 0;

    // Gọi API để cập nhật trạng thái KPI cá nhân
    await usuarioProvider.updateKPIBenhVien(kpibenhvien);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Thông qua biễu mẫu thành công!')),
    );
  }

// Hàm để lưu chỉnh sửa
  Future<void> saveEdits() async {
    if (test.length < 5) {
      // Hiển thị cảnh báo nếu ít hơn 5 KPI được chọn
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bạn phải chọn ít nhất 5 mục tiêu trước khi lưu.'),
        ),
      );
      return;
    }
    maphieukpi = await Provider.of<Usuario_provider1>(context, listen: false)
        .getMaphieuKpiBvByNam(year);
    await Provider.of<Usuario_provider1>(context, listen: false)
        .ChiTietKPIBVByNam(year);

    Provider.of<Usuario_provider1>(context, listen: false)
            .chitiettieuchimuctieuBV
            .isEmpty
        ? []
        : Provider.of<Usuario_provider1>(context, listen: false)
            .chitiettieuchimuctieuBV
            .map((kpiDetail) {});

    bool hasEmptyFields = false;

// kiểm tra cac cột đã được điền hêt chưa
    if (test.length != kehoachControllers.length ||
        test.length != trongsoControllers.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Số lượng mục tiêu và trường dữ liệu không khớp.'),
        ),
      );
      return; // Early exit to avoid issues
    }

    if (!KpiApiService.areAllFieldsFilled(
        test, kehoachControllers, trongsoControllers)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Vui lòng điền đầy đủ các mục kế hoạch và trọng số hợp lệ.')),
      );
      return;
    }

    // tính tổng trọng số
    double totalTrongSo = 0;
    for (var controller in trongsoControllers.values) {
      totalTrongSo += double.tryParse(controller.text) ?? 0;
    }

    // Check if the total weight is exactly 100
    if (totalTrongSo != 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Tổng trọng số phải bằng 100. Hiện tại là $totalTrongSo.'),
        ),
      );
      return; // Stop and do not proceed with saving
    }
    // Hiển thị hộp thoại xác nhận
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[200],
          title: const Text('Xác nhận'),
          content: const Text('Bạn có chắc chắn muốn lưu thông tin KPI không?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(false); // Trả về false nếu người dùng chọn "Không"
              },
              child: const Text('Không'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(true); // Trả về true nếu người dùng chọn "Có"
              },
              child: const Text('Có'),
            ),
          ],
        );
      },
    );

    // Nếu người dùng xác nhận, tiến hành lưu
    if (confirmed == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đang lưu thông tin KPI...')),
      );
      await deletechitietKPIBV(maphieukpi!);
      await saveEditsKPIBV();

      // Gọi hàm saveAllKpisToApi khi nhấn nút
      await KpiApiService.saveAllKpisToApi(
        context,
        test,
        maphieukpi!,
        kehoachControllers,
        trongsoControllers,
      );

      // Thông báo hoàn thành
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã hoàn thành lưu thông tin biểu mẫu.')),
      );
    } else {}
  }

// Hàm để hiển thị hộp thoại xác nhận
  Future<bool?> _showConfirmationDialog(
      BuildContext context, String title, String content) async {
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[200],
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Người dùng chọn "Không"
              },
              child: const Text('Không'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Người dùng chọn "Có"
              },
              child: const Text('Có'),
            ),
          ],
        );
      },
    );

    // Nếu người dùng chọn "Có", chuyển đến trang xem biểu mẫu và không tiếp tục lưu
    if (confirmed == true) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => XemKhoaPhongBM(
                  userEmail: widget.userEmail,
                  displayName: widget.displayName,
                  photoURL: widget.photoURL,
                )), // Điều hướng đến trang xem biểu mẫu
      );
      return null; // Ngăn quá trình tiếp tục lưu
    }

    // Nếu người dùng chọn "Không", tiếp tục hành động
    // return confirmed;
    return null;
  }

  Future<bool?> _showConfirmationDialog1(
      BuildContext context, String title, String content) async {
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[200],
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(false); // Người dùng chọn "Lưu chỉnh sửa"
              },
              child: const Text('Lưu chỉnh sửa'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(true); // Người dùng chọn "Xem lại biểu mẫu"
              },
              child: const Text('Xem lại biểu mẫu'),
            ),
          ],
        );
      },
    );

    // Trả về giá trị của confirmed để kiểm tra trong hàm checkKpiStatus
    return confirmed;
  }

 Widget build(BuildContext context) {
    // Lấy đối tượng Usuario_provider
    Usuario_provider usuarioProvider1 =
        Provider.of<Usuario_provider>(context, listen: false);
    String? selectedChucDanh;

    return Consumer<Usuario_provider>(
      builder: (context, usuarioProvider1, child) {
        final kpicntt = usuarioProvider1.kpicntt;

        return Scaffold(
          backgroundColor: bgColor,
          drawer: MediaQuery.of(context).size.width < 600
              ?  SideMenu( userEmail: widget.userEmail,
                    displayName: widget.displayName,
                    photoURL: widget.photoURL!,)
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
                            title: "KPI",
                            svgSrc: "assets/icons/menu_dashboard.svg",
                            press: () {},
                          ),
                          DrawerListTile(
                            title: "Chọn lại",
                            svgSrc: "assets/icons/menu_doc.svg",
                            press: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CapKpiKP(
                                    userEmail: widget.userEmail ?? '',
                                    displayName: widget.displayName ?? '',
                                    photoURL: widget.photoURL ?? '',
                                  ), // Điều hướng đến chi tiết KPI
                                ),
                              );
                            },
                          ),
                          DrawerListTile(
                            title: "Thêm nội dung KPI",
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ThemmuctieuKP(
                                    userEmail: widget.userEmail ?? '',
                                    displayName: widget.displayName ?? '',
                                    photoURL: widget.photoURL ?? '', currentSelectedMaqpList: currentSelectedMaqpList,
                                  ), // Điều hướng đến chi tiết KPI
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    // Bên phải: Nội dung chính
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        child: _Laydulieu(),
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
                      child: _Laydulieu(),
                    ),
                    Positioned(
                      top: 16,
                      left: 16,
                      child: IconButton(
                        icon: const Icon(Icons.menu,
                            size: 32, color: Colors.black),
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

Widget _Laydulieu() {
  return currentSelectedMaqpList.isEmpty
      ? const Center(child: Text('Không có KPI nào được chọn.'))
      : FutureBuilder<List<Kpiphongcntt>>(
          future: Provider.of<Usuario_provider>(context, listen: false)
              .getKpiPhongKhoatheomaKPI(currentSelectedMaqpList),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                  child: Text('Lỗi khi tải dữ liệu: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Không có dữ liệu KPI.'));
            }

            final kpiDetails = snapshot.data!;
            final uniqueKpis = {for (var kpi in kpiDetails) kpi.makpi: kpi}
                .values
                .toList();
            test = uniqueKpis;

     return Center(
  child: SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
        color: Color.fromARGB(255, 250, 250, 250),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min, // Đảm bảo chiều cao không vượt quá nội dung
          children: [
            // Tiêu đề
            const Text(
              'Danh sách KPI vừa chọn',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(94, 113, 122, 1)
              ),
            ),
            const SizedBox(height: 16), // Khoảng cách giữa tiêu đề và hàng nút

            // Row chứa các nút, căn chỉnh sang bên phải
         
            const SizedBox(height: 20), // Khoảng cách giữa hàng nút và DataTable

            // Container chứa DataTable, bo góc và có thể cuộn ngang
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), // Bo góc cho DataTable
                color: const Color.fromRGBO(176, 212, 184, 1), // Màu nền của DataTable
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: KpiDetailsDataTable(
                  uniqueKpis: uniqueKpis,
                  kpiDetailsMap: kpiDetailsMap,
                  kehoachControllers: kehoachControllers,
                  trongsoControllers: trongsoControllers,
                  kehoachFocusNodes: kehoachFocusNodes,
                  removeKpi: _removeKpi,
                  removeAllKpis: _removeAllKpis,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Nút xác nhận và lưu thông tin KPI
            ElevatedButton(
              onPressed: () async {
                if (uniqueKpis.length < 5) {
                  return;
                }

                bool hasEmptyFields = false;

                if (uniqueKpis.length != kehoachControllers.length ||
                    uniqueKpis.length != trongsoControllers.length) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Số lượng mục tiêu và trường dữ liệu không khớp.'),
                    ),
                  );
                  return;
                }

                if (!KpiApiService.areAllFieldsFilled(uniqueKpis, kehoachControllers, trongsoControllers)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Vui lòng điền đầy đủ các mục kế hoạch và trọng số hợp lệ.')),
                  );
                  return;
                }

                double totalTrongSo = 0;
                for (var controller in trongsoControllers.values) {
                  totalTrongSo += double.tryParse(controller.text) ?? 0;
                }

                if (totalTrongSo != 100) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Tổng trọng số phải bằng 100. Hiện tại là $totalTrongSo.'),
                    ),
                  );
                  return;
                }

                bool isStatusValid = await checkKpiStatus(context);
                if (isStatusValid) {
                  bool? confirmed = await showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Colors.grey[200],
                        title: const Text('Xác nhận'),
                        content: const Text('Bạn có chắc chắn muốn lưu thông tin KPI không?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: const Text('Không'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            child: const Text('Có'),
                          ),
                        ],
                      );
                    },
                  );

                  if (confirmed == true) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Đang lưu thông tin KPI...')),
                    );

                    await _saveKpiData();
                    String maphieukpi = kpiCode.toString();

                    await KpiApiService.saveAllKpisToApi(
                      context,
                      uniqueKpis,
                      maphieukpi!,
                      kehoachControllers,
                      trongsoControllers,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Đã hoàn thành lưu thông tin KPI.')),
                    );
                  }
                }
              },
              child: const Text('Cấp biểu mẫu KPI'),
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
        ),
      ),
    ),
  ),
);




          },
        );
}
}

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;
    if (text.length == 2 || text.length == 5) {
      if (oldValue.text.length < newValue.text.length) {
        text += '/';
      } else {
        text = text.substring(0, text.length - 1);
      }
    }
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
