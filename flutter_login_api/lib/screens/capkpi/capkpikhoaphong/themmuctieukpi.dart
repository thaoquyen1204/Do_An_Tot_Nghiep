import 'package:flutter/material.dart';
import 'package:flutter_login_api/mausacvakichthuoc/constants1.dart';
import 'package:flutter_login_api/models/kpiphongcntt.dart';
import 'package:flutter_login_api/screens/capkpi/capkpikhoaphong/capkpi.dart';
import 'package:flutter_login_api/screens/capkpi/capkpikhoaphong/kpichitietkhoaphong.dart';
import 'package:flutter_login_api/screens/capkpi/trangchucapkpi.dart';
import 'package:flutter_login_api/screens/main/components/side_menu.dart';
import 'package:provider/provider.dart';
import 'package:flutter_login_api/providers/usuario_provider.dart';

class ThemmuctieuKP extends StatefulWidget {
  final List<int> currentSelectedMaqpList;
      final String userEmail;
  final String displayName;
  final String? photoURL;


  const ThemmuctieuKP({Key? key,required this.userEmail,
    required this.displayName,
    this.photoURL, required this.currentSelectedMaqpList})
      : super(key: key);

  @override
  _ThemmuctieuKPScreenState createState() => _ThemmuctieuKPScreenState();
}

class _ThemmuctieuKPScreenState extends State<ThemmuctieuKP>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final int currentYear = DateTime.now().year;
  List<int> selectedRows = [];
  bool _selectAll = false;
  late List<Map<String, dynamic>> apiData;
  TextEditingController _searchController = TextEditingController();
  late String userName; // Thay thế bằng tên người dùng
  late String userPosition = ''; // Thay thế bằng chức vụ

  @override
  void initState() {
    super.initState();
    userName = widget.displayName;
    _fetchEmployeeQuyen();
    _tabController = TabController(length: 4, vsync: this);
    // Initialize selectedRows with currentSelectedMaqpList
    selectedRows = List.from(widget.currentSelectedMaqpList);

    Future.microtask(() => Provider.of<Usuario_provider>(context, listen: false)
        .getKpiPhongKhoa());
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
Widget _LayChiTiet(List<Kpiphongcntt> kpicntt) {
  TextEditingController searchController = TextEditingController();
  List<Kpiphongcntt> filteredKpicntt = List.from(kpicntt);

  return Center(
    child: Column(
      children: [
        const SizedBox(height: 20),
        // Thêm tiêu đề "Cấp KPI"
        const Text(
          'Cấp KPI khoa phòng',
          style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(94, 113, 122, 1)
              ),
        ),
        const SizedBox(height: 10),
        // Thêm thanh tìm kiếm
    Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16.0),
  child: TextField(
  controller: searchController,
  decoration: InputDecoration(
    labelText: 'Tìm kiếm mục tiêu...',
    labelStyle: TextStyle(
      color: Colors.black, // Màu chữ của nhãn
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: Colors.grey[700]!, // Màu xám đậm cho khung
        width: 2.0,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: Colors.grey[700]!, // Màu xám đậm khi được focus
        width: 2.0,
      ),
    ),
    prefixIcon: Icon(Icons.search, color: Colors.grey[700]),
    hintText: 'Nhập mục tiêu...',
    hintStyle: TextStyle(
      color: Colors.grey, // Màu chữ nhắc (placeholder)
    ),
  ),
  style: TextStyle(
    color: Colors.black, // Màu chữ là đen khi người dùng nhập
  ),
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
                                          selectedRows = kpicntt
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
                          rows: kpicntt.map<DataRow>((usuario) {
                            return DataRow(
                              cells: [
                                DataCell(
                                  Checkbox(
                                    value: selectedRows.contains(usuario.makpi),
                                    onChanged: (value) {
                                      setState(() {
                                        if (value!) {
                                          // Nếu người dùng chọn, thêm vào selectedRows không cần kiểm tra currentSelectedMaqpList
                                          selectedRows.add(usuario.makpi);
                                        } else {
                                          // Bỏ chọn mục, xóa khỏi selectedRows
                                          selectedRows.remove(usuario.makpi);
                                        }

                                        // Cập nhật trạng thái _selectAll
                                        _selectAll = selectedRows.length ==
                                            kpicntt.length;
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
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
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
