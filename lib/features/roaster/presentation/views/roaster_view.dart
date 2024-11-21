import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:temple_ui_tools/styling/spacing_widgets.dart';
import 'package:temple_ui_tools/utils/utils.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../boat/models/boats.dart';
import '../../../bookings/models/booking_model.dart';
import '../../models/roaster.dart';
import 'add_edit_roaster_details_view.dart';
import 'roaster_chart_view.dart';

class RoasterView extends StatefulWidget {
  const RoasterView({super.key});

  static Route route() => MaterialPageRoute(
        builder: (context) => const RoasterView(),
      );

  @override
  State<RoasterView> createState() => _RoasterViewState();
}

class _RoasterViewState extends State<RoasterView> {
  DateTime selectedDate = DateTime.now();
  bool showLoading = false;
  Boat? selectedBoat;

  List<Boat> boats = [];

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
      appBar: const AppBarWidget(heading: 'Roster'),
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
            : Column(
                children: [
                  Spacing.h20,
                  buildCalenderWidget(),
                  Spacing.h20,
                  buildAllBoats(),
                  Spacing.h30,
                  buildCustomers(),
                ],
              ),
      ),
    );
  }

  Widget buildCustomers() {
    if (selectedBoat != null) {
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
          Roaster? roaster;
          data?.forEach((element) {
            Booking booking = Booking.fromMap(element.data());
            if (booking.isDSD && booking.cancelBooking != true) {
              bookings.add(booking);
            }
          });
          List<Booking> filteredBookings = bookings.where((Booking booking) {
            return (booking.getBoatInfo(selectedDate)?.id == selectedBoat?.id);
          }).toList();

          if (filteredBookings.isNotEmpty) {
            return Expanded(
              child: ListView.builder(
                itemCount: filteredBookings.length,
                itemBuilder: (context, index) {
                  Booking booking = filteredBookings[index];

                  return Column(
                    children: booking.pax!.map((p) {
                      roaster = null;

                      if (p['roaster'] != null) {
                        roaster = Roaster.fromJson(p['roaster']);
                      }

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            AddEditRoasterDetailsView.route(
                              booking: booking,
                              paxIndex: booking.pax!.indexOf(p),
                              boat: selectedBoat,
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Spacing.h10,
                            Row(
                              children: [
                                Spacing.w15,
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.text.skyBlue,
                                  ),
                                  child: Center(
                                    child: Text(
                                      booking.id ?? '',
                                      style: TextStyle(
                                        color: AppColors.text.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: AppFonts.nunito,
                                      ),
                                    ),
                                  ),
                                ),
                                Spacing.w20,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${p['first-name']}'
                                        ' ${p['last-name']}',
                                        style: TextStyle(
                                          color: AppColors.text.black,
                                          fontSize: 13,
                                          fontFamily: AppFonts.nunito,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                buildIcon(roaster),
                              ],
                            ).paddingSymmetric(horizontal: 20),
                            Spacing.h10,
                            Container(
                              height: 1,
                              width: Screen.width,
                              color: AppColors.text.grey,
                            ).paddingSymmetric(horizontal: 15),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            );
          }
          return const Text(
            "No Dsd's found",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          );
        },
      );
    }
    return const SizedBox();
  }

  Widget buildAllBoats() {
    return Wrap(
      runSpacing: 15,
      spacing: 15,
      children: [
        Container(
          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                RoasterChartView.route(selectedDate),
              );
            },
            child: const Icon(Icons.insert_chart),
          ).paddingAll(5),
        ).paddingOnly(left: 10),
        ...boats.map(
          (boat) => buildChip(
            onTap: () {
              selectedBoat = boat;
              setState(() {});
            },
            color: (boat.id == selectedBoat?.id) ? AppColors.text.lightSkyBlue : Colors.white,
            title: boat.name,
          ),
        ),
      ],
    ).paddingSymmetric(horizontal: 10);
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
          style: const TextStyle(color: Colors.black, fontSize: 12),
          textAlign: TextAlign.center,
        ).paddingSymmetric(horizontal: 10, vertical: 7),
      ),
    );
  }

  Widget buildCalenderWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        buildButton(
          onTap: () {
            onDateChanged(
              selectedDate.subtract(const Duration(days: 1)),
            );
          },
          icon: Icons.arrow_back_ios_rounded,
        ),
        Spacing.w20,
        Text(
          DateFormat('dd-MMM-yyyy').format(selectedDate),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        Spacing.w20,
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
            selectDate(context);
          },
          icon: const Icon(
            Icons.calendar_today_outlined,
            size: 17,
          ),
        ),
      ],
    ).paddingSymmetric(horizontal: 20);
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

    var data =
        await FirebaseFirestore.instance.collection('dailyBoats').doc(DateFormat('dd-MM-yyyy').format(date)).get();

    BoatsModel boatsModel = BoatsModel.fromMap(data.data());

    boats.addAll(boatsModel.boats as Iterable<Boat>);
    if (boats.isNotEmpty) {
      selectedBoat = boats[0];
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

  selectDate(BuildContext context) async {
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
                foregroundColor: AppColors.text.black,
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
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

  Widget buildIcon(Roaster? roaster) {
    if (roaster == null) return const SizedBox();

    if (roaster.instructor != null &&
        roaster.timeIn != null &&
        roaster.timeOut != null &&
        roaster.customerFeedback != null) {
      return const Icon(
        Icons.check_circle,
        color: Colors.green,
        size: 20,
      );
    }

    if (roaster.timeIn != null && roaster.timeOut != null) {
      return const Icon(
        Icons.directions_boat,
        color: appBlue,
        size: 20,
      );
    }
    if (roaster.timeIn != null) {
      return const Icon(
        Icons.scuba_diving_rounded,
        color: Colors.orange,
        size: 20,
      );
    }
    return const SizedBox();
  }
}
