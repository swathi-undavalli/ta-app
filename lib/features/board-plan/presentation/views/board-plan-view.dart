import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/util/alignment_extensions.dart';
import 'package:temple_adventures/core/util/spacing-widget.dart';
import 'package:temple_adventures/features/board-plan/controllers/board-plan-controller.dart';
import 'package:intl/intl.dart';
import 'package:temple_adventures/features/board-plan/presentation/widgets/customer-details.dart';
import 'dart:ui' as ui;

import '../../../boat/models/boats.dart';
import '../../../bookings/models/booking-model.dart';

class BoardPlanView extends StatefulWidget {
  BoardPlanView({Key? key}) : super(key: key);
  static const String id = "boardPlanView";

  @override
  State<BoardPlanView> createState() => _BoardPlanViewState();
}

class _BoardPlanViewState extends State<BoardPlanView> {
  final BoardPlanLogic logic = BoardPlanLogic();

  final GlobalKey widgetKey = GlobalKey();

  @override
  void initState() {
    selectedDate = DateTime.now();

    logic.init(selectedDate).whenComplete(() => logic.controller.update());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background.lightBlue,
      floatingActionButton: buildFloatingActionButton(),
      body: SafeArea(
        child: GetBuilder<BoardPlanController>(
          assignId: true,
          builder: (controller) {
            if (controller.showLoading)
              return Container(
                color: Colors.transparent,
                width: Get.width,
                height: Get.height,
                child: Center(
                    child: CircularProgressIndicator(
                  color: Colors.black,
                )),
              );
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          buildButton(
                              onTap: () {
                                logic.onDateChanged(selectedDate
                                    .subtract(const Duration(days: 1)));
                              },
                              icon: Icons.arrow_back_ios_rounded),
                          Spacing.w15,
                          buildTitle(
                              DateFormat('dd-MM-yyyy').format(selectedDate)),
                          Spacing.w15,
                          buildButton(
                              onTap: () {
                                logic.onDateChanged(
                                    selectedDate.add(const Duration(days: 1)));
                              },
                              icon: Icons.arrow_forward_ios_rounded),
                        ],
                      ),
                      buildCalendarIcon(context),
                    ],
                  ),
                  Spacing.h20,
                  Wrap(
                    runSpacing: 15,
                    spacing: 15,
                    children: [
                      buildChip(
                        onTap: () {
                          controller.isGeneralInfoSelected = true;
                          controller.selectedBoat = null;
                          controller.update();
                        },
                        color: (controller.isGeneralInfoSelected)
                            ? AppColors.text.lightSkyBlue
                            : Colors.white,
                        title: "General Info",
                      ),
                      ...controller.boats.map(
                        (boat) => buildChip(
                          onTap: () {
                            controller.selectedBoat = boat;
                            controller.isGeneralInfoSelected = false;
                            controller.update();
                          },
                          color: (boat.id == controller.selectedBoat?.id)
                              ? AppColors.text.lightSkyBlue
                              : Colors.white,
                          title: boat.name,
                        ),
                      )
                    ],
                  ),
                  Spacing.h20,
                  if (controller.selectedBoat != null &&
                      !controller.isGeneralInfoSelected)
                    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection("bookings")
                            .where(
                              "bookingDate",
                              arrayContains:
                                  DateFormat("dd-MM-yyyy").format(selectedDate),
                            )
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError ||
                              snapshot.connectionState ==
                                  ConnectionState.waiting) {
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
                            bookings.add(booking);
                          });
                          return Transform.scale(
                            scale: 1.7,
                            alignment: Alignment.topLeft,
                            child: RepaintBoundary(
                              key: widgetKey,
                              child: CustomerList(
                                bookings: bookings,
                                boat: controller.selectedBoat!,
                              ),
                            ).paddingOnly(bottom: 1000),
                          );
                        }),
                  if (controller.isGeneralInfoSelected)
                    Transform.scale(
                      scale: 1,
                      alignment: Alignment.topLeft,
                      child: RepaintBoundary(
                        key: widgetKey,
                        child: DSDTable(),
                      ),
                    )
                ],
              ).paddingSymmetric(horizontal: 20, vertical: 20),
            );
          },
        ),
      ),
    );
  }

  Widget buildButton({required Function onTap, required IconData icon}) {
    return SizedBox(
        height: 20,
        width: 20,
        child: IconButton(
            splashRadius: 30,
            padding: EdgeInsets.zero,
            onPressed: () {
              onTap();
            },
            icon: Icon(
              icon,
              color: Colors.black,
              size: 14,
            )));
  }

  Widget buildChip(
      {required Function onTap, required Color color, required String title}) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        height: 35,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(20)),
        child: Text(
          title,
          style: TextStyle(color: Colors.black),
          textAlign: TextAlign.center,
        ).paddingSymmetric(horizontal: 10, vertical: 7),
      ),
    );
  }

  Future<void> _captureAndShare() async {
    try {
      RenderRepaintBoundary boundary =
          widgetKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      log("1..");
      ui.Image image = await boundary.toImage(pixelRatio: 10);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      log("2..");
      final tempDir = await getTemporaryDirectory();
      final tempPath = '${tempDir.path}/screenshot.png';
      File(tempPath).writeAsBytesSync(pngBytes);
      log("3..");
      log("started sharingg..");
      try {
        Share.shareFiles([tempPath]);
      } catch (e) {
        log("ended sharing..3 $e");
      }
      log("4..");
      log("ended sharing..");
    } catch (e) {
      print('Error while capturing and sharing the screenshot: $e');
    }
  }

  Widget buildFloatingActionButton() {
    return GetBuilder<BoardPlanController>(
      assignId: true,
      builder: (controller) {
        if (controller.boats.isNotEmpty)
          return FloatingActionButton(
            elevation: 0,
            onPressed: () async {
              log("chinni");
              await _captureAndShare();
              log("swathi");
            },
            backgroundColor: AppColors.background.black,
            child: Icon(Icons.share),
          );
        return SizedBox();
      },
    );
  }

  Widget buildCalendarIcon(BuildContext context) {
    return IconButton(
      splashRadius: 20,
      onPressed: () {
        showDateSelector(context);
      },
      icon: Icon(
        Icons.calendar_today_outlined,
        size: 17,
      ),
    );
  }

  Widget buildTitle(String text) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
            fontSize: 16,
            color: AppColors.text.black,
            fontWeight: FontWeight.bold,
            fontFamily: AppFonts.nunito),
      ),
    );
  }

  showDateSelector(BuildContext context) async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2090),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.text.black,
              onPrimary: Colors.white, // header text color
              onSurface: AppColors.text.black, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: AppColors.text.black,
                textStyle:
                    TextStyle(fontWeight: FontWeight.w500), // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      logic.onDateChanged(date);
    }
  }
}

