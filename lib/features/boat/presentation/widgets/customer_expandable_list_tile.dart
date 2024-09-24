import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:temple_ui_tools/utils/utils.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/models/item_model.dart';
import '../../../../core/util/spacing_widgets.dart';
import '../../../../core/util/utils.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../activities/model/colors_data.dart';
import '../../../bookings/models/booking_model.dart';
import '../../../bookings/presentation/widgets/app_text_fields.dart';
import '../../models/boat_details.dart';
import '../../models/boats.dart';
import 'boat_selector.dart';
import 'counter_widget.dart';
import 'customer_booking_status.dart';
import 'employee_selector_bottom_sheet.dart';

class CustomerExpandableListTile extends StatefulWidget {
  const CustomerExpandableListTile({
    super.key,
    required this.title,
    required this.color,
    required this.itemModel,
    required this.selectedDate,
  });

  final String title;
  final ItemModel itemModel;
  final DateTime selectedDate;
  final Color color;

  @override
  State<CustomerExpandableListTile> createState() => _CustomerExpandableListTileState();
}

class _CustomerExpandableListTileState extends State<CustomerExpandableListTile> {
  bool isExpanded = false;

  ItemModel get itemModel => widget.itemModel;

  @override
  Widget build(BuildContext context) {
    final DocumentReference bookingDoc = FirebaseFirestore.instance.collection('bookings').doc(itemModel.bookingID);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInCubic,
      alignment: Alignment.topCenter,
      constraints: BoxConstraints(
        minHeight: isExpanded ? 500 : 50,
      ),
      width: Screen.width,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder(
              stream: bookingDoc.snapshots(),
              builder: (
                BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot,
              ) {
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

                final data = snapshot.data?.data();

                if (data == null) {
                  return const Icon(
                    Icons.warning,
                    size: 15,
                  );
                }

                Booking bookingModel = Booking.fromMap(data as Map<String, dynamic>);

                return Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Spacing.w10,
                          Flexible(
                            child: Text(
                              widget.title,
                              style: TextStyle(
                                color: AppColors.text.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Spacing.w10,
                          if ((bookingModel.getInstructor(widget.selectedDate) != null))
                            const Icon(
                              Icons.scuba_diving,
                              size: 13,
                            ),
                          Spacing.w10,
                          if ((bookingModel.getBoatInfo(widget.selectedDate)?.id ?? '').isNotEmpty)
                            const Icon(
                              Icons.directions_boat,
                              size: 13,
                            ),
                        ],
                      ),
                    ),
                    if (widget.itemModel.bookingModel?.isQuickBooking ?? false)
                      const Text(
                        '  (Quick)',
                        style: TextStyle(
                          fontSize: FontSize.small,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    IconButton(
                      splashRadius: 20,
                      icon: Icon(
                        isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                      ),
                      onPressed: () {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      },
                    ),
                  ],
                ).paddingSymmetric(vertical: 3);
              },
            ),
            isExpanded
                ? FutureBuilder(
                    future: Future.delayed(const Duration(milliseconds: 200)),
                    initialData: const SizedBox(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const SizedBox(height: 10),
                            const Text(
                              'Booking Details : ',
                              style: TextStyle(
                                fontSize: FontSize.textSize,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _buildKeyValuePairs(
                              'Booking Id',
                              itemModel.bookingID ?? '-',
                            ),
                            _buildKeyValuePairs(
                              'Course Name',
                              itemModel.activity,
                            ),
                            _buildKeyValuePairs('Session', itemModel.session),
                            if (!itemModel.bookingModel!.isQuickBooking)
                              _buildKeyValuePairs(
                                'Registered',
                                '${itemModel.bookingModel!.registeredUsers.length} / ${itemModel.bookingModel!.noOfPersons}',
                                isDanger: ((itemModel.bookingModel!.registeredUsers.length) !=
                                    (itemModel.bookingModel!.noOfPersons)),
                              ),
                            (itemModel.remarks == '')
                                ? _buildKeyValuePairs('Remarks', '-')
                                : _buildKeyValuePairs(
                                    'Remarks',
                                    itemModel.remarks.toString(),
                                  ),
                            StreamBuilder(
                              stream: bookingDoc.snapshots(),
                              builder: (
                                BuildContext context,
                                AsyncSnapshot<DocumentSnapshot> snapshot,
                              ) {
                                if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                }

                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Text('Loading...');
                                }
                                final data = snapshot.data?.data();

                                if (data == null) {
                                  return const Text('Document does not exist');
                                }

                                Booking bookingModel = Booking.fromMap(
                                  data as Map<String, dynamic>,
                                );
                                ItemModel bookingItemModel = ItemModel.fromBooking(bookingModel);

                                TextEditingController employeeNotesTED = TextEditingController(
                                  text: bookingItemModel.bookingModel!.boatDetails?.employeeNotes ?? '',
                                );

                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    buildManageInstructors(
                                      bookingItemModel,
                                      bookingModel,
                                    ),
                                    buildManageDiveBuddies(
                                      bookingItemModel,
                                      bookingModel,
                                    ),
                                    buildCustomerStatusAndBoat(bookingModel),
                                    buildCustomerTanks(bookingModel),
                                    AppTextField(
                                      controller: employeeNotesTED,
                                      hintText: 'Equipment Notes',
                                      minLines: 3,
                                      errorValidator: () {
                                        return null;
                                      },
                                      validator: (_) {
                                        return null;
                                      },
                                    ),
                                    const Text(
                                      'Notes wont be saved until "Update Notes" button is pressed',
                                      style: TextStyle(
                                        fontSize: 10,
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: AppButton.miniFlat(
                                        text: 'Update Notes',
                                        onTap: () {
                                          updateBoatDetails(
                                            bookingModel: bookingModel,
                                            employeeNotes: employeeNotesTED.text,
                                            selectedDate: widget.selectedDate,
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            Spacing.h20,
                            Spacing.h20,
                          ],
                        ).paddingSymmetric(horizontal: 15);
                      }
                      return const SizedBox();
                    },
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget buildCustomerStatusAndBoat(Booking bookingModel) {
    return Row(
      children: [
        BookingStatus(
          initialStatus: bookingModel.isDSD
              ? bookingModel.boatDetails?.bookingStatus ?? 0
              : bookingModel.getStatus(widget.selectedDate) ?? 0,
          onChanged: (int status) async {
            await updateBoatDetails(
              bookingModel: bookingModel,
              bookingStatus: status,
              selectedDate: widget.selectedDate,
            );
          },
          isDSD: (colorsData!.blue.contains(itemModel.activity)),
        ),
        const Spacer(),
        BoatSelector(
          key: UniqueKey(),
          selectedBoatId: bookingModel.getBoatInfo(widget.selectedDate)?.id ?? '',
          onChanged: (Boat? boat) async {
            if (boat != null) {
              await updateBoatDetails(
                bookingModel: bookingModel,
                boatId: boat.id,
                selectedDate: widget.selectedDate,
              );
            } else {
              await removeBoat(
                bookingModel: bookingModel,
                selectedDate: widget.selectedDate,
              );
            }
          },
          selectedDate: widget.selectedDate,
        ),
      ],
    );
  }

  Widget buildCustomerTanks(Booking bookingModel) {
    if (widget.itemModel.activity != 'Discover Scuba Diving') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Row(
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
                  ).paddingOnly(bottom: 10),
                  CounterWidget(
                    onChanged: (int val) {
                      updateBoatDetails(
                        bookingModel: bookingModel,
                        selectedDate: widget.selectedDate,
                        nitrox: val,
                      );
                    },
                    initialValue: bookingModel.getBoatInfo(widget.selectedDate)?.nitrox ?? 0,
                  ),
                ],
              ),
              Column(
                children: [
                  const Text(
                    'Air',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ).paddingOnly(bottom: 10),
                  CounterWidget(
                    onChanged: (int val) {
                      updateBoatDetails(
                        bookingModel: bookingModel,
                        selectedDate: widget.selectedDate,
                        air: val,
                      );
                    },
                    initialValue: bookingModel.getBoatInfo(widget.selectedDate)?.air ?? 0,
                  ),
                ],
              ),
            ],
          ),
        ],
      );
    }
    return const SizedBox();
  }

  Widget buildManageInstructors(
    ItemModel bookingItemModel,
    Booking bookingModel,
  ) {
    if (widget.itemModel.activity != 'Discover Scuba Diving') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: Screen.width - 170,
                child: const Text(
                  'Instructor  (N - A):',
                  style: TextStyle(
                    fontSize: FontSize.textSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  Instructor? currentInstructor = bookingModel.getInstructor(widget.selectedDate);

                  List<Instructor>? instructors = await EmpSelectorBottomSheet.getSelectedInstructors(
                    context,
                    initialSelectedInstructors: [
                      if (currentInstructor != null) currentInstructor,
                    ],
                    instructorLimit: 1,
                    employeeType: EmployeeType.showFreelancersDivers,
                    tanksRequired: true,
                    selectedDate: widget.selectedDate,
                    showAssignmentStatus: true,
                  );

                  if (instructors == null) return;

                  List<Instructor> oldInstructors = bookingModel.boatDetails?.instructors ?? [];

                  Instructor? newSelectedInstructor = instructors.firstOrNull;

                  if (newSelectedInstructor != null) {
                    if ((oldInstructors.isEmpty)) {
                      for (var date in (bookingModel.bookingDate ?? [])) {
                        var i = newSelectedInstructor.copyWith(
                          date: date,
                          air: newSelectedInstructor.air ?? 0,
                          nitrox: newSelectedInstructor.nitrox ?? 0,
                        );

                        oldInstructors.add(i);
                      }
                    } else if (newSelectedInstructor.date == DateFormat('dd-MM-yyyy').format(widget.selectedDate)) {
                      oldInstructors.remove(currentInstructor);
                      oldInstructors.add(newSelectedInstructor);
                    } else {
                      oldInstructors.add(newSelectedInstructor);
                    }
                  }

                  if (newSelectedInstructor == null && currentInstructor != null) {
                    oldInstructors.remove(currentInstructor);
                  }

                  await updateBoatDetails(
                    instructors: oldInstructors,
                    bookingModel: bookingModel,
                    selectedDate: widget.selectedDate,
                  );
                },
                child: Container(
                  height: 31,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(
                      30,
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Manage',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (bookingModel.getInstructor(widget.selectedDate) != null)
            _buildDiverName(
              '${bookingModel.getInstructor(widget.selectedDate)?.name} (${bookingModel.getInstructor(widget.selectedDate)?.nitrox ?? 0} - ${bookingModel.getInstructor(widget.selectedDate)?.air ?? 0})',
            ).paddingOnly(bottom: 6),
          const SizedBox(height: 10),
        ],
      );
    }
    return const SizedBox();
  }

  Widget buildManageDiveBuddies(
    ItemModel bookingItemModel,
    Booking bookingModel,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: Screen.width - 170,
              child: const Text(
                'Dive buddies (N - A) :',
                style: TextStyle(
                  fontSize: FontSize.textSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                List<Instructor>? diveBuddies = (await EmpSelectorBottomSheet.getSelectedInstructors(
                  context,
                  initialSelectedInstructors: bookingItemModel.bookingModel?.boatDetails?.diveBuddies ?? [],
                  instructorLimit: -1,
                  employeeType: EmployeeType.showAllDiveTeam,
                  tanksRequired: true,
                  selectedDate: widget.selectedDate,
                  showAssignmentStatus: true,
                ));

                await updateBoatDetails(
                  bookingModel: bookingModel,
                  selectedDate: widget.selectedDate,
                  diveBuddies: diveBuddies,
                );
              },
              child: Container(
                height: 31,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(
                    30,
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Manage',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (bookingItemModel.bookingModel?.boatDetails?.diveBuddies != null)
          ...?bookingItemModel.bookingModel!.boatDetails?.diveBuddies?.map(
            (e) {
              return _buildDiverName(
                '${e.name} (${e.nitrox ?? 0} - ${e.air ?? 0})',
              ).paddingOnly(bottom: 6);
            },
          ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildDiverName(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w600),
    );
  }

  Widget _buildKeyValuePairs(
    String key,
    String value, {
    bool isDanger = false,
    bool shrinkKey = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (shrinkKey)
          Text(
            key,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 13,
              letterSpacing: 0.3,
              fontWeight: FontWeight.w600,
            ),
          ).paddingOnly(right: 10)
        else
          Expanded(
            child: Text(
              key,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 13,
                letterSpacing: 0.3,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        SizedBox(
          width: 170,
          child: Text(
            value,
            // overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isDanger ? Colors.red : Colors.black,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ],
    ).paddingOnly(bottom: 6);
  }
}

Future<void> updateBoatDetails({
  required Booking bookingModel,
  required DateTime selectedDate,
  String? boatId,
  String? boatName,
  int? bookingStatus,
  int? nitrox,
  int? air,
  int? instructorNitrox,
  int? instructorAir,
  String? employeeNotes,
  List<Instructor>? instructors,
  List<Instructor>? diveBuddies,
}) async {
  if (bookingStatus != null) {
    if (bookingModel.isDSD) {
      bookingModel.boatDetails?.bookingStatus = bookingStatus;
    } else {
      bookingModel.setStatus(
        selectedDate,
        bookingStatus,
      );
    }
  } else if (boatId != null || air != null || nitrox != null) {
    BoatInfo? boatInfo = bookingModel.getBoatInfo(selectedDate);
    if (boatInfo == null) {
      boatInfo = BoatInfo(id: boatId ?? '', air: air ?? 0, nitrox: nitrox ?? 0);
    } else {
      boatInfo = boatInfo.copyWith(id: boatId, air: air, nitrox: nitrox);
    }

    bookingModel.setBoatInfo(
      selectedDate,
      boatInfo,
    );
  }

  bookingModel.boatDetails = bookingModel.boatDetails?.copyWith(
    bookingStatus: bookingStatus,
    employeeNotes: employeeNotes,
    instructors: instructors,
    diveBuddies: diveBuddies,
  );

  await FirebaseFirestore.instance.collection('bookings').doc(bookingModel.id).set(
        bookingModel.toMap(),
      );
}
