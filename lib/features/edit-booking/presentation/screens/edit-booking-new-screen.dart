import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/util/app-func.dart';
import 'package:temple_adventures/core/widgets/app-button.dart';
import 'package:temple_adventures/core/widgets/back-navigation-icon.dart';
import 'package:temple_adventures/core/widgets/bookings_calender_widget/bookings_calender_widget.dart';
import 'package:temple_adventures/core/widgets/bookings_calender_widget/bookings_calender_widget_controller.dart';
import 'package:temple_adventures/core/widgets/phone_number/intl_phone_field.dart';
import 'package:temple_adventures/features/bookings/models/booking-model.dart';
import 'package:temple_adventures/features/bookings/presentation/screens/book-date-time-screen.dart';
import 'package:temple_adventures/features/bookings/presentation/widgets/app-text-fields.dart';
import 'package:temple_adventures/features/edit-booking/controller/edit-booking-new-controller.dart';
import 'package:temple_adventures/features/logs/models/log-model.dart';
import 'package:temple_adventures/features/logs/presentation/screens/log-screen.dart';

class EditBookingNewScreen extends StatelessWidget {
  static const String id = "EditBookingNewScreen";
  EditBookingNewLogic logic = EditBookingNewLogic();
  final BookingModel bookingArg = Get.arguments;
  final AutoScrollController autoScrollControllerTheory =
      AutoScrollController();
  final AutoScrollController autoScrollControllerPool = AutoScrollController();
  final AutoScrollController autoScrollControllerDive = AutoScrollController();

