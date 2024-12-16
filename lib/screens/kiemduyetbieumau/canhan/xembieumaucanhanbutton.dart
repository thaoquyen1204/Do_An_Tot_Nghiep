import 'package:flutter/material.dart';
import 'package:flutter_login_api/models/usuario.dart';

class NhanVienGrid extends StatelessWidget {
  final List<Usuario> nhanViens;
  final Map<String, String> statusMap;
  final bool isLoading;
  final TextEditingController yearController;

  const NhanVienGrid({
    Key? key,
    required this.nhanViens,
    required this.statusMap,
    required this.isLoading,
    required this.yearController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator()) // Hiển thị khi đang tải
        : nhanViens.isEmpty
            ? Center(child: Text('Danh sách nhân viên trống.'))
            : LayoutBuilder(
                builder: (context, constraints) {
                  // Tính toán số cột dựa trên độ rộng của màn hình
                  int crossAxisCount = constraints.maxWidth > 1200
                      ? 4
                      : constraints.maxWidth > 800
                          ? 3
                          : constraints.maxWidth > 600
                              ? 2
                              : 1; // Điều chỉnh số cột dựa trên kích thước màn hình

                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing:
                          10.0, // Khoảng cách giữa các ô theo chiều ngang
                      mainAxisSpacing:
                          10.0, // Khoảng cách giữa các ô theo chiều dọc
                      childAspectRatio:
                          0.8, // Tỉ lệ giữa chiều cao và chiều rộng của ô
                    ),
                    itemCount: nhanViens.length,
                    itemBuilder: (context, index) {
                      final nhanVien = nhanViens[index];
                      String currentStatus = statusMap[nhanVien.maNv] ??
                          'Chưa kiểm tra'; // Lấy trạng thái nếu có

                      return Card(
                        color: Colors.grey[200],
                        elevation: 4,
                        margin: EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Hiển thị trạng thái từ map
                              Text(
                                'Trạng thái: $currentStatus', // Hiển thị trạng thái KPI
                                style: TextStyle(
                                  color: currentStatus == 'Đã duyệt'
                                      ? Colors.green
                                      : currentStatus == 'Từ chối'
                                          ? Colors.red
                                          : Colors
                                              .orange, // Thay đổi màu sắc dựa trên trạng thái
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),

                              // Hiển thị hình ảnh nhân viên
                              CircleAvatar(
                                backgroundImage: nhanVien.hinhAnhNv != null &&
                                        nhanVien.hinhAnhNv!.isNotEmpty
                                    ? NetworkImage(nhanVien.hinhAnhNv!)
                                    : AssetImage(
                                            'assets/images/default_avatar.png')
                                        as ImageProvider,
                                radius: 40,
                              ),
                              SizedBox(height: 10),

                              // Hiển thị tên nhân viên
                              Text(
                                nhanVien.tenNv ?? 'Tên chưa cập nhật',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 5),

                              // Hiển thị chức danh
                              Text(nhanVien.maChucDanh ?? 'Chức danh chưa cập nhật'),

                              SizedBox(height: 10),

                              // Nút "Xem chi tiết"
                              ElevatedButton(
                                onPressed: () {
                                  final year = int.tryParse(
                                          yearController.text) ??
                                      DateTime.now().year; // Lấy năm từ TextField
                                  // Chuyển đến màn hình Chi tiết với mã nhân viên tương ứng
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => ChiTietCNBM(
                                  //         maNV: nhanVien.maNv,
                                  //         year: year), // Truyền mã NV
                                  //   ),
                                  // );
                                },
                                child: Text('Xem chi tiết'),
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
                        ),
                      );
                    },
                  );
                },
              );
  }
}
