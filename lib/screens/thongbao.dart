import 'package:flutter/material.dart';
import 'package:flutter_login_api/mausacvakichthuoc/constants1.dart';
import 'package:flutter_login_api/models/thongbao.dart';
import 'package:flutter_login_api/providers/usuario_provider.dart';
import 'package:flutter_login_api/providers/usuario_provider3.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ThongBaoScreen extends StatefulWidget {
  final String userEmail;
  final String displayName;
  final String? photoURL;

  const ThongBaoScreen({
    Key? key,
    required this.userEmail,
    required this.displayName,
    this.photoURL,
  }) : super(key: key);

  @override
  State<ThongBaoScreen> createState() => _ThongBaoScreenState();
}

class _ThongBaoScreenState extends State<ThongBaoScreen> {
  late Usuario_provider3 thongBaoProvider;
  String maNV = '';
  Future<List<ThongBao>?>? thongBaoFuture;

  @override
  void initState() {
    super.initState();
    thongBaoProvider = Provider.of<Usuario_provider3>(context, listen: false);
    _initializeData();
  }

  // Hàm lấy mã nhân viên và sau đó lấy thông báo
  Future<void> _initializeData() async {
    maNV = await _fetchEmployeeMaNV();
    if (maNV.isNotEmpty) {
      setState(() {
        thongBaoFuture = thongBaoProvider.getThongBaoByMaNV(maNV);
      });
    }
  }

  Future<String> _fetchEmployeeMaNV() async {
    final gmail = widget.userEmail;
    final resultParam = await Provider.of<Usuario_provider>(context, listen: false)
        .GetMaNVByEmail(gmail);
    print("Fetching MaNV: $resultParam");
    return resultParam ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách thông báo'),
        backgroundColor: Color.fromARGB(255, 110, 187, 117),
        titleTextStyle: const TextStyle(
    color: Colors.white, // Màu chữ
    fontSize: 20,        // Kích thước chữ
    fontWeight: FontWeight.bold, // Độ đậm chữ (tuỳ chọn)
  ),
      ),
      body: thongBaoFuture == null
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<List<ThongBao>?>(
              future: thongBaoFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Lỗi: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'Không có thông báo',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  );
                }

                final thongBaoList = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: thongBaoList.length,
                  itemBuilder: (context, index) {
                    final thongBao = thongBaoList[index];
                    return Card(
                      color: Colors.grey[200],
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
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
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
                        onTap: () => _showThongBaoDetail(context, thongBao),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  void _showThongBaoDetail(BuildContext context, ThongBao thongBao) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[200],
        title: Text(
          thongBao.tieuDe ?? 'Chi tiết thông báo',
          style: const TextStyle(color: Colors.black),
        ),
        content: Text(
          thongBao.noiDung ?? 'Không có nội dung',
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }
}
