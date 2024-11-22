// import 'package:flutter/material.dart';
// import 'package:flutter_login_api/mausacvakichthuoc/constants1.dart';
// import 'package:flutter_login_api/models/chitietkpicanhannv.dart';
// import 'package:flutter_login_api/models/kpicanhan.dart';
// import 'package:flutter_login_api/providers/usuario_provider.dart';
// import 'package:flutter_login_api/providers/usuario_provider1.dart';
// import 'package:flutter_login_api/screens/main/components/side_menu.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:fl_chart/fl_chart.dart';

// class Test extends StatefulWidget {
//   @override
//   _MyKPIPageState createState() => _MyKPIPageState();
// }

// class _MyKPIPageState extends State<Test> {
//   TextEditingController _maNVController = TextEditingController();
//   TextEditingController _yearController = TextEditingController();
//   List<ChiTietKPICaNhanNV> _kpiData = [];
//   bool _isLoading = false;
//   bool _isDataVisible = false;
//   Map<int, TextEditingController> _controllers = {};
//   String _employeeName = ''; // Để hiển thị tên nhân viên
//   String? maphieukpi;
//   final int currentYear = DateTime.now().year;
//   bool isComplete = false;
//   @override
//   void initState() {
//     super.initState();
//     // Lấy năm hiện tại và đặt làm giá trị mặc định cho ô năm
//     _maNVController.text = '1456'; // Gán giá trị từ tham số maNV
//     _yearController.text = '2024';
//     _fetchKPI();
//     _fetchEmployeeName(); // Gán giá trị từ tham số year
//   }

//   @override
//   void dispose() {
//     _controllers.forEach((key, controller) {
//       controller.dispose();
//     });
//     super.dispose();
//   }

//   Future<void> _fetchEmployeeName() async {
//     print("Chạy đên hàm này rồi");
//     final maNV = '1456';

//     if (maNV.isNotEmpty) {
//       try {
//         print(maNV);
//         // Gọi API hoặc hàm lấy thông tin nhân viên theo mã
//         final name = await Provider.of<Usuario_provider>(context, listen: false)
//             .getNameByMaND(maNV);
//         print(name);
//         setState(() {
//           _employeeName = name; // Hiển thị tên nhân viên
//         });
//       } catch (error) {
//         // Hiển thị lỗi nếu không tìm thấy tên nhân viên
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Lỗi: $error')),
//         );
//       }
//     }
//   }

//   Future<void> _fetchKPI() async {
//     final maNV = _maNVController.text;
//     print(maNV);
//     final year = int.tryParse(_yearController.text);

//     if (maNV.isNotEmpty && year != null) {
//       setState(() {
//         _isLoading = true;
//       });

//       try {
//         await Provider.of<Usuario_provider1>(context, listen: false)
//             .ChiTietKPICNByMaNVvaNam(maNV, year);

//         setState(() {
//           _isDataVisible = true;
//           _kpiData = Provider.of<Usuario_provider1>(context, listen: false)
//               .chitiietkpicanhan;

//           for (var i = 0; i < _kpiData.length; i++) {
//             _controllers[i] = TextEditingController();
//           }
//         });
//       } catch (error) {
//         _isDataVisible = false;
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Dữ liệu không tồn tại')),
//         );
//       } finally {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Vui lòng nhập mã NV và năm hợp lệ!')),
//       );
//     }
//   }

//   double calculateKPI(String thucHien, String keHoach, List<String> rules) {
//     bool isDate(String value) {
//       try {
//         DateFormat('dd/MM/yyyy').parseStrict(value);
//         return true;
//       } catch (_) {
//         return false;
//       }
//     }

//     DateTime? parseDate(String value) {
//       if (isDate(value)) {
//         return DateFormat('dd/MM/yyyy').parse(value);
//       }
//       return null;
//     }

//     double? parseNumber(String value) {
//       return double.tryParse(value.replaceAll('%', '').trim());
//     }

