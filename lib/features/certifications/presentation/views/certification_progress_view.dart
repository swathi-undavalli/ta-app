import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/export.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/models/item_model.dart';
import '../../../../core/util/spacing_widgets.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../bookings/models/booking_model.dart';
import 'certification_details_view.dart';

class CertificationProgressView extends StatefulWidget {
  const CertificationProgressView({super.key});
  static const String id = 'CertificationProgressView';

  @override
  State<CertificationProgressView> createState() => _CertificationProgressViewState();
}

class _CertificationProgressViewState extends State<CertificationProgressView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(heading: 'Certification Logs'),
      body: SafeArea(
        child: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection('bookings').where('certificateStatus', isNotEqualTo: 0).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No bookings found.'));
            }

            final bookings = snapshot.data!.docs.where((doc) => doc['certificateStatus'] != 0).toList()
              ..sort((a, b) {
                int statusA = a['certificateStatus'];
                int statusB = b['certificateStatus'];
                return statusA.compareTo(statusB);
              });

            final status1Bookings = bookings.where((doc) => doc['certificateStatus'] == 1).toList();
            final status2Bookings = bookings.where((doc) => doc['certificateStatus'] == 2).toList();

            final sortedBookings = [...status1Bookings, ...status2Bookings];

            return ListView.builder(
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
                            (newBooking.certificateStatus == 1) ? Icons.incomplete_circle_outlined : Icons.check_circle,
                            color: (newBooking.certificateStatus == 1) ? Colors.orange.shade400 : Colors.green.shade400,
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
            );
          },
        ),
      ),
    );
  }
}
