import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/util/alignment_extensions.dart';
import '../../../../core/util/spacing_widgets.dart';
import '../../../boat/models/boat_details.dart';
import '../../../boat/models/boats.dart';
import '../../../bookings/models/activity_model.dart';
import '../../../bookings/models/booking_model.dart';

List<String> coursesStatus = [
  'Booked In',
  'Paperwork done',
  'Dive center',
  'Harbour',
];

List<String> dsdStatus = [
  'Booked In',
  'Paperwork done',
  'Pool ongoing',
  'Pool completed',
  'Dive center',
  'Harbour',
];

class CustomerList extends StatefulWidget {
  const CustomerList({Key? key, required this.bookings, required this.boat}) : super(key: key);

  final List<Booking> bookings;
  final Boat boat;

  @override
  State<CustomerList> createState() => CustomerListState();
}

class CustomerListState extends State<CustomerList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 190,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.black,
        ),
      ),
      child: buildCustomerListTable(),
    );
  }

  List<Booking> get getBookings {
    List<Booking> bookings = widget.bookings.where((Booking booking) {
      return (booking.getBoatInfo(selectedDate)?.id == widget.boat.id);
    }).toList();

    return bookings;
  }

  Map<String?, List<Booking>> groupBookingByInstructorId() {
    Map<String?, List<Booking>> groupedStudents = {};
    groupedStudents['others'] = [];
    for (var booking in getBookings) {
      String? id = booking.instructor?.id;
      if (id == null) {
        groupedStudents['others']!.add(booking);
        continue;
      } else if (!groupedStudents.containsKey(id)) {
        groupedStudents[id] = [];
      }
      groupedStudents[id]!.add(booking);
    }

    List<String?> sortedKeys = groupedStudents.keys.toList()..sort();

    Map<String?, List<Booking>> sortedMap = {};
    for (var key in sortedKeys) {
      sortedMap[key] = groupedStudents[key]!;
    }

    return sortedMap;
  }

  Widget buildCustomerListTable() {
    return Column(
      children: [
        buildBoatDetails(),
        const Divider(height: 1, color: Colors.black),
        buildHeadings(),
        const Divider(height: 1, color: Colors.black),
        ...groupBookingByInstructorId().entries.map((e) {
          String? id = e.key;
          List<String?> items = groupBookingByInstructorId().keys.toList();
          final List<Booking> bookings = e.value;

          return buildCustomersList(bookings, items.indexOf(id) + 1);
        }),
        const Divider(
          color: Colors.black,
          height: 1,
        ),
        if (widget.boat.dsdInstructors != null)
          ...(widget.boat.dsdInstructors ?? []).map(
            (e) => Row(
              children: [
                const Text(
                  ' - ',
                  style: TextStyle(fontWeight: FontWeight.normal, color: Colors.red),
                ).width(10),
                Text(
                  e.name,
                  style: const TextStyle(fontFamily: AppFonts.nunito, fontSize: 7.0, color: Colors.red),
                ).paddingOnly(top: 3, left: 3).width(73),
                Row(
                  children: [
                    Text(
                      e.air?.toString() ?? '0',
                      style: const TextStyle(fontFamily: AppFonts.nunito, fontSize: 7.0, color: Colors.blue),
                    ),
                    const Text(
                      ' - ',
                      style: TextStyle(
                        fontFamily: AppFonts.nunito,
                        fontSize: 7.0,
                      ),
                    ),
                    Text(
                      e.nitrox?.toString() ?? '0',
                      style: const TextStyle(fontFamily: AppFonts.nunito, fontSize: 7.0, color: Colors.green),
                    ),
                  ],
                ).width(20),
                Spacing.w24,
                const Text(
                  'DSD Staff',
                  style: TextStyle(fontFamily: AppFonts.nunito, fontSize: 7.0, color: Colors.blue),
                ).paddingOnly(
                  top: 3,
                  left: 13,
                ),
              ],
            ),
          ),
        if (widget.boat.photographer != null)
          ...widget.boat.photographer!.map(
            (e) => Row(
              children: [
                const Text(
                  '📷',
                  style: TextStyle(
                    fontFamily: AppFonts.nunito,
                    fontSize: 7.0,
                  ),
                ).width(10),
                Text(
                  e.name,
                  style: const TextStyle(fontFamily: AppFonts.nunito, fontSize: 7.0, color: Colors.red),
                ).paddingOnly(top: 3, left: 3).width(73),
                SizedBox(
                  width: 22,
                  child: Row(
                    children: [
                      Text(
                        e.air?.toString() ?? '0',
                        style: const TextStyle(fontFamily: AppFonts.nunito, fontSize: 7.0, color: Colors.blue),
                      ),
                      const Text(' - ', style: TextStyle(fontFamily: AppFonts.nunito, fontSize: 7.0)),
                      Text(
                        e.nitrox?.toString() ?? '0',
                        style: const TextStyle(fontFamily: AppFonts.nunito, fontSize: 7.0, color: Colors.green),
                      ),
                    ],
                  ),
                ),
                Spacing.w24,
                const Text(
                  'Photo / Video',
                  style: TextStyle(fontFamily: AppFonts.nunito, fontSize: 7.0, color: Colors.blue),
                ).paddingOnly(
                  top: 3,
                  left: 13,
                ),
              ],
            ),
          ),
        if (widget.boat.internPhotoVideo != null)
          ...widget.boat.internPhotoVideo!.map(
            (e) => Row(
              children: [
                const Text(
                  '📷',
                  style: TextStyle(
                    fontFamily: AppFonts.nunito,
                    fontSize: 7.0,
                  ),
                ).width(10),
                Text(e.name, style: const TextStyle(fontFamily: AppFonts.nunito, fontSize: 7.0, color: Colors.green))
                    .paddingOnly(top: 3, left: 3)
                    .width(73),
                SizedBox(
                  width: 20,
                  child: Row(
                    children: [
                      Text(
                        (e.air ?? 0).toString(),
                        style: const TextStyle(fontFamily: AppFonts.nunito, fontSize: 7.0, color: Colors.blue),
                      ),
                      const Text(
                        ' - ',
                        style: TextStyle(
                          fontFamily: AppFonts.nunito,
                          fontSize: 7.0,
                        ),
                      ),
                      Text(
                        (e.nitrox ?? 0).toString(),
                        style: const TextStyle(fontFamily: AppFonts.nunito, fontSize: 7.0, color: Colors.green),
                      ),
                    ],
                  ),
                ),
                Spacing.w24,
                const Text(
                  'Photo / Video',
                  style: TextStyle(fontFamily: AppFonts.nunito, fontSize: 7.0, color: Colors.blue),
                ).paddingOnly(
                  top: 3,
                  left: 13,
                ),
              ],
            ),
          ),
        const Divider(
          color: Colors.black,
          height: 1,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if ((widget.boat.air ?? 0) != 0)
                  buildHeadingItem(
                    'Total Air (w Extra / Spare): ',
                    '${getTotalAirCount(widget.bookings, widget.boat) + widget.boat.air!}',
                  )
                else
                  buildHeadingItem(
                    'Total Air : ',
                    '${getTotalAirCount(widget.bookings, widget.boat)}',
                  ),
                if ((widget.boat.nitrox ?? 0) != 0)
                  buildHeadingItem(
                    'Total Nitrox (w Extra / Spare): ',
                    '${getTotalAirCount(widget.bookings, widget.boat, true) + widget.boat.nitrox!}',
                  )
                else
                  buildHeadingItem(
                    'Total Nitrox : ',
                    '${getTotalAirCount(widget.bookings, widget.boat, true)}',
                  ),
                buildHeadingItem(
                  'Total Tanks: ',
                  '${getTotalAirCount(widget.bookings, widget.boat, true) + getTotalAirCount(widget.bookings, widget.boat, false) + (widget.boat.nitrox ?? 0) + (widget.boat.air ?? 0)}',
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildHeadingItem(
                  'Total Pax : ',
                  '${getTotalPAXCount(widget.bookings, widget.boat)}',
                ),
                buildHeadingItem(
                  'DSD Instructors : ',
                  '${widget.boat.dsdInstructors?.length}',
                ),
                buildHeadingItem(
                  'Total DSD PAX : ',
                  '${getTotalDSDPAXCount(widget.bookings, widget.boat)}',
                ),
                buildHeadingItem(
                  'Total Instructors : ',
                  '${getTotalInstructorCount(widget.bookings, widget.boat)}',
                ),
                buildHeadingItem(
                  'Total Courses : ',
                  '${getTotalCourseCount(widget.bookings, widget.boat)}',
                ),
              ],
            ),
          ],
        ).paddingAll(3),
      ],
    );
  }

  int airCount = 0;

  Widget buildCustomersList(List<Booking> bookings, int slNo) {
    if (bookings.isEmpty) {
      return const SizedBox();
    }

    int airTotal = 0;
    int nitroxTotal = 0;

    for (var booking in bookings) {
      int air = booking.getInstructorTanks(selectedDate)?.air ?? 0;
      int nitrox = booking.getInstructorTanks(selectedDate)?.nitrox ?? 0;

      airTotal += air;
      nitroxTotal += nitrox;
    }

    if (bookings[0].instructor == null) {
      List<Booking> dsds = [];
      List<Booking> otherBookings = [];

      for (var booking in bookings) {
        if (booking.activity![0]!.id == '11') {
          dsds.add(booking);
        } else {
          otherBookings.add(booking);
        }
      }
      return Column(
        children: [
          ...List.generate(
            otherBookings.length,
            (index) => buildCustomerListItem(index, otherBookings, '?'),
          ),
          ...List.generate(
            dsds.length,
            (index) => buildCustomerListItem(index, dsds, '-'),
          ),
        ],
      );
    }

    return Container(
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black26, width: 1))),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spacing.w3,
              SizedBox(
                width: 10,
                child: Text(
                  slNo.toString(),
                  style: const TextStyle(
                    fontFamily: AppFonts.nunito,
                    fontSize: 7.0,
                  ),
                ),
              ).paddingOnly(
                top: 3,
              ),
              Text(
                bookings[0].instructor?.name ?? '-',
                style: const TextStyle(fontFamily: AppFonts.nunito, fontSize: 7.0, color: Colors.red),
              )
                  .paddingOnly(
                    top: 3,
                  )
                  .left
                  .width(70),
              SizedBox(
                width: 20,
                child: Row(
                  children: [
                    Text(
                      '$airTotal',
                      style: const TextStyle(fontFamily: AppFonts.nunito, fontSize: 7.0, color: Colors.blue),
                    ),
                    const Text(
                      ' - ',
                      style: TextStyle(
                        fontFamily: AppFonts.nunito,
                        fontSize: 7.0,
                      ),
                    ),
                    Text(
                      '$nitroxTotal',
                      style: const TextStyle(fontFamily: AppFonts.nunito, fontSize: 7.0, color: Colors.green),
                    ),
                  ],
                ),
              ).paddingOnly(top: 3),
            ],
          ),
          ...List.generate(
            bookings.length,
            (index) => buildCustomerListItem(index, bookings, ' '),
          ),
        ],
      ),
    );
  }

  Widget buildCustomerListItem(int index, List<Booking> bookings, String slNo) {
    return Container(
      width: 190,
      decoration: BoxDecoration(
        color: index.isOdd ? Colors.white : AppColors.text.skyBlue.withOpacity(0.2),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spacing.w3,
              SizedBox(
                width: 10,
                child: Text(
                  slNo,
                  style: const TextStyle(
                    fontFamily: AppFonts.nunito,
                    fontSize: 7.0,
                  ),
                ),
              ),
              SizedBox(
                width: 70,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${bookings[index].pax?[0]['first-name']} x ${bookings[index].noOfPersons}",
                      style: const TextStyle(
                        fontFamily: AppFonts.nunito,
                        fontSize: 7.0,
                      ),
                    ),
                    if (bookings[index].boatDetails?.employeeNotes != null &&
                        bookings[index].boatDetails?.employeeNotes != '')
                      Text(
                        'Notes: ${bookings[index].boatDetails?.employeeNotes}',
                        style: const TextStyle(fontFamily: AppFonts.nunito, fontSize: 7.0, color: Colors.grey),
                      ),
                  ],
                ),
              ),
              SizedBox(
                width: 22,
                child: Row(
                  children: [
                    Text(
                      (bookings[index].activity![0]!.id == '11')
                          ? '${bookings[index].noOfPersons}'
                          : '${bookings[index].getBoatInfo(selectedDate)?.air ?? 0}',
                      style: const TextStyle(fontFamily: AppFonts.nunito, fontSize: 7.0, color: Colors.blue),
                    ),
                    const Text(
                      ' - ',
                      style: TextStyle(
                        fontFamily: AppFonts.nunito,
                        fontSize: 7.0,
                      ),
                    ),
                    Text(
                      '${bookings[index].getBoatInfo(selectedDate)?.nitrox ?? 0}',
                      style: const TextStyle(fontFamily: AppFonts.nunito, fontSize: 7.0, color: Colors.green),
                    ),
                  ],
                ),
              ),
              FutureBuilder<String?>(
                future: getActivityShortName(bookings[index].activity?[0]),
                builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 5,
                      width: 5,
                      child: CircularProgressIndicator(
                        strokeWidth: 0.5,
                        color: Colors.black,
                      ),
                    ); // Show a loading indicator
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return buildText(' ${snapshot.data}', 30);
                  }
                },
              ),
              Spacing.w5,
              Container(
                decoration: BoxDecoration(
                  color: getBookingStatusColor(
                    bookings[index].isDSD
                        ? bookings[index].boatDetails?.bookingStatus ?? 0
                        : bookings[index].getStatus(selectedDate) ?? 0,
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: buildText(
                  bookings[index].isDSD
                      ? dsdStatus[bookings[index].boatDetails?.bookingStatus ?? 0]
                      : coursesStatus[bookings[index].getStatus(selectedDate) ?? 0],
                  40,
                  Colors.white,
                  true,
                ).paddingOnly(top: 2, left: 1, right: 1),
              )
            ],
          ).paddingOnly(top: 3),
          buildDiveBuddiesList(bookings, index),
        ],
      ),
    );
  }

  Widget buildDiveBuddiesList(List<Booking> bookings, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Spacing.w3,
        Spacing.w10,
        SizedBox(
          width: 70,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if ((bookings[index].boatDetails?.diveBuddies ?? []).isNotEmpty)
                ...(bookings[index].boatDetails?.diveBuddies ?? [])
                    .map(
                      (diveBuddy) => Text(
                        diveBuddy.name.capitalizeFirst ?? '-',
                        style: const TextStyle(fontFamily: AppFonts.nunito, fontSize: 7.0, color: Colors.green),
                      ),
                    )
                    .toList(),
            ],
          ),
        ),
        SizedBox(
          width: 22,
          child: Column(
            children: [
              if ((bookings[index].boatDetails?.diveBuddies ?? []).isNotEmpty)
                ...(bookings[index].boatDetails?.diveBuddies ?? [])
                    .map(
                      (diveBuddy) => Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${diveBuddy.air ?? 0}',
                            style: const TextStyle(fontFamily: AppFonts.nunito, fontSize: 7.0, color: Colors.blue),
                          ),
                          const Text(
                            ' - ',
                            style: TextStyle(
                              fontFamily: AppFonts.nunito,
                              fontSize: 7.0,
                            ),
                          ),
                          Text(
                            '${diveBuddy.nitrox ?? 0}',
                            style: const TextStyle(fontFamily: AppFonts.nunito, fontSize: 7.0, color: Colors.green),
                          ),
                        ],
                      ),
                    )
                    .toList()
            ],
          ),
        ),
      ],
    );
  }

  Widget buildHeadings() {
    return Row(
      children: [
        Spacing.w3,
        buildText('#   Name', 80),
        buildText('A - N', 20),
        buildText('Course', 30, null, true),
        Spacing.w5,
        buildText('Status', 35, null, true),
      ],
    ).paddingOnly(top: 2);
  }

  List<String> boatStatus = [
    'Boat Ready',
    'Waiting for Captains',
    'Left Harbour',
    'Reached Dive site',
    'Diving',
    'Dives done',
    'Docked at Harbour',
  ];

  Widget buildBoatDetails() {
    return Container(
      color: getBoatDetailsColor(widget.boat.boatStatus ?? 0).withOpacity(0.2),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 90,
                    child: Text(
                      widget.boat.name,
                      style: const TextStyle(
                        fontFamily: AppFonts.nunito,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                  buildHeadingItem('Time: ', widget.boat.time),
                  buildHeadingItem('Date: ', DateFormat('dd-MM-yyyy').format(selectedDate)),
                  buildHeadingItem(
                    'Status: ',
                    boatStatus[widget.boat.boatStatus ?? 0],
                  ),
                ],
              ),
              Container(
                constraints: const BoxConstraints(
                  minWidth: 10,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Spacing.h2,
                  if (widget.boat.captains?.isNotEmpty ?? false)
                    buildHeadingItem('Captain 1:', " ${widget.boat.captains?[0].name ?? '-'}"),
                  if ((widget.boat.captains?.length ?? 0) == 2)
                    buildHeadingItem('Captain 2:', " ${widget.boat.captains?[1].name ?? '-'}"),
                  buildHeadingItem('Dive Site:', " ${widget.boat.diveSite ?? '-'}"),
                  Wrap(
                    children: [
                      const Text(
                        'Surface Support:',
                        style: TextStyle(
                          fontFamily: AppFonts.nunito,
                          fontSize: 7.0,
                        ),
                      ).paddingSymmetric(vertical: 1),
                      ...(widget.boat.surfaceSupport ?? []).map(
                        (e) => Text(
                          '${e.name} ,',
                          style: TextStyle(
                            fontFamily: AppFonts.nunito,
                            fontSize: 7.0,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ).width(64),
                  buildHeadingItem('Boat Notes: ', widget.boat.notes ?? '-'),
                  Spacing.h2,
                ],
              ),
            ],
          ).paddingSymmetric(horizontal: 5)
        ],
      ),
    );
  }

  Widget buildHeadingItem(String title, String val, [Color? valueColor]) {
    return RichText(
      text: TextSpan(
        text: '$title ',
        style: const TextStyle(fontFamily: AppFonts.nunito, fontSize: 7.0, color: Colors.black),
        children: <TextSpan>[
          TextSpan(
            text: val,
            style: TextStyle(
              fontFamily: AppFonts.nunito,
              fontSize: 7.0,
              fontWeight: FontWeight.normal,
              color: valueColor ?? Colors.grey.shade700,
            ),
          ),
        ],
      ),
    ).width(100 - 32).paddingSymmetric(vertical: 1);
  }

  Widget buildText(String title, [double? width, Color? color, bool isCenter = false]) {
    Widget t = Text(
      title,
      style: TextStyle(
        fontFamily: AppFonts.nunito,
        fontSize: 7.0,
        color: color,
      ),
      textAlign: isCenter ? TextAlign.center : null,
    );

    return SizedBox(
      width: width,
      child: isCenter ? t.center : t,
    );
  }

  Future<String> getActivityShortName(Activity? activity) async {
    if (activity?.shortName != null) {
      return activity!.shortName!;
    } else {
      var data = await FirebaseFirestore.instance.collection('catalogue').doc(activity?.id).get();
      Map<String, dynamic>? doc = data.data();

      if (doc != null) {
        Activity newActivity = Activity.fromMap(doc);
        return newActivity.shortName ?? newActivity.name ?? '-';
      }
    }
    return activity?.name ?? '-';
  }

  Color getBookingStatusColor(int index) {
    if (index == 0) {
      return Colors.blueAccent.withOpacity(0.6);
    } else if (index == 1) {
      return Colors.blue;
    } else if (index == 2) {
      return Colors.greenAccent;
    } else if (index == 3) {
      return Colors.green;
    } else if (index == 4) {
      return Colors.purple.shade400;
    } else if (index == 5) {
      return Colors.black.withOpacity(0.5);
    } else if (index == 6) {
      return Colors.yellow;
    } else if (index == 7) {
      return Colors.pink;
    } else if (index == 8) {
      return Colors.orange;
    } else if (index == 9) {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }

  Color getBoatDetailsColor(int index) {
    if (index == 0) {
      return Colors.grey..shade900;
    } else if (index == 1) {
      return Colors.orange..shade900;
    } else if (index == 2) {
      return Colors.red.shade400;
    } else if (index == 3) {
      return Colors.green..shade900;
    } else if (index == 4) {
      return Colors.deepPurple;
    } else if (index == 5) {
      return Colors.purpleAccent.shade100;
    } else if (index == 6) {
      return Colors.yellow.shade900;
    } else {
      return Colors.white70;
    }
  }
}

