import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/widgets/app-button.dart';
import 'package:temple_adventures/features/boat/models/boat-model.dart';
import 'package:temple_adventures/features/boat/models/boat-passengers-model.dart'
    as boatsPassengerModel;
import 'package:temple_adventures/features/boat/presentation/screens/chooseBoat-page.dart';
import 'package:temple_adventures/features/boat/presentation/widgets/bottomSheetWidget.dart';
import 'package:temple_adventures/features/counter-model.dart';

import '../../../../core/widgets/app-expansion-panel.dart';
import '../../../home/model/employee.dart';

class SeatsAvailabilityExpansionPanel extends StatefulWidget {
  final int boatID;
  List<Employee> selectedEmployees = [];
  List<int> selectedSeats = [];

  SeatsAvailabilityExpansionPanel(this.boatID);

  @override
  State<SeatsAvailabilityExpansionPanel> createState() =>
      _SeatsAvailabilityExpansionPanelState();
}

class _SeatsAvailabilityExpansionPanelState
    extends State<SeatsAvailabilityExpansionPanel> {
  bool isExpanded = false;
  int employeeCount = 0;
  bool showLoading = true;
  double bottomSheetHeight;
  TextEditingController searchTED = TextEditingController();
  final SearchController searchController = Get.put(SearchController());
  List<Employee> allEmployeesList = [];
  List<Employee> suggestionsList = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("boats")
            .doc(widget.boatID.toString())
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            BoatsModel boat = BoatsModel.fromMap(snapshot.data.data());
            return buildExpansion(boatsModel: boat);
          }
          return Container();
        });
  }

  Widget buildExpansion({BoatsModel boatsModel}) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("boats")
            .doc(widget.boatID.toString())
            .collection("allocation")
            .doc("02-05-2022")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data.data() != null) {
            boatsPassengerModel.BoatPassengersModel passengerModel =
                boatsPassengerModel.BoatPassengersModel.fromMap(
                    snapshot.data.data());
            print(passengerModel.passengers.length);
            return Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                curve: Curves.easeInCubic,
                alignment: Alignment.topCenter,
                height: isExpanded ? 500 : 50,
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  // border: Border.all(color: AppColors.text.grey),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 100,
                                child: Text(
                                  boatsModel.boatName,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: AppColors.text.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Spacer(),
                              IconButton(
                                splashRadius: 20,
                                iconSize: 23,
                                icon: Icon(isExpanded
                                    ? Icons.keyboard_arrow_up_rounded
                                    : Icons.keyboard_arrow_down_rounded),
                                onPressed: () {
                                  setState(() {
                                    isExpanded = !isExpanded;
                                    log(isExpanded.toString());
                                  });
                                },
                              ),
                            ]),
                      ),
                      isExpanded
                          ? FutureBuilder(
                              future:
                                  Future.delayed(Duration(milliseconds: 200)),
                              initialData: SizedBox(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done)
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 25, right: 25),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(height: 20),
                                        buildSideHeading(text: "Customers"),
                                        SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              // height: 130,
                                              width: 270,
                                              child: Wrap(
                                                  direction: Axis.horizontal,
                                                  verticalDirection:
                                                      VerticalDirection.down,
                                                  children: [
                                                    ...List.generate(
                                                        (passengerModel
                                                            .passengers
                                                            .length), (index) {
                                                      return buildSeat(
                                                          borderColor: AppColors
                                                              .text.skyBlue,
                                                          color: AppColors.text
                                                              .lightSkyBlue,
                                                          seatNoColor: AppColors
                                                              .text.black,
                                                          seatNo: index + 1);
                                                    }),
                                                    ...List.generate(
                                                        (boatsModel.capacity -
                                                            passengerModel
                                                                .passengers
                                                                .length),
                                                        (index) {
                                                      return (buildSeat(
                                                        borderColor:
                                                            Color(0xff5BFF62),
                                                        color:
                                                            Color(0xffD1FFBB),
                                                        seatNoColor:
                                                            AppColors.text.grey,
                                                        seatNo: passengerModel
                                                                .passengers
                                                                .length +
                                                            index +
                                                            1,
                                                      ));
                                                    }),
                                                    // ...selectedSeats.map((e) =>
                                                    //     buildSeat(
                                                    //         borderColor:
                                                    //             AppColors.text
                                                    //                 .skyBlue,
                                                    //         color: AppColors
                                                    //             .text
                                                    //             .lightSkyBlue,
                                                    //         seatNoColor:
                                                    //             AppColors
                                                    //                 .text.black,
                                                    //         seatNo: e)),
                                                    // ...List.generate(
                                                    //     (boatsModel.capacity -
                                                    //         selectedSeats
                                                    //             .length),
                                                    //     (index) {
                                                    //   return buildSeat(
                                                    //       borderColor:
                                                    //           Color(0xff5BFF62),
                                                    //       color:
                                                    //           Color(0xffD1FFBB),
                                                    //       seatNoColor: AppColors
                                                    //           .text.grey,
                                                    //       seatNo: index +
                                                    //           selectedSeats
                                                    //               .length +
                                                    //           1);
                                                    // }),
                                                  ]),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 30),
                                        buildSeatColorRepresentation(
                                            borderColor: AppColors.text.skyBlue,
                                            color: AppColors.text.lightSkyBlue,
                                            text: "Selected"),
                                        SizedBox(height: 15),
                                        buildSeatColorRepresentation(
                                            borderColor: Color(0xff5BFF62),
                                            color: Color(0xffD1FFBB),
                                            text: "Available"),
                                        SizedBox(height: 30),
                                        buildSideHeading(text: "Employees"),
                                        SizedBox(height: 20),
                                        Container(
                                          width: 350,
                                          child: Wrap(
                                              direction: Axis.horizontal,
                                              verticalDirection:
                                                  VerticalDirection.down,
                                              children: [
                                                ...widget.selectedEmployees.map(
                                                    (e) =>
                                                        buildSelectedEmployee(
                                                            e))
                                              ]),
                                        ),
                                        SizedBox(height: 10),
                                        Container(
                                          width: Get.width,
                                          child: AppButton.miniFlat(
                                            onTap: () {
                                              Get.bottomSheet(BottomSheetWidget(
                                                selectedEmployees:
                                                    widget.selectedEmployees,
                                                onEmployeeTapped: (Employee e) {
                                                  setState(() {
                                                    widget.selectedEmployees
                                                        .add(e);

                                                    print("hellooooooo");
                                                  });
                                                },
                                              ));
                                              log("clicked");
                                            },
                                            text: "Add",
                                          ),
                                          alignment: Alignment.centerRight,
                                        )
                                      ],
                                    ),
                                  );
                                return SizedBox();
                              })
                          : SizedBox(),
                    ],
                  ),
                ),
              ),
            );
          }
          return Container();
        });
  }

  Widget buildSelectedEmployee(Employee e) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4, top: 5, bottom: 5),
      child: Container(
        height: 22,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black.withOpacity(0.2), width: 1),
            borderRadius: BorderRadius.circular(11)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  e.firstName,
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ),
            SizedBox(width: 1),
            Padding(
              padding: const EdgeInsets.only(right: 2.0, top: 2, bottom: 2),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    widget.selectedEmployees.remove(e);
                  });
                },
                child: Container(
                  height: 16,
                  width: 16,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black.withOpacity(0.1)),
                  child: Icon(Icons.clear_rounded,
                      size: 12, color: Colors.black.withOpacity(0.6)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildSideHeading({String text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: TextStyle(
            color: Colors.black.withOpacity(0.30),
            fontSize: 10,
            fontWeight: FontWeight.w300,
            letterSpacing: 0.75,
          ),
        ),
        SizedBox(height: 5),
        Container(
          width: Get.width,
          height: 1,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black.withOpacity(0.1)),
          ),
        ),
      ],
    );
  }

  Widget buildSeat(
      {Color borderColor, Color color, int seatNo, Color seatNoColor}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (widget.selectedSeats.contains(seatNo)) {
            widget.selectedSeats.remove(seatNo);
          } else {
            if (widget.selectedSeats.length < 6) {
              setState(() {
                widget.selectedSeats.add(seatNo);
                ChooseBoatPage(selectedSeatsCount: widget.selectedSeats.length);
                print(widget.selectedSeats);
              });
            }
          }
        });

      },
      child: Padding(
        padding: const EdgeInsets.only(right: 5, left: 5, top: 13),
        child: Container(
          height: 22,
          width: 17,
          decoration: BoxDecoration(
              borderRadius: BorderRadiusDirectional.circular(4),
              border: Border.all(
                  color: (widget.selectedSeats.contains(seatNo))
                      ? AppColors.text.skyBlue
                      : borderColor,
                  width: 1),
              color: (widget.selectedSeats.contains(seatNo))
                  ? AppColors.text.lightSkyBlue
                  : color),
          child: Center(
            child: Text(
              seatNo.toString(),
              style: TextStyle(
                  fontSize: 8,
                  color: (widget.selectedSeats.contains(seatNo))
                      ? Colors.black
                      : seatNoColor),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSeatColorRepresentation(
      {Color borderColor, Color color, String text}) {
    return Row(
      children: [
        Container(
          height: 22,
          width: 17,
          decoration: BoxDecoration(
              borderRadius: BorderRadiusDirectional.circular(4),
              border: Border.all(color: borderColor, width: 1),
              color: color),
          child: Center(
            child: Icon(Icons.star,
                size: 8,
                color: (text == "Selected")
                    ? AppColors.text.black
                    : AppColors.text.grey),
          ),
        ),
        SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        )
      ],
    );
  }
}
