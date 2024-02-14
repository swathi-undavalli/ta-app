import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share/share.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/util/alignment_extensions.dart';
import '../../../../core/util/spacing_widgets.dart';
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
            Spacing.h20,
            AppTextField(
              hintText: 'Customer Email',
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

  Future<void> generateLogs() async {
    if (Validator.validateEmail(emailTED.text) != null) return;

    setState(() {
      showLoading = true;
    });

    List<DiveLogModel> diveLogs = [];

    var customerData = await FirebaseFirestore.instance
        .collection('customers')
        .doc('kamesh.wb@gmail.com')
        // .doc(emailTED.text)
        .get();
    CustomerModel customer = CustomerModel.fromMap(customerData.data() ?? {});

    var data = await FirebaseFirestore.instance
        .collection('customers')
        .doc('kamesh.wb@gmail.com')
        //TODO: Update this @Sahitha
        // .doc(emailTED.text)
        .collection('diveLogs')
        .get();

    for (var element in data.docs) {
      try {
        Map<String, dynamic> d = element.data();
        diveLogs.add(DiveLogModel.fromMap(d));
      } catch (e) {
        print('Error parsing DiveLogModel ${element.data()}');
      }
    }

    File pdfFile = await CustomerLogs.generatePdf(customer, diveLogs);
    Share.shareFiles([pdfFile.path]);

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
