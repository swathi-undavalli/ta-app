import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/models/item_model.dart';
import '../../../../core/util/spacing_widgets.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../bookings/models/booking_model.dart';
import '../widgets/filters_bottomsheet.dart';
import 'certification_details_view.dart';

class CertificationLogsView extends StatefulWidget {
  const CertificationLogsView({super.key});
  static const String id = 'CertificationProgressView';

  @override
  State<CertificationLogsView> createState() => _CertificationLogsViewState();
}

class _CertificationLogsViewState extends State<CertificationLogsView> {
  FiltersResult result = FiltersResult();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background.lightBlue,
      appBar: const AppBarWidget(heading: 'Certification Logs'),
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Spacing.h10,
              buildFiltersHeader(),
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

                  final sortedBookings = snapshot.data?.docs ?? [];

                  return Expanded(
                    child: ListView.builder(
                      itemCount: sortedBookings.length,
                      itemBuilder: (context, index) {
                        var booking = sortedBookings[index];
                        Booking newBooking = Booking.fromMap(booking.data());
                        ItemModel itemModel = ItemModel.fromBooking(newBooking);
                        return InkWell(
                          onTap: () {
                            Get.toNamed(CertificationDetailsView.id, arguments: itemModel);
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
                                          itemModel.email ?? '',
                                          style: TextStyle(
                                            color: AppColors.text.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: AppFonts.nunito,
                                          ),
                                        ),
                                        Spacing.h5,
                                        Text(
                                          'Instructor: ${itemModel.bookingModel?.boatDetails!.instructors?[0].name}',
                                          style: TextStyle(
                                            color: AppColors.text.darkgrey,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: AppFonts.nunito,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    (newBooking.certificateStatus == 1)
                                        ? Icons.incomplete_circle_outlined
                                        : Icons.check_circle,
                                    color: (newBooking.certificateStatus == 1)
                                        ? Colors.orange.shade400
                                        : Colors.green.shade400,
                                  ),
                                  Spacing.w15,
                                ],
                              ),
                              Container(
                                height: 1,
                                width: Get.width,
                                color: AppColors.text.grey,
                              ).paddingSymmetric(horizontal: 15, vertical: 20),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getBookingsQuery() {
    var query = FirebaseFirestore.instance.collection('bookings');
    var whereQuery;

    if ((result.showOngoingLogs == true && result.showCompletedLogs == true) ||
        ((result.showOngoingLogs ?? false) == false && (result.showCompletedLogs ?? false) == false)) {
      whereQuery = query
          .where('certificateStatus', isGreaterThanOrEqualTo: 1)
          .where('certificateStatus', isLessThanOrEqualTo: 2);
    } else if (result.showOngoingLogs == true) {
      whereQuery =
          query.where('certificateStatus', isGreaterThanOrEqualTo: 1).where('certificateStatus', isLessThan: 2);
    } else if (result.showCompletedLogs == true) {
      whereQuery =
          query.where('certificateStatus', isGreaterThanOrEqualTo: 2).where('certificateStatus', isLessThan: 3);
    }

    // date
    if (result.selectedDate != null) {
      whereQuery = whereQuery.where(
        'bookingDate',
        arrayContains: DateFormat('dd-MM-yyyy').format(result.selectedDate!),
      );
    }

    whereQuery = whereQuery.orderBy('certificateStatus');

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
            width: MediaQuery.of(context).size.width - 150,
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
            icon: const Icon(Icons.filter_list_rounded)),
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
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
          InkWell(
            onTap: () {
              onTap();
            },
            child: Icon(
              Icons.clear,
              size: 14,
            ).paddingAll(5),
          ),
        ],
      ).paddingAll(3),
    ).paddingOnly(right: 5);
  }
}
