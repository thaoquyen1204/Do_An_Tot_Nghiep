import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_api/providers/usuario_provider.dart';
import 'package:flutter_login_api/providers/usuario_provider1.dart';
import 'package:provider/provider.dart';

class Chart extends StatefulWidget {
  final String userEmail;
  final String displayName;
  final String? photoURL;

  const Chart({
    Key? key,
    required this.userEmail,
    required this.displayName,
    this.photoURL,
  }) : super(key: key);

  @override
  _ChartScreenState createState() => _ChartScreenState();
}

class _ChartScreenState extends State<Chart> with SingleTickerProviderStateMixin {
  String manhanvien = '';
  int count = 0;
  int countH = 0;

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
      });

    } catch (e) {
      // Xử lý lỗi nếu cần
      print("Error loading data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tính số liệu biểu đồ
_loadData();
    int incompleteCount = (count - countH).clamp(0, count);

    if (count == 0) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info_outline, color: Colors.grey, size: 50),
          SizedBox(height: 8),
          Text(
            "Không có dữ liệu để hiển thị",
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }


    List<PieChartSectionData> paiChartSelectionData = [
      PieChartSectionData(
        color: Colors.green, // Mục hoàn thành
        value: countH.toDouble(),
        showTitle: true,
        title: "Hoàn thành",
        radius: 25,
      ),
      PieChartSectionData(
        color: Colors.red, // Mục chưa hoàn thành
        value: incompleteCount.toDouble(),
        showTitle: true,
        title: "Chưa hoàn thành",
        radius: 22,
      ),
    ];

    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 60,
              startDegreeOffset: -90,
              sections: paiChartSelectionData,
            ),
          ),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${((countH / (count == 0 ? 1 : count)) * 100).toStringAsFixed(1)}%",
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Text(
                  "Tỉ lệ hoàn thành",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
