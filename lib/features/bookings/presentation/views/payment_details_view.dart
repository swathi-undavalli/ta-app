import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../controller/new_booking_controller.dart';
import '../widgets/app_text_fields.dart';

class PaymentDetailsView extends StatelessWidget {
  final NewBookingLogic logic = NewBookingLogic();

  PaymentDetailsView({super.key});

  static Route route() => MaterialPageRoute(
        builder: (context) => PaymentDetailsView(),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background.lightBlue,
      appBar: const AppBarWidget(heading: 'Payment Details'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: SizedBox(
              height: 500,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildPayableAmount(),
                  buildPaymentMode(),
                  buildPaymentDate(context),
                  buildPaymentReferenceTextField(),
                  buildReceiptNo(),
                  const SizedBox(height: 40),
                  buildProceed(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///==================UI==================///

  Widget buildPaymentDate(BuildContext context) {
    return GetBuilder<NewBookingController>(
      builder: (controller) {
        // String paymentDate =
        //     DateFormat("d MMM yyyy").format(controller.paymentDate);
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Payment Date',
              style: TextStyle(fontSize: FontSize.textSize),
            ),
            GestureDetector(
              onTap: () {
                logic.paymentDatePicker(context);
              },
              child: Container(
                height: 30,
                width: 120,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Text(
                    DateFormat('d MMM yyyy').format(controller.paymentDate),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildPaymentReferenceTextField() {
    return GetBuilder<NewBookingController>(
      builder: (controller) {
        return AppTextField(
          width: 320,
          hintText: 'Payment Reference',
          controller: controller.paymentReferenceTED,
          focusNode: logic.controller.paymentReferenceNode,
          nextFocusNode: logic.controller.receiptNoNode,
          required: false,
          errorValidator: () {
            return null;
          },
          validator: (firstName) {
            return null;
          },
        );
      },
    );
  }

  Widget buildReceiptNo() {
    return GetBuilder<NewBookingController>(
      builder: (controller) {
        return AppTextField(
          width: 320,
          hintText: 'Receipt No / Invoice No',
          controller: controller.receiptNoTED,
          focusNode: controller.receiptNoNode,
          required: false,
          errorValidator: () {
            return null;
          },
          validator: (firstName) {
            return null;
          },
        );
      },
    );
  }

  Widget buildPaymentMode() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Select PaymentMode',
          style: TextStyle(
            fontSize: FontSize.textSize,
            color: AppColors.text.black,
          ),
        ),
        Container(
          height: 30,
          width: 120,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          child: GetBuilder<NewBookingController>(
            builder: (controller) {
              return Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: DropdownButton(
                  underline: const SizedBox(),
                  isExpanded: true,
                  value: controller.paymentModeTED.text.isNotEmpty ? controller.paymentModeTED.text : null,
                  onChanged: (dynamic mode) {
                    if (mode == 'UPI') {
                      return;
                    }
                    controller.paymentModeTED.text = mode;
                    controller.update();
                  },
                  items: controller.paymentOptions.map((newMode) {
                    return DropdownMenuItem(
                      value: newMode,
                      child: Text(
                        newMode,
                        style: TextStyle(color: (newMode == 'UPI') ? Colors.black12 : Colors.black),
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildPayableAmount() {
    return GetBuilder<NewBookingController>(
      builder: (controller) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Payable Amount',
              style: TextStyle(
                fontSize: FontSize.textSize,
                color: AppColors.text.black,
              ),
            ),
            SizedBox(
              height: 30,
              width: 120,
              child: Text(
                '${controller.payingNowTED.text} /-',
                style: const TextStyle(fontSize: FontSize.textSize, color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildProceed(BuildContext context) {
    return Center(
      child: AppButton.flat(
        text: 'Proceed',
        textColor: AppColors.text.white,
        color: AppColors.background.black,
        onTap: () {
          logic.onPaymentDetailsFilled(context);
        },
      ),
    );
  }
}
