import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/util/alignment_extensions.dart';
import '../../../../core/util/spacing_widgets.dart';
import '../../../../core/util/utils.dart';
import '../../../../core/util/validator.dart';
import '../../../../core/widgets/app_button.dart';
import '../../models/customer_model.dart';
import '../../models/dive-log-model.dart';
import '../widgets/app_text_fields.dart';
import '../widgets/customer_logs_pdf.dart';

class CustomerLogsView extends StatefulWidget {
  const CustomerLogsView({Key? key}) : super(key: key);

  static const String id = 'CustomerLogsView';

  @override
  State<CustomerLogsView> createState() => _CustomerLogsViewState();
}

class _CustomerLogsViewState extends State<CustomerLogsView> {
  late TextEditingController emailTED;
  bool showLoading = false;
  DateTimeRange? dateRange;

  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    emailTED = TextEditingController();
  }

  @override
  void dispose() {
    emailTED.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background.lightBlue,
      appBar: buildAppBar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spacing.h20,
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: SizedBox(
                    width: Get.width,
                    child: Text(
                      'Select Dates',
                      style: TextStyle(color: AppColors.text.black, fontSize: 14, fontWeight: FontWeight.w600),
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
            Spacing.h20,
            AppTextField(
              hintText: 'Customer Email *',
              controller: emailTED,
              errorValidator: () {
                return Validator.validateEmail(emailTED.text);
              },
            ),
            Spacing.h30,
            Spacing.h30,
            if (showLoading)
              const CircularProgressIndicator(
                color: Colors.white,
                backgroundColor: Colors.black,
              ).center
            else
              AppButton.flat(
                onTap: generateLogs,
                text: 'Generate Logs',
                color: Colors.black,
                textColor: Colors.white,
              ).center,
            Spacing.h30,
          ],
        ).paddingSymmetric(horizontal: 20, vertical: 30).scrollable,
      ),
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
              )
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

  Future<void> generateLogs() async {
    FocusScope.of(context).unfocus();
    if (startDate == null && endDate == null) {
      showToast('Please add start and end dates');
      return;
    }else if(emailTED.text.isEmpty){
      showToast('Please enter email');
      return;
    }
    setState(() {
      showLoading = true;
    });

    List<DiveLogModel> diveLogs = [];

    var customerData = await FirebaseFirestore.instance.collection('customers').doc(emailTED.text).get();
    CustomerModel customer = CustomerModel.fromMap(customerData.data() ?? {});

    var data = await FirebaseFirestore.instance
        .collection('customers')
        .doc(emailTED.text)
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
        print('Error parsing DiveLogModel ${element.data()}');
      }
    }

    if (diveLogs.isNotEmpty) {
      File pdfFile = await CustomerLogs.generatePdf(customer, diveLogs);
      Share.shareFiles([pdfFile.path]);
    } else {
      showToast('No logs added');
    }

    setState(() {
      showLoading = false;
    });
  }

  Widget buildShowLoading() {
    return Container(
      color: Colors.white,
      height: Get.height,
      width: Get.width,
      child: const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
          backgroundColor: Colors.grey,
        ),
      ),
    );
  }

  PreferredSizeWidget buildAppBar() {
    return AppBar(
      toolbarHeight: 70,
      centerTitle: true,
      title: Text(
        'Customer Logs',
        style: TextStyle(
          color: AppColors.text.black,
          fontSize: 20,
          fontWeight: FontWeight.normal,
          letterSpacing: 1.2,
        ),
      ),
      leading: TextButton(
        onPressed: () {
          Get.back();
        },
        child: Icon(
          Icons.arrow_back_ios,
          color: AppColors.text.black,
          size: 17,
        ),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
    );
  }
}
