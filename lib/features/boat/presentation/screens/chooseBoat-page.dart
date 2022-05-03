import 'dart:developer';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/widgets/back-navigation-icon.dart';
import 'package:temple_adventures/features/boat/controller/newBoat-controller.dart';
import 'package:temple_adventures/features/boat/models/boat-passengers-model.dart';
import 'package:temple_adventures/features/boat/presentation/widgets/seatsAvailabiltyWidget.dart';
import 'package:temple_adventures/features/bookings/controller/new-booking-controller.dart';
import 'package:temple_adventures/features/bookings/models/booking-model.dart';
import 'package:temple_adventures/features/counter-model.dart';

class ChooseBoatPage extends StatelessWidget {
  static const String id = "ChooseBoatPage";

  SeatsAvailabilityExpansionPanel boat1 = SeatsAvailabilityExpansionPanel(1);
  SeatsAvailabilityExpansionPanel boat2 = SeatsAvailabilityExpansionPanel(2);
  SeatsAvailabilityExpansionPanel boat3 = SeatsAvailabilityExpansionPanel(3);
  SeatsAvailabilityExpansionPanel boat4 = SeatsAvailabilityExpansionPanel(4);

  ChooseBoatPage({this.selectedSeatsCount});

  int selectedSeatsCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        onPressed: () async {
          print("boat1:${boat1.selectedSeats}");
          print("boat2:${boat2.selectedSeats}");
          print("boat3:${boat3.selectedSeats}");
          print("boat4:${boat4.selectedSeats}");
          print("boat1:${boat1.selectedEmployees}");
          print("boat2:${boat2.selectedEmployees}");
          print("boat3:${boat3.selectedEmployees}");
          print("boat4:${boat4.selectedEmployees}");

          BoatPassengersModel boatPassengersModel = BoatPassengersModel();
          NewBookingLogic newBookingLogic = NewBookingLogic();

          newBookingLogic.controller.bookingModel = BookingModel(pax: [
            {
              "first-name": "sahitha",
              "email": "sahitha@kcn.com",
              "phoneNumber": "5646848487",
            }
          ], diveDate: [
            DateTime.now()
          ]);

          var boats = [boat1, boat2, boat3, boat4];
          for (int j = 0; j < boats.length; j++) {
            var boat = boats[j];
            boatPassengersModel.passengers = [];
            boatPassengersModel.employees = [];
            for (int i = 0; i < boat.selectedSeats.length; i++) {
              boatPassengersModel.passengers.add(Passenger(
                  name: newBookingLogic.controller.bookingModel.pax[0]
                      ["first-name"],
                  gender: "male",
                  phone: newBookingLogic.controller.bookingModel.pax[0]
                      ["phoneNumber"],
                  email: newBookingLogic.controller.bookingModel.pax[0]
                      ["email"]));
            }
            for (int i = 0; i < boat.selectedEmployees.length; i++) {
              var e = boat.selectedEmployees[i];
              boatPassengersModel.employees.add(Employee(
                  id: e.id,
                  name: e.name,
                  gender: e.gender,
                  phone: e.phoneNumber));
            }
            await FirebaseFirestore.instance
                .collection("boats")
                .doc((1 + j).toString())
                .collection("allocation")
                .doc(DateFormat("dd-MM-yyyy").format(
                    newBookingLogic.controller.bookingModel.diveDate[0]))
                .set(boatPassengersModel.toMap());
          }

          // Get.toNamed(ChooseBoatPage.id);
        },
        backgroundColor: AppColors.background.black,
        child: Icon(Icons.arrow_forward_ios_rounded),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                SizedBox(height: 10),
                buildSeatsSelected(),
                SizedBox(height: 40),
                boat1,
                boat2,
                boat3,
                boat4,
                // ...List.generate(counterModel.boat, (index) {
                //   log(index.toString());
                //   return SeatsAvailabilityExpansionPanel(index + 1);
                // }),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSeatsSelected() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Row(
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "$selectedSeatsCount",
                  style: TextStyle(
                      fontSize: 30,
                      fontFamily: AppFonts.nunito,
                      color: AppColors.text.black,
                      fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text: '/6',
                  style: TextStyle(
                      fontSize: 10,
                      fontFamily: AppFonts.nunito,
                      color: AppColors.text.black,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          SizedBox(width: 10),
          Container(
            alignment: Alignment.bottomCenter,
            height: 27,
            child: Text(
              "Selected",
              style: TextStyle(
                color: AppColors.text.skyBlue,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAppBar() {
    return AppBar(
      toolbarHeight: 70,
      centerTitle: true,
      title: Text(
        "Select Seats",
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          letterSpacing: 1.2,
        ),
      ),
      leading: BackNavigationIcon(),
      elevation: 0,
      backgroundColor: AppColors.background.white,
    );
  }
}
