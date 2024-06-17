import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:temple_ui_tools/utils/utils.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/util/alignment_extensions.dart';
import '../../../../core/util/spacing_widgets.dart';
import '../../../../core/util/validator.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/phone_number/intl_phone_field.dart';
import '../../controller/new_booking_controller.dart';
import '../../models/activity_model.dart';
import '../widgets/app_text_fields.dart';
import 'book_date_time_view.dart';

class AddCustomerDetailsView extends StatelessWidget {
  final NewBookingLogic logic = NewBookingLogic();

  AddCustomerDetailsView({Key? key}) : super(key: key);

  static Route route() => MaterialPageRoute(
        builder: (context) => AddCustomerDetailsView(),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(heading: 'New Booking'),
      floatingActionButton: buildFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      backgroundColor: AppColors.background.lightBlue,
      body: WillPopScope(
        onWillPop: () async {
          logic.controller.reset();
          return true;
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: GetBuilder<NewBookingController>(
                builder: (controller) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          buildSubTitle('Quick Booking'),
                          const Spacer(),
                          Switch(
                            value: controller.isQuickBooking,
                            onChanged: (value) {
                              controller.isQuickBooking = value;
                            },
                            activeColor: AppColors.text.skyBlue,
                            inactiveThumbColor: AppColors.text.grey,
                          ),
                        ],
                      ),
                      (controller.isQuickBooking)
                          ? Stack(
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        buildSubTitle('Customer Booking'),
                                        const Spacer(),
                                        Switch(
                                          value: controller.isCustomerBooking,
                                          onChanged: (value) {
                                            controller.isCustomerBooking = value;
                                          },
                                          activeColor: AppColors.text.skyBlue,
                                          inactiveThumbColor: AppColors.text.grey,
                                        ),
                                      ],
                                    ),
                                    AppTextField(
                                      hintText: 'Parent Booking Id',
                                      controller: logic.controller.quickBookingIdTED,
                                      keyboardType: TextInputType.number,
                                      errorValidator: () {
                                        return null;
                                      },
                                      validator: (_) {
                                        return null;
                                      },
                                    ),
                                    AppTextField(
                                      hintText: 'Name',
                                      controller: logic.controller.quickNameTED,
                                      required: true,
                                      errorValidator: () {
                                        return null;
                                      },
                                      validator: (_) {
                                        return null;
                                      },
                                    ),
                                    if (controller.isCustomerBooking)
                                      AppTextField(
                                        hintText: 'Customer Email Id',
                                        controller: logic.controller.quickEmailTED,
                                        required: true,
                                        errorValidator: () {
                                          return null;
                                        },
                                        validator: (_) {
                                          return null;
                                        },
                                        inputFormatter: [
                                          TextInputFormatter.withFunction((oldValue, newValue) {
                                            return newValue.copyWith(text: newValue.text.toLowerCase());
                                          }),
                                        ],
                                      ),
                                    AppTextField(
                                      hintText: 'No of Persons',
                                      controller: logic.controller.quickNoOfPersonsTED,
                                      keyboardType: TextInputType.number,
                                      required: true,
                                      errorValidator: () {
                                        return null;
                                      },
                                      validator: (_) {
                                        return null;
                                      },
                                    ),
                                    buildActivityDropDown(),
                                    const SizedBox(height: 20),
                                    buildQuickDiveSession(context),
                                    const SizedBox(height: 100),
                                    AppButton.flat(
                                      text: 'Create Booking',
                                      onTap: () {
                                        log('started creating');
                                        logic.createBooking(context);
                                        log('done');
                                      },
                                      color: Colors.black,
                                      textColor: Colors.white,
                                    ),
                                    Spacing.h40,
                                  ],
                                ).scrollable,
                                if (controller.quickShowLoading)
                                  Container(
                                    height: Screen.height,
                                    width: Screen.width,
                                    color: Colors.grey.shade50,
                                    child: const SizedBox(
                                      height: 30,
                                      width: 30,
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                  ),
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                if (!controller.getDetailsPressed) ...[
                                  buildEmailID(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      AppButton.miniFlat(
                                        text: 'Get Details',
                                        onTap: () {
                                          logic.getDetailsPressed();
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                                if (controller.getDetailsPressed) ...[
                                  buildNameFields(),
                                  buildEmailID(),
                                  buildDOB(context),
                                  buildNoOfPersons(),
                                  buildPhoneNumber(),
                                  const SizedBox(height: 40),
                                ],
                                if (controller.showLoading)
                                  const SizedBox(
                                    height: 200,
                                    child: Center(
                                      child: SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.black,
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///======================UI==============///

  Widget buildQuickDiveSession(BuildContext context) {
    return GetBuilder<NewBookingController>(
      builder: (controller) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildSubTitle('Dive Session'),
                AppButton.miniFlat(
                  text: 'ADD',
                  onTap: () {
                    logic.addQuickDiveSessionDateTime(context);
                  },
                  bgColor: AppColors.background.black,
                  textColor: AppColors.text.white,
                ),
              ],
            ),
            Wrap(
              children: (controller.quickDiveDates ?? []).map((e) => buildTime(e, DateType.dive)).toList(),
            ),
          ],
        );
      },
    );
  }

  Widget buildTime(DateTime? date, DateType type) {
    if (date != null) {
      return GestureDetector(
        onTap: () {
          if (type == DateType.dive) {
            logic.controller.quickDiveDates!.remove(date);
          }

          logic.controller.update();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          margin: const EdgeInsets.only(right: 10, bottom: 10),
          decoration: BoxDecoration(
            color: AppColors.background.lightSkyBlue,
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: FittedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(DateFormat('MMM  dd @ hh:mm a').format(date)),
                Spacing.w20,
                const Icon(
                  Icons.close,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      );
    }
    return const SizedBox();
  }

  Widget buildActivityDropDown() {
    return SizedBox(
      width: 320,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Container(
                width: Screen.width,
                alignment: Alignment.centerLeft,
                child: buildSubTitle('Activity'),
              ),
            ),
          ),
          SizedBox(
            width: 210,
            child: GetBuilder<NewBookingController>(
              builder: (controller) {
                return Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: DropdownButton(
                    underline: Container(height: 1, color: Colors.black45),
                    isExpanded: true,
                    value: controller.quickSelectedActivity,
                    onChanged: (Activity? activity) {
                      if (activity != null) {
                        controller.quickSelectedActivity = activity;
                        logic.controller.update();
                      }
                    },
                    items: controller.activities.toSet().toList().map((activity) {
                      return DropdownMenuItem(
                        value: activity,
                        child: Text(
                          activity.name ?? 'error',
                          style: const TextStyle(fontWeight: FontWeight.normal),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSubTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        color: AppColors.text.black,
        fontSize: 14,
        fontFamily: AppFonts.nunito,
        fontWeight: FontWeight.normal,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget buildNoOfPersons() {
    return AppTextField(
      hintText: 'No of Persons',
      controller: logic.controller.paxTED,
      focusNode: logic.controller.noOfPersonsNode,
      nextFocusNode: logic.controller.phoneNumberNode,
      keyboardType: TextInputType.number,
      required: true,
      onChangedCallBack: (_) {},
      isStrictNumber: true,
      errorValidator: () {
        return null;
      },
      validator: (email) {
        return null;
      },
    );
  }

  Widget buildDOB(BuildContext context) {
    return GetBuilder<NewBookingController>(
      builder: (controller) {
        return GestureDetector(
          onTap: () {
            logic.dobDatePicker(context);
          },
          child: AbsorbPointer(
            child: AppTextField(
              hintText: 'Date of Birth',
              controller: logic.controller.dobTED,
              focusNode: logic.controller.dobNode,
              nextFocusNode: logic.controller.noOfPersonsNode,
              keyboardType: TextInputType.number,
              required: false,
              onChangedCallBack: (_) {},
              errorValidator: () {
                return null;
              },
              validator: (email) {
                return null;
              },
            ),
          ),
        );
      },
    );
  }

  Widget buildNameFields() {
    return Row(
      children: [
        AppTextField(
          width: (Screen.width / 2) - 45,
          hintText: 'First Name',
          controller: logic.controller.fNameTED,
          focusNode: logic.controller.fNameNode,
          nextFocusNode: logic.controller.lNameNode,
          required: true,
          onChangedCallBack: (_) {},
          errorValidator: () {
            return null;
          },
          validator: (email) {
            return null;
          },
        ),
        const SizedBox(
          width: 10,
        ),
        AppTextField(
          width: (Screen.width / 2) - 45,
          hintText: 'Last Name',
          controller: logic.controller.lNameTED,
          focusNode: logic.controller.lNameNode,
          nextFocusNode: logic.controller.emailNode,
          required: false,
          onChangedCallBack: (_) {},
          errorValidator: () {
            return null;
          },
          validator: (email) {
            return null;
          },
        ),
      ],
    );
  }

  Widget buildEmailID() {
    return AppTextField(
      hintText: 'Enter Customer Email ID',
      controller: logic.controller.emailTED,
      focusNode: logic.controller.emailNode,
      keyboardType: TextInputType.emailAddress,
      onChangedCallBack: (_) {},
      required: true,
      inputFormatter: [
        TextInputFormatter.withFunction((oldValue, newValue) {
          return newValue.copyWith(text: newValue.text.toLowerCase());
        }),
      ],
      errorValidator: () {
        return Validator.validateEmail(logic.controller.emailTED.text);
      },
      validator: (email) {
        return Validator.validateEmail(email!);
      },
    );
  }

  Widget buildPhoneNumber() {
    return GetBuilder<NewBookingController>(
      builder: (controller) {
        return IntlPhoneField(
          autoValidate: true,
          focusNode: controller.phoneNumberNode,
          initialCountryCode: controller.isoCode,
          showCountryFlag: false,
          initialValue: controller.phoneNumberTED.text,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(
            labelText: 'Phone Number  *',
            labelStyle: TextStyle(
              fontSize: FontSize.small,
              fontFamily: AppFonts.nunito,
            ),
          ),
          style: const TextStyle(
            fontFamily: AppFonts.nunito,
            fontWeight: FontWeight.normal,
            fontSize: 14,
          ),
          searchText: 'Search',
          onSubmitted: (_) {},
          onChanged: (phone) {
            controller.countryCodeTED.text = phone.countryCode;
            controller.phoneNumberTED.text = phone.number!;
            controller.isoCode = phone.countryISOCode;
          },
        );
      },
    );
  }

  Widget buildFloatingActionButton(BuildContext context) {
    return GetBuilder<NewBookingController>(
      builder: (controller) {
        if (controller.getDetailsPressed && !controller.isQuickBooking) {
          return FloatingActionButton(
            onPressed: () {
              logic.onCheckPressed(context);
            },
            elevation: 0,
            backgroundColor: AppColors.iconColor.black,
            child: const Icon(
              Icons.check,
              color: Colors.white,
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