DateTime selectedDate = DateTime.now();

String getNames(List<Instructor>? surfaceSupport, [bool useNextLine = false]) {
  if (surfaceSupport == null || surfaceSupport.isEmpty) {
    return '-';
  }
  String names = '';
  for (var ins in surfaceSupport) {
    if (useNextLine) {
      names += '${ins.name.capitalize}, \n';
    } else {
      names += '${ins.name.capitalize}, ';
    }
  }
  if (useNextLine) {
    return names.substring(0, names.length - 3);
  }
  return names.substring(0, names.length - 2);
}

int getTotalAirCount(List<Booking> bookings, Boat boat, [bool isNitrox = false]) {
  int total = 0;
  int diveBuddyAir = 0;
  int diveBuddyNitrox = 0;

  for (var booking in bookings) {
    BoatInfo? boatInfo = booking.getBoatInfo(selectedDate);
    if (boatInfo?.id == boat.id) {
      if (isNitrox) {
        total += boatInfo?.nitrox ?? 0;
      } else {
        total += boatInfo?.air ?? 0;
      }

      for (Instructor instructor in (booking.boatDetails?.diveBuddies ?? [])) {
        diveBuddyAir += instructor.air ?? 0;
        diveBuddyNitrox += instructor.nitrox ?? 0;
      }
    }
  }

  int internPhotoAir = 0;
  int internPhotoNitrox = 0;

  for (Instructor intern in (boat.internPhotoVideo ?? [])) {
    internPhotoAir += intern.air ?? 0;
    internPhotoNitrox += intern.nitrox ?? 0;
  }

  int dsdStaffAir = 0;
  int dsdStaffNitrox = 0;

  for (Instructor instructor in (boat.dsdInstructors ?? [])) {
    dsdStaffAir += instructor.air ?? 0;
    dsdStaffNitrox += instructor.nitrox ?? 0;
  }

  int photoAir = 0;
  int photoNitrox = 0;

  for (Instructor instructor in (boat.photographer ?? [])) {
    photoAir += instructor.air ?? 0;
    photoNitrox += instructor.nitrox ?? 0;
  }

  if (isNitrox) {
    return total +
        getTotalInstructorsAirCount(bookings, boat, isNitrox) +
        diveBuddyNitrox +
        dsdStaffNitrox +
        photoNitrox +
        internPhotoNitrox;
  }
  return total +
      getTotalInstructorsAirCount(bookings, boat, isNitrox) +
      diveBuddyAir +
      internPhotoAir +
      photoAir +
      dsdStaffAir +
      getTotalDSDPAXCount(bookings, boat);
}

