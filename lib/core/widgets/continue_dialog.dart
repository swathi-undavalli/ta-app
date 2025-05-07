import 'package:flutter/material.dart';

import '../constants/constants.dart';
import 'app_button.dart';

class ContinueDialog extends StatefulWidget {
  const ContinueDialog({
    super.key,
    required this.title,
    required this.content,
  });

  final String title, content;

  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String content,
  }) async {
    return await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return ContinueDialog(
              title: title,
              content: content,
            );
          },
        ) ??
        false;
  }

  @override
  State<ContinueDialog> createState() => _ContinueDialogState();
}

class _ContinueDialogState extends State<ContinueDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.title,
        style: TextStyle(
          color: AppColors.text.black,
          fontFamily: AppFonts.nunito,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        widget.content,
        style: TextStyle(
          color: AppColors.text.black,
          fontFamily: AppFonts.nunito,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: [
        AppButton.miniFlat(
          isSecondary: true,
          text: 'Cancel',
          onTap: () {
            Navigator.pop(context, false);
          },
        ),
        AppButton.miniFlat(
          text: 'OK',
          onTap: () {
            Navigator.pop(context, true);
          },
        ),
      ],
    );
  }
}
