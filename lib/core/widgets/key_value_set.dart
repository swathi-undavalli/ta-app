import 'package:flutter/material.dart';
import 'package:temple_ui_tools/utils/utils.dart';

class KeyValueSets extends StatelessWidget {
  final String title;
  final String? value;
  final Color? valueColor;
  final Color? titleColor;
  final double spacing;
  final TextStyle? titleStyle;
  final TextStyle? valueStyle;
  final double? titleHeight;
  final double? valueHeight;
  const KeyValueSets({
    super.key,
    required this.title,
    this.value,
    this.valueColor,
    this.titleColor,
    this.spacing = 0,
    this.titleStyle,
    this.valueStyle,
    this.titleHeight,
    this.valueHeight,
  });

  @override
  Widget build(BuildContext context) {
    String val = '';
    if (value == null || value!.isEmpty) {
      val = '-';
    } else {
      val = value!;
    }
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            height: titleHeight ?? 32,
            width: Screen.width,
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: titleStyle ??
                  TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                    height: 1.36,
                    color: Colors.grey,
                  ),
            ),
          ),
        ),
        // Spacing.w20,
        SizedBox(
          width: spacing,
        ),
        Expanded(
          flex: 1,
          child: Container(
            width: 180,
            height: valueHeight ?? 32,
            alignment: Alignment.centerLeft,
            child: Text(
              val,
              overflow: TextOverflow.ellipsis,
              style: valueStyle ??
                  TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                    height: 1.36,
                    color: Colors.grey,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}
