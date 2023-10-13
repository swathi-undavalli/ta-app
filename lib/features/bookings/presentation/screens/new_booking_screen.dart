import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/util/utils.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/back_navigation_icon.dart';
import '../../controller/new_booking_controller.dart';
import '../widgets/app_text_fields.dart';

class NewBookingScreen extends StatelessWidget {
  static const String id = 'BookingFormScreen';
  final NewBookingLogic logic = NewBookingLogic();

  NewBookingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar() as PreferredSizeWidget?,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              buildTextFields(),
              buildBreakdown(),
              buildButtons(),
              const SizedBox(height: 30)
            ],
          ),
        ),
      ),
    );
  }

  ///======================UI====================///

  Widget buildDiveLocation() {
    return SizedBox(
      width: 320,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 12, top: 10),
              child: Container(
                width: Get.width,
                alignment: Alignment.centerLeft,
                child: buildSubTitle(text: 'Dive Location'),
              ),
            ),
          ),
          SizedBox(
            width: 180,
            child: buildLocation(),
          ),
        ],
      ),
    );
  }

  Widget buildSwitch(
      {required String text, Function? onChanged, required bool switchValue,}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            text,
            style: TextStyle(
                fontSize: FontSize.small, color: AppColors.text.darkgrey,),
          ),
        ),
        Switch(
          value: switchValue,
          onChanged: onChanged as void Function(bool)?,
          activeColor: AppColors.text.skyBlue,
          inactiveThumbColor: AppColors.text.grey,
        ),
      ],
    );
  }

  Widget buildLocation() {
    return GetBuilder<NewBookingController>(builder: (controller) {
      return Padding(
        padding: const EdgeInsets.only(left: 13),
        child: Text(
          controller.diveLocation,
          style: TextStyle(fontSize: 16, color: AppColors.text.black),
        ),
      );
    },);
  }

  Widget buildAppBar() {
    return AppBar(
      toolbarHeight: 70,
      centerTitle: true,
      title: buildTitle(),
      leading: const BackNavigationIcon(),
      elevation: 0,
      backgroundColor: AppColors.background.white,
    );
  }

  Widget buildTextFields() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: GetBuilder<NewBookingController>(builder: (controller) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(height: 30),
            buildDiveLocation(),
            const SizedBox(height: 20),
            buildPriceField(),
            buildDiscount(),
            buildTax(),
            buildPayingNow(),
            AppTextField(
              hintText: 'Remarks',
              controller: logic.controller.remarksTED,
              focusNode: logic.controller.remarksNode,
              required: false,
              onChangedCallBack: (_) {},
              errorValidator: () {
                return null;
                // return Validator.validateEmail(
                //     logic.controller.emailTED.text);
              },
              validator: (email) {
                return null;
                // return Validator.validateEmail(email);
              },
            ),
          ],
        );
      },),
    );
  }

  Widget buildPriceField() {
    return AppTextField(
      hintText: 'Price',
      isStrictNumber: true,
      controller: logic.controller.priceTED,
      focusNode: logic.controller.priceNode,
      nextFocusNode: logic.controller.discountNode,
      keyboardType: TextInputType.number,
      onChangedCallBack: (value) {
        logic.controller.bookingModel.price = getInt(value) * 1.0;
        logic.controller.update();
      },
      required: false,
      errorValidator: () {
        return null;
      },
      validator: (noOfPersons) {
        return null;
        // return Validator.validateName(noOfPersons);
      },
    );
  }

  Widget buildBreakdown() {
    return Padding(
      padding: const EdgeInsets.only(top: 100, left: 40, bottom: 100),
      child: SizedBox(
        width: Get.width,
        height: 120,
        child: GetBuilder<NewBookingController>(builder: (controller) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildAmountSummary(
                  text: 'Price',
                  amount: getInt(controller.priceTED.text) *
                      controller.bookingModel.noOfPersons! *
                      1.0,),
              buildAmountSummary(
                text: 'Discount',
                amount: getDiscount(controller),
              ),
              buildAmountSummary(
                  text: 'Total Amount',
                  amount: controller.bookingModel.totalCost.ceilToDouble(),),
              buildAmountSummary(
                  text: 'Balance',
                  amount: controller.bookingModel.balance.ceilToDouble(),),
            ],
          );
        },),
      ),
    );
  }

  getDiscount(NewBookingController controller) {
    double price = getInt(controller.priceTED.text) *
        controller.bookingModel.noOfPersons! *
        1.0;
    if (controller.bookingModel.discountType == '%') {
      return price * (controller.bookingModel.discount! / 100);
    }
    return (controller.bookingModel.discount) ?? 0.0;
  }

  Widget buildAmountSummary({required String text, double? amount}) {
    return SizedBox(
      width: 320,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Container(
                width: Get.width,
                alignment: Alignment.centerLeft,
                child: buildSubTitle(text: text),
              ),
            ),
          ),
          SizedBox(
            width: 215,
            child: Text(
              ':      $amount',
              style: const TextStyle(fontSize: FontSize.textSize),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        buildCancelButton(),
        buildContinueButton(),
      ],
    );
  }

  Widget buildShowLoading() {
    return GetBuilder<NewBookingController>(builder: (controller) {
      if (controller.showLoading) {
        return Container(
          color: Colors.black54,
          height: Get.height,
          width: Get.width,
          child: const Center(
              child: CircularProgressIndicator(
            color: Colors.white,
          ),),
        );
      } else {
        return Container();
      }
    },);
  }

  Widget buildDiscount() {
    return SizedBox(
      width: 320,
      child: GetBuilder<NewBookingController>(builder: (controller) {
        return Row(
          children: [
            Expanded(
              child: AppTextField(
                hintText: 'Discount',
                controller: logic.controller.discountTED,
                focusNode: logic.controller.discountNode,
                nextFocusNode: logic.controller.payingNowNode,
                keyboardType: TextInputType.number,
                required: false,
                errorValidator: () {
                  return null;
                },
                onChangedCallBack: (discount) {
                  try {
                    controller.bookingModel.discount = double.parse(discount);
                  } catch (e) {
                    controller.bookingModel.discount = 0;
                  }
                  controller.update();
                },
                validator: (firstName) {
                  return null;
                  // return Validator.validateName(firstName);
                },
              ),
            ),
            const SizedBox(
              width: 30,
            ),
            Row(
              children: [
                Text(
                  '₹',
                  style: TextStyle(
                      fontSize: 17,
                      color: !controller.discountSwitch
                          ? AppColors.text.skyBlue
                          : AppColors.text.grey,),
                ),
                SizedBox(
                  width: 70,
                  height: 75,
                  child: buildSwitch(
                      text: '',
                      switchValue: controller.discountSwitch,
                      onChanged: (value) {
                        if (value) {
                          controller.bookingModel.discountType = '%';
                        } else {
                          controller.bookingModel.discountType = '₹';
                        }
                        controller.discountSwitch = value;
                      },),
                ),
                Text(
                  '%',
                  style: TextStyle(
                      fontSize: 15,
                      color: controller.discountSwitch
                          ? AppColors.text.skyBlue
                          : AppColors.text.grey,),
                ),
              ],
            ),
          ],
        );
      },),
    );
  }

  Widget buildTax() {
    return SizedBox(
      width: 320,
      child: GetBuilder<NewBookingController>(builder: (controller) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tax',
              style: TextStyle(fontSize: 12, color: AppColors.text.darkgrey),
            ),
            SizedBox(
              width: 70,
              height: 75,
              child: buildSwitch(
                  text: '',
                  switchValue: controller.taxable,
                  onChanged: (value) {
                    if (value) {
                      controller.bookingModel.tax = 18;
                    } else {
                      controller.bookingModel.tax = 0;
                    }
                    controller.taxable = value;
                  },),
            ),
          ],
        );
      },),
    );
  }

  Widget buildPayingNow() {
    return SizedBox(
      width: 320,
      child: GetBuilder<NewBookingController>(builder: (controller) {
        return AppTextField(
          hintText: 'Paying Now',
          controller: logic.controller.payingNowTED,
          focusNode: logic.controller.payingNowNode,
          nextFocusNode: logic.controller.remarksNode,
          isStrictNumber: true,
          keyboardType: TextInputType.number,
          required: false,
          errorValidator: () {
            if (controller.bookingModel.balance < 0) return 'Invalid Amount';
            return null;
          },
          onChangedCallBack: (payingNow) {
            try {
              controller.bookingModel.paid =
                  double.parse(controller.payingNowTED.text);
            } catch (e) {
              controller.bookingModel.paid = 0;
            }
            controller.update();
          },
          validator: (firstName) {
            //print(firstName);
            return null;
            // return Validator.validateName(firstName);
          },
        );
      },),
    );
  }

  Widget buildSubTitle({required String text}) {
    return Text(
      text,
      style: TextStyle(
        color: AppColors.text.black,
        fontSize: 12,
        fontFamily: AppFonts.nunito,
        fontWeight: FontWeight.normal,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget buildTitle() {
    return Text(
      'Booking Form',
      style: TextStyle(
        color: AppColors.text.black,
        fontSize: 20,
        fontFamily: AppFonts.nunito,
        fontWeight: FontWeight.normal,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget buildCancelButton() {
    return Center(
      child: AppButton.flat(
        text: 'Cancel',
        textColor: AppColors.text.black,
        color: AppColors.background.grey,
        onTap: () {
          Get.back();
        },
      ),
    );
  }

  Widget buildContinueButton() {
    return Center(
      child: GetBuilder<NewBookingController>(builder: (controller) {
        return AppButton.flat(
          text: 'Continue',
          textColor: AppColors.text.white,
          color: AppColors.background.black,
          onTap: () {
            logic.onContinuePressedBookingForm();
          },
        );
      },),
    );
  }
}
