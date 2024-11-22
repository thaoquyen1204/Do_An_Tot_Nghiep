import 'package:flutter/material.dart';
import 'package:flutter_login_api/mausacvakichthuoc/constants1.dart';
import 'package:flutter_login_api/models/kpibenhvien.dart';
import 'package:flutter_login_api/models/kpicanhan.dart';
import 'package:flutter_login_api/providers/usuario_provider.dart';
import 'package:flutter_login_api/providers/usuario_provider1.dart';
import 'package:flutter_login_api/screens/capkpi/capkpikhoaphong/themmuctieukpi.dart';
import 'package:flutter_login_api/screens/main/components/side_menu.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Để lấy năm hiện tại

class XemKhoaPhongBM extends StatefulWidget {
      final String userEmail;
  final String displayName;
  final String? photoURL;
 const XemKhoaPhongBM({Key? key,
    required this.userEmail,
    required this.displayName,
    this.photoURL})
      : super(key: key);
  @override
  _KhoaPhongBMState createState() => _KhoaPhongBMState();
}

class _KhoaPhongBMState extends State<XemKhoaPhongBM> {
  final _yearController = TextEditingController();
  bool _isLoading = false; // Để hiển thị trạng thái đang tải
  bool _isDataVisible = false;
  bool _kiemduyet = true;
  int currentYear = DateTime.now().year;
  String maphieukpi = '';
  int sotrangthai = 0;
  String _maNVController = '';
  String _employeeName = '';
  List<int> currentSelectedMaqpList = [];
  

  final now = DateTime.now();

  /// Hàm để lấy chức vụ dựa trên mã nhân viên
  Future<String?> _fetchEmployeeQuyen() async {
     final gmail = widget.userEmail;
    var result = await Provider.of<Usuario_provider>(context, listen: false)
        .GetMaNVByEmail(gmail);

    print("Fetching data for MaNV: ${result}");
    _maNVController = result;
     final maNV = result;// Lấy giá trị từ TextField
    try {
      var resultParam =
          await Provider.of<Usuario_provider>(context, listen: false)
              .getEmployeeQuyenByMaNV(maNV);
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
                .KPIBVTTByNam(year); // Lấy trạng thái

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
  void initState() {
    super.initState();
    // Lấy năm hiện tại và đặt làm giá trị mặc định cho ô năm
    _yearController.text = currentYear.toString();
    _fetchEmployeeQuyen();
  }

  @override
  void dispose() {
    _yearController.dispose();
    super.dispose();
  }

  // Hàm lấy chi tiết bệnh viện
  Future<void> _fetchKPI() async {
    final year = int.tryParse(_yearController.text);
    currentYear = year!;
    print('Year input: $year'); // Kiểm tra giá trị nhập từ TextField

    if (year != null) {
      setState(() {
        _isLoading = true;
      });

      try {
        print('Fetching data for year: $year'); // Bắt đầu gọi API với year

        // Lấy chi tiết KPI cá nhân chỉ dựa trên năm
        await Provider.of<Usuario_provider1>(context, listen: false)
            .ChiTietKPIBVByNam(year);

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
  return Center(
    child: Container(
      padding: const EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width * 0.85, // Kích thước khung lớn
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(color: Colors.blueAccent), // Viền màu xanh
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
        crossAxisAlignment: CrossAxisAlignment.center, // Căn giữa cho cột
        children: [
          // Tiêu đề "Biểu mẫu KPI khoa phòng năm"
          Text(
            'Biểu mẫu KPI khoa phòng năm $currentYear',
            style: TextStyle(
             fontSize: 21,
                  color: Colors.black,
            ),
            textAlign: TextAlign.center, // Đảm bảo căn giữa nội dung văn bản
          ),
          const SizedBox(height: 16), // Khoảng cách giữa tiêu đề và phần nhập liệu

          // Khung chứa mã NV, năm và nút lấy chi tiết
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(width: 10),
              // Ô nhập năm
              Expanded(
                child: TextFormField(
                  controller: _yearController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Năm',
                    labelStyle: TextStyle(color: Colors.blue), // Thay đổi màu chữ
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Nút lấy KPI
              ElevatedButton(
                onPressed: () async {
                  await _fetchKPI(); // Gọi hàm lấy KPI
                  await _trangthai(); // Gọi hàm lấy trạng thái
                },
                child: const Text('Lấy Chi Tiết biểu mẫu'),
                 style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green, // Màu nền
                                  foregroundColor: Colors.white, // Màu văn bản
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 32, vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(8), // Bo góc nút
                                  ),
                                ),
                              ),
            ],
          ),
          const SizedBox(height: 20),

          // Hiển thị dữ liệu KPI
          if (_isDataVisible)
            Expanded(
              child: Center(
                child: Consumer<Usuario_provider1>(
                  builder: (ctx, kpiProvider, child) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      width: MediaQuery.of(context).size.width * 0.85, // Đặt khung lớn
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.blueAccent), // Viền màu xanh
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
                        child: DataTable(
                          columnSpacing: 20.0,
                          columns: const [
                            DataColumn(label: Text('Nội Dung KPI')),
                            DataColumn(label: Text('Tiêu chí')),
                            DataColumn(label: Text('Kế hoạch')),
                            DataColumn(label: Text('Trọng Số')),
                          ],
                          rows: kpiProvider.chitiettieuchimuctieuBV.isEmpty
                              ? []
                              : kpiProvider.chitiettieuchimuctieuBV.map(
                                  (kpiDetail) {
                                    maphieukpi = kpiDetail.maphieukpibenhvien;
                                    currentSelectedMaqpList.add(kpiDetail.makpi);
                                    return DataRow(cells: [
                                      DataCell(
                                        Container(
                                          width: 250,
                                          child: Text(
                                            kpiDetail.noidungkpi,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            softWrap: true,
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          kpiDetail.phuongphapdo ?? '',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          kpiDetail.kehoach ?? '',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          kpiDetail.trongsokpibv.toString(),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ]);
                                  },
                                ).toList(),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          const SizedBox(height: 20),

          // Hiển thị các thông báo trạng thái và nút tùy theo trạng thái và quyền
          if (_isDataVisible && sotrangthai == 0)
            const Text('Biểu mẫu chưa được phê duyệt.'),
          if (_isDataVisible && sotrangthai == 1)
            const Text('Biểu mẫu đã được phê duyệt.'),
          if (_isDataVisible && sotrangthai == 2 && _employeeName == 'NV')
            const Text('Biểu mẫu bị từ chối.'),
          if (_isDataVisible && sotrangthai == 2 && _employeeName == 'TKP' || _employeeName == 'PKP' ) ...[
            const Text('Biểu mẫu bị từ chối.'),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ThemmuctieuKP(
                        currentSelectedMaqpList: currentSelectedMaqpList,
                        userEmail: widget.userEmail,
                        displayName: widget.displayName,
                        photoURL: widget.photoURL,
                      ),
                    ),
                    (Route<dynamic> route) => false,
                  );
                },
                child: const Text('Chỉnh sửa biểu mẫu'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    ),
  );
}

}