//     var thucHienDate = parseDate(thucHien);
//     var keHoachDate = parseDate(keHoach);
//     double? thucHienValue = thucHienDate == null ? parseNumber(thucHien) : null;
//     double? keHoachValue = keHoachDate == null ? parseNumber(keHoach) : null;

//     for (var rule in rules) {
//       var parts = rule.split(':');
//       if (parts.length < 2) continue;

//       var condition = parts[0].trim();
//       var kpiString = parts[1].trim();
//       var operator = condition.split(' ')[1];
//       var kpiValue =
//           double.tryParse(kpiString.split('=').last.trim().replaceAll('%', ''));

//       if (thucHienDate != null && keHoachDate != null) {
//         switch (operator) {
//           case '=':
//             if (thucHienDate.isAtSameMomentAs(keHoachDate))
//               return kpiValue ?? 0;
//             break;
//           case '<':
//             if (thucHienDate.isBefore(keHoachDate)) return kpiValue ?? 0;
//             break;
//           case '>':
//             if (thucHienDate.isAfter(keHoachDate)) return kpiValue ?? 0;
//             break;
//           case '<=':
//             if (thucHienDate.isBefore(keHoachDate) ||
//                 thucHienDate.isAtSameMomentAs(keHoachDate))
//               return kpiValue ?? 0;
//             break;
//           case '>=':
//             if (thucHienDate.isAfter(keHoachDate) ||
//                 thucHienDate.isAtSameMomentAs(keHoachDate))
//               return kpiValue ?? 0;
//             break;
//         }
//       } else if (thucHienValue != null && keHoachValue != null) {
//         switch (operator) {
//           case '=':
//             if (thucHienValue == keHoachValue) return kpiValue ?? 0;
//             break;
//           case '<':
//             if (thucHienValue < keHoachValue) return kpiValue ?? 0;
//             break;
//           case '>':
//             if (thucHienValue > keHoachValue) return kpiValue ?? 0;
//             break;
//           case '<=':
//             if (thucHienValue <= keHoachValue) return kpiValue ?? 0;
//             break;
//           case '>=':
//             if (thucHienValue >= keHoachValue) return kpiValue ?? 0;
//             break;
//         }
//       }
//     }
//     return 0;
//   }

//   List<String> fetchRulesFromTieuchidanhgiaketqua(String tieuchi) {
//     return tieuchi
//         .split('\n')
//         .where((rule) => rule.trim().isNotEmpty && rule.contains(':'))
//         .toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Usuario_provider1 usuarioProvider1 =
//         Provider.of<Usuario_provider1>(context);
//     final kpicntt = usuarioProvider1.chitiietkpicanhan;

