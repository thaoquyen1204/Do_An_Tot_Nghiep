import 'package:flutter_login_api/main.dart';
import 'package:flutter_login_api/mausacvakichthuoc/constants1.dart';
import 'package:flutter_login_api/models/MyFiles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_api/screens/capkpi/capkpicanhan/capkpicanhan.dart';
import 'package:flutter_login_api/screens/danhgiakhenthuong/trangchudanhgia.dart';
import 'package:flutter_login_api/screens/danhgiakhenthuong/trangchudanhgiaCN.dart';
import 'package:flutter_login_api/screens/kiemduyetbieumau/canhan/xembieumaucanhan.dart';
import 'package:flutter_login_api/screens/kiemduyetbieumau/trangchubmcn.dart';
import 'package:flutter_login_api/screens/kpi/danhmuckpi.dart';
import 'package:flutter_login_api/screens/nguoidung/trangchuthongtincanhan.dart';
import 'package:flutter_login_api/screens/quanly/nguoidung.dart';
import 'package:flutter_svg/flutter_svg.dart';


// Trang chuyển hương các nut tren giao dien
class FileInfoCard extends StatelessWidget {
   final String userEmail;
  final String displayName;
  final String? photoURL;
  const FileInfoCard({
    Key? key,
    required this.userEmail,
    required this.displayName,
    this.photoURL,
    required this.info,
  }) : super(key: key);
  

  final CloudStorageInfo info;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Điều kiện để điều hướng đến các màn hình khác nhau
        if (info.title == "Danh sách xét duyệt") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TrangChuDGCN(userEmail: userEmail,
                              displayName:displayName,
                              photoURL: photoURL,),
            ),
          );
          } else if (info.title == "Biễu mẫu KPI") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => TrangChuBMCN( userEmail: userEmail,
              displayName: displayName,
              photoURL: photoURL,),
            ),
          );
        } else if (info.title == "Thông tin cá nhân") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => XemTTNguoidung( userEmail: userEmail,
              displayName: displayName,
              photoURL: photoURL,),
            ),
          );
           } else if (info.title == "Cấp KPI cá nhân") {
              saveUserInfo1(
    UserInfo1(email: userEmail, displayName: displayName, photoURL: photoURL),
    'CapKpiCN' // route hiện tại
  );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CapKpiCN(userEmail: userEmail,
                displayName: displayName,
                photoURL: photoURL,),
            ),
          );
        } else {
          // Trang mặc định nếu tiêu đề không khớp với các trang đã liệt kê
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DefaultScreen(),
            ),
          );
        }
      },
      child: Container(
        padding: EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(defaultPadding * 0.75),
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: info.color!.withOpacity(0.1),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: SvgPicture.asset(
                    info.svgSrc!,
                    colorFilter: ColorFilter.mode(
                        info.color ?? Colors.black, BlendMode.srcIn),
                  ),
                ),
                Icon(Icons.more_vert, color: Colors.white54)
              ],
            ),
            Text(
              info.title!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            ProgressLine(
              color: info.color,
              percentage: info.percentage,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${info.numOfFiles} Files",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Colors.white70),
                ),
                Text(
                  info.totalStorage!,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Colors.white),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

// Các màn hình khác nhau
class KPIScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("KPI List"),
      ),
      body: Center(
        child: Text("Hiển thị Danh sách KPI"),
      ),
    );
  }
}

class UserManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quản lý người dùng"),
      ),
      body: Center(
        child: Text("Hiển thị Quản lý người dùng"),
      ),
    );
  }
}

class DefaultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trang mặc định"),
      ),
      body: Center(
        child: Text("Trang mặc định"),
      ),
    );
  }
}

// ProgressLine Widget
class ProgressLine extends StatelessWidget {
  const ProgressLine({
    Key? key,
    this.color = primaryColor,
    required this.percentage,
  }) : super(key: key);

  final Color? color;
  final int? percentage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 5,
          decoration: BoxDecoration(
            color: color!.withOpacity(0.1),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) => Container(
            width: constraints.maxWidth * (percentage! / 100),
            height: 5,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }
}