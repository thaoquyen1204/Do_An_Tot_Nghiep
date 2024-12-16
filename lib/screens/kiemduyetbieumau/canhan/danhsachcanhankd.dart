import 'package:flutter/material.dart';
import 'package:flutter_login_api/mausacvakichthuoc/constants1.dart';
import 'package:flutter_login_api/models/usuario.dart';
import 'package:flutter_login_api/providers/usuario_provider.dart';
import 'package:flutter_login_api/providers/usuario_provider1.dart';
import 'package:flutter_login_api/screens/kiemduyetbieumau/canhan/chitietcanhanbm.dart';
import 'package:flutter_login_api/screens/kiemduyetbieumau/canhan/trucquan.dart';
import 'package:flutter_login_api/screens/kiemduyetbieumau/trangchubm.dart';
import 'package:flutter_login_api/screens/kpi/danhmuckpi.dart';
import 'package:flutter_login_api/screens/main/components/side_menu.dart';
import 'package:flutter_login_api/screens/nguoidung/trangchuthongtincanhan.dart';
import 'package:flutter_login_api/screens/trangchu/canhan/giaodien.dart';
import 'package:flutter_login_api/screens/trangchu/truongphong/truongphong.dart';
import 'package:provider/provider.dart';

class NhanVienGridScreen extends StatefulWidget {
  final String userEmail;
  final String displayName;
  final String? photoURL;
  NhanVienGridScreen({
    required this.userEmail,
    required this.displayName,
    this.photoURL,
  }); // Thêm tham số cho năm

  @override
  _NhanVienGridScreenState createState() => _NhanVienGridScreenState();
}

class _NhanVienGridScreenState extends State<NhanVienGridScreen> {
  List<Usuario> nhanViens = [];
  bool isLoading = true; // Trạng thái tải dữ liệu
  final TextEditingController _yearController =
      TextEditingController(); // Controller cho TextField năm
  int currentYear = DateTime.now().year; // Lấy năm hiện tại
  bool _isLoading = false; // Trạng thái tải cho hàm _trangthai
  Map<String, String> statusMap = {}; // Lưu trạng thái KPI của từng nhân viên
  String userPosition = '';

  @override
  void initState() {
    super.initState();
    _fetchNhanViens();
    _fetchEmployeeQuyen();
    _yearController.text =
        currentYear.toString(); // Gán năm hiện tại vào TextField
  }

  Future<void> _fetchEmployeeQuyen() async {
    try {
      final gmail = widget.userEmail;
      final maNV = await Provider.of<Usuario_provider>(context, listen: false)
          .GetMaNVByEmail(gmail);

      final result = await Provider.of<Usuario_provider>(context, listen: false)
          .getEmployeeQuyenByMaNV(maNV);

      setState(() {
        userPosition = result;
      });
    } catch (e) {
      print('Lỗi khi lấy quyền: $e');
    }
  }

  Future<void> _fetchNhanViens() async {
    try {
      final usuarioProvider =
          Provider.of<Usuario_provider>(context, listen: false);
      await usuarioProvider.getNhanVien();
      setState(() {
        nhanViens = usuarioProvider.usuarios;
        isLoading = false; // Dừng trạng thái loading
      });
      await _trangthai();
    } catch (error) {
      setState(() {
        isLoading = false; // Dừng trạng thái loading trong trường hợp lỗi
      });
      print("Lỗi khi tải dữ liệu: $error");
    }
  }

