import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:temple_adventures/core/widgets/app-button.dart';
import 'package:temple_adventures/features/boat/models/boat-details.dart';
import 'package:temple_adventures/features/boat/models/boat-model.dart';
import 'package:temple_adventures/features/boat/presentation/widgets/captain-selector-bottomSheet.dart';
import 'package:temple_adventures/features/bookings/presentation/widgets/app-text-fields.dart';
import 'package:temple_adventures/features/conditions/controller/conditions-controller.dart';
import 'package:temple_adventures/features/home/model/employee.dart';
import 'package:intl/intl.dart';

class BoatDetailsBottomSheet extends StatefulWidget {
  const BoatDetailsBottomSheet({
    Key? key,
    required this.selectedDate,
  }) : super(key: key);

  final DateTime selectedDate;

  static Future<BoatDetails?> show(BuildContext context,
      {required DateTime date}) async {
    var data = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (BuildContext context) {
        return BoatDetailsBottomSheet(
          selectedDate: date,
        );
      },
    );

    return data as BoatDetails?;
  }

  @override
  State<BoatDetailsBottomSheet> createState() => _BoatDetailsBottomSheetState();
}

class _BoatDetailsBottomSheetState extends State<BoatDetailsBottomSheet> {
  final CollectionReference employeesCollection =
      FirebaseFirestore.instance.collection('employees');
  Employee? selectedCaptain;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 20,
          left: 25,
          right: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          30,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Add Boat",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ).paddingOnly(top: 8),
              Spacer(),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () async {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          SizedBox(height: 20),
          (selectedCaptain == null)
              ? AppButton.miniFlat(
                  text: "Add Captain",
                  onTap: () async {
                    selectedCaptain = await CaptainSelectorBottomSheet.show(
                      context,
                      initialSelectedCaptain: selectedCaptain,
                    );
                    setState(() {});
                    log(selectedCaptain.toString());
                  },
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Selected Captain :",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        // decoration: TextDecoration.underline
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          selectedCaptain?.name ?? "",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            selectedCaptain =
                                await CaptainSelectorBottomSheet.show(
                              context,
                              initialSelectedCaptain: selectedCaptain,
                            );
                            setState(() {});
                          },
                          child: Text(
                            "Change",
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue,
                                decoration: TextDecoration.underline),
                          ).paddingOnly(left: 10, right: 7),
                        ),
                        Icon(
                          Icons.edit,
                          size: 12,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ],
                ),
          AppTextField(
            hintText: "Boat name",
            errorValidator: () {
              return null;
            },
            validator: (_) {
              return null;
            },
          ),
          AppTextField(
            hintText: "Boat Capacity",
            keyboardType: TextInputType.number,
            errorValidator: () {
              return null;
            },
            validator: (_) {
              return null;
            },
          ),
          SizedBox(height: 20),
          Center(
            child: AppButton.flat(
              height: 50,
              width: 145,
              text: "Submit",
              onTap: () async {
                var d = await FirebaseFirestore.instance
                    .collection("dailyBoats")
                    .doc(DateFormat("dd-MM-yyyy").format(widget.selectedDate))
                    .get();
                Map<String, dynamic>? data = d.data();
                if (data != null) {}
              },
              textColor: Colors.white,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
