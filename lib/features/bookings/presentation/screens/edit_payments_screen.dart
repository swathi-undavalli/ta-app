import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/app_button.dart';
import '../../controller/edit_payments_controller.dart';
import '../../models/booking_model.dart';
import '../widgets/app_text_fields.dart';
import '../../../employees/model/employee.dart';

// ignore: must_be_immutable
class EditPaymentsScreen extends StatelessWidget {
  static const String id = 'EditPaymentsScreen';
  EditPaymentsLogic logic = EditPaymentsLogic();

  EditPaymentsScreen({Key? key}) : super(key: key);

  // BookingModel bookingArg = Get.arguments;

  @override
  Widget build(BuildContext context) {
    // logic.controller.bookingModel = bookingArg;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        centerTitle: true,
        title: buildTitle(),
        leading: TextButton(
          onPressed: () {
            // logic.controller.reset();
            Get.back();
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: AppColors.text.black,
            size: 17,
          ),
        ),
        elevation: 0,
        backgroundColor: AppColors.background.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: GetBuilder<EditPaymentsController>(builder: (controller) {
            return Column(
              children: [
                const SizedBox(height: 20),
                ...List.generate(
                  controller.bookingModel!.payments!.length,
                  (index) {
                    return buildTransactions(
                        index: index,
                        payment: controller.bookingModel!.payments![index],);
                  },
                ),
              ],
            );
          },),
        ),
      ),
    );
  }

  Widget buildTransactions({required PaymentModel payment, int? index}) {
    DateTime now = DateTime.now();
    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 8,
              width: 8,
              decoration: BoxDecoration(
                  color: Colors.green, borderRadius: BorderRadius.circular(10),),
            ).paddingOnly(top: 2, left: 5),
            const SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: Get.width - 100,
                  child: Text(
                    'Payment ${payment.amount!.round()} by ${payment.paymentMode} collected by ${payment.collectedBy}',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        wordSpacing: 2,),
                  ),
                ),
                const SizedBox(height: 2),
                if (payment.time != null &&
                    now.day == payment.time!.day &&
                    now.month == payment.time!.month &&
                    now.year == payment.time!.year)
                  Text(
                    "Today - ${DateFormat("hh:mm a").format(payment.time!)}",
                    style:
                        TextStyle(fontSize: 10, color: AppColors.text.darkgrey),
                  )
                else if (payment.time != null)
                  Text(
                    DateFormat('EEE dd MMM yy - hh:mm a').format(payment.time!),
                    style:
                        TextStyle(fontSize: 10, color: AppColors.text.darkgrey),
                  )
                else
                  Text(
                    'Initial Deposit',
                    style:
                        TextStyle(fontSize: 10, color: AppColors.text.darkgrey),
                  ),
              ],
            ),
          ],
        ).paddingOnly(bottom: 10),
        Positioned(
          right: 0,
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  logic.controller.paymentTED.text =
                      payment.amount!.round().toString();
                  logic.controller.paymentModeTED.text =
                      payment.paymentMode.toString();
                  logic.controller.receiptNoTED.text =
                      payment.reciptNo.toString();
                  logic.controller.referenceNoTED.text =
                      payment.referenceNo.toString();
                  Get.defaultDialog(
                    contentPadding: const EdgeInsets.only(
                        left: 30, right: 30, top: 10, bottom: 10,),
                    title: '\nEdit Payment',
                    backgroundColor: Colors.white,
                    titleStyle: TextStyle(
                        color: AppColors.text.black,
                        fontFamily: AppFonts.nunito,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,),
                    middleTextStyle: TextStyle(
                        color: AppColors.text.black,
                        fontFamily: AppFonts.nunito,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,),
                    content: Column(
                      children: [
                        AppTextField(
                          width: 320,
                          hintText: 'Deposit',
                          keyboardType: TextInputType.number,
                          controller: logic.controller.paymentTED,
                          required: false,
                          errorValidator: () {
                            return null;
                          },
                          validator: (firstName) {
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        buildPaymentMode(),
                        AppTextField(
                          width: 320,
                          hintText: 'Receipt No',
                          controller: logic.controller.receiptNoTED,
                          required: false,
                          errorValidator: () {
                            return null;
                          },
                          validator: (firstName) {
                            return null;
                          },
                        ),
                        AppTextField(
                          width: 320,
                          hintText: 'ReferenceNo',
                          controller: logic.controller.referenceNoTED,
                          required: false,
                          errorValidator: () {
                            return null;
                          },
                          validator: (firstName) {
                            return null;
                          },
                        ),
                      ],
                    ),
                    confirm: GetBuilder<EditPaymentsController>(
                        builder: (controller) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppButton.miniText(
                            text: 'Cancel',
                            onTap: () {
                              Get.back();
                            },
                          ),
                          AppButton.miniFlat(
                            text: 'OK',
                            onTap: () async {
                              logic.controller.bookingModel!.payments![index!]
                                      .amount =
                                  double.parse(
                                      logic.controller.paymentTED.text,);
                              logic.controller.bookingModel!.payments![index]
                                      .paymentMode =
                                  logic.controller.paymentModeTED.text;
                              logic.controller.bookingModel!.payments![index]
                                      .reciptNo =
                                  logic.controller.receiptNoTED.text;
                              logic.controller.bookingModel!.payments![index]
                                      .referenceNo =
                                  logic.controller.referenceNoTED.text;
                              logic.controller.bookingModel!.payments![index]
                                  .collectedBy = currentEmployee!.name;
                              logic.controller.bookingModel!.payments![index]
                                  .time = DateTime.now();
                              await FirebaseFirestore.instance
                                  .collection('bookings')
                                  .doc(logic.controller.bookingModel!.id)
                                  .set(logic.controller.bookingModel!.toMap());
                              Get.back();
                              controller.update();
                              Get.back();
                            },
                          ),
                        ],
                      );
                    },),
                    barrierDismissible: false,
                    radius: 10,
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.0),
                  child: Icon(Icons.edit, size: 12),
                ),
              ),
              const SizedBox(width: 13),
              GestureDetector(
                onTap: () async {
                  log(logic.controller.bookingModel!.toMap().toString());
                  logic.controller.bookingModel!.payments!.removeAt(index!);
                  log(logic.controller.bookingModel!.toMap().toString());
                  logic.controller.update();
                  await FirebaseFirestore.instance
                      .collection('bookings')
                      .doc(logic.controller.bookingModel!.id)
                      .set(logic.controller.bookingModel!.toMap());
                  logic.controller.update();
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.0),
                  child: Icon(Icons.delete, size: 12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildPaymentMode() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Select PaymentMode',
          style: TextStyle(
              fontSize: FontSize.small, color: AppColors.text.black,),
        ),
        Container(
          height: 20,
          width: 80,
          decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
              ),
              borderRadius: BorderRadius.circular(5),),
          child: GetBuilder<EditPaymentsController>(builder: (controller) {
            return Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: DropdownButton(
                underline: const SizedBox(),
                isExpanded: true,
                value: controller.paymentModeTED.text.isNotEmpty
                    ? controller.paymentModeTED.text
                    : null,
                onChanged: (dynamic mode) {
                  controller.paymentModeTED.text = mode;
                  controller.update();
                },
                items: controller.paymentOptions.map((newMode) {
                  return DropdownMenuItem(
                    value: newMode,
                    child: Text(
                      newMode,
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                }).toList(),
              ),
            );
          },),
        )
      ],
    );
  }

  Widget buildTitle() {
    return Text(
      'Edit Payments',
      style: TextStyle(
        color: AppColors.text.black,
        fontSize: 20,
        fontFamily: AppFonts.nunito,
        fontWeight: FontWeight.normal,
        letterSpacing: 1.2,
      ),
    );
  }
}
