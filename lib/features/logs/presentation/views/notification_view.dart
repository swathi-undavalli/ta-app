import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:temple_ui_tools/utils/utils.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/back_navigation_icon.dart';
import '../../../bookings/models/booking_model.dart';

class NotificationView extends StatefulWidget {
  final Booking booking;

  const NotificationView({Key? key, required this.booking}) : super(key: key);

  static Route route(Booking booking) => MaterialPageRoute(
        builder: (context) => NotificationView(booking: booking),
      );

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  final DetailsLogic logic = DetailsLogic();

  @override
  void initState() {
    super.initState();
    checkFireBase();
  }

  checkFireBase() async {
    logic.controller.bookingModel = widget.booking;
    logic.controller.update();
    log(logic.controller.bookingModel.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background.lightBlue,
      appBar: AppBar(
        toolbarHeight: 70,
        centerTitle: true,
        // title: buildTitle(),
        leading: const BackNavigationIcon(),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: GetBuilder<DetailsController>(
          builder: (controller) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 0,
                  left: 30,
                  right: 30,
                  bottom: 30,
                ),
                child: SizedBox(
                  width: Screen.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Hurrah !!',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                          color: AppColors.text.skyBlue,
                        ),
                      ),
                      const SizedBox(height: 30),
                      buildHeading(
                        title: 'New Booking Created by',
                        text: controller.bookingModel.employeeName,
                      ),
                      const SizedBox(height: 50),
                      buildBookingDetails(
                        title: 'Booking ID',
                        text: controller.bookingModel.id,
                      ),
                      buildBookingDetails(
                        title: 'Name',
                        text: controller.bookingModel.pax![0]['first-name'] +
                            ' ' +
                            controller.bookingModel.pax![0]['last-name'],
                      ),
                      buildBookingDetails(
                        title: 'Pax',
                        text: controller.bookingModel.noOfPersons.toString(),
                      ),
                      buildBookingDetails(
                        title: 'Email ID',
                        text: controller.bookingModel.pax![0]['email'],
                      ),
                      buildBookingDetails(
                        title: 'Total Amount',
                        text: '${controller.bookingModel.totalCost.toStringAsFixed(0)} /-',
                      ),
                      buildBookingDetails(
                        title: 'Deposit',
                        text: '${controller.bookingModel.paid!.toStringAsFixed(0)} /-',
                      ),
                      buildBookingDetails(
                        title: 'Balance',
                        text:
                            '${(controller.bookingModel.totalCost - controller.bookingModel.paid!).toStringAsFixed(0)} /-',
                      ),
                      buildBookingDetails(
                        title: 'Receipt No',
                        text: controller.bookingModel.receiptNo ?? '-',
                      ),
                      buildBookingDetails(
                        title: 'Payment Mode',
                        text: controller.bookingModel.paymentMode ?? '-',
                      ),
                      buildBookingDetails(
                        title: 'Transaction ID',
                        text: controller.bookingModel.paymentTransactionId ?? '-',
                      ),
                      buildBookingDetails(
                        title: 'Activity',
                        text: controller.bookingModel.activity![0]!.name,
                      ),
                      buildDates(
                        title: 'Dive Dates',
                        dates: controller.bookingModel.diveDate!,
                      ),
                      buildDates(
                        title: 'Theory Dates',
                        dates: controller.bookingModel.theoryDate!,
                      ),
                      buildDates(
                        title: 'Pool Dates',
                        dates: controller.bookingModel.poolDate!,
                      ),
                      buildBookingDetails(
                        title: 'Remarks',
                        text: (controller.bookingModel.remarks != '') ? controller.bookingModel.remarks : '-',
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildBookingDetails({required String title, String? text}) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontFamily: AppFonts.nunito,
                color: AppColors.text.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(
            width: 150,
            child: Text(
              '$text',
              style: TextStyle(
                fontSize: 12,
                fontFamily: AppFonts.nunito,
                color: AppColors.text.black,
                fontWeight: FontWeight.w500,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHeading({String? title, String? text}) {
    return SizedBox(
      width: Screen.width,
      child: FittedBox(
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: title,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: AppFonts.nunito,
                  color: AppColors.text.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(
                text: '  $text ',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: AppFonts.nunito,
                  color: AppColors.text.skyBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDates({required String title, required List<DateTime?> dates}) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontFamily: AppFonts.nunito,
                color: AppColors.text.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Column(
            children: [
              ...dates.map(
                (e) {
                  String date = DateFormat('dd-MM-yyyy @ hh-mm a').format(e!);
                  return SizedBox(
                    width: 150,
                    child: Text(
                      date,
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: AppFonts.nunito,
                        color: AppColors.text.black,
                        fontWeight: FontWeight.w500,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DetailsLogic {
  DetailsController controller = Get.put(DetailsController());
}

class DetailsController extends GetxController {
  late Booking bookingModel;
}
