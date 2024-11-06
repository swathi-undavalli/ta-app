import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_ui_tools/styling/alignment_extensions.dart';

import '../constants/constants.dart';
import 'ta_image.dart';

// ignore: must_be_immutable
class AppIconButton extends StatelessWidget {
  AppIconButton(
    this.icon, {
    required this.onTap,
    super.key,
    this.iconSize = 24,
    this.text = '',
    this.color,
    this.bgColor,
  });
  Function onTap;
  String icon;
  double iconSize;
  String text;
  Color? color;
  Color? bgColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: AppColors.text.grey,
      radius: 100,
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        onTap();
      },
      child: Column(
        children: [
          Container(
            height: iconSize,
            width: iconSize,
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(iconSize * 2)),
            child: TAImage(
              icon,
              height: iconSize,
              width: iconSize,
              color: color,
            ).paddingAll((bgColor == null) ? 0 : 10).center,
          ).paddingAll(3),
          if (text.isNotEmpty)
            Text(
              text,
              textAlign: TextAlign.center,
              // style: AppTypography.FF1_OverLine_Heavy.copyWith(
              //     color: Colors.black.withOpacity(0.3)),
            ).paddingOnly(top: 11),
        ],
      ),
    );
  }
}
