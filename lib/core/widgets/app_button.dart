import 'package:flutter/material.dart';

import '../constants/constants.dart';

class AppButton extends StatelessWidget {
  final String? text;
  final Function? onTap;
  final Color? bgColor;
  final Color? textColor;
  final Color splashColor;
  final double height;
  final double width;
  final double borderRadius;
  final double fontSize;
  final bool enable;

  const AppButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.bgColor,
    required this.textColor,
    required this.splashColor,
    this.height = 31,
    this.width = 100,
    this.borderRadius = 20,
    this.fontSize = 12,
    this.enable = true,
  });

  factory AppButton.miniText({
    String? text,
    Function? onTap,
    Color? textColor,
  }) {
    return AppButton(
      text: text,
      onTap: onTap,
      bgColor: Colors.transparent,
      textColor: textColor ?? AppColors.text.black,
      splashColor: Colors.black.withOpacity(0.2),
    );
  }

  factory AppButton.miniFlat({
    String? text,
    Function? onTap,
    bool enable = true,
    Color bgColor = Colors.black,
    Color textColor = Colors.white,
  }) {
    return AppButton(
      text: text,
      onTap: onTap,
      enable: enable,
      bgColor: bgColor,
      textColor: textColor,
      splashColor: Colors.white.withOpacity(0.2),
    );
  }

  factory AppButton.flat({
    String? text,
    Function? onTap,
    Color? color,
    Color? textColor,
    bool enable = true,
    double height = 50,
    double width = 155,
  }) {
    return AppButton(
      text: text,
      onTap: onTap,
      height: height,
      width: width,
      fontSize: 16,
      enable: enable,
      bgColor: color,
      textColor: textColor,
      splashColor: Colors.white.withOpacity(0.2),
      borderRadius: 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.all(splashColor),
        backgroundColor: WidgetStateProperty.all<Color?>(enable ? bgColor : bgColor!.withOpacity(0.5)),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        minimumSize: WidgetStateProperty.all<Size>(Size(width, height)),
      ),
      onPressed: () {
        if (enable) onTap!();
      },
      child: Text(
        text!,
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
          fontFamily: AppFonts.nunito,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.60,
        ),
      ),
    );
  }
}
