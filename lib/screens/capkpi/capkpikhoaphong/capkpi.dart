import 'package:flutter/material.dart';
import 'package:flutter_login_api/mausacvakichthuoc/constants1.dart';
import 'package:flutter_login_api/models/kpiphongcntt.dart';
import 'package:flutter_login_api/screens/capkpi/capkpikhoaphong/kpichitietkhoaphong.dart';
import 'package:flutter_login_api/screens/capkpi/trangchucapkpi.dart';
import 'package:flutter_login_api/screens/kpi/danhmuckpi.dart';
import 'package:flutter_login_api/screens/main/components/side_menu.dart';
import 'package:flutter_login_api/screens/nguoidung/trangchuthongtincanhan.dart';
import 'package:flutter_login_api/screens/trangchu/truongphong/truongphong.dart';
import 'package:provider/provider.dart';
import 'package:flutter_login_api/providers/usuario_provider.dart';

class CapKpiKP extends StatefulWidget {
  final String userEmail;
  final String displayName;
  final String? photoURL;
  const CapKpiKP(
      {Key? key,
      required this.userEmail,
      required this.displayName,
      this.photoURL})
      : super(key: key);
  @override
  _CapKpiKPScreenState createState() => _CapKpiKPScreenState();
}

class _CapKpiKPScreenState extends State<CapKpiKP>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final int currentYear = DateTime.now().year;
  List<int> selectedRows = [];
  bool _selectAll = false; // Thêm biến để theo dõi trạng thái "Chọn tất cả"
  late List<Map<String, dynamic>> apiData;
  TextEditingController _searchController = TextEditingController();
  late String userName; // Thay thế bằng tên người dùng
  late String userPosition = ''; // Thay thế bằng chức vụ
  TextEditingController searchController = TextEditingController();
  List<Kpiphongcntt> filteredKpicntt = [];

  @override
  void initState() {
    super.initState();
    userName = widget.displayName;
    _fetchEmployeeQuyen();
    _tabController = TabController(length: 4, vsync: this);
    Future.microtask(() => Provider.of<Usuario_provider>(context, listen: false)
        .getKpiPhongKhoa());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Giaodien1(
                                    userEmail: widget.userEmail,
                                    displayName: widget.displayName,
                                    photoURL: widget.photoURL!,
                                  ),
                                ),
                              );
                            },
                          ),
                          DrawerListTile(
                            title: "Chọn lại",
                            svgSrc: "assets/icons/menu_dashboard.svg",
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
                            title: "Danh sách KPI",
                            svgSrc: "assets/icons/menu_doc.svg",
                            press: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Kpi(
                                    userEmail: widget.userEmail ?? '',
                                    displayName: widget.displayName ?? '',
                                    photoURL: widget.photoURL ?? '',
                                  ), // Điều hướng đến chi tiết KPI
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TrangChuCap(
                                    userEmail: widget.userEmail ?? '',
                                    displayName: widget.displayName ?? '',
                                    photoURL: widget.photoURL ?? '',
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
                        child: _LayChiTiet(kpicntt),
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
                      child: _LayChiTiet(kpicntt),
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

  // Hàm tìm kiếm
  void _searchKpi() {
    String query = searchController.text.toLowerCase();
    Usuario_provider usuarioProvider1 =
        Provider.of<Usuario_provider>(context, listen: false);
    final kpicntt = usuarioProvider1.kpicntt;
    // In ra từ khóa tìm kiếm (query)
    print('Từ khóa tìm kiếm: $query');

    setState(() {
      filteredKpicntt = kpicntt.where((usuario) {
        // Kiểm tra dữ liệu của mỗi đối tượng
        bool match = usuario.noidung!.toLowerCase().contains(query) ||
            usuario.phuongphapdo!.toLowerCase().contains(query) ||
            usuario.donvitinh!.toLowerCase().contains(query) ||
            usuario.chitieu!.toLowerCase().contains(query);

        // In ra kết quả so khớp của mỗi đối tượng
        print('So khớp với ${usuario.noidung}: $match');

        return match;
      }).toList();
      // Loại bỏ mục trùng lặp
      filteredKpicntt = _removeDuplicates(filteredKpicntt);
      // In ra danh sách kết quả đã lọc
      print('Danh sách kết quả đã lọc: ${filteredKpicntt.length} mục');
    });
  }

  List<Kpiphongcntt> _removeDuplicates(List<Kpiphongcntt> list) {
    final uniqueItems = <String, Kpiphongcntt>{};
    for (var item in list) {
      if (item.noidung != null) {
        uniqueItems[item.noidung!] = item; // Sử dụng `noidung` làm key
      }
    }
    return uniqueItems.values.toList();
  }

  Widget _LayChiTiet(List<Kpiphongcntt> kpicntt) {
    if (filteredKpicntt == null || filteredKpicntt.isEmpty) {
      filteredKpicntt = _removeDuplicates(kpicntt);
    } else {
      filteredKpicntt = filteredKpicntt;
    }
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            'Cấp KPI khoa phòng',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(94, 113, 122, 1),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: 'Tìm kiếm mục tiêu...',
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.grey[700]!,
                          width: 2.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.grey[700]!,
                          width: 2.0,
                        ),
                      ),
                      prefixIcon: Icon(Icons.search, color: Colors.grey[700]),
                      hintText: 'Nhập mục tiêu...',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _searchKpi, // Gọi hàm tìm kiếm khi nhấn nút
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color.fromARGB(255, 110, 187, 117),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.search, color: Colors.white), // Icon trên nút
                      SizedBox(width: 8), // Khoảng cách giữa icon và text
                      Text('Tìm kiếm',
                          style:
                              TextStyle(color: Colors.white)), // Text trên nút
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SingleChildScrollView(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: DataTable(
                          headingRowColor: MaterialStateColor.resolveWith(
                              (states) => Colors.grey[200]!),
                          dataRowColor: MaterialStateColor.resolveWith(
                              (states) => Colors.white),
                          columns: [
                            DataColumn(
                              label: Row(
                                children: [
                                  Text('Chọn tất cả'),
                                  Checkbox(
                                    value: _selectAll,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectAll = value!;
                                        if (_selectAll) {
                                          selectedRows = filteredKpicntt
                                              .map((usuario) => usuario.makpi)
                                              .toList();
                                        } else {
                                          selectedRows.clear();
                                        }
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const DataColumn(
                                label: Text(
                                    'Mục tiêu bệnh viện (chọn ít nhất 5 mục)')),
                            const DataColumn(label: Text('Phương pháp đo')),
                            const DataColumn(label: Text('Đơn vị')),
                            const DataColumn(label: Text('Chỉ tiêu')),
                          ],
                          rows: filteredKpicntt.map<DataRow>((usuario) {
                            print(
                                'Số lượng mục tiêu hiện tại: ${filteredKpicntt.length}');
                            return DataRow(
                              cells: [
                                DataCell(
                                  Checkbox(
                                    value: selectedRows.contains(usuario.makpi),
                                    onChanged: (value) {
                                      setState(() {
                                        if (value!) {
                                          selectedRows.add(usuario.makpi);
                                        } else {
                                          selectedRows.remove(usuario.makpi);
                                        }
                                        _selectAll = selectedRows.length ==
                                            filteredKpicntt.length;
                                      });
                                    },
                                  ),
                                ),
                                DataCell(
                                  Tooltip(
                                    message: usuario.noidung ?? 'N/A',
                                    child: SizedBox(
                                      width: 300,
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
                                      width: 100,
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
                                      width: 50,
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
              ),
            ),
          ),
          if (selectedRows.isNotEmpty && selectedRows.length >= 5)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => KpiDetailsScreen(
                            selectedMaqpList: selectedRows,
                            userEmail: widget.userEmail,
                            displayName: widget.displayName,
                            photoURL: widget.photoURL,
                          ),
                        ),
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: const Text('Xem chi tiết'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color.fromARGB(255, 110, 187, 117),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget buildCircle(String label) {
    return Column(
      children: [
        const CircleAvatar(
          radius: 15,
          backgroundColor: Colors.grey,
          child: CircleAvatar(
            radius: 13,
            backgroundColor: Colors.white,
          ),
        ),
        const SizedBox(height: 3),
        Text(label, style: const TextStyle(fontSize: 10)),
      ],
    );
  }
}
