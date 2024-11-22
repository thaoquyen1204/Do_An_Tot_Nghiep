// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_login_api/mausacvakichthuoc/constants1.dart';
import 'package:flutter_login_api/models/chitietkpikhoaphong.dart';
import 'package:flutter_login_api/models/kpikhoaphong.dart';
import 'package:flutter_login_api/models/kpiphongcntt.dart';
import 'package:flutter_login_api/models/modelchucdanh.dart';
import 'package:flutter_login_api/providers/usuario_provider2.dart';
import 'package:flutter_login_api/screens/capkpi/capkpibieumauchucvu/thembieumauchucvu.dart';
import 'package:flutter_login_api/screens/capkpi/trangchucapkpi.dart';
import 'package:flutter_login_api/screens/danhgiakhenthuong/canhan/danhgiacanhan.dart';
import 'package:flutter_login_api/screens/kiemduyetbieumau/khoaphongcn/xembieumaubutton.dart';
import 'package:flutter_login_api/screens/kiemduyetbieumau/khoaphongcn/xembieumauchucvucanhan.dart';
import 'package:flutter_login_api/screens/main/components/side_menu.dart';
import 'package:provider/provider.dart';
import 'package:flutter_login_api/providers/usuario_provider.dart';

class CapKPIBMCV extends StatefulWidget {
      final String userEmail;
  final String displayName;
  final String? photoURL;
  const CapKPIBMCV({
    Key? key,
    required this.userEmail,
    required this.displayName,
    this.photoURL,
  });
  @override
  _CapKpiBMCVScreenState createState() => _CapKpiBMCVScreenState();
}

class _CapKpiBMCVScreenState extends State<CapKPIBMCV>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final int currentYear = DateTime.now().year;
  List<int> selectedRows = []; // List to track selected KPIs
  List<Map<String, dynamic>> selectedKpiDetails =
      []; // List to hold KPI details for second DataTable
  bool _selectAll = false;
  TextEditingController _searchController = TextEditingController();
  final Usuario_provider2 _kpiApiService = Usuario_provider2();
  late String userName ;
  late String userPosition ;
  String? selectedmachucdanh = '';
  late String kpiCode;
      String? maphieukpi;
