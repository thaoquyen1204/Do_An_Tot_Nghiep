import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_api/models/chitietkpicanhannv.dart';
import 'package:flutter_login_api/models/chitiettieuchimuctieubv.dart';
import 'package:flutter_login_api/models/kpiphongcntt.dart';
import 'package:flutter_login_api/providers/usuario_provider1.dart';
import 'package:provider/provider.dart';

class KpiDetailsDataTableCN extends StatefulWidget {
  final List<Kpiphongcntt> uniqueKpis;
  final Map<int, Map<String, String>> kpiDetailsMap;
  final Map<int, TextEditingController> kehoachControllers;
  final Map<int, TextEditingController> trongsoControllers;
  final Map<int, FocusNode> kehoachFocusNodes;
  final void Function(int) removeKpi;
  final void Function() removeAllKpis;

  const KpiDetailsDataTableCN({
    Key? key,
    required this.uniqueKpis,
    required this.kpiDetailsMap,
    required this.kehoachControllers,
    required this.trongsoControllers,
    required this.kehoachFocusNodes,
    required this.removeKpi,
    required this.removeAllKpis,
  }) : super(key: key);

  @override
  _KpiDetailsDataTableCNState createState() => _KpiDetailsDataTableCNState();
}

class _KpiDetailsDataTableCNState extends State<KpiDetailsDataTableCN> {
  @override
  void initState() {
    super.initState();
    // Khởi tạo các TextEditingController nếu chưa có cho từng KPI
    for (var kpi in widget.uniqueKpis) {
      if (!widget.kehoachControllers.containsKey(kpi.makpi)) {
        widget.kehoachControllers[kpi.makpi] = TextEditingController();
      }
      if (!widget.trongsoControllers.containsKey(kpi.makpi)) {
        widget.trongsoControllers[kpi.makpi] = TextEditingController();
      }
    }
  }

bool areAllFieldsFilled() {
  for (var kpi in widget.uniqueKpis) {
    final kehoachValue = widget.kehoachControllers[kpi.makpi]?.text.trim() ?? '';
    final trongsoValue = widget.trongsoControllers[kpi.makpi]?.text.trim() ?? '';

    // Kiểm tra nếu trường kế hoạch hoặc trọng số còn trống
    if (kehoachValue.isEmpty || trongsoValue.isEmpty) {
      return false;
    }

    // Kiểm tra nếu trọng số không phải là số hợp lệ
    final parsedTrongso = double.tryParse(trongsoValue);
    if (parsedTrongso == null || parsedTrongso <= 0 || parsedTrongso > 100) {
      return false;
    }
  }
  return true; // Tất cả các trường đều đã được nhập và hợp lệ
}
  void updateKpiField(int kpiId, String field, String value) {
    if (field == 'kehoach') {
      widget.kehoachControllers[kpiId]?.text = value;
    } else if (field == 'trongso') {
      widget.trongsoControllers[kpiId]?.text = value;
    }
    widget.kpiDetailsMap[kpiId]?[field] = value;

    // In log để kiểm tra giá trị cập nhật
    print('KpiId: $kpiId, Field: $field, Value: $value');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DataTable(
          columns: [
            DataColumn(
              label: Row(
                children: [
                  const Text('Xóa'),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: widget.removeAllKpis,
                  ),
                ],
              ),
            ),
            const DataColumn(label: Text('Nội dung')),
            const DataColumn(label: Text('Phương pháp đo')),
            const DataColumn(label: Text('Chỉ tiêu')),
            const DataColumn(label: Text('Kế hoạch')),
            const DataColumn(label: Text('Trọng số')),
          ],
          rows: List<DataRow>.generate(
            widget.uniqueKpis.length,
            (index) {
              final kpi = widget.uniqueKpis[index];
              final kehoachController = widget.kehoachControllers[kpi.makpi];
              final trongsoController = widget.trongsoControllers[kpi.makpi];

              return DataRow(
                cells: [
                  DataCell(
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => widget.removeKpi(kpi.makpi),
                    ),
                  ),
                  DataCell(
                    Tooltip(
                      message: kpi.noidung ?? 'N/A',
                      child: SizedBox(
                        width: 300,
                        child: Text(
                          kpi.noidung ?? 'N/A',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                  DataCell(Text(kpi.phuongphapdo ?? 'N/A')),
                  DataCell(Text(kpi.chitieu ?? 'N/A')),
                   DataCell(
                    SizedBox(
                      width: 100,
                      child: TextField(
                        controller: kehoachController,
                        onChanged: (value) {
                          //updateKpiField(kpi.makpi, 'kehoach', value);
                        },
                        onEditingComplete: () {
                    updateKpiField(kpi.makpi, 'kehoach', kehoachController?.text ?? '');
                     },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Nhập kế hoạch',
                        ),
                      ),
                    ),
                  ),
                DataCell(
  SizedBox(
    width: 100,
    child: TextField(
      controller: trongsoController,
      onChanged: (value) {
        // Optional: you can validate while typing if necessary
      },
      onEditingComplete: () {
        // Check if the controller is not null
        if (trongsoController != null && trongsoController!.text.isNotEmpty) {
          double? parsedValue = double.tryParse(trongsoController!.text);
          if (parsedValue != null && parsedValue > 0 && parsedValue <= 100) {
            updateKpiField(kpi.makpi, 'trongso', trongsoController!.text);
          } else {
            // Show error message or reset the input if the value is invalid
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Trọng số phải là số lớn hơn 0 và nhỏ hơn hoặc bằng 100.'),
              ),
            );
            // Optionally reset the value to a valid state
            trongsoController!.text = ''; // Reset input field
          }
        }
      },
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Nhập trọng số',
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')), // Allow numbers with up to 2 decimal places
      ],
    ),
  ),
),

                ],
              );
            },
          ),
        ),     
      ],
      
    );
    
  }
}
class KpiApiServiceCN{
static Future<void> saveAllKpisToApi(
    BuildContext context,
    List<Kpiphongcntt> uniqueKpis,
    String maphieukpi,
    Map<int, TextEditingController> kehoachControllers,
    Map<int, TextEditingController> trongsoControllers) async {
    for (var kpi in uniqueKpis) {
      final kehoachValue = kehoachControllers[kpi.makpi]?.text.trim() ?? '';
      final trongsoValue =
          double.tryParse(trongsoControllers[kpi.makpi]?.text.trim() ?? '0') ?? 0;

      // In ra thông tin hiện tại của KPI (Debug)
      print('KPI: ${kpi.makpi}, Kế hoạch: $kehoachValue, Trọng số1: $trongsoValue');

      // Kiểm tra giá trị nhập vào
      if (kehoachValue.isEmpty || trongsoValue <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Vui lòng nhập kế hoạch và trọng số hợp lệ cho KPI ${kpi.makpi}'),
          ),
        );
        continue; // Bỏ qua KPI này nếu thông tin không hợp lệ
      }

