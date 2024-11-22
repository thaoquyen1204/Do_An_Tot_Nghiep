import 'package:flutter/material.dart';
import 'package:flutter_login_api/mausacvakichthuoc/constants1.dart';

class CloudStorageInfoTP {
  final String? svgSrc, title, totalStorage;
  final int? numOfFiles, percentage;
  final Color? color;

  CloudStorageInfoTP({
    this.svgSrc,
    this.title,
    this.totalStorage,
    this.numOfFiles,
    this.percentage,
    this.color,
  });
}

List demoMyFilesTP = [
   CloudStorageInfoTP(
    title: "Cấp danh mục KPI khoa phòng",
    numOfFiles: 1328,
    svgSrc: "assets/icons/one_drive.svg",
    color: const Color(0xFFA4CDFF),
    totalStorage: "1GB",
    percentage: 10,
  ),
  CloudStorageInfoTP(
    title: "Kiểm duyệt biểu mẫu",
    numOfFiles: 1328,
    svgSrc: "assets/icons/google_drive.svg",
    color: const Color(0xFFFFA113),
    totalStorage: "2.9GB",
     percentage: 35,
  ),

   CloudStorageInfoTP(
    title: "Đánh giá KPI",
    numOfFiles: 1328,
    svgSrc: "assets/icons/Documents.svg",
    color: primaryColor,
    totalStorage: "1.9GB",
    percentage: 35,
  ),
  CloudStorageInfoTP(
    title: "Quản lý thông tin người dùng",
    numOfFiles: 5328,
    svgSrc: "assets/icons/drop_box.svg",
    color: const Color(0xFF007EE5),
    totalStorage: "7.3GB",
    percentage: 78,
  ),
];
