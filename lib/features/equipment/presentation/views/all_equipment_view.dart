import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';
import 'add_equipment_view.dart';

class AllEquipmentView extends StatefulWidget {
  const AllEquipmentView({super.key});

  static Route route() => MaterialPageRoute(
        builder: (context) => const AllEquipmentView(),
      );

  @override
  State<AllEquipmentView> createState() => _AllEquipmentViewState();
}

class _AllEquipmentViewState extends State<AllEquipmentView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        backgroundColor: AppColors.background.black,
        onPressed: () {
          Navigator.push(context, AddEquipmentView.route());
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: SafeArea(
        child: Container(),
      ),
    );
  }
}
