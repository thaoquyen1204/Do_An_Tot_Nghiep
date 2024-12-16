// import 'package:flutter/material.dart';
// import 'package:flutter_login_api/mausacvakichthuoc/constants1.dart';
// import 'package:flutter_login_api/models/kpiphongcntt.dart';
// import 'package:flutter_login_api/models/modelchucdanh.dart';
// import 'package:flutter_login_api/screens/main/components/side_menu.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter_login_api/providers/usuario_provider.dart';

// class Test extends StatefulWidget {
//   @override
//   _CapKpiKPScreenState createState() => _CapKpiKPScreenState();
// }

// class _CapKpiKPScreenState extends State<Test>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   final int currentYear = DateTime.now().year;
//   List<int> selectedRows = []; // List to track selected KPIs
//   List<Map<String, dynamic>> selectedKpiDetails =
//       []; // List to hold KPI details for second DataTable
//   bool _selectAll = false;
//   TextEditingController _searchController = TextEditingController();
//   late String userName = 'quyen';
//   late String userPosition = 'Trưởng phòng';
//     String? selectedmachucdanh;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 4, vsync: this);
//     Future.microtask(() => Provider.of<Usuario_provider>(context, listen: false)
//         .getKPIByPKCN());
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

// @override
// Widget build(BuildContext context) {
//   String? selectedChucDanh;

//   return Consumer<Usuario_provider>(
//     builder: (context, usuarioProvider1, child) {
//       final kpicntt = usuarioProvider1.kpicntt;
//        String? selectedChucDanh = usuarioProvider1.chucdanh.isNotEmpty
//           ? usuarioProvider1.chucdanh[0].maChucDanh // Chọn giá trị đầu tiên nếu có
//           : null;
//       return Scaffold(
//         backgroundColor: bgColor,
//         drawer: MediaQuery.of(context).size.width < 600
//             ? const SideMenu()
//             : null,
//         body: LayoutBuilder(
//           builder: (context, constraints) {
//             if (constraints.maxWidth >= 600) {
//               return Row(
//                 children: [
//                   Container(
//                     width: MediaQuery.of(context).size.width * 0.2,
//                     color: bgColor1,
//                     child: Column(
//                       children: [
//                         DrawerHeader(
//                           child: Image.asset(
//                               "assets/images/Tiêu_đề_Website_BV_16_-removebg-preview.png"),
//                         ),
//                         DrawerListTile(
//                           title: "KPI",
//                           svgSrc: "assets/icons/menu_dashboard.svg",
//                           press: () {},
//                         ),
//                         DrawerListTile(
//                           title: "Tài liệu",
//                           svgSrc: "assets/icons/menu_doc.svg",
//                           press: () {},
//                         ),
//                         DrawerListTile(
//                           title: "Thông báo",
//                           svgSrc: "assets/icons/menu_notification.svg",
//                           press: () {},
//                         ),
//                         DrawerListTile(
//                           title: "Thông tin cá nhân",
//                           svgSrc: "assets/icons/menu_profile.svg",
//                           press: () {},
//                         ),
//                         DrawerListTile(
//                           title: "Cài đặt",
//                           svgSrc: "assets/icons/menu_setting.svg",
//                           press: () {},
//                         ),
//                       ],
//                     ),
//                   ),
//                   Expanded(
//                     child: Container(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         children: [
//                           const Padding(
//                             padding: EdgeInsets.all(16.0),
//                             child: Align(
//                               alignment: Alignment.centerLeft,
//                               child: Column(
//                                 crossAxisAlignment:
//                                     CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'Cấp KPI BIỂU MẪU CÁ NHÂN',
//                                     style: TextStyle(
//                                       fontSize: 21,
//                                       color: Colors.black,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 0),

//                           Container(
//                             height: 50, // Điều chỉnh chiều cao
//                             child: DropdownButton<String>(
//                               isExpanded: true,
//                               hint: const Text("Chọn chức danh"),
//                               value: selectedChucDanh, // Sử dụng giá trị selectedChucDanh tại đây
//                               onChanged: (String? newValue) {
//                                 selectedChucDanh = newValue; // Cập nhật selectedChucDanh
//                                 selectedmachucdanh =selectedChucDanh;
//                                 // Cập nhật lại UI bằng cách sử dụng setState
//                                 (context as Element).markNeedsBuild(); // Cập nhật lại widget
//                               },
//                               items: usuarioProvider1.chucdanh.map((ChucDanh chuc) {
//                                 return DropdownMenuItem<String>(
//                                   value: chuc.maChucDanh,
                                  
