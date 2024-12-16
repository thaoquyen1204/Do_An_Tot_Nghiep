import 'dart:typed_data';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

void savePdf(BuildContext context, Uint8List pdfBytes) {
  try {
    // Tạo Blob và URL tải xuống
    final blob = html.Blob([pdfBytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..target = '_blank'
      ..download = 'Danh sách kết quả đánh giá sinh viên.pdf'
      ..click();
    html.Url.revokeObjectUrl(url);

    // Hiển thị thông báo tải thành công
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Tệp PDF đã tải xuống thành công!"),
        duration: Duration(seconds: 3),
      ),
    );
  } catch (e) {
    // Hiển thị thông báo lỗi
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Lỗi khi tải tệp PDF: $e"),
        duration: Duration(seconds: 3),
      ),
    );
  }
}
