import 'dart:typed_data'; // Để sử dụng kiểu Uint8List cho ảnh
import 'package:flutter/material.dart';
import 'package:flutter_login_api/mausacvakichthuoc/constants1.dart';
import 'package:flutter_login_api/models/usuario.dart';
import 'package:flutter_login_api/providers/usuario_provider.dart';
import 'package:flutter_login_api/screens/kpi/danhmuckpi.dart';
import 'package:flutter_login_api/screens/main/components/side_menu.dart';
import 'package:flutter_login_api/screens/nguoidung/anhienmatkhau.dart';
import 'package:flutter_login_api/screens/nguoidung/trangchuthongtincanhan.dart';
import 'package:flutter_login_api/screens/quanly/nguoidung.dart';
import 'package:flutter_login_api/screens/thongbao.dart';
import 'package:flutter_login_api/screens/trangchu/canhan/giaodien.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Firebase Storage
import 'package:flutter/foundation.dart'; // Để kiểm tra nếu đang chạy trên Web

class EditPage extends StatefulWidget {
  final String maNV; // Mã KPI cần chỉnh sửa
  final String userEmail;
  final String displayName;
  final String? photoURL;

  EditPage({
    Key? key,
    required this.userEmail,
    required this.maNV,
    required this.displayName,
    this.photoURL,
  });

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  // Khai báo các TextEditingController cho các TextFormField
  final TextEditingController _tenNvController = TextEditingController();
  final TextEditingController _sdtController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _tenTaiKhoanController = TextEditingController();
  final TextEditingController _matKhauController = TextEditingController();

  Uint8List? _image; // Dữ liệu ảnh cho Android/iOS/Web
  String hinhAnhNv = ''; // Đường dẫn hoặc URL hình ảnh
  final ImagePicker _picker =
      ImagePicker(); // ImagePicker để chọn ảnh từ thiết bị
  Uint8List? _existingImage;

