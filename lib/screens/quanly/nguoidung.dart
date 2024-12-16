import 'package:flutter/material.dart';
import 'package:flutter_login_api/mausacvakichthuoc/constants1.dart';
import 'package:flutter_login_api/screens/kpi/danhmuckpi.dart';
import 'package:flutter_login_api/screens/main/components/side_menu.dart';
import 'package:flutter_login_api/screens/nguoidung/trangchuthongtincanhan.dart';
import 'package:flutter_login_api/screens/quanly/chinhsuanguoidung.dart';
import 'package:flutter_login_api/screens/quanly/themnguoidung.dart';
import 'package:flutter_login_api/screens/thongbao.dart';
import 'package:flutter_login_api/screens/trangchu/truongphong/truongphong.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_login_api/providers/usuario_provider.dart';
import 'package:flutter_login_api/models/usuario.dart';

class NguoiDung extends StatefulWidget {
     final String userEmail;
  final String displayName;
  final String? photoURL;
  const NguoiDung({ Key? key,
    required this.userEmail,
    required this.displayName,
    this.photoURL,}) : super(key: key);

  @override
  State<NguoiDung> createState() => _NguoiDungScreenState();
}

class _NguoiDungScreenState extends State<NguoiDung> {
  bool isExpanded = false;
  int _rowsPerPage = 5; // Số hàng trên mỗi trang
  int _currentPage = 0; // Trang hiện tại
  int selectedIndex = 0;

