import 'dart:html' as html;
import 'package:csv/csv.dart';

import 'dart:html' as html;
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';

Future<void> exportCSV(BuildContext context, String fileName, List<List<dynamic>> rows) async {
  String csv = const ListToCsvConverter().convert(rows);

  // Thêm BOM vào đầu chuỗi CSV
  String csvWithBom = '\uFEFF' + csv;

  try {
    // Tạo Blob và tải xuống tệp
    final blob = html.Blob([csvWithBom], 'text/csv;charset=utf-8');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', fileName)
      ..click();
    html.Url.revokeObjectUrl(url);

    // Hiển thị SnackBar thông báo thành công
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Tệp CSV đã được tải xuống: $fileName")),
    );
  } catch (e) {
    // Hiển thị SnackBar thông báo lỗi
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Đã xảy ra lỗi khi tải tệp CSV: $e")),
    );
  }
}

