import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/util/alignment_extensions.dart';
import '../../../../core/util/spacing_widgets.dart';
import '../../../../core/util/utils.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/time_picker.dart';
import '../../../bookings/models/booking_model.dart';
import '../../../bookings/presentation/widgets/app_text_fields.dart';
import '../../models/boat_details.dart';
import '../../models/boats.dart';
import 'boat_status.dart';
import 'counter_widget.dart';
import 'employee_selector_bottom_sheet.dart';

class BoatDetailsBottomSheet extends StatefulWidget {
  const BoatDetailsBottomSheet({
    Key? key,
    required this.selectedDate,
    required this.isBoatEdit,
    this.boat,
  }) : super(key: key);

  final DateTime selectedDate;
  final Boat? boat;
  final bool isBoatEdit;

  static Future<BoatsModel?> show(
    BuildContext context, {
    required DateTime date,
    required bool isBoatEdit,
    Boat? initialBoat,
  }) async {
    var data = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (BuildContext context) {
        return BoatDetailsBottomSheet(
          selectedDate: date,
          isBoatEdit: isBoatEdit,
          boat: initialBoat,
        );
      },
    );

    return data as BoatsModel?;
  }

  @override
  State<BoatDetailsBottomSheet> createState() => _BoatDetailsBottomSheetState();
}

class _BoatDetailsBottomSheetState extends State<BoatDetailsBottomSheet> {
  List<Instructor> selectedCaptains = [];
  List<Instructor> selectedDsdInstructors = [];
  List<Instructor> selectedPhotographer = [];
  List<Instructor> surfaceSupport = [];
  List<Instructor> internsPhotoVideo = [];
  late TextEditingController boatTED;
  late TextEditingController boatNoTED;
  late TextEditingController diveSiteTED;
  late TextEditingController notesTED;
  int nitrox = 0;
  int air = 0;
  late DateTime selectedTime;
  int boatStatus = 0;
  bool hideBoat = false;
  bool isBoat = false;
  bool showLoading = false;

  @override
  void initState() {
    boatTED = TextEditingController(text: widget.boat?.name ?? '');
    notesTED = TextEditingController(text: widget.boat?.notes ?? '');
    diveSiteTED = TextEditingController(text: widget.boat?.diveSite);
    boatNoTED = TextEditingController(text: widget.boat?.boatNo);
    nitrox = widget.boat?.nitrox ?? 0;
    air = widget.boat?.air ?? 0;
    boatStatus = widget.boat?.boatStatus ?? 0;
    hideBoat = ((widget.boat?.hideBoat)) ?? hideBoat;
    isBoat = ((widget.boat?.isBoat)) ?? isBoat;
    log('start ${hideBoat.toString()}');
    if (widget.boat?.time != null) {
      selectedTime = TimePicker.getDateTime(widget.boat?.time ?? '') ?? DateTime.now();
    } else {
      selectedTime = DateTime.now();
    }
    if (widget.isBoatEdit) fetchEmployeeData();
    super.initState();
  }

  Future<void> fetchEmployeeData() async {
    if (widget.boat?.captains != null) {
      log(widget.boat!.captains.toString());

      selectedCaptains.addAll(widget.boat!.captains as Iterable<Instructor>);
      log(selectedCaptains.toString());
    }

    if (widget.boat?.dsdInstructors != null) {
      log(widget.boat!.dsdInstructors.toString());

      selectedDsdInstructors.addAll(widget.boat!.dsdInstructors as Iterable<Instructor>);
      log(selectedDsdInstructors.toString());
    }

    if (widget.boat?.photographer != null) {
      log(widget.boat!.photographer.toString());

      selectedPhotographer.addAll(widget.boat!.photographer as Iterable<Instructor>);
      log(selectedPhotographer.toString());
    }

    if (widget.boat?.surfaceSupport != null) {
      log(widget.boat!.surfaceSupport.toString());

      surfaceSupport.addAll(widget.boat!.surfaceSupport as Iterable<Instructor>);
      log(surfaceSupport.toString());
    }
    if (widget.boat?.internPhotoVideo != null) {
      log(widget.boat!.internPhotoVideo.toString());

      internsPhotoVideo.addAll(widget.boat!.internPhotoVideo as Iterable<Instructor>);
      log(internsPhotoVideo.toString());
    }
    if (mounted) setState(() {});
  }

