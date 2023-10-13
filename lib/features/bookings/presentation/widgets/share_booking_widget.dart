import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/assets.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/ta_image.dart';
import '../../models/booking_model.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class ShareBookingWidget extends StatelessWidget {
  Booking booking;

  ShareBookingWidget(this.booking, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      width: Get.width,
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              "${booking.pax![0]["first-name"] + " " + booking.pax![0]["last-name"]} 's"
                  .capitalizeFirst!,
              style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontFamily: AppFonts.nunito,),
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: Get.width,
              child: FittedBox(
                child: Text(
                  booking.activity![0]!.name!,
                  style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xff575757),
                      fontFamily: AppFonts.nunito,),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildSectionTitle(title: 'Booking Details'),
                const SizedBox(height: 10),
                buildBookingDetails(title: 'Booking ID', text: booking.id),
                buildBookingDetails(
                    title: 'Name',
                    text: booking.pax![0]['first-name'] +
                        ' ' +
                        booking.pax![0]['last-name'],),
                buildBookingDetails(
                    title: 'Pax', text: booking.noOfPersons.toString(),),
                buildBookingDetails(
                    title: 'Email ID', text: booking.pax![0]['email'],),
                buildBookingDetails(
                    title: 'Activity', text: booking.activity![0]!.name,),
                buildDates(title: 'Dive Dates', dates: booking.diveDate!),
                buildDates(title: 'Theory Dates', dates: booking.theoryDate!),
                buildDates(title: 'Pool Dates', dates: booking.poolDate!),
              ],
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildSectionTitle(title: 'Payment Details'),
                const SizedBox(height: 10),
                buildBookingDetails(
                    title: 'Total Amount',
                    text: '${booking.totalCost.toStringAsFixed(0)} /-',),
                buildBookingDetails(
                    title: 'Deposit',
                    text: '${booking.paid!.toStringAsFixed(0)} /-',),
                buildBookingDetails(
                    title: 'Balance',
                    text:
                        '${(booking.totalCost - booking.paid!).toStringAsFixed(0)} /-',),
                buildBookingDetails(
                    title: 'Receipt No', text: booking.receiptNo ?? '-',),
                buildBookingDetails(
                    title: 'Payment Mode', text: booking.paymentMode ?? '-',),
                buildBookingDetails(
                    title: 'Transaction ID',
                    text: (booking.paymentTransactionId != '')
                        ? booking.paymentTransactionId
                        : '-',),
                buildAllTransactions(),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  width: 130,
                  child: Text(
                    'For any queries,\nContact : ${booking.employeeName}',
                    style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xff595959),
                        fontFamily: AppFonts.nunito,),
                  ),
                ),
                const Spacer(),
                TAImage(AppImages.icons.appLogo, height: 60, width: 60),
              ],
            ),
          ],
        ).paddingSymmetric(vertical: 20, horizontal: 40),
      ),
    );
  }

  ///================UI==================///

  Widget buildSectionTitle({required String title}) {
    return Text(
      title,
      style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: Colors.black,
          fontFamily: AppFonts.nunito,),
    );
  }

  Widget buildAllTransactions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'All Transactions',
          style: TextStyle(
              fontSize: 10,
              fontFamily: AppFonts.nunito,
              color: AppColors.text.black,
              fontWeight: FontWeight.w500,),
        ).paddingOnly(top: 5),
        buildListOfPayments(
          payments: [
            PaymentModel(
              amount: booking.paid!.roundToDouble(),
              collectedBy: booking.employeeName,
              reciptNo: booking.receiptNo,
              referenceNo: booking.paymentTransactionId,
              remarks: '',
              paymentMode: booking.paymentMode,
              time: booking.createdAt,
            ),
            ...booking.payments!,
          ],
        ),
        // ...List.generate(
        //   booking.payments.length,
        //   (index) {
        //     return Container(
        //       width: Get.width,
        //       child: buildTransaction(payment: booking.payments[index]),
        //     );
        //   },
        // )
      ],
    );
  }

  Widget buildListOfPayments({required List<PaymentModel> payments}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...List.generate(
          payments.length,
          (index) {
            return buildTransaction(payment: payments[index]);
          },
        ),
      ],
    );
  }

  Widget buildTransaction({required PaymentModel payment}) {
    DateTime now = DateTime.now();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Payment ${payment.amount!.round()} by ${payment.paymentMode ?? "-"} collected by ${payment.collectedBy}",
          style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              wordSpacing: 2,
              fontFamily: AppFonts.nunito,
              color: Colors.black,),
        ),
        const SizedBox(height: 2),
        if (payment.time != null &&
            now.day == payment.time!.day &&
            now.month == payment.time!.month &&
            now.year == payment.time!.year)
          Text(
            "Today - ${DateFormat("hh:mm a").format(payment.time!)}",
            style: TextStyle(
              fontSize: 10,
              color: AppColors.text.darkgrey,
              fontFamily: AppFonts.nunito,
            ),
          )
        else if (payment.time != null)
          Text(
            DateFormat('EEE dd MMM yy - hh:mm a').format(payment.time!),
            style: TextStyle(
              fontSize: 10,
              color: AppColors.text.darkgrey,
              fontFamily: AppFonts.nunito,
            ),
          )
        else
          Text(
            'Initial Deposit',
            style: TextStyle(
              fontSize: 10,
              color: AppColors.text.darkgrey,
              fontFamily: AppFonts.nunito,
            ),
          ),
      ],
    ).paddingOnly(top: 10);
  }

  Widget buildBookingDetails({required String title, String? text}) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 10,
                  fontFamily: AppFonts.nunito,
                  color: AppColors.text.black,
                  fontWeight: FontWeight.w500,),
            ),
          ),
          SizedBox(
            width: 150,
            child: Text(
              '$text',
              style: const TextStyle(
                fontSize: 10,
                fontFamily: AppFonts.nunito,
                color: Color(0xff575757),
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildDates({required String title, required List<DateTime?> dates}) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 10,
                  fontFamily: AppFonts.nunito,
                  color: AppColors.text.black,
                  fontWeight: FontWeight.w500,),
            ),
          ),
          Column(
            children: [
              ...dates.map(
                (e) {
                  String date = DateFormat('dd-MM-yyyy @ hh:mm a').format(e!);
                  return SizedBox(
                      width: 150,
                      child: Text(
                        date,
                        style: const TextStyle(
                            fontSize: 10,
                            fontFamily: AppFonts.nunito,
                            color: Color(0xff575757),
                            fontWeight: FontWeight.w500,
                            overflow: TextOverflow.ellipsis,),
                      ),);
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
