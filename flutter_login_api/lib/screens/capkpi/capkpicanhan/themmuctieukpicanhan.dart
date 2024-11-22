import 'package:flutter/material.dart';
import 'package:flutter_login_api/models/kpiphongcntt.dart';
import 'package:flutter_login_api/screens/capkpi/capkpikhoaphong/kpichitietkhoaphong.dart';
import 'package:provider/provider.dart';
import 'package:flutter_login_api/providers/usuario_provider.dart';

class ThemmuctieuCN extends StatefulWidget {
  final List<int> currentSelectedMaqpList;
    final String userEmail;
  final String displayName;
  final String? photoURL;

  const ThemmuctieuCN({Key? key,
    required this.userEmail,
    required this.displayName,
    this.photoURL, required this.currentSelectedMaqpList})
      : super(key: key);

  @override
  _ThemmuctieuCNScreenState createState() => _ThemmuctieuCNScreenState();
}

class _ThemmuctieuCNScreenState extends State<ThemmuctieuCN>
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

    Future.microtask(() =>
        Provider.of<Usuario_provider>(context, listen: false).GetKPIByCVCN());
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
    return Consumer<Usuario_provider>(
      builder: (context, usuarioProvider1, child) {
        final kpicntt = usuarioProvider1.kpicntt;

        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(150.0),
            child: AppBar(
              title: Text('MỤC TIÊU CÁ NHÂN - NĂM $currentYear'),
              backgroundColor: Color.fromARGB(255, 110, 187, 117),
              centerTitle: true,
              flexibleSpace: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.85,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              height: 50,
                              child: TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  hintText: 'Tìm kiếm KPI...',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                  prefixIcon: Icon(Icons.search),
                                ),
                                onChanged: (text) {
                                  // Logic tìm kiếm ở đây
                                },
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                  ),
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        userName,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        userPosition,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                PopupMenuButton<String>(
                                  onSelected: (value) {
                                    // Handle menu selection here
                                    if (value == 'Tùy chọn 1') {
                                      // Do something
                                    } else if (value == 'Tùy chọn 2') {
                                      // Do something else
                                    }
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return [
                                      PopupMenuItem<String>(
                                        value: 'Tùy chọn 1',
                                        child: Text('Tùy chọn 1'),
                                      ),
                                      PopupMenuItem<String>(
                                        value: 'Tùy chọn 2',
                                        child: Text('Tùy chọn 2'),
                                      ),
                                    ];
                                  },
                                  icon: Icon(Icons.more_vert),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
           body: Container(
            color: Color(0xFFE8F5E9),
             child: Column(
            children: [
              const SizedBox(height: 20),
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
                        child: DataTable(
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
                                      width: 350,
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
              //if (selectedRows.isNotEmpty && selectedRows.length >= 5)
              //   Padding(
              //     padding: const EdgeInsets.all(16.0),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         ElevatedButton(
              //           onPressed: () {
              //             Navigator.pushAndRemoveUntil(
              //               context,
              //               MaterialPageRoute(
              //                 builder: (context) => KpiDetailsScreenCN(
              //                   userEmail: widget.userEmail,
              // displayName:widget. displayName,
              // photoURL: widget.photoURL,
              //                   selectedMaqpList: selectedRows,
              //                 ),
              //               ),
              //               (Route<dynamic> route) => false,
              //             );
              //           },
              //           child: const Text('Xem chi tiết'),
              //           style: ElevatedButton.styleFrom(
              //             backgroundColor: Colors.green,
              //             padding: const EdgeInsets.symmetric(
              //                 horizontal: 32, vertical: 16),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
            ],
          ),
           )

        );
      },
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
