import 'package:flutter/material.dart';
import 'package:flutter_login_api/main.dart';
import 'package:flutter_login_api/mausacvakichthuoc/constants1.dart';
import 'package:flutter_login_api/models/chitietkpicanhannv.dart';
import 'package:flutter_login_api/models/chitietkpikhoaphong.dart';
import 'package:flutter_login_api/models/kpicanhan.dart';
import 'package:flutter_login_api/models/kpikhoaphong.dart';
import 'package:flutter_login_api/models/kpiphongcntt.dart';
import 'package:flutter_login_api/models/modelchucdanh.dart';
import 'package:flutter_login_api/providers/usuario_provider1.dart';
import 'package:flutter_login_api/providers/usuario_provider2.dart';
import 'package:flutter_login_api/screens/capkpi/capkpibieumauchucvu/thembieumauchucvu.dart';
import 'package:flutter_login_api/screens/kiemduyetbieumau/khoaphongcn/xembieumaubutton.dart';
import 'package:flutter_login_api/screens/kiemduyetbieumau/khoaphongcn/xembieumauchucvucanhan.dart';
import 'package:flutter_login_api/screens/main/components/side_menu.dart';
import 'package:flutter_login_api/screens/trangchu/canhan/giaodien.dart';
import 'package:provider/provider.dart';
import 'package:flutter_login_api/providers/usuario_provider.dart';

class CapKpiCN extends StatefulWidget {
    final String userEmail;
  final String displayName;
  final String? photoURL;
   const CapKpiCN(
      {Key? key,
      required this.userEmail,
      required this.displayName,
      this.photoURL})
      : super(key: key);
  @override
  _CapKpiCNScreenState createState() => _CapKpiCNScreenState();
}

