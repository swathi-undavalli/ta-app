import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:temple_adventures/core/util/spacing-widget.dart';
import 'package:temple_adventures/core/widgets/app-button.dart';
import 'package:temple_adventures/features/boat/models/boat-details.dart';
import 'package:temple_adventures/features/boat/presentation/widgets/counter-widget.dart';
import 'package:temple_adventures/features/bookings/presentation/widgets/app-text-fields.dart';

class InternsBottomSheet extends StatefulWidget {
  final List<Intern> initialSelectedInterns;
  final bool isTanksRequired;

  const InternsBottomSheet({
    Key? key,
    required this.initialSelectedInterns,
    required this.isTanksRequired,
  }) : super(key: key);

  static Future<List<Intern>?> show(BuildContext context,
      {required List<Intern> initialInterns,
      required bool tanksRequired}) async {
    var data = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (BuildContext context) {
        return InternsBottomSheet(
          initialSelectedInterns: initialInterns,
          isTanksRequired: tanksRequired,
        );
      },
    );

    return data as List<Intern>?;
  }

  @override
  State<InternsBottomSheet> createState() => _InternsBottomSheetState();
}

class _InternsBottomSheetState extends State<InternsBottomSheet> {
  late TextEditingController controller;
  List<Intern> interns = [];
  int air = 0;
  int nitrox = 0;

  @override
  void initState() {
    controller = TextEditingController();
    interns = widget.initialSelectedInterns;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          30,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Manage Interns",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ).paddingOnly(top: 8),
              Spacer(),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () async {
                  Navigator.pop(context, interns);
                },
              ),
            ],
          ),
          Wrap(
            alignment: WrapAlignment.start,
            runAlignment: WrapAlignment.start,
            children: interns
                .map((e) => InkWell(
                      onTap: () {
                        interns.remove(e);
                        setState(() {});
                      },
                      child: Container(
                        height: 30,
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.grey,
                            width: 2.0,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "${e.name} ",
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontFamily: "Nunito",
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (widget.isTanksRequired)
                              Text(
                                "(A-${e.air} / N-${e.nitrox})",
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontFamily: "Nunito",
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.close,
                              size: 16,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ))
                .toList(),
            spacing: 10,
            runSpacing: 10,
          ).paddingOnly(left: 15, top: 20),
          AppTextField(
            hintText: "Add intern",
            controller: controller,
            errorValidator: () {
              return null;
            },
            validator: (_) {
              return null;
            },
          ),
          SizedBox(height: 20),
          buildTanks(),
          Container(
            width: Get.width,
            alignment: Alignment.centerRight,
            child: AppButton.miniFlat(
              text: "Add",
              onTap: () {
                if (controller.text.isNotEmpty) {
                  interns.add(
                      Intern(name: controller.text, air: air, nitrox: nitrox));
                  controller.text = "";
                  air = 0;
                  nitrox = 0;
                }
                setState(() {});
              },
            ),
          ),
          Spacing.h20,
        ],
      ).paddingSymmetric(horizontal: 20),
    );
  }

  Widget buildTanks() {
    if (widget.isTanksRequired)
      return Row(
        children: [
          Column(
            children: [
              Text(
                "Nitrox",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ).paddingOnly(bottom: 10),
              CounterWidget(
                key: UniqueKey(),
                onChanged: (int val) {
                  nitrox = val;
                },
                initialValue: nitrox,
              )
            ],
          ),
          Column(
            children: [
              Text(
                "Air",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ).paddingOnly(bottom: 10),
              CounterWidget(
                key: UniqueKey(),
                onChanged: (int val) {
                  air = val;
                },
                initialValue: air,
              )
            ],
          ),
        ],
      );
    return SizedBox();
  }
}
