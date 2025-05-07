import 'package:flutter/material.dart';
import 'app_button.dart';

class CustomAlertDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  final String title;
  final String content;

  const CustomAlertDialog({super.key, required this.onConfirm, required this.title, required this.content});

  static Future<void> show(BuildContext context,
      {required VoidCallback onConfirm, required String title, required String content}) {
    return showDialog(
      context: context,
      builder: (context) => CustomAlertDialog(
        onConfirm: onConfirm,
        title: title,
        content: content,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      content: Text(
        content,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      actions: <Widget>[
        AppButton.miniFlat(
          isSecondary: true,
          text: 'Cancel',
          onTap: () {
            Navigator.pop(context);
          },
        ),
        AppButton.miniFlat(
          text: 'Okay',
          onTap: () {
            onConfirm();
          },
        ),
      ],
    );
  }
}
