import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/constants.dart';

class EquipmentAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String description;
  final Widget? action;
  final bool hideBackButton;

  const EquipmentAppBar({
    super.key,
    required this.title,
    required this.description,
    this.action,
    this.hideBackButton = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background.black,
      title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          Text(
            description,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ).paddingOnly(top: 10),
      actions: [if (action != null) action!.paddingOnly(top: 16)],
      titleSpacing: 0,
      elevation: 0,
      leadingWidth: hideBackButton ? 40 : 50,
      leading: hideBackButton ? const SizedBox() : null,
    );
  }
}
