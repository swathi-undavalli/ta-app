import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:temple_ui_tools/utils/utils.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/constants/enums.dart';
import '../../../../core/util/utils.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/booking_calender_widget_old/booking_calender_old.dart';
import '../../../../core/widgets/bookings_calender_widget/bookings_calender_widget_controller_new.dart';
import '../../../../core/widgets/phone_number/intl_phone_field.dart';
import '../../../logs/models/log_model.dart';
import '../../../logs/presentation/views/log_view.dart';
import '../../controller/edit_booking_new_controller.dart';
import '../../models/booking_model.dart';
import '../widgets/app_text_fields.dart';
import 'book_date_time_view.dart';

class EditBookingView extends StatefulWidget {
  final Booking? booking;

  const EditBookingView({super.key, required this.booking});

  static Route route(Booking booking) => MaterialPageRoute(
        builder: (context) => EditBookingView(
          booking: booking,
        ),
      );

  @override
  State<EditBookingView> createState() => _EditBookingViewState();
}

class _EditBookingViewState extends State<EditBookingView> {
  final EditBookingNewLogic logic = EditBookingNewLogic();

  final AutoScrollController autoScrollControllerTheory = AutoScrollController();

  final AutoScrollController autoScrollControllerPool = AutoScrollController();

  final AutoScrollController autoScrollControllerDive = AutoScrollController();