 @override
Widget build(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;
  final screenSize = MediaQuery.of(context).size;
  final usuarios = Provider.of<Usuario_provider>(context).usuarios;

  // Chia dữ liệu thành các trang nhỏ
  final paginatedData = usuarios.skip(_currentPage * _rowsPerPage).take(_rowsPerPage).toList();
  final totalPages = (usuarios.length / _rowsPerPage).ceil(); // Tổng số trang

  return Scaffold(
    backgroundColor: bgColor,
    drawer: screenSize.width < 600 ?  SideMenu( userEmail: widget.userEmail,
                    displayName: widget.displayName,
                    photoURL: widget.photoURL!,) : null, // Slide menu
    body: LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 600) {
          return Row(
            children: [
              // Menu bên trái
              Container(
                width: constraints.maxWidth * 0.2,
                color: bgColor1,
                child: Column(
                  children: [
                    DrawerHeader(
                      child: Image.asset(
                        "assets/images/Tiêu_đề_Website_BV_16_-removebg-preview.png",
                      ),
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
                            builder: (context) => Giaodien1(
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
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05,
                    vertical: screenHeight * 0.05,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // IconButton(
                            //   onPressed: () {
                            //     setState(() {
                            //       isExpanded = !isExpanded;
                            //     });
                            //   },
                            //   // icon: const Icon(Icons.menu),
                            // ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Thành viên",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: screenWidth * 0.03,
                                      color: Colors.pinkAccent,
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.01),
                                ],
                              ),
                            ),
                            // SizedBox(
                            //   width: screenWidth * 0.3,
                            //   child: TextField(
                            //     decoration: const InputDecoration(
                            //       hintText: "Type Article Title",
                            //       prefixIcon: Icon(Icons.search),
                            //       border: OutlineInputBorder(
                            //         borderSide: BorderSide(
                            //           color: Colors.black26,
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.05),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(16),
                          child: usuarios.isEmpty
                              ? const Center(child: CircularProgressIndicator())
                              : SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                    headingRowColor: MaterialStateProperty.resolveWith(
                                      (states) => Colors.grey.shade200,
                                    ),
                                    columns: const [
                                      DataColumn(label: Text("Mã số nhân viên")),
                                      DataColumn(label: Text("Tên nhân viên")),
                                      DataColumn(label: Text("Chức vụ")),
                                      DataColumn(label: Text("Sửa")),
                                      DataColumn(label: Text("Xóa")),
                                    ],
                                    rows: paginatedData.map((usuario) {
                                      return DataRow(cells: [
                                        DataCell(Text(usuario.maNv)),
                                        DataCell(Text(usuario.tenNv)),
                                        DataCell(Text(usuario.maChucDanh)),
                                        DataCell(
                                          const Icon(Icons.edit, color: Colors.black),
                                          onTap: () {
                                            _editUser(context, usuario, widget.userEmail, widget.displayName, widget.photoURL);
                                          },
                                        ),
                                        DataCell(
                                          const Icon(Icons.delete, color: Colors.black),
                                          onTap: () {
                                            _deleteUser(context, usuario);
                                          },
                                        ),
                                      ]);
                                    }).toList(),
                                  ),
                                ),
                        ),
                        SizedBox(height: screenHeight * 0.05),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: _currentPage > 0
                                  ? () {
                                      setState(() {
                                        _currentPage--;
                                      });
                                    }
                                  : null,
                            ),
                            Text("Page ${_currentPage + 1} of $totalPages"),
                            IconButton(
                              icon: const Icon(Icons.arrow_forward),
                              onPressed: _currentPage < totalPages - 1
                                  ? () {
                                      setState(() {
                                        _currentPage++;
                                      });
                                    }
                                  : null,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        } else {
           return Scaffold(
    appBar: AppBar(
      title: const Text(
    "Quản lý người dùng",
    style: TextStyle(color: Colors.black), // Thay đổi màu chữ ở đây
  ),
      backgroundColor: bgColor1,
    ),
      drawer: SideMenu( userEmail: widget.userEmail,
                    displayName: widget.displayName,
                    photoURL: widget.photoURL!,), 
    body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: screenHeight * 0.02),
          Text(
            "Danh sách nhân viên",
            style: TextStyle(
              fontSize: screenWidth * 0.06,
              color: Colors.pinkAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: screenHeight * 0.03),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: usuarios.isEmpty
                ? const Center(child: CircularProgressIndicator( color: Colors.black, ))
                : Column(
                    children: paginatedData.map((usuario) {
                      return Card(
                          color: Colors.grey[200],
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
  title: Text(
    usuario.tenNv,
    style: const TextStyle(
      color: Colors.black, // Đổi màu chữ của tiêu đề
      fontWeight: FontWeight.bold,
    ),
  ),
  subtitle: Text(
    "Chức vụ: ${usuario.maChucDanh}",
    style: TextStyle(
      color: Colors.grey[700], // Đổi màu chữ của phụ đề
    ),
  ),
  trailing: Wrap(
    spacing: 8,
    children: [
      IconButton(
        icon: const Icon(Icons.edit, color: Colors.black),
        onPressed: () {
          _editUser(context, usuario, widget.userEmail, widget.displayName, widget.photoURL);
        },
      ),
      IconButton(
        icon: const Icon(Icons.delete, color: Colors.black),
        onPressed: () {
          _deleteUser(context, usuario);
        },
      ),
    ],
  ),
),
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    ),
  );
}
      },
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        ThemUser(widget.userEmail, widget.displayName, widget.photoURL);
      },
      child: const Icon(Icons.add),
      backgroundColor: const Color.fromARGB(255, 71, 219, 44),
    ),
  );
}


  void ThemUser(String userEmail, String displayName, String? photoURL) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 208, 235, 202),
          contentPadding: EdgeInsets.zero,
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.8,
            child: AddUserScreen( userEmail: userEmail,
              displayName: displayName,
              photoURL: photoURL,), // AddUserScreen inside a dialog
          ),
        );
      },
    );
  }

  void _deleteUser(BuildContext context, Usuario usuario) {
    final usuarioProvider =
        Provider.of<Usuario_provider>(context, listen: false);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 208, 235, 202),
          title: const Text('Xóa nhân viên'),
          content:
              Text('Bạn có chắc chắn muốn xóa nhân viên ${usuario.tenNv}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại ngay lập tức

                usuarioProvider.deleteUsuario(usuario.maNv).then((_) {
                  _showConfirmationDialog(
                    context,
                    'Thành công',
                    'Xóa nhân viên ${usuario.tenNv} thành công!',
                  );
                  setState(() {
                    usuarioProvider.getUsuarios();
                  });
                }).catchError((error) {
                  _showConfirmationDialog(
                    context,
                    'Thất bại',
                    'Xóa nhân viên ${usuario.tenNv} thất bại: $error',
                  );
                });
              },
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );
  }

  void _showConfirmationDialog(
      BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
         backgroundColor: const Color.fromARGB(255, 208, 235, 202),
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _editUser(BuildContext context, Usuario usuario, String userEmail,
    String displayName, String? photoURL) {
    final usuarioProvider =
        Provider.of<Usuario_provider>(context, listen: false);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditUserDialog(
            usuario: usuario, usuarioProvider: usuarioProvider, userEmail: userEmail,
              displayName: displayName,
              photoURL: photoURL,);
      },
    );
  }
}

// void _addUser(BuildContext context, Usuario usuario) {

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AddUserScreen();
//       },
//     );
//   }
// }
