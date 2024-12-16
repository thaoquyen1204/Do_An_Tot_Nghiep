import 'package:flutter_login_api/mausacvakichthuoc/constants1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_api/models/MyFilesTP.dart';
import 'package:flutter_login_api/screens/capkpi/capkpikhoaphong/capkpi.dart';
import 'package:flutter_login_api/screens/capkpi/trangchucapkpi.dart';
import 'package:flutter_login_api/screens/danhgiakhenthuong/trangchudanhgia.dart';
import 'package:flutter_login_api/screens/kiemduyetbieumau/trangchubm.dart';
import 'package:flutter_login_api/screens/kpi/danhmuckpi.dart';
import 'package:flutter_login_api/screens/quanly/nguoidung.dart';
import 'package:flutter_svg/flutter_svg.dart';


// Trang chuyển hương các nut tren giao dien
class FileInfoCardTP extends StatelessWidget {
     final String userEmail;
  final String displayName;
  final String? photoURL;
  const FileInfoCardTP({
    Key? key,
    required this.userEmail,
    required this.displayName,
    this.photoURL,
    required this.info1,
  }) : super(key: key);
  

  final CloudStorageInfoTP info1;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Điều kiện để điều hướng đến các màn hình khác nhau
        if (info1.title == "Đánh giá KPI") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TrangChuDG(userEmail: userEmail,
                              displayName:displayName,
                              photoURL: photoURL,),
            ),
          );
            } else if (info1.title == "Cấp danh mục KPI khoa phòng") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => TrangChuCap( userEmail: userEmail,
              displayName: displayName,
              photoURL: photoURL,),
            ),
          );
            } else if (info1.title == "Kiểm duyệt biểu mẫu") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => TrangChuBM( userEmail: userEmail,
              displayName: displayName,
              photoURL: photoURL,),
            ),
          );
        } else if (info1.title == "Quản lý thông tin người dùng") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => NguoiDung( userEmail: userEmail,
              displayName: displayName,
              photoURL: photoURL,),
            ),
          );
        } else {
          // Trang mặc định nếu tiêu đề không khớp với các trang đã liệt kê
          Navigator.push(
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
                    color: info1.color!.withOpacity(0.1),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: SvgPicture.asset(
                    info1.svgSrc!,
                    colorFilter: ColorFilter.mode(
                        info1.color ?? Colors.black, BlendMode.srcIn),
                  ),
                ),
                Icon(Icons.more_vert, color: Colors.white54)
              ],
            ),
            Text(
              info1.title!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            ProgressLine(
              color: info1.color,
              percentage: info1.percentage,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${info1.numOfFiles} Files",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Colors.white70),
                ),
                Text(
                  info1.totalStorage!,
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