//                                   child: Text(
//                                     chuc.tenChucDanh,
//                                     style: const TextStyle(fontSize: 14), // Font size nhỏ hơn
//                                   ),
//                                 );
//                               }).toList(),
//                             ),
//                           ),

//                           const SizedBox(height: 3),

//                           _buildFirstDataTable(kpicntt),
//                           const SizedBox(height: 3),
//                           _buildSecondDataTable(),
//                           const Spacer(),
//                           Align(
//                             alignment: Alignment.center,
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 // Add your onPressed action here
//                               },
//                               child: const Text('Lưu biểu mẫu'),
//                               style: ElevatedButton.styleFrom(
//                                 foregroundColor: Colors.white,
//                                 backgroundColor: const Color.fromARGB(255, 110, 187, 117),
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 32, vertical: 16),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius:
//                                       BorderRadius.circular(12),
//                                 ),
//                                 elevation: 2,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               );
//             } else {
//               return Stack(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.only(
//                         top: 56.0, left: 16.0, right: 16.0, bottom: 16.0),
//                     child: Column(
//                       children: [
//                         const Padding(
//                           padding: EdgeInsets.all(16.0),
//                           child: Align(
//                             alignment: Alignment.centerLeft,
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Cấp KPI BIỂU MẪU CÁ NHÂN',
//                                   style: TextStyle(
//                                     fontSize: 26,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                                 SizedBox(height: 4),
//                               ],
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 10),