late String maphieukpi1;
late String maNV;

  @override
  void initState() {
    super.initState();
    _fetchKpiCode();
    userName = widget.displayName;
    _fetchEmployeeQuyen();
    _fetchEmployeeMaNV();
 
    _tabController = TabController(length: 4, vsync: this);
    Future.microtask(() =>
        Provider.of<Usuario_provider>(context, listen: false).getKPIByPKCN());
  }
  Future<String?> _fetchEmployeeMaNV() async {
    final gmail = widget.userEmail;
    var resultParam =
        await Provider.of<Usuario_provider>(context, listen: false)
            .GetMaNVByEmail(gmail);

    print("Fetching data for MaNV: ${resultParam}");

   maNV = resultParam;
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

      // Cập nhật userPosition dựa vào kết quả trả về
      setState(() {
        if (result == "NV") {
          userPosition = "Nhân viên";
        } else if (result == "TKP") {
          userPosition = "Trưởng phòng";
          } else if (result == "PKP") {
          userPosition = "Phó khoa phòng";
        } else {
          userPosition = result; // Hoặc gán giá trị mặc định nếu cần
        }
      });

      print("xem maquyen: $userPosition");
      return result;
    } catch (e) {
      print('Đã xảy ra lỗi: $e');
      return null;
    }
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchKpiCode() async {
    DateTime today = DateTime.now(); // Sử dụng ngày hiện tại
    String? result = await _kpiApiService.getKpiCodeKP(today);

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

  @override
  Widget build(BuildContext context) {
    String? selectedChucDanh;

    return Consumer<Usuario_provider>(
      builder: (context, usuarioProvider1, child) {
        final kpicntt = usuarioProvider1.kpicntt;
        // String? selectedChucDanh = usuarioProvider1.chucdanh.isNotEmpty
        //     ? usuarioProvider1
        //         .chucdanh[0].maChucDanh // Chọn giá trị đầu tiên nếu có
        //     : null;
        return Scaffold(
          backgroundColor: bgColor,
          drawer:
              MediaQuery.of(context).size.width < 600 ?  SideMenu( userEmail: widget.userEmail,
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
                            title: "Danh sách chức vụ ",
                            svgSrc: "assets/icons/menu_doc.svg",
                            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => XemBieumauButton(
                    userEmail: widget.userEmail,
                    displayName: widget.displayName,
                    photoURL: widget.photoURL!, chucdanhList:usuarioProvider1.chucdanh, selectedChucDanh: '',
                  ),
                ),
              );
            },
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
    Navigator.pop(context); // Quay lại trang trước đó
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
                                      'Cấp KPI BIỂU MẪU CÁ NHÂN',
                                      style: TextStyle(
                                        fontSize: 21,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // DropdownButton
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    height: 50, // Điều chỉnh chiều cao
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      hint: const Text("Chọn chức danh", style: TextStyle(
          color: Colors.black, // Đổi màu chữ của hint thành đen
        ),),
                                      value:
                                          selectedChucDanh, // Sử dụng giá trị selectedChucDanh tại đây
                                      onChanged: (String? newValue) {
                                        selectedChucDanh =
                                            newValue; // Cập nhật selectedChucDanh
                                        selectedmachucdanh = selectedChucDanh;
                                        // Cập nhật lại UI bằng cách sử dụng setState
                                        (context as Element)
                                            .markNeedsBuild(); // Cập nhật lại widget
                                      },
                                      items: usuarioProvider1.chucdanh
                                          .map((ChucDanh chuc) {
                                        return DropdownMenuItem<String>(
                                          value: chuc.maChucDanh,
                                          child: Text(
                                            chuc.tenChucDanh,
                                            style: const TextStyle(
                                                fontSize:
                                                    14), // Font size nhỏ hơn
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                    width:
                                        20), // Khoảng cách giữa dropdown và button
                                // ElevatedButton
                              Expanded(
  flex: 1,
  child: ElevatedButton(
    onPressed: () {
      if (selectedChucDanh == null) {
        // Nếu selectedChucDanh là null, điều hướng đến trang XemBieumauButton
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => XemBieumauButton(
              chucdanhList: usuarioProvider1.chucdanh,
              selectedChucDanh: selectedChucDanh,
                userEmail: widget.userEmail ?? '',
                                    displayName: widget.displayName ?? '',
                                    photoURL: widget.photoURL ?? '',
            ),
          ),
        );
      } else {
        // Nếu selectedChucDanh không null, điều hướng đến trang chi tiết
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => XemBieumauKPCN(
              machucdanh: selectedChucDanh!,
                userEmail: widget.userEmail ?? '',
                                    displayName: widget.displayName ?? '',
                                    photoURL: widget.photoURL ?? '',
            ),
          ),
        );
      }
    },
    child: const Text('Xem biểu mẫu'),
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: const Color.fromARGB(255, 110, 187, 117),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
    ),
  ),
),

                                const SizedBox(
                                    width:
                                        20), // Khoảng cách giữa dropdown và button
                                // ElevatedButton
                                Expanded(
                                  flex: 1,
                                  child: ElevatedButton(
                                    onPressed:(){ Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CapKPIBMCV(  userEmail: widget.userEmail ?? '',
                                    displayName: widget.displayName ?? '',
                                    photoURL: widget.photoURL ?? '', ), 
                                      ),
                                    );
                                    },
                                    child: const Text('Chọn lại'),
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: const Color.fromARGB(
                                          255, 110, 187, 117),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 32, vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            _buildFirstDataTable(kpicntt),
                            const SizedBox(height: 3),
                            _buildSecondDataTable(),
                            const Spacer(),
                            Align(
                              alignment: Alignment.center,
                              child: ElevatedButton(
                                onPressed: _handleSave,
                                child: const Text('Lưu'),
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
                            ),
                          ],
                        ),
                      ),
                    ),
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
                                    'Cấp KPI BIỂU MẪU CÁ NHÂN',
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
                          const SizedBox(height: 10),

                          // DropdownButton for chức danh
                          Container(
                            height: 50, // Điều chỉnh chiều cao
                            child: DropdownButton<String>(
                              isExpanded: true,
                              hint: const Text("Chọn chức danh"),
                              value: selectedChucDanh,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedChucDanh = newValue;
                                  print("selectedChucDanh$selectedChucDanh");
                                });
                              },
                              items: usuarioProvider1.chucdanh
                                  .map((ChucDanh chuc) {
                                return DropdownMenuItem<String>(
                                  value: chuc.maChucDanh,
                                  child: Text(
                                    chuc.tenChucDanh,
                                    style: const TextStyle(
                                        fontSize: 14), // Font size nhỏ hơn
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 5),
                          _buildFirstDataTable(kpicntt),
                          const SizedBox(height: 5),
                          _buildSecondDataTable(),
                          const Spacer(),
                          Align(
                              alignment: Alignment.center,
                              child: ElevatedButton(
                                onPressed: _handleSave,
                                child: const Text('Lưu'),
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
                            ),
                        ],
                      ),
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

  Widget _buildFirstDataTable(List<Kpiphongcntt> kpicntt) {
    // Sử dụng Set để loại bỏ các mục trùng lặp dựa trên makpi
    final uniqueKpicntt = kpicntt.toSet().toList();

    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height *
              0.3, // Chiều cao cố định hoặc có thể dùng MediaQuery để điều chỉnh
          width: MediaQuery.of(context).size.width * 0.84,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal, // Cuộn theo chiều ngang
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical, // Cuộn theo chiều dọc
              child: DataTable(
                headingRowColor: MaterialStateColor.resolveWith(
                  (states) => Colors.grey[200]!, // Màu nền cho hàng tiêu đề
                ),
                columns: [
                  DataColumn(
                    label: Row(
                      children: [
                        const Text('Chọn tất cả'),
                        Checkbox(
                          value: _selectAll,
                          onChanged: (value) {
                            setState(() {
                              _selectAll = value!;
                              if (_selectAll) {
                                selectedRows = uniqueKpicntt
                                    .map((usuario) => usuario.makpi)
                                    .toList();
                                selectedKpiDetails =
                                    uniqueKpicntt.map((usuario) {
                                  return {
                                    'makpi': usuario.makpi,
                                    'noidung': usuario.noidung,
                                    'phuongphapdo': usuario.phuongphapdo,
                                    'donvitinh': usuario.donvitinh,
                                    'chitieu': usuario.chitieu,
                                    'kehoach': '',
                                    'trongso': '',
                                  };
                                }).toList();
                              } else {
                                selectedRows.clear();
                                selectedKpiDetails.clear();
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const DataColumn(
                    label: Expanded(
                      child: Text(
                        'Mục tiêu bệnh viện (chọn ít nhất 5 mục)',
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const DataColumn(
                    label: Expanded(
                      child: Text(
                        'Phương pháp đo',
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const DataColumn(
                    label: Expanded(
                      child: Text(
                        'Đơn vị',
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const DataColumn(
                    label: Expanded(
                      child: Text(
                        'Chỉ tiêu',
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
                rows: uniqueKpicntt.map<DataRow>((usuario) {
                  return DataRow(
                    cells: [
                      DataCell(
                        Checkbox(
                          value: selectedRows.contains(usuario.makpi),
                          onChanged: (value) {
                            setState(() {
                              if (value!) {
                                selectedRows.add(usuario.makpi);
                                selectedKpiDetails.add({
                                  'makpi': usuario.makpi,
                                  'noidung': usuario.noidung,
                                  'phuongphapdo': usuario.phuongphapdo,
                                  'donvitinh': usuario.donvitinh,
                                  'chitieu': usuario.chitieu,
                                  'kehoach': '',
                                  'trongso': '',
                                });
                              } else {
                                selectedRows.remove(usuario.makpi);
                                selectedKpiDetails.removeWhere((element) =>
                                    element['makpi'] == usuario.makpi);
                              }
                              _selectAll =
                                  selectedRows.length == uniqueKpicntt.length;
                            });
                          },
                        ),
                      ),
                      DataCell(
                        Tooltip(
                          message: usuario.noidung ?? 'N/A',
                          child: SizedBox(
                            width: 280,
                            child: Text(
                              usuario.noidung ?? 'N/A',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        Tooltip(
                          message: usuario.phuongphapdo ?? 'N/A',
                          child: SizedBox(
                            width: 150,
                            child: Text(
                              usuario.phuongphapdo ?? 'N/A',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        Tooltip(
                          message: usuario.donvitinh ?? 'N/A',
                          child: SizedBox(
                            width: 100,
                            child: Text(
                              usuario.donvitinh ?? 'N/A',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                      DataCell(Text(usuario.chitieu ?? 'N/A')),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSecondDataTable() {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height *
              0.3, // Chiều cao cố định hoặc có thể điều chỉnh
          width: MediaQuery.of(context).size.width *
              0.84, // Responsive width for better scrolling
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal, // Cuộn theo chiều ngang
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical, // Cuộn theo chiều dọc
              child: DataTable(
                headingRowColor: MaterialStateColor.resolveWith(
                  (states) => Colors.grey[200]!, // Màu nền cho hàng tiêu đề
                ),
                columns: [
                  const DataColumn(label: Text('Xóa')),
                  const DataColumn(
                    label: Expanded(
                      child: Text('Mục tiêu bệnh viện'),
                    ),
                  ),
                  const DataColumn(
                    label: Expanded(
                      child: Text('Phương pháp đo'),
                    ),
                  ),
                  const DataColumn(
                    label: Expanded(
                      child: Text('Chỉ tiêu'),
                    ),
                  ),
                  const DataColumn(
                    label: Expanded(
                      child: Text('Kế hoạch'),
                    ),
                  ),
                  const DataColumn(
                    label: Expanded(
                      child: Text('Trọng số'),
                    ),
                  ),
                ],
                rows: selectedKpiDetails.map<DataRow>((kpiDetail) {
                  return DataRow(
                    cells: [
                      DataCell(
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              selectedRows.remove(kpiDetail['makpi']);
                              selectedKpiDetails.remove(kpiDetail);
                            });
                          },
                        ),
                      ),
                      DataCell(
                        Tooltip(
                          message: kpiDetail['noidung'] ?? 'N/A',
                          child: SizedBox(
                            width: 220, // Limit width for text overflow
                            child: Text(
                              kpiDetail['noidung'] ?? 'N/A',
                              overflow: TextOverflow
                                  .ellipsis, // Show "..." for long text
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        Tooltip(
                          message: kpiDetail['phuongphapdo'] ?? 'N/A',
                          child: SizedBox(
                            width: 70, // Limit width
                            child: Text(
                              kpiDetail['phuongphapdo'] ?? 'N/A',
                              overflow:
                                  TextOverflow.ellipsis, // Handle long text
                            ),
                          ),
                        ),
                      ),
                      DataCell(Text(kpiDetail['chitieu'] ?? 'N/A')),
                      DataCell(
                        SizedBox(
                          width: 100, // Limit width for input field
                          child: TextFormField(
                            initialValue: kpiDetail['kehoach'],
                            onChanged: (value) {
                              setState(() {
                                kpiDetail['kehoach'] = value;
                              });
                            },
                          ),
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: 100, // Limit width for input field
                          child: TextFormField(
                            initialValue: kpiDetail['trongso'],
                            onChanged: (value) {
                              setState(() {
                                kpiDetail['trongso'] = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSave() async {
       _LayMaPhieu();
    print("machucdanh$selectedmachucdanh");
    if (selectedmachucdanh == null || selectedmachucdanh == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Bạn chưa chọn chức danh để xây dựng biểu mẫu Kpi.')),
      );
      return;
    }
    // Kiểm tra nếu số lượng KPI ít hơn 5
    if (selectedKpiDetails.length < 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Phải chọn ít nhất 5 tiêu chí KPI.')),
      );
      return;
    }

    // Tổng trọng số
    double totalTrongSo = 0;

    // Kiểm tra từng KPI
    for (int i = 0; i < selectedKpiDetails.length; i++) {
      final kpiDetail = selectedKpiDetails[i];

      // Kiểm tra nếu trường 'kế hoạch' bị bỏ trống
      if (kpiDetail['kehoach'] == null || kpiDetail['kehoach'].trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Trường kế hoạch ở hàng ${i + 1} không được để trống!')),
        );
        return;
      }

      // Kiểm tra nếu trường 'trọng số' bị bỏ trống
      if (kpiDetail['trongso'] == null || kpiDetail['trongso'].trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Trường trọng số ở hàng ${i + 1} không được để trống!')),
        );
        return;
      }

      // Kiểm tra trọng số phải là số
      final trongSo = double.tryParse(kpiDetail['trongso']);
      if (trongSo == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Trọng số ở hàng ${i + 1} phải là một số hợp lệ!')),
        );
        return; // Dừng quá trình kiểm tra nếu có lỗi
      }

      totalTrongSo += trongSo;
    }

    // Kiểm tra tổng trọng số phải bằng 100
    if (totalTrongSo != 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tổng trọng số phải bằng 100.')),
      );
      return;
    }
    bool isStatusValid = await checkKpiStatus(context);
    if (isStatusValid) {
      // Hộp thoại xác nhận trước khi lưu
      final bool? confirmSave = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.grey[200],
            title: const Text('Xác nhận lưu'),
            content: const Text('Bạn có chắc chắn muốn lưu không?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pop(false); // Trả về false nếu chọn "Không"
                },
                child: const Text('Không'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // Trả về true nếu chọn "Có"
                },
                child: const Text('Có'),
              ),
            ],
          );
        },
      );

      // Nếu người dùng không xác nhận, dừng quá trình lưu
      if (confirmSave != true) {
        return;
      }

      try {
        // Gọi hàm lưu KPI
        await _saveKpiKhoaPhong();
        await saveChitietkpikhoaphong(context, kpiCode.toString());

        // Thông báo lưu thành công
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lưu thông tin KPI thành công!')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CapKPIBMCV(  userEmail: widget.userEmail ?? '',
                                    displayName: widget.displayName ?? '',
                                    photoURL: widget.photoURL ?? '',),
          ),
        );
      } catch (e) {
        // Bắt lỗi và thông báo nếu có lỗi
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lưu thất bại: $e')),
        );
      }
    }
  }

  Future<void> _saveKpiKhoaPhong() async {
    try {
      // Đảm bảo rằng ngày nằm trong khoảng hợp lệ của SQL Server
      DateTime validDateTime(DateTime date) {
        DateTime minDate = DateTime(1753, 1, 1);
        if (date.isBefore(minDate)) {
          return minDate;
        }
        return date;
      }

      // Tạo đối tượng kpicanhan để lưu dữ liệu
      final kpikhoaphong = Kpikhoaphong(
        maphieukpikhoaphong: kpiCode.toString(),
        idbieumau: 74,
        manv: maNV,
        quynam: DateTime.now().year,
        ngaylapphieukpikhoaphong: validDateTime(DateTime.now()),
        nguoipheduyetkpikhoaphong: null,
        ngaypheduyetkpikhoaphong: null,
        trangthai: 0,
        machucdanh: selectedmachucdanh,
      );

      // Gọi Provider để lưu thông tin KPI Bệnh Viện
      await Provider.of<Usuario_provider2>(context, listen: false)
          .addKPIKhoaPhong(kpikhoaphong);
    } catch (e) {
      // Xử lý khi gặp lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Thêm mới thất bạikp: $e')),
      );
    }
  }

  Future<void> saveChitietkpikhoaphong(
      BuildContext context, String maphieukpi) async {
    // Duyệt qua danh sách KPI trong selectedKpiDetails
    for (var kpiDetail in selectedKpiDetails) {
      final kehoachValue = kpiDetail['kehoach']?.trim() ?? '';
      final trongsoValue =
          double.tryParse(kpiDetail['trongso']?.trim() ?? '0') ?? 0;

      // In ra thông tin hiện tại của KPI (Debug)
      print(
          'KPI: ${kpiDetail['makpi']}, Kế hoạch: $kehoachValue, Trọng số: $trongsoValue');

      // Tạo đối tượng để gửi lên API
      final chitietkpikp = ChitietKpiKP(
        makpi: kpiDetail['makpi'],
        noidungkpikhoaphong: kpiDetail['noidung'] ?? 'N/A',
        kehoach: kehoachValue,
        trongsokpikhoaphong: trongsoValue,
        nguonchungminh: 'CNTT',
        maphieukpikhoaphong: maphieukpi,
        tieuchidanhgiaketqua: kpiDetail['phuongphapdo'],
      );

      try {
        await Provider.of<Usuario_provider2>(context, listen: false)
            .addChitietKPIKP(chitietkpikp);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Thêm mới thất bạictkp: $e')),
        );
      }
    }
  }

  Future<bool> checkKpiStatus(BuildContext context) async {
    try {
      int resultParam =
          await Provider.of<Usuario_provider2>(context, listen: false)
              .CheckNamPhieuKpiKP(
                  DateTime.now().year, selectedmachucdanh.toString());

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
      } else if (resultParam == 4) {
        // Trạng thái đã duyệt
        bool? shouldContinue = await _showConfirmationDialog(context,
            'Biểu mẫu đã được đánh giá.', 'Bạn có muốn xem lại biểu mẫu không?');

        // Nếu người dùng chọn xem lại, dừng lại (trả về false)
        if (shouldContinue == true) {
         Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DanhgiaCN(maNV: maNV, year: currentYear,  userEmail: widget.userEmail ?? '',
                                    displayName: widget.displayName ?? '',
                                    photoURL: widget.photoURL ?? '',
                // machucdanh: selectedmachucdanh.toString(),
              ),
            ),
          );
        }
        return false;
      } else if (resultParam == 2) {
        // Trạng thái bị từ chối
        bool? shouldReview = await _showConfirmationDialog1(
            context,
            'Biểu mẫu bị từ chối.',
            'Bạn muốn xem lại biểu mẫu hay lưu chỉnh sửa không?');

        if (shouldReview == true) {
          print(" Điều hướng tới trang xem biểu mẫu");
          //Điều hướng tới trang xem biểu mẫu
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => XemBieumauKPCN(
                machucdanh: selectedmachucdanh.toString(),
                  userEmail: widget.userEmail ?? '',
                                    displayName: widget.displayName ?? '',
                                    photoURL: widget.photoURL ?? '',
              ),
            ),
          );
          return false; // Dừng lại nếu người dùng chọn xem lại
        } else {
          print("Lưu chỉnh sửa");
           await _handleSave1();
          return false;
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
            builder: (context) => XemBieumauKPCN(
                  machucdanh: selectedmachucdanh.toString(),
                    userEmail: widget.userEmail ?? '',
                                    displayName: widget.displayName ?? '',
                                    photoURL: widget.photoURL ?? '',
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
  Future<void> _handleSave1() async {
    
    if (selectedmachucdanh == null || selectedmachucdanh == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Bạn chưa chọn chức danh để xây dựng biểu mẫu Kpi.')),
      );
      return;
    }
    print("machucdanh$selectedmachucdanh");
    // Kiểm tra nếu số lượng KPI ít hơn 5
    if (selectedKpiDetails.length < 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Phải chọn ít nhất 5 tiêu chí KPI.')),
      );
      return;
    }

    // Tổng trọng số
    double totalTrongSo = 0;
print("đến kiểm tả rồi");
    // Kiểm tra từng KPI
    print(selectedKpiDetails);
    for (int i = 0; i < selectedKpiDetails.length; i++) {
       final kpiDetail = selectedKpiDetails[i];

    // Lấy giá trị từ trường 'kế hoạch' và 'trọng số'
    String keHoachValue = kpiDetail['kehoach'] ?? '';
    String trongSoValue = kpiDetail['trongso'] ?? '';
    print(keHoachValue);
    print(trongSoValue);


      // Kiểm tra nếu trường 'kế hoạch' bị bỏ trống
      if (kpiDetail['kehoach'] == null || kpiDetail['kehoach'].trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Trường kế hoạch ở hàng ${i + 1} không được để trống!')),
        );
        return;
      }

      // Kiểm tra nếu trường 'trọng số' bị bỏ trống
      if (kpiDetail['trongso'] == null || kpiDetail['trongso'].trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Trường trọng số ở hàng ${i + 1} không được để trống!')),
        );
        return;
      }

      // Kiểm tra trọng số phải là số
      final trongSo = double.tryParse(kpiDetail['trongso']);
      if (trongSo == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Trọng số ở hàng ${i + 1} phải là một số hợp lệ!')),
        );
        return; // Dừng quá trình kiểm tra nếu có lỗi
      }

      totalTrongSo += trongSo;
    }

    // Kiểm tra tổng trọng số phải bằng 100
    if (totalTrongSo != 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tổng trọng số phải bằng 100.')),
      );
      return;
    }
      // Hộp thoại xác nhận trước khi lưu
      final bool? confirmSave = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
             backgroundColor: Colors.grey[200],
            title: const Text('Xác nhận lưu'),
            content: const Text('Bạn có chắc chắn muốn lưu không?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pop(false); // Trả về false nếu chọn "Không"
                },
                child: const Text('Không'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // Trả về true nếu chọn "Có"
                },
                child: const Text('Có'),
              ),
            ],
          );
        },
      );

      // Nếu người dùng không xác nhận, dừng quá trình lưu
      if (confirmSave != true) {
        return;
      }

     try {
        print(maphieukpi);
         final usuarioProvider =
        Provider.of<Usuario_provider2>(context, listen: false);
       maphieukpi = (await usuarioProvider.GetChiTietKPIKKpByMCCDvaNam(selectedmachucdanh.toString(), currentYear))!;
        // Gọi hàm lưu KPI
          if (maphieukpi != null) {
  await deletechitietKPIKP(maphieukpi!); // Chỉ thực hiện nếu maphieukpi khác null
}
await saveChitietkpikhoaphong(context, maphieukpi.toString()); // Và hàm thứ ba
await saveEditsKPIKP(); // Tiếp tục thực hiện hàm thứ hai
print(maphieukpi);


        // Thông báo lưu thành công
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lưu thông tin KPI thành công!')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CapKPIBMCV(  userEmail: widget.userEmail ?? '',
                                    displayName: widget.displayName ?? '',
                                    photoURL: widget.photoURL ?? '',),
          ),
        );
      } catch (e) {
        // Bắt lỗi và thông báo nếu có lỗi
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lưu thất bại: $e')),
        );
      }
    
  }

  

    Future<void> saveEditsKPIKP() async {
       final usuarioProvider =
        Provider.of<Usuario_provider2>(context, listen: false);
    if (maphieukpi!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không có mã phiếu để thông qua.')),
      );
      return;
    }
    // Lấy đối tượng Kpicanhan dựa trên mã phiếu
    Kpikhoaphong? kpikhoaphong=
        await usuarioProvider.getKpikhoaphongByMaphieu(maphieukpi!);

    if (kpikhoaphong == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không tìm thấy biễu mẫu cá nhân.')),
      );
      return;
    }

    // Hàm để đảm bảo ngày hợp lệ cho SQL Server
    DateTime validDateTime(DateTime date) {
      DateTime minDate = DateTime(1753, 1, 1);
      return date.isBefore(minDate) ? minDate : date;
    }

    // Cập nhật các trường cần thiết
    kpikhoaphong.manv = maNV;
    kpikhoaphong.nguoipheduyetkpikhoaphong = null;
    kpikhoaphong.ngaylapphieukpikhoaphong = validDateTime(DateTime.now());
    kpikhoaphong.ngaypheduyetkpikhoaphong = null;
    kpikhoaphong.trangthai = 0;
    kpikhoaphong.machucdanh=selectedmachucdanh;

    // Gọi API để cập nhật trạng thái KPI cá nhân
    await usuarioProvider.updateKPIKhoaPhong(kpikhoaphong);


  }

// Hàm để lưu chỉnh sửa
  Future<void> _LayMaPhieu() async {
print(selectedmachucdanh);
  maphieukpi = await Provider.of<Usuario_provider2>(context, listen: false)
      .GetChiTietKPIKKpByMCCDvaNam(selectedmachucdanh.toString(), currentYear);
      maphieukpi1 = maphieukpi!;
  await Provider.of<Usuario_provider2>(context, listen: false)
      .ChiTietKPIKPByMaCDvaNam(selectedmachucdanh.toString(), currentYear);

  print('Mã phiếu KPI: $maphieukpi');
  print('Chi tiết KPI cá nhân: ${Provider.of<Usuario_provider2>(context, listen: false).chitietkpikhoaphong}');

  Provider.of<Usuario_provider2>(context, listen: false)
          .chitietkpikhoaphong
          .isEmpty
      ? []
      : Provider.of<Usuario_provider2>(context, listen: false)
          .chitietkpikhoaphong
          .map((kpiDetail) {
    print('Chi tiết KPI: $kpiDetail');
  });

 
}
Future<void> deletechitietKPIKP(String maphieukpi) async {
  final usuarioProvider =
      Provider.of<Usuario_provider2>(context, listen: false);
 

  try {
     
    // In ra thông tin trước khi xóa
    print('Bắt đầu xóa chi tiết KPI với mã phiếu KPI: $maphieukpi');

    await usuarioProvider.deletecchitietKPIKhoaPhong(maphieukpi);

    // In ra thông tin sau khi xóa thành công
    print('Xóa thành công chi tiết KPI với mã phiếu KPI: $maphieukpi');
  } catch (e) {
    // In ra lỗi nếu quá trình xóa gặp vấn đề
    print('Lỗi khi xóa chi tiết KPI: $e');

    // Có thể hiển thị thêm một thông báo lỗi cho người dùng nếu cần
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text('Lỗi khi xóa chi tiết KPI: $e')),
    // );
  }
}
}
