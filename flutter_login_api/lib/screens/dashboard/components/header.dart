import 'package:flutter_login_api/mausacvakichthuoc/constants1.dart';
import 'package:flutter_login_api/controllers/MenuAppController.dart';
import 'package:flutter_login_api/mausacvakichthuoc/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class Header extends StatefulWidget {
  final String userEmail;
  final String displayName;
  final String? photoURL;

  const Header({
    Key? key,
    required this.userEmail,
    required this.displayName,
    this.photoURL,
  }) : super(key: key);

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!Responsive.isDesktop(context))
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: context.read<MenuAppController>().controlMenu,
          ),
        if (!Responsive.isMobile(context))
          Text(
            "Trang chủ",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        if (!Responsive.isMobile(context))
          Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
        Expanded(child: SearchField()),
        ProfileCard(
          displayName: widget.displayName,
          photoURL: widget.photoURL,
        ),
      ],
    );
  }
}

class ProfileCard extends StatelessWidget {
  final String displayName;
  final String? photoURL;

  const ProfileCard({
    Key? key,
    required this.displayName,
    this.photoURL,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: defaultPadding),
      padding: EdgeInsets.symmetric(
        horizontal: defaultPadding,
        vertical: defaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Color.fromARGB(26, 250, 248, 248)),
      ),
      child: Row(
        children: [
          if (photoURL != null)
            CircleAvatar(
              backgroundImage: NetworkImage(photoURL!),
              radius: 20,
            )
          else
            CircleAvatar(
              backgroundImage: AssetImage("assets/images/profile_pic.png"),
              radius: 20,
            ),
          if (!Responsive.isMobile(context))
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
              child: Text(
                displayName,
                style: TextStyle(color: const Color.fromARGB(255, 19, 18, 18)),
              ),
            ),
          Icon(Icons.keyboard_arrow_down),
        ],
      ),
      
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: "Tìm kiếm",
        fillColor: black,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        suffixIcon: InkWell(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.all(defaultPadding * 0.75),
            margin: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: SvgPicture.asset("assets/icons/Search.svg"),
          ),
        ),
      ),
    );
  }
}
