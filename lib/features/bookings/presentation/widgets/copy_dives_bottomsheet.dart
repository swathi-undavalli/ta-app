import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/util/alignment_extensions.dart';
import '../../../../core/util/spacing_widgets.dart';
import '../../../../core/util/utils.dart';
import '../../../../core/widgets/app_button.dart';
import '../../models/booking_model.dart';
import '../../models/dive_log_model.dart';
import 'app_text_fields.dart';

class CopyDivesBottomSheet extends StatefulWidget {
  const CopyDivesBottomSheet({super.key, required this.bookingModel});

  final Booking bookingModel;

  static void show(BuildContext context, {required Booking booking}) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (BuildContext context) {
        return CopyDivesBottomSheet(bookingModel: booking);
      },
    );
  }

  @override
  State<CopyDivesBottomSheet> createState() => _CopyDivesBottomSheetState();
}

class _CopyDivesBottomSheetState extends State<CopyDivesBottomSheet> {
  DateTimeRange? dateRange;
  DateTime? startDate;
  DateTime? endDate;
  TextEditingController copyFromTED = TextEditingController();
  TextEditingController copyToTED = TextEditingController();
  bool showLoading = false;
  String? copyFromError;
  String? copyToError;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: AppColors.background.lightBlue,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Spacing.h30,
            Spacing.h30,
            buildHeader(),
            Spacing.h30,
            buildDateSelector(),
            Spacing.h20,
            ...buildCustomers(),
            Spacing.h20,
            AppTextField(
              controller: copyFromTED,
              hintText: 'Copy from',
              errorValidator: () {
                return copyFromError;
              },
            ),
            AppTextField(
              controller: copyToTED,
              hintText: 'Copy to',
              errorValidator: () {
                return copyFromError;
              },
            ),
            Spacing.h50,
            if (showLoading)
              const CircularProgressIndicator(
                color: Colors.white,
                backgroundColor: Colors.black,
              ).center
            else
              AppButton.flat(
                onTap: copyLogs,
                text: 'Copy Logs',
                color: Colors.black,
                textColor: Colors.white,
              ).center,
            Spacing.h20,
          ],
        ).paddingSymmetric(horizontal: 20),
      ),
    ).paddingOnly(bottom: MediaQuery.of(context).viewInsets.bottom);
  }

  Widget buildDateSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                width: Get.width,
                child: Text(
                  'Select Dates',
                  style: TextStyle(
                    color: AppColors.text.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 100,
              child: (startDate == null && endDate == null)
                  ? AppButton.miniFlat(
                      onTap: () {
                        showDateRangePickerBottomSheet(context);
                      },
                      text: 'Select',
                    ).center
                  : GestureDetector(
                      onTap: () {
                        showDateRangePickerBottomSheet(context);
                      },
                      child: const Text(
                        'Change',
                        style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue),
                      ),
                    ),
            ),
          ],
        ),
        Spacing.h10,
        if (startDate != null && endDate != null)
          Text(
            "${DateFormat("dd-MM-yyyy").format(startDate!)} - ${DateFormat("dd-MM-yyyy").format(endDate!)}",
            style: const TextStyle(
              fontSize: 13,
            ),
          ),
      ],
    );
  }

  Future showDateRangePickerBottomSheet(BuildContext context) {
    return showDateRangePicker(
      context: context,
      builder: (context, child) {
        return Theme(
          data: ThemeData.from(
            colorScheme: ColorScheme.light(
              primary: AppColors.text.skyBlue,
              secondary: AppColors.text.lightSkyBlue,
            ),
            useMaterial3: true,
          ),
          child: Column(
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 400.0,
                ),
                child: child,
              ),
            ],
          ),
        );
      },
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      currentDate: DateTime.now(),
    ).then((pickedDateRange) async {
      if (pickedDateRange != null) {
        dateRange = pickedDateRange;
        startDate = dateRange!.start;
        endDate = dateRange!.end;
        setState(() {});
      }
    });
  }

  List<Widget> buildCustomers() {
    return List.generate(
      widget.bookingModel.pax!.length,
      (index) => Row(
        children: [
          Text("${widget.bookingModel.pax?[index]['first-name']}"
              " ${widget.bookingModel.pax?[index]['last-name']}"),
          Spacing.w2,
          Expanded(
            child: Text(
              "(${widget.bookingModel.pax?[index]['email']})",
              style: const TextStyle(fontSize: 10),
            ),
          ),
          Spacing.w10,
          IconButton(
            onPressed: () async {
              String email = widget.bookingModel.pax?[index]['email'];
              await Clipboard.setData(ClipboardData(text: email));
            },
            icon: const Icon(
              Icons.copy,
              color: Colors.black,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Copy Dives',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ).paddingOnly(top: 8),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () async {
            Get.back();
          },
        ),
      ],
    );
  }

  Future<void> copyLogs() async {
    FocusScope.of(context).unfocus();

    if (isValid) {
      setState(() {
        showLoading = true;
      });
      List<DiveLogModel> diveLogs = [];

      var data = await FirebaseFirestore.instance
          .collection('customers')
          .doc(copyFromTED.text)
          .collection('diveLogs')
          .where(
            'timeIn',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startDate!.subtract(const Duration(days: 1))),
            isLessThanOrEqualTo: Timestamp.fromDate(endDate!.add(const Duration(days: 1))),
          )
          .get();
      for (var element in data.docs) {
        try {
          Map<String, dynamic> d = element.data();
          diveLogs.add(DiveLogModel.fromMap(d));
        } catch (e) {
          if (kDebugMode) {
            print('Error parsing DiveLogModel ${element.data()}');
          }
        }
      }
      diveLogs.forEach((element) async {
        String id = DateTime.now().microsecondsSinceEpoch.toString();
        await FirebaseFirestore.instance
            .collection('customers')
            .doc(copyToTED.text)
            .collection('diveLogs')
            .doc(id)
            .set(element.copyWith(id: id).toMap());
      });
      setState(() {
        showLoading = false;
      });
      Get.back();
    }
  }

  bool get isValid {
    copyFromError = null;
    copyToError = null;
    bool isValid = true;
    if (copyFromTED.text.isEmpty) {
      copyFromError = 'Required';
      isValid = false;
    }
    if (copyToTED.text.isEmpty) {
      copyToError = 'Required';
      isValid = false;
    }
    if (startDate == null && endDate == null) {
      showToast('Please add start and end dates');
      isValid = false;
    }
    return isValid;
  }
}