  Future<void> _trangthai() async {
    final year = int.tryParse(_yearController.text);
    if (year != null) {
      setState(() {
        _isLoading = true;
      });
      try {
        for (var nhanVien in nhanViens) {
          int trangthai =
              await Provider.of<Usuario_provider1>(context, listen: false)
                  .KPICNTTByMaNVvaNam(nhanVien.maNv, year);
          String message;
          if (trangthai == 1) {
            message = 'Đã duyệt';
          } else if (trangthai == 2) {
            message = 'Từ chối';
          } else if (trangthai == 0) {
            message = 'Chưa phê duyệt';
          } else if (trangthai == 4) {
            message = 'Đã được đánh giá';
          } else {
            message = 'Trạng thái không xác định';
          }
          statusMap[nhanVien.maNv] = message;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cập nhật trạng thái thành công!')),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $error')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập năm hợp lệ!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      drawer: MediaQuery.of(context).size.width < 600
          ? SideMenu(
              userEmail: widget.userEmail,
              displayName: widget.displayName,
              photoURL: widget.photoURL!,
            )
          : null,
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
                        title: "Trang chủ",
                        svgSrc: "assets/icons/menu_dashboard.svg",
                        press: () {
                          // Kiểm tra vị trí người dùng và điều hướng đến trang tương ứng
                          if (userPosition == "TKP" || userPosition == "PKP") {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Giaodien1(
                                        userEmail: widget.userEmail,
                                        displayName: widget.displayName,
                                        photoURL: widget.photoURL!,
                                      )),
                            );
                          } else if (userPosition == "NV") {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Giaodien(
                                        userEmail: widget.userEmail,
                                        displayName: widget.displayName,
                                        photoURL: widget.photoURL!,
                                      )),
                            );
                          }
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
                                userEmail: widget.userEmail,
                                displayName: widget.displayName,
                                photoURL: widget.photoURL!,
                              ),
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
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Danh sách nhân viên',
                              style:
                                  TextStyle(fontSize: 21, color: Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Text(
                              'Năm: ',
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(width: 8),
                            Container(
                              width: 60,
                              child: TextField(
                                controller: _yearController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 8.0),
                                ),
                                onSubmitted: (value) {
                                  setState(() {
                                    currentYear =
                                        int.tryParse(value) ?? currentYear;
                                  });
                                },
                              ),
                            ),
                            SizedBox(width: 16),
                            ElevatedButton(
                              onPressed: _trangthai,
                              child: Text('Kiểm tra'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            Spacer(),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Trucquan(
                                      userEmail: widget.userEmail,
                                      displayName: widget.displayName,
                                      photoURL: widget.photoURL,
                                    ),
                                  ),
                                );
                              },
                              child: Text('Trực quan'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: isLoading
                              ? Center(child: CircularProgressIndicator())
                              : nhanViens.isEmpty
                                  ? Center(
                                      child: Text('Danh sách nhân viên trống.'))
                                  : LayoutBuilder(
                                      builder: (context, constraints) {
                                        int crossAxisCount =
                                            constraints.maxWidth > 1200
                                                ? 4
                                                : constraints.maxWidth > 800
                                                    ? 4
                                                    : constraints.maxWidth > 600
                                                        ? 2
                                                        : 1;

                                        return GridView.builder(
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: crossAxisCount,
                                            crossAxisSpacing: 10.0,
                                            mainAxisSpacing: 10.0,
                                            childAspectRatio: 0.8,
                                          ),
                                          itemCount: nhanViens.length,
                                          itemBuilder: (context, index) {
                                            final nhanVien = nhanViens[index];
                                            String currentStatus =
                                                statusMap[nhanVien.maNv] ??
                                                    'Chưa kiểm tra';

                                            return Card(
                                              color: Colors.grey[200],
                                              elevation: 4,
                                              margin: EdgeInsets.all(8.0),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Trạng thái: $currentStatus',
                                                      style: TextStyle(
                                                        color: currentStatus ==
                                                                'Đã duyệt'
                                                            ? Colors.green
                                                            : currentStatus ==
                                                                    'Đã được đánh giá'
                                                                ? Colors.purple
                                                                : currentStatus ==
                                                                        'Từ chối'
                                                                    ? Colors.red
                                                                    : Colors
                                                                        .orange,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(height: 5),
                                                    CircleAvatar(
                                                      backgroundImage: nhanVien
                                                                      .hinhAnhNv !=
                                                                  null &&
                                                              nhanVien
                                                                  .hinhAnhNv!
                                                                  .isNotEmpty
                                                          ? NetworkImage(
                                                              nhanVien
                                                                  .hinhAnhNv!)
                                                          : AssetImage(
                                                                  'assets/images/default_avatar.png')
                                                              as ImageProvider,
                                                      radius: 40,
                                                    ),
                                                    SizedBox(height: 10),
                                                    Text(
                                                      nhanVien.tenNv ??
                                                          'Tên chưa cập nhật',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    SizedBox(height: 5),
                                                    Text(nhanVien.maChucDanh ??
                                                        'Chức danh chưa cập nhật'),
                                                    SizedBox(height: 10),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        print(
                                                            'Giá trị displayName: ${widget.displayName}');
                                                        final year = int.tryParse(
                                                                _yearController
                                                                    .text) ??
                                                            DateTime.now().year;
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    ChiTietCNBM(
                                                              maNV:
                                                                  nhanVien.maNv,
                                                              year: year,
                                                              userEmail: widget
                                                                  .userEmail,
                                                              displayName: widget
                                                                  .displayName,
                                                              photoURL: widget
                                                                  .photoURL,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child:
                                                          Text('Xem chi tiết'),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Colors.green,
                                                        foregroundColor:
                                                            Colors.white,
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 32,
                                                                vertical: 16),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
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
                          child: Text(
                            'Danh sách nhân viên',
                            style: TextStyle(fontSize: 21, color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            'Năm: ',
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(width: 8),
                          Container(
                            width: 60,
                            child: TextField(
                              controller: _yearController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 8.0),
                              ),
                              onSubmitted: (value) {
                                setState(() {
                                  currentYear =
                                      int.tryParse(value) ?? currentYear;
                                });
                              },
                            ),
                          ),
                          SizedBox(width: 14),
                          // Dùng Flexible để nút "Kiểm tra" co dãn theo kích thước màn hình
                          Flexible(
                            child: ElevatedButton(
                              onPressed: _trangthai,
                              child: Text('Kiểm tra'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          // Dùng Spacer để đẩy nút "Trực quan" về cuối
                          SizedBox(width: 14),
                          // Dùng Flexible cho nút "Trực quan" để co dãn hợp lý trên các màn hình nhỏ
                          Flexible(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Trucquan(
                                      userEmail: widget.userEmail,
                                      displayName: widget.displayName,
                                      photoURL: widget.photoURL,
                                    ),
                                  ),
                                );
                              },
                              child: Text('Trực quan'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: isLoading
                            ? Center(child: CircularProgressIndicator())
                            : nhanViens.isEmpty
                                ? Center(
                                    child: Text('Danh sách nhân viên trống.'))
                                : LayoutBuilder(
                                    builder: (context, constraints) {
                                      int crossAxisCount =
                                          constraints.maxWidth > 1200
                                              ? 4
                                              : constraints.maxWidth > 800
                                                  ? 4
                                                  : constraints.maxWidth > 600
                                                      ? 2
                                                      : 1;

                                      return GridView.builder(
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: crossAxisCount,
                                          crossAxisSpacing: 10.0,
                                          mainAxisSpacing: 10.0,
                                          childAspectRatio: 0.8,
                                        ),
                                        itemCount: nhanViens.length,
                                        itemBuilder: (context, index) {
                                          final nhanVien = nhanViens[index];
                                          String currentStatus =
                                              statusMap[nhanVien.maNv] ??
                                                  'Chưa kiểm tra';

                                          return Card(
                                            color: Colors.grey[200],
                                            elevation: 4,
                                            margin: EdgeInsets.all(8.0),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Trạng thái: $currentStatus',
                                                    style: TextStyle(
                                                      color: currentStatus ==
                                                              'Đã duyệt'
                                                          ? Colors.green
                                                          : currentStatus ==
                                                                  'Đã được đánh giá'
                                                              ? Colors.purple
                                                              : currentStatus ==
                                                                      'Từ chối'
                                                                  ? Colors.red
                                                                  : Colors
                                                                      .orange,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(height: 5),
                                                  CircleAvatar(
                                                    backgroundImage: nhanVien
                                                                    .hinhAnhNv !=
                                                                null &&
                                                            nhanVien.hinhAnhNv!
                                                                .isNotEmpty
                                                        ? NetworkImage(
                                                            nhanVien.hinhAnhNv!)
                                                        : AssetImage(
                                                                'assets/images/default_avatar.png')
                                                            as ImageProvider,
                                                    radius: 40,
                                                  ),
                                                  SizedBox(height: 10),
                                                  Text(
                                                    nhanVien.tenNv ??
                                                        'Tên chưa cập nhật',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  SizedBox(height: 5),
                                                  Text(nhanVien.maChucDanh ??
                                                      'Chức danh chưa cập nhật'),
                                                  SizedBox(height: 10),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      final year = int.tryParse(
                                                              _yearController
                                                                  .text) ??
                                                          DateTime.now().year;
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              ChiTietCNBM(
                                                            maNV: nhanVien.maNv,
                                                            year: year,
                                                            userEmail: widget
                                                                .userEmail,
                                                            displayName: widget
                                                                .displayName,
                                                            photoURL:
                                                                widget.photoURL,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Text('Xem chi tiết'),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Colors.green,
                                                      foregroundColor:
                                                          Colors.white,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 32,
                                                          vertical: 16),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: IconButton(
                    icon: const Icon(Icons.menu, size: 32, color: Colors.black),
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
  }
}
