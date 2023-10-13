import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/util/alignment_extensions.dart';
import '../../../../core/constants/assets.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/app_icon_button.dart';

class CheckBoxWidget extends StatefulWidget {
  const CheckBoxWidget({Key? key, required this.onChanged, required this.text, required this.initialValue}) : super(key: key);

  final Function(bool) onChanged;
  final String text;
  final bool initialValue;

  @override
  State<CheckBoxWidget> createState() => _CheckBoxWidgetState();
}

class _CheckBoxWidgetState extends State<CheckBoxWidget> {
  bool isChecked = false;

  @override
  void initState() {
    isChecked = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.text.startsWith('==')) {
      return Text(
        widget.text.replaceFirst('==', ''),
        style: const TextStyle(fontWeight: FontWeight.w700),
      ).paddingOnly(bottom: 15, top: 5).left;
    }
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: Get.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: (isChecked) ? AppColors.text.skyBlue.withOpacity(0.26) : const Color(0xffDADADA).withOpacity(0.26),
        ),
        alignment: Alignment.centerLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                widget.text,
                style: const TextStyle(fontSize: 13.0, height: 1.36, color: Colors.black),
              ).paddingSymmetric(horizontal: 15, vertical: 5),
            ),
            AppIconButton(
              (isChecked) ? AppImages.icons.checkBox : AppImages.icons.box,
              onTap: onTap,
            ).paddingOnly(top: 3, right: 10),
          ],
        ),
      ).paddingOnly(bottom: 6),
    );
  }

  void onTap() {
    setState(() {
      isChecked = !isChecked;
    });
    widget.onChanged(isChecked);
  }
}