//     return Scaffold(
//       backgroundColor: bgColor,
//       drawer: MediaQuery.of(context).size.width < 600
//           ?  SideMenu( userEmail: widget.userEmail,
//                     displayName: widget.displayName,
//                     photoURL: widget.photoURL!,)
//           : null, // Slide menu
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           if (constraints.maxWidth >= 600) {
//             return Row(
//               children: [
//                 // Left side: Menu
//                 Container(
//                   width: MediaQuery.of(context).size.width * 0.12,
//                   color: bgColor1,
//                   child: Column(
//                     children: [
//                       DrawerHeader(
//                         child: Image.asset(
//                             "assets/images/Tiêu_đề_Website_BV_16_-removebg-preview.png"),
//                       ),
//                       DrawerListTile(
//                         title: "KPI",
//                         svgSrc: "assets/icons/menu_dashboard.svg",
//                         press: () {},
//                       ),
//                       DrawerListTile(
//                         title: "Tài liệu",
//                         svgSrc: "assets/icons/menu_doc.svg",
//                         press: () {},
//                       ),
//                       DrawerListTile(
//                         title: "Thông báo",
//                         svgSrc: "assets/icons/menu_notification.svg",
//                         press: () {},
//                       ),
//                       DrawerListTile(
//                         title: "Thông tin cá nhân",
//                         svgSrc: "assets/icons/menu_profile.svg",
//                         press: () {},
//                       ),
//                       DrawerListTile(
//                         title: "Cài đặt",
//                         svgSrc: "assets/icons/menu_setting.svg",
//                         press: () {},
//                       ),
//                     ],
//                   ),
//                 ),
//                 // Right side: Main content
//                 Expanded(
//                   child: SingleChildScrollView(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // const SizedBox(height: 5), // Spacing for visual appeal
//                         const Padding(
//                           padding: EdgeInsets.all(5.0),
//                           child: Text(
//                             'Tổng kết KPI cuối năm',
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                         // Row containing two side-by-side charts

//                         Row(
//                           mainAxisAlignment:
//                               MainAxisAlignment.center, // Căn giữa các biểu đồ
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.all(16.0),
//                               height: 100, // Chiều cao của biểu đồ
//                               width: 100, // Chiều rộng biểu đồ
//                               child: buildCompletionPieChart(
//                                   kpicntt), // Gọi hàm vẽ biểu đồ thứ nhất
//                             ),
//                             const SizedBox(
//                                 width: 100), // Khoảng cách giữa hai biểu đồ
//                             Container(
//                               padding: const EdgeInsets.all(16.0),
//                               height: 200, // Chiều cao của biểu đồ
//                               width: 440, // Chiều rộng biểu đồ
//                               child: buildCompletionRateBarChart(
//                                   kpicntt), // Gọi hàm vẽ biểu đồ thứ hai
//                             ),
//                           ],
//                         ),

//                         const SizedBox(
//                             height: 5), // Space between charts and DataTable
//                         Container(
//                           padding: const EdgeInsets.all(16.0),
//                           child: _Dulieubang1(kpicntt),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           } else {
//             return Stack(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.only(
//                       top: 56.0, left: 16.0, right: 16.0, bottom: 16.0),
//                   child: SingleChildScrollView(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // const SizedBox(height: 5), // Spacing for visual appeal
//                         const Padding(
//                           padding: EdgeInsets.all(5.0),
//                           child: Text(
//                             'Tổng kết KPI cuối năm',
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                         // Row containing two side-by-side charts

//                         SingleChildScrollView(
//                           scrollDirection: Axis.horizontal,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment
//                                 .center, // Căn giữa các biểu đồ
//                             children: [
//                               Container(
//                                 padding: const EdgeInsets.all(16.0),
//                                 height: 100, // Chiều cao của biểu đồ
//                                 width: 100, // Chiều rộng biểu đồ
//                                 child: buildCompletionPieChart(
//                                     kpicntt), // Gọi hàm vẽ biểu đồ thứ nhất
//                               ),
//                               const SizedBox(
//                                   width: 100), // Khoảng cách giữa hai biểu đồ
//                               Container(
//                                 padding: const EdgeInsets.all(16.0),
//                                 height: 200, // Chiều cao của biểu đồ
//                                 width: 440, // Chiều rộng biểu đồ
//                                 child: buildCompletionRateBarChart(
//                                     kpicntt), // Gọi hàm vẽ biểu đồ thứ hai
//                               ),
//                             ],
//                           ),
//                         ),

//                         const SizedBox(
//                             height: 5), // Space between charts and DataTable
//                         Container(
//                           padding: const EdgeInsets.all(16.0),
//                           child: _Dulieubang1(kpicntt),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   top: 16,
//                   left: 16,
//                   child: Builder(
//                     builder: (context) => IconButton(
//                       icon:
//                           const Icon(Icons.menu, size: 32, color: Colors.black),
//                       onPressed: () {
//                         Scaffold.of(context).openDrawer();
//                       },
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           }
//         },
//       ),
//     );
//   }

