import 'package:flutter/material.dart';
import 'package:flutter_login_api/mausacvakichthuoc/constants1.dart';
import 'package:flutter_login_api/models/kpibenhvien.dart';
import 'package:flutter_login_api/models/kpicanhan.dart';
import 'package:flutter_login_api/models/thongbao.dart';
import 'package:flutter_login_api/providers/usuario_provider.dart';
import 'package:flutter_login_api/providers/usuario_provider1.dart';
import 'package:flutter_login_api/providers/usuario_provider3.dart';
import 'package:flutter_login_api/screens/capkpi/capkpikhoaphong/capkpi.dart';
import 'package:flutter_login_api/screens/capkpi/trangchucapkpi.dart';
import 'package:flutter_login_api/screens/kiemduyetbieumau/nutkiemduyet.dart';
import 'package:flutter_login_api/screens/kiemduyetbieumau/trangchubm.dart';
import 'package:flutter_login_api/screens/main/components/side_menu.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Để lấy năm hiện tại

class KhoaPhongBM extends StatefulWidget {
    final String userEmail;
  final String displayName;
  final String? photoURL;
   const KhoaPhongBM({
    Key? key,
    required this.userEmail,
    required this.displayName,
    this.photoURL,
  }) : super(key: key);

 @override
  State<KhoaPhongBM> createState() => _KhoaPhongBMState();
}

class _KhoaPhongBMState extends State<KhoaPhongBM> {
  final _yearController = TextEditingController();
  bool _isLoading = false; // Để hiển thị trạng thái đang tải
  bool _isDataVisible = false;
  bool _kiemduyet = true;
  int currentYear = DateTime.now().year;
  String maphieukpi = '';
  int sotrangthai = 0;
  String userPosition ='';
    TextEditingController reasonController = TextEditingController();

  Future<void> _handleThongQua() async {
    if (maphieukpi.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không có mã phiếu để thông qua.')),
      );
      return;
    }

    // Hiển thị hộp thoại xác nhận
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
        backgroundColor: Colors.grey[200],
          title: const Text('Xác nhận'),
          content: const Text('Bạn có chắc chắn muốn thông qua KPI này không?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop(false); // Trả về false khi chọn Hủy
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(true); // Trả về true khi chọn OK
              },
            ),
          ],
        );
      },
    );

    // Nếu người dùng chọn Hủy thì dừng lại
    if (confirm != true) {
      return;
    }

    try {
      final usuarioProvider =
          Provider.of<Usuario_provider1>(context, listen: false);

      // Lấy đối tượng Kpicanhan dựa trên mã phiếu
      Kpibenhvien? kpibenhvien =
          await usuarioProvider.getKpibenhvienByMaphieu(maphieukpi);

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
      kpibenhvien.nguoipheduyet = widget.displayName;
      kpibenhvien.ngaypheduyet = validDateTime(DateTime.now());
      kpibenhvien.trangthai = 1;

      // Gọi API để cập nhật trạng thái KPI cá nhân
      await usuarioProvider.updateKPIBenhVien(kpibenhvien);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thông qua biễu mẫu thành công!')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $error')),
      );
      print('Lỗi trong quá trình cập nhật KPI: $error');
    }
  }

  Future<void> _handleTuChoi() async {
    if (maphieukpi.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không có mã phiếu.')),
      );
      return;
    }
    // Bước 1: Hiển thị hộp thoại nhập lý do từ chối
    String? reason = await _showReasonDialog();

    // Nếu người dùng nhấn Hủy hoặc không nhập lý do thì dừng lại
    if (reason == null || reason.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lý do từ chối không được để trống.')),
      );
      return;
    }


   // Bước 2: Hiển thị hộp thoại xác nhận từ chối
    bool? confirm = await _showConfirmationDialog();
    if (confirm != true) {
      return;
    }

    try {
      // Lưu thông báo với lý do từ chối
      await saveThongbao(context, reason);



      final usuarioProvider =
          Provider.of<Usuario_provider1>(context, listen: false);

      // Lấy đối tượng Kpicanhan dựa trên mã phiếu
      Kpibenhvien? kpibenhvien =
          await usuarioProvider.getKpibenhvienByMaphieu(maphieukpi);

      if (kpibenhvien == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không tìm thấy biểu mẫu khoa phòng.')),
        );
        return;
      }

      // Hàm để đảm bảo ngày hợp lệ cho SQL Server
      DateTime validDateTime(DateTime date) {
        DateTime minDate = DateTime(1753, 1, 1);
        return date.isBefore(minDate) ? minDate : date;
      }

      // Cập nhật các trường cần thiết
      kpibenhvien.nguoipheduyet = widget.displayName;
      kpibenhvien.ngaypheduyet = validDateTime(DateTime.now());
      kpibenhvien.trangthai = 2;

      // Gọi API để cập nhật trạng thái KPI cá nhân
      await usuarioProvider.updateKPIBenhVien(kpibenhvien);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Từ chối biểu mẫu thành công!')),
      );
  
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $error')),
      );
      print('Lỗi trong quá trình cập nhật biểu mẫu: $error');
    }
  }
