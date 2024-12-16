import 'package:flutter/material.dart';
import 'package:flutter_login_api/mausacvakichthuoc/constants1.dart';

class CloudStorageInfo {
  final String? svgSrc, title, totalStorage;
  final int? numOfFiles, percentage;
  final Color? color;

  CloudStorageInfo({
    this.svgSrc,
    this.title,
    this.totalStorage,
    this.numOfFiles,
    this.percentage,
    this.color,
  });
}

List demoMyFiles = [
    CloudStorageInfo(
    title: "Cấp KPI cá nhân",
    numOfFiles: 1328,
    svgSrc: "assets/icons/one_drive.svg",
    color: const Color(0xFFA4CDFF),
    totalStorage: "1GB",
    percentage: 10,
  ),
    CloudStorageInfo(
    title: "Biễu mẫu KPI",
    numOfFiles: 1328,
    svgSrc: "assets/icons/google_drive.svg",
    color: const Color(0xFFFFA113),
    totalStorage: "2.9GB",
     percentage: 35,
  ),
  CloudStorageInfo(
    title: "Danh sách xét duyệt",
    numOfFiles: 1328,
    svgSrc: "assets/icons/Documents.svg",
    color: primaryColor,
    totalStorage: "1.9GB",
    percentage: 35,
  ),
  CloudStorageInfo(
    title: "Thông tin cá nhân",
    numOfFiles: 5328,
    svgSrc: "assets/icons/drop_box.svg",
    color: const Color(0xFF007EE5),
    totalStorage: "7.3GB",
    percentage: 78,
  ),
];
