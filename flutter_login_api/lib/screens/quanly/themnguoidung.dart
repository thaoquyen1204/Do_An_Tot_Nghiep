import 'package:flutter/material.dart';
import 'package:flutter_login_api/screens/quanly/nguoidung.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:flutter_login_api/models/usuario.dart';
import 'package:provider/provider.dart';
import 'package:flutter_login_api/providers/usuario_provider.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddUserScreen extends StatefulWidget {
  final String userEmail;
  final String displayName;
  final String? photoURL;
  const AddUserScreen({
    Key? key,
    required this.userEmail,
    required this.displayName,
    this.photoURL,
  }) : super(key: key);

  @override
  _AddUserScreenState createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final TextEditingController maNvController = TextEditingController();
  final TextEditingController tenNvController = TextEditingController();
  final TextEditingController hinhAnhNvController = TextEditingController();
  final TextEditingController sdtController = TextEditingController();
  final TextEditingController gmailController = TextEditingController();
  final TextEditingController tenTaiKhoanController = TextEditingController();
  final TextEditingController matKhauController = TextEditingController();
  final TextEditingController maPhongKhoaController =
      TextEditingController(text: "Công nghệ thông tin");
  final TextEditingController maChucNangController =
      TextEditingController(text: "QLND");

  String? selectedChucDanh;
  String? selectedQuyen;
  bool _isObscured = true;
  Uint8List? _image;
  final _formKey = GlobalKey<FormState>(); // Key cho Form

  final FocusNode _sdtFocusNode = FocusNode();
  final FocusNode _gmailFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    _sdtFocusNode.addListener(() {
      if (!_sdtFocusNode.hasFocus) {
        _validatePhoneNumber();
      }
    });
    _gmailFocusNode.addListener(() {
      if (!_gmailFocusNode.hasFocus) {
        _validateEmail();
      }
    });
  }

  @override
  void dispose() {
    _sdtFocusNode.dispose();
    _gmailFocusNode.dispose();
    super.dispose();
  }

  // Hàm kiểm tra số điện thoại
  void _validatePhoneNumber() {
    final value = sdtController.text;
    if (value.isEmpty) {
      _showAlertDialog(context, 'Lỗi', 'Vui lòng nhập số điện thoại', () {
        // Đóng AlertDialog, giữ nguyên màn hình hiện tại
        // Navigator.of(context).pop();
      });
    } else if (value.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(value)) {
      _showAlertDialog(context, 'Lỗi', 'Số điện thoại phải có 10 số', () {
        // Đóng AlertDialog, giữ nguyên màn hình hiện tại
        // Navigator.of(context).pop();
      });
    }
  }

  // Hàm kiểm tra email
  void _validateEmail() {
    final value = gmailController.text;
    if (value.isEmpty) {
      _showAlertDialog(context, 'Lỗi', 'Vui lòng nhập địa chỉ email', () {
        // Đóng AlertDialog, giữ nguyên màn hình hiện tại
        //Navigator.of(context).pop();
      });
    } else if (!EmailValidator.validate(value)) {
      _showAlertDialog(context, 'Lỗi', 'Địa chỉ email không hợp lệ', () {
        // Đóng AlertDialog, giữ nguyên màn hình hiện tại
        //Navigator.of(context).pop();
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  final Map<String, String> maQuyenMap = {
    'Nhân viên': 'NV',
    'Trưởng khoa phòng': 'TKP',
  };

  Future<void> uploadImageToFirebase() async {
    if (_image != null) {
      final storageRef = FirebaseStorage.instance.ref().child(
          'user_images/${maNvController.text}.jpg'); // Đặt tên file theo mã nhân viên
      try {
        // Tải ảnh lên Firebase Storage
        final uploadTask = storageRef.putData(
          _image!,
          SettableMetadata(contentType: 'image/jpeg'), // Xác định loại MIME
        );

        // Đợi quá trình tải lên hoàn thành
        final snapshot = await uploadTask.whenComplete(() => {});

        // Kiểm tra xem quá trình tải lên có thành công không
        if (snapshot.state == TaskState.success) {
          // Lấy URL của ảnh sau khi tải lên thành công
          final imageUrl = await storageRef.getDownloadURL();
          setState(() {
            hinhAnhNvController.text =
                imageUrl; // Lưu URL ảnh vào TextField hoặc sử dụng ở nơi khác
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

  Future<void> pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);

    if (_file != null) {
      final imageBytes = await _file.readAsBytes();
      setState(() {
        _image = imageBytes;
        //hinhAnhNvController.text = _file.path;
      });
    } else {
      print('Không upload được ảnh');
    }
  }

  void selectImage() async {
    await pickImage(ImageSource.gallery);
    setState(() {});
  }

  bool quyenTruyCap = false;

  // Hàm để hiển thị AlertDialog
  void _showAlertDialog(BuildContext context, String title, String content,
      VoidCallback onOkPressed) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                onOkPressed(); // Gọi hàm callback khi nhấn OK
                Navigator.of(context).pop(); // Đóng AlertDialog
              },
            ),
          ],
        );
      },
    );
  }

  // Hàm mở AlertDialog để thêm mới nhân viên
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color.fromARGB(255, 208, 235, 202),
      title: const Center(
        child: Text(
          'Thêm Mới Nhân Viên',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          
          children: [
            TextFormField(
              controller: maNvController,
              decoration: const InputDecoration(
                labelText: 'Mã số nhân viên',
                labelStyle:
                    TextStyle(color: Colors.black), // Change label color
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.black), // Change border color
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.black), // Change focused border color
                ),
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.black), // Set the input text color
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: tenNvController,
              decoration: const InputDecoration(
                labelStyle: TextStyle(color: Colors.black),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.black), // Change border color
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.black), // Change focused border color
                ),
                labelText: 'Tên nhân viên',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: hinhAnhNvController,
              decoration: const InputDecoration(
                labelStyle: TextStyle(color: Colors.black),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.black), // Change border color
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.black), // Change focused border color
                ),
                labelText: 'Đường dẫn hình ảnh',
                border: OutlineInputBorder(),
              ),
              readOnly: true,
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_image != null)
                    Image.memory(
                      _image!,
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    )
                  else
                    Container(
                      height: 50,
                      width: 50,
                      color: Colors.grey[300],
                      child: Icon(Icons.image, size: 50),
                    ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: selectImage,
                    style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: Color.fromARGB(255, 110, 187, 117),
            shadowColor: Colors.greenAccent,
            elevation: 5,
          ),
          child: Text(
            'Chọn hình ảnh từ thư viện',
            style: TextStyle(
              fontSize: 16, // Cỡ chữ
              // Đậm chữ
            ),
          ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: tenTaiKhoanController,
              decoration: const InputDecoration(
                labelStyle: TextStyle(color: Colors.black),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.black), // Change border color
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.black), // Change focused border color
                ),
                labelText: 'Tên tài khoản nhân viên',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: sdtController,
              focusNode: _sdtFocusNode,
              decoration: const InputDecoration(
                labelStyle: TextStyle(color: Colors.black),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.black), // Change border color
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.black), // Change focused border color
                ),
                labelText: 'Số điện thoại nhân viên',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: matKhauController,
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.black),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.black), // Change border color
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.black), // Change focused border color
                ),
                labelText: 'Mật khẩu',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    // Toggle between eye and eye-off icon
                    _isObscured ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    // Toggle the obscureText state
                    setState(() {
                      _isObscured = !_isObscured;
                    });
                  },
                ),
              ),
              obscureText: _isObscured, // If true, it shows dots
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: gmailController,
              focusNode: _gmailFocusNode,
              decoration: const InputDecoration(
                labelStyle: TextStyle(color: Colors.black),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.black), // Change border color
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.black), // Change focused border color
                ),
                labelText: 'Gmail nhân viên',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedQuyen,
              decoration: const InputDecoration(
                labelStyle: TextStyle(color: Colors.black),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.black), // Change border color
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.black), // Change focused border color
                ),
                labelText: 'Mã quyền',
                border: OutlineInputBorder(),
              ),
              items: maQuyenMap.keys.map((role) {
                return DropdownMenuItem<String>(
                  value: role,
                  child: Text(role),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedQuyen = newValue;
                });
              },
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedChucDanh,
              isExpanded: true, 
              decoration: const InputDecoration(
                labelStyle: TextStyle(color: Colors.black),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.black), // Change border color
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.black), // Change focused border color
                ),
                labelText: 'Chức danh',
                border: OutlineInputBorder(),
              ),
              items: Provider.of<Usuario_provider>(context)
                  .chucdanh
                  .map((chucDanh) {
                return DropdownMenuItem<String>(
                  value: chucDanh.maChucDanh,
                  child: Text(chucDanh.tenChucDanh),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedChucDanh = value;
                });
              },
            ),
            SizedBox(height: 10),
            CheckboxListTile(
              title: Text(
                'Quyền truy cập',
                style: TextStyle(color: Colors.black),
              ),
              value: quyenTruyCap,
              onChanged: (bool? value) {
                setState(() {
                  quyenTruyCap = value!;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
              fillColor: MaterialStateProperty.all(Colors.white),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: Color.fromARGB(255, 110, 187, 117),
            shadowColor: Colors.greenAccent,
            elevation: 5,
          ),
          child: Text(
            'Hủy',
            style: TextStyle(
              fontSize: 16, // Cỡ chữ
              // Đậm chữ
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          onPressed: () async {
            try {
              // Tải ảnh lên Firebase
              await uploadImageToFirebase();
              // Sau khi tải ảnh thành công và URL đã được cập nhật vào hinhAnhNvController
              final selectedQuyenShortCode = maQuyenMap[selectedQuyen] ?? '';
              final newUsuario = Usuario(
                maNv: maNvController.text,
                tenNv: tenNvController.text,
                sdt: sdtController.text,
                gmail: gmailController.text,
                hinhAnhNv: hinhAnhNvController.text, // URL ảnh từ Firebase
                tenTaiKhoan: tenTaiKhoanController.text,
                matKhau: matKhauController.text,
                maPhongKhoa: "CNTT",
                maChucDanh: selectedChucDanh ?? '',
                maQuyen: selectedQuyenShortCode,
                quyenTruyCap: quyenTruyCap,
              );

              // Lưu thông tin vào Firestore
              await Provider.of<Usuario_provider>(context, listen: false)
                  .addUsuario(newUsuario);
              //           Navigator.of(context).pop();
              //           _showSnackBar('Thêm mới nhân viên thành công!');
              //           Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(builder: (context) => const NguoiDung()), // Assuming NguoiDung screen exists
              // );
              _showSuccessDialog(
                context,
                widget.userEmail,
                widget.displayName,
                widget.photoURL,
              );
            } catch (e) {
              Navigator.of(context).pop();
              _showSnackBar('Thêm mới thất bại: $e');
            }
          },
        style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: Color.fromARGB(255, 110, 187, 117),
            shadowColor: Colors.greenAccent,
            elevation: 5,
          ),
          child: Text(
            'Lưu',
            style: TextStyle(
              fontSize: 16, // Cỡ chữ
              // Đậm chữ
            ),
          ),
        ),
      ],
    );
  }
}

void _showSuccessDialog(BuildContext context, String userEmail,
    String displayName, String? photoURL) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Color.fromARGB(255, 208, 235, 202),
        title: Text('Thành công'),
        content: Text('Thêm nhân viên thành công!'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Đóng dialog
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => NguoiDung(
                          userEmail: userEmail,
                          displayName: displayName,
                          photoURL: photoURL,
                        )),
              ); // Chuyển hướng về trang NguoiDung sau khi nhấn OK
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}
