import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:temple_ui_tools/utils/utils.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/util/alignment_extensions.dart';
import '../../../../core/util/spacing_widgets.dart';
import '../../../boat/models/boats.dart';
import '../../../bookings/models/booking_model.dart';
import '../widgets/customer_details.dart';

class BoardPlanView extends StatefulWidget {
  const BoardPlanView({Key? key}) : super(key: key);

  static Route route() => MaterialPageRoute(
        builder: (context) => const BoardPlanView(),
      );

  @override
  State<BoardPlanView> createState() => _BoardPlanViewState();
}

class _BoardPlanViewState extends State<BoardPlanView> {
  bool showLoading = true;
  bool isGeneralInfoSelected = false;
  Boat? selectedBoat;

  List<Boat> boats = [];

  List<Booking> bookings = [];

  final GlobalKey widgetKey = GlobalKey();

  @override
  void initState() {
    selectedDate = DateTime.now();
    init(selectedDate).whenComplete(() => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background.lightBlue,
      floatingActionButton: (boats.isNotEmpty) ? buildFloatingActionButton() : const SizedBox(),
      body: SafeArea(
        child: (showLoading)
            ? Container(
                color: Colors.transparent,
                width: Screen.width,
                height: Screen.height,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildCalenderWidget(context),
                    Spacing.h20,
                    Wrap(
                      runSpacing: 15,
                      spacing: 15,
                      children: [
                        buildChip(
                          onTap: () {
                            isGeneralInfoSelected = true;
                            selectedBoat = null;
                            setState(() {});
                          },
                          color: (isGeneralInfoSelected) ? AppColors.text.lightSkyBlue : Colors.white,
                          title: 'General Info',
                        ),
                        ...boats.map(
                          (boat) => buildChip(
                            onTap: () {
                              selectedBoat = boat;
                              isGeneralInfoSelected = false;
                              setState(() {});
                            },
                            color: (boat.id == selectedBoat?.id) ? AppColors.text.lightSkyBlue : Colors.white,
                            title: boat.name,
                          ),
                        ),
                      ],
                    ),
                    Spacing.h20,
                    if (selectedBoat != null && !isGeneralInfoSelected)
                      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection('bookings')
                            .where(
                              'bookingDate',
                              arrayContains: DateFormat('dd-MM-yyyy').format(selectedDate),
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
                            bookings.add(booking);
                          });
                          return Transform.scale(
                            scale: 1.7,
                            alignment: Alignment.topLeft,
                            child: RepaintBoundary(
                              key: widgetKey,
                              child: CustomerList(
                                bookings: bookings,
                                boat: selectedBoat!,
                                selectedDate: selectedDate,
                              ),
                            ).paddingOnly(bottom: 1000),
                          );
                        },
                      ),
                    if (isGeneralInfoSelected)
                      Transform.scale(
                        scale: 1,
                        alignment: Alignment.topLeft,
                        child: RepaintBoundary(
                          key: widgetKey,
                          child: const GeneralInfoData(),
                        ),
                      ),
                  ],
                ).paddingSymmetric(horizontal: 20, vertical: 20),
              ),
      ),
    );
  }

  Future<void> init(DateTime date) async {
    showLoading = true;
    await getAllBoats(date);
    showLoading = false;
    setState(() {});
  }

  Future<void> getAllBoats(DateTime date) async {
    boats = [];
    selectedBoat = null;
    isGeneralInfoSelected = false;

    var data =
        await FirebaseFirestore.instance.collection('dailyBoats').doc(DateFormat('dd-MM-yyyy').format(date)).get();

    BoatsModel boatsModel = BoatsModel.fromMap(data.data());
    boats.addAll(boatsModel.boats as Iterable<Boat>);
    if (boats.isNotEmpty) {
      selectedBoat = boats[0];
    } else {
      isGeneralInfoSelected = true;
    }
  }

  Future<void> onDateChanged(DateTime date) async {
    selectedDate = date;
    showLoading = true;
    setState(() {});

    await init(selectedDate);
    showLoading = false;
    setState(() {});
  }

  Widget buildCalenderWidget(BuildContext context) {
    return Row(
      children: [
        buildButton(
          onTap: () {
            onDateChanged(
              selectedDate.subtract(const Duration(days: 1)),
            );
          },
          icon: Icons.arrow_back_ios_rounded,
        ),
        Spacing.w15,
        buildTitle(
          DateFormat('dd-MM-yyyy').format(selectedDate),
        ),
        Spacing.w15,
        Text(
          DateFormat('EEEE').format(selectedDate),
          style: TextStyle(
            fontSize: 13,
            color: AppColors.text.black,
            fontFamily: AppFonts.nunito,
            fontWeight: FontWeight.w600,
          ),
        ),
        Spacing.w15,
        buildButton(
          onTap: () {
            onDateChanged(
              selectedDate.add(const Duration(days: 1)),
            );
          },
          icon: Icons.arrow_forward_ios_rounded,
        ),
        const Spacer(),
        IconButton(
          splashRadius: 20,
          onPressed: () {
            showDateSelector(context);
          },
          icon: const Icon(
            Icons.calendar_today_outlined,
            size: 17,
          ),
        ),
      ],
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
        ),
      ),
    );
  }

  Widget buildChip({
    required Function onTap,
    required Color color,
    required String title,
  }) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        height: 35,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: const TextStyle(color: Colors.black),
          textAlign: TextAlign.center,
        ).paddingSymmetric(horizontal: 10, vertical: 7),
      ),
    );
  }

  Future<void> _captureAndShare() async {
    try {
      RenderRepaintBoundary boundary = widgetKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 10);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final tempPath = '${tempDir.path}/screenshot.png';
      File(tempPath).writeAsBytesSync(pngBytes);
      shareImages([tempPath]);
    } catch (e) {
      log('Error while capturing and sharing the screenshot: $e');
    }
  }

  Future<void> shareImages(List<String> images) async {
    try {
      Share.shareXFiles(images.map((e) => XFile(e)).toList());
    } catch (e) {
      log('Error while sharing images $e');
    }
  }

  Future<String?> captureImage() async {
    try {
      RenderRepaintBoundary boundary = widgetKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 10);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final tempPath = '${tempDir.path}/screenshot${DateTime.now().toIso8601String()}.png';
      File(tempPath).writeAsBytesSync(pngBytes);
      return tempPath;
    } catch (e) {
      log('Error while capturing the screenshot: $e');
    }
    return null;
  }

  Widget buildFloatingActionButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          elevation: 0,
          onPressed: () async {
            await _captureAndShare();
          },
          backgroundColor: AppColors.background.black,
          child: const Icon(
            Icons.share,
            color: Colors.white,
          ),
        ),
        Spacing.h20,
        FloatingActionButton(
          elevation: 0,
          onPressed: () async {
            List<String> images = [];

            selectedBoat = null;
            isGeneralInfoSelected = true;
            setState(() {});
            await Future.delayed(const Duration(seconds: 1));
            isGeneralInfoSelected = false;
            setState(() {});

            //General Info
            String? image = await captureImage();
            if (image != null) {
              images.add(image);
            }

            for (Boat boat in boats) {
              selectedBoat = boat;
              setState(() {});
              await Future.delayed(const Duration(seconds: 1));

              //Boats
              String? boatImage = await captureImage();
              if (boatImage != null) {
                images.add(boatImage);
              }
            }

            isGeneralInfoSelected = false;

            await shareImages(images);
          },
          backgroundColor: AppColors.background.black,
          child: const Icon(
            Icons.directions_boat_filled_rounded,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget buildTitle(String text) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          color: AppColors.text.black,
          fontWeight: FontWeight.bold,
          fontFamily: AppFonts.nunito,
        ),
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
                textStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: AppColors.text.black,
                ), // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      onDateChanged(date);
    }
  }
}

