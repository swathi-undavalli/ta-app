import 'dart:developer';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:temple_adventures/core/widgets/app-button.dart';
import 'package:temple_adventures/core/widgets/app-expansion-panel.dart';
import 'package:temple_adventures/core/widgets/bookings_calender_widget/bookings_calender_widget_controller.dart';
import 'package:temple_adventures/features/boat/presentation/screens/chooseBoat-page.dart';
import 'package:temple_adventures/features/bookings/models/booking-model.dart';

import '../../models/boat-passengers-model.dart';

class SelectSeatsWidget extends StatefulWidget {
  final BookingModel bookingModel;

  SelectSeatsWidget(this.bookingModel);

  @override
  State<SelectSeatsWidget> createState() => _SelectSeatsWidgetState();
}

class _SelectSeatsWidgetState extends State<SelectSeatsWidget> {
  BookingsCalenderWidgetLogic bookingCalenderLogic =
      BookingsCalenderWidgetLogic();

  @override
  void initState() {
    bool isSame(DateTime date1, DateTime date2) {
      return (date1.day == date2.day &&
          date1.month == date2.month &&
          date1.year == date2.year);
    }

    for (int i = 0; i < widget.bookingModel.diveDate.length; i++) {
      if (isSame(widget.bookingModel.diveDate[i],
          bookingCalenderLogic.controller.selectedDate)) {
        print("Leaving");
      } else {
        widget.bookingModel.diveDate.removeAt(i);
      }
    }
    getDataFromFirebase(widget.bookingModel.diveDate[0]);

    super.initState();
  }

  getDataFromFirebase(DateTime date) async {
    var d = await FirebaseFirestore.instance
        .collection("coastGuardSlip")
        .doc(DateFormat("dd-MM-yyyy").format(date))
        .get();
    Map<String, dynamic> data = d.data();

    print("hellow");
    if (data != null && data[date.toIso8601String()] != null) {
      BoatPassengersModel boatModel =
          BoatPassengersModel.fromMap(data[date.toIso8601String()]);
      log(boatModel.toMap().toString());
      int count = 0;
      boatModel.passenger.forEach((p) {
        if (p.bookingID == widget.bookingModel.id) {
          count++;
        }
      });
      if (widget.bookingModel.noOfPersons == count) {
        isFilled = true;
      }
    }
    setState(() {
      showLoading = false;
    });
  }

  bool showLoading = true;
  bool isFilled = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: (showLoading)
          ? SizedBox(
              height: 15,
              width: 15,
              child: CircularProgressIndicator(
                strokeWidth: 1,
                color: Colors.black,
              ))
          : AppButton.miniFlat(
              bgColor: isFilled ? Colors.green : Colors.black,
              text: "Select Seats",
              onTap: () {
                Get.toNamed(
                  ChooseBoatPage.id,
                  arguments: widget.bookingModel,
                );
              },
            ).paddingOnly(right: 15),
    );
  }
}
