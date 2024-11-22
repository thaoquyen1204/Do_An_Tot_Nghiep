import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_api/models/modelchucdanh.dart';
import 'package:flutter_login_api/screens/quanly/nguoidung.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_login_api/providers/usuario_provider.dart';
import 'package:flutter_login_api/models/usuario.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data'; // Để xử lý dữ liệu hình ảnh
import 'package:file_picker/file_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EditUserDialog extends StatefulWidget {
  final Usuario usuario;
  final Usuario_provider usuarioProvider;
  final String userEmail;
  final String displayName;
  final String? photoURL;

  const EditUserDialog({
    Key? key,
    required this.userEmail,
    required this.displayName,
    this.photoURL,
    required this.usuario,
    required this.usuarioProvider,
  }) : super(key: key);

  @override
  _EditUserDialogState createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<EditUserDialog> {
  final _formKey = GlobalKey<FormState>();
  late String maNv;
  late String tenNv;
  late String maChucDanh;
  File? hinhAnhFile;
  Uint8List? _image;
  late String hinhAnhNv;
  late String sdt;
  late String gmail;
  late String tenTaiKhoan;
  late String matKhau;
  late String maPhongKhoa;
  late String maQuyen;
  late bool quyenTruyCap;
  final ImagePicker _picker = ImagePicker();
  bool _isObscured = true;
  late String selectedChucDanh;
  late List<ChucDanh> chucDanhList;

  final Map<String, String> maQuyenMap = {
    'Nhân viên': 'NV',
    'Trưởng khoa phòng': 'TKP',
  };

  @override
  void initState() {
    super.initState();
    // Khởi tạo giá trị từ user ban đầu
    maNv = widget.usuario.maNv;
    tenNv = widget.usuario.tenNv;
    maChucDanh = widget.usuario.maChucDanh;
    hinhAnhNv = widget.usuario.hinhAnhNv;
    sdt = widget.usuario.sdt;
    gmail = widget.usuario.gmail;
    tenTaiKhoan = widget.usuario.tenTaiKhoan;
    matKhau = widget.usuario.matKhau;
    maPhongKhoa = widget.usuario.maPhongKhoa;
    maQuyen = widget.usuario.maQuyen!;
    quyenTruyCap = widget.usuario.quyenTruyCap!;
    selectedChucDanh = widget.usuario.maChucDanh;
    chucDanhList = widget.usuarioProvider.chucdanh;
  }

  Future<void> _pickImage() async {
    if (kIsWeb) {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null) {
        setState(() {
          _image = result.files.first.bytes; // Dữ liệu hình ảnh cho Web
          hinhAnhNv = result.files.first.name; // Cập nhật tên hình ảnh
        });
      } else {
        print('Không chọn được ảnh');
      }
    } else {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final imageBytes = await pickedFile.readAsBytes();
        setState(() {
          _image = imageBytes; // Dữ liệu hình ảnh cho Android/iOS
          hinhAnhNv = pickedFile.path; // Đường dẫn hình ảnh
        });
      } else {
        print('Không chọn được ảnh');
      }
    }
  }

  Future<void> uploadImageToFirebase() async {
    if (_image != null) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_images/${maNv}.jpg'); // Thay đổi tên hình ảnh nếu cần

      try {
        // Hiển thị thông báo tiến trình tải lên
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
    return AlertDialog(
      backgroundColor: Color.fromARGB(255, 208, 235, 202),
      title: Text('Chỉnh sửa nhân viên'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: maNv,
                decoration: InputDecoration(
                  labelText: 'Mã số nhân viên',
                  labelStyle: TextStyle(color: Colors.black),
                ),
                onChanged: (value) => maNv = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mã số nhân viên';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: tenNv,
                decoration: InputDecoration(
                  labelText: 'Tên nhân viên',
                  labelStyle: TextStyle(color: Colors.black),
                ),
                onChanged: (value) => tenNv = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên nhân viên';
                  }
                  return null;
                },
              ),
              // TextFormField(
              //   initialValue: maChucDanh,
              //   decoration: InputDecoration(labelText: 'Chức vụ'),
              //   onChanged: (value) => maChucDanh = value,
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Vui lòng nhập chức vụ';
              //     }
              //     return null;
              //   },
              // ),
              TextFormField(
                initialValue: hinhAnhNv,
                decoration: InputDecoration(
                  labelText: 'Đường dẫn hình ảnh (nếu có)',
                  labelStyle: TextStyle(color: Colors.black),
                ),
                onChanged: (value) {
                  hinhAnhNv = value;
                  setState(() {
                    _image =
                        null; // Xóa hình ảnh đã chọn nếu người dùng nhập đường dẫn
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    if (_image == null) {
                      return 'Vui lòng nhập hoặc chọn hình ảnh';
                    }
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await _pickImage();
                      if (_image != null) {
                        await uploadImageToFirebase();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor:
                          Color.fromARGB(255, 132, 227, 134), // Màu chữ
                      elevation: 5, // Đổ bóng cho nút
                      shadowColor:
                          Colors.grey.withOpacity(0.5), // Màu của đổ bóng
                      padding: EdgeInsets.symmetric(
                        horizontal:
                            20, // Khoảng cách từ chữ tới mép nút (ngang)
                        vertical: 15, // Khoảng cách từ chữ tới mép nút (dọc)
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(30), // Bo góc cho nút
                      ),
                    ),
                    child: Text(
                      'Chọn hình ảnh từ thiết bị',
                      style: TextStyle(
                        fontSize: 16, // Kích thước chữ
                      ),
                    ),
                  ),

                  SizedBox(width: 10),
                  // Hiển thị hình ảnh đã chọn nếu có
                  if (_image != null)
                    Image.memory(
                      _image!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    )
                  else if (hinhAnhNv.isNotEmpty)
                    Image.network(
                      hinhAnhNv,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        print('Lỗi tải ảnh: $error');
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.error, color: Colors.red),
                              Text('Không tải được ảnh'),
                            ],
                          ),
                        );
                      },
                    )
                  else
                    Text('Chưa có hình ảnh'),
                ],
              ),

              TextFormField(
                initialValue: sdt,
                decoration: InputDecoration(
                  labelText: 'Số điện thoại',
                  labelStyle: TextStyle(color: Colors.black),
                ),
                onChanged: (value) => sdt = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập số điện thoại';
                  } else if (value.length != 10 ||
                      !RegExp(r'^\d+$').hasMatch(value)) {
                    // Kiểm tra số điện thoại có đúng 10 số và chỉ chứa các chữ số
                    return 'Số điện thoại phải gồm 10 chữ số';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: gmail,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.black),
                ),
                onChanged: (value) => gmail = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập email';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value)) {
                    // Biểu thức chính quy đơn giản để kiểm tra định dạng email
                    return 'Vui lòng nhập địa chỉ email hợp lệ';
                  }
                  return null;
                },
              ),

              TextFormField(
                initialValue: tenTaiKhoan,
                decoration: InputDecoration(
                  labelText: 'Tên tài khoản',
                  labelStyle: TextStyle(color: Colors.black),
                ),
                onChanged: (value) => tenTaiKhoan = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên tài khoản';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: matKhau,
                decoration: InputDecoration(
                  labelText: 'Mật khẩu',
                  labelStyle: TextStyle(color: Colors.black),
                  suffixIcon: IconButton(
                    icon: Icon(
                      color: Colors.black,
                      _isObscured ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscured =
                            !_isObscured; // Thay đổi trạng thái che mật khẩu
                      });
                    },
                  ),
                ),
                obscureText: _isObscured,
                onChanged: (value) => matKhau = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mật khẩu';
                  }
                  return null;
                },
              ),
              // DropdownButtonFormField để chọn quyền
              DropdownButtonFormField<String>(
                value: maQuyenMap.keys.firstWhere(
                    (key) => maQuyenMap[key] == maQuyen,
                    orElse: () => maQuyenMap.keys.first),
                decoration: InputDecoration(
                  labelText: 'Mã quyền',
                  labelStyle: TextStyle(color: Colors.black),
                  //border: OutlineInputBorder(),
                ),
                items: maQuyenMap.keys.map((role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    maQuyen = maQuyenMap[newValue!]!;
                  });
                },
              ),
              DropdownButtonFormField<String>(
                value: selectedChucDanh.isNotEmpty ? selectedChucDanh : null,
                isExpanded: true, 
                decoration: const InputDecoration(
                  labelText: 'Chức danh',
                  labelStyle: TextStyle(color: Colors.black),
                ),
                items: chucDanhList.map((chucDanh) {
                  return DropdownMenuItem<String>(
                    value: chucDanh.maChucDanh,
                    child: Text(chucDanh.tenChucDanh),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedChucDanh = value;
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng chọn chức danh';
                  }
                  return null;
                },
              ),
              CheckboxListTile(
                title: Text(
                  'Quyền truy cập',
                  style: TextStyle(color: Colors.black),
                ), // Tiêu đề cho Checkbox
                value: quyenTruyCap, // Giá trị hiện tại của checkbox
                onChanged: (bool? value) {
                  setState(() {
                    quyenTruyCap = value ?? false; // Cập nhật giá trị mới
                  });
                },
                fillColor: MaterialStateProperty.all(Colors.white),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog without saving
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
            'Hủy',
            style: TextStyle(
              fontSize: 16, // Cỡ chữ
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              final updatedUsuario = Usuario(
                maNv: maNv,
                tenNv: tenNv,
                maChucDanh: selectedChucDanh,
                hinhAnhNv: hinhAnhNv,
                sdt: sdt,
                gmail: gmail,
                tenTaiKhoan: tenTaiKhoan,
                matKhau: matKhau,
                maPhongKhoa: maPhongKhoa,
                maQuyen: maQuyen,
                quyenTruyCap: quyenTruyCap,
              );
              widget.usuarioProvider.updateUsuario(updatedUsuario).then((_) {
                _showSuccessDialog(
                  context,
                  widget.userEmail,
                  widget.displayName,
                  widget.photoURL,
                );
              }).catchError((error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Cập nhật thất bại')),
                );
              });
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
        backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Nền trắng
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Bo góc hộp thoại
        ),
        title: Center(
          child: Text(
            'Thành công',
            style: TextStyle(
              color: Colors.green[700], // Màu chữ xanh đậm
              fontSize: 20, // Kích thước chữ tiêu đề
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green[700], // Màu biểu tượng thành công
              size: 60, // Kích thước biểu tượng
            ),
            const SizedBox(height: 20),
            Text(
              'Cập nhật nhân viên thành công!',
              style: const TextStyle(
                color: Colors.black, // Màu chữ
                fontSize: 16, // Kích thước chữ nội dung
              ),
              textAlign: TextAlign.center, // Canh giữa nội dung
            ),
          ],
        ),
        actions: <Widget>[
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NguoiDung(
                            userEmail: userEmail,
                            displayName: displayName,
                            photoURL: photoURL,
                          )),
                  (Route<dynamic> route) =>
                      false, // Xóa tất cả các màn hình trước đó
                ); // Chuyển hướng về trang NguoiDung sau khi nhấn OK
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.green[700], // Màu nền của nút
                padding: const EdgeInsets.symmetric(
                  horizontal: 30, // Đệm ngang
                  vertical: 15, // Đệm dọc
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Bo góc nút
                ),
              ),
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Colors.white, // Màu chữ của nút
                  fontSize: 16, // Kích thước chữ của nút
                ),
              ),
            ),
          ),
          const SizedBox(height: 10), // Tạo khoảng trống giữa các thành phần
        ],
      );
    },
  );
}
