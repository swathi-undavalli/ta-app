import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:temple_ui_tools/utils/utils.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/util/alignment_extensions.dart';
import '../../../../core/util/spacing_widgets.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../boat/models/boat_details.dart';
import '../../../boat/models/boats.dart';
import '../../../bookings/models/booking_model.dart';
import '../../models/roaster.dart';
import '../widgets/customer_feedback_bottomsheet.dart';
import '../widgets/roaster_time_editor_bs.dart';

class AddEditRoasterDetailsView extends StatefulWidget {
  const AddEditRoasterDetailsView({
    super.key,
    required this.booking,
    required this.paxIndex,
    required this.boat,
  });

  final Booking booking;
  final int? paxIndex;
  final Boat? boat;

  static Route route({
    required Booking booking,
    required int? paxIndex,
    required Boat? boat,
  }) =>
      MaterialPageRoute(
        builder: (context) => AddEditRoasterDetailsView(
          booking: booking,
          paxIndex: paxIndex,
          boat: boat,
        ),
      );

  @override
  State<AddEditRoasterDetailsView> createState() =>
      _AddEditRoasterDetailsViewState();
}

class _AddEditRoasterDetailsViewState extends State<AddEditRoasterDetailsView> {
  Instructor? assignedInstructor;
  late TextEditingController customerRemarks;
  List<Instructor> dsdInstructors = [];
  DateTime? timeIn;
  DateTime? timeOut;
  bool showLoading = false;
  late Booking booking;

  @override
  void initState() {
    super.initState();
    customerRemarks = TextEditingController();
    dsdInstructors = widget.boat?.dsdInstructors ?? [];

    booking = widget.booking;

    if ((widget.paxIndex != null)) {
      var pax = booking.pax?[widget.paxIndex!];
      var roasterData = pax?['roaster'] as Map<String, dynamic>?;

      if (roasterData != null) {
        Roaster roaster = Roaster.fromJson(roasterData);

        assignedInstructor = roaster.instructor;
        customerRemarks.text = roaster.remarks ?? '';
        timeIn = roaster.timeIn;
        timeOut = roaster.timeOut;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background.lightBlue,
      appBar: AppBarWidget(
        heading: '',
        color: AppColors.background.lightBlue,
        actions: [
          IconButton(
            onPressed: () async {
              if (widget.paxIndex != null) {
                setState(() {
                  showLoading = true;
                });
                var pax = booking.pax![widget.paxIndex!];
                pax['roaster'] = null;

                await FirebaseFirestore.instance
                    .collection('bookings')
                    .doc(booking.id)
                    .set(booking.toMap());

                setState(() {
                  showLoading = false;
                });
                Get.back();
              }
            },
            icon: const Icon(Icons.refresh),
          ).paddingOnly(right: 10),
        ],
      ),
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: Screen.width,
                    child: const Icon(
                      Icons.account_circle,
                      size: 70,
                      color: Colors.grey,
                    ),
                  ),
                  Spacing.h15,
                  Text(
                    '${booking.pax?[widget.paxIndex!]['first-name']} ${booking.pax?[widget.paxIndex!]['last-name']}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacing.h40,
                  buildInstructor(),
                  Spacing.h30,
                  Row(
                    children: [
                      buildTimeButtons(
                        title: 'In the water',
                        onTap: () {
                          timeIn ??= DateTime.now();
                          setState(() {});
                          log(timeIn.toString());
                        },
                        color: (timeIn != null)
                            ? AppColors.text.lightSkyBlue
                            : Colors.white,
                      ),
                      Spacing.w20,
                      buildTimeButtons(
                        title: 'Out of water',
                        onTap: () {
                          timeOut ??= DateTime.now();
                          setState(() {});
                          log(timeOut.toString());
                        },
                        color: (timeOut != null)
                            ? AppColors.text.lightSkyBlue
                            : Colors.white,
                      ),
                    ],
                  ),
                  Spacing.h10,
                  Row(
                    children: [
                      if (timeIn != null)
                        Expanded(
                          child: Text(
                            'In water time : ${DateFormat('hh:mm a').format(timeIn!)}',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                      Spacing.w20,
                      if (timeOut != null)
                        Expanded(
                          child: Text(
                            'Out water time : ${DateFormat('hh:mm a').format(timeOut!)}',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                    ],
                  ),
                  Spacing.h10,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Change In the water and out the water timings ',
                        style: TextStyle(fontSize: 10),
                      ),
                      InkWell(
                        onTap: () {
                          RoasterTimeEditorBs.show(context);
                        },
                        child: const Text(
                          ' here',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Spacing.h20,
                  Row(
                    children: [
                      const Text('Customer Review'),
                      const Spacer(),
                      AppButton.miniFlat(
                        text: 'Submit',
                        onTap: () {
                          CustomerFeedbackBottomSheet.show(
                            context,
                            bookingModel: booking,
                          );
                        },
                      ),
                    ],
                  ),
                  Spacing.h100,
                  AppButton.flat(
                    text: (booking.pax?[widget.paxIndex!]['roaster'] == null)
                        ? 'Submit'
                        : 'Update',
                    onTap: () async {
                      showLoading = true;
                      setState(() {});

                      Roaster roaster = Roaster(
                        instructor: assignedInstructor,
                        timeIn: timeIn,
                        timeOut: timeOut,
                        knowsSwimming: null,
                        interestedOwc: null,
                        remarks: customerRemarks.text,
                      );

                      if (widget.paxIndex != null) {
                        var pax = booking.pax![widget.paxIndex!];

                        if (pax['roaster'] != null &&
                            pax['roaster'] is Map<String, dynamic>) {
                          // Update existing `roaster` map
                          (pax['roaster'] as Map<String, dynamic>)
                              .addAll(roaster.toJson());
                        } else {
                          // Assign a new map if `roaster` doesn't exist
                          pax['roaster'] = roaster.toJson();
                        }
                      }

                      await FirebaseFirestore.instance
                          .collection('bookings')
                          .doc(booking.id)
                          .set(booking.toMap());
                      showLoading = false;
                      setState(() {});

                      Get.back();
                    },
                    color: Colors.black,
                    textColor: Colors.white,
                  ),
                  Spacing.h40,
                ],
              ).paddingSymmetric(horizontal: 20).scrollable,
      ),
    );
  }

  Widget buildTimeButtons({
    required String title,
    required Function onTap,
    required Color color,
  }) {
    return Expanded(
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Container(
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
            ),
            color: color,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(title),
        ),
      ),
    );
  }

  Widget buildInstructor() {
    return Row(
      children: [
        Text(
          'Instructor',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.text.black,
          ),
        ),
        const Spacer(),
        Container(
          height: 30,
          width: 120,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          child: DropdownButton(
            underline: const SizedBox(),
            isExpanded: true,
            value: assignedInstructor,
            onChanged: (dynamic mode) {
              assignedInstructor = mode;
              setState(() {});
            },
            items: dsdInstructors.map((newIns) {
              return DropdownMenuItem(
                value: newIns,
                child: Text(newIns.name),
              );
            }).toList(),
          ).paddingSymmetric(horizontal: 10),
        ),
      ],
    );
  }

  Widget buildSwitch({
    required String text,
    Function? onChanged,
    required bool switchValue,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ),
        Switch(
          value: switchValue,
          onChanged: onChanged as void Function(bool)?,
          activeColor: AppColors.text.skyBlue,
          inactiveThumbColor: AppColors.text.grey,
        ),
      ],
    );
  }
}
