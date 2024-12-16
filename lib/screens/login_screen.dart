import 'package:flutter/material.dart';
import 'package:flutter_login_api/screens/trangchu/canhan/giaodien.dart';
import 'package:flutter_login_api/main.dart';
import 'package:flutter_login_api/screens/canhan.dart';
import 'package:flutter_login_api/screens/dashboard/components/header.dart';
import 'package:flutter_login_api/screens/main/main_screen.dart';
import 'package:flutter_login_api/screens/trangchu/truongphong/truongphong.dart';
import 'package:provider/provider.dart';
import 'package:flutter_login_api/providers/usuario_provider.dart';
import 'package:flutter_login_api/widgets/input_decoration.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            cajapurpura(size),
            imagePerson(),
            loginform(context),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView loginform(BuildContext context) {
    final usuarioProvider = Provider.of<Usuario_provider>(context);
    var txtCorreo = TextEditingController();
    var txtPassword = TextEditingController();
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 250),
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(horizontal: 30),
            width: double.infinity,
            // height: 450,
            decoration: BoxDecoration(
              // color: const Color.fromARGB(255, 255, 255, 255),
              color: Color.fromARGB(255, 193, 247, 173),
              borderRadius: BorderRadius.circular(25),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 15,
                  offset: Offset(0, 5),
                )
              ],
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Text(
                  'Đăng nhập',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 30),
                Container(
                  child: Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          controller: txtCorreo,
                          decoration: InputDecorations.inputDecoration(
                            hinttext: 'abc123',
                            labeltext: 'Tên tài khoản',
                            icono: const Icon(Icons.alternate_email_rounded),
                          ),
                          // validator: (value) {
                          //   String pattern =
                          //       r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                          //   RegExp regExp = RegExp(pattern);
                          //   return regExp.hasMatch(value ?? '')
                          //       ? null
                          //       : 'Gmail chưa đúng cú  pháp';
                          // },
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          autocorrect: false,
                          obscureText: true,
                          controller: txtPassword,
                          decoration: InputDecorations.inputDecoration(
                            hinttext: '*********',
                            labeltext: 'Mật khẩu',
                            icono: const Icon(Icons.lock_clock_outlined),
                          ),
                          validator: (value) {
                            return (value != null && value.length >= 1)
                                ? null
                                : 'Mật khẩu không được rỗng và có ít nhất 3 kí tự';
                          },
                        ),
                        const SizedBox(height: 30),
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          disabledColor: Colors.grey,
                          color: Color.fromARGB(255, 115, 231, 162),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 80, vertical: 15),
                            child: const Text(
                              'Đăng nhập',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          onPressed: () {
                            var usuario = usuarioProvider.usuarios;
                            try {
                              // Tìm kiếm người dùng dựa trên email và mật khẩu, đồng thời kiểm tra quyền
                              final matchingUser = usuario.firstWhere(
                                (e) =>
                                    e.tenTaiKhoan == txtCorreo.text &&
                                    e.matKhau == txtPassword.text,
                              );

                              final userInfo =
                                  UserInfo1.fromUsuario(matchingUser);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Đăng nhập thành công"),
                                  // duration: Duration(seconds: 2),
                                ),
                              );
// Thêm khoảng thời gian trước khi điều hướng
                              Future.delayed(const Duration(seconds: 2), () {
                                if (matchingUser.maQuyen == 'TKP'|| matchingUser.maQuyen == 'PKP') {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Giaodien1(
                                        userEmail: userInfo.email,
                                        displayName: userInfo.displayName,
                                        photoURL: userInfo.photoURL ??
                                            'https://example.com/default-avatar.png',
                                      ),
                                    ),
                                  );
                                } else if (matchingUser.maQuyen == 'NV') {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Giaodien(
                                        userEmail: userInfo.email,
                                        displayName: userInfo.displayName,
                                        photoURL: userInfo.photoURL ??
                                            'https://example.com/default-avatar.png',
                                      ),
                                    ),
                                  );
                                }
                              });

                              // Lưu thông tin người dùng
                              saveUserInfo1(
                                  userInfo,
                                  matchingUser.maQuyen == 'TKP' ||  matchingUser.maQuyen == 'PKP'
                                      ? 'giaodien1'
                                      : 'giaodien');
                            } catch (e) {
                              print('Không thành công: $e');
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Đăng nhập không thành công"),
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 30),
                        // MaterialButton(
                        //   shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(10)),
                        //   disabledColor: Colors.grey,
                        //   color: Colors.blue,
                        //   child: Container(
                        //     padding: const EdgeInsets.symmetric(
                        //         horizontal: 80, vertical: 15),
                        //     child: const Text(
                        //       'Đăng nhập bằng Google',
                        //       style: TextStyle(color: Colors.white),
                        //     ),
                        //   ),
                        //   onPressed: () {
                        //     _handleGoogleSignIn(context);
                        //   },
                        // ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  SafeArea iconopersonnal() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 30),
        width: double.infinity,
        child: const Icon(
          Icons.person_pin,
          color: Colors.white,
          size: 100,
        ),
      ),
    );
  }

  SafeArea imagePerson() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 30),
        width: double.infinity,
        child: SizedBox(
          width: 200, // Chiều rộng mong muốn
          height: 150, // Chiều cao mong muốn
          child: FittedBox(
            fit: BoxFit.contain, // Điều chỉnh ảnh vừa vặn
            child: Image.asset(
              'assets/images/Tiêu đề Website BV(16).png', // Đường dẫn ảnh
            ),
          ),
        ),
      ),
    );
  }

  Container cajapurpura(Size size) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(144, 238, 144, 1), // Màu xanh lá nhạt (light green)
            Color.fromRGBO(34, 139, 34, 1) // Màu xanh lá đậm (forest green)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      width: double.infinity,
      height: size.height * 0.4,
      child: Stack(
        children: [
          Positioned(child: burbuja(), top: 90, left: 30),
          Positioned(child: burbuja(), top: -40, left: -30),
          Positioned(child: burbuja(), top: -50, right: -20),
          Positioned(child: burbuja(), bottom: -50, left: 10),
          Positioned(child: burbuja(), bottom: -40, right: 20),
        ],
      ),
    );
  }

  Container burbuja() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(25), // Giảm bán kính để tạo hình vuông bo góc
        color: const Color.fromRGBO(255, 255, 255, 0.1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 5,
            offset: const Offset(0, 5),
          ),
        ],
      ),
    );
  }

  void _handleGoogleSignIn(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        User? user = userCredential.user;

        if (user != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
            'displayName': user.displayName,
            'email': user.email,
            'photoURL': user.photoURL,
            'lastSignInTime': user.metadata.lastSignInTime,
          });

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Giaodien(
                userEmail: user.email ?? '',
                displayName: user.displayName ?? '',
                photoURL: user.photoURL ?? '',
              ),
            ),
          );

          // Lưu thông tin người dùng (nếu cần)
          saveUserInfo(user, 'giaodien');
        }
      }
    } catch (e) {
      print("Error signing in with Google: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to sign in with Google: $e"),
        ),
      );
    }
  }
}
