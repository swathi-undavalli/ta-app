import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/access_levels.dart';
import 'package:temple_adventures/core/constants/assets.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/util/ta-image.dart';
import 'package:temple_adventures/features/boat/models/boat-model.dart';
import 'package:temple_adventures/features/boat/models/boat-passengers-model.dart';
import 'package:temple_adventures/features/boat/presentation/screens/editBoat-page.dart';
import 'package:url_launcher/url_launcher.dart';

class BoatWidget extends StatefulWidget {
  static const String id = "BoatWidget";
  final BoatsModel boat;
  final BoatPassengersModel boatPassengersModel;

  BoatWidget({
    @required this.boat,
    @required this.boatPassengersModel,
  });

  @override
  State<BoatWidget> createState() => _BoatWidgetState();
}

class _BoatWidgetState extends State<BoatWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    int bookedSeats = 0;
    List<Employees> employees = [];
    List<Passenger> passengers = [];
    List<Freelancer> freelancers = [];

    widget.boatPassengersModel.passenger.forEach((passenger) {
      if (passenger.boatID == widget.boat.id) {
        bookedSeats++;
      }
    });
    widget.boatPassengersModel.employees.forEach((employee) {
      if (employee.boatID == widget.boat.id) {
        employees.add(employee);
      }
    });
    widget.boatPassengersModel.passenger.forEach((passenger) {
      if (passenger.boatID == widget.boat.id) {
        passengers.add(passenger);
      }
    });
    widget.boatPassengersModel.freelancer.forEach((freelancer) {
      if (freelancer.boatID == widget.boat.id) {
        freelancers.add(freelancer);
      }
    });

    if (bookedSeats == 0 && employees.isEmpty) return SizedBox();
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInCubic,
        alignment: Alignment.topCenter,
        constraints: BoxConstraints(
          minHeight: isExpanded ? 400 : 50,
        ),
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
          child: Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 100,
                        child: Text(
                          widget.boat.boatName,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: AppColors.text.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Spacer(),
                      // EmployeeAccess(
                      //   access: AccessRights.editBookings,
                      //   child: IconButton(
                      //     splashRadius: 20,
                      //     icon: Icon(Icons.edit,
                      //         color: AppColors.background.black),
                      //     iconSize: 12,
                      //     onPressed: () {
                      //       Get.toNamed(EditBoatPage.id,
                      //           arguments: widget.boat);
                      //     },
                      //   ),
                      // ),
                      IconButton(
                        splashRadius: 20,
                        iconSize: 23,
                        icon: Icon(isExpanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded),
                        onPressed: () {
                          setState(() {
                            isExpanded = !isExpanded;
                            //log(isExpanded.toString());
                          });
                        },
                      ),
                    ]),
                isExpanded
                    ? FutureBuilder(
                        future: Future.delayed(Duration(milliseconds: 200)),
                        initialData: SizedBox(),
                        builder: (context, snapshot) {
                          log(bookedSeats.toString());
                          log(widget.boat.capacity.toString());
                          log(widget.boatPassengersModel.passenger.length
                              .toString());
                          if (snapshot.connectionState == ConnectionState.done)
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 30),
                                Container(
                                  width: Get.width,
                                  alignment: Alignment.center,
                                  child: Stack(
                                    children: [
                                      (widget.boat.ocean)
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 20.0),
                                              child: TAImage(
                                                AppImages.icon.newBoat,
                                                height: 90,
                                                // width: 100,
                                              ),
                                            )
                                          : Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 10.0),
                                              child: TAImage(
                                                AppImages.icon.vehicle,
                                                height: 90,
                                              ),
                                            ),
                                      Positioned(
                                        left: (widget.boat.ocean) ? 80 : 65,
                                        top: (widget.boat.ocean) ? 5 : 15,
                                        bottom: 5,
                                        child: Container(
                                          height: 400,
                                          width: 160,
                                          child: Wrap(
                                              direction: Axis.horizontal,
                                              verticalDirection:
                                                  VerticalDirection.down,
                                              children: [
                                                ...List.generate(bookedSeats,
                                                    (index) {
                                                  return buildSeat(
                                                      borderColor: AppColors
                                                          .text.skyBlue,
                                                      color: AppColors
                                                          .text.lightSkyBlue);
                                                }),
                                                ...List.generate(
                                                    (widget.boat.capacity -
                                                        bookedSeats), (index) {
                                                  return buildSeat(
                                                      borderColor:
                                                          Color(0xff5BFF62),
                                                      color: Color(0xffD1FFBB));
                                                }),
                                              ]),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(height: 30),
                                Column(
                                  children: [
                                    buildSeatColorRepresentation(
                                        borderColor: AppColors.text.skyBlue,
                                        color: AppColors.text.lightSkyBlue,
                                        text: "Selected"),
                                    SizedBox(height: 10),
                                    buildSeatColorRepresentation(
                                        borderColor: Color(0xff5BFF62),
                                        color: Color(0xffD1FFBB),
                                        text: "Available"),
                                  ],
                                ),
                                SizedBox(height: 30),
                                Row(
                                  children: [
                                    Expanded(
                                      child: buildCaptainName(
                                          icon: AppImages.icon.captain,
                                          name: widget.boat.captainName),
                                    ),
                                    Expanded(
                                      child: buildCaptainPhone(
                                          icon: Icons.phone,
                                          phoneNumber: widget.boat.phoneNumber),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 40),
                                buildSideHeading(text: "Passengers"),
                                SizedBox(height: 10),
                                buildPassengers(widget.boat.id),
                                SizedBox(height: 30),
                                buildSideHeading(text: "Employees"),
                                SizedBox(height: 10),
                                Container(
                                  width: 350,
                                  child: Wrap(
                                    direction: Axis.horizontal,
                                    verticalDirection: VerticalDirection.down,
                                    children: [
                                      ...employees
                                          .map((e) => Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Text(
                                                  e.name,
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                              ))
                                          .toList(),

                                      // ...List.generate(
                                      //   10,
                                      //   (index) {
                                      //     return buildEmployeeChip();
                                      //   },
                                      // )

                                      // employees.map((e) => buildEmployeeChip())
                                    ],
                                  ),
                                ),
                                SizedBox(height: 30),
                                buildSideHeading(text: "Freelancers"),
                                SizedBox(height: 10),
                                Container(
                                  width: 350,
                                  child: Wrap(
                                    direction: Axis.horizontal,
                                    verticalDirection: VerticalDirection.down,
                                    children: [
                                      ...freelancers
                                          .map((e) => Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Text(
                                                  e.name,
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                              ))
                                          .toList(),

                                      // ...List.generate(
                                      //   10,
                                      //   (index) {
                                      //     return buildEmployeeChip();
                                      //   },
                                      // )

                                      // employees.map((e) => buildEmployeeChip())
                                    ],
                                  ),
                                ),
                                SizedBox(height: 30),
                              ],
                            );
                          return SizedBox();
                        })
                    : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildEmployeeChip() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text(
        "Das",
        style: TextStyle(fontSize: 12),
      ),
    );
  }

  Widget buildStatusHistory() {
    return Row(
      children: [
        buildStatusName(title: "Started"),
        SizedBox(width: 80),
        buildStatusName(title: "Diving"),
        SizedBox(width: 80),
        buildStatusName(title: "Reached"),
      ],
    );
  }

  Widget buildStatusName({@required String title}) {
    return Text(
      title,
      style: TextStyle(
          fontSize: FontSize.small,
          fontWeight: FontWeight.w600,
          color: Colors.grey),
    );
  }

  Widget buildSeat({Color borderColor, Color color}) {
    return Padding(
      padding: const EdgeInsets.only(left: 3.5, top: 6),
      child: Container(
        height: 12,
        width: 7,
        decoration: BoxDecoration(
            borderRadius: BorderRadiusDirectional.circular(2),
            border: Border.all(color: borderColor, width: 1),
            color: color),
      ),
    );
  }

  Widget buildCaptainName({@required String icon, @required String name}) {
    return Row(
      children: [
        TAImage(
          icon,
          height: 20,
          width: 20,
        ),
        SizedBox(width: 10),
        Container(
          width: 85,
          child: Text(
            name,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: FontSize.small, fontWeight: FontWeight.w700),
          ),
        )
      ],
    );
  }

  Widget buildCaptainPhone(
      {@required IconData icon, @required String phoneNumber}) {
    return GestureDetector(
      onTap: () {
        makingPhoneCall(phoneNumber);
      },
      child: Row(
        children: [
          Icon(icon, size: 15),
          SizedBox(width: 10),
          Text(
            phoneNumber,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: FontSize.small, fontWeight: FontWeight.w700),
          )
        ],
      ),
    );
  }

  makingPhoneCall(String phoneNumber) async {
    String url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget buildBoatStatus({String totalAmount, List<double> payments}) {
    return Row(
      children: [
        buildCircle(),
        buildLine(),
        buildCircle(),
        buildLine(),
        buildCircle(),
      ],
    );
  }

  Widget buildCircle({Color color}) {
    return Icon(
      Icons.circle,
      size: 10,
      color: Colors.grey,
    );
  }

  Widget buildLine() {
    return Center(
      child: Stack(
        children: [
          Container(
            height: 2,
            width: 120,
            decoration: BoxDecoration(
              color: AppColors.text.grey,
            ),
          ),
        ],
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
            color: Colors.black.withOpacity(0.80),
            fontSize: 10,
            fontWeight: FontWeight.w300,
            letterSpacing: 0.75,
          ),
        ),
        SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Container(
            width: Get.width,
            height: 1,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black.withOpacity(0.1)),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSeatColorRepresentation(
      {Color borderColor, Color color, String text}) {
    return Row(
      children: [
        Container(
          height: 12,
          width: 7,
          decoration: BoxDecoration(
              borderRadius: BorderRadiusDirectional.circular(2),
              border: Border.all(color: borderColor, width: 1),
              color: color),
        ),
        SizedBox(width: 10),
        Text(
          text,
          style:
              TextStyle(fontSize: FontSize.small, fontWeight: FontWeight.w500),
        )
      ],
    );
  }

  Widget seatsAvailability(
      {@required String name,
      @required String value,
      @required double fontSize,
      @required Color valueColour}) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: name,
            style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w700,
                color: AppColors.text.black),
          ),
          TextSpan(
            text: value,
            style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                color: valueColour),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget buildText({@required String text, @required String value}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text(
            text,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          SizedBox(width: 20),
          Text(
            value,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget buildPassengers(String boatId) {
    Map<String, List<Passenger>> passengersBasedOnBookingId = {};

    widget.boatPassengersModel.passenger.forEach((passenger) {
      if (passengersBasedOnBookingId.containsKey(passenger.bookingID)) {
        passengersBasedOnBookingId[passenger.bookingID].add(passenger);
      } else {
        passengersBasedOnBookingId[passenger.bookingID] = [passenger];
      }
    });

    List<Widget> children = [];

    passengersBasedOnBookingId.forEach((key, value) {
      children.add(
        PassengersList(key, boatId, value),
      );
    });
    return Container(
      width: 350,
      child: Wrap(
        children: children,
      ),
    );
  }
}

class PassengersList extends StatelessWidget {
  final String bookingId;
  final String boatId;
  final List<Passenger> passengers;
  PassengersList(this.bookingId, this.boatId, this.passengers);

  Color backgroundColor = Colors.white;

  Widget build(BuildContext context) {
    passengers.removeWhere((element) => element.boatID != boatId);
    if (passengers.isNotEmpty)
      return Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black12,
          ),
          borderRadius: BorderRadius.circular(3),
        ),
        child: Wrap(
          children: [
            Text(
              bookingId,
              style: TextStyle(
                  fontSize: 7,
                  color: AppColors.background.skyBlue,
                  fontWeight: FontWeight.bold),
            ).paddingOnly(right: 10, top: 3),
            ...passengers
                .map(
                  (e) => Text(
                    e.name.capitalizeFirst,
                    style: TextStyle(fontSize: 12),
                  ).paddingOnly(right: 5),
                )
                .toList()
          ],
        ).paddingOnly(left: 5),
      );
    return SizedBox();
  }
}
