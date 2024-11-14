import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';

class BannerContainer extends StatelessWidget {
  final Widget child;
  final double? height;

  const BannerContainer({super.key, required this.child, this.height = 55});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: MediaQuery.of(context).size.width - 32,
      decoration: bannerContainerDecoration,
      child: child,
    );
  }
}