      // Tạo đối tượng để gửi lên API
      final chitietkpicanhan = ChiTietKPICaNhanNV(


        maphieukpicanhan:maphieukpi,
        makpi:kpi.makpi,
        noidungkpicanhan:kpi.noidung ?? 'N/A',
        nguonchungminh:'CNTT',
        tieuchidanhgiaketqua:kpi.phuongphapdo,
        kehoach:kehoachValue,
        trongsokpicanhan: trongsoValue,
        thuchien:'null',
        tylehoanthanh:0,
        ketqua:false,
      );

      try {
        await Provider.of<Usuario_provider1>(context, listen: false)
            .addTieuchikpicanhan(chitietkpicanhan);
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(content: Text('Đã lưu thông tin KPI.')),
        // );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Thêm mới thất bại111: $e')),
        );
      }
    }
  }
// Hàm kiểm tra đã nhập đúng dữ liệu cho tất cả KPI
  static bool areAllFieldsFilled(
      List<Kpiphongcntt> uniqueKpis,
      Map<int, TextEditingController> kehoachControllers,
      Map<int, TextEditingController> trongsoControllers) {
    for (var kpi in uniqueKpis) {
      final kehoachValue = kehoachControllers[kpi.makpi]?.text.trim() ?? '';
      final trongsoValue = trongsoControllers[kpi.makpi]?.text.trim() ?? '';

      // Kiểm tra nếu trường kế hoạch hoặc trọng số còn trống
      if (kehoachValue.isEmpty || trongsoValue.isEmpty) {
        return false;
      }

      // Kiểm tra nếu trọng số không phải là số hợp lệ
      final parsedTrongso = double.tryParse(trongsoValue);
      if (parsedTrongso == null || parsedTrongso <= 0 || parsedTrongso > 100) {
        return false;
      }
    }
    return true; // Tất cả các trường đều đã được nhập và hợp lệ
  }
}