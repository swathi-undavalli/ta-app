import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/util/spacing_widgets.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/phone_number/intl_phone_field.dart';
import '../../models/booking_model.dart';
import '../screens/add_log_view.dart';
import 'app_text_fields.dart';

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
                          Get.toNamed(AddLogView.id);
                        },
                        icon: Icon(
                          Icons.arrow_forward,
                          color: AppColors.text.skyBlue,
                        ),
                      )
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
                  addCustomerDialog(context);
                },
              ),
            Spacing.h30,
          ],
        ),
      ),
    );
  }

  Future<void> addCustomerDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Add Customer',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          content: SizedBox(
            height: 300,
            child: Column(
              children: [
                AppTextField(
                  hintText: 'Email',
                  errorValidator: () {
                    return null;
                  },
                  validator: (_) {
                    return null;
                  },
                ),
                AppTextField(
                  hintText: 'Name',
                  errorValidator: () {
                    return null;
                  },
                  validator: (_) {
                    return null;
                  },
                ),
                buildPhoneNumber(),
              ],
            ),
          ),
          actions: <Widget>[
            AppButton.miniText(
              text: 'Cancel',
              onTap: () {
                Get.back();
              },
            ),
            AppButton.miniFlat(
              text: 'Okay',
              onTap: () async {},
            ),
          ],
        );
      },
    );
  }

  Widget buildPhoneNumber() {
    return IntlPhoneField(
      autoValidate: true,
      initialCountryCode: isoCode,
      showCountryFlag: false,
      initialValue: phoneNumber,
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
        countryCode = phone.countryCode;
        phoneNumber = phone.number!;
        isoCode = phone.countryISOCode;
      },
    );
  }
}
