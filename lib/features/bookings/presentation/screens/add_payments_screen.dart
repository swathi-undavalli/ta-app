import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/app_button.dart';
import '../../controller/add_payments_controller.dart';
import '../../models/booking_model.dart';
import '../widgets/app_text_fields.dart';

// ignore: must_be_immutable
class AddPaymentsScreen extends StatelessWidget {
  static const String id = 'AddPaymentsScreen';
  AddPaymentsLogic logic = AddPaymentsLogic();

  Booking? bookingArg = Get.arguments;

  AddPaymentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logic.controller.bookingModel = bookingArg;
    return Scaffold(
      backgroundColor: AppColors.background.lightBlue,
      appBar: buildAppBar() as PreferredSizeWidget?,
      body: WillPopScope(
        onWillPop: () async {
          logic.controller.reset();
          return true;
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildBalanceAmount(),
                  const SizedBox(height: 20),
                  buildPaymentMode(),
                  const SizedBox(height: 20),
                  buildPaymentDate(context),
                  const SizedBox(height: 20),
                  buildDepositTF(),
                  buildPaymentReferenceTextField(),
                  buildReceiptNo(),
                  const SizedBox(height: 70),
                  buildProceed(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDepositTF() {
    return GetBuilder<AddPaymentsController>(
      builder: (controller) {
        return AppTextField(
          width: 320,
          hintText: 'Deposit',
          controller: controller.depositTED,
          focusNode: controller.depositNode,
          nextFocusNode: controller.paymentReferenceNode,
          keyboardType: TextInputType.number,
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

  Widget buildAppBar() {
    return AppBar(
      toolbarHeight: 70,
      centerTitle: true,
      title: buildTitle(),
      leading: TextButton(
        onPressed: () {
          logic.controller.reset();
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
    );
  }

  Widget buildPaymentDate(BuildContext context) {
    return GetBuilder<AddPaymentsController>(builder: (controller) {
      DateTime date = controller.paymentDate;
        String paymentDate = DateFormat('d MMM yyyy').format(date);
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Payment Date',
              style: TextStyle(fontSize: FontSize.textSize),
            ),
            GestureDetector(
              onTap: () {
                logic.datePicker(context);
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
                child: Center(child: Text(paymentDate)),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildPaymentReferenceTextField() {
    return GetBuilder<AddPaymentsController>(
      builder: (controller) {
        return AppTextField(
          width: 320,
          hintText: 'Payment Reference',
          controller: controller.paymentReferenceTED,
          focusNode: controller.paymentReferenceNode,
          nextFocusNode: controller.receiptNoNode,
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
    return GetBuilder<AddPaymentsController>(
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
          child: GetBuilder<AddPaymentsController>(
            builder: (controller) {
              return Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: DropdownButton(
                  underline: const SizedBox(),
                  isExpanded: true,
                  value: controller.paymentModeTED.text.isNotEmpty ? controller.paymentModeTED.text : null,
                  onChanged: (dynamic mode) {
                    controller.paymentModeTED.text = mode;
                    controller.update();
                  },
                  items: controller.paymentOptions.map((newMode) {
                    return DropdownMenuItem(
                      value: newMode,
                      child: Text(newMode),
                    );
                  }).toList(),
                ),
              );
            },
          ),
        )
      ],
    );
  }

  Widget buildBalanceAmount() {
    return GetBuilder<AddPaymentsController>(
      builder: (controller) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Balance',
              style: TextStyle(
                fontSize: FontSize.textSize,
                color: AppColors.text.black,
              ),
            ),
            SizedBox(
              height: 30,
              width: 120,
              child: Text(
                ' ${getBalance(bookingArg!.payments!, double.parse(bookingArg!.paid.toString()).roundToDouble(), double.parse(bookingArg!.totalCost.toString()).roundToDouble())} /-',
              ),
            )
          ],
        );
      },
    );
  }

  String getBalance(List<PaymentModel> payments, double deposit, double total) {
    double t = deposit;
    for (var payment in payments) {
      t += payment.amount!;
    }
    return (total - t).toInt().toString();
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
        text: 'Proceed',
        textColor: AppColors.text.white,
        color: AppColors.background.black,
        onTap: () {
          logic.onPaymentDetailsFilled(
            getBalance(
              bookingArg!.payments!,
              double.parse(bookingArg!.paid.toString()).roundToDouble(),
              double.parse(bookingArg!.totalCost.toString()).roundToDouble(),
            ),
          );
        },
      ),
    );
  }
}
