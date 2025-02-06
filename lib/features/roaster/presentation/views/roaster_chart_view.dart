import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:temple_ui_tools/styling/spacing_widgets.dart';
import 'package:temple_ui_tools/utils/utils.dart';

import '../../../../core/util/utils.dart';
import '../../../../core/widgets/access_levels.dart';
import '../../../../core/widgets/app_bar.dart';
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
    // Lock the orientation to landscape only
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

  final GlobalKey _repaintBoundaryKey = GlobalKey();
  bool isRoaster = true;
  bool showLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          showLoading = true;
          setState(() {});
          _captureAndShareScreenshot();
          showLoading = false;
          setState(() {});
        },
        child: const Icon(Icons.share),
      ),
      appBar: AppBarWidget(
        heading: (isRoaster) ? 'Roster' : 'Payment Details',
        actions: [
          EmployeeAccess(
            access: AccessRights.showPaymentDetails,
            child: Row(
              children: [
                Text(
                  (isRoaster) ? 'Roster' : 'Payment',
                  style: const TextStyle(color: Colors.black),
                ),
                Switch(
                  value: isRoaster,
                  onChanged: (value) {
                    isRoaster = value;
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SizedBox(
          height: Screen.height,
          child: SingleChildScrollView(
            child: RepaintBoundary(
              key: _repaintBoundaryKey,
              child: Container(
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Spacing.h20,
                    Row(
                      children: [
                        const Spacer(),
                        Text(
                          DateFormat('dd-MM-yyyy').format(widget.selectedDate),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                    Spacing.h20,
                    buildHeadings(),
                    Spacing.h10,
                    buildCustomers(),
                    Spacing.h70,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _captureAndShareScreenshot() async {
    try {
      RenderRepaintBoundary boundary = _repaintBoundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 10);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final tempPath = '${tempDir.path}/screenshot.png';
      File(tempPath).writeAsBytesSync(pngBytes);
      shareImages([tempPath]);
    } catch (e) {
      log('Error capturing screenshot: $e');
    }
  }

  Future<void> shareImages(List<String> images) async {
    try {
      Share.shareXFiles(images.map((e) => XFile(e)).toList());
    } catch (e) {
      log('Error while sharing images $e');
    }
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

            return Column(
              children: [
                for (int i = 0; i < filteredBookings.length; i++) buildCustomerInfo(filteredBookings, i, boatsModel),
              ],
            );
          },
        );
      },
    );
  }

  Widget buildCustomerInfo(List<Booking> bookings, int index, BoatsModel boatsModel) {
    Booking booking = bookings[index];
    Boat? boat;
    boatsModel.boats?.forEach((element) {
      if (element.id == booking.getBoatInfo(widget.selectedDate)?.id) {
        boat = element;
      }
    });

    if (isRoaster) {
      return Column(
        children: [
          ...(booking.pax ?? []).map(
            (p) {
              if (p['roaster'] != null) {
                Roaster roaster = Roaster.fromMap(p['roaster']);

                return Row(
                  children: [
                    buildText(text: boat?.name ?? '-'),
                    buildText(
                      text: booking.id ?? '',
                    ),
                    buildText(text: '${p['first-name']} ${p['last-name']}'),
                    buildText(text: p['gender']),
                    buildText(text: roaster.staffInstructor?.name ?? roaster.instructor?.name ?? '-'),
                    buildText(text: (roaster.timeIn != null) ? DateFormat('hh:mm a').format(roaster.timeIn!) : '-'),
                    buildText(text: (roaster.timeOut != null) ? DateFormat('hh:mm a').format(roaster.timeOut!) : '-'),
                    buildText(text: (roaster.isDived == true) ? 'Yes' : 'No'),
                    buildText(text: (roaster.customerFeedback?.knowsSwimming == true) ? 'Yes' : 'No'),
                    buildText(text: (roaster.customerFeedback?.interestedOwc == true) ? 'Yes' : 'No'),
                    buildText(text: roaster.customerFeedback?.feedback?.stringOrNull ?? '-'),
                  ],
                ).paddingSymmetric(horizontal: 10, vertical: 5);
              }
              return const SizedBox();
            },
          ),
        ],
      );
    } else {
      return Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start, // Aligns items properly
            children: [
              buildText(text: boat?.name ?? '-'),
              buildText(text: booking.id ?? '-'),
              ((booking.pax ?? []).isEmpty)
                  ? buildText(
                      text: '${booking.details?.firstName.capitalizeFirst} ${booking.details?.lastName}',
                    )
                  : IntrinsicHeight(
                      child: Container(
                        width: 100,
                        alignment: Alignment.center,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min, // Avoid unnecessary expansion
                          children: [
                            ...(booking.pax ?? []).map((p) {
                              return buildText(
                                text: '${p['first-name']} ${p['last-name']}',
                              );
                            }), // `.toList()` ensures the map results are converted to a list
                          ],
                        ),
                      ),
                    ),
              buildText(text: booking.noOfPersons.toString()),
              buildText(text: booking.details?.gender ?? '-'),
              buildText(
                text: '${booking.details?.firstName.capitalizeFirst} ${booking.details?.lastName}',
              ),
              buildText(text: booking.invoiceNo ?? '-'),
              buildText(text: booking.employeeName ?? '-'),
            ],
          ).paddingSymmetric(horizontal: 10, vertical: 5),
        ],
      );
    }
  }

  Widget buildHeadings() {
    if (isRoaster) {
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
    } else {
      return Row(
        children: [
          buildText(text: 'Boat'),
          buildText(text: 'Id'),
          buildText(text: 'Diver Names'),
          buildText(text: 'DSD Count'),
          buildText(text: 'Gender'),
          buildText(text: 'Group Name'),
          buildText(text: 'Conformed SO# / INV#'),
          buildText(text: 'Booking Channel'),
        ],
      ).paddingSymmetric(horizontal: 10);
    }
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
