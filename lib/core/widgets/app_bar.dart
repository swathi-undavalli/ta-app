import 'package:flutter/material.dart';
import '../constants/constants.dart';
import 'back_navigation_icon.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({super.key, required this.heading});

  final String heading;

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 70,
      centerTitle: true,
      title: Text(
        heading,
        style: TextStyle(
          color: AppColors.text.black,
          fontSize: 20,
          fontFamily: AppFonts.nunito,
          fontWeight: FontWeight.normal,
          letterSpacing: 1.2,
        ),
      ),
      leading: const BackNavigationIcon(),
      elevation: 0,
      backgroundColor: AppColors.background.white,
    );
  }
}