  EditBookingNewScreen() {
    logic.controller.bookingModel = bookingArg;
    logic.controller.activityNAmeTED.text =
        bookingArg.activity[0].name.toString();
    logic.controller.discountTED.text = (bookingArg.discount).toString();
    logic.controller.totalAmountTED.text = (bookingArg.totalCost).toString();
    logic.controller.priceTED.text = bookingArg.price.toString();
    logic.controller.depositTED.text = bookingArg.paid.toString();
    logic.controller.balanceTED.text = bookingArg.balance.toString();
    logic.controller.paxTED.text = bookingArg.noOfPersons.toString();
    logic.controller.remarksTED.text = bookingArg.remarks;
    logic.controller.invoiceTED.text = bookingArg.receiptNo;
    logic.controller.countryCodeTED.text = bookingArg.pax[0]["countryCode"];
    logic.controller.phoneTED.text = bookingArg.pax[0]["phoneNumber"];
    logic.controller.emailTED.text = bookingArg.pax[0]["email"];
    logic.controller.firstNameTED.text = bookingArg.pax[0]["first-name"];
    logic.controller.lastNameTED.text = bookingArg.pax[0]["last-name"];
    logic.controller.isoCode = bookingArg.pax[0]["isoCode"];
    // logic.controller.taxableAmount = bookingArg.tax;
    // logic.controller.discount = bookingArg.discount;
    logic.controller.discountTED.text = bookingArg.discount.toString();
    // logic.controller.totalCost = bookingArg.totalCost;
    // logic.controller.cost = bookingArg.price;
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
        child: WillPopScope(
          onWillPop: () async {
            logic.controller.reset();
            logic.controller.startDate =
                logic.controller.startDate.subtract(Duration(days: 50));
            return true;
          },
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: Center(
                    child: GetBuilder<EditBookingNewController>(
                      builder: (controller) {
                        return Column(
                          children: [
                            buildBookingID(),
                            SizedBox(height: 20),
                            buildActivityDropDown(),
                            buildPriceTF(controller),
                            buildNameFields(controller),
                            buildPAXTF(controller),
                            buildDiscount(),
                            buildTax(),
                            buildDepositTF(controller),
                            SizedBox(height: 25),
                            buildTotalAmount(),
                            SizedBox(height: 25),
                            buildBalanceAmount(),
                            buildReceiptNo(controller),
                            buildRemarksTF(controller),
                            buildEmailTF(controller),
                            SizedBox(height: 10),
                            buildPhoneNumber(),
                            SizedBox(height: 50),
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
                          ],
                        );
                      },
                    ),
                  ),
                ),
                buildButtons(),
                SizedBox(height: 50)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildButtons() {
    return GetBuilder<EditBookingNewController>(builder: (controller) {
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
                controller.bookingModel.bookingDate = [];

                if (controller.bookingModel.poolDate != null &&
                    controller.bookingModel.poolDate.isNotEmpty) {
                  controller.bookingModel.poolDate.forEach((date) {
                    controller.bookingModel.bookingDate
                        .add(getStringDate(date));
                  });
                }
                if (controller.bookingModel.theoryDate != null &&
                    controller.bookingModel.theoryDate.isNotEmpty) {
                  controller.bookingModel.theoryDate.forEach((date) {
                    controller.bookingModel.bookingDate
                        .add(getStringDate(date));
                  });
                }
                if (controller.bookingModel.diveDate != null &&
                    controller.bookingModel.diveDate.isNotEmpty) {
                  controller.bookingModel.diveDate.forEach((date) {
                    controller.bookingModel.bookingDate
                        .add(getStringDate(date));
                  });
                }
                await FirebaseFirestore.instance
                    .collection("bookings")
                    .doc(controller.bookingModel.id)
                    .set(controller.bookingModel.toMap());
                LogModel logModel = LogModel(
                    type: LogType.bookingEdited,
                    bookingId: controller.bookingModel.id);
                FirebaseFirestore.instance
                    .collection("logs")
                    .doc()
                    .set(logModel.toMap());
                Get.back();
                controller.reset();
                BookingsCalenderWidgetLogic bookingCalenderLogic =
                    BookingsCalenderWidgetLogic();
                bookingCalenderLogic.onDateSelected(
                    bookingCalenderLogic.controller.lastDateIndex);
              }),
        ],
      );
    });
  }

  Widget buildEditSessions(EditBookingNewController controller,
      {@required DateType type}) {
    String title = "";
    List<Widget> dates = [];
    FilterType filterType;
    AutoScrollController scrollController;
    if (type == DateType.Theory) {
      title = "Theory";
      filterType = FilterType.Theory;
      scrollController = autoScrollControllerTheory;
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
                          autoScrollController: autoScrollControllerTheory,
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
    }
    if (type == DateType.Pool) {
      title = "Pool";
      filterType = FilterType.Pool;
      scrollController = autoScrollControllerPool;
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
                          autoScrollController: scrollController,
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
    }
    if (type == DateType.Dive) {
      title = "Dive";
      filterType = FilterType.Dive;
      scrollController = autoScrollControllerDive;
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
                          autoScrollController: scrollController,
                          startDate: DateTime.now(),
                          calenderType: FilterType.Dive,
                          onDateTimeSelected: (date) {
                            selectedDiveDate = date;
                          },
                          isDiveSession: true,
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
                          autoScrollController: scrollController,
                          highlightInvalidTime: true,
                          startDate: DateTime.now(),
                          calenderType: filterType,
                          onDateTimeSelected: (date) {
                            selectedDate = date;
                          },
                          isDiveSession: filterType == FilterType.Dive,
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

                                  controller.bookingModel.bookingDate
                                      .add(getStringDate(selectedDate));

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

  Widget buildDateButton({
    DateTime date,
    Function onEdit,
    Function onDelete,
    String text = "Change",
  }) {
    return GetBuilder<EditBookingNewController>(builder: (controller) {
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

  Widget buildActivityDropDown() {
    return Container(
      width: Get.width,
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
            child: GetBuilder<EditBookingNewController>(builder: (controller) {
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
                      controller.bookingModel.price = activity.price * 1.0;
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

  Widget buildPhoneNumber() {
    return GetBuilder<EditBookingNewController>(builder: (controller) {
      return IntlPhoneField(
        autoValidate: true,
        initialCountryCode: controller.isoCode,
        showCountryFlag: false,
        focusNode: controller.phoneNode,
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
          controller.bookingModel.pax[0]["isoCode"] = phone.countryISOCode;
          controller.bookingModel.pax[0]["phoneNumber"] = phone.number;
          controller.bookingModel.pax[0]["countryCode"] = phone.countryCode;
        },
      );
    });
  }

  Widget buildEmailTF(EditBookingNewController controller) {
    return buildTextFields(
      text: "Email",
      textEditingController: controller.emailTED,
      keyBoardType: TextInputType.emailAddress,
      focus: controller.emailNode,
      nextFocus: controller.phoneNode,
      onChangedCallBack: (email) {
        controller.bookingModel.pax[0]["email"] = email;
      },
    );
  }

  Widget buildRemarksTF(EditBookingNewController controller) {
    return buildTextFields(
      text: "Remarks",
      textEditingController: controller.remarksTED,
      focus: controller.remarksNode,
      nextFocus: controller.emailNode,
      onChangedCallBack: (email) {
        controller.bookingModel.remarks = email;
      },
    );
  }

  Widget buildReceiptNo(EditBookingNewController controller) {
    return buildTextFields(
        text: "Invoice No",
        textEditingController: controller.invoiceTED,
        focus: controller.invoiceNoNode,
        nextFocus: controller.remarksNode,
        onChangedCallBack: (invoice) {
          controller.bookingModel.receiptNo = invoice;
        });
  }

  Widget buildDepositTF(EditBookingNewController controller) {
    return buildTextFields(
      text: "Deposit",
      textEditingController: controller.depositTED,
      keyBoardType: TextInputType.number,
      onChangedCallBack: (payingNow) {
        controller.bookingModel.paid = getInt(payingNow) * 1.0;
        controller.update();
      },
      focus: controller.depositNode,
      nextFocus: controller.invoiceNoNode,
    );
  }

  Widget buildBalanceAmount() {
    return GetBuilder<EditBookingNewController>(builder: (controller) {
      return Container(
        width: 320,
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Text(
                  "Balance" + "   :",
                  style: TextStyle(
                      fontSize: FontSize.small, color: AppColors.text.darkgrey),
                ),
              ),
            ),
            Container(
              child: Text(
                controller.bookingModel.balance.toString() + "/-",
                style: TextStyle(
                    fontSize: FontSize.textSize, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget buildTotalAmount() {
    return GetBuilder<EditBookingNewController>(builder: (controller) {
      return Container(
        width: Get.width,
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Text(
                  "TotalCost" + "   :",
                  style: TextStyle(
                      fontSize: FontSize.small, color: AppColors.text.darkgrey),
                ),
              ),
            ),
            Container(
              child: Text(
                controller.bookingModel.totalCost.toString() + "/-",
                style: TextStyle(
                    fontSize: FontSize.textSize, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget buildDiscount() {
    return Container(
      width: Get.width,
      child: GetBuilder<EditBookingNewController>(builder: (controller) {
        return Row(
          children: [
            Expanded(
              child: Container(
                child: AppTextField(
                  hintText: "Discount",
                  controller: logic.controller.discountTED,
                  focusNode: logic.controller.discountNode,
                  nextFocusNode: logic.controller.totalAmountNode,
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
                  },
                ),
              ),
            ),
            SizedBox(width: 30),
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

  Widget buildBookingID() {
    return GetBuilder<EditBookingNewController>(builder: (controller) {
      return Text(
        "Booking ID : ${controller.bookingModel.id}",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      );
    });
  }

  Widget buildTax() {
    return Container(
      width: Get.width,
      child: GetBuilder<EditBookingNewController>(builder: (controller) {
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
                  }),
            ),
          ],
        );
      }),
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

  Widget buildPAXTF(EditBookingNewController controller) {
    return buildTextFields(
        text: "No of Persons",
        textEditingController: controller.paxTED,
        keyBoardType: TextInputType.number,
        focus: controller.paxNode,
        nextFocus: controller.discountNode,
        onChangedCallBack: (newNumber) {
          controller.bookingModel.noOfPersons = getInt(newNumber);
          controller.update();
        });
  }

  Widget buildNameFields(EditBookingNewController controller) {
    return Row(
      children: [
        Expanded(
          child: Container(
            width: Get.width,
            child: buildFirstName(controller),
          ),
        ),
        SizedBox(width: 20),
        Container(
          width: (Get.width / 2.5),
          child: buildLastName(controller),
        ),
      ],
    );
  }

  Widget buildFirstName(EditBookingNewController controller) {
    return buildTextFields(
        text: "First Name",
        textEditingController: controller.firstNameTED,
        focus: controller.firstNameNode,
        nextFocus: controller.lastNameNode,
        onChangedCallBack: (newName) {
          controller.bookingModel.pax[0]["first-name"] = newName;
        });
  }

  Widget buildLastName(EditBookingNewController controller) {
    return buildTextFields(
        text: "Last Name",
        textEditingController: controller.lastNameTED,
        focus: controller.lastNameNode,
        nextFocus: controller.paxNode,
        onChangedCallBack: (newName) {
          controller.bookingModel.pax[0]["last-name"] = newName;
        });
  }

  Widget buildTitle() {
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

  Widget buildPriceTF(EditBookingNewController controller) {
    return buildTextFields(
      text: "Price",
      textEditingController: controller.priceTED,
      keyBoardType: TextInputType.number,
      focus: controller.priceNode,
      nextFocus: controller.firstNameNode,
      onChangedCallBack: (newPrice) {
        controller.bookingModel.price = getInt(newPrice) * 1.0;
        controller.update();
      },
    );
  }

  Widget buildTextFields({
    String text,
    TextEditingController textEditingController,
    TextInputType keyBoardType,
    FocusNode focus,
    FocusNode nextFocus,
    Function(String) onChangedCallBack,
  }) {
    return Container(
      child: AppTextField(
        width: Get.width,
        hintText: text,
        controller: textEditingController,
        keyboardType: keyBoardType,
        focusNode: focus,
        nextFocusNode: nextFocus,
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