//   Widget _Dulieubang1(List<ChiTietKPICaNhanNV> kpicntt) {
//     return Center(
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 2),
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.grey),
//           borderRadius: BorderRadius.circular(8),
//           color: Colors.white,
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 if (_employeeName.isNotEmpty)
//                   Expanded(
//                     flex: 2,
//                     child: Text(
//                       '$_employeeName',
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.blue,
//                       ),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   flex: 1,
//                   child: TextFormField(
//                     controller: _yearController,
//                     keyboardType: TextInputType.number,
//                     decoration: const InputDecoration(
//                       labelText: 'Năm',
//                       labelStyle: TextStyle(color: Colors.blue),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   flex: 1,
//                   child: ElevatedButton(
//                     onPressed: () async {
//                       await _fetchKPI();
//                     },
//                     child: const Text('Tải lại'),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green,
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 32, vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//             if (_isDataVisible)
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 width: MediaQuery.of(context).size.width * 0.85,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[200],
//                   border: Border.all(color: Colors.blueAccent),
//                   borderRadius: BorderRadius.circular(8),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.2),
//                       spreadRadius: 0.2,
//                       blurRadius: 2,
//                       offset: const Offset(0, 3),
//                     ),
//                   ],
//                 ),
//                 child: SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: SingleChildScrollView(
//                     scrollDirection: Axis.vertical,
//                     child: DataTable(
//                       headingRowColor: MaterialStateColor.resolveWith(
//                         (states) => Colors.grey[200]!,
//                       ),
//                       columns: const [
//                         DataColumn(
//                           label: Expanded(
//                             child: Text(
//                               'Mục tiêu KPI cá nhân',
//                               textAlign: TextAlign.center,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ),
//                         DataColumn(
//                           label: Expanded(
//                             child: Text(
//                               'Tiêu chí đánh giá kết quả',
//                               textAlign: TextAlign.center,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ),
//                         DataColumn(
//                           label: Expanded(
//                             child: Text(
//                               'Kế hoạch',
//                               textAlign: TextAlign.center,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ),
//                         DataColumn(
//                           label: Expanded(
//                             child: Text(
//                               'Thực hiện',
//                               textAlign: TextAlign.center,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ),
//                         DataColumn(
//                           label: Expanded(
//                             child: Text(
//                               'Tỷ lệ hoàn thành',
//                               textAlign: TextAlign.center,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ),
//                         DataColumn(
//                           label: Expanded(
//                             child: Text(
//                               'Kết quả',
//                               textAlign: TextAlign.center,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ),
//                       ],
//                       rows: _kpiData.map<DataRow>((kpi) {
//                         int index = _kpiData.indexOf(kpi);
//                         return DataRow(
//                           cells: [
//                             DataCell(
//                               Tooltip(
//                                 message: kpi.noidungkpicanhan ?? 'N/A',
//                                 child: SizedBox(
//                                   width: 250,
//                                   child: Text(
//                                     kpi.noidungkpicanhan ?? 'N/A',
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             DataCell(
//                               Tooltip(
//                                 message: kpi.tieuchidanhgiaketqua ?? 'N/A',
//                                 child: SizedBox(
//                                   width: 150,
//                                   child: Text(
//                                     kpi.tieuchidanhgiaketqua ?? 'N/A',
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             DataCell(
//                               Tooltip(
//                                 message: kpi.kehoach ?? 'N/A',
//                                 child: SizedBox(
//                                   width: 100,
//                                   child: Text(
//                                     kpi.kehoach ?? 'N/A',
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             DataCell(
//                               TextField(
//                                 controller: _controllers[index],
//                                 keyboardType: TextInputType.number,
//                                 onChanged: (value) async {
//                                   setState(() {
//                                     // Cập nhật `thuchien` với giá trị mới
//                                     kpi.thuchien = value;
//                                     // Cập nhật lại tỷ lệ hoàn thành khi giá trị thực hiện thay đổi
//                                     kpi.tylehoanthanh = calculateKPI(
//                                       value,
//                                       kpi.kehoach ?? '',
//                                       fetchRulesFromTieuchidanhgiaketqua(
//                                         kpi.tieuchidanhgiaketqua ?? '',
//                                       ),
//                                     );
//                                   });
                                  
//                                 },
//                               ),
//                             ),
//                             DataCell(
//                               Tooltip(
//                                 message: kpi.tylehoanthanh.toString(),
//                                 child: SizedBox(
//                                   width: 100,
//                                   child: Text(
//                                     '${kpi.tylehoanthanh}%',
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             DataCell(
//                               Checkbox(
//                                 value: kpi.tylehoanthanh == 100,
//                                 onChanged: (bool? newValue) {
//                                   setState(() {
//                                     // Cập nhật `ketqua` với giá trị `newValue` hoặc mặc định là `false` nếu `newValue` là null
//                                     kpi.ketqua = newValue ?? false;

//                                     // Chỉ thực hiện gán nếu `kpi.ketqua` không null
//                                     kpi.tylehoanthanh =
//                                         (kpi.ketqua == true) ? 100 : 0;
//                                   });
//                                 },
//                               ),
//                             ),
//                           ],
//                         );
//                       }).toList(),
//                     ),
//                   ),
//                 ),
//               ),
//             const SizedBox(height: 5),
//             if (_isDataVisible)
//               Align(
//                 alignment: Alignment.center,
//                 child: ElevatedButton(
//                   onPressed: _handleSave,
//                   child: const Text('Lưu'),
//                   style: ElevatedButton.styleFrom(
//                     foregroundColor: Colors.white,
//                     backgroundColor: const Color.fromARGB(255, 110, 187, 117),
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 32, vertical: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     elevation: 2,
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _handleSave() async {
//     // Hộp thoại xác nhận trước khi lưu
//     final bool? confirmSave = await showDialog<bool>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Xác nhận lưu'),
//           content: const Text('Bạn có chắc chắn muốn lưu không?'),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context)
//                     .pop(false); // Trả về false nếu chọn "Không"
//               },
//               child: const Text('Không'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(true); // Trả về true nếu chọn "Có"
//               },
//               child: const Text('Có'),
//             ),
//           ],
//         );
//       },
//     );

//     // Nếu người dùng không xác nhận, dừng quá trình lưu
//     if (confirmSave != true) {
//       return;
//     }

//     try {
//       print(maphieukpi);
//       final usuarioProvider =
//           Provider.of<Usuario_provider1>(context, listen: false);
//       maphieukpi = await Provider.of<Usuario_provider1>(context, listen: false)
//           .getMaphieuKpCNByNamandMaNV(currentYear, _maNVController.text);
//       // Gọi hàm lưu KPI
//       // if (maphieukpi != null) {
//       //   await deletechitietKPICN(
//       //       maphieukpi!); // Chỉ thực hiện nếu maphieukpi khác null
//       // }
//       await saveEditsChiTietKPICN(maphieukpi.toString()); // Và hàm thứ ba
//       await saveEditsKPICN(); // Tiếp tục thực hiện hàm thứ hai
//       print(maphieukpi);

//       // Thông báo lưu thành công
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Kiểm duyệt thông tin KPI thành công!')),
//       );
//       // Navigator.push(
//       //   context,
//       //   MaterialPageRoute(
//       //     builder: (context) => CapKpiCN(),
//       //   ),
//       // );
//     } catch (e) {
//       // Bắt lỗi và thông báo nếu có lỗi
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Lưu thất bại: $e')),
//       );
//     }
//   }

//   Future<void> saveEditsKPICN() async {
//     final usuarioProvider =
//         Provider.of<Usuario_provider1>(context, listen: false);
//     if (maphieukpi!.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Không có mã phiếu để thông qua.')),
//       );
//       return;
//     }
//     // Lấy đối tượng Kpicanhan dựa trên mã phiếu
//     Kpicanhan? kpicanhan =
//         await usuarioProvider.getKpicanhanByMaphieu(maphieukpi!);

//     if (kpicanhan == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Không tìm thấy biễu mẫu cá nhân.')),
//       );
//       return;
//     }

//     // Hàm để đảm bảo ngày hợp lệ cho SQL Server
//     DateTime validDateTime(DateTime date) {
//       DateTime minDate = DateTime(1753, 1, 1);
//       return date.isBefore(minDate) ? minDate : date;
//     }

//     // Cập nhật các trường cần thiết
//     kpicanhan.nguoipheduyetkpicanhan = 'quyen';
//     kpicanhan.ngaypheduyetkpicanhan = validDateTime(DateTime.now());
//     kpicanhan.trangthai = 4;

//     // Gọi API để cập nhật trạng thái KPI cá nhân
//     await usuarioProvider.updateKPICaNhan(kpicanhan);

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Thông qua biễu mẫu thành công!')),
//     );
//   }

// // Hàm để lưu chỉnh sửa
//   Future<void> _LayMaPhieu() async {
//     maphieukpi = await Provider.of<Usuario_provider1>(context, listen: false)
//         .getMaphieuKpCNByNamandMaNV(currentYear, _maNVController.text);
//     // maphieukpi1 = maphieukpi!;
//     await Provider.of<Usuario_provider1>(context, listen: false)
//         .ChiTietKPICNByMaNVvaNam(_maNVController.text, currentYear);

//     print('Mã phiếu KPI: $maphieukpi');
//     print(
//         'Chi tiết KPI cá nhân: ${Provider.of<Usuario_provider1>(context, listen: false).chitiietkpicanhan}');

//     Provider.of<Usuario_provider1>(context, listen: false)
//             .chitiietkpicanhan
//             .isEmpty
//         ? []
//         : Provider.of<Usuario_provider1>(context, listen: false)
//             .chitiietkpicanhan
//             .map((kpiDetail) {
//             print('Chi tiết KPI: $kpiDetail');
//           });
//   }

//  Future<void> saveEditsChiTietKPICN(String maphieukpi) async {
//   final usuarioProvider = Provider.of<Usuario_provider1>(context, listen: false);
  
//   // Kiểm tra nếu danh sách rỗng thì thông báo
//   if (_kpiData.isEmpty) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Không có dữ liệu để lưu')),
//     );
//     return;
//   }

//   if (maphieukpi.isEmpty) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Không có mã phiếu để thông qua.')),
//     );
//     return;
//   }

//   try {
//     for (var kpiDetail in _kpiData) {
//       print("Đang xử lý KPI với MaKPI: ${kpiDetail.makpi}");
//       print("Kiểu dữ liệu thực hiện: ${kpiDetail.thuchien.runtimeType}"); 
      
//       if (kpiDetail.makpi == null || kpiDetail.thuchien == null || kpiDetail.kehoach == null) {
//         print("Bỏ qua KPI không đầy đủ thông tin cho MaKPI: ${kpiDetail.makpi}");
//         continue;
//       }

//       print("Lưu dữ liệu KPI cho MaKPI: ${kpiDetail.makpi}");
//       print("Thực hiện: ${kpiDetail.thuchien}");
//       print("Tỷ lệ hoàn thành: ${kpiDetail.tylehoanthanh}");
//       print("Kết quả: ${kpiDetail.ketqua}");

//       int? stt = await usuarioProvider.GetidByMaPhieuandMaKPI(maphieukpi, kpiDetail.makpi);
//       if (stt == null) {
//         print("Không tìm thấy STT cho MaKPI: ${kpiDetail.makpi}");
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Không tìm thấy STT cho MaKPI: ${kpiDetail.makpi}')),
//         );
//         continue; // Bỏ qua nếu không tìm thấy STT
//       } else {
//         print("Đã tìm thấy STT: $stt"); // Kiểm tra giá trị của STT
//       }

//       // Gọi hàm lấy chi tiết KPI cá nhân với STT hợp lệ
//       ChiTietKPICaNhanNV? chiTietKPICaNhanNV = await usuarioProvider.getChiTietKpicanhanByMaphieu(stt);
//       if (chiTietKPICaNhanNV == null) {
//         print("Không tìm thấy chi tiết KPI cho STT: $stt");
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Không tìm thấy KPI cho MaKPI: ${kpiDetail.makpi}')),
//         );
//         continue; // Bỏ qua nếu không tìm thấy chi tiết KPI
//       }

//       // Tiến hành cập nhật và gọi hàm API
//       chiTietKPICaNhanNV.stt = stt;
//       chiTietKPICaNhanNV.thuchien = kpiDetail.thuchien;
//       chiTietKPICaNhanNV.tylehoanthanh = kpiDetail.tylehoanthanh;
//       chiTietKPICaNhanNV.ketqua = kpiDetail.tylehoanthanh == 100;

//       // In ra để kiểm tra giá trị trước khi cập nhật
//       print("Đang cập nhật chi tiết KPI: ${chiTietKPICaNhanNV.toJson()}");

//       await usuarioProvider.updateChiTietKPICaNhan(chiTietKPICaNhanNV);
//       print("Cập nhật thành công cho MaKPI: ${kpiDetail.makpi}");
//     }

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Thông qua tất cả chi tiết KPI thành công!')),
//     );
//     print("Tất cả chi tiết KPI đã được cập nhật thành công.");
//   } catch (e) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Cập nhật thất bại: $e')),
//     );
//     print("Cập nhật thất bại: $e");
//   }
// }
//   Future<bool> checkKpiStatus(BuildContext context) async {
//     try {
//       int resultParam =
//           await Provider.of<Usuario_provider1>(context, listen: false)
//               .CheckNamPhieuKpiCN(DateTime.now().year, '1456');

//       if (resultParam == 0) {
//         // Trạng thái chờ duyệt
//         bool? shouldContinue = await _showConfirmationDialog(
//             context,
//             'Biểu mẫu đang ở trạng thái chờ duyệt.',
//             'Bạn có muốn xem lại biểu mẫu không?');

//         // Nếu người dùng chọn xem lại, dừng lại (trả về false)
//         if (shouldContinue == true) {
//           return false;
//         }
//         return false;
//       } else if (resultParam == 1) {
//         // Trạng thái đã duyệt
//         bool? shouldContinue = await _showConfirmationDialog(context,
//             'Biểu mẫu đã được duyệt.', 'Bạn có muốn xem lại biểu mẫu không?');

//         // Nếu người dùng chọn xem lại, dừng lại (trả về false)
//         if (shouldContinue == true) {
//           return false;
//         }
//         return false;
//       } else if (resultParam == 2) {
//         // Trạng thái bị từ chối
//         bool? shouldReview = await _showConfirmationDialog1(
//             context,
//             'Biểu mẫu bị từ chối.',
//             'Bạn muốn xem lại biểu mẫu hay lưu chỉnh sửa không?');

//         if (shouldReview == true) {
//           print(" Điều hướng tới trang xem biểu mẫu");
//           //Điều hướng tới trang xem biểu mẫu
//           // Navigator.push(
//           //   context,
//           //   MaterialPageRoute(
//           //     builder: (context) => XemBieumauKPCN(
//           //       machucdanh: machucdanh.toString(),
//           //     ),
//           //   ),
//           // );
//           return false; // Dừng lại nếu người dùng chọn xem lại
//         } else {
//           print("Lưu chỉnh sửa");
//           // await _handleSave1();
//           return false;
//         }
//       } else if (resultParam == 3) {
//         // Trạng thái hợp lệ, cho phép tiếp tục
//         return true;
//       }
//     } catch (e) {
//       // Gặp lỗi
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Kiểm tra trạng thái thất bại: $e')),
//       );
//       return false; // Không cho phép tiếp tục khi gặp lỗi
//     }

//     return false; // Mặc định dừng lại nếu không có điều kiện nào thỏa mãn
//   }

//   Future<bool?> _showConfirmationDialog(
//       BuildContext context, String title, String content) async {
//     bool? confirmed = await showDialog<bool>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: Colors.grey[200],
//           title: Text(title),
//           content: Text(content),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(false); // Người dùng chọn "Không"
//               },
//               child: const Text('Không'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(true); // Người dùng chọn "Có"
//               },
//               child: const Text('Có'),
//             ),
//           ],
//         );
//       },
//     );

//     // Nếu người dùng chọn "Có", chuyển đến trang xem biểu mẫu và không tiếp tục lưu
//     if (confirmed == true) {
//       // Navigator.push(
//       //   context,
//       //   MaterialPageRoute(
//       //       builder: (context) => XemBieumauKPCN(
//       //             machucdanh: machucdanh.toString(),
//       //           )), // Điều hướng đến trang xem biểu mẫu
//       // );
//       return null; // Ngăn quá trình tiếp tục lưu
//     }

//     // Nếu người dùng chọn "Không", tiếp tục hành động
//     // return confirmed;
//     return null;
//   }

//   Future<bool?> _showConfirmationDialog1(
//       BuildContext context, String title, String content) async {
//     bool? confirmed = await showDialog<bool>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: Colors.grey[200],
//           title: Text(title),
//           content: Text(content),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context)
//                     .pop(false); // Người dùng chọn "Lưu chỉnh sửa"
//               },
//               child: const Text('Lưu chỉnh sửa'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context)
//                     .pop(true); // Người dùng chọn "Xem lại biểu mẫu"
//               },
//               child: const Text('Xem lại biểu mẫu'),
//             ),
//           ],
//         );
//       },
//     );

//     // Trả về giá trị của confirmed để kiểm tra trong hàm checkKpiStatus
//     return confirmed;
//   }

//   Widget buildCompletionRateBarChart(List<ChiTietKPICaNhanNV> kpiData) {
//     return BarChart(
//       BarChartData(
//         alignment: BarChartAlignment.center,
//         maxY: 100,
//         minY: 0,
//         barGroups: kpiData.asMap().entries.map((entry) {
//           final index = entry.key;
//           final kpi = entry.value;
//           return BarChartGroupData(
//             x: index,
//             barRods: [
//               BarChartRodData(
//                 toY: kpi.tylehoanthanh ?? 0,
//                 color: Colors.blueAccent,
//                 width: 15,
//               ),
//             ],
//           );
//         }).toList(),
//         titlesData: FlTitlesData(
//           bottomTitles: AxisTitles(
//             sideTitles: SideTitles(
//               showTitles: true,
//               getTitlesWidget: (double value, TitleMeta meta) {
//                 return Text(
//                   'KPI ${value.toInt() + 1}', // Số thứ tự KPI
//                   style: TextStyle(fontSize: 12),
//                 );
//               },
//             ),
//           ),
//           leftTitles: AxisTitles(
//             sideTitles: SideTitles(showTitles: true, reservedSize: 32),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildCompletionPieChart(List<ChiTietKPICaNhanNV> kpiData) {
//     final completedKpis =
//         kpiData.where((kpi) => kpi.tylehoanthanh == 100).length;
//     final incompleteKpis = kpiData.length - completedKpis;

//     return PieChart(
//       PieChartData(
//         sections: [
//           PieChartSectionData(
//             color: Colors.green,
//             value: completedKpis.toDouble(),
//             title: 'Hoàn thành',
//           ),
//           PieChartSectionData(
//             color: Colors.red,
//             value: incompleteKpis.toDouble(),
//             title: 'Chưa hoàn thành',
//           ),
//         ],
//         sectionsSpace: 2,
//         centerSpaceRadius: 20,
//       ),
//     );
//   }
// }