  @override
  void dispose() {
    // Giải phóng bộ nhớ khi không dùng nữa
    _tenNvController.dispose();
    _sdtController.dispose();
    _emailController.dispose();
    _tenTaiKhoanController.dispose();
    _matKhauController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    if (kIsWeb) {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null) {
        setState(() {
          _image = result.files.first.bytes; // Dữ liệu ảnh cho Web
          hinhAnhNv = result.files.first.name; // Tên ảnh
        });
      } else {
        print('Không chọn được ảnh');
      }
    } else {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final imageBytes = await pickedFile.readAsBytes();
        setState(() {
          _image = imageBytes; // Dữ liệu ảnh cho Android/iOS
          hinhAnhNv = pickedFile.path; // Đường dẫn ảnh
        });
      } else {
        print('Không chọn được ảnh');
      }
    }
  }

  Future<void> _UpdateNguoiDung() async {
    // Kiểm tra số điện thoại
    if (_sdtController.text.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Số điện thoại phải có đủ 10 số.')),
      );
      return; // Dừng lại nếu không đủ số
    }

    // Kiểm tra địa chỉ email
    if (!_emailController.text.endsWith('@gmail.com')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email phải có định dạng @gmail.com.')),
      );
      return; // Dừng lại nếu email không đúng định dạng
    }
    // Hiển thị hộp thoại xác nhận
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[200],
          title: const Text('Xác nhận'),
          content:
              const Text('Bạn có chắc chắn muốn thay đổi thông tin này không?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop(false); // Trả về false khi chọn Hủy
              },
            ),
            TextButton(
              child: const Text('Có'),
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

    // Lấy `Usuario_provider` từ context
    final usuarioProvider =
        Provider.of<Usuario_provider>(context, listen: false);

    // Lấy thông tin nhân viên dựa trên mã nhân viên
    Usuario? nguoidung = await usuarioProvider.getNhanVienByMaNv(widget.maNV);

    // Nếu không tìm thấy nhân viên, ngừng lại
    if (nguoidung == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không tìm thấy nhân viên.')),
      );
      return;
    }

    // Cập nhật thông tin cho đối tượng `Usuario`
    nguoidung.tenNv = _tenNvController.text; // Lấy giá trị từ TextController
    // Chỉ cập nhật hình ảnh nếu có ảnh được chọn
    if (_image != null) {
      await uploadImageToFirebase(); // Tải ảnh lên Firebase
      nguoidung.hinhAnhNv = hinhAnhNv; // Cập nhật URL hình ảnh sau khi upload
    } else {
      nguoidung.hinhAnhNv = nguoidung.hinhAnhNv; // Giữ nguyên giá trị hiện tại
    } // URL hình ảnh sau khi upload
    nguoidung.sdt = _sdtController.text; // Cập nhật số điện thoại
    nguoidung.gmail = _emailController.text; // Cập nhật email
    nguoidung.tenTaiKhoan =
        _tenTaiKhoanController.text; // Cập nhật tên tài khoản
    nguoidung.matKhau = _matKhauController.text; // Cập nhật mật khẩu
    nguoidung.quyenTruyCap = true;
    nguoidung.maChucNang = 'CN';
    try {
      // Gửi yêu cầu cập nhật thông tin nhân viên
      await usuarioProvider.updateUsuario(nguoidung);

      // Hiển thị hộp thoại thành công
      _showSuccessDialog(
          context, widget.userEmail, widget.displayName, widget.photoURL);
    } catch (error) {
      // Xử lý lỗi nếu có
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cập nhật thất bại: $error')),
      );
    }
  }

  void _showSuccessDialog(BuildContext context, String userEmail,
      String displayName, String? photoURL) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 208, 235, 202),
          title: const Text('Thành công'),
          content: const Text('Cập nhật nhân viên thành công!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => XemTTNguoidung(
                            userEmail: userEmail,
                            displayName: displayName,
                            photoURL: photoURL,
                          )),
                ); // Chuyển hướng về trang NguoiDung sau khi nhấn OK
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> uploadImageToFirebase() async {
    if (_image != null) {
      final storageRef = FirebaseStorage.instance.ref().child(
          'user_images/${widget.maNV}.jpg'); // Tên ảnh dựa trên mã nhân viên

      try {
        final uploadTask = storageRef.putData(_image!);

        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          print('Tải lên: ${snapshot.bytesTransferred}/${snapshot.totalBytes}');
        });

        final snapshot = await uploadTask.whenComplete(() {});

        if (snapshot.state == TaskState.success) {
          final imageUrl = await storageRef.getDownloadURL();
          setState(() {
            hinhAnhNv = imageUrl; // Cập nhật URL hình ảnh
          });
          print('Ảnh đã được tải lên thành công: $imageUrl');
        } else {
          print('Tải ảnh lên không thành công.');
        }
      } catch (e) {
        print('Tải ảnh lên Firebase Storage thất bại: $e');
      }
    } else {
      print('Không có ảnh để tải lên.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: const Text("Chỉnh sửa thông tin cá nhân"),
        backgroundColor: Colors.green[400],
      ),
      drawer: _buildDrawer(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            width: 1100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8.0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: FutureBuilder<Usuario?>(
              future: Provider.of<Usuario_provider>(context, listen: false)
                  .getNhanVienByMaNv(
                      widget.maNV), // Gọi API lấy dữ liệu nhân viên
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text('Lỗi khi tải dữ liệu: ${snapshot.error}'));
                } else if (snapshot.data == null) {
                  return const Center(
                      child: Text('Không tìm thấy dữ liệu nhân viên.'));
                } else {
                  final nguoidung = snapshot.data!; // Lấy đối tượng nhân viên

                  // Cập nhật giá trị của các TextEditingController
                  _tenNvController.text = nguoidung.tenNv ?? '';
                  _sdtController.text = nguoidung.sdt ?? '';
                  _emailController.text = nguoidung.gmail ?? '';
                  _tenTaiKhoanController.text = nguoidung.tenTaiKhoan ?? '';
                  _matKhauController.text = nguoidung.matKhau ?? '';

                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Avatar và nút chọn ảnh
                          Center(
                            child: CircleAvatar(
                              backgroundImage: _image != null
                                  ? MemoryImage(_image!)
                                  : nguoidung.hinhAnhNv != null &&
                                          nguoidung.hinhAnhNv!.isNotEmpty
                                      ? NetworkImage(nguoidung.hinhAnhNv!)
                                      : const AssetImage(
                                              'assets/images/default_avatar.png')
                                          as ImageProvider,
                              radius: 60,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () async {
                              await _pickImage();
                              // if (_image != null) {
                              //   await uploadImageToFirebase(); // Tải lên Firebase nếu có ảnh
                              // }
                            },
                            child: const Text('Chọn ảnh từ thiết bị'),
                          ),

                          const SizedBox(height: 20),

                          _buildEditableInfoCard(
                              Icons.person, _tenNvController, 'Tên nhân viên'),
                          _buildEditableInfoCard(
                              Icons.phone, _sdtController, 'Số điện thoại'),
                          _buildEditableInfoCard(
                              Icons.email, _emailController, 'Email'),
                          _buildEditableInfoCard(Icons.account_circle,
                              _tenTaiKhoanController, 'Tên tài khoản'),

                          PasswordField(
                            controller: _matKhauController,
                            label: 'Mật khẩu',
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _UpdateNguoiDung();
        },
        backgroundColor: Colors.green[400],
        child: const Icon(Icons.save),
      ),
    );
  }

  Widget _buildEditableInfoCard(
      IconData icon, TextEditingController controller, String labelText) {
    return Container(
      width: 700,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        elevation: 6,
        color: Colors.grey[200],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, color: Colors.green[800]),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                    labelText: labelText,
                    labelStyle: TextStyle(color: Colors.green[800]),
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Container(
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
                  builder: (context) => Giaodien(
                    userEmail: widget.userEmail,
                    displayName: widget.displayName,
                    photoURL: widget.photoURL!,
                  ),
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
                    userEmail: widget.userEmail,
                    displayName: widget.displayName,
                    photoURL: widget.photoURL!,
                  ),
                ),
              );
            },
          ),
          DrawerListTile(
            title: "Thông báo",
            svgSrc: "assets/icons/menu_notification.svg",
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ThongBaoScreen(
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
                  builder: (context) => XemTTNguoidung(
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
    );
  }
}