//                         // DropdownButton for chức danh
//                         Container(
//                           height: 50, // Điều chỉnh chiều cao
//                           child: DropdownButton<String>(
//                             isExpanded: true,
//                             hint: const Text("Chọn chức danh"),
//                             value: selectedChucDanh,
//                             onChanged: (String? newValue) {
//                               setState(() {
//                                 selectedChucDanh = newValue;
//                               });
//                             },
//                             items: usuarioProvider1.chucdanh.map((ChucDanh chuc) {
//                               return DropdownMenuItem<String>(
//                                 value: chuc.maChucDanh,
//                                 child: Text(
//                                   chuc.tenChucDanh,
//                                   style: const TextStyle(fontSize: 14), // Font size nhỏ hơn
//                                 ),
//                               );
//                             }).toList(),
//                           ),
//                         ),
//                         const SizedBox(height: 5),
//                         _buildFirstDataTable(kpicntt),
//                         const SizedBox(height: 5),
//                         _buildSecondDataTable(),
//                         const Spacer(),
//                         Align(
//                           alignment: Alignment.center,
//                           child: ElevatedButton(
//                             onPressed: () {
//                               // Add your onPressed action here
//                             },
//                             child: const Text('Tiếp tục'),
//                             style: ElevatedButton.styleFrom(
//                               foregroundColor: Colors.white,
//                               backgroundColor: const Color.fromARGB(255, 110, 187, 117),
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 32, vertical: 16),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               elevation: 2,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Positioned(
//                     top: 16,
//                     left: 16,
//                     child: IconButton(
//                       icon: const Icon(Icons.menu, size: 32, color: Colors.black),
//                       onPressed: () {
//                         Scaffold.of(context).openDrawer(); // Mở Drawer
//                       },
//                     ),
//                   ),
//                 ],
//               );
//             }
//           },
//         ),
//       );
//     },
//   );
// }






// Widget _buildFirstDataTable(List<Kpiphongcntt> kpicntt) {
//   // Sử dụng Set để loại bỏ các mục trùng lặp dựa trên makpi
//   final uniqueKpicntt = kpicntt.toSet().toList();

//   return Center(
//     child: Container(
//       margin: const EdgeInsets.symmetric(vertical: 2),
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey),
//         borderRadius: BorderRadius.circular(8),
//         color: Colors.white,
//       ),
//       child: SizedBox(
//         height: MediaQuery.of(context).size.height *
//             0.3, // Chiều cao cố định hoặc có thể dùng MediaQuery để điều chỉnh
//         width: MediaQuery.of(context).size.width * 0.84,
//         child: SingleChildScrollView(
//           scrollDirection: Axis.horizontal, // Cuộn theo chiều ngang
//           child: SingleChildScrollView(
//             scrollDirection: Axis.vertical, // Cuộn theo chiều dọc
//             child: DataTable(
//               headingRowColor: MaterialStateColor.resolveWith(
//                 (states) => Colors.grey[200]!, // Màu nền cho hàng tiêu đề
//               ),
//               columns: [
//                 DataColumn(
//                   label: Row(
//                     children: [
//                       const Text('Chọn tất cả'),
//                       Checkbox(
//                         value: _selectAll,
//                         onChanged: (value) {
//                           setState(() {
//                             _selectAll = value!;
//                             if (_selectAll) {
//                               selectedRows = uniqueKpicntt
//                                   .map((usuario) => usuario.makpi)
//                                   .toList();
//                               selectedKpiDetails = uniqueKpicntt.map((usuario) {
//                                 return {
//                                   'makpi': usuario.makpi,
//                                   'noidung': usuario.noidung,
//                                   'phuongphapdo': usuario.phuongphapdo,
//                                   'donvitinh': usuario.donvitinh,
//                                   'chitieu': usuario.chitieu,
//                                   'kehoach': '',
//                                   'trongso': '',
//                                 };
//                               }).toList();
//                             } else {
//                               selectedRows.clear();
//                               selectedKpiDetails.clear();
//                             }
//                           });
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//                 const DataColumn(
//                   label: Expanded(
//                     child: Text(
//                       'Mục tiêu bệnh viện (chọn ít nhất 5 mục)',
//                       textAlign: TextAlign.center,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 ),
//                 const DataColumn(
//                   label: Expanded(
//                     child: Text(
//                       'Phương pháp đo',
//                       textAlign: TextAlign.center,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 ),
//                 const DataColumn(
//                   label: Expanded(
//                     child: Text(
//                       'Đơn vị',
//                       textAlign: TextAlign.center,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 ),
//                 const DataColumn(
//                   label: Expanded(
//                     child: Text(
//                       'Chỉ tiêu',
//                       textAlign: TextAlign.center,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 ),
//               ],
//               rows: uniqueKpicntt.map<DataRow>((usuario) {
//                 return DataRow(
//                   cells: [
//                     DataCell(
//                       Checkbox(
//                         value: selectedRows.contains(usuario.makpi),
//                         onChanged: (value) {
//                           setState(() {
//                             if (value!) {
//                               selectedRows.add(usuario.makpi);
//                               selectedKpiDetails.add({
//                                 'makpi': usuario.makpi,
//                                 'noidung': usuario.noidung,
//                                 'phuongphapdo': usuario.phuongphapdo,
//                                 'donvitinh': usuario.donvitinh,
//                                 'chitieu': usuario.chitieu,
//                                 'kehoach': '',
//                                 'trongso': '',
//                               });
//                             } else {
//                               selectedRows.remove(usuario.makpi);
//                               selectedKpiDetails.removeWhere((element) =>
//                                   element['makpi'] == usuario.makpi);
//                             }
//                             _selectAll = selectedRows.length == uniqueKpicntt.length;
//                           });
//                         },
//                       ),
//                     ),
//                     DataCell(
//                       Tooltip(
//                         message: usuario.noidung ?? 'N/A',
//                         child: SizedBox(
//                           width: 280,
//                           child: Text(
//                             usuario.noidung ?? 'N/A',
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ),
//                     ),
//                     DataCell(
//                       Tooltip(
//                         message: usuario.phuongphapdo ?? 'N/A',
//                         child: SizedBox(
//                           width: 150,
//                           child: Text(
//                             usuario.phuongphapdo ?? 'N/A',
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ),
//                     ),
//                     DataCell(
//                       Tooltip(
//                         message: usuario.donvitinh ?? 'N/A',
//                         child: SizedBox(
//                           width: 100,
//                           child: Text(
//                             usuario.donvitinh ?? 'N/A',
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ),
//                     ),
//                     DataCell(Text(usuario.chitieu ?? 'N/A')),
//                   ],
//                 );
//               }).toList(),
//             ),
//           ),
//         ),
//       ),
//     ),
//   );
// }



