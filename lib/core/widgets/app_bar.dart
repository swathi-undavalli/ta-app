import 'package:flutter/material.dart';

import '../constants/constants.dart';
import 'back_navigation_icon.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({
    super.key,
    required this.heading,
    this.actions,
    this.color,
    this.centerTitle = true,
  });

  final String heading;
  final List<Widget>? actions;
  final Color? color;
  final bool centerTitle;

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 70,
      centerTitle: centerTitle,
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
      actions: actions,
      elevation: 0,
      backgroundColor: color ?? Colors.white,
    );
  }
}
