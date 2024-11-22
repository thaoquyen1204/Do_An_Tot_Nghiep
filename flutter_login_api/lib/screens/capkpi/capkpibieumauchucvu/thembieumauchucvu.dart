import 'package:flutter/material.dart';
import 'package:flutter_login_api/mausacvakichthuoc/constants1.dart';
import 'package:flutter_login_api/models/chitietkpikhoaphong.dart';
import 'package:flutter_login_api/models/kpikhoaphong.dart';
import 'package:flutter_login_api/models/kpiphongcntt.dart';
import 'package:flutter_login_api/models/modelchucdanh.dart';
import 'package:flutter_login_api/providers/usuario_provider2.dart';
import 'package:flutter_login_api/screens/capkpi/capkpibieumauchucvu/capkpibieumauchucvu.dart';
import 'package:flutter_login_api/screens/capkpi/capkpikhoaphong/kpichitietkhoaphong.dart';
import 'package:flutter_login_api/screens/kiemduyetbieumau/khoaphongcn/xembieumauchucvucanhan.dart';
import 'package:flutter_login_api/screens/main/components/side_menu.dart';
import 'package:flutter_login_api/screens/test.dart';
import 'package:provider/provider.dart';
import 'package:flutter_login_api/providers/usuario_provider.dart';

class ThemmuctieuBMCN extends StatefulWidget {
  final List<int> currentSelectedMaqpList;
  String machucdanh;
      final String userEmail;
  final String displayName;
  final String? photoURL;

   ThemmuctieuBMCN({Key? key,
 required this.currentSelectedMaqpList,required this.machucdanh,required this.userEmail,
    required this.displayName,
    this.photoURL, })
      : super(key: key);

  @override
  _ThemmuctieuCNScreenState createState() => _ThemmuctieuCNScreenState();
}

class _ThemmuctieuCNScreenState extends State<ThemmuctieuBMCN>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final int currentYear = DateTime.now().year;
  List<int> selectedRows = [];
  bool _selectAll = false;
  late List<Map<String, dynamic>> apiData;
  TextEditingController _searchController = TextEditingController();
  late String userName= ''; // Thay thế bằng tên người dùng
  late String userPosition = ''; // Thay thế bằng chức vụ
  String? selectedmachucdanh = '';
    List<Map<String, dynamic>> selectedKpiDetails =
      []; 
    String? maphieukpi;
   late String machucdanh;
   String maNV = '';
    
  @override
  void initState() {
    super.initState();
    // _fetchEmployeeQuyen();
    _tabController = TabController(length: 4, vsync: this);
    selectedRows = List.from(widget.currentSelectedMaqpList);
    machucdanh=widget.machucdanh;
    selectedmachucdanh=widget.machucdanh;
    _LayMaPhieu();
    _fetchEmployeeMaNV();
    
    Future.microtask(() =>
        Provider.of<Usuario_provider>(context, listen: false).GetKPIByCVCN());
    
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
      child: IntrinsicHeight(
        child: DropdownButtonFormField<String>(
          isExpanded: true,
          decoration: const InputDecoration(
            labelText: 'Chọn mã chức danh',
            contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            border: OutlineInputBorder(),
          ),
          value: machucdanh,
          onChanged: (String? newValue) {
            setState(() {
              machucdanh = newValue ?? machucdanh; 
            });
          },
          items: usuarioProvider1.chucdanh.map((ChucDanh chuc) {
            return DropdownMenuItem<String>(
              value: chuc.maChucDanh,
              child: Text(
                chuc.tenChucDanh,
                style: const TextStyle(fontSize: 14),
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
                              onPressed: () {
                                // Add your onPressed action here
                              },
                              child: const Text('Tiếp tục'),
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
  final isSelected = selectedRows.contains(usuario.makpi);

                return DataRow(
                  
    cells: [
      DataCell(
        Checkbox(
          value: isSelected,
          onChanged: (value) {
            // Chỉ cập nhật trạng thái của checkbox hiện tại
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
                selectedKpiDetails.removeWhere(
                    (element) => element['makpi'] == usuario.makpi);
              }
              _selectAll = selectedRows.length == uniqueKpicntt.length;
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
        // Gọi hàm lưu KPI
         if (maphieukpi != null) {
  await deletechitietKPIKP(maphieukpi!); // Chỉ thực hiện nếu maphieukpi khác null
}

await saveEditsKPIKP(); // Tiếp tục thực hiện hàm thứ hai
await saveChitietkpikhoaphong(context, maphieukpi.toString()); // Và hàm thứ ba

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
              ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Thông qua biễu mẫu thành công!')),
    );
    
      } catch (e) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Thêm mới thất bạikp1: $e')),
        // );
      }
    }
  }

    Future<void> saveEditsKPIKP() async {
    if (maphieukpi!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không có mã phiếu để thông qua.')),
      );
      return;
    }

    final usuarioProvider =
        Provider.of<Usuario_provider2>(context, listen: false);

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
    Future<String?> _fetchEmployeeMaNV() async {
    final gmail = widget.userEmail;
    var resultParam =
        await Provider.of<Usuario_provider>(context, listen: false)
            .GetMaNVByEmail(gmail);

    print("Fetching data for MaNV: ${resultParam}");

     maNV = resultParam;
  }

// Hàm để lưu chỉnh sửa
  Future<void> _LayMaPhieu() async {

  maphieukpi = await Provider.of<Usuario_provider2>(context, listen: false)
      .GetChiTietKPIKKpByMCCDvaNam(machucdanh, currentYear);
  await Provider.of<Usuario_provider2>(context, listen: false)
      .ChiTietKPIKPByMaCDvaNam(machucdanh, currentYear);

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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Lỗi khi xóa chi tiết KPI: $e')),
    );
  }
}
}