class _CapKpiCNScreenState extends State<CapKpiCN>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final int currentYear = DateTime.now().year;
  List<int> selectedRows = [];
  bool _selectAll = false; // Thêm biến để theo dõi trạng thái "Chọn tất cả"
  late List<Map<String, dynamic>> apiData;
  TextEditingController _searchController = TextEditingController();
  late String userName; // Thay thế bằng tên người dùng
  late String userPosition = ''; // Thay thế bằng chức vụ
  late String machucdanh = 'KSCNTTPC';
  List<Map<String, dynamic>> selectedKpiDetails = [];
  bool _isLoading = false; // Để hiển thị trạng thái đang tải
  bool _isDataVisible = false;
  late String kpiCode;
  String? maphieukpi;
  String Manhanvien='';
  final Usuario_provider1 _kpiApiService = Usuario_provider1();
  @override
  void initState() {
    super.initState();

    // _fetchEmployeeQuyen();
    _tabController = TabController(length: 4, vsync: this);
    _fetchTrangThaiKPI();
    _fetchKpiCode();
    _fetchEmployeeMaNV();
    checkKpiStatus(context);
    print("Mã chức danh: $machucdanh, Năm hiện tại: $currentYear");

    Future.microtask(() =>
        Provider.of<Usuario_provider2>(context, listen: false)
            .getChitietkpikhoaphongbyMaCD(machucdanh, currentYear));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
Future<String?> _fetchEmployeeMaNV() async {
    final gmail = widget.userEmail;
    var resultParam =
        await Provider.of<Usuario_provider>(context, listen: false)
            .GetMaNVByEmail(gmail);

    print("Fetching data for MaNV: ${resultParam}");

    final Manhanvien = resultParam;
     print("Fetching data for MaNV1: ${Manhanvien}");}

  Future<void> _fetchKpiCode() async {
    DateTime today = DateTime.now(); // Sử dụng ngày hiện tại
    String? result = await _kpiApiService.getKpiCodeCN(today);

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

  Future<void> _fetchTrangThaiKPI() async {
    // Kiểm tra giá trị nhập từ TextField
    if (currentYear != null) {
      setState(() {
        _isLoading = true;
      });

      try {
        print(
            'Fetching data for year: $currentYear'); // Bắt đầu gọi API với year

        int resultParam =
            await Provider.of<Usuario_provider2>(context, listen: false)
                .CheckNamPhieuKpiKP(DateTime.now().year, machucdanh);

        if (resultParam == 1) {
          setState(() {
            _isDataVisible = true; // Hiển thị bảng nếu có dữ liệu
          });
        } else {
          print('Data fetched successfully'); // Dữ liệu được fetch thành công
          setState(() {
            _isDataVisible = false; // Ẩn bảng nếu không có dữ liệu
          });
          _showAlertDialog(
              context, 'Thông báo', 'Biểu mẫu chưa được thông qua');
        }
      } catch (error) {
        print('Error fetching data: $error'); // Xử lý lỗi nếu có
        setState(() {
          _isDataVisible = false;
        });
        _showAlertDialog(context, 'Lỗi', 'Dữ liệu không tồn tại');
      } finally {
        setState(() {
          _isLoading = false; // Dừng hiển thị loading khi hoàn tất
        });
        print('Loading completed'); // Xác nhận quá trình fetch hoàn tất
      }
    } else {
      print('Invalid year input'); // Kiểm tra trường hợp nhập không hợp lệ
      _showAlertDialog(context, 'Lỗi', 'Vui lòng nhập năm hợp lệ!');
    }
  }

// Hàm để hiển thị hộp thoại cảnh báo
  void _showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[200],
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại khi bấm OK
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Usuario_provider2>(
      builder: (context, usuarioProvider2, child) {
        final kpicntt = usuarioProvider2.chitietkpikhoaphong;
        print(kpicntt);
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
                                   saveUserInfo1(
    UserInfo1(email: widget.userEmail, displayName: widget.displayName, photoURL: widget.photoURL),
    'giaodien' // route hiện tại
  );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Giaodien(
                              userEmail: widget.userEmail ?? '',
                              displayName: widget.displayName ?? '',
                              photoURL: widget.photoURL ?? '',
                            ),
                          ),
                        );
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
                                      'Cấp KPI CÁ NHÂN',
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
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // DropdownButton
                                // Expanded(
                                //   flex: 3,
                                //   child: Container(
                                //     height: 50, // Điều chỉnh chiều cao
                                //     child: DropdownButton<String>(
                                //       isExpanded: true,
                                //       hint: const Text("Chọn chức danh"),
                                //       value:
                                //           selectedChucDanh, // Sử dụng giá trị selectedChucDanh tại đây
                                //       onChanged: (String? newValue) {
                                //         selectedChucDanh =
                                //             newValue; // Cập nhật selectedChucDanh
                                //         selectedmachucdanh = selectedChucDanh;
                                //         // Cập nhật lại UI bằng cách sử dụng setState
                                //         (context as Element)
                                //             .markNeedsBuild(); // Cập nhật lại widget
                                //       },
                                //       items: usuarioProvider1.chucdanh
                                //           .map((ChucDanh chuc) {
                                //         return DropdownMenuItem<String>(
                                //           value: chuc.maChucDanh,
                                //           child: Text(
                                //             chuc.tenChucDanh,
                                //             style: const TextStyle(
                                //                 fontSize:
                                //                     14), // Font size nhỏ hơn
                                //           ),
                                //         );
                                //       }).toList(),
                                //     ),
                                //   ),
                                // ),
                                const SizedBox(
                                    width:
                                        20), // Khoảng cách giữa dropdown và button
                                // ElevatedButton
                                Expanded(
                                  flex: 0,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CapKpiCN(userEmail: widget.userEmail,
                displayName: widget.displayName,
                photoURL: widget.photoURL,),
                                        ),
                                      );
                                    },
                                    child: const Text('Trở lại'),
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

                                const SizedBox(width: 20),

                                Expanded(
                                  flex: 0,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CapKpiCN(userEmail: widget.userEmail,
                displayName: widget.displayName,
                photoURL: widget.photoURL,),
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
                                const SizedBox(width: 20),
                             

                              
                              ],
                            ),
                            const SizedBox(height: 3),
                            _Dulieubang1(kpicntt),
                            const SizedBox(height: 3),
                            if (_isDataVisible) _Laydulieu2(),
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
              "assets/images/Tiêu_đề_Website_BV_16_-removebg-preview.png",
            ),
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
              saveUserInfo1(
                UserInfo1(
                  email: widget.userEmail,
                  displayName: widget.displayName,
                  photoURL: widget.photoURL,
                ),
                'giaodien', // route hiện tại
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Giaodien(
                    userEmail: widget.userEmail ?? '',
                    displayName: widget.displayName ?? '',
                    photoURL: widget.photoURL ?? '',
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
      const Icon(Icons.assessment, color: Colors.green, size: 28), // Thêm icon trang trí
      const SizedBox(width: 10),
      const Text(
        'Cấp KPI BIỂU MẪU CÁ NHÂN',
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
          _Dulieubang1(kpicntt),
          const SizedBox(height: 5),
          if (_isDataVisible) _Laydulieu2(),
          const Spacer(),
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: _handleSave,
              child: const Text('Lưu'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromARGB(255, 110, 187, 117),
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
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
  );
}
          
              }
            
          ),
        );
      },
    );
  }

  Widget _Dulieubang1(List<ChitietKpiKP> kpicntt) {
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
                                selectedRows = kpicntt
                                    .map((usuario) => usuario.makpi)
                                    .toList();
                                selectedKpiDetails = kpicntt.map((usuario) {
                                  return {
                                    'makpi': usuario.makpi,
                                    'noidung': usuario.noidungkpikhoaphong,
                                    'phuongphapdo':
                                        usuario.tieuchidanhgiaketqua,
                                    'kehoach': usuario.kehoach,
                                    'trongsokpikhoaphong':
                                        usuario.trongsokpikhoaphong,
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
                        'Mục tiêu KPI cá nhân (chọn ít nhất 5 mục)',
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const DataColumn(
                    label: Expanded(
                      child: Text(
                        'Tiêu chí đánh giá kết quả',
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const DataColumn(
                    label: Expanded(
                      child: Text(
                        'Kế hoạch',
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const DataColumn(
                    label: Expanded(
                      child: Text(
                        'Trọng số',
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
                rows: kpicntt.map<DataRow>((usuario) {
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
                                  'noidung': usuario.noidungkpikhoaphong,
                                  'phuongphapdo': usuario.tieuchidanhgiaketqua,
                                  'kehoach': usuario.kehoach,
                                  'trongsokpikhoaphong':
                                      usuario.trongsokpikhoaphong,
                                });
                              } else {
                                selectedRows.remove(usuario.makpi);
                                selectedKpiDetails.removeWhere((element) =>
                                    element['makpi'] == usuario.makpi);
                              }
                              _selectAll =
                                  selectedRows.length == kpicntt.length;
                            });
                          },
                        ),
                      ),
                      DataCell(
                        Tooltip(
                          message: usuario.noidungkpikhoaphong ?? 'N/A',
                          child: SizedBox(
                            width: 250,
                            child: Text(
                              usuario.noidungkpikhoaphong ?? 'N/A',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        Tooltip(
                          message: usuario.tieuchidanhgiaketqua ?? 'N/A',
                          child: SizedBox(
                            width: 150,
                            child: Text(
                              usuario.tieuchidanhgiaketqua ?? 'N/A',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        Tooltip(
                          message: usuario.kehoach ?? 'N/A',
                          child: SizedBox(
                            width: 100,
                            child: Text(
                              usuario.kehoach ?? 'N/A',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        Tooltip(
                          message:
                              usuario.trongsokpikhoaphong.toString() ?? 'N/A',
                          child: SizedBox(
                            width: 100,
                            child: Text(
                              usuario.trongsokpikhoaphong.toString() ?? 'N/A',
                              overflow: TextOverflow.ellipsis,
                            ),
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

  Widget _Laydulieu2() {
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
                      child: Text('Mục tiêu kpi cá nhân'),
                    ),
                  ),
                  const DataColumn(
                    label: Expanded(
                      child: Text('Tiêu chí đánh giá kết quả'),
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
                            width: 300, // Limit width for text overflow
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
                            width: 150, // Limit width
                            child: Text(
                              kpiDetail['phuongphapdo'] ?? 'N/A',
                              overflow:
                                  TextOverflow.ellipsis, // Handle long text
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width:
                              100, // Giới hạn chiều rộng cho trường nhập liệu
                          child: TextFormField(
                            initialValue: kpiDetail['kehoach'],
                            enabled: false, // Không cho phép chỉnh sửa
                            style: const TextStyle(
                              color: Colors.black, // Giữ nguyên màu chữ
                            ),
                            decoration: const InputDecoration(
                              disabledBorder: InputBorder
                                  .none, // Không viền khi bị vô hiệu hóa
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width:
                              100, // Giới hạn chiều rộng cho trường nhập liệu
                          child: TextFormField(
                            initialValue:
                                kpiDetail['trongsokpikhoaphong'].toString(),
                            enabled: false, // Không cho phép chỉnh sửa
                            style: const TextStyle(
                              color: Colors.black, // Giữ nguyên màu chữ
                            ),
                            decoration: const InputDecoration(
                              disabledBorder: InputBorder
                                  .none, // Không viền khi bị vô hiệu hóa
                            ),
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
   

    if (machucdanh == null || machucdanh == '') {
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
        await _saveKpiCaNhan();
        await saveChitietkpiCaNhan(context, kpiCode.toString());

        // Thông báo lưu thành công
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lưu thông tin KPI thành công!')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CapKpiCN(userEmail: widget.userEmail,
                displayName: widget.displayName,
                photoURL: widget.photoURL,),
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

  Future<void> _saveKpiCaNhan() async {
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
       final gmail = widget.userEmail;
    var resultParam =
        await Provider.of<Usuario_provider>(context, listen: false)
            .GetMaNVByEmail(gmail);
           Manhanvien= resultParam;
      print('Giá trị maNV: $Manhanvien');
      final kpicanhan = Kpicanhan(
        maphieukpicanhan: kpiCode.toString(),
        idbieumau: 73,
        manv: Manhanvien.toString(),
        quynam: DateTime.now().year,
        ngaylapphieukpicanhan: validDateTime(DateTime.now()),
        nguoipheduyetkpicanhan: null,
        ngaypheduyetkpicanhan: null,
        trangthai: 0,
      );

      // Gọi Provider để lưu thông tin KPI Bệnh Viện
      await Provider.of<Usuario_provider1>(context, listen: false)
          .addKPICaNhan(kpicanhan);

      // Hiển thị thông báo thành công
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Đã lưu thông tin KPI.')),
      // );
    } catch (e) {
      // Xử lý khi gặp lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Thêm mới thất bạ111i: $e')),
      );
    }
  }

  Future<void> saveChitietkpiCaNhan(
      BuildContext context, String maphieukpi) async {
    // Duyệt qua danh sách KPI trong selectedKpiDetails
    for (var kpiDetail in selectedKpiDetails) {
      // Tạo đối tượng để gửi lên API
      final chitietkpicanhan = ChiTietKPICaNhanNV(
        maphieukpicanhan: maphieukpi,
        makpi: kpiDetail['makpi'],
        noidungkpicanhan: kpiDetail['noidung'] ?? 'N/A',
        nguonchungminh: 'CNTT',
        tieuchidanhgiaketqua: kpiDetail['phuongphapdo'],
        kehoach: kpiDetail['kehoach'],
        trongsokpicanhan: kpiDetail['trongsokpikhoaphong'],
        thuchien: 'null',
        tylehoanthanh: 0,
        ketqua: false,
      );

      try {
        await Provider.of<Usuario_provider1>(context, listen: false)
            .addTieuchikpicanhan(chitietkpicanhan);
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(content: Text('Đã lưu thông tin KPI.')),
        // );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Thêm mới thất bại111: $e')),
        );
      }
    }
  }

  Future<bool> checkKpiStatus(BuildContext context) async {
    try {
      print("ffffffff");
      print(Manhanvien);
       var resultParam1 =
        await Provider.of<Usuario_provider>(context, listen: false)
            .GetMaNVByEmail(widget.userEmail);
           Manhanvien= resultParam1;
      int resultParam =
          await Provider.of<Usuario_provider1>(context, listen: false)
              .CheckNamPhieuKpiCN(DateTime.now().year, Manhanvien);
print("nnnnnnnnnnnn");
print(resultParam);
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
          print(" Điều hướng tới trang xem biểu mẫu");
          //Điều hướng tới trang xem biểu mẫu
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => XemBieumauKPCN(
          //       machucdanh: machucdanh.toString(),
          //     ),
          //   ),
          // );
          return false; // Dừng lại nếu người dùng chọn xem lại
        } else {
          print("Lưu chỉnh sửa");
          await _handleSave1();
          return false;
        }
      } else if (resultParam == 3 || resultParam == null) {
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
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //       builder: (context) => XemBieumauKPCN(
      //             machucdanh: machucdanh.toString(),
      //           )), // Điều hướng đến trang xem biểu mẫu
      // );
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
      _LayMaPhieu();
    if (machucdanh == null || machucdanh == '') {
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
          Provider.of<Usuario_provider1>(context, listen: false);
           final gmail = widget.userEmail;
    var resultParam =
        await Provider.of<Usuario_provider>(context, listen: false)
            .GetMaNVByEmail(gmail);
           Manhanvien= resultParam;
      maphieukpi = await Provider.of<Usuario_provider1>(context, listen: false)
          .getMaphieuKpCNByNamandMaNV(currentYear, Manhanvien);
          print("aaaaaaaaaaaaaaa");
          print(maphieukpi);
      // Gọi hàm lưu KPI
      if (maphieukpi != null) {
        await deletechitietKPICN(
            maphieukpi!); // Chỉ thực hiện nếu maphieukpi khác null
      }
      await saveChitietkpiCaNhan(
          context, maphieukpi.toString()); // Và hàm thứ ba
      await saveEditsKPICN(); // Tiếp tục thực hiện hàm thứ hai
      print(maphieukpi);

      // Thông báo lưu thành công
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lưu thông tin KPI thành công!')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CapKpiCN(userEmail: widget.userEmail,
                displayName: widget.displayName,
                photoURL: widget.photoURL,),
        ),
      );
    } catch (e) {
      // Bắt lỗi và thông báo nếu có lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lưu thất bại: $e')),
      );
    }
  }

  Future<void> saveEditsKPICN() async {
    final usuarioProvider =
        Provider.of<Usuario_provider1>(context, listen: false);
    if (maphieukpi!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không có mã phiếu để thông qua.')),
      );
      return;
    }
    // Lấy đối tượng Kpicanhan dựa trên mã phiếu
    Kpicanhan? kpicanhan =
        await usuarioProvider.getKpicanhanByMaphieu(maphieukpi!);

    if (kpicanhan == null) {
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
    kpicanhan.manv = Manhanvien;
    kpicanhan.nguoipheduyetkpicanhan = null;
    kpicanhan.ngaylapphieukpicanhan = validDateTime(DateTime.now());
    kpicanhan.ngaypheduyetkpicanhan = null;
    kpicanhan.trangthai = 0;

    // Gọi API để cập nhật trạng thái KPI cá nhân
    await usuarioProvider.updateKPICaNhan(kpicanhan);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Thông qua biễu mẫu thành công!')),
    );
  }

// Hàm để lưu chỉnh sửa
  Future<void> _LayMaPhieu() async {
  
    final gmail = widget.userEmail;
    var resultParam =
        await Provider.of<Usuario_provider>(context, listen: false)
            .GetMaNVByEmail(gmail);
           Manhanvien= resultParam;
    maphieukpi = await Provider.of<Usuario_provider1>(context, listen: false)
        .getMaphieuKpCNByNamandMaNV(currentYear, Manhanvien);
    // maphieukpi1 = maphieukpi!;
    await Provider.of<Usuario_provider1>(context, listen: false)
        .ChiTietKPICNByMaNVvaNam(Manhanvien, currentYear);

    print('Mã phiếu KPI: $maphieukpi');
    print(
        'Chi tiết KPI cá nhân: ${Provider.of<Usuario_provider1>(context, listen: false).chitiietkpicanhan}');

    Provider.of<Usuario_provider1>(context, listen: false)
            .chitiietkpicanhan
            .isEmpty
        ? []
        : Provider.of<Usuario_provider1>(context, listen: false)
            .chitiietkpicanhan
            .map((kpiDetail) {
            print('Chi tiết KPI: $kpiDetail');
          });
  }

  Future<void> deletechitietKPICN(String maphieukpi) async {
    final usuarioProvider =
        Provider.of<Usuario_provider1>(context, listen: false);

    try {
      // In ra thông tin trước khi xóa
      print('Bắt đầu xóa chi tiết KPI với mã phiếu KPI: $maphieukpi');

      await usuarioProvider.deletecchitietKPICaNhan(maphieukpi);

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
