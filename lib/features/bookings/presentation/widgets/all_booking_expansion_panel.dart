import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/models/item_model.dart';
import '../../../../core/widgets/access_levels.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../activities/model/colors_data.dart';
import '../../../all_bookings/presentation/views/all_bookings_view.dart';
import '../../../logs/models/log_model.dart';
import '../../../logs/presentation/views/log_view.dart';
import '../../models/booking_model.dart';
import '../views/add_payments_view.dart';
import '../views/edit_booking_view.dart';

// ignore: must_be_immutable
class AllBookingsExpansionPanel extends StatefulWidget {
  Booking booking;

  AllBookingsExpansionPanel({Key? key, required this.booking}) : super(key: key);

  @override
  State<AllBookingsExpansionPanel> createState() => _AllBookingsExpansionPanelState();
}

class _AllBookingsExpansionPanelState extends State<AllBookingsExpansionPanel> {
  bool isExpanded = false;
  DateTime date = DateTime.now();

  ItemModel? item;

  @override
  void initState() {
    item = ItemModel.fromBooking(widget.booking);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 20),
      child: buildExpansion(itemModel: item!),
    );
  }

  Widget buildExpansion({required ItemModel itemModel, int? i}) {
    getColor() {
      if (itemModel.bookingModel?.cancelBooking == true) {
        return const Color(0xffEE9A9D);
      } else {
        String cc = '';

        if (colorsData!.blue.contains(itemModel.activity)) {
          cc = 'Blue';
        } else if (colorsData!.purple.contains(itemModel.activity)) {
          cc = 'Purple';
        } else if (colorsData!.red.contains(itemModel.activity)) {
          cc = 'Red';
        } else if (colorsData!.green.contains(itemModel.activity)) {
          cc = 'Green';
        } else if (colorsData!.white.contains(itemModel.activity)) {
          cc = 'White';
        }

        if (cc == 'Blue') {
          return const Color(0xffA9EBF8).withOpacity(0.3);
        } else if (cc == 'Purple') {
          return const Color(0xffDDB3FF);
        } else if (cc == 'Red') {
          return const Color(0xffF8FF96);
        } else if (cc == 'Green') {
          return const Color(0xff96F1BD);
        } else if (cc == 'White') {
          return const Color(0xffE0E0E0);
        }
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInCubic,
        alignment: Alignment.topCenter,
        // height: controller.isExpanded[i] ? 400 : 50,
        constraints: BoxConstraints(
          minHeight: isExpanded ? 400 : 50,
        ),
        // height: controller.isExpanded[i] ? 470 : 50,
        width: 350,
        decoration: BoxDecoration(
          color: getColor(),
          borderRadius: BorderRadius.circular(10),
          // border: Border.all(color: AppColors.text.grey),
        ),
        child: Container(
          constraints: BoxConstraints(
            minHeight: isExpanded ? 400 : 50,
          ),
          decoration: BoxDecoration(
            color: getColor(),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 7,
                      width: 7,
                      decoration: BoxDecoration(
                        color: getBalance(
                                  item!.bookingModel!.payments!,
                                  double.parse(item!.paid).roundToDouble(),
                                  double.parse(item!.cost).roundToDouble(),
                                ) ==
                                '0'
                            ? Colors.green
                            : Colors.red,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              itemModel.name!.trim().toLowerCase().capitalizeFirst!,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppColors.text.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            ' x ${itemModel.bookingModel!.noOfPersons}',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.text.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Spacer(),
                    IconButton(
                      splashRadius: 20,
                      icon: Icon(
                        Icons.call_rounded,
                        color: AppColors.background.black,
                      ),
                      iconSize: 15,
                      onPressed: () {
                        makingPhoneCall(itemModel.phone);
                      },
                    ),
                    EmployeeAccess(
                      access: AccessRights.editBookings,
                      child: IconButton(
                        splashRadius: 20,
                        icon: Icon(
                          Icons.delete,
                          color: AppColors.background.black,
                        ),
                        iconSize: 15,
                        onPressed: () {
                          Get.defaultDialog(
                            contentPadding: const EdgeInsets.only(
                              left: 30,
                              right: 30,
                              top: 20,
                              bottom: 30,
                            ),
                            title: '\nAre You Sure ? ',
                            middleText: 'Booking will Be Deleted Permanently.',
                            backgroundColor: Colors.white,
                            titleStyle: TextStyle(
                              color: AppColors.text.black,
                              fontFamily: AppFonts.nunito,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            middleTextStyle: TextStyle(
                              color: AppColors.text.black,
                              fontFamily: AppFonts.nunito,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                            confirm: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppButton.miniText(
                                  text: 'Cancel',
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                AppButton.miniFlat(
                                  text: 'OK',
                                  onTap: () {
                                    FirebaseFirestore.instance
                                        .collection('bookings')
                                        .doc(itemModel.bookingModel!.id)
                                        .delete();
                                    LogModel logModel = LogModel(
                                      type: LogType.bookingDeleted,
                                      bookingId: itemModel.bookingModel!.id,
                                    );
                                    FirebaseFirestore.instance.collection('logs').doc().set(logModel.toMap());

                                    Navigator.pop(context);
                                    const AllBookingsView();
                                    setState(() {});
                                  },
                                ),
                              ],
                            ),
                            barrierDismissible: false,
                            radius: 10,
                          );
                        },
                      ),
                    ),
                    EmployeeAccess(
                      access: AccessRights.editBookings,
                      child: IconButton(
                        splashRadius: 20,
                        icon: Icon(
                          Icons.edit,
                          color: AppColors.background.black,
                        ),
                        iconSize: 15,
                        onPressed: () {
                          Navigator.push(context, EditBookingView.route(itemModel.bookingModel!));
                        },
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
                                buildKeyValuePairs(
                                  'Booking Id',
                                  item!.bookingID!,
                                ),
                                buildKeyValuePairs('Activity', item!.activity),
                                buildKeyValuePairs(
                                  'Total Cost',
                                  double.parse(item!.cost).roundToDouble().toString(),
                                ),
                                buildKeyValuePairs(
                                  'Deposit',
                                  double.parse(item!.paid).roundToDouble().toString(),
                                ),
                                buildKeyValuePairs(
                                  'Balance',
                                  getBalance(
                                    item!.bookingModel!.payments!,
                                    double.parse(item!.paid).roundToDouble(),
                                    double.parse(item!.cost).roundToDouble(),
                                  ),
                                ),
                                buildKeyValuePairs(
                                  'Pax',
                                  item!.bookingModel!.noOfPersons.toString(),
                                ),
                                ((item != null) && (item!.receiptNo != null))
                                    ? buildKeyValuePairs(
                                        'Invoice no',
                                        item!.receiptNo!,
                                      )
                                    : buildKeyValuePairs('Invoice no', '-'),
                                (item!.remarks == '')
                                    ? buildKeyValuePairs('Remarks', '-')
                                    : buildKeyValuePairs(
                                        'Remarks',
                                        item!.remarks.toString(),
                                      ),
                                buildKeyValuePairs('Phone', item!.phone!),
                                buildKeyValuePairs('Email', item!.email!),
                                buildKeyValuePairs('Time', item!.time),
                                buildKeyValuePairs('Date', item!.date),
                                buildKeyValuePairs('Session', item!.session),
                                buildKeyValuePairs(
                                  'Registered',
                                  '${item!.bookingModel!.registeredUsers.length} / ${item!.bookingModel!.noOfPersons}',
                                  isDanger: ((item!.bookingModel!.registeredUsers.length) !=
                                      (item!.bookingModel!.noOfPersons)),
                                ),
                                const SizedBox(height: 30),
                                buildPaymentStatus(
                                  totalAmount: item!.bookingModel!.totalCost,
                                  payments: [
                                    PaymentModel(
                                      amount: double.parse(item!.paid).roundToDouble(),
                                      collectedBy: item!.employeeName,
                                      reciptNo: item!.receiptNo,
                                      referenceNo: item!.bookingModel!.paymentTransactionId,
                                      remarks: '',
                                      paymentMode: item!.bookingModel!.paymentMode,
                                      time: item!.bookingModel!.createdAt,
                                    ),
                                    ...item!.bookingModel!.payments!,
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const Spacer(),
                                    Container(
                                      child: AppButton.miniFlat(
                                        text: 'Add Payment',
                                        onTap: () {
                                          Navigator.push(context, AddPaymentsView.route(itemModel.bookingModel!));
                                        },
                                      ).paddingOnly(right: 15),
                                      // alignment: Alignment.centerRight,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    (item!.employeeName != null)
                                        ? Container(
                                            alignment: Alignment.centerRight,
                                            child: RichText(
                                              text: TextSpan(
                                                text: 'Created By : ',
                                                style: TextStyle(
                                                  fontFamily: AppFonts.nunito,
                                                  color: AppColors.text.darkgrey,
                                                  fontSize: 10,
                                                ),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text: item!.employeeName,
                                                    style: const TextStyle(
                                                      color: Color(0xff484646),
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : const SizedBox(),
                                    // AppButton.miniFlat(
                                  ],
                                ),
                                const SizedBox(height: 20),
                              ],
                            );
                          }
                          return const SizedBox();
                        },
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPaymentStatus({
    required double totalAmount,
    required List<PaymentModel> payments,
  }) {
    double deposits = 0.0;

    for (var payment in payments) {
      deposits += payment.amount!;
    }

    int n = payments.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 1,
                    color: (totalAmount == deposits) ? Colors.green.shade400 : Colors.black,
                  ),
                ),
              ],
            ).paddingOnly(top: 7, left: 16, right: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: n,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List<Widget>.generate(n, (i) {
                      return buildCircle(color: Colors.black);
                    }),
                  ),
                ),
                (totalAmount == deposits)
                    ? const SizedBox()
                    : Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            buildCircle(color: Colors.red.shade300),
                          ],
                        ),
                      ),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 39,
                        child: Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            color: AppColors.text.skyBlue,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.circle,
                            size: 10,
                            color: AppColors.text.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: n,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List<Widget>.generate(n, (i) {
                      return buildNumber(
                        text: payments[i].amount!.round().toString(),
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      );
                    }),
                  ),
                ),
                (totalAmount == deposits)
                    ? const SizedBox()
                    : Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            buildNumber(
                              text: (totalAmount - deposits).round().toString(),
                              // text: "16000",
                              color: Colors.red.shade300,
                              fontWeight: FontWeight.normal,
                            ),
                          ],
                        ),
                      ),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      buildNumber(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        text: totalAmount.round().toString(),
                      ),
                    ],
                  ),
                ),
              ],
            ).paddingOnly(top: 20),
          ],
        ).paddingOnly(right: 20),
        const SizedBox(height: 20),
        ...List.generate(
          payments.length,
          (index) {
            return buildTransactions(payment: payments[index]);
          },
        ),
      ],
    );
  }

  String getBalance(List<PaymentModel> payments, double deposit, double total) {
    double t = deposit;
    for (var payment in payments) {
      t += payment.amount!;
    }
    return (total - t).toInt().toString();
  }

  Widget buildTransactions({required PaymentModel payment}) {
    DateTime now = DateTime.now();
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 8,
          width: 8,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(10),
          ),
        ).paddingOnly(top: 2),
        const SizedBox(width: 10),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Paid ${payment.amount!.round()} by ${payment.paymentMode} collected by ${payment.collectedBy}',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                wordSpacing: 2,
              ),
            ),
            const SizedBox(height: 2),
            if (payment.time != null &&
                now.day == payment.time!.day &&
                now.month == payment.time!.month &&
                now.year == payment.time!.year)
              Text(
                "Today - ${DateFormat("hh:mm a").format(payment.time!)}",
                style: TextStyle(fontSize: 10, color: AppColors.text.darkgrey),
              )
            else if (payment.time != null)
              Text(
                DateFormat('EEE dd MMM yy - hh:mm a').format(payment.time!),
                style: TextStyle(fontSize: 10, color: AppColors.text.darkgrey),
              )
            else
              Text(
                'Initial Deposit',
                style: TextStyle(fontSize: 10, color: AppColors.text.darkgrey),
              ),
          ],
        ),
      ],
    ).paddingOnly(bottom: 10);
  }

  makingPhoneCall(String? phoneNumber) async {
    String url = 'tel:$phoneNumber';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget buildKeyValuePairs(String key, String value, {bool isDanger = false}) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            key,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 13,
              letterSpacing: 0.3,
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
          ),
        ),
        Expanded(
          child: SizedBox(
            height: 16,
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isDanger ? Colors.red : Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
                height: 1.3,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCircle({Color? color}) {
    return SizedBox(
      width: 39,
      child: Icon(
        Icons.circle,
        size: 10,
        color: color,
      ),
    );
  }

  Widget buildNumber({
    FontWeight? fontWeight,
    Color? color,
    required String text,
  }) {
    return SizedBox(
      width: 39,
      child: Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 10, fontWeight: fontWeight, color: color),
        ),
      ),
    );
  }
}
