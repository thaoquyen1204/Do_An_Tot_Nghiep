import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_api/providers/usuario_provider2.dart';
import 'package:flutter_login_api/providers/usuario_provider3.dart';
import 'package:flutter_login_api/screens/capkpi/capkpicanhan/capkpicanhan.dart';
import 'package:flutter_login_api/screens/trangchu/canhan/giaodien.dart';
import 'package:flutter_login_api/home_page.dart';
import 'package:flutter_login_api/models/usuario.dart';
import 'package:flutter_login_api/providers/usuario_provider1.dart';
import 'package:flutter_login_api/screens/kpi/danhmuckpi.dart';
import 'package:flutter_login_api/screens/test.dart';
import 'package:flutter_login_api/screens/trangchu/truongphong/truongphong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_api/firebase_options.dart';
import 'package:flutter_login_api/providers/usuario_provider.dart';
import 'package:flutter_login_api/screens/canhan.dart';
import 'package:flutter_login_api/screens/login_screen.dart';

import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Lấy thông tin đăng nhập và route từ SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userEmail = prefs.getString('userEmail');
  String? displayName = prefs.getString('displayName');
   String? photoURL = prefs.getString('photoURL');
  String? initialRoute = prefs.getString('currentRoute') ?? 'login';

  // Kiểm tra nếu người dùng đã đăng nhập
  if (userEmail != null && displayName != null) {
    initialRoute = initialRoute;  // Route trước đó
  } else {
    initialRoute = 'login';  // Chưa đăng nhập, chuyển đến trang đăng nhập
  }

  runApp(MyApp(
    initialRoute: initialRoute,
    userEmail: userEmail,
    displayName: displayName,
    photoURL :photoURL,
  ));
}
   
class MyApp extends StatelessWidget {
  final String? initialRoute;
  final String? userEmail;
  final String? displayName;
  final String? photoURL;

  const MyApp({Key? key, this.initialRoute, this.userEmail, this.displayName, this.photoURL})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Usuario_provider()),
         ChangeNotifierProvider(create: (_) => Usuario_provider1()),
          ChangeNotifierProvider(create: (_) => Usuario_provider2()),
          ChangeNotifierProvider(create: (_) => Usuario_provider3()),
      ],
      child: MaterialApp(
        title: 'Material App',
        debugShowCheckedModeBanner: false,
        routes: {
          'login': (_) => const LoginScreen(),
          'google': (_) => const HomePage(),
          // 'test': (_) => Test(),        
          'danhmuc':(_) => Kpi(  userEmail: userEmail ?? '',
            displayName: displayName ?? '',
            photoURL: photoURL ?? ''),  
         'giaodien': (_) => Giaodien(
            userEmail: userEmail ?? '',
            displayName: displayName ?? '',
            photoURL: photoURL ?? '',
          ),
          'giaodien1': (_) => Giaodien1(
            userEmail: userEmail ?? '',
            displayName: displayName ?? '',
            photoURL: photoURL ?? '',
          ),
          'CapKpiCN': (_) => CapKpiCN(
            userEmail: userEmail ?? '',
            displayName: displayName ?? '',
            photoURL: photoURL ?? '',
          ),
        },
        initialRoute: initialRoute,
      ),
    );
  }
}

// Hàm lưu thông tin đăng nhập và route
Future<void> saveUserInfo(User user, String route) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('userEmail', user.email ?? '');
  await prefs.setString('displayName', user.displayName ?? '');
  await prefs.setString('currentRoute', route);
  await prefs.setString('photoURL', user.photoURL ?? '');
}
Future<void> saveUserInfo1(UserInfo1 userInfo, String route) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('userEmail', userInfo.email);
  await prefs.setString('displayName', userInfo.displayName);
  await prefs.setString('currentRoute', route);
  await prefs.setString('photoURL', userInfo.photoURL ?? ''); 
}
class UserInfo1 {
  final String email;
  final String displayName;
  final String? photoURL; // Thêm photoURL vào lớp

  UserInfo1({
    required this.email,
    required this.displayName,
    this.photoURL,
  });

  factory UserInfo1.fromUsuario(Usuario usuario) {
    return UserInfo1(
      email: usuario.gmail,
      displayName: usuario.tenNv,
      photoURL: usuario.hinhAnhNv, // Lấy photoURL từ Usuario
    );
  }
}
