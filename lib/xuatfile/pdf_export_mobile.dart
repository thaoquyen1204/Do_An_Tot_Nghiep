import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> savePdf(BuildContext context, Uint8List pdfBytes) async {
  // Yêu cầu quyền lưu trữ (chỉ Android cần)
  if (Platform.isAndroid) {
    final status = await Permission.manageExternalStorage.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Quyền lưu trữ bị từ chối")),
      );
      return;
    }
  }

  try {
    // Lấy đường dẫn bộ nhớ
    final directory = Directory('/storage/emulated/0/Download');

    // Tạo tên tệp mới nếu tệp đã tồn tại
    String fileName = 'Danh sách kết quả đánh giá sinh viên.pdf';
    String filePath = '${directory.path}/$fileName';
    int counter = 1;

    // Kiểm tra nếu tệp đã tồn tại, thay đổi tên tệp
    while (await File(filePath).exists()) {
      fileName = 'Danh sách kết quả đánh giá sinh viên($counter).pdf';
      filePath = '${directory.path}/$fileName';
      counter++;
    }

    // Lưu file PDF
    final file = File(filePath);
    await file.writeAsBytes(pdfBytes);

    // Hiển thị SnackBar thông báo thành công
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("File PDF đã được lưu tại: $filePath")),
    );
  } catch (e) {
    // Hiển thị SnackBar thông báo lỗi
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Lỗi khi lưu file: $e")),
    );
  }
}