//   Widget _buildSecondDataTable() {
//     return Center(
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 2),
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.grey),
//           borderRadius: BorderRadius.circular(8),
//           color: Colors.white,
//         ),
//         child: SizedBox(
//           height: MediaQuery.of(context).size.height *
//               0.3, // Chiều cao cố định hoặc có thể điều chỉnh
//           width: MediaQuery.of(context).size.width *
//               0.84, // Responsive width for better scrolling
//           child: SingleChildScrollView(
//             scrollDirection: Axis.horizontal, // Cuộn theo chiều ngang
//             child: SingleChildScrollView(
//               scrollDirection: Axis.vertical, // Cuộn theo chiều dọc
//               child: DataTable(
//                 headingRowColor: MaterialStateColor.resolveWith(
//                   (states) => Colors.grey[200]!, // Màu nền cho hàng tiêu đề
//                 ),
//                 columns: [
//                   const DataColumn(label: Text('Xóa')),
//                   const DataColumn(
//                     label: Expanded(
//                       child: Text('Mục tiêu bệnh viện'),
//                     ),
//                   ),
//                   const DataColumn(
//                     label: Expanded(
//                       child: Text('Phương pháp đo'),
//                     ),
//                   ),
//                   const DataColumn(
//                     label: Expanded(
//                       child: Text('Chỉ tiêu'),
//                     ),
//                   ),
//                   const DataColumn(
//                     label: Expanded(
//                       child: Text('Kế hoạch'),
//                     ),
//                   ),
//                   const DataColumn(
//                     label: Expanded(
//                       child: Text('Trọng số'),
//                     ),
//                   ),
//                 ],
//                 rows: selectedKpiDetails.map<DataRow>((kpiDetail) {
//                   return DataRow(
//                     cells: [
//                       DataCell(
//                         IconButton(
//                           icon: const Icon(Icons.delete, color: Colors.red),
//                           onPressed: () {
//                             setState(() {
//                               selectedRows.remove(kpiDetail['makpi']);
//                               selectedKpiDetails.remove(kpiDetail);
//                             });
//                           },
//                         ),
//                       ),
//                       DataCell(
//                         Tooltip(
//                           message: kpiDetail['noidung'] ?? 'N/A',
//                           child: SizedBox(
//                             width: 220, // Limit width for text overflow
//                             child: Text(
//                               kpiDetail['noidung'] ?? 'N/A',
//                               overflow: TextOverflow
//                                   .ellipsis, // Show "..." for long text
//                             ),
//                           ),
//                         ),
//                       ),
//                       DataCell(
//                         Tooltip(
//                           message: kpiDetail['phuongphapdo'] ?? 'N/A',
//                           child: SizedBox(
//                             width: 70, // Limit width
//                             child: Text(
//                               kpiDetail['phuongphapdo'] ?? 'N/A',
//                               overflow:
//                                   TextOverflow.ellipsis, // Handle long text
//                             ),
//                           ),
//                         ),
//                       ),
//                       DataCell(Text(kpiDetail['chitieu'] ?? 'N/A')),
//                       DataCell(
//                         SizedBox(
//                           width: 100, // Limit width for input field
//                           child: TextFormField(
//                             initialValue: kpiDetail['kehoach'],
//                             onChanged: (value) {
//                               setState(() {
//                                 kpiDetail['kehoach'] = value;
//                               });
//                             },
//                           ),
//                         ),
//                       ),
//                       DataCell(
//                         SizedBox(
//                           width: 100, // Limit width for input field
//                           child: TextFormField(
//                             initialValue: kpiDetail['trongso'],
//                             onChanged: (value) {
//                               setState(() {
//                                 kpiDetail['trongso'] = value;
//                               });
//                             },
//                           ),
//                         ),
//                       ),
//                     ],
//                   );
//                 }).toList(),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
