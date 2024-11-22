import 'package:flutter_login_api/mausacvakichthuoc/constants1.dart';
import 'package:flutter_login_api/controllers/MenuAppController.dart';
import 'package:flutter_login_api/main.dart';
import 'package:flutter_login_api/screens/main/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Giaodien extends StatelessWidget {
  final String userEmail;
  final String displayName;
  final String photoURL;

  const Giaodien({
    Key? key,
    required this.userEmail,
    required this.displayName,
    required this.photoURL,
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nhân viên',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: const Color.fromARGB(255, 13, 2, 2)),
        canvasColor: secondaryColor, // Color of layout containers
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => MenuAppController(),
          ),
        ],
        child: MainScreen(
          userEmail: userEmail,
          displayName: displayName,
          photoURL: photoURL,
        ),
      ),
      
    );
    
  }
}
