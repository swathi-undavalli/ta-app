import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/util/app-func.dart';
import 'package:temple_adventures/core/widgets/app-button.dart';
import 'package:temple_adventures/core/widgets/app-expansion-panel.dart';
import 'package:temple_adventures/core/widgets/back-navigation-icon.dart';
import 'package:temple_adventures/core/widgets/bookings_calender_widget/bookings_calender_widget.dart';
import 'package:temple_adventures/core/widgets/bookings_calender_widget/bookings_calender_widget_controller.dart';
import 'package:temple_adventures/core/widgets/phone_number/intl_phone_field.dart';
import 'package:temple_adventures/features/bookings/controller/edit-booking-details-controller.dart';
import 'package:temple_adventures/features/bookings/controller/new-booking-controller.dart';
import 'package:temple_adventures/features/bookings/models/booking-model.dart';
import 'package:temple_adventures/features/bookings/presentation/screens/book-date-time-screen.dart';
import 'package:temple_adventures/features/bookings/presentation/widgets/app-text-fields.dart';
import 'package:intl/intl.dart';

class EditBookingDetailsScreen extends StatelessWidget {
  static const String id = "EditCustomerDetails";
  EditBookingDetailsLogic logic = EditBookingDetailsLogic();
  final BookingModel bookingArg = Get.arguments;
  ExpansionPanelLogic expansionPanelLogic = ExpansionPanelLogic();

