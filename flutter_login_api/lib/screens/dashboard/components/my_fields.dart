import 'package:flutter_login_api/mausacvakichthuoc/constants1.dart';
import 'package:flutter_login_api/models/MyFiles.dart';
import 'package:flutter_login_api/mausacvakichthuoc/responsive.dart';
import 'package:flutter/material.dart';

import '../../../mausacvakichthuoc/constants.dart';
import 'file_info_card.dart';

class MyFiles extends StatelessWidget {
    final String userEmail;
  final String displayName;
  final String? photoURL;
  const MyFiles({
    Key? key,
    required this.userEmail,
    required this.displayName,
    this.photoURL,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Cá nhân",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            ElevatedButton.icon(
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: defaultPadding * 1.5,
                  vertical:
                      defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
                ),
              ),
              onPressed: () {},
              icon: Icon(Icons.add),
              label: Text("Add New"),
            ),
          ],
        ),
        SizedBox(height: defaultPadding),
       Responsive(
  mobile: FileInfoCardGridView(
    crossAxisCount: _size.width < 650 ? 2 : 4,
    childAspectRatio: _size.width < 650 && _size.width > 350 ? 1.3 : 1,
    userEmail: userEmail,        // Truyền userEmail
    displayName: displayName,    // Truyền displayName
    photoURL: photoURL,          // Truyền photoURL
  ),
  tablet: FileInfoCardGridView(
    userEmail: userEmail,        // Truyền userEmail
    displayName: displayName,    // Truyền displayName
    photoURL: photoURL,          // Truyền photoURL
  ),
  desktop: FileInfoCardGridView(
    childAspectRatio: _size.width < 1400 ? 1.1 : 1.4,
    userEmail: userEmail,        // Truyền userEmail
    displayName: displayName,    // Truyền displayName
    photoURL: photoURL,          // Truyền photoURL
  ),
),
      ],
    );
  }
}

class FileInfoCardGridView extends StatelessWidget {
     final String userEmail;
  final String displayName;
  final String? photoURL;
  const FileInfoCardGridView({
     required this.userEmail,
    required this.displayName,
    this.photoURL,
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: demoMyFiles.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) => FileInfoCard(info: demoMyFiles[index],userEmail: userEmail,
              displayName: displayName,
              photoURL: photoURL),
    );
  }
}
