import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/util/spacing_widgets.dart';
import '../../../../core/widgets/app_button.dart';
import '../../models/booking_model.dart';
import '../screens/add_dive_log_view.dart';
import 'add_customer_dialog.dart';

class DiveLogBottomSheet extends StatefulWidget {
  const DiveLogBottomSheet({
    Key? key,
    required this.bookingModel,
  }) : super(key: key);

  final Booking bookingModel;

  static void show(BuildContext context, {required Booking bookingModel}) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (BuildContext context) {
        return DiveLogBottomSheet(
          bookingModel: bookingModel,
        );
      },
    );
  }

  @override
  State<DiveLogBottomSheet> createState() => _DiveLogBottomSheetState();
}

class _DiveLogBottomSheetState extends State<DiveLogBottomSheet> {
  String? phoneNumber;
  String? countryCode;
  String? isoCode = 'IN';
  TextEditingController nameTED = TextEditingController();
  TextEditingController emailTED = TextEditingController();
  bool showLoading = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 40,
        left: 25,
        right: 20,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: AppColors.background.lightBlue,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spacing.h30,
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'Add Log',
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
            ),
            Spacing.h20,
            ...List.generate(
              widget.bookingModel.pax!.length,
              (index) => Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text("${widget.bookingModel.pax?[index]['first-name']}"
                          "${widget.bookingModel.pax?[index]['last-name']}"),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          Get.toNamed(
                            AddDiveLogView.id,
                            arguments: [
                              widget.bookingModel,
                              widget.bookingModel.pax?[index]['email'],
                            ],
                          );
                        },
                        icon: Icon(
                          Icons.arrow_forward,
                          color: AppColors.text.skyBlue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Spacing.h20,
            if (widget.bookingModel.pax!.length != widget.bookingModel.noOfPersons)
              AppButton.miniFlat(
                text: 'Add Customer',
                onTap: () {
                  AddCustomerDialog.show(
                    context,
                    bookingModel: widget.bookingModel,
                  );
                },
              ),
            Spacing.h30,
          ],
        ),
      ),
    );
  }
}
