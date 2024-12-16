import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';

Future<void> exportCSV(
    BuildContext context, String fileName, List<List<dynamic>> rows) async {
  String csv = const ListToCsvConverter().convert(rows);

  // Thêm BOM vào đầu chuỗi CSV
  String csvWithBom = '\uFEFF' + csv;

  try {
    // Lấy đường dẫn bộ nhớ
    Directory directory = Directory('/storage/emulated/0/Download');

    // Kiểm tra nếu directory tồn tại
    if (!await directory.exists()) {
      throw Exception("Không thể lấy đường dẫn bộ nhớ");
    }

    // Tạo tên tệp mới nếu tệp đã tồn tại
    String filePath = '${directory.path}/$fileName';
    int counter = 1;

    while (await File(filePath).exists()) {
      fileName = '${fileName.replaceAll('.csv', '')}($counter).csv'; // Tạo tên mới cho file
      filePath = '${directory.path}/$fileName';
      counter++;
    }

    // Lưu file CSV
    File file = File(filePath);
    await file.writeAsString(csvWithBom, encoding: utf8);

    // Hiển thị thông báo thành công
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("File CSV đã lưu tại: $filePath")),
    );
  } catch (e) {
    // Hiển thị thông báo lỗi
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Lỗi khi lưu file CSV: $e")),
    );
  }
}