  Future<void> selectTime(BuildContext context) async {
    final DateTime? pickedTime = await TimePicker.show(
      context,
      initialTime: selectedTime,
    );

    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 40,
        left: 25,
        right: 20,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          30,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  (widget.isBoatEdit) ? 'Edit Boat' : 'Add Boat',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ).paddingOnly(top: 8),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () async {
                    if (boatTED.text != '') {
                      await addEditBoat(context);
                    } else {
                      showToast('please enter the boat details');
                    }
                    // Navigator.pop(context);
                  },
                ),
              ],
            ),
            Spacing.h20,
            if (showLoading)
              const CircularProgressIndicator(
                color: Colors.black,
              ).center.height(Get.height)
            else ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BoatStatus(
                    initialStatus: boatStatus,
                    onChanged: (int status) {
                      boatStatus = status;
                    },
                  ),
                  if (widget.isBoatEdit) buildDeleteBoat(),
                ],
              ),
              Spacing.h10,
              Row(
                children: [
                  Text(
                    'Hide Boat',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.text.black,
                      fontFamily: AppFonts.nunito,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacing.w10,
                  Switch(
                    value: hideBoat,
                    activeColor: AppColors.text.skyBlue,
                    onChanged: (bool value) {
                      setState(() {
                        hideBoat = value;
                        log(hideBoat.toString());
                      });
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Other',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.text.black,
                      fontFamily: AppFonts.nunito,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacing.w10,
                  Switch(
                    value: isBoat,
                    activeColor: AppColors.text.skyBlue,
                    onChanged: (bool value) {
                      setState(() {
                        isBoat = value;
                        log(isBoat.toString());
                      });
                    },
                  ),
                  Spacing.w10,
                  Text(
                    'Boat',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.text.black,
                      fontFamily: AppFonts.nunito,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              AppTextField(
                hintText: 'Boat No',
                controller: boatNoTED,
                errorValidator: () {
                  return null;
                },
                validator: (_) {
                  return null;
                },
              ),
              AppTextField(
                hintText: 'Boat Name',
                controller: boatTED,
                errorValidator: () {
                  return null;
                },
                validator: (_) {
                  return null;
                },
              ),
              AppTextField(
                hintText: 'Dive Site',
                controller: diveSiteTED,
                errorValidator: () {
                  return null;
                },
                validator: (_) {
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text(
                    'Boat time',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      log(selectedTime.toString());
                      selectTime(context);
                    },
                    child: Container(
                      height: 30,
                      width: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Text(
                          TimePicker.getFormattedTime(selectedTime) ?? 'No time selected',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Spacing.h20,
              if (isBoat)
                buildEmployeeSelector(
                  employees: selectedCaptains,
                  title: 'Captains',
                  employeeLimit: 2,
                  isTanksRequired: false,
                  employeeType: EmployeeType.showCaptains,
                ),
              Spacing.h20,
              buildEmployeeSelector(
                employees: selectedDsdInstructors,
                title: 'DSD Instructors',
                employeeLimit: -1,
                isTanksRequired: true,
                employeeType: EmployeeType.showFreelancersDivers,
              ),
              Spacing.h20,
              buildEmployeeSelector(
                employees: selectedPhotographer,
                title: 'Photographer / Videographer',
                employeeLimit: 2,
                isTanksRequired: true,
                employeeType: EmployeeType.showFreelancersDivers,
              ),
              Spacing.h20,
              buildEmployeeSelector(
                employees: internsPhotoVideo,
                title: 'Intern Photographer / Videographer',
                employeeLimit: 2,
                employeeType: EmployeeType.showInterns,
                isTanksRequired: true,
              ),
              Spacing.h20,
              buildEmployeeSelector(
                employees: surfaceSupport,
                title: 'Surface Support',
                employeeLimit: -1,
                employeeType: EmployeeType.showAllEmployees,
                isTanksRequired: false,
              ),
              AppTextField(
                hintText: 'Notes',
                controller: notesTED,
                errorValidator: () {
                  return null;
                },
                validator: (_) {
                  return null;
                },
              ),
              Spacing.h20,
              Text(
                'Extra / Spare Tanks : ',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.text.black,
                  fontFamily: AppFonts.nunito,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacing.h20,
              buildSpareTankCount(),
              Spacing.h50,
              Center(
                child: AppButton.flat(
                  height: 50,
                  width: 145,
                  text: (widget.isBoatEdit) ? 'Update' : 'Submit',
                  onTap: () async {
                    if (boatTED.text != '') {
                      await addEditBoat(context);
                    } else {
                      showToast('please enter the boat name');
                    }
                  },
                  textColor: Colors.white,
                  color: Colors.black,
                ),
              ),
              Spacing.h30,
            ],
          ],
        ),
      ),
    );
  }

  Widget buildDeleteBoat() {
    return TextButton(
      onPressed: () {
        _deleteBoat();
      },
      child: Row(
        children: [
          Text(
            'Delete Boat',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.text.black,
              fontFamily: AppFonts.nunito,
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.w600,
            ),
          ),
          Spacing.w10,
          const Icon(
            Icons.delete,
            color: Colors.black,
            size: 15,
          ),
        ],
      ),
    );
  }

  Future<void> _deleteBoat() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Are you Sure! You want to delete?',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          content: Text(
            '${widget.boat?.name} @ ${widget.boat?.time}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
            ),
          ),
          actions: <Widget>[
            AppButton.miniText(
              text: 'Cancel',
              onTap: () {
                Get.back();
              },
            ),
            AppButton.miniFlat(
              text: 'Okay',
              onTap: () async {
                var bookingSnapShots = await FirebaseFirestore.instance
                    .collection('bookings')
                    .where(
                      'boatDetails.boat.${DateFormat("dd-MM-yyyy").format(widget.selectedDate)}.id',
                      isEqualTo: widget.boat?.id ?? '',
                    )
                    .get();

                List<Booking> bookings = [];
                for (var doc in bookingSnapShots.docs) {
                  Booking booking = Booking.fromMap(doc.data());
                  bookings.add(booking);
                }

                // un-assign
                for (Booking booking in bookings) {
                  booking.setBoatInfo(widget.selectedDate, null);
                  await FirebaseFirestore.instance.collection('bookings').doc(booking.id).set(booking.toMap());
                }

                //delete boat
                var d = await FirebaseFirestore.instance
                    .collection('dailyBoats')
                    .doc(DateFormat('dd-MM-yyyy').format(widget.selectedDate))
                    .get();

                Map<String, dynamic>? data = d.data();
                BoatsModel? boatsModel = BoatsModel.fromMap(data);

                (boatsModel.boats ?? []).removeWhere((boat) => boat.id == widget.boat?.id);

                await FirebaseFirestore.instance
                    .collection('dailyBoats')
                    .doc(DateFormat('dd-MM-yyyy').format(widget.selectedDate))
                    .set(boatsModel.toMap());
                Get.back();
                Get.back();
                setState(() {});
                log('deleted');
              },
            ),
          ],
          actionsAlignment: MainAxisAlignment.spaceBetween,
        );
      },
    );
  }

  Widget buildSpareTankCount() {
    return Row(
      children: [
        Column(
          children: [
            const Text(
              'Nitrox',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ).paddingOnly(bottom: 15),
            CounterWidget(
              onChanged: (int val) {
                nitrox = val;
                setState(() {});
              },
              initialValue: nitrox,
            ),
          ],
        ),
        const SizedBox(width: 20),
        Column(
          children: [
            const Text(
              'Air',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ).paddingOnly(bottom: 15),
            CounterWidget(
              onChanged: (int val) {
                air = val;
                setState(() {});
              },
              initialValue: air,
            ),
          ],
        ),
      ],
    );
  }

  Widget buildEmployeeSelector({
    required List<Instructor> employees,
    required String title,
    required int employeeLimit,
    required EmployeeType employeeType,
    required bool isTanksRequired,
  }) {
    if (employees.isEmpty) {
      return AppButton.miniFlat(
        text: 'Add $title',
        onTap: () async {
          employees = await EmpSelectorBottomSheet.getSelectedInstructors(
                context,
                initialSelectedInstructors: employees,
                instructorLimit: employeeLimit,
                employeeType: employeeType,
                tanksRequired: isTanksRequired,
              ) ??
              [];

          setState(() {});
        },
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  "$title ${(isTanksRequired) ? "(N - A)" : ""}",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 60,
              child: GestureDetector(
                onTap: () async {
                  employees = (await EmpSelectorBottomSheet.getSelectedInstructors(
                        context,
                        initialSelectedInstructors: employees,
                        instructorLimit: employeeLimit,
                        employeeType: employeeType,
                        tanksRequired: isTanksRequired,
                      )) ??
                      [];

                  setState(() {});
                },
                child: const Text(
                  'Change',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ).paddingOnly(left: 10, right: 7),
              ),
            ),
            const Icon(
              Icons.edit,
              size: 12,
              color: Colors.blue,
            ),
          ],
        ),
        Spacing.h20,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...employees.map(
              (e) => Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${e.name} ',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (isTanksRequired)
                        Text(
                          '(${e.nitrox ?? 0} - ${e.air ?? 0})',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ],
              ).paddingOnly(bottom: 20),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> addEditBoat(BuildContext context) async {
    setState(() {
      showLoading = true;
    });

    String boatId;
    DocumentReference boatRef =
        FirebaseFirestore.instance.collection('dailyBoats').doc(DateFormat('dd-MM-yyyy').format(widget.selectedDate));

    BoatsModel? boatsModel;

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot boatSnapshot = await transaction.get(boatRef);
      Map<String, dynamic>? data = boatSnapshot.data() as Map<String, dynamic>?;
      boatsModel = BoatsModel.fromMap(data);

      if (widget.isBoatEdit) {
        boatId = widget.boat!.id;
        Boat boat = Boat(
          captains: selectedCaptains,
          id: boatId,
          name: boatTED.text,
          surfaceSupport: surfaceSupport,
          notes: notesTED.text,
          nitrox: nitrox,
          air: air,
          time: TimePicker.getFormattedTime(selectedTime)!,
          diveSite: diveSiteTED.text,
          dsdInstructors: selectedDsdInstructors,
          photographer: selectedPhotographer,
          boatStatus: boatStatus,
          hideBoat: hideBoat,
          internPhotoVideo: internsPhotoVideo,
          isBoat: isBoat,
          boatNo: boatNoTED.text,
        );

        boatsModel?.boats?.removeWhere((b) => b.id == boatId);
        boatsModel?.boats?.add(boat);
      } else {
        boatId = DateTime.now().millisecondsSinceEpoch.toString();
        Boat boat = Boat(
          captains: selectedCaptains,
          id: boatId,
          name: boatTED.text,
          surfaceSupport: surfaceSupport,
          notes: notesTED.text,
          nitrox: nitrox,
          air: air,
          time: TimePicker.getFormattedTime(selectedTime)!,
          diveSite: diveSiteTED.text,
          dsdInstructors: selectedDsdInstructors,
          photographer: selectedPhotographer,
          boatStatus: boatStatus,
          hideBoat: hideBoat,
          internPhotoVideo: internsPhotoVideo,
          isBoat: isBoat,
          boatNo: boatNoTED.text,
        );

        boatsModel?.boats?.add(boat);

        transaction.set(boatRef, boatsModel?.toMap());
      }
    });
    setState(() {
      showLoading = false;
    });

    // ignore: use_build_context_synchronously
    Navigator.pop(context, boatsModel);
  }
}
