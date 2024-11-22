import 'package:flutter/material.dart';
import 'package:flutter_login_api/mausacvakichthuoc/constants1.dart';
import 'package:flutter_login_api/models/modelchucdanh.dart';
import 'package:flutter_login_api/providers/usuario_provider.dart';
import 'package:flutter_login_api/providers/usuario_provider1.dart';
import 'package:flutter_login_api/providers/usuario_provider2.dart';
import 'package:flutter_login_api/screens/capkpi/capkpibieumauchucvu/capkpibieumauchucvu.dart';
import 'package:flutter_login_api/screens/capkpi/capkpikhoaphong/capkpi.dart';
import 'package:flutter_login_api/screens/kiemduyetbieumau/canhan/danhsachcanhankd.dart';
import 'package:flutter_login_api/screens/kiemduyetbieumau/khoaphong/khoaphongbm.dart';
import 'package:flutter_login_api/screens/kiemduyetbieumau/khoaphongcn/danhsachbieumauchucvu.dart';
import 'package:flutter_login_api/screens/kiemduyetbieumau/timkiem.dart';
import 'package:flutter_login_api/screens/main/components/side_menu.dart';
import 'package:flutter_login_api/screens/trangchu/canhan/giaodien.dart';
import 'package:flutter_login_api/screens/trangchu/truongphong/truongphong.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;

const String manLookRightImageUrl =
    'https://jobsgo.vn/blog/wp-content/uploads/2021/10/truong-phong-1.jpg';
const String dogImageUrl =
    'https://png.pngtree.com/png-clipart/20230330/original/pngtree-form-line-icon-png-image_9010067.png';
const String womanLookLeftImageUrl =
    'https://file1.hutech.edu.vn/file/news/986313495f7bf5afbb3077e00e8444ed.png';

final kGreyBackground = Colors.grey[200];

class TrangChuCap extends StatefulWidget {
  final String userEmail;
  final String displayName;
  final String? photoURL;

  const TrangChuCap({
    Key? key,
    required this.userEmail,
    required this.displayName,
    this.photoURL,
  }) : super(key: key);

  @override
  State<TrangChuCap> createState() => _TrangChuBMState();
}

class _TrangChuBMState extends State<TrangChuCap> {
  late String searchString;
  List<Widget> searchResultTiles = [];
  List<ChucDanh> chucDanhs = [];
  bool isLoading = true;
  final TextEditingController _yearController = TextEditingController();
  int currentYear = DateTime.now().year;
  bool _isLoading = false;
  Map<String, String> statusMap = {};
  late int resultParam;
  List<charts.Series<ChartData, String>> _chartDataBM = [];
  List<charts.Series<ChartData, String>> _chartDataBV = [];
  late int ketqua;
  @override
  void initState() {
    searchString = '';
    super.initState();
    _fetchChucDanh();
    _yearController.text = currentYear.toString();
  }

