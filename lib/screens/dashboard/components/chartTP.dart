import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_api/providers/usuario_provider.dart';
import 'package:flutter_login_api/providers/usuario_provider1.dart';
import 'package:provider/provider.dart';

class ChartP extends StatefulWidget {
  final String userEmail;
  final String displayName;
  final String? photoURL;

  const ChartP({
    Key? key,
    required this.userEmail,
    required this.displayName,
    this.photoURL,
  }) : super(key: key);

  @override
  _ChartScreenState createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartP> {
  int count = 0; // Tổng nhân viên
  int countH = 0; // Số nhân viên đã được đánh giá
  bool isLoading = true; // Trạng thái tải dữ liệu

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final usuarioProvider = Provider.of<Usuario_provider>(context, listen: false);
      final usuarioProvider1 = Provider.of<Usuario_provider1>(context, listen: false);

      // Lấy danh sách nhân viên từ API
      await usuarioProvider.getNhanVien();
      var nhanViens = usuarioProvider.usuarios;

      int evaluatedCount = 0; // Số nhân viên được đánh giá

      for (var nhanVien in nhanViens) {
        int trangthai = await usuarioProvider1.KPICNTTByMaNVvaNam(
          nhanVien.maNv,
          DateTime.now().year,
        );

        if (trangthai == 4) {
          evaluatedCount++; // Đếm số nhân viên đã được đánh giá
        }
      }

      // Cập nhật trạng thái
      setState(() {
        count = nhanViens.length;
        countH = evaluatedCount;
        isLoading = false; // Kết thúc tải dữ liệu
      });
    } catch (e) {
      print("Lỗi khi tải dữ liệu: $e");
      setState(() {
        isLoading = false; // Đảm bảo giao diện không bị treo
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    // Tính số nhân viên chưa được đánh giá
    int notEvaluatedCount = (count - countH).clamp(0, count);

    // Dữ liệu biểu đồ
    List<PieChartSectionData> paiChartSelectionData = [
      PieChartSectionData(
        color: Colors.green, // Nhân viên đã được đánh giá
        value: countH.toDouble(),
        showTitle: true,
        title: "${((countH / count) * 100).toStringAsFixed(1)}%", // % đã đánh giá
        radius: 25,
      ),
      PieChartSectionData(
        color: Colors.red, // Nhân viên chưa được đánh giá
        value: notEvaluatedCount.toDouble(),
        showTitle: true,
        title: "${((notEvaluatedCount / count) * 100).toStringAsFixed(1)}%", // % chưa đánh giá
        radius: 22,
      ),
    ];

    // Hiển thị giao diện
    return SizedBox(
      height: 300,
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 70,
              startDegreeOffset: -90,
              sections: paiChartSelectionData,
            ),
          ),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${((countH / count) * 100).toStringAsFixed(1)}%",
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Text(
                  "Tỉ lệ nhân viên đã được đánh giá",
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
