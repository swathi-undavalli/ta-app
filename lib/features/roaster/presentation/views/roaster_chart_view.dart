import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:temple_ui_tools/styling/spacing_widgets.dart';

import '../../../../core/widgets/back_navigation_icon.dart';
import '../../../boat/models/boats.dart';
import '../../../bookings/models/booking_model.dart';
import '../../models/roaster.dart';

class RoasterChartView extends StatefulWidget {
  const RoasterChartView({super.key, required this.selectedDate});

  final DateTime selectedDate;

  static Route route(DateTime selectedDate) => MaterialPageRoute(
        builder: (context) => RoasterChartView(selectedDate: selectedDate),
      );

  @override
  State<RoasterChartView> createState() => _RoasterChartViewState();
}

class _RoasterChartViewState extends State<RoasterChartView> {
  @override
  void initState() {
    super.initState();
    // Lock the orientation to portrait only
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    // Reset to allow all orientations when leaving the page
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Spacing.h20,
            Row(
              children: [
                const BackNavigationIcon(),
                Expanded(
                  child: Text(
                    DateFormat('dd-MM-yyyy').format(widget.selectedDate),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                Spacing.w95,
              ],
            ),
            Spacing.h20,
            buildHeadings(),
            Spacing.h15,
            buildCustomers(),
          ],
        ),
      ),
    );
  }

  Widget buildCustomers() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('bookings')
          .where(
            'bookingDate',
            arrayContains: DateFormat('dd-MM-yyyy').format(widget.selectedDate),
          )
          .snapshots(),
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
        final data = snapshot.data?.docs;
        List<Booking> bookings = [];
        data?.forEach((element) {
          Booking booking = Booking.fromMap(element.data());
          if (booking.isDSD && booking.cancelBooking != true) {
            bookings.add(booking);
          }
        });

        List<Booking> filteredBookings = bookings.where((Booking booking) {
          return (booking.getBoatInfo(widget.selectedDate)?.id != null);
        }).toList();

        return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('dailyBoats')
              .doc(DateFormat('dd-MM-yyyy').format(widget.selectedDate))
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
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
            Map<String, dynamic>? data = snapshot.data?.data() as Map<String, dynamic>?;
            if (data == null) {
              return const Text('No data added');
            }
            BoatsModel boatsModel = BoatsModel.fromMap(data);

            Duration? difference;

            return Expanded(
              child: ListView.builder(
                itemCount: filteredBookings.length,
                itemBuilder: (context, index) {
                  Booking booking = bookings[index];
                  Boat? boat;
                  boatsModel.boats?.forEach((element) {
                    if (element.id == booking.getBoatInfo(widget.selectedDate)?.id) {
                      boat = element;
                    }
                  });

                  return Column(
                    children: [
                      ...(booking.pax ?? []).map(
                        (p) {
                          if (p['roaster'] != null) {
                            Roaster roaster = Roaster.fromJson(p['roaster']);

                            if (roaster.timeIn != null && roaster.timeOut != null) {
                              DateTime startTime = roaster.timeIn!;
                              DateTime endTime = roaster.timeOut!;

                              difference = endTime.difference(startTime);
                            }
                            return Row(
                              children: [
                                buildText(text: boat?.name ?? '-'),
                                buildText(
                                  text: booking.id ?? '',
                                ),
                                buildText(
                                  text: '${p['first-name']}' '${p['last-name']}',
                                ),
                                buildText(text: p['gender']),
                                buildText(
                                  text: roaster.instructor?.name ?? '-',
                                ),
                                buildText(
                                  text: (roaster.timeIn != null) ? DateFormat('hh:mm a').format(roaster.timeIn!) : '-',
                                ),
                                buildText(
                                  text:
                                      (roaster.timeOut != null) ? DateFormat('hh:mm a').format(roaster.timeOut!) : '-',
                                ),
                                buildText(
                                  text: (difference != null && difference!.inMinutes >= 10) ? 'Yes' : 'No',
                                ),
                                buildText(
                                  text: (roaster.customerFeedback != null && roaster.customerFeedback!.knowsSwimming!)
                                      ? 'Yes'
                                      : 'No',
                                ),
                                buildText(
                                  text: (roaster.customerFeedback != null && roaster.customerFeedback!.interestedOwc!)
                                      ? 'Yes'
                                      : 'No',
                                ),
                                buildText(
                                  text: (roaster.customerFeedback != null &&
                                          roaster.customerFeedback!.feedback!.isNotEmpty)
                                      ? roaster.customerFeedback!.feedback!
                                      : '-',
                                ),
                              ],
                            ).paddingSymmetric(horizontal: 10, vertical: 5);
                          }
                          return const SizedBox();
                        },
                      ),
                    ],
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget buildHeadings() {
    return Row(
      children: [
        buildText(text: 'Boat'),
        buildText(text: 'Id'),
        buildText(text: 'Diver'),
        buildText(text: 'Gender'),
        buildText(text: 'Staff'),
        buildText(text: 'Time in'),
        buildText(text: 'Time out'),
        buildText(text: 'Dive done / Not done'),
        buildText(text: 'Knows swimming'),
        buildText(text: 'Interested OWC'),
        buildText(text: 'Remarks'),
      ],
    ).paddingSymmetric(horizontal: 10);
  }

  Widget buildText({
    required String text,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return Expanded(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
      ).paddingSymmetric(horizontal: 2),
    );
  }
}
