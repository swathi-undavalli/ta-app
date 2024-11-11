import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:temple_ui_tools/temple_ui_tools.dart';
import 'package:temple_ui_tools/utils/utils.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../models/equipment_model.dart';
import '../widgets/equipment_summary_bottomsheet.dart';
import 'add_edit_equipment_view.dart';

class AllEquipmentView extends StatefulWidget {
  const AllEquipmentView({super.key});

  static Route route() => MaterialPageRoute(
        builder: (context) => const AllEquipmentView(),
      );

  @override
  State<AllEquipmentView> createState() => _AllEquipmentViewState();
}

class _AllEquipmentViewState extends State<AllEquipmentView> {
  List<EquipmentItem> selectedItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background.lightBlue,
      appBar: AppBarWidget(
        heading: 'All Equipment',
        actions: [
          AppButton.miniText(
            text: 'Add',
            textColor: Colors.blue,
            onTap: () {
              Navigator.push(context, AddEditEquipmentView.route(null));
            },
          ),
        ],
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('equipmentItems').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError || snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 15,
                width: 15,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.black,
                ),
              );
            }

            if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
              return SizedBox(
                height: Screen.height,
                child: const Text(
                  'Equipment not found',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ).center,
              );
            }

            return Stack(
              children: [
                SizedBox(
                  height: Screen.height,
                  width: Screen.width,
                  child: Wrap(
                    spacing: 15,
                    runSpacing: 15,
                    children: [
                      ...snapshot.data!.docs.map((DocumentSnapshot document) {
                        EquipmentItem? item = EquipmentItemMapper.fromMap(
                          document.data() as Map<String, dynamic>,
                        );
                        return InkWell(
                          onTap: () {
                            if (!selectedItems.contains(item)) {
                              selectedItems.add(item);
                            } else {
                              selectedItems.remove(item);
                            }
                            setState(() {});
                          },
                          onLongPress: () {
                            Navigator.push(context, AddEditEquipmentView.route(item));
                          },
                          child: Container(
                            height: 95,
                            width: 95,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: (selectedItems.contains(item)) ? Colors.green : Colors.black),
                              color: (selectedItems.contains(item)) ? Colors.green : Colors.white,
                            ),
                            child: Text(item.name).center.paddingAll(10),
                          ),
                        );
                      }),
                    ],
                  ).paddingAll(20).scrollable,
                ),
                if (selectedItems.isNotEmpty) buildButton(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildButton() {
    return Positioned(
      bottom: 30,
      child: SizedBox(
        width: Screen.width,
        child: AppButton.flat(
          width: 200,
          text: '${selectedItems.length}  items  selected',
          onTap: () {
            EquipmentSummaryBottomsheet.show(context, selectedItems);
          },
          textColor: Colors.white,
          color: Colors.black,
        ).center,
      ),
    );
  }
}