  Future<void> _fetchChucDanh() async {
    try {
      final usuarioProvider =
          Provider.of<Usuario_provider>(context, listen: false);
      await usuarioProvider.getChucdanh();
      setState(() {
        chucDanhs = usuarioProvider.chucdanh;
        isLoading = false;
      });
      //await _trangthai();
    } catch (error) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void setSearchString(String value) => setState(() {
        searchString = value;
      });

  Future<int> checkKpiStatusBM(BuildContext context) async {
    final year = int.tryParse(_yearController.text);
    chucDanhs = chucDanhs.toSet().toList();
    for (var chucdanh in chucDanhs) {
      int trangthai =
          await Provider.of<Usuario_provider2>(context, listen: false)
              .CheckNamPhieuKpiKP(year!, chucdanh.maChucDanh);
      resultParam = trangthai;
    }
    return resultParam;
  }

  Future<int> checkKpiStatus(BuildContext context) async {
    final year = int.tryParse(_yearController.text);
    int resultParam =
        await Provider.of<Usuario_provider1>(context, listen: false)
            .CheckNamPhieuKpiBV(year!);
    return resultParam;
  }

  Future<void> _generateCharts(BuildContext context) async {
    final year = int.tryParse(_yearController.text);
    if (year != null) {
      List<ChartData> chartData = [];

      for (var chucdanh in chucDanhs) {
        int result =
            await Provider.of<Usuario_provider2>(context, listen: false)
                .CheckNamPhieuKpiKP(year, chucdanh.maChucDanh);
        ketqua = result;
        if (result == 0 || result == 1 || result == 2 || result == 4) {
          // Đã tạo
          chartData.add(ChartData(chucdanh.maChucDanh, 1)); // Biểu thị 'Đã tạo'
        } else if (result == 3) {
          // Chưa tạo
          chartData
              .add(ChartData(chucdanh.maChucDanh, 3)); // Biểu thị 'Chưa tạo'
        }
      }

      setState(() {
        _chartDataBM = [
          charts.Series<ChartData, String>(
            id: 'StatusBM',
            domainFn: (ChartData data, _) => data.label,
            measureFn: (ChartData data, _) => data.value,
            data: chartData,
            colorFn: (ChartData data, _) => charts.ColorUtil.fromDartColor(
              data.value == 1 && ketqua != 3
                  ? Colors.green
                  : Colors.red, // Màu xanh cho 'Đã tạo', màu đỏ cho 'Chưa tạo'
            ),
          ),
        ];
      });

      // Dữ liệu từ hàm checkKpiStatus
      int resultBV = await checkKpiStatus(context);
      int createdBV =
          (resultBV == 0 || resultBV == 1 || resultBV == 2 || resultBV == 4)
              ? 1
              : 0;
      int notCreatedBV = (resultBV == 3) ? 1 : 0;

      setState(() {
        _chartDataBV = [
          charts.Series<ChartData, String>(
            id: 'StatusBV',
            domainFn: (ChartData data, _) => data.label,
            measureFn: (ChartData data, _) => data.value,
            data: [
              ChartData('Đã tạo', createdBV),
              ChartData('Chưa tạo', notCreatedBV),
            ],
            colorFn: (ChartData data, _) => charts.ColorUtil.fromDartColor(
              data.label == 'Đã tạo' ? Colors.green : Colors.red,
            ),
          ),
        ];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var listViewPadding =
        const EdgeInsets.symmetric(horizontal: 16, vertical: 24);
    return Scaffold(
      backgroundColor: bgColor,
      drawer: MediaQuery.of(context).size.width < 600 ?  SideMenu( userEmail: widget.userEmail,
                    displayName: widget.displayName,
                    photoURL: widget.photoURL!,) : null,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 600) {
            return Row(
              children: [
                // Thanh bên trái (SideMenu)
                Container(
                  width: 250, // Đặt chiều rộng cố định cho SideMenu
                  child: _buildSideMenu(),
                ),

                // Nội dung bên phải
                Expanded(
                  child: Padding(
                    padding: listViewPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Ô nhập năm và nút xem biểu đồ
                        TextField(
                          controller: _yearController,
                          decoration: InputDecoration(
                            labelText: 'Nhập năm',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => _generateCharts(context),
                          child: Text('Xem Biểu Đồ'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor:
                              const Color.fromARGB(255, 110, 187, 117),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                      ),
                        SizedBox(height: 24),

                        // Biểu đồ đặt cạnh nhau
                        Row(
                          children: [
                          
                            // Khoảng cách giữa hai biểu đồ
                            Flexible(
                              child: Container(
                                height: 100, // Đặt chiều cao cho biểu đồ
                                child: _chartDataBV.isNotEmpty
                                    ? charts.BarChart(_chartDataBV)
                                    : Center(
                                        child: Text(
                                            'Chưa có dữ liệu cho biểu đồ khoa phòng')),
                              ),
                            ),
                             SizedBox(width: 16),
                              Flexible(
                              child: Container(
                                height: 100, // Đặt chiều cao cho biểu đồ
                                child: _chartDataBM.isNotEmpty
                                    ? charts.BarChart(_chartDataBM)
                                    : Center(
                                        child: Text(
                                            'Chưa có dữ liệu cho biểu đồ chức danh')),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                            height:
                                16), // Khoảng cách giữa biểu đồ và chú thích
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Container(
                                    width: 16, height: 16, color: Colors.green),
                                SizedBox(width: 4),
                                Text('Đã tạo'),
                              ],
                            ),
                            SizedBox(
                                width: 16), // Khoảng cách giữa hai chú thích
                            Row(
                              children: [
                                Container(
                                    width: 16, height: 16, color: Colors.red),
                                SizedBox(width: 4),
                                Text('Chưa tạo'),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                            height: 24), // Khoảng cách giữa biểu đồ và nội dung

                        // Nội dung thêm bên dưới
                        Expanded(
                          child: Center(
                            child: _buildContent(listViewPadding),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 16.0),
                  child: _buildContent(listViewPadding),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: IconButton(
                    icon: const Icon(Icons.menu, size: 32, color: Colors.black),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildSideMenu() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.2,
      color: bgColor1,
      child: Column(
        children: [
          DrawerHeader(
            child: Image.asset(
                "assets/images/Tiêu_đề_Website_BV_16_-removebg-preview.png"),
          ),
          DrawerListTile(
            title: "KPI",
            svgSrc: "assets/icons/menu_dashboard.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "Tài liệu",
            svgSrc: "assets/icons/menu_doc.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "Thông báo",
            svgSrc: "assets/icons/menu_notification.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "Thông tin cá nhân",
            svgSrc: "assets/icons/menu_profile.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "Cài đặt",
            svgSrc: "assets/icons/menu_setting.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "Quay lại",
            svgSrc: "assets/icons/menu_setting.svg",
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Giaodien1(
                    userEmail: widget.userEmail,
                    displayName: widget.displayName,
                    photoURL: widget.photoURL!,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContent(EdgeInsets listViewPadding) {
    return searchString.isNotEmpty
        ? GridView.count(
            padding: listViewPadding,
            crossAxisCount: 2, // Số cột của lưới
            mainAxisSpacing: 20, // Khoảng cách giữa các hàng
            crossAxisSpacing: 20, // Khoảng cách giữa các cột
            childAspectRatio: 1.0, // Tỉ lệ khung hình để tạo hình vuông
            children: searchResultTiles,
          )
        : GridView.count(
            padding: listViewPadding,
            crossAxisCount: 2, // Số cột của lưới
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 1.0, // Tỉ lệ khung hình để tạo hình vuông
            children: [
              _buildUserTile(
                imageUrl: manLookRightImageUrl,
                title: 'Khoa phòng',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CapKpiKP(
                      userEmail: widget.userEmail ?? '',
                      displayName: widget.displayName ?? '',
                      photoURL: widget.photoURL ?? '',
                    ),
                  ),
                ),
              ),
              _buildUserTile(
                imageUrl: womanLookLeftImageUrl,
                title: 'Biểu mẫu Cá nhân',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CapKPIBMCV(
                      userEmail: widget.userEmail,
                      displayName: widget.displayName,
                      photoURL: widget.photoURL,
                    ),
                  ),
                ),
              ),
            ],
          );
  }

  Widget _buildUserTile(
      {required String imageUrl,
      required String title,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4.0,
              spreadRadius: 1.0,
              offset: Offset(2, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              imageUrl,
              color: kGreyBackground,
              colorBlendMode: BlendMode.darken,
              alignment: Alignment.topCenter,
              fit: BoxFit.cover,
            ),
            Container(
              color: Colors.black.withOpacity(0.5),
              alignment: Alignment.center,
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChartData {
  final String label;
  final int value;

  ChartData(this.label, this.value);
}
