import 'package:flutter_login_api/mausacvakichthuoc/responsive.dart';
import 'package:flutter_login_api/screens/dashboard/components/my_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_api/mausacvakichthuoc/constants1.dart';

import 'components/header.dart';

import 'components/recent_files.dart';
import 'components/storage_details.dart';

class DashboardScreen extends StatelessWidget {
  final String userEmail;
  final String displayName;
  final String? photoURL;

  const DashboardScreen({
    Key? key,
    required this.userEmail,
    required this.displayName,
    this.photoURL,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(
              userEmail: userEmail,
              displayName: displayName,
              photoURL: photoURL,
            ),
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      MyFiles(userEmail: userEmail,
              displayName: displayName,
              photoURL: photoURL,),
                      SizedBox(height: defaultPadding),
                      RecentFiles(),
                      if (Responsive.isMobile(context))
                        SizedBox(height: defaultPadding),
                      if (Responsive.isMobile(context)) StorageDetails(userEmail: userEmail,
                    displayName: displayName,
                    photoURL: photoURL!,),
                    ],
                  ),
                ),
                if (!Responsive.isMobile(context))
                  SizedBox(width: defaultPadding),
                if (!Responsive.isMobile(context))
                  Expanded(
                    flex: 2,
                    child: StorageDetails(userEmail: userEmail,
                    displayName: displayName,
                    photoURL: photoURL!,),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}