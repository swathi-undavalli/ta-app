import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';

class EquipmentBody extends StatelessWidget {
  final Widget child;

  const EquipmentBody({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.background.lightBlue,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
