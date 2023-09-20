import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/util/spacing-widget.dart';
import 'package:temple_adventures/features/boat/presentation/widgets/counter-widget.dart';

import '../../../../core/models/item-model.dart';
import '../../../../core/util/utils.dart';
import '../../../../core/widgets/app-button.dart';
import '../../../activities/model/colors_data.dart';
import '../../../bookings/models/booking-model.dart';
import '../../../bookings/presentation/widgets/app-text-fields.dart';
import '../../models/boat-details.dart';
import '../../models/boats.dart';
import 'boat-selector.dart';
import 'customer-booking-status.dart';
import 'employee-selector-bottomSheet.dart';

class CustomerExpandableListTile extends StatefulWidget {
  const CustomerExpandableListTile({
    Key? key,
    required this.title,
    required this.color,
    required this.itemModel,
    required this.selectedDate,
  }) : super(key: key);

  final String title;
  final ItemModel itemModel;
  final DateTime selectedDate;
  final Color color;

  @override
  State<CustomerExpandableListTile> createState() =>
      _CustomerExpandableListTileState();
}

class _CustomerExpandableListTileState
    extends State<CustomerExpandableListTile> {
  bool isExpanded = false;

  ItemModel get itemModel => widget.itemModel;

  @override
  Widget build(BuildContext context) {
    final DocumentReference bookingDoc = FirebaseFirestore.instance
        .collection('bookings')
        .doc(itemModel.bookingID);

    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInCubic,
      alignment: Alignment.topCenter,
      constraints: BoxConstraints(
        minHeight: isExpanded ? 500 : 50,
      ),
      width: Get.width,
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
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError ||
                      snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
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
                    return Icon(
                      Icons.warning,
                      size: 15,
                    );
                  }

                  Booking bookingModel =
                      Booking.fromMap(data as Map<String, dynamic>);

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
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Spacing.w10,
                            if ((bookingModel.boatDetails?.instructors ?? [])
                                .isNotEmpty)
                              Icon(
                                Icons.scuba_diving,
                                size: 13,
                              ),
                            Spacing.w10,
                            if ((bookingModel
                                        .getBoatInfo(widget.selectedDate)
                                        ?.id ??
                                    '')
                                .isNotEmpty)
                              Icon(
                                Icons.directions_boat,
                                size: 13,
                              ),
                          ],
                        ),
                      ),
                      if (widget.itemModel.bookingModel?.isQuickBooking ??
                          false)
                        Text(
                          "  (Quick)",
                          style: TextStyle(
                              fontSize: FontSize.small,
                              fontWeight: FontWeight.bold),
                        ),
                      IconButton(
                        splashRadius: 20,
                        icon: Icon(isExpanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded),
                        onPressed: () {
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                      ),
                    ],
                  ).paddingSymmetric(vertical: 3);
                }),
            isExpanded
                ? FutureBuilder(
                    future: Future.delayed(Duration(milliseconds: 200)),
                    initialData: SizedBox(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 10),
                            Text(
                              "Booking Details : ",
                              style: TextStyle(
                                  fontSize: FontSize.textSize,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 10),
                            _buildKeyValuePairs(
                                "Booking Id", itemModel.bookingID ?? "-"),
                            _buildKeyValuePairs(
                                "Course Name", itemModel.activity),
                            if (!itemModel.bookingModel!.isQuickBooking)
                              _buildKeyValuePairs(
                                "Balance",
                                "${getBalance(itemModel.bookingModel?.payments ?? [], double.parse(itemModel.paid).roundToDouble(), double.parse(itemModel.cost).roundToDouble())} / -",
                              ),
                            _buildKeyValuePairs("Session", itemModel.session),
                            if (!itemModel.bookingModel!.isQuickBooking)
                              _buildKeyValuePairs(
                                "Registered",
                                "${itemModel.bookingModel!.pax!.length - 1} / ${itemModel.bookingModel!.noOfPersons}",
                                isDanger:
                                    ((itemModel.bookingModel!.pax!.length -
                                            1) !=
                                        (itemModel.bookingModel!.noOfPersons)),
                              ),
                            (itemModel.remarks == "")
                                ? _buildKeyValuePairs("Remarks", "-")
                                : _buildKeyValuePairs(
                                    "Remarks", itemModel.remarks.toString()),
                            SizedBox(height: 20),
                            StreamBuilder(
                                stream: bookingDoc.snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                                  if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  }

                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Text('Loading...');
                                  }
                                  final data = snapshot.data?.data();

                                  if (data == null) {
                                    return Text('Document does not exist');
                                  }

                                  Booking bookingModel = Booking.fromMap(
                                      data as Map<String, dynamic>);
                                  ItemModel bookingItemModel =
                                      ItemModel.fromBooking(bookingModel);

                                  TextEditingController employeeNotesTED =
                                      TextEditingController(
                                          text: bookingItemModel.bookingModel!
                                                  .boatDetails?.employeeNotes ??
                                              "");

                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      buildManageInstructors(
                                          bookingItemModel, bookingModel),
                                      buildManageDiveBuddies(
                                          bookingItemModel, bookingModel),
                                      buildCustomerStatusAndBoat(bookingModel),
                                      buildCustomerTanks(bookingModel),
                                      AppTextField(
                                        controller: employeeNotesTED,
                                        hintText: "Equipment Notes",
                                        minLines: 3,
                                        errorValidator: () {
                                          return null;
                                        },
                                        validator: (_) {
                                          return null;
                                        },
                                      ),
                                      Text(
                                        'Notes wont be saved until "Update Notes" button is pressed',
                                        style: TextStyle(
                                          fontSize: 10,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: AppButton.miniFlat(
                                          text: "Update Notes",
                                          onTap: () {
                                            updateBoatDetails(
                                              bookingModel: bookingModel,
                                              employeeNotes:
                                                  employeeNotesTED.text,
                                              selectedDate: widget.selectedDate,
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                            SizedBox(height: 20),
                            SizedBox(height: 20),
                          ],
                        ).paddingSymmetric(horizontal: 15);
                      }
                      return SizedBox();
                    })
                : SizedBox(),
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
                selectedDate: widget.selectedDate);
          },
          isDSD: (colorsData!.blue.contains(itemModel.activity)),
        ),
        Spacer(),
        BoatSelector(
          key: UniqueKey(),
          selectedBoatId:
              bookingModel.getBoatInfo(widget.selectedDate)?.id ?? "",
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
    if (widget.itemModel.activity != "Discover Scuba Diving")
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Row(
            children: [
              Column(
                children: [
                  Text(
                    "Nitrox",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ).paddingOnly(bottom: 10),
                  Container(
                    child: CounterWidget(
                        onChanged: (int val) {
                          updateBoatDetails(
                            bookingModel: bookingModel,
                            selectedDate: widget.selectedDate,
                            nitrox: val,
                          );
                        },
                        initialValue: bookingModel
                                .getBoatInfo(widget.selectedDate)
                                ?.nitrox ??
                            0),
                  )
                ],
              ),
              Column(
                children: [
                  Text(
                    "Air",
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
                      initialValue:
                          bookingModel.getBoatInfo(widget.selectedDate)?.air ??
                              0)
                ],
              ),
            ],
          ),
        ],
      );
    return SizedBox();
  }

  Widget buildManageInstructors(
      ItemModel bookingItemModel, Booking bookingModel) {
    if (widget.itemModel.activity != "Discover Scuba Diving")
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: Get.width - 170,
                child: Text(
                  "Instructors :",
                  style: TextStyle(
                    fontSize: FontSize.textSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  List<Instructor>? instructors =
                      await EmpSelectorBottomSheet.show(
                    context,
                    initialSelectedEmployees: bookingItemModel
                            .bookingModel?.boatDetails?.instructors ??
                        [],
                    instructorLimit: 1,
                    employeeType: EmployeeType.ShowFreelancersDivers,
                  );

                  log("tap instructors $instructors");

                  await updateBoatDetails(
                    instructors: instructors,
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
                  child: Center(
                    child: Text(
                      "Manage",
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
          SizedBox(height: 10),
          if (bookingItemModel.bookingModel?.boatDetails?.instructors != null)
            ...?bookingItemModel.bookingModel!.boatDetails?.instructors?.map(
              (e) {
                return _buildDiverName(
                        e.name,
                        bookingItemModel.bookingModel!.boatDetails!.instructors!
                            .indexOf(e))
                    .paddingOnly(bottom: 6);
              },
            ),
          SizedBox(height: 10),
          buildInstructorTanks(bookingModel, bookingItemModel),
          SizedBox(height: 20),
        ],
      );
    return SizedBox();
  }

  Widget buildInstructorTanks(
      Booking bookingModel, ItemModel bookingItemModel) {
    if (bookingItemModel.bookingModel?.boatDetails?.instructors?.length != 0)
      return Row(
        children: [
          Column(
            children: [
              Text(
                "Nitrox",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ).paddingOnly(bottom: 10),
              Container(
                child: CounterWidget(
                    onChanged: (int val) {
                      updateBoatDetails(
                        bookingModel: bookingModel,
                        selectedDate: widget.selectedDate,
                        instructorNitrox: val,
                      );
                    },
                    initialValue: bookingModel
                            .getInstructorTanks(widget.selectedDate)
                            ?.nitrox ??
                        0),
              )
            ],
          ),
          Column(
            children: [
              Text(
                "Air",
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
                      instructorAir: val,
                    );
                  },
                  initialValue: bookingModel
                          .getInstructorTanks(widget.selectedDate)
                          ?.air ??
                      0)
            ],
          ),
        ],
      );
    return SizedBox();
  }

  Widget buildManageDiveBuddies(
      ItemModel bookingItemModel, Booking bookingModel) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: Get.width - 170,
              child: Text(
                "Dive buddies (N - A) :",
                style: TextStyle(
                  fontSize: FontSize.textSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                List<Instructor> diveBuddies =
                    (await EmpSelectorBottomSheet.show(
                          context,
                          initialSelectedEmployees: bookingItemModel
                                  .bookingModel?.boatDetails?.diveBuddies ??
                              [],
                          instructorLimit: -1,
                          employeeType: EmployeeType.showAllDiveTeam,
                          tanksRequired: true,
                        )) ??
                        [];

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
                child: Center(
                  child: Text(
                    "Manage",
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
        SizedBox(height: 10),
        if (bookingItemModel.bookingModel?.boatDetails?.diveBuddies != null)
          ...?bookingItemModel.bookingModel!.boatDetails?.diveBuddies?.map(
            (e) {
              return _buildDiverName(
                      "${e.name} (${e.nitrox ?? 0} - ${e.air ?? 0})",
                      bookingItemModel.bookingModel!.boatDetails!.diveBuddies!
                          .indexOf(e))
                  .paddingOnly(bottom: 6);
            },
          ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildDiverName(String text, int index) {
    return RichText(
      text: TextSpan(
        text: (index + 1).toString(),
        style: TextStyle(
          color: Colors.grey[700],
          fontFamily: "Nunito",
          fontSize: 13,
          letterSpacing: 0.3,
          fontWeight: FontWeight.w600,
          height: 1.3,
        ),
        children: <TextSpan>[
          TextSpan(
            text: "   $text",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ],
      ),
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
        Container(
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

  String getBalance(List<PaymentModel> payments, double deposit, double total) {
    double t = deposit;
    payments.forEach((payment) {
      t += payment.amount!;
    });
    return (total - t).toInt().toString();
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
        boatInfo =
            BoatInfo(id: boatId ?? '', air: air ?? 0, nitrox: nitrox ?? 0);
      } else {
        boatInfo = boatInfo.copyWith(id: boatId, air: air, nitrox: nitrox);
      }

      bookingModel.setBoatInfo(
        selectedDate,
        boatInfo,
      );
    } else if (instructorAir != null || instructorNitrox != null) {
      InstructorTanks? instructorTanks =
          bookingModel.getInstructorTanks(selectedDate);
      if (instructorTanks == null) {
        instructorTanks = InstructorTanks(
            air: instructorAir ?? 0, nitrox: instructorNitrox ?? 0);
      } else {
        instructorTanks = instructorTanks.copyWith(
            air: instructorAir, nitrox: instructorNitrox);
      }

      bookingModel.setInstructorTanks(
        selectedDate,
        instructorTanks,
      );
    }

    bookingModel.boatDetails = bookingModel.boatDetails?.copyWith(
      bookingStatus: bookingStatus,
      employeeNotes: employeeNotes,
      instructors: instructors,
      diveBuddies: diveBuddies,
    );

    await FirebaseFirestore.instance
        .collection('bookings')
        .doc(bookingModel.id)
        .set(
          bookingModel.toMap(),
        );
  }
}
