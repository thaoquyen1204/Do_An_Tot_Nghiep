import 'package:flutter/material.dart';
import 'package:flutter_login_api/screens/login_screen.dart';
class CaNhan extends StatefulWidget {
  final String userEmail;
  final String displayName;
  final String? photoURL;
  const CaNhan({required this.userEmail, required this.displayName, this.photoURL});

  @override
  _CaNhanState createState() => _CaNhanState();
}

class _CaNhanState extends State<CaNhan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 70,
              height: 70,
              child: Image.asset(
                  'assets/images/Tiêu_đề_Website_BV_16_-removebg-preview.png'),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.notifications),
                  onPressed: () {},
                ),
                // IconButton(
                //   icon: Icon(Icons.menu),
                //   onPressed: () {
                //     Scaffold.of(context).openDrawer();
                    
                //   },
                // ),
              ],
            ),
          ],
        ),
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Cá nhân',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Trang chủ'),
              onTap: () {
                // thêm hành động
              },
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Thông tin cá nhân'),
              onTap: () {
                  //Navigator.pushReplacementNamed(context, 'login');
              },
            ),
            // ListTile(
            //   leading: Icon(Icons.settings),
            //   title: Text('Settings'),
            //   onTap: () {
            //     // thêm hành động
            //   },
            // ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Đăng xuất'),
              onTap: () {
                   Navigator.pushReplacementNamed(context, 'login');
              },
            ),

             
          ],
        ),
      ),
      body:Stack(
        children: [
          // Ảnh nền mờ
          Positioned.fill(
            //child: ColorFiltered(
            //   colorFilter: ColorFilter.mode(
            //     Colors.black.withOpacity(0.5), // Màu đen mờ
            //     BlendMode.darken, // Phủ màu đen lên ảnh để làm mờ
            //   ),
              child: Image.asset(
                'assets/images/anhbia.jpg', // Đường dẫn tới ảnh nền của bạn
                fit: BoxFit.cover, // Đảm bảo ảnh nền bao phủ toàn bộ màn hình
              ),
            ),
          //),
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Row(
              children: [
                  Text(widget.displayName,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                // Text(widget.userEmail,
                // style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                //  ),
                Spacer(),
                 if (widget.photoURL != null)
                CircleAvatar(
              backgroundImage: NetworkImage(widget.photoURL!),
              radius: 20,
            ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search destinations...',
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                ),
              ),
            ),
            SizedBox(height: 16),
            Wrap(
              spacing: 8.0,
              children: [
                _buildCategoryButton(Icons.home, 'KPI'),
                _buildCategoryButton(Icons.people, 'Người dùng'),
                _buildCategoryButton(Icons.settings, 'Cài đặt hệ thống'),
                _buildCategoryButton(Icons.phone, 'Liên lạc'),
                
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: 3, // Adjust the number of items
                itemBuilder: (context, index) {
                  return _buildDestinationCard(
                      'Museum of Natural History', '\$10', 'assets/museum.png');
                },
              ),
            ),
          ],
        ),
      ),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(IconData icon, String label) {
    return OutlinedButton.icon(
      icon: Icon(icon),
      label: Text(label),
      onPressed: () {},
    );
  }

  Widget _buildDestinationCard(String title, String price, String image) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Image.asset(image),
        title: Text(title),
        subtitle: Text('Price is: $price'),
      ),
    );
  }
}