int getTotalInstructorsAirCount(List<Booking> bookings, Boat boat, [bool isNitrox = false]) {
  int total = 0;
  for (var booking in bookings) {
    BoatInfo? boatInfo = booking.getBoatInfo(selectedDate);

    if (boatInfo?.id == boat.id) {
      if (isNitrox) {
        total += booking.getInstructorTanks(selectedDate)?.nitrox ?? 0;
      } else {
        total += booking.getInstructorTanks(selectedDate)?.air ?? 0;
      }
    }
  }
  return total;
}

int getTotalPAXCount(
  List<Booking> bookings,
  Boat boat,
) {
  int total = 0;
  for (var booking in bookings) {
    BoatInfo? boatInfo = booking.getBoatInfo(selectedDate);
    if (boatInfo?.id == boat.id) {
      total += booking.noOfPersons ?? 0;
    }
  }
  return total +
      getTotalInstructorCount(bookings, boat) +
      getTotalDiveBuddyCount(bookings, boat) +
      (boat.dsdInstructors?.length ?? 0) +
      (boat.photographer?.length ?? 0) +
      (boat.internPhotoVideo?.length ?? 0);
}

int getTotalDSDPAXCount(
  List<Booking> bookings,
  Boat boat,
) {
  int total = 0;
  for (var booking in bookings) {
    BoatInfo? boatInfo = booking.getBoatInfo(selectedDate);
    if (boatInfo?.id == boat.id) {
      if (booking.activity![0]!.id == '11') {
        total += booking.noOfPersons ?? 0;
      }
    }
  }
  return total;
}

