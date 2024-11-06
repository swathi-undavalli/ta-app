import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:temple_ui_tools/styling/spacing_widgets.dart';
import 'package:temple_ui_tools/utils/utils.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/models/item_model.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../bookings/models/booking_model.dart';
import '../widgets/filters_bottomsheet.dart';
import 'certification_details_view.dart';

class CertificationLogsView extends StatefulWidget {
  const CertificationLogsView({super.key});

  static Route route() => MaterialPageRoute(
        builder: (context) => const CertificationLogsView(),
      );

  @override
  State<CertificationLogsView> createState() => _CertificationLogsViewState();
}

class _CertificationLogsViewState extends State<CertificationLogsView> {
  FiltersResult result = FiltersResult();

  TextEditingController searchTED = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background.lightBlue,
      appBar: const AppBarWidget(heading: 'Certifications'),
      body: SafeArea(
        child: SizedBox(
          height: Screen.height,
          width: Screen.width,
          child: Column(
            children: [
              Spacing.h10,
              buildFiltersHeader(),
              Spacing.h10,
              buildSearchBar(),
              Spacing.h10,
              StreamBuilder(
                stream: getBookingsQuery(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) {
                    return const SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(
                        color: Colors.black,
                        backgroundColor: Colors.grey,
                        strokeWidth: 3,
                      ),
                    );
                  }

                  if (snapshot.data?.docs.isEmpty ?? true) {
                    return const Center(child: Text('No bookings found.'));
                  }

                  final bookings = snapshot.data?.docs ?? [];
                  List<Booking> visibleBookings = [];

                  for (int i = 0; i < bookings.length; i++) {
                    Booking booking = Booking.fromMap(bookings[i].data());
                    if (result.showOngoingLogs == true && (booking.certificationStatuses?.contains(1) ?? false)) {
                      visibleBookings.add(booking);
                      continue;
                    }
                    if (result.showCompletedLogs == true && (booking.certificationStatuses?.contains(2) ?? false)) {
                      visibleBookings.add(booking);
                      continue;
                    }
                    if ((result.showCompletedLogs ?? false) == false &&
                        (result.showOngoingLogs ?? false) == false &&
                        ((booking.certificationStatuses?.contains(1) ?? false) ||
                            (booking.certificationStatuses?.contains(2) ?? false))) {
                      visibleBookings.add(booking);
                      continue;
                    }
                  }

                  if (visibleBookings.isNotEmpty) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: bookings.length,
                        itemBuilder: (context, index) {
                          Booking booking = Booking.fromMap(bookings[index].data());
                          ItemModel itemModel = ItemModel.fromBooking(booking);

                          return Column(
                            children: booking.pax!.map((p) {
                              int status = p['certificateStatus'] ?? 0;
                              if (result.showOngoingLogs == true && status == 1) {
                                return buildItem(context, itemModel, p);
                              }
                              if (result.showCompletedLogs == true && status == 2) {
                                return buildItem(context, itemModel, p);
                              }
                              if ((result.showCompletedLogs ?? false) == false &&
                                  (result.showOngoingLogs ?? false) == false &&
                                  status != 0) {
                                return buildItem(context, itemModel, p);
                              }
                              return const SizedBox();
                            }).toList(),
                          );
                        },
                      ),
                    );
                  }

                  return const Center(child: Text('No bookings found.'));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSearchBar() {
    return Container(
      width: Screen.width - 30,
      height: 47,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.black),
      ),
      child: Row(
        children: [
          Spacing.w15,
          Icon(Icons.search, color: AppColors.text.darkgrey),
          Spacing.w15,
          SizedBox(
            width: 225,
            child: TextField(
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
                disabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                hintText: 'Search...',
                hintStyle: TextStyle(fontSize: FontSize.textSize, height: 1),
              ),
              controller: searchTED,
              onChanged: (query) {
                // _stream = _filterStream(query);
                setState(() {});
              },
            ),
          ),
          if (searchTED.text != '')
            InkWell(
              onTap: () {
                searchTED.text = '';
                setState(() {});
              },
              highlightColor: Colors.grey,
              splashColor: Colors.red,
              radius: 30,
              child: Icon(Icons.close, color: AppColors.text.darkgrey).paddingAll(5),
            ),
        ],
      ),
    );
  }

  InkWell buildItem(BuildContext context, ItemModel itemModel, Map<String, dynamic> customer) {
    return InkWell(
      onTap: () {
        Navigator.push(context, CertificationDetailsView.route(itemModel, customer));
      },
      child: Column(
        children: [
          Spacing.h20,
          Row(
            children: [
              Spacing.w15,
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.text.skyBlue),
                child: Center(
                  child: Text(
                    itemModel.bookingID ?? '',
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
                      customer['email'],
                      style: TextStyle(
                        color: AppColors.text.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppFonts.nunito,
                      ),
                    ),
                    Spacing.h5,
                    buildText(itemModel),
                  ],
                ),
              ),
              Icon(
                (customer['certificateStatus'] == 1) ? Icons.incomplete_circle_outlined : Icons.check_circle,
                color: (customer['certificateStatus'] == 1) ? Colors.orange.shade400 : Colors.green.shade400,
              ),
              Spacing.w15,
            ],
          ),
          Container(
            height: 1,
            width: Screen.width,
            color: AppColors.text.grey,
          ).paddingSymmetric(horizontal: 15, vertical: 20),
        ],
      ),
    );
  }

  Text buildText(ItemModel itemModel) {
    return Text(
      'Instructor: ${itemModel.bookingModel?.getInstructor(DateFormat("dd-MM-yyyy").parse(itemModel.bookingModel!.bookingDate!.last))?.name}',
      style: TextStyle(
        color: AppColors.text.darkgrey,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        fontFamily: AppFonts.nunito,
      ),
    );
  }

  Stream getBookingsQuery() {
    var query = FirebaseFirestore.instance.collection('bookings');
    var whereQuery;

    if (result.selectedDate != null) {
      whereQuery = query.where(
        'bookingDate',
        arrayContains: DateFormat('dd-MM-yyyy').format(result.selectedDate!),
      );
      if (searchTED.text.isNotEmpty) {
        whereQuery = whereQuery.where('instructorName', isGreaterThanOrEqualTo: searchTED.text.capitalizeFirst);
      }
      return whereQuery.snapshots();
    }

    if ((result.showOngoingLogs == true && result.showCompletedLogs == true) ||
        ((result.showOngoingLogs ?? false) == false && (result.showCompletedLogs ?? false) == false)) {
      whereQuery = query.where('certificationStatuses', arrayContainsAny: [1, 2]);
    } else if (result.showOngoingLogs == true) {
      whereQuery = query.where('certificationStatuses', arrayContains: 1);
    } else if (result.showCompletedLogs == true) {
      whereQuery = query.where('certificationStatuses', arrayContains: 2);
    }
    if (searchTED.text.isNotEmpty) {
      whereQuery = whereQuery.where('instructorName', isGreaterThanOrEqualTo: searchTED.text.capitalizeFirst);
    }
    return whereQuery.snapshots();
  }

  Widget buildFiltersHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Spacing.w20,
        if (result.selectedDate != null || result.showCompletedLogs == true || result.showOngoingLogs == true)
          SizedBox(
            height: 40,
            width: Screen.width - 150,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  if (result.selectedDate != null)
                    buildChip(
                      text: DateFormat('dd-MM-yyyy').format(result.selectedDate!),
                      onTap: () {
                        result.selectedDate = null;
                        setState(() {});
                      },
                    ),
                  if (result.showOngoingLogs == true)
                    buildChip(
                      text: 'show ongoing',
                      onTap: () {
                        result.showOngoingLogs = false;
                        setState(() {});
                      },
                    ),
                  if (result.showCompletedLogs == true)
                    buildChip(
                      text: 'show completed',
                      onTap: () {
                        result.showCompletedLogs = false;
                        setState(() {});
                      },
                    ),
                ],
              ),
            ),
          ),
        const Spacer(),
        const Text(
          'Filters',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        Spacing.w5,
        IconButton(
          onPressed: () async {
            var r = await FiltersBottomSheet.show(
              context,
              result: result,
            );
            if (r != null) {
              result = r;
              setState(() {});
            }
          },
          icon: const Icon(Icons.filter_list_rounded),
        ),
        Spacing.w10,
      ],
    );
  }

  Widget buildChip({required String text, required Function onTap}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Spacing.w5,
          Text(
            text,
            style: const TextStyle(color: Colors.black, fontSize: 14),
          ),
          InkWell(
            onTap: () {
              onTap();
            },
            child: const Icon(
              Icons.clear,
              size: 14,
            ).paddingAll(5),
          ),
        ],
      ).paddingAll(3),
    ).paddingOnly(right: 5);
  }
}
