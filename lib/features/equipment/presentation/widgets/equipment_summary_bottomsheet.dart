import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:temple_ui_tools/styling/alignment_extensions.dart';
import 'package:temple_ui_tools/styling/spacing_widgets.dart';
import 'package:temple_ui_tools/utils/utils.dart';

import '../../../../core/util/utils.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../bookings/presentation/widgets/app_text_fields.dart';
import '../../Repository/equipment_repo.dart';
import '../../models/equipment_model.dart';

class EquipmentSummaryBottomsheet extends StatefulWidget {
  const EquipmentSummaryBottomsheet({super.key, required this.selectedItems});

  final List<EquipmentItem> selectedItems;

  static Future<List<EquipmentItem>> show(BuildContext context, List<EquipmentItem> selectedItems) async {
    List<EquipmentItem>? data = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      builder: (BuildContext context) {
        return EquipmentSummaryBottomsheet(
          selectedItems: selectedItems,
        );
      },
    );
    return data ?? [];
  }

  @override
  State<EquipmentSummaryBottomsheet> createState() => _EquipmentSummaryBottomsheetState();
}

class _EquipmentSummaryBottomsheetState extends State<EquipmentSummaryBottomsheet> {
  bool showLoading = false;
  List<EquipmentItem> selectedItems = [];
  List<EquipmentPiece> selectedEquipmentPieces = [];
  List<EquipmentPiece> equipmentPieces = [];
  late TextEditingController dayCoursesTED;

  @override
  void initState() {
    super.initState();
    selectedItems = widget.selectedItems;
    dayCoursesTED = TextEditingController();
    loadCategories();
  }

  Future<void> loadCategories() async {
    showLoading = true;
    equipmentPieces = await EquipmentRepo.fetchEquipmentPieces();
    showLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Screen.height,
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, top: 30),
      color: Colors.white,
      child: Stack(
        children: [
          Column(
            children: [
              buildTitleAndClose(),
              Spacing.h30,
              SizedBox(
                height: Screen.height - 148,
                width: Screen.width,
                child: Column(
                  children: [
                    ...selectedItems.map((item) {
                      return buildEquipmentCard(item).paddingOnly(bottom: 30);
                    }),
                  ],
                ),
              ),
              buildButton(),
              Spacing.h20,
            ],
          ).paddingAll(20).scrollable,
          buildShowLoading(),
        ],
      ),
    );
  }

  Widget buildButton() {
    return Positioned(
      bottom: 0,
      child: SizedBox(
        width: Screen.width,
        child: AppButton.flat(
          text: 'Verify Otp',
          onTap: () {
            if (selectedEquipmentPieces.isNotEmpty) {
            } else {
              showToast('Please select atleast one equipmentId');
            }
          },
          textColor: Colors.white,
          color: (selectedEquipmentPieces.isNotEmpty) ? Colors.black : Colors.grey,
        ).center,
      ),
    );
  }

  Widget buildShowLoading() {
    if (showLoading) {
      return Container(
        height: Screen.height,
        width: Screen.width,
        color: Colors.white,
        child: const CircularProgressIndicator().center,
      );
    }
    return const SizedBox();
  }

  Widget buildEquipmentCard(EquipmentItem item) {
    return Container(
      width: Screen.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade200,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black),
                  color: Colors.white,
                ),
                child: Text(item.name).center,
              ),
              Spacing.w20,
              Column(
                children: [
                  Spacing.h10,
                  buildKeyValuePairs(key: 'Category', value: item.category.name),
                  buildKeyValuePairs(key: 'Equipment', value: item.name),
                  buildKeyValuePairs(
                    key: 'Quantity',
                    value: selectedEquipmentPieces.where((e) => (e.equipmentName == item.name)).length.toString(),
                  ),
                ],
              ),
            ],
          ),
          Spacing.h10,
          AppTextField(
            controller: dayCoursesTED,
            hintText: 'Day courses',
            required: true,
          ),
          Spacing.h20,
          Container(
            height: 50,
            width: Screen.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black),
            ),
            child: Row(
              children: [
                ...equipmentPieces
                    .where((e) => ((e.equipmentName == item.name) && (e.currentRental == null))) // Apply filters here
                    .map(
                  (e) {
                    return InkWell(
                      onTap: () {
                        if (!selectedEquipmentPieces.contains(e)) {
                          selectedEquipmentPieces.add(e);
                        } else {
                          selectedEquipmentPieces.remove(e);
                        }
                        setState(() {});
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(e.equipmentId),
                            if (selectedEquipmentPieces.contains(e))
                              Row(
                                children: [
                                  Spacing.w7,
                                  const Icon(
                                    Icons.close,
                                    size: 15,
                                  ),
                                  Spacing.w5,
                                ],
                              ),
                          ],
                        ).paddingAll(5),
                      ),
                    ).paddingSymmetric(horizontal: 10);
                  },
                ),
              ],
            ),
          ),
        ],
      ).paddingAll(15),
    );
  }

  Widget buildKeyValuePairs({required String key, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 65,
          child: Text(
            key,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 12,
              letterSpacing: 0.3,
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
          ),
        ),
        Spacing.w20,
        SizedBox(
          width: 100,
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
              height: 1.3,
            ),
          ),
        ),
      ],
    ).paddingOnly(bottom: 5);
  }

  Widget buildTitleAndClose() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Selected Equipment',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            if (!showLoading) {
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }
}
