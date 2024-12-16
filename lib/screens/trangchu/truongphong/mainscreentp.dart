import 'package:flutter_login_api/controllers/MenuAppController.dart';
import 'package:flutter_login_api/mausacvakichthuoc/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_api/screens/trangchu/truongphong/dashboardscreentp.dart';
import 'package:provider/provider.dart';

import 'package:flutter_login_api/screens/main/components/side_menu.dart';
class MainScreenTP extends StatefulWidget {
  final String userEmail;
  final String displayName;
  final String? photoURL;

  const MainScreenTP({
    Key? key,
    required this.userEmail,
    required this.displayName,
    this.photoURL,
  }) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreenTP> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuAppController>().scaffoldKey,
      drawer: SideMenu( userEmail: widget.userEmail,
                    displayName: widget.displayName,
                    photoURL: widget.photoURL!,),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              Expanded(
                child: SideMenu( userEmail: widget.userEmail,
                    displayName: widget.displayName,
                    photoURL: widget.photoURL!,),
              ),
            Expanded(
              flex: 5,
              child: DashboardScreenTP(
                userEmail: widget.userEmail,
                displayName: widget.displayName,
                photoURL: widget.photoURL,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
