import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/features/boat/presentation/widgets/counter-widget.dart';
import 'package:temple_adventures/features/boat/presentation/widgets/tank-counter.dart';

import '../../../../core/widgets/app-button.dart';
import '../../../../core/widgets/booking-expansion-panel.dart';
import '../../../bookings/models/booking-model.dart';
import '../../../bookings/presentation/widgets/app-text-fields.dart';
import '../../models/boat-details.dart';
import '../../models/boats.dart';
import 'boat-selector.dart';
import 'customer-booking-status.dart';
import 'employee-selector-bottomSheet.dart';
import 'interns-bottomSheet.dart';

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
            Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: Get.width - 200,
                  child: Text(
                    widget.title,
                    style: TextStyle(
                        color: AppColors.text.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Spacer(),
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

                      BookingModel bookingModel =
                          BookingModel.fromMap(data as Map<String, dynamic>);

                      return Row(
                        children: [
                          if ((bookingModel.boatDetails?.instructors ?? [])
                              .isNotEmpty)
                            Icon(
                              Icons.scuba_diving,
                              size: 15,
                            ),
                          SizedBox(
                            width: 10,
                          ),
                          if ((bookingModel
                                      .getBoatInfo(widget.selectedDate)
                                      ?.id ??
                                  '')
                              .isNotEmpty)
                            Icon(
                              Icons.directions_boat,
                              size: 15,
                            ),
                        ],
                      );
                    }),
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
            ).paddingSymmetric(vertical: 3),
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
                            _buildKeyValuePairs(
                              "Balance",
                              "${getBalance(itemModel.bookingModel?.payments ?? [], double.parse(itemModel.paid).roundToDouble(), double.parse(itemModel.cost).roundToDouble())} / -",
                            ),
                            _buildKeyValuePairs("Session", itemModel.session),
                            _buildKeyValuePairs(
                              "Registered",
                              "${itemModel.bookingModel!.pax!.length - 1} / ${itemModel.bookingModel!.noOfPersons}",
                              isDanger:
                                  ((itemModel.bookingModel!.pax!.length - 1) !=
                                      (itemModel.bookingModel!.noOfPersons)),
                            ),
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

                                  BookingModel bookingModel =
                                      BookingModel.fromMap(
                                          data as Map<String, dynamic>);
                                  ItemModel bookingItemModel =
                                      ItemModel.fromBookings(bookingModel);

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
                                      buildManageInterns(
                                          bookingItemModel, bookingModel),
                                      Row(
                                        children: [
                                          BookingStatus(
                                            initialStatus: bookingModel
                                                    .boatDetails
                                                    ?.bookingStatus ??
                                                0,
                                            onChanged: (int status) async {
                                              await updateBoatDetails(
                                                  bookingModel: bookingModel,
                                                  bookingStatus: status,
                                                  selectedDate:
                                                      widget.selectedDate);
                                            },
                                          ),
                                          Spacer(),
                                          BoatSelector(
                                            key: UniqueKey(),
                                            selectedBoatId: bookingModel
                                                    .getBoatInfo(
                                                        widget.selectedDate)
                                                    ?.id ??
                                                "",
                                            onChanged: (Boat boat) async {
                                              await updateBoatDetails(
                                                bookingModel: bookingModel,
                                                boatId: boat.id,
                                                selectedDate:
                                                    widget.selectedDate,
                                              );
                                            },
                                            selectedDate: widget.selectedDate,
                                          ),
                                        ],
                                      ),
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

  Widget buildCustomerTanks(BookingModel bookingModel) {
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
      ItemModel bookingItemModel, BookingModel bookingModel) {
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
                  "Instructors / Dive-Buddies :",
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
      BookingModel bookingModel, ItemModel bookingItemModel) {
    if(bookingItemModel.bookingModel?.boatDetails?.instructors?.length != 0)
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
                initialValue:
                    bookingModel.getInstructorTanks(widget.selectedDate)?.air ??
                        0)
          ],
        ),
      ],
    );
    return SizedBox();
  }

  Widget buildManageInterns(
      ItemModel bookingItemModel, BookingModel bookingModel) {
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
                "Interns (A - N) :",
                style: TextStyle(
                  fontSize: FontSize.textSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                List<Intern>? interns = await InternsBottomSheet.show(
                  context,
                  initialInterns:
                      bookingItemModel.bookingModel?.boatDetails?.interns ?? [],
                  surfaceSupport: false,
                );

                log("tap instructors $interns");

                await updateBoatDetails(
                  interns: interns,
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
        if (bookingItemModel.bookingModel?.boatDetails?.interns != null)
          ...?bookingItemModel.bookingModel!.boatDetails?.interns?.map(
            (e) {
              return _buildDiverName(
                      "${e.name} (${e.air} - ${e.nitrox})",
                      bookingItemModel.bookingModel!.boatDetails!.interns!
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
      children: [
        if (shrinkKey)
          Text(
            key,
            style: TextStyle(
                color: Colors.grey[700],
                fontSize: 13,
                letterSpacing: 0.3,
                fontWeight: FontWeight.w600,
                height: 1.3),
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
                  height: 1.3),
            ),
          ),
        Container(
          height: 16,
          width: 170,
          child: Text(
            value,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: isDanger ? Colors.red : Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
                height: 1.3),
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
    required BookingModel bookingModel,
    required DateTime selectedDate,
    String? boatId,
    String? boatName,
    List<Intern>? interns,
    int? bookingStatus,
    int? nitrox,
    int? air,
    int? instructorNitrox,
    int? instructorAir,
    String? employeeNotes,
    List<Instructor>? instructors,
  }) async {
    if (bookingStatus != null) {
      bookingModel.boatDetails?.bookingStatus = bookingStatus;
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
        interns: interns);

    await FirebaseFirestore.instance
        .collection('bookings')
        .doc(bookingModel.id)
        .set(
          bookingModel.toMap(),
        );
  }
}
