import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/widgets/back_navigation_icon.dart';

class RoasterView extends StatefulWidget {
  const RoasterView({super.key});
  static String id = 'RoasterView';
  @override
  State<RoasterView> createState() => _RoasterViewState();
}

class _RoasterViewState extends State<RoasterView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background.lightBlue,
      appBar: const AppBarWidget(heading: 'Roaster'),
      body: const SafeArea(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
