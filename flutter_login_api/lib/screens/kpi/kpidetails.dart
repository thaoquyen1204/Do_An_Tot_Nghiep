import 'package:flutter/material.dart';
import 'package:flutter_login_api/models/kpiphongcntt.dart';

class KpiDetailsScreen extends StatelessWidget {
  final Kpiphongcntt usuario;

  KpiDetailsScreen(this.usuario);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết KPI', style: TextStyle(fontSize: 20)),
        backgroundColor: Color.fromARGB(255, 110, 187, 117),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildDetailCard(
              context,
              title: 'Nội dung',
              content: usuario.noidung,
              color: Colors.white,
            ),
            _buildDetailCard(
              context,
              title: 'Đơn vị tính',
              content: usuario.donvitinh ?? 'N/A',
               color: Colors.white,
            ),
            _buildDetailCard(
              context,
              title: 'Phương pháp đo',
              content: usuario.phuongphapdo ?? 'N/A',
               color: Colors.white,
            ),
            _buildDetailCard(
              context,
              title: 'Công việc cá nhân',
              content: usuario.congvieccanhan != null ? usuario.congvieccanhan.toString() : 'N/A',
               color: Colors.white,
            ),
            _buildDetailCard(
              context,
              title: 'Chỉ tiêu',
              content: usuario.chitieu ?? 'N/A',
               color: Colors.white,
            ),
          
            // Add more details here as needed
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(BuildContext context, {required String title, required String content, required Color color}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0), // Bo tròn góc thẻ
      ),
      elevation: 5, // Tạo bóng cho thẻ
      shadowColor: Colors.grey.withOpacity(0.5), // Màu bóng
      color: color, // Màu nền thẻ
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListTile(
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18, // Tăng kích thước tiêu đề
              color: Colors.black87, // Màu chữ tiêu đề
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              content,
              style: TextStyle(
                fontSize: 16, // Tăng kích thước nội dung
                color: Colors.black54, // Màu chữ nội dung
              ),
            ),
          ),
        ),
      ),
    );
  }
}