// Hàm hiển thị hộp thoại nhập lý do từ chối
  Future<String?> _showReasonDialog() async {
    reasonController.clear();

    return await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[200],
          title: const Text('Nhập lý do từ chối'),
          content: TextField(
            controller: reasonController,
            decoration: const InputDecoration(
              hintText: 'Nhập lý do...',
              border: OutlineInputBorder(),
             hintStyle: TextStyle(color: Colors.black),
            ),
            maxLines: 3,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop(null);
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                String input = reasonController.text.trim();
                Navigator.of(context).pop(input.isEmpty ? null : input);
              },
            ),
          ],
        );
      },
    );
  }

// Hàm hiển thị hộp thoại xác nhận từ chối
  Future<bool?> _showConfirmationDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[200],
          title: const Text('Xác nhận'),
          content:
              const Text('Bạn có chắc chắn muốn từ chối biểu mẫu này không?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

// Hàm lưu thông báo với lý do từ chối
  Future<void> saveThongbao(BuildContext context, String reason) async {
    print('Bắt đầu hàm saveThongbao');

    try {
      // Bước 1: Lấy mã nhân viên dựa trên quyền 'PKP'
      print('Đang lấy mã nhân viên với quyền PKP...');
      String resultParam =
          await Provider.of<Usuario_provider>(context, listen: false)
              .getMaNVByMaQuyen('PKP');
      print('Mã nhân viên lấy được: $resultParam');

      // Bước 2: Đảm bảo ngày hợp lệ cho SQL Server
      DateTime validDateTime(DateTime date) {
        DateTime minDate = DateTime(1753, 1, 1);
        return date.isBefore(minDate) ? minDate : date;
      }

      // Bước 3: Tạo thông báo mới
      print('Tạo thông báo với nội dung: $reason');
      final thongbao = ThongBao(
        maNhanVien: resultParam,
        tieuDe: 'Biểu mẫu khoa phòng bị từ chối',
        noiDung: reason,
        thoiGian: validDateTime(DateTime.now()),
        trangThai: false,
        maPhieu: maphieukpi,
      );

      // Bước 4: Gửi thông báo thông qua Provider
      print('Đang gửi thông báo...');
      await Provider.of<Usuario_provider3>(context, listen: false)
          .addThongbao(thongbao);
      print('Gửi thông báo thành công');

      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Thông báo đã được lưu thành công!')),
      // );
    } catch (e) {
      print('Lỗi khi thêm thông báo: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Thêm mới thông báo thất bại: $e')),
      );
    }

    print('Kết thúc hàm saveThongbao');
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

  // Hàm lấy chi tiết KPI cá nhân
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
                            title: "Lý do bị từ chối",
                            svgSrc: "assets/icons/menu_doc.svg",
                            press: () {
                              _showThongBaoDialog(context);
                            },
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
                                  builder: (context) => TrangChuBM(
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
                'Kiểm duyệt biểu mẫu KPI khoa phòng năm $currentYear',
                style: TextStyle(
                  fontSize: 21,
                  color: Colors.black,
                ),
                textAlign:
                    TextAlign.center, // Đảm bảo căn giữa nội dung văn bản
              ),
            ),

            const SizedBox(height: 20),
            // Khung chứa mã NV, năm và tên
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
                      labelStyle:
                          TextStyle(color: Colors.blue), // Thay đổi màu chữ
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Nút lấy KPI
                ElevatedButton(
                  onPressed: () async {
                    // Gọi hai hàm
                    await _fetchKPI(); // Gọi hàm lấy KPI
                    await _trangthai(); // Gọi hàm lấy trạng thái
                  },
                   style: ElevatedButton.styleFrom(
   foregroundColor: Colors.white,
                                  backgroundColor:
                                      const Color.fromARGB(255, 110, 187, 117),
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  child: const Text('Lấy Chi Tiết biểu mẫu'),
),
  const SizedBox(width: 10),
                // Nút lấy KPI               
              Visibility(
  visible: userPosition == 'TKP',
  child: ElevatedButton(
    onPressed: () async {
      final year = int.tryParse(_yearController.text);
      if (year != null) {
        maphieukpi = (await Provider.of<Usuario_provider1>(context, listen: false)
            .getMaphieuKpiBvByNam(year))!;
        if (maphieukpi != null) {
          await deletebieumauKPI(maphieukpi);
        }
      }
    },
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: const Color.fromARGB(255, 110, 187, 117),
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    child: const Text('Xóa biểu mẫu'),
  ),
),

              ],
            ),
            const SizedBox(height: 20),
            // Hiển thị dữ liệu KPI trong DataTable
            if (_isDataVisible)
              Expanded(
                child: Center(
                  child: Consumer<Usuario_provider1>(
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
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columnSpacing: 20.0,
                              columns: const [
                                // DataColumn(label: Text('Mã KPI')),
                                DataColumn(label: Text('Nội Dung KPI')),
                                DataColumn(label: Text('Tiêu chí')),
                                DataColumn(label: Text('Kế hoạch')),
                                DataColumn(label: Text('Trọng Số')),
                              ],
                              rows: Provider.of<Usuario_provider1>(context,
                                          listen: false)
                                      .chitiettieuchimuctieuBV
                                      .isEmpty
                                  ? []
                                  : Provider.of<Usuario_provider1>(context,
                                          listen: false)
                                      .chitiettieuchimuctieuBV
                                      .map(
                                      (kpiDetail) {
                                        maphieukpi =
                                            kpiDetail.maphieukpibenhvien;
                                        return DataRow(cells: [
                                          // DataCell(
                                          //   Text(
                                          //     kpiDetail.makpi.toString(),
                                          //     overflow: TextOverflow.ellipsis,
                                          //   ),
                                          // ),

                                          DataCell(
                                            Tooltip(
                                              message: kpiDetail
                                                  .noidungkpi, // Nội dung của tooltip
                                              child: Container(
                                                width: 450,
                                                child: Text(
                                                  kpiDetail.noidungkpi,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines:
                                                      1, // Giới hạn chỉ hiển thị 1 dòng
                                                  softWrap: true,
                                                ),
                                              ),
                                            ),
                                          ),

                                          DataCell(
                                            Tooltip(
                                              message: kpiDetail.phuongphapdo,
                                              child: Container(
                                                width: 250,
                                                child: Text(
                                                  kpiDetail.phuongphapdo ?? '',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
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
                        ),
                      );
                    },
                  ),
                ),
              ),
            const SizedBox(height: 20),
           
            if (_isDataVisible && sotrangthai == 0 && userPosition =='TKP')...[
            
              KiemDuyetButtons(
                onThongQua: () => _handleThongQua(), // Gọi hàm xử lý thông qua
                onTuChoi: _handleTuChoi, // Gọi hàm xử lý từ chối
              ),
            ],
            if (_isDataVisible && sotrangthai == 1)
              const Text('Biểu mẫu đã được phê duyệt.'),
            if (_isDataVisible && sotrangthai == 4)
              const Text('Biểu mẫu đã được đánh giá.'),
                       if (_isDataVisible && sotrangthai == 2 && userPosition == 'NV')
              const Text('Biểu mẫu bị từ chối.'),
            if (_isDataVisible &&
                sotrangthai == 2 &&
                (userPosition == 'TKP' || userPosition == 'PKP')) ...[
              const Text('Biểu mẫu bị từ chối.'),
              Align(
                alignment: Alignment.centerRight, // Đặt nút chỉnh sửa bên phải
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CapKpiKP(
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
  Future<String?> _fetchEmployeeQuyen() async {
    final gmail = widget.userEmail;
    var resultParam =
        await Provider.of<Usuario_provider>(context, listen: false)
            .GetMaNVByEmail(gmail);
    print("Fetching data for MaNV: ${resultParam}");
    final maNV = resultParam;
      var result = await Provider.of<Usuario_provider>(context, listen: false)
          .getEmployeeQuyenByMaNV(maNV);
userPosition = result;
      // Cập nhật userPosition dựa vào kết quả trả về
     print('Quyen$userPosition');
  }
  Future<void> deletebieumauKPI(String maphieukpi) async {
  final usuarioProvider = Provider.of<Usuario_provider1>(context, listen: false);

  // Hiển thị hộp thoại xác nhận
  bool? confirmDelete = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.grey[200],
        title: Text('Xác nhận'),
        content: Text('Bạn có chắc chắn muốn xóa KPI với mã phiếu $maphieukpi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // Hủy bỏ
            child: Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true), // Xác nhận xóa
            child: Text('OK'),
          ),
        ],
      );
    },
  );

  // Nếu người dùng chọn OK, tiến hành xóa
  if (confirmDelete == true) {
    try {
      print('Bắt đầu xóa chi tiết KPI với mã phiếu KPI: $maphieukpi');
       await usuarioProvider.deletecchitietKPIBenhVien(maphieukpi);
      
       await usuarioProvider.deleteKPIBenhVien(maphieukpi);
      print('Xóa thành công chi tiết KPI với mã phiếu KPI: $maphieukpi');
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Xóa biểu mẫu KPI thành công!'),
           backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('Lỗi khi xóa chi tiết KPI: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Xóa biểu mẫu KPI không thành công!'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  } else {
    print('Hủy bỏ thao tác xóa.');
  }
}

void _showThongBaoDialog(BuildContext context) {
  final thongBaoProvider = Provider.of<Usuario_provider3>(context, listen: false);
  print('Đã vào hàm _showThongBaoDialog');

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.grey[200],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.7,
        child: FutureBuilder<List<ThongBao>?>(
          future: thongBaoProvider.getThongBaoByMaPhieu(maphieukpi),
          builder: (context, snapshot) {
            print('Bắt đầu FutureBuilder');

            if (snapshot.connectionState == ConnectionState.waiting) {
              print('Đang tải dữ liệu...');
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              print('Lỗi khi lấy dữ liệu: ${snapshot.error}');
              return Center(
                child: Text('Lỗi: ${snapshot.error}', style: const TextStyle(color: Colors.red)),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              print('Không có dữ liệu thông báo');
              return const Center(
                child: Text('Không có thông báo', style: TextStyle(fontSize: 16, color: Colors.black)),
              );
            }

            final thongBaoList = snapshot.data!.take(5).toList();
            print('Số lượng thông báo lấy được: ${thongBaoList.length}');

            return ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: thongBaoList.length,
              itemBuilder: (context, index) {
                final thongBao = thongBaoList[index];
                print('Đang hiển thị thông báo: ${thongBao.tieuDe}');

                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(15),
                    leading: const Icon(Icons.notifications, color: Colors.blue),
                    title: Text(
                      thongBao.tieuDe ?? 'Không có tiêu đề',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        Text(
                          thongBao.noiDung ?? 'Không có nội dung',
                          style: const TextStyle(color: Colors.black54),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          thongBao.thoiGian != null
                              ? 'Ngày: ${DateFormat('dd/MM/yyyy').format(thongBao.thoiGian!)}'
                              : 'Ngày không xác định',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.check, color: Colors.green),
                      onPressed: () async {
                        print('Nhấn nút OK cho thông báo: ${thongBao.maThongBao}');

                        // Khi nhấn vào nút OK, cập nhật trạng thái của thông báo
                        await thongBaoProvider.updateThongBaoTrangThai(
                          thongBao.maThongBao!,
                          true, // Đặt trạng thái thành true
                        );
                        print('Đã cập nhật trạng thái thông báo');                       
                        // Cập nhật lại danh sách sau khi thay đổi
                        thongBaoProvider.notifyListeners();
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            print('Đóng hộp thoại');
            Navigator.pop(context);
          },
          child: const Text('Đóng', style: TextStyle(color: Colors.blue)),
        ),
      ],
    ),
  );
}
}