  EditBookingDetailsScreen() {
    expansionPanelLogic.controller.bookingModel = bookingArg;
    logic.controller.bookingModel = bookingArg;
    logic.controller.activityNAmeTED.text =
        bookingArg.activity[0].name.toString();
    logic.controller.discountTED.text = (bookingArg.discount).toString();
    logic.controller.totalAmountTED.text = (bookingArg.totalCost).toString();
    logic.controller.priceTED.text = bookingArg.price.toString();
    logic.controller.depositTED.text = bookingArg.payingNow.toString();
    logic.controller.balanceTED.text = bookingArg.balance.toString();
    logic.controller.paxTED.text = bookingArg.noOfPersons.toString();
    logic.controller.remarksTED.text = bookingArg.remarks;
    logic.controller.countryCodeTED.text = bookingArg.pax[0]["countryCode"];
    logic.controller.phoneTED.text = bookingArg.pax[0]["phoneNumber"];
    logic.controller.emailTED.text = bookingArg.pax[0]["email"];
    logic.controller.isoCode = bookingArg.pax[0]["isoCode"];
    logic.controller.taxableAmount = bookingArg.tax;
    logic.controller.discount = bookingArg.discount;
    logic.controller.totalCost = bookingArg.totalCost;
    logic.controller.cost = bookingArg.price;
    logic.controller.taxable = bookingArg.tax != 0;
    logic.controller.discountSwitch = bookingArg.discountType == "%";
    // logic.getPrice();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        centerTitle: true,
        title: buildTitle(),
        leading: BackNavigationIcon(),
        elevation: 0,
        backgroundColor: AppColors.background.white,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: SafeArea(
          child:
              GetBuilder<EditBookingDetailsController>(builder: (controller) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        buildActivityDropDown(),
                        buildPriceTF(controller),
                        buildPAXTF(controller),
                        buildDiscount(),
                        buildTax(),
                        Container(
                          width: 320,
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: Text(
                                    "TotalCost" + "   :",
                                    style: TextStyle(
                                        fontSize: FontSize.small,
                                        color: AppColors.text.darkgrey),
                                  ),
                                ),
                              ),
                              Container(
                                child: Text(
                                  controller.bookingModel.totalCost.toString() +
                                      "/-",
                                  style: TextStyle(
                                      fontSize: FontSize.textSize,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                        buildDepositTF(controller),
                        SizedBox(height: 20),
                        Container(
                          width: 320,
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: Text(
                                    "Balance" + "   :",
                                    style: TextStyle(
                                        fontSize: FontSize.small,
                                        color: AppColors.text.darkgrey),
                                  ),
                                ),
                              ),
                              Container(
                                // width: 80,
                                child: Text(
                                  controller.bookingModel.balance.toString() +
                                      "/-",
                                  style: TextStyle(
                                      fontSize: FontSize.textSize,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                        buildRemarksTF(controller),
                        buildEmailTF(controller),
                        SizedBox(height: 10),
                        buildPhoneNumber(),
                        SizedBox(height: 10),
                        SizedBox(height: 100),
                        buildEditSessions(
                          controller,
                          type: DateType.Theory,
                        ),
                        SizedBox(height: 30),
                        buildEditSessions(
                          controller,
                          type: DateType.Pool,
                        ),
                        SizedBox(height: 30),
                        buildEditSessions(
                          controller,
                          type: DateType.Dive,
                        ),
                        SizedBox(height: 100),
                        // buildDateButton(
                        //     date: controller.bookingModel.theoryDate[0],
                        //     onTap: () {
                        //       logic.onChooseTheorySessionPressed();
                        //     },
                        //     text: "Theory"),
                        // buildDateButton(
                        //     date: controller.bookingModel.poolDate[0],
                        //     onTap: () {
                        //       logic.onChoosePoolSessionPressed();
                        //     },
                        //     text: "Pool"),
                        // buildDateButton(
                        //     date: controller.bookingModel.diveDate[0],
                        //     onTap: () {
                        //       logic.onChooseDiveSessionPressed();
                        //     },
                        //     text: "Dive"),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 50),
                buildButtons(),
                SizedBox(height: 50),
                // SizedBox(height: 50),
              ],
            );
          }),
        ),
      ),
    );
  }

  Column buildEditSessions(EditBookingDetailsController controller,
      {@required DateType type}) {
    String title = "";
    List<Widget> dates = [];
    if (type == DateType.Theory) {
      title = "Theory";
      dates = controller.bookingModel.theoryDate
          .map(
            (e) => buildDateButton(
              date: e,
              onEdit: () {
                DateTime selectedTheoryDate = e;
                Get.defaultDialog(
                  title: "",
                  titlePadding: EdgeInsets.all(0),
                  titleStyle: TextStyle(fontSize: 0, height: 0),
                  content: Container(
                    height: 480,
                    width: 400,
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: Text(
                            "Choose Date",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        BookingsCalenderWidget(
                          highlightInvalidTime: true,
                          startDate: DateTime.now(),
                          calenderType: FilterType.Theory,
                          onDateTimeSelected: (date) {
                            selectedTheoryDate = date;
                          },
                          isDiveSession: false,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            AppButton.miniText(
                              text: "Cancel",
                              onTap: () {
                                Get.back();
                              },
                            ),
                            AppButton.miniFlat(
                              text: "Okay",
                              bgColor: AppColors.background.black,
                              textColor: AppColors.text.white,
                              onTap: () {
                                if (selectedTheoryDate != null &&
                                    selectedTheoryDate.hour != null &&
                                    selectedTheoryDate.minute != null &&
                                    selectedTheoryDate.day != null) {
                                  int index = controller.bookingModel.theoryDate
                                      .indexOf(e);
                                  controller.bookingModel.theoryDate[index] =
                                      selectedTheoryDate;
                                  print(controller.bookingModel.theoryDate);
                                  controller.update();
                                  Get.back();
                                } else {
                                  showToast("Select Time");
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  radius: 10,
                );
              },
              onDelete: () {
                controller.bookingModel.theoryDate.remove(e);
                controller.update();
              },
            ),
          )
          .toList();
    } else if (type == DateType.Pool) {
      title = "Pool";
      dates = controller.bookingModel.poolDate
          .map(
            (e) => buildDateButton(
              date: e,
              onEdit: () {
                DateTime selectedPoolDate = e;
                Get.defaultDialog(
                  title: "",
                  titlePadding: EdgeInsets.all(0),
                  titleStyle: TextStyle(fontSize: 0, height: 0),
                  content: Container(
                    height: 480,
                    width: 400,
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: Text(
                            "Choose Date",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        BookingsCalenderWidget(
                          highlightInvalidTime: true,
                          startDate: DateTime.now(),
                          calenderType: FilterType.Pool,
                          onDateTimeSelected: (date) {
                            selectedPoolDate = date;
                          },
                          isDiveSession: false,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            AppButton.miniText(
                              text: "Cancel",
                              onTap: () {
                                Get.back();
                              },
                            ),
                            AppButton.miniFlat(
                              text: "Okay",
                              bgColor: AppColors.background.black,
                              textColor: AppColors.text.white,
                              onTap: () {
                                if (selectedPoolDate != null &&
                                    selectedPoolDate.hour != null &&
                                    selectedPoolDate.minute != null &&
                                    selectedPoolDate.day != null) {
                                  int index = controller.bookingModel.poolDate
                                      .indexOf(e);
                                  controller.bookingModel.poolDate[index] =
                                      selectedPoolDate;
                                  print(controller.bookingModel.poolDate);
                                  controller.update();
                                  Get.back();
                                } else {
                                  showToast("Select Time");
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  radius: 10,
                );
              },
              onDelete: () {
                controller.bookingModel.poolDate.remove(e);
                controller.update();
              },
            ),
          )
          .toList();
    } else if (type == DateType.Dive) {
      title = "Dive";
      dates = controller.bookingModel.diveDate
          .map(
            (e) => buildDateButton(
              date: e,
              onEdit: () {
                DateTime selectedDiveDate = e;
                Get.defaultDialog(
                  title: "",
                  titlePadding: EdgeInsets.all(0),
                  titleStyle: TextStyle(fontSize: 0, height: 0),
                  content: Container(
                    height: 480,
                    width: 400,
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: Text(
                            "Choose Date",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        BookingsCalenderWidget(
                          highlightInvalidTime: true,
                          startDate: DateTime.now(),
                          calenderType: FilterType.Dive,
                          onDateTimeSelected: (date) {
                            selectedDiveDate = date;
                          },
                          isDiveSession: false,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            AppButton.miniText(
                              text: "Cancel",
                              onTap: () {
                                Get.back();
                              },
                            ),
                            AppButton.miniFlat(
                              text: "Okay",
                              bgColor: AppColors.background.black,
                              textColor: AppColors.text.white,
                              onTap: () {
                                if (selectedDiveDate != null &&
                                    selectedDiveDate.hour != null &&
                                    selectedDiveDate.minute != null &&
                                    selectedDiveDate.day != null) {
                                  int index = controller.bookingModel.diveDate
                                      .indexOf(e);
                                  controller.bookingModel.diveDate[index] =
                                      selectedDiveDate;
                                  print(controller.bookingModel.diveDate);
                                  controller.update();
                                  Get.back();
                                } else {
                                  showToast("Select Time");
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  radius: 10,
                );
              },
              onDelete: () {
                controller.bookingModel.diveDate.remove(e);
                controller.update();
              },
            ),
          )
          .toList();
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            AppButton.miniFlat(
              text: "ADD",
              onTap: () {
                DateTime selectedDate;
                Get.defaultDialog(
                  title: "",
                  titlePadding: EdgeInsets.all(0),
                  titleStyle: TextStyle(fontSize: 0, height: 0),
                  content: Container(
                    height: 480,
                    width: 400,
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: Text(
                            "Choose Date",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        BookingsCalenderWidget(
                          highlightInvalidTime: true,
                          startDate: DateTime.now(),
                          calenderType: FilterType.Pool,
                          onDateTimeSelected: (date) {
                            selectedDate = date;
                          },
                          isDiveSession: false,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            AppButton.miniText(
                              text: "Cancel",
                              onTap: () {
                                Get.back();
                              },
                            ),
                            AppButton.miniFlat(
                              text: "Okay",
                              bgColor: AppColors.background.black,
                              textColor: AppColors.text.white,
                              onTap: () {
                                if (selectedDate != null &&
                                    selectedDate.hour != null &&
                                    selectedDate.minute != null &&
                                    selectedDate.day != null) {
                                  if (type == DateType.Theory)
                                    controller.bookingModel.theoryDate
                                        .add(selectedDate);
                                  else if (type == DateType.Pool)
                                    controller.bookingModel.poolDate
                                        .add(selectedDate);
                                  else if (type == DateType.Dive)
                                    controller.bookingModel.diveDate
                                        .add(selectedDate);

                                  controller.bookingModel.bookingDate.add(getStringDate(selectedDate));


                                  controller.update();
                                  Get.back();
                                } else {
                                  showToast("Select Time");
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  radius: 10,
                );
              },
            ),
          ],
        ),
        ...dates,
      ],
    );
  }

  Widget buildEmailTF(EditBookingDetailsController controller) {
    return buildTextFields(
        text: "Email",
        textEditingController: controller.emailTED,
        keyBoardType: TextInputType.emailAddress,
        focus: controller.emailNode,
        nextFocus: controller.phoneNode);
  }

  Widget buildRemarksTF(EditBookingDetailsController controller) {
    return buildTextFields(
        text: "Remarks",
        textEditingController: controller.remarksTED,
        focus: controller.remarksNode,
        nextFocus: controller.emailNode);
  }

  Widget buildDepositTF(EditBookingDetailsController controller) {
    return buildTextFields(
      text: "Deposit",
      textEditingController: controller.depositTED,
      keyBoardType: TextInputType.number,
      onChanged: () {
        logic.getPrice();
      },
      onChangedCallBack: (payingNow) {
        try {
          controller.bookingModel.payingNow =
              double.parse(controller.depositTED.text);
        } catch (e) {
          controller.bookingModel.payingNow = 0;
        }
      },
      focus: controller.depositNode,
      nextFocus: controller.balanceNode,
    );
  }

  Widget buildPAXTF(EditBookingDetailsController controller) {
    return buildTextFields(
        text: "PAX",
        textEditingController: controller.paxTED,
        keyBoardType: TextInputType.number,
        // onChanged: () {
        //   try {
        //     logic.getPrice();
        //     controller.update();
        //   } catch (e) {
        //     print("error");
        //     print(e);
        //   }
        // },
        onChangedCallBack: (pax) {
          try {
            controller.bookingModel.noOfPersons = int.parse(pax);
          } catch (e) {
            controller.bookingModel.noOfPersons = 1;
          }
          print(controller.bookingModel.totalCost);
          // print(controller.bookingModel.noOfPersons);
          controller.update();
        },
        focus: controller.paxNode,
        nextFocus: controller.discountNode);
  }

  Widget buildPriceTF(EditBookingDetailsController controller) {
    return buildTextFields(
        text: "Price",
        textEditingController: controller.priceTED,
        keyBoardType: TextInputType.number,
        // onChanged: () {
        //   try {
        //     logic.getPrice();
        //   } catch (e) {
        //     print("error");
        //     print(e);
        //   }
        // },
        onChangedCallBack: (price) {
          try {
            controller.bookingModel.price = double.parse(price);
          } catch (e) {
            controller.bookingModel.price = 0;
          }
        },
        focus: controller.priceNode,
        nextFocus: controller.paxNode);
  }

  Widget buildDiscount() {
    return Container(
      width: 320,
      child: GetBuilder<EditBookingDetailsController>(builder: (controller) {
        return Row(
          children: [
            Expanded(
              child: Container(
                child: AppTextField(
                  hintText: "Discount",
                  controller: logic.controller.discountTED,
                  focusNode: logic.controller.discountNode,
                  nextFocusNode: logic.controller.totalAmountNode,
                  onChanged: logic.getPrice,
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
                        controller.discountSwitch = value;
                        logic.getPrice();
                        controller.bookingModel.discount =
                            double.parse(controller.discountTED.text);
                        controller.bookingModel.discountType =
                            controller.discountSwitch ? "%" : "₹";
                        print("VALUE : ${controller.discountSwitch}");
                        controller.update();
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

  Widget buildTitle() {
    return GetBuilder<EditBookingDetailsController>(builder: (controller) {
      return Text(
        'Edit Booking',
        style: TextStyle(
          color: AppColors.text.black,
          fontSize: 20,
          fontFamily: AppFonts.nunito,
          fontWeight: FontWeight.normal,
          letterSpacing: 1.0,
        ),
      );
    });
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

  Widget buildTax() {
    return Container(
      width: 320,
      child: GetBuilder<EditBookingDetailsController>(builder: (controller) {
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
                    controller.bookingModel.tax = value ? 18 : 0;
                    controller.taxable = value;
                    logic.getPrice();
                  }),
            ),
          ],
        );
      }),
    );
  }

  Widget buildShowLoading() {
    return GetBuilder<EditBookingDetailsController>(builder: (controller) {
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

  Widget buildActivityDropDown() {
    return Container(
      width: 320,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 12, top: 12),
              child: Container(
                width: Get.width,
                alignment: Alignment.centerLeft,
                child: buildSubTitle(text: "Activities"),
              ),
            ),
          ),
          Container(
            width: 215,
            child:
                GetBuilder<EditBookingDetailsController>(builder: (controller) {
              if (!controller.showLoading)
                return Padding(
                  padding: const EdgeInsets.only(left: 13),
                  child: DropdownButton(
                    // focusNode: controller.locationNode,
                    underline: Container(height: 1, color: Colors.black45),
                    isExpanded: true,
                    value: controller.bookingModel.activity[0],
                    onChanged: (activity) {
                      print(activity.name);
                      controller.bookingModel.activity[0] = activity;
                      controller.priceTED.text = activity.price.toString();
                      logic.getPrice();
                      print(controller.bookingModel.activity[0].name);
                      controller.bookingModel.price = activity.price * 1.0;
                      print(controller.bookingModel.balance);
                      controller.update();
                    },
                    items:
                        controller.activities.toSet().toList().map((activity) {
                      return DropdownMenuItem(
                        child: new Text(
                          activity.name,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        value: activity,
                      );
                    }).toList(),
                  ),
                );
              else
                return SizedBox();
            }),
          ),
        ],
      ),
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

  Widget buildDateButton({
    DateTime date,
    Function onEdit,
    Function onDelete,
    String text = "Change",
  }) {
    return GetBuilder<EditBookingDetailsController>(builder: (controller) {
      return Row(
        children: [
          Text(getStringFromDate(date)),
          Spacer(),
          IconButton(
              splashRadius: 20,
              onPressed: () {
                onEdit();
              },
              icon: Icon(
                Icons.edit,
                size: 15,
              )),
          IconButton(
              splashRadius: 20,
              onPressed: () {
                onDelete();
              },
              icon: Icon(
                Icons.delete,
                size: 15,
              )),
          // AppButton.miniFlat(
          //   text: text,
          //   onTap: onEdit,
          // ),
        ],
      );
    });
  }

  getStringFromDate(DateTime dateT) {
    if (dateT != null) {
      final DateFormat formatter = DateFormat('hh:mm a');
      String time;
      final DateFormat format = DateFormat('dd-MM-yyyy');
      String date;
      time = formatter.format(dateT);
      date = format.format(dateT);
      return "$date @ $time";
    } else
      return "                 --                 ";
  }

  Widget buildPhoneNumber() {
    return GetBuilder<EditBookingDetailsController>(builder: (controller) {
      return IntlPhoneField(
        autoValidate: true,
        initialCountryCode: controller.isoCode,
        showCountryFlag: false,
        initialValue: controller.phoneTED.text,
        decoration: InputDecoration(
          labelText: "Phone Number",
          labelStyle: TextStyle(
            fontSize: FontSize.small,
            fontFamily: AppFonts.nunito,
          ),
        ),
        style: TextStyle(
            fontFamily: AppFonts.nunito,
            fontWeight: FontWeight.normal,
            fontSize: 14),
        searchText: "Search",
        onSubmitted: (_) {},
        onChanged: (phone) {
          controller.phoneTED.text = phone.number;
          controller.countryCodeTED.text = phone.countryCode;
          controller.isoCode = phone.countryISOCode;
          print(phone.number);
          print(phone.countryCode);
          print(phone.countryISOCode);
          print(controller.isoCode);
          // print(controller.isoCode);
        },
      );
    });
  }

  Widget buildButtons() {
    return GetBuilder<EditBookingDetailsController>(builder: (controller) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          AppButton.flat(
            height: 45,
            width: 140,
            color: AppColors.background.grey,
            text: "Cancel",
            textColor: AppColors.text.black,
            onTap: () {
              disposeKeyboard();
              Get.back();
              controller.reset();
            },
          ),
          AppButton.flat(
              height: 45,
              width: 140,
              color: AppColors.background.black,
              text: "Update",
              textColor: AppColors.text.white,
              onTap: () async {
                print(controller.discount);
                print(controller.taxableAmount);
                controller.bookingModel.bookingDate = [];
                if (controller.bookingModel.poolDate != null) {
                  controller.bookingModel.bookingDate
                      .add(getStringDate(controller.bookingModel.poolDate[0]));
                }
                if (controller.bookingModel.theoryDate != null) {
                  controller.bookingModel.bookingDate.add(
                      getStringDate(controller.bookingModel.theoryDate[0]));
                }
                if (controller.bookingModel.diveDate != null) {
                  controller.bookingModel.bookingDate
                      .add(getStringDate(controller.bookingModel.diveDate[0]));
                }
                controller.bookingModel.tax = controller.taxableAmount;
                controller.bookingModel.discount = controller.discount;
                controller.bookingModel.discountType =
                    controller.discountSwitch ? "%" : "₹";
                controller.bookingModel.price =
                    double.parse(controller.priceTED.text);
                controller.bookingModel.payingNow =
                    double.parse(controller.depositTED.text);
                controller.bookingModel.noOfPersons =
                    int.parse(controller.paxTED.text);
                controller.bookingModel.remarks = controller.remarksTED.text;
                controller.bookingModel.pax[0]["phoneNumber"] =
                    controller.phoneTED.text;
                controller.bookingModel.pax[0]["countryCode"] =
                    controller.countryCodeTED.text;
                controller.bookingModel.pax[0]["email"] =
                    controller.emailTED.text;
                controller.bookingModel.pax[0]["isoCode"] = controller.isoCode;
                await FirebaseFirestore.instance
                    .collection("bookings")
                    .doc(controller.bookingModel.id)
                    .set(controller.bookingModel.toMap());
                Get.back();
                controller.reset();
                BookingsCalenderWidgetLogic bookingCalenderLogic =
                    BookingsCalenderWidgetLogic();
                bookingCalenderLogic.onDateSelected(
                    bookingCalenderLogic.controller.lastDateIndex);
                // controller.update();
              }),
        ],
      );
    });
  }

  Widget buildTextFields({
    String text,
    TextEditingController textEditingController,
    TextInputType keyBoardType,
    FocusNode focus,
    FocusNode nextFocus,
    Function onChanged,
    Function(String) onChangedCallBack,
  }) {
    return Container(
      child: AppTextField(
        hintText: text,
        controller: textEditingController,
        keyboardType: keyBoardType,
        focusNode: focus,
        nextFocusNode: nextFocus,
        onChanged: onChanged,
        onChangedCallBack: (_) {
          onChangedCallBack(_);
        },
        errorValidator: () {
          return null;
        },
        validator: (_) {
          return null;
        },
      ),
    );
  }
}
