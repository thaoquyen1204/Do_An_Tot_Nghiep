import 'package:flutter/material.dart';
import 'package:flutter_login_api/mausacvakichthuoc/constants1.dart';
import 'package:flutter_login_api/models/kpibenhvien.dart';
import 'package:flutter_login_api/models/kpicanhan.dart';
import 'package:flutter_login_api/models/modelchucdanh.dart';
import 'package:flutter_login_api/providers/usuario_provider.dart';
import 'package:flutter_login_api/providers/usuario_provider2.dart';
import 'package:flutter_login_api/screens/capkpi/capkpibieumauchucvu/thembieumauchucvu.dart';
import 'package:flutter_login_api/screens/capkpi/capkpicanhan/themmuctieukpicanhan.dart';
import 'package:flutter_login_api/screens/capkpi/capkpikhoaphong/themmuctieukpi.dart';
import 'package:flutter_login_api/screens/kiemduyetbieumau/khoaphongcn/xembieumaubutton.dart';
import 'package:flutter_login_api/screens/kiemduyetbieumau/nutkiemduyet.dart';
import 'package:flutter_login_api/screens/main/components/side_menu.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Để lấy năm hiện tại

class XemBieumauKPCN extends StatefulWidget {
  final String machucdanh;
      final String userEmail;
  final String displayName;
  final String? photoURL;
  const XemBieumauKPCN({
    Key? key,
    required this.machucdanh,
    required this.userEmail,
    required this.displayName,
    this.photoURL,
  }) : super(key: key);
  @override
  _XemKhoaPhongCNState createState() => _XemKhoaPhongCNState();
}

class _XemKhoaPhongCNState extends State<XemBieumauKPCN> {
  final _yearController = TextEditingController();
  bool _isLoading = false; // Để hiển thị trạng thái đang tải
  bool _isDataVisible = false;
  bool _kiemduyet = true;
  final int currentYear = DateTime.now().year;
  String maphieukpi = '';
  int sotrangthai = 0;
  String _maNVController = '';
  String _employeeName = '';
  late int nam;

  List<int> currentSelectedMaqpList = [];
  String tenchucdanh = '';
  String _machucdanhtext = '';
  late String selectedMaChucDanh;
  late String selectedMaChucDanh1;
  final now = DateTime.now();
  // Khai báo usuarioProvider1 ở đây
  late Usuario_provider usuarioProvider1;

  @override
  @override
void initState() {
  super.initState();
  _yearController.text = currentYear.toString();
  nam =  currentYear;
  selectedMaChucDanh = widget.machucdanh ?? ''; // Ensure it has a valid value
  print('selectedMaChucDanh$selectedMaChucDanh');
  _fetchEmployeeTen();
   _fetchEmployeeQuyen();
  usuarioProvider1 = Provider.of<Usuario_provider>(context, listen: false);
}
Future<String?> _fetchEmployeeQuyen() async {
    final gmail = widget.userEmail;
    var resultParam =
        await Provider.of<Usuario_provider>(context, listen: false)
            .GetMaNVByEmail(gmail);

    print("Fetching data for MaNV: ${resultParam}");

    final maNV = resultParam;
    
      var result = await Provider.of<Usuario_provider>(context, listen: false)
          .getEmployeeQuyenByMaNV(maNV);
_employeeName = result;
      // Cập nhật userPosition dựa vào kết quả trả về
    
      print("xem maquyen: $_employeeName");
     
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
            await Provider.of<Usuario_provider2>(context, listen: false)
                .CheckNamPhieuKpiKP(year, selectedMaChucDanh); // Lấy trạng thái
                print(selectedMaChucDanh);

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
                content: Text('Không tìm thấy trạng thái cho nhân viên này!')),
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

  Future<String?> _fetchEmployeeTen() async {
    // In thông báo trước khi gọi hàm GetKPITenCDByMaCD
    print("Starting to fetch data for MaChucDanh1: ${widget.machucdanh}");

    // Gọi hàm GetKPITenCDByMaCD và chờ kết quả
    var resultParam =
        await Provider.of<Usuario_provider>(context, listen: false)
            .GetKPITenCDByMaCD(selectedMaChucDanh);

    // In kết quả trả về từ API (resultParam)
    print("Fetched resultParam: $resultParam");

    // Cập nhật biến tenchucdanh với kết quả nhận được
    tenchucdanh = resultParam;

    // In giá trị biến tenchucdanh sau khi cập nhật
    print("Updated tenchucdanh: $tenchucdanh");

    // Trả về giá trị kết quả
    return resultParam;
  }

  @override
  void dispose() {
    _yearController.dispose();
    super.dispose();
  }

