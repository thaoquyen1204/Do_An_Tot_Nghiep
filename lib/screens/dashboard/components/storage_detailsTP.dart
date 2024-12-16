import 'package:flutter/material.dart';
import 'package:flutter_login_api/mausacvakichthuoc/constants1.dart';
import 'package:flutter_login_api/models/usuario.dart';
import 'package:flutter_login_api/providers/usuario_provider.dart';
import 'package:flutter_login_api/providers/usuario_provider1.dart';
import 'package:flutter_login_api/screens/dashboard/components/chartTP.dart';
import 'package:provider/provider.dart';
import '../../../mausacvakichthuoc/constants.dart';
import 'chart.dart';
import 'storage_info_card.dart';

class StorageDetailsP extends StatefulWidget {
  final String userEmail;
  final String displayName;
  final String? photoURL;

  const StorageDetailsP({
    Key? key,
    required this.userEmail,
    required this.displayName,
    this.photoURL,
  }) : super(key: key);

  @override
  _StorageDetailsState createState() => _StorageDetailsState();
}

class _StorageDetailsState extends State<StorageDetailsP> {
  int count = 0; // Tổng số KPI
  int countH = 0; // Số KPI hoàn thành
  int incompleteCount = 0; // Số KPI chưa hoàn thành
  Map<String, double> tyleHoanThanhMap = {}; // Lưu trữ tỷ lệ hoàn thành

      List<Usuario> nhanViens = []; // Danh sách nhân viên (Cần phải định nghĩa lớp NhanVien)

bool isLoading = true;

@override
void initState() {
  super.initState();
  _loadData().then((_) {
    setState(() {
      isLoading = false; // Kết thúc tải
    });
  });
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

    setState(() {
      count = nhanViens.length;
      countH = evaluatedCount;
      incompleteCount = count - countH;
    });
  } catch (e) {
    print("Lỗi khi tải dữ liệu: $e");
  }
}


  @override
Widget build(BuildContext context) {
  return isLoading
      ? const Center(child: CircularProgressIndicator())
      : Container(
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
              ChartP(
                userEmail: widget.userEmail,
                displayName: widget.displayName,
                photoURL: widget.photoURL!,
              ),
              StorageInfoCard(
                svgSrc: "assets/icons/Documents.svg",
                title: "Nhân viên",
                amountOfFiles: count,
              ),
              StorageInfoCard(
                svgSrc: "assets/icons/media.svg",
                title: "Nhân viên đã được đánh gia",
                amountOfFiles: countH,
              ),
              StorageInfoCard(
                svgSrc: "assets/icons/folder.svg",
                title: "Nhân viên chưa được đánh gia",
                amountOfFiles: incompleteCount,
              ),
            ],
          ),
        );
}

}