  @override
  void initState() {
    super.initState();
    logic.controller.bookingModel = widget.booking;
    logic.controller.activityNAmeTED.text = widget.booking!.activity![0]!.name.toString();
    logic.controller.totalAmountTED.text = ((widget.booking!.totalCost).round()).toString();
    logic.controller.priceTED.text = widget.booking!.price.toString();
    logic.controller.depositTED.text = widget.booking!.paid.toString();
    logic.controller.balanceTED.text = widget.booking!.balance.toString();
    logic.controller.paxTED.text = widget.booking!.noOfPersons.toString();
    logic.controller.remarksTED.text = widget.booking!.remarks ?? '';
    logic.controller.invoiceTED.text = widget.booking!.receiptNo ?? '';
    logic.controller.countryCodeTED.text = widget.booking!.pax![0]['countryCode'] ?? '';
    logic.controller.phoneTED.text = widget.booking!.pax![0]['phoneNumber'] ?? '';
    logic.controller.emailTED.text = widget.booking!.pax![0]['email'] ?? '';
    logic.controller.firstNameTED.text = widget.booking!.pax![0]['first-name'];
    logic.controller.lastNameTED.text = widget.booking!.pax![0]['last-name'] ?? '';
    logic.controller.isoCode = widget.booking!.pax![0]['isoCode'] ?? '';
    logic.controller.discountTED.text = widget.booking!.discount?.toString() ?? '0';
    logic.controller.taxable = widget.booking!.tax != 0;
    logic.controller.discountSwitch = widget.booking!.discountType == '%';

    if (widget.booking!.pax![0]['dob'] != null) {
      try {
        logic.controller.dob = (widget.booking!.pax![0]['dob'] as Timestamp).toDate();
      } catch (e) {
        showToast(widget.booking!.id!);
        logic.controller.dob = DateTime.now();
      }
      logic.controller.dobTED.text = DateFormat('dd MMM, yyyy').format(logic.controller.dob);
      log('Hey Dob');
      log(logic.controller.dob.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background.lightBlue,
      appBar: const AppBarWidget(heading: 'Edit Booking'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: WillPopScope(
          onWillPop: () async {
            logic.controller.reset();
            logic.controller.startDate = logic.controller.startDate.subtract(const Duration(days: 50));
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
                            const SizedBox(height: 20),
                            buildActivityDropDown(),
                            buildPriceTF(controller),
                            buildNameFields(controller),
                            buildDOB(context),
                            buildPAXTF(controller),
                            buildDiscount(),
                            buildTax(),
                            buildDepositTF(controller),
                            const SizedBox(height: 25),
                            buildTotalAmount(),
                            const SizedBox(height: 25),
                            buildReceiptNo(controller),
                            buildRemarksTF(controller),
                            buildEmailTF(controller),
                            const SizedBox(height: 10),
                            buildPhoneNumber(),
                            const SizedBox(height: 50),
                            buildEditSessions(
                              context,
                              controller,
                              type: DateType.theory,
                            ),
                            const SizedBox(height: 30),
                            buildEditSessions(
                              context,
                              controller,
                              type: DateType.pool,
                            ),
                            const SizedBox(height: 30),
                            buildEditSessions(
                              context,
                              controller,
                              type: DateType.dive,
                            ),
                            const SizedBox(height: 100),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                buildButtons(context),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///=====================UI==================///

  Widget buildDOB(BuildContext context) {
    return GetBuilder<EditBookingNewController>(
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
              nextFocusNode: logic.controller.paxNode,
              keyboardType: TextInputType.number,
              required: false,
              onChangedCallBack: (date) {
                // controller.bookingModel.pax[0]["dob"] = date;
                // log(controller.bookingModel.pax[0]["dob"].toString());
                // controller.update();
              },
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

  Widget buildButtons(BuildContext context) {
    return GetBuilder<EditBookingNewController>(
      builder: (controller) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            AppButton.flat(
              height: 45,
              width: 140,
              color: AppColors.background.grey,
              text: 'Cancel',
              textColor: AppColors.text.black,
              onTap: () {
                disposeKeyboard();
                Navigator.pop(context);
                controller.reset();
              },
            ),
            AppButton.flat(
              height: 45,
              width: 140,
              color: AppColors.background.black,
              text: 'Update',
              textColor: AppColors.text.white,
              onTap: () async {
                controller.bookingModel!.bookingDate = [];

                if (controller.bookingModel!.poolDate != null && controller.bookingModel!.poolDate!.isNotEmpty) {
                  for (var date in controller.bookingModel!.poolDate!) {
                    controller.bookingModel!.bookingDate!.add(getStringDate(date!));
                  }
                }
                if (controller.bookingModel!.theoryDate != null && controller.bookingModel!.theoryDate!.isNotEmpty) {
                  for (var date in controller.bookingModel!.theoryDate!) {
                    controller.bookingModel!.bookingDate!.add(getStringDate(date!));
                  }
                }
                if (controller.bookingModel!.diveDate != null && controller.bookingModel!.diveDate!.isNotEmpty) {
                  for (var date in controller.bookingModel!.diveDate!) {
                    controller.bookingModel!.bookingDate!.add(getStringDate(date!));
                  }
                }

                await FirebaseFirestore.instance
                    .collection('bookings')
                    .doc(controller.bookingModel!.id)
                    .set(controller.bookingModel!.toMap());

                LogModel logModel = LogModel(
                  type: LogType.bookingEdited,
                  bookingId: controller.bookingModel!.id,
                );
                FirebaseFirestore.instance.collection('logs').doc().set(logModel.toMap());
                if (context.mounted) {
                  Navigator.pop(context);
                }
                controller.reset();

                BookingsCalenderWidgetLogicNew bookingCalenderLogicNew = BookingsCalenderWidgetLogicNew();
                bookingCalenderLogicNew.onDateSelected(bookingCalenderLogicNew.controller.selectedDate);
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildEditSessions(
    BuildContext context,
    EditBookingNewController controller, {
    required DateType type,
  }) {
    String title = '';
    List<Widget> dates = [];
    FilterType? filterType;
    AutoScrollController? scrollController;
    if (type == DateType.theory) {
      title = 'Theory';
      filterType = FilterType.Theory;
      scrollController = autoScrollControllerTheory;
      dates = controller.bookingModel!.theoryDate!
          .map(
            (e) => buildDateButton(
              date: e,
              onEdit: () {
                DateTime? selectedTheoryDate = e;
                Get.defaultDialog(
                  title: '',
                  titlePadding: const EdgeInsets.all(0),
                  titleStyle: const TextStyle(fontSize: 0, height: 0),
                  content: SizedBox(
                    height: 480,
                    width: 400,
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 20,
                          ),
                          child: const Text(
                            'Choose Date',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        BookingsCalenderWidgetOld(
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
                              text: 'Cancel',
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                            AppButton.miniFlat(
                              text: 'Okay',
                              bgColor: AppColors.background.black,
                              textColor: AppColors.text.white,
                              onTap: () {
                                if (selectedTheoryDate != null &&
                                    selectedTheoryDate?.hour != null &&
                                    selectedTheoryDate?.minute != null &&
                                    selectedTheoryDate?.day != null) {
                                  int index = controller.bookingModel!.theoryDate!.indexOf(e);
                                  controller.bookingModel!.theoryDate![index] = selectedTheoryDate;
                                  controller.update();
                                  Navigator.pop(context);
                                } else {
                                  showToast('Select Time');
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
                controller.bookingModel!.theoryDate!.remove(e);
                controller.update();
              },
            ),
          )
          .toList();
    }
    if (type == DateType.pool) {
      title = 'Pool';
      filterType = FilterType.Pool;
      scrollController = autoScrollControllerPool;
      dates = controller.bookingModel!.poolDate!
          .map(
            (e) => buildDateButton(
              date: e,
              onEdit: () {
                DateTime? selectedPoolDate = e;
                Get.defaultDialog(
                  title: '',
                  titlePadding: const EdgeInsets.all(0),
                  titleStyle: const TextStyle(fontSize: 0, height: 0),
                  content: SizedBox(
                    height: 480,
                    width: 400,
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 20,
                          ),
                          child: const Text(
                            'Choose Date',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        BookingsCalenderWidgetOld(
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
                              text: 'Cancel',
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                            AppButton.miniFlat(
                              text: 'Okay',
                              bgColor: AppColors.background.black,
                              textColor: AppColors.text.white,
                              onTap: () {
                                if (selectedPoolDate != null &&
                                    selectedPoolDate?.hour != null &&
                                    selectedPoolDate?.minute != null &&
                                    selectedPoolDate?.day != null) {
                                  int index = controller.bookingModel!.poolDate!.indexOf(e);
                                  controller.bookingModel!.poolDate![index] = selectedPoolDate;
                                  //print(controller.bookingModel.poolDate);
                                  controller.update();
                                  Navigator.pop(context);
                                } else {
                                  showToast('Select Time');
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
                controller.bookingModel!.poolDate!.remove(e);
                controller.update();
              },
            ),
          )
          .toList();
    }
    if (type == DateType.dive) {
      title = 'Dive';
      filterType = FilterType.Dive;
      scrollController = autoScrollControllerDive;
      dates = controller.bookingModel!.diveDate!
          .map(
            (e) => buildDateButton(
              date: e,
              onEdit: () {
                DateTime? selectedDiveDate = e;
                Get.defaultDialog(
                  title: '',
                  titlePadding: const EdgeInsets.all(0),
                  titleStyle: const TextStyle(fontSize: 0, height: 0),
                  content: SizedBox(
                    height: 480,
                    width: 400,
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 20,
                          ),
                          child: const Text(
                            'Choose Date',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        BookingsCalenderWidgetOld(
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
                              text: 'Cancel',
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                            AppButton.miniFlat(
                              text: 'Okay',
                              bgColor: AppColors.background.black,
                              textColor: AppColors.text.white,
                              onTap: () {
                                if (selectedDiveDate != null &&
                                    selectedDiveDate?.hour != null &&
                                    selectedDiveDate?.minute != null &&
                                    selectedDiveDate?.day != null) {
                                  int index = controller.bookingModel!.diveDate!.indexOf(e);
                                  controller.bookingModel!.diveDate![index] = selectedDiveDate;
                                  controller.update();
                                  Navigator.pop(context);
                                } else {
                                  showToast('Select Time');
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
                controller.bookingModel!.diveDate!.remove(e);
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
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            AppButton.miniFlat(
              text: 'ADD',
              onTap: () {
                DateTime? selectedDate;
                Get.defaultDialog(
                  title: '',
                  titlePadding: const EdgeInsets.all(0),
                  titleStyle: const TextStyle(fontSize: 0, height: 0),
                  content: SizedBox(
                    height: 500,
                    width: 400,
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 20,
                          ),
                          child: const Text(
                            'Choose Date',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        BookingsCalenderWidgetOld(
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
                              text: 'Cancel',
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                            AppButton.miniFlat(
                              text: 'Okay',
                              bgColor: AppColors.background.black,
                              textColor: AppColors.text.white,
                              onTap: () {
                                if (selectedDate != null &&
                                    selectedDate?.hour != null &&
                                    selectedDate?.minute != null &&
                                    selectedDate?.day != null) {
                                  if (type == DateType.theory) {
                                    controller.bookingModel!.theoryDate!.add(selectedDate);
                                  } else if (type == DateType.pool) {
                                    controller.bookingModel!.poolDate!.add(selectedDate);
                                  } else if (type == DateType.dive) {
                                    controller.bookingModel!.diveDate!.add(selectedDate);
                                  }

                                  controller.bookingModel!.bookingDate!.add(getStringDate(selectedDate!));

                                  controller.update();
                                  Navigator.pop(context);
                                } else {
                                  showToast('Select Time');
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
    DateTime? date,
    Function? onEdit,
    Function? onDelete,
    String text = 'Change',
  }) {
    return GetBuilder<EditBookingNewController>(
      builder: (controller) {
        return Row(
          children: [
            Text(getStringFromDate(date)),
            const Spacer(),
            IconButton(
              splashRadius: 20,
              onPressed: () {
                onEdit!();
              },
              icon: const Icon(
                Icons.edit,
                size: 15,
              ),
            ),
            IconButton(
              splashRadius: 20,
              onPressed: () {
                onDelete!();
              },
              icon: const Icon(
                Icons.delete,
                size: 15,
              ),
            ),
            // AppButton.miniFlat(
            //   text: text,
            //   onTap: onEdit,
            // ),
          ],
        );
      },
    );
  }

  getStringFromDate(DateTime? dateT) {
    if (dateT != null) {
      final DateFormat formatter = DateFormat('hh:mm a');
      String time;
      final DateFormat format = DateFormat('dd-MM-yyyy');
      String date;
      time = formatter.format(dateT);
      date = format.format(dateT);
      return '$date @ $time';
    } else {
      return '                 --                 ';
    }
  }

  Widget buildActivityDropDown() {
    return SizedBox(
      width: Screen.width,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 12, top: 12),
              child: Container(
                width: Screen.width,
                alignment: Alignment.centerLeft,
                child: buildSubTitle(text: 'Activities'),
              ),
            ),
          ),
          SizedBox(
            width: 215,
            child: GetBuilder<EditBookingNewController>(
              builder: (controller) {
                if (!controller.showLoading) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 13),
                    child: DropdownButton(
                      // focusNode: controller.locationNode,
                      underline: Container(height: 1, color: Colors.black45),
                      isExpanded: true,
                      value: controller.bookingModel!.activity![0],
                      onChanged: (dynamic activity) {
                        //print(activity.name);
                        controller.bookingModel!.activity![0] = activity;
                        controller.priceTED.text = activity.price.toString();
                        controller.bookingModel!.price = activity.price * 1.0;
                        controller.update();
                      },
                      items: controller.activities.toSet().toList().map((activity) {
                        return DropdownMenuItem(
                          value: activity,
                          child: Text(
                            activity.name!,
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPhoneNumber() {
    return GetBuilder<EditBookingNewController>(
      builder: (controller) {
        return IntlPhoneField(
          autoValidate: true,
          initialCountryCode: controller.isoCode,
          showCountryFlag: false,
          focusNode: controller.phoneNode,
          initialValue: controller.phoneTED.text,
          decoration: const InputDecoration(
            labelText: 'Phone Number',
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
            controller.bookingModel!.pax![0]['isoCode'] = phone.countryISOCode;
            controller.bookingModel!.pax![0]['phoneNumber'] = phone.number;
            controller.bookingModel!.pax![0]['countryCode'] = phone.countryCode;
          },
        );
      },
    );
  }

  Widget buildEmailTF(EditBookingNewController controller) {
    return buildTextFields(
      text: 'Email',
      textEditingController: controller.emailTED,
      keyBoardType: TextInputType.emailAddress,
      focus: controller.emailNode,
      nextFocus: controller.phoneNode,
      onChangedCallBack: (email) {
        controller.bookingModel!.pax![0]['email'] = email;
      },
    );
  }

  Widget buildRemarksTF(EditBookingNewController controller) {
    return buildTextFields(
      text: 'Remarks',
      textEditingController: controller.remarksTED,
      focus: controller.remarksNode,
      nextFocus: controller.emailNode,
      onChangedCallBack: (email) {
        controller.bookingModel!.remarks = email;
      },
    );
  }

  Widget buildReceiptNo(EditBookingNewController controller) {
    return buildTextFields(
      text: 'Invoice No',
      textEditingController: controller.invoiceTED,
      focus: controller.invoiceNoNode,
      nextFocus: controller.remarksNode,
      onChangedCallBack: (invoice) {
        controller.bookingModel!.receiptNo = invoice;
      },
    );
  }

  Widget buildDepositTF(EditBookingNewController controller) {
    return buildTextFields(
      text: 'Deposit',
      textEditingController: controller.depositTED,
      keyBoardType: TextInputType.number,
      onChangedCallBack: (payingNow) {
        controller.bookingModel!.paid = getInt(payingNow) * 1.0;
        controller.update();
      },
      focus: controller.depositNode,
      nextFocus: controller.invoiceNoNode,
    );
  }

  Widget buildBalanceAmount() {
    return GetBuilder<EditBookingNewController>(
      builder: (controller) {
        return SizedBox(
          width: 320,
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Text(
                    'Balance' '   :',
                    style: TextStyle(
                      fontSize: FontSize.small,
                      color: AppColors.text.darkgrey,
                    ),
                  ),
                ),
              ),
              Text(
                '${controller.bookingModel!.balance.roundToDouble()}/-',
                style: const TextStyle(
                  fontSize: FontSize.textSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildTotalAmount() {
    return GetBuilder<EditBookingNewController>(
      builder: (controller) {
        return SizedBox(
          width: Screen.width,
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Text(
                    'TotalCost' '   :',
                    style: TextStyle(
                      fontSize: FontSize.small,
                      color: AppColors.text.darkgrey,
                    ),
                  ),
                ),
              ),
              Text(
                '${controller.bookingModel!.totalCost.roundToDouble()}/-',
                style: const TextStyle(
                  fontSize: FontSize.textSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildDiscount() {
    return SizedBox(
      width: Screen.width,
      child: GetBuilder<EditBookingNewController>(
        builder: (controller) {
          return Row(
            children: [
              Expanded(
                child: AppTextField(
                  hintText: 'Discount',
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
                      controller.bookingModel!.discount = double.parse(discount);
                    } catch (e) {
                      controller.bookingModel!.discount = 0;
                    }
                    controller.update();
                  },
                  validator: (firstName) {
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 30),
              Row(
                children: [
                  Text(
                    '₹',
                    style: TextStyle(
                      fontSize: 17,
                      color: !controller.discountSwitch ? AppColors.text.skyBlue : AppColors.text.grey,
                    ),
                  ),
                  SizedBox(
                    width: 70,
                    height: 75,
                    child: buildSwitch(
                      text: '',
                      switchValue: controller.discountSwitch,
                      onChanged: (value) {
                        if (value) {
                          controller.bookingModel!.discountType = '%';
                        } else {
                          controller.bookingModel!.discountType = '₹';
                        }
                        controller.discountSwitch = value;
                      },
                    ),
                  ),
                  Text(
                    '%',
                    style: TextStyle(
                      fontSize: 15,
                      color: controller.discountSwitch ? AppColors.text.skyBlue : AppColors.text.grey,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildBookingID() {
    return GetBuilder<EditBookingNewController>(
      builder: (controller) {
        return Text(
          'Booking ID : ${controller.bookingModel!.id}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        );
      },
    );
  }

  Widget buildTax() {
    return SizedBox(
      width: Screen.width,
      child: GetBuilder<EditBookingNewController>(
        builder: (controller) {
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
                    controller.bookingModel!.tax = value ? 18 : 0;
                    controller.taxable = value;
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildSwitch({
    required String text,
    Function? onChanged,
    required bool switchValue,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: FontSize.small,
              color: AppColors.text.darkgrey,
            ),
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

  Widget buildPAXTF(EditBookingNewController controller) {
    return buildTextFields(
      text: 'No of Persons',
      textEditingController: controller.paxTED,
      keyBoardType: TextInputType.number,
      focus: controller.paxNode,
      nextFocus: controller.discountNode,
      onChangedCallBack: (newNumber) {
        controller.bookingModel!.noOfPersons = getInt(newNumber);
        controller.update();
      },
    );
  }

  Widget buildNameFields(EditBookingNewController controller) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            width: Screen.width,
            child: buildFirstName(controller),
          ),
        ),
        const SizedBox(width: 20),
        SizedBox(
          width: (Screen.width / 2.5),
          child: buildLastName(controller),
        ),
      ],
    );
  }

  Widget buildFirstName(EditBookingNewController controller) {
    return buildTextFields(
      text: 'First Name',
      textEditingController: controller.firstNameTED,
      focus: controller.firstNameNode,
      nextFocus: controller.lastNameNode,
      onChangedCallBack: (newName) {
        controller.bookingModel!.pax![0]['first-name'] = newName;
      },
    );
  }

  Widget buildLastName(EditBookingNewController controller) {
    return buildTextFields(
      text: 'Last Name',
      textEditingController: controller.lastNameTED,
      focus: controller.lastNameNode,
      onChangedCallBack: (newName) {
        controller.bookingModel!.pax![0]['last-name'] = newName;
      },
    );
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

  Widget buildPriceTF(EditBookingNewController controller) {
    return buildTextFields(
      text: 'Price',
      textEditingController: controller.priceTED,
      keyBoardType: TextInputType.number,
      focus: controller.priceNode,
      nextFocus: controller.firstNameNode,
      onChangedCallBack: (newPrice) {
        controller.bookingModel!.price = getInt(newPrice) * 1.0;
        controller.update();
      },
    );
  }

  Widget buildTextFields({
    String? text,
    TextEditingController? textEditingController,
    TextInputType? keyBoardType,
    FocusNode? focus,
    FocusNode? nextFocus,
    Function(String)? onChangedCallBack,
  }) {
    return AppTextField(
      width: Screen.width,
      hintText: text,
      controller: textEditingController,
      keyboardType: keyBoardType,
      focusNode: focus,
      nextFocusNode: nextFocus,
      onChangedCallBack: (_) {
        onChangedCallBack!(_);
      },
      errorValidator: () {
        return null;
      },
      validator: (_) {
        return null;
      },
    );
  }
}
