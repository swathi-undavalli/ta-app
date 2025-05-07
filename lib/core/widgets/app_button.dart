import 'package:flutter/material.dart';
import 'package:temple_ui_tools/styling/padding_extensions.dart';

import '../constants/constants.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color? buttonColor;
  final double height;
  final double width;
  final double borderRadius;
  final double fontSize;
  final bool showLoading;
  final bool isSecondary;

  const AppButton({
    super.key,
    required this.text,
    required this.onTap,
    this.buttonColor,
    this.height = 31,
    this.width = 100,
    this.borderRadius = 20,
    this.fontSize = 12,
    this.showLoading = false,
    this.isSecondary = false,
  });

  factory AppButton.miniFlat({
    required String text,
    required VoidCallback onTap,
    Color? buttonColor,
    bool showLoading = false,
    bool isSecondary = false,
  }) {
    return AppButton(
      text: text,
      onTap: onTap,
      buttonColor: buttonColor,
      isSecondary: isSecondary,
      showLoading: showLoading,
    );
  }

  factory AppButton.flat({
    required String text,
    required VoidCallback onTap,
    Color? buttonColor,
    bool showLoading = false,
    bool isSecondary = false,
    double height = 50,
    double width = 155,
  }) {
    return AppButton(
      text: text,
      onTap: onTap,
      height: height,
      width: width,
      fontSize: 16,
      showLoading: showLoading,
      isSecondary: isSecondary,
      buttonColor: buttonColor,
      borderRadius: 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.all(Colors.white.withOpacity(0.1)),
        backgroundColor: WidgetStateProperty.all<Color>(
          isSecondary
              ? AppColors.background.disabledGrey
              : buttonColor ?? Colors.black,
        ),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        minimumSize: WidgetStateProperty.all<Size>(
          Size(width, height),
        ),
        padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero),
      ),
      onPressed: showLoading ? null : onTap,
      child: showLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ).paddingHorizontal(10),
    );
  }
}
