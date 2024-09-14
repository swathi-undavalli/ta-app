import 'package:flutter/material.dart';

import '../constants/constants.dart';

class BackNavigationIcon extends StatelessWidget {
  const BackNavigationIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: TextButton(
        onPressed: () {
          Navigator.pop(context);
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