  // Hàm lấy chi tiết KPI khoa phòng
 Future<void> _fetchKPI() async {
  final year = int.tryParse(_yearController.text);
  nam = year!;
  final machucdanh = selectedMaChucDanh;
  print('Year input: $year'); // Kiểm tra giá trị nhập từ TextField

  if (year != null) {
    setState(() {
      _isLoading = true;
    });

    try {
      print('Fetching data for year: $year'); // Bắt đầu gọi API với year

      // Lấy chi tiết KPI cá nhân chỉ dựa trên năm
      final fetchedData = await Provider.of<Usuario_provider2>(context, listen: false)
          .ChiTietKPIKPByMaCDvaNam(machucdanh, year);
 final fetchedData1 = await Provider.of<Usuario_provider2>(context, listen: false)
          .GetChiTietKPIKKpByMCCDvaNam(machucdanh, year);

      // Kiểm tra nếu dữ liệu trả về là rỗng hoặc không có
      if (fetchedData1 == null || fetchedData1.isEmpty) {
        print('No data available for year: $year');
        setState(() {
          _isDataVisible = false; // Ẩn bảng nếu không có dữ liệu
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Dữ liệu không tồn tại cho năm $year')),
        );
      } else {
        print('Data fetched successfully'); // Dữ liệu được fetch thành công
        setState(() {
          _isDataVisible = true; // Hiển thị bảng nếu có dữ liệu
        });
      }
    } catch (error) {
      print('Error fetching data: $error'); // Xử lý lỗi nếu có
      setState(() {
        _isDataVisible = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Dữ liệu không tồn tại')),
      );
    } finally {
      setState(() {
        _isLoading = false; // Dừng hiển thị loading khi hoàn tất
      });
      print('Loading completed'); // Xác nhận quá trình fetch hoàn tất
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
                            title: "Quay lại ",
                            svgSrc: "assets/icons/menu_doc.svg",
                            press: () {
    Navigator.pop(context); // Quay lại trang trước đó
  },
            
                          ),
                        ],
                      ),
                    ),
                    // Bên phải: Nội dung chính
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        child: _LayChiTiet(),
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
                      child: _LayChiTiet(),
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

  Widget _LayChiTiet() {
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
            Center(
              child: Text(
                'Xem biểu mẫu KPI chung năm $nam',
                style: TextStyle(
                  fontSize: 21,
                  color: Colors.black,
                ),
                textAlign:
                    TextAlign.center, // Đảm bảo căn giữa nội dung văn bản
              ),
            ),

            const SizedBox(
                height: 20), // Khoảng cách giữa tiêu đề và hàng bên dưới
            // Khung chứa mã NV, năm và nút lấy chi tiết
          Row(
  crossAxisAlignment: CrossAxisAlignment.center,
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    // Ô nhập năm
    Expanded(
      flex: 2,
      child: IntrinsicHeight(
        child: TextFormField(
          controller: _yearController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Năm',
            labelStyle: TextStyle(color: Colors.blue),
            contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            border: OutlineInputBorder(),
          ),
        ),
      ),
    ),
    const SizedBox(width: 20),
    // Dropdown chọn mã chức danh
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
          value: selectedMaChucDanh,
          onChanged: (String? newValue) {
            setState(() {
              selectedMaChucDanh = newValue ?? selectedMaChucDanh; 
              _fetchKPI();
              _trangthai();
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
    const SizedBox(width: 20),
    // Nút lấy KPI
    ElevatedButton(
      onPressed: () async {
        await _fetchKPI();
        await _trangthai();
      },
      child: const Text(
        'Lấy Chi Tiết biểu mẫu',
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: const Color.fromARGB(255, 110, 187, 117),
        shadowColor: Colors.greenAccent,
        elevation: 5,
      ),
    ),
  ],
),



            const SizedBox(height: 20),

            // Hiển thị dữ liệu KPI
            if (_isDataVisible)
              Expanded(
                child: Center(
                  child: Consumer<Usuario_provider2>(
                    builder: (ctx, kpiProvider, child) {
                      return Container(
                        padding: const EdgeInsets.all(16),
                        width: MediaQuery.of(context).size.width *
                            0.85, // Đặt khung lớn
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(
                              color: Colors.blueAccent), // Viền màu xanh
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
                            rows: kpiProvider.chitietkpikhoaphong.isEmpty
                                ? []
                                : kpiProvider.chitietkpikhoaphong.map(
                                    (kpiDetail) {
                                      maphieukpi =
                                          kpiDetail.maphieukpikhoaphong;
                                      // Lưu mã KPI vào currentSelectedMaqpList
                                      currentSelectedMaqpList
                                          .add(kpiDetail.makpi);
                                      return DataRow(cells: [
                                        DataCell(
                                          Container(
                                            width: 250,
                                            child: Text(
                                              kpiDetail.noidungkpikhoaphong,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines:
                                                  1, // Giới hạn chỉ hiển thị 1 dòng
                                              softWrap: true,
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            kpiDetail.tieuchidanhgiaketqua ??
                                                '',
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
                                            kpiDetail.trongsokpikhoaphong
                                                .toString(),
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
            if (_isDataVisible && sotrangthai == 2&&
                _employeeName == 'NV')
              const Text('Biểu mẫu bị từ chối.'),
            if (_isDataVisible &&
                sotrangthai == 2 &&
                (_employeeName == 'TKP'||_employeeName == 'PKP')) ...[
              const Text('Biểu mẫu bị từ chối.'),
              Align(
                alignment: Alignment.centerRight, // Đặt nút chỉnh sửa bên phải
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ThemmuctieuBMCN(
                          currentSelectedMaqpList: currentSelectedMaqpList,    
                          machucdanh: selectedMaChucDanh.toString(), 
                            userEmail: widget.userEmail ?? '',
                                    displayName: widget.displayName ?? '',
                                    photoURL: widget.photoURL ?? '',           
                        ),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  },
                  child: const Text(
                    'Chỉnh sửa',
                    style: TextStyle(
                      color: Colors
                          .white, // Màu chữ trắng để nổi bật trên nền xanh
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: Color.fromARGB(
                        255, 110, 187, 117), // Màu nền xanh lá nhạt
                    shadowColor: Colors.greenAccent, // Đổ bóng màu xanh nhẹ
                    elevation: 5, // Hiệu ứng đổ bóng
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