class GeneralInfoData extends StatelessWidget {
  const GeneralInfoData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('dailyBoats')
          .doc(DateFormat('dd-MM-yyyy').format(selectedDate))
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

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spacing.h10,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildSectionTitle('General Info :'),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('dd-MM-yyyy').format(selectedDate),
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.text.black,
                          fontFamily: AppFonts.nunito,
                          fontWeight: FontWeight.w600,
                        ),
                      ).paddingSymmetric(vertical: 5),
                      Text(
                        DateFormat('EEEE').format(selectedDate),
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.text.black,
                          fontFamily: AppFonts.nunito,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Spacing.h3,
              const Text(
                'BCD',
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
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(
                      text: 'S - ',
                      style: TextStyle(
                        fontSize: 11,
                      ),
                    ),
                    TextSpan(
                      text: '${boatsModel.dsd?.bcd?.s ?? 0}, ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(
                      text: 'M - ',
                      style: TextStyle(
                        fontSize: 11,
                      ),
                    ),
                    TextSpan(
                      text: '${boatsModel.dsd?.bcd?.m ?? 0}, ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: 'L - ',
                      style: const TextStyle(fontSize: 11, color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                          text: '${boatsModel.dsd?.bcd?.l ?? 0}, ',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(
                          text: 'XL - ',
                          style: TextStyle(
                            fontSize: 11,
                          ),
                        ),
                        TextSpan(
                          text: '${boatsModel.dsd?.bcd?.xl ?? 0}, ',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(
                          text: 'XXL - ',
                          style: TextStyle(
                            fontSize: 11,
                          ),
                        ),
                        TextSpan(
                          text: '${boatsModel.dsd?.bcd?.xxl ?? 0}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Spacing.h6,
              const Text(
                'Weights',
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
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(
                      text: '4KG - ',
                      style: TextStyle(
                        fontSize: 11,
                      ),
                    ),
                    TextSpan(
                      text: '${boatsModel.dsd?.weights?.w4 ?? 0}, ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: '5KG - ',
                      style: const TextStyle(fontSize: 11, color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                          text: '${boatsModel.dsd?.weights?.w5 ?? 0}, ',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(
                          text: '6KG - ',
                          style: TextStyle(
                            fontSize: 11,
                          ),
                        ),
                        TextSpan(
                          text: '${boatsModel.dsd?.weights?.w6 ?? 0}, ',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(
                          text: '7KG - ',
                          style: TextStyle(
                            fontSize: 11,
                          ),
                        ),
                        TextSpan(
                          text: '${boatsModel.dsd?.weights?.w7 ?? 0}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Spacing.h6,
              buildDSDItem('Fins', '${boatsModel.dsd?.fins ?? 0}'),
              buildDSDItem('Mask', '${boatsModel.dsd?.mask ?? 0}'),
              buildDSDItem('Regulator', '${boatsModel.dsd?.regulator ?? 0}'),
              buildDSDItem(
                'Power Mask',
                "${boatsModel.dsd?.powerMask ?? 0} (${boatsModel.dsd?.powerNotes ?? '-'})",
              ),
              Spacing.h3,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildSectionTitle('Weather :'),
                      Spacing.h3,
                      buildDSDItem(
                        'Waves',
                        "${boatsModel.dsd?.waves ?? '-'} m/s",
                      ),
                      buildDSDItem(
                        'Winds',
                        "${boatsModel.dsd?.winds ?? '-'} km/h",
                      ),
                      buildDSDItem(
                        'Low Tides',
                        boatsModel.dsd?.lowTides ?? '-',
                      ),
                      buildDSDItem(
                        'High Tides',
                        boatsModel.dsd?.highTides ?? '-',
                      ),
                    ],
                  ),
                  buildTanksCount(boatsModel),
                ],
              ),
              Spacing.h3,
              buildSectionTitle('Employees : '),
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
                        'DSD Pool',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                      Spacing.h3,
                      Text(
                        getNames(boatsModel.dsd?.dsdPool, true),
                        style: const TextStyle(fontSize: 11),
                      ),
                      Spacing.h3,
                      const Text(
                        'DSD Ocean Leader',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                      Spacing.h3,
                      Text(
                        getNames(boatsModel.dsd?.dsdOceanHead, true),
                        style: const TextStyle(fontSize: 11),
                      ),
                      Spacing.h3,
                      const Text(
                        'DSD Center Staff',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                      Spacing.h3,
                      Text(
                        getNames(boatsModel.dsd?.centerStaff, true),
                        style: const TextStyle(fontSize: 11),
                      ),
                      Spacing.h3,
                      const Text(
                        'Courses Center',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                      Spacing.h3,
                      Text(
                        getNames(boatsModel.dsd?.courseCenter, true),
                        style: const TextStyle(fontSize: 11),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Day offs',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                      Spacing.h3,
                      Text(
                        getNames(boatsModel.dsd?.dayOffs, true),
                        style: const TextStyle(fontSize: 11),
                      ),
                      Spacing.h3,
                      const Text(
                        'Leaves',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                      Spacing.h3,
                      Text(
                        getNames(boatsModel.dsd?.leaves, true),
                        style: const TextStyle(fontSize: 11),
                      ),
                      const Text(
                        'General Notes',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ).left,
                      Spacing.h3,
                      SizedBox(
                        width: 90,
                        child: Text(
                          (boatsModel.dsd?.generalNotes != null && boatsModel.dsd?.generalNotes != '')
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
      },
    );
  }

  Widget buildTanksCount(BoatsModel boatsModel) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('bookings')
          .where(
            'bookingDate',
            arrayContains: DateFormat('dd-MM-yyyy').format(selectedDate),
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
            buildSectionTitle('Tanks Count : '),
            Spacing.h3,
            buildDSDItem('Total Air', totalAir.toString()),
            buildDSDItem('Total Nitrox', totalNitrox.toString()),
            buildDSDItem('Total Tanks', (totalAir + totalNitrox).toString()),
          ],
        );
      },
    );
  }

  Widget buildSectionTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        color: AppColors.text.black,
        fontFamily: AppFonts.nunito,
        decoration: TextDecoration.underline,
        fontWeight: FontWeight.w600,
      ),
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
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 11),
        ),
      ],
    ).paddingOnly(bottom: 3);
  }
}
