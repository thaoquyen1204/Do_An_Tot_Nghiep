import 'package:flutter/material.dart';
import 'package:flutter_login_api/mausacvakichthuoc/constants1.dart';
import 'package:flutter_login_api/providers/usuario_provider.dart';
import 'package:flutter_login_api/providers/usuario_provider1.dart';
import 'package:provider/provider.dart';
import '../../../mausacvakichthuoc/constants.dart';
import 'chart.dart';
import 'storage_info_card.dart';

class StorageDetails extends StatefulWidget {
  final String userEmail;
  final String displayName;
  final String? photoURL;

  const StorageDetails({
    Key? key,
    required this.userEmail,
    required this.displayName,
    this.photoURL,
  }) : super(key: key);

  @override
  _StorageDetailsState createState() => _StorageDetailsState();
}

class _StorageDetailsState extends State<StorageDetails> {
  int count = 0; // Tổng số KPI
  int countH = 0; // Số KPI hoàn thành
  int incompleteCount = 0; // Số KPI chưa hoàn thành
  String manhanvien = ''; // Mã nhân viên

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      var maNV = await Provider.of<Usuario_provider>(context, listen: false)
          .GetMaNVByEmail(widget.userEmail);
      manhanvien = maNV;
      int totalCount = await Provider.of<Usuario_provider1>(context, listen: false)
          .GetDemChiTietKPICNByMaNVvaNam(manhanvien, DateTime.now().year);
      int completedCount = await Provider.of<Usuario_provider1>(context, listen: false)
          .GetDemChiTietKPICNByMaNVvaNamHT(manhanvien, DateTime.now().year);

      setState(() {
        count = totalCount;
        countH = completedCount;
        incompleteCount = (count - countH).clamp(0, count); // Đảm bảo giá trị >= 0
      });
    } catch (e) {
      // Xử lý lỗi nếu cần
      print("Error loading data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Biểu đồ KPI",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: defaultPadding),
          Chart(
            userEmail: widget.userEmail,
            displayName: widget.displayName,
            photoURL: widget.photoURL!,
          ),
          StorageInfoCard(
            svgSrc: "assets/icons/Documents.svg",
            title: "Tổng KPI",
            amountOfFiles: count,
          ),
          StorageInfoCard(
            svgSrc: "assets/icons/media.svg",
            title: "Số lượng KPI hoàn thành",
            amountOfFiles: countH,
          ),
          StorageInfoCard(
            svgSrc: "assets/icons/folder.svg",
            title: "Số lượng KPI chưa hoàn thành",
            amountOfFiles: incompleteCount,
          ),
        ],
      ),
    );
  }
}
