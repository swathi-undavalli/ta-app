import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/constants.dart';

class BackNavigationIcon extends StatelessWidget {
  const BackNavigationIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: TextButton(
        onPressed: () {
          Get.back();
        },
        child: Icon(
          Icons.arrow_back_ios,
          color: AppColors.text.black,
          size: 17,
        ),
      ),
    );
  }
}
