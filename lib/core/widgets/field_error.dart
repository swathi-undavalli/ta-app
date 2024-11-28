import 'package:flutter/material.dart';

class FieldError extends StatelessWidget {
  const FieldError(this.error, {super.key});

  final String? error;

  @override
  Widget build(BuildContext context) {
    if (error == null) return const SizedBox();
    return Text(
      error!,
      style: TextStyle(color: Colors.red.shade800, fontSize: 12),
    );
  }
}
