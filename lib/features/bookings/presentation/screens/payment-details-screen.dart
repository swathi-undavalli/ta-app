import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/widgets/app-button.dart';
import 'package:temple_adventures/core/widgets/back-navigation-icon.dart';
import 'package:temple_adventures/features/bookings/controller/new-booking-controller.dart';
import 'package:temple_adventures/features/bookings/presentation/widgets/app-text-fields.dart';
import 'package:intl/intl.dart';

class PaymentDetailsScreen extends StatelessWidget {
  static const String id = "PaymentDetailsScreen";
  final NewBookingLogic logic = NewBookingLogic();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar() as PreferredSizeWidget?,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Container(
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
                  SizedBox(height: 40),
                  buildProceed(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///==================UI==================///

  Widget buildAppBar() {
    return AppBar(
      toolbarHeight: 70,
      centerTitle: true,
      title: buildTitle(),
      leading: BackNavigationIcon(),
      elevation: 0,
      backgroundColor: AppColors.background.white,
    );
  }

  Widget buildPaymentDate(BuildContext context) {
    return GetBuilder<NewBookingController>(builder: (controller) {
      // String paymentDate =
      //     DateFormat("d MMM yyyy").format(controller.paymentDate);
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Text(
              "Payment Date",
              style: TextStyle(fontSize: FontSize.textSize),
            ),
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
                  borderRadius: BorderRadius.circular(5)),
              child: Center(
                  child: Text(
                      DateFormat("d MMM yyyy").format(controller.paymentDate))),
            ),
          ),
        ],
      );
    });
  }

  Widget buildPaymentReferenceTextField() {
    return GetBuilder<NewBookingController>(builder: (controller) {
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
    });
  }

  Widget buildReceiptNo() {
    return GetBuilder<NewBookingController>(builder: (controller) {
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
    });
  }

  Widget buildPaymentMode() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Text(
            "Select PaymentMode",
            style: TextStyle(
                fontSize: FontSize.textSize, color: AppColors.text.black),
          ),
        ),
        Container(
          height: 30,
          width: 120,
          decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
              ),
              borderRadius: BorderRadius.circular(5)),
          child: GetBuilder<NewBookingController>(builder: (controller) {
            return Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: DropdownButton(
                underline: SizedBox(),
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
                    child: new Text(newMode),
                    value: newMode,
                  );
                }).toList(),
              ),
            );
          }),
        )
      ],
    );
  }

  Widget buildPayableAmount() {
    return GetBuilder<NewBookingController>(builder: (controller) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Text(
              "Payable Amount",
              style: TextStyle(
                  fontSize: FontSize.textSize, color: AppColors.text.black),
            ),
          ),
          Container(
            height: 30,
            width: 120,
            child: Text(
              controller.payingNowTED.text + " /-",
              style:
                  TextStyle(fontSize: FontSize.textSize, color: Colors.black),
            ),
          )
        ],
      );
    });
  }

  Widget buildTitle() {
    return Text(
      'Payment Details',
      style: TextStyle(
        color: AppColors.text.black,
        fontSize: 20,
        fontFamily: AppFonts.nunito,
        fontWeight: FontWeight.normal,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget buildProceed() {
    return Center(
      child: AppButton.flat(
        text: "Proceed",
        textColor: AppColors.text.white,
        color: AppColors.background.black,
        onTap: () {
          logic.onPaymentDetailsFilled();
        },
      ),
    );
  }
}