int getTotalInstructorCount(
  List<Booking> bookings,
  Boat boat,
) {
  List<String> instructorIDs = [];
  for (var booking in bookings) {
    BoatInfo? boatInfo = booking.getBoatInfo(selectedDate);
    if (boatInfo?.id == boat.id) {
      if (booking.instructor != null) {
        instructorIDs.add(booking.instructor!.id);
      }
    }
  }
  instructorIDs = instructorIDs.toSet().toList();
  return instructorIDs.length;
}

int getTotalDiveBuddyCount(
  List<Booking> bookings,
  Boat boat,
) {
  List<Instructor> diveBuddies = [];
  for (var booking in bookings) {
    BoatInfo? boatInfo = booking.getBoatInfo(selectedDate);
    if (boatInfo?.id == boat.id) {
      diveBuddies.addAll((booking.boatDetails?.diveBuddies ?? []).map((e) => e));
    }
  }
  diveBuddies = diveBuddies.toSet().toList();
  return diveBuddies.length;
}

int getTotalCourseCount(
  List<Booking> bookings,
  Boat boat,
) {
  int total = 0;
  for (var booking in bookings) {
    BoatInfo? boatInfo = booking.getBoatInfo(selectedDate);
    if (boatInfo?.id == boat.id) {
      total += booking.noOfPersons ?? 0;
    }
  }
  return total;
}