class DSDTable extends StatelessWidget {
  const DSDTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('dailyBoats')
            .doc(DateFormat("dd-MM-yyyy").format(selectedDate))
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError ||
              snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(
              height: 15,
              width: 15,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.black,
              ),
            );
          }
          Map<String, dynamic>? data =
              snapshot.data?.data() as Map<String, dynamic>?;
          if (data == null) {
            return const Text("No data added");
          }
          BoatsModel boatsModel = BoatsModel.fromMap(data);

          return Container(
            decoration: BoxDecoration(
                color: Colors.white, border: Border.all(color: Colors.black)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Spacing.h10,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildSectionTitle("General Info :"),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat("dd-MM-yyyy").format(selectedDate),
                          style: TextStyle(
                              fontSize: 13,
                              color: AppColors.text.black,
                              fontFamily: AppFonts.nunito,
                              fontWeight: FontWeight.w600),
                        ).paddingSymmetric(vertical: 5),
                        Text(
                          DateFormat('EEEE').format(selectedDate),
                          style: TextStyle(
                              fontSize: 13,
                              color: AppColors.text.black,
                              fontFamily: AppFonts.nunito,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
                Spacing.h3,
                const Text(
                  "BCD",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ).left,
                Spacing.h5,
                RichText(
                  text: TextSpan(
                    text: 'XS - ',
                    style: const TextStyle(fontSize: 11, color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                          text: '${boatsModel.dsd?.bcd?.xs ?? 0}, ',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const TextSpan(
                          text: 'S - ',
                          style: TextStyle(
                            fontSize: 11,
                          )),
                      TextSpan(
                          text: '${boatsModel.dsd?.bcd?.s ?? 0}, ',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const TextSpan(
                          text: 'M - ',
                          style: TextStyle(
                            fontSize: 11,
                          )),
                      TextSpan(
                          text: '${boatsModel.dsd?.bcd?.m ?? 0}, ',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(
                        text: 'L - ',
                        style:
                            const TextStyle(fontSize: 11, color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                              text: '${boatsModel.dsd?.bcd?.l ?? 0}, ',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          const TextSpan(
                              text: 'XL - ',
                              style: TextStyle(
                                fontSize: 11,
                              )),
                          TextSpan(
                              text: '${boatsModel.dsd?.bcd?.xl ?? 0}, ',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          const TextSpan(
                              text: 'XXL - ',
                              style: TextStyle(
                                fontSize: 11,
                              )),
                          TextSpan(
                              text: '${boatsModel.dsd?.bcd?.xxl ?? 0}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
                Spacing.h6,
                const Text(
                  "Weights",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ).left,
                Spacing.h5,
                RichText(
                  text: TextSpan(
                    text: '3KG - ',
                    style: const TextStyle(fontSize: 11, color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                          text: '${boatsModel.dsd?.weights?.w3 ?? 0}, ',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const TextSpan(
                          text: '4KG - ',
                          style: TextStyle(
                            fontSize: 11,
                          )),
                      TextSpan(
                          text: '${boatsModel.dsd?.weights?.w4 ?? 0}, ',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(
                        text: '5KG - ',
                        style:
                            const TextStyle(fontSize: 11, color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                              text: '${boatsModel.dsd?.weights?.w5 ?? 0}, ',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          const TextSpan(
                              text: '6KG - ',
                              style: TextStyle(
                                fontSize: 11,
                              )),
                          TextSpan(
                              text: '${boatsModel.dsd?.weights?.w6 ?? 0}, ',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          const TextSpan(
                              text: '7KG - ',
                              style: TextStyle(
                                fontSize: 11,
                              )),
                          TextSpan(
                              text: '${boatsModel.dsd?.weights?.w7 ?? 0}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
                Spacing.h6,
                buildDSDItem('Fins', "${boatsModel.dsd?.fins ?? 0}"),
                buildDSDItem('Mask', "${boatsModel.dsd?.mask ?? 0}"),
                buildDSDItem('Regulator', "${boatsModel.dsd?.regulator ?? 0}"),
                buildDSDItem('Power Mask',
                    "${boatsModel.dsd?.powerMask ?? 0} (${boatsModel.dsd?.powerNotes ?? '-'})"),
                Spacing.h3,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildSectionTitle("Weather :"),
                        Spacing.h3,
                        buildDSDItem(
                            'Waves', "${boatsModel.dsd?.waves ?? '-'} m/s"),
                        buildDSDItem(
                            'Winds', "${boatsModel.dsd?.winds ?? '-'} km/h"),
                        buildDSDItem(
                            'Low Tides', boatsModel.dsd?.lowTides ?? '-'),
                        buildDSDItem(
                            'High Tides', boatsModel.dsd?.highTides ?? '-'),
                      ],
                    ),
                    buildTanksCount(boatsModel),
                  ],
                ),
                Spacing.h3,
                buildSectionTitle("Employees : "),
                Spacing.h3,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "DSD Pool",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                        Spacing.h3,
                        Text(
                          getInternNames(boatsModel.dsd?.dsdPools, true),
                          style: const TextStyle(fontSize: 11),
                        ),
                        Spacing.h3,
                        const Text(
                          "DSD Ocean Leader",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                        Spacing.h3,
                        Text(
                          getInternNames(boatsModel.dsd?.dsdOceanLead, true),
                          style: const TextStyle(fontSize: 11),
                        ),
                        Spacing.h3,
                        const Text(
                          "DSD Center Staff",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                        Spacing.h3,
                        Text(
                          getInternNames(boatsModel.dsd?.dsdCenterStaff, true),
                          style: const TextStyle(fontSize: 11),
                        ),
                        Spacing.h3,
                        const Text(
                          "Courses Center",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                        Spacing.h3,
                        Text(
                          getInternNames(boatsModel.dsd?.coursesCenter, true),
                          style: const TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Day offs",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                        Spacing.h3,
                        Text(
                          getNames(boatsModel.dsd?.dayOffs, true),
                          style: const TextStyle(fontSize: 11),
                        ),
                        Spacing.h3,
                        const Text(
                          "Leaves",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                        Spacing.h3,
                        Text(
                          getNames(boatsModel.dsd?.leaves, true),
                          style: const TextStyle(fontSize: 11),
                        ),
                        const Text(
                          "General Notes",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 11),
                        ).left,
                        Spacing.h3,
                        SizedBox(
                          width: 90,
                          child: Text(
                            (boatsModel.dsd?.generalNotes != null &&
                                    boatsModel.dsd?.generalNotes != "")
                                ? boatsModel.dsd!.generalNotes!
                                : '-',
                            style: const TextStyle(fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Spacing.h10,
              ],
            ).paddingOnly(left: 15, right: 15),
          );
        });
  }

  Widget buildTanksCount(BoatsModel boatsModel) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("bookings")
            .where(
              "bookingDate",
              arrayContains: DateFormat("dd-MM-yyyy").format(selectedDate),
            )
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError ||
              snapshot.connectionState == ConnectionState.waiting) {
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
            bookings.add(booking);
          });

          int totalAir = 0;
          int totalNitrox = 0;

          for (Boat boat in boatsModel.boats ?? []) {
            totalAir += getTotalAirCount(bookings, boat);
            totalNitrox += getTotalAirCount(bookings, boat, true);
            totalAir += boat.air ?? 0;
            totalNitrox += boat.nitrox ?? 0;
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spacing.h6,
              buildSectionTitle("Tanks Count : "),
              Spacing.h3,
              buildDSDItem('Total Air', totalAir.toString()),
              buildDSDItem('Total Nitrox', totalNitrox.toString()),
              buildDSDItem('Total Tanks', (totalAir + totalNitrox).toString()),
            ],
          );
        });
  }

  Widget buildSectionTitle(String text) {
    return Text(
      "$text",
      style: TextStyle(
          fontSize: 13,
          color: AppColors.text.black,
          fontFamily: AppFonts.nunito,
          decoration: TextDecoration.underline,
          fontWeight: FontWeight.w600),
    ).paddingSymmetric(vertical: 5);
  }

  Widget buildDSDItem(String key, String? value) {
    if (value == null || value.isEmpty) {
      value = '-';
    }
    return Row(
      children: [
        SizedBox(
            width: 80,
            child: Text(
              key,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11),
            )),
        Text(
          value,
          style: const TextStyle(fontSize: 11),
        ),
      ],
    ).paddingOnly(bottom: 3);
  }
}
