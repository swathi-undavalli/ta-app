import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/util/app-func.dart';
import 'package:temple_adventures/core/util/validator.dart';
import 'package:temple_adventures/core/widgets/app-button.dart';
import 'package:temple_adventures/core/widgets/back-navigation-icon.dart';
import 'package:temple_adventures/features/bookings/controller/new-booking-controller.dart';
import 'package:temple_adventures/features/bookings/presentation/screens/add_customer_details_screen.dart';
import 'package:temple_adventures/features/bookings/presentation/screens/add_customer_screen.dart';
import 'package:temple_adventures/features/bookings/presentation/screens/new-customer-screen.dart';
import 'package:temple_adventures/features/bookings/presentation/screens/payment-details-screen.dart';
import 'package:temple_adventures/features/bookings/presentation/widgets/activity-selector.dart';
import 'package:temple_adventures/features/bookings/presentation/widgets/app-text-fields.dart';

class NewBookingScreen extends StatelessWidget {
  static const String id = "BookingFormScreen";
  final NewBookingLogic logic = NewBookingLogic();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: buildAppBar(),
          body: SafeArea(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  buildTextFields(),
                  buildBreakdown(),
                  buildButtons(),
                  SizedBox(height: 30)
                ],
              ),
            ),
          ),
        ),
        buildShowLoading(),
      ],
    );
  }

  ///======================UI====================///

  Widget buildDiveLocation() {
    return Container(
      width: 320,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 12, top: 10),
              child: Container(
                width: Get.width,
                alignment: Alignment.centerLeft,
                child: buildSubTitle(text: "Dive Location"),
              ),
            ),
          ),
          Container(
            width: 180,
            child: buildLocation(),
          ),
        ],
      ),
    );
  }

  Widget buildSwitch({String text, Function onChanged, bool switchValue}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            text,
            style: TextStyle(
                fontSize: FontSize.small, color: AppColors.text.darkgrey),
          ),
        ),
        Switch(
          value: switchValue,
          onChanged: onChanged,
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
    });
  }

  // Widget buildActivityDropDown() {
  //   return Container(
  //     width: 320,
  //     child: Row(
  //       children: [
  //         Expanded(
  //           child: Padding(
  //             padding: const EdgeInsets.only(right: 12, top: 12),
  //             child: Container(
  //               width: Get.width,
  //               alignment: Alignment.centerLeft,
  //               child: buildSubTitle(text: "Activities"),
  //             ),
  //           ),
  //         ),
  //         Container(
  //           width: 215,
  //           child: GetBuilder<NewBookingController>(builder: (controller) {
  //             return Padding(
  //               padding: const EdgeInsets.only(left: 13),
  //               child: DropdownButton(
  //                 // focusNode: controller.locationNode,
  //                 underline: Container(height: 1, color: Colors.black45),
  //                 isExpanded: true,
  //                 value: (controller.selectedActivity == null ||
  //                         controller.selectedActivity.length == 0)
  //                     ? null
  //                     : controller.selectedActivity[0],
  //                 onChanged: (activity) {
  //                   if (controller.selectedActivity == null ||
  //                       controller.selectedActivity.length == 0) {
  //                     controller.selectedActivity = [];
  //                     controller.selectedActivity.add(activity);
  //                   } else
  //                     controller.selectedActivity[0] = activity;
  //                   controller.priceTED.text = activity.price.toString();
  //                   logic.getPrice();
  //                   controller.update();
  //                 },
  //                 items: controller.activities.toSet().toList().map((activity) {
  //                   return DropdownMenuItem(
  //                     child: new Text(
  //                       activity.name,
  //                       style: TextStyle(
  //                         fontWeight: FontWeight.normal,
  //                       ),
  //                     ),
  //                     value: activity,
  //                   );
  //                 }).toList(),
  //               ),
  //             );
  //           }),
  //         ),
  //       ],
  //     ),
  //   );
  // }

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

  Widget buildTextFields() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: GetBuilder<NewBookingController>(builder: (controller) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // buildActivityDropDown(),
            SizedBox(height: 30),
            buildDiveLocation(),
            SizedBox(height: 20),
            buildPriceField(),
            // buildPAXField(),
            buildDiscount(),
            buildTax(),
            buildPayingNow(),
            AppTextField(
              hintText: "Remarks",
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
      }),
    );
  }

  // Widget buildPAXField() {
  //   return AppTextField(
  //     hintText: 'No of Persons',
  //     controller: logic.controller.paxTED,
  //     focusNode: logic.controller.noOfPersonsNode,
  //     nextFocusNode: logic.controller.discountNode,
  //     keyboardType: TextInputType.number,
  //     onChanged: () {
  //       try {
  //         logic.getPrice();
  //       } catch (e) {
  //         print("error");
  //         print(e);
  //       }
  //     },
  //     required: false,
  //     errorValidator: () {
  //       return null;
  //     },
  //     validator: (noOfPersons) {
  //       return null;
  //       // return Validator.validateName(noOfPersons);
  //     },
  //   );
  // }

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
        // try {
        //   logic.getPrice();
        // } catch (e) {
        //   print("error");
        //   print(e);
        // }
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
      child: Container(
        width: Get.width,
        height: 120,
        child: GetBuilder<NewBookingController>(builder: (controller) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildAmountSummary(
                  text: "Price",
                  amount: getInt(controller.priceTED.text) *
                      controller.bookingModel.noOfPersons *
                      1.0),
              buildAmountSummary(
                text: "Discount",
                amount: getDiscount(controller),
              ),
              buildAmountSummary(
                  text: "Total Amount",
                  amount: controller.bookingModel.totalCost),
              buildAmountSummary(
                  text: "Balance", amount: controller.bookingModel.balance),
            ],
          );
        }),
      ),
    );
  }

  getDiscount(NewBookingController controller) {
    double price = getInt(controller.priceTED.text) *
        controller.bookingModel.noOfPersons *
        1.0;
    if (controller.bookingModel.discountType == "%")
      return price * (controller.bookingModel.discount / 100);
    return (controller.bookingModel.discount) ?? 0.0;
  }

  Widget buildAmountSummary({String text, double amount}) {
    return Container(
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
          Container(
            width: 215,
            child: Text(
              ":      " + amount.toString(),
              style: TextStyle(fontSize: FontSize.textSize),
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
      if (controller.showLoading)
        return Container(
          color: Colors.black54,
          height: Get.height,
          width: Get.width,
          child: Center(
              child: CircularProgressIndicator(
            color: Colors.white,
          )),
        );
      else
        return Container();
    });
  }

  Widget buildDiscount() {
    return Container(
      width: 320,
      child: GetBuilder<NewBookingController>(builder: (controller) {
        return Row(
          children: [
            Expanded(
              child: Container(
                child: AppTextField(
                  hintText: "Discount",
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
            ),
            SizedBox(
              width: 30,
            ),
            Row(
              children: [
                Text(
                  "₹",
                  style: TextStyle(
                      fontSize: 17,
                      color: !controller.discountSwitch
                          ? AppColors.text.skyBlue
                          : AppColors.text.grey),
                ),
                Container(
                  width: 70,
                  height: 75,
                  child: buildSwitch(
                      text: "",
                      switchValue: controller.discountSwitch,
                      onChanged: (value) {
                        if (value)
                          controller.bookingModel.discountType = "%";
                        else
                          controller.bookingModel.discountType = "₹";
                        controller.discountSwitch = value;
                      }),
                ),
                Text(
                  "%",
                  style: TextStyle(
                      fontSize: 15,
                      color: controller.discountSwitch
                          ? AppColors.text.skyBlue
                          : AppColors.text.grey),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }

  Widget buildTax() {
    return Container(
      width: 320,
      child: GetBuilder<NewBookingController>(builder: (controller) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Tax",
              style: TextStyle(fontSize: 12, color: AppColors.text.darkgrey),
            ),
            Container(
              width: 70,
              height: 75,
              child: buildSwitch(
                  text: "",
                  switchValue: controller.taxable,
                  onChanged: (value) {
                    if (value)
                      controller.bookingModel.tax = 18;
                    else
                      controller.bookingModel.tax = 0;
                    controller.taxable = value;
                  }),
            ),
          ],
        );
      }),
    );
  }

  Widget buildPayingNow() {
    return Container(
      width: 320,
      child: GetBuilder<NewBookingController>(builder: (controller) {
        return Container(
          child: AppTextField(
            hintText: "Paying Now",
            controller: logic.controller.payingNowTED,
            focusNode: logic.controller.payingNowNode,
            nextFocusNode: logic.controller.remarksNode,
            isStrictNumber: true,
            keyboardType: TextInputType.number,
            required: false,
            errorValidator: () {
              if (controller.balance < 0) return "Invalid Amount";
              return null;
            },
            onChangedCallBack: (payingNow) {
              try {
                controller.bookingModel.payingNow =
                    double.parse(controller.payingNowTED.text);
              } catch (e) {
                controller.bookingModel.payingNow = 0;
              }
              controller.update();
            },
            validator: (firstName) {
              print(firstName);
              return null;
              // return Validator.validateName(firstName);
            },
          ),
        );
      }),
    );
  }

  Widget buildSubTitle({String text}) {
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
        text: "Cancel",
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
          text: "Continue",
          textColor: AppColors.text.white,
          color: AppColors.background.black,
          onTap: () {
            logic.onContinuePressedBookingForm();
          },
        );
      }),
    );
  }
}
