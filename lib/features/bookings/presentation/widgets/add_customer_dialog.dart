import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/util/alignment_extensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/phone_number/intl_phone_field.dart';
import '../../models/booking_model.dart';
import '../../models/customer_model.dart';
import 'app_text_fields.dart';

class AddCustomerDialog extends StatefulWidget {
  const AddCustomerDialog({
    Key? key,
    required this.bookingModel,
  }) : super(key: key);

  final Booking bookingModel;

  static void show(BuildContext context, {required Booking bookingModel}) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AddCustomerDialog(
          bookingModel: bookingModel,
        );
      },
    );
  }

  @override
  State<AddCustomerDialog> createState() => _AddCustomerDialogState();
}

class _AddCustomerDialogState extends State<AddCustomerDialog> {
  String? phoneNumber;
  String? countryCode;
  String? isoCode = 'IN';
  TextEditingController nameTED = TextEditingController();
  TextEditingController emailTED = TextEditingController();
  bool showLoading = false;
  String? nameError;
  String? emailError;
  String? phoneError;
  CustomerModel? customerModel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: Colors.white,
      title: const Text(
        'Add Customer',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      content: (!showLoading)
          ? SizedBox(
              height: 300,
              child: Column(
                children: [
                  AppTextField(
                    hintText: 'Email',
                    controller: emailTED,
                    required: true,
                    errorValidator: () {
                      return emailError;
                    },
                    validator: (email) {
                      return emailError;
                    },
                  ),
                  AppTextField(
                    hintText: 'Name',
                    controller: nameTED,
                    required: true,
                    errorValidator: () {
                      return nameError;
                    },
                    validator: (name) {
                      return name;
                    },
                  ),
                  buildPhoneNumber(),
                ],
              ).scrollable,
            )
          : Container(
              height: Get.height / 2,
              color: Colors.white,
              child: const CircularProgressIndicator(
                color: Colors.black,
                backgroundColor: Colors.grey,
              ).center,
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
          onTap: () async {
            if (isValid()) {
              setState(() {
                showLoading = true;
              });
              if (await isCustomerExists() == false) {
                await createCustomer();
              }
              widget.bookingModel.pax?.add({
                'first-name': nameTED.text,
                'email': emailTED.text,
                'last-name': '',
                'countryCode': countryCode,
                'phoneNumber': phoneNumber,
                'isoCode': isoCode,
                'dob': DateTime.now(),
              });
              await FirebaseFirestore.instance
                  .collection('bookings')
                  .doc(widget.bookingModel.id)
                  .set(widget.bookingModel.toMap());
              setState(() {
                showLoading = false;
              });
              clear();
              Get.back();
            }
          },
        ),
      ],
    );
  }

  Future<bool> isCustomerExists() async {
    var d = await FirebaseFirestore.instance.collection('customers').doc(emailTED.text).get();
    Map<String, dynamic>? data = d.data();
    if (data == null) return false;
    return true;
  }

  Future<void> createCustomer() async {
    CustomerModel customer = CustomerModel(
      countryCode: countryCode,
      firstName: nameTED.text,
      lastName: '',
      email: emailTED.text,
      phoneNumber: phoneNumber,
      idProof: '',
      gender: '',
      dob: null,
    );
    await FirebaseFirestore.instance.collection('customers').doc(emailTED.text).set(customer.toMap());
  }

  bool isValid() {
    bool isValid = true;
    nameError = null;
    emailError = null;
    phoneError = null;

    if (nameTED.text.isEmpty) {
      nameError = 'Required';
      isValid = false;
      setState(() {});
    }
    if (emailTED.text.isEmpty) {
      emailError = 'Required';
      isValid = false;
      setState(() {});
    }
    if (phoneNumber == null) {
      phoneError = 'Required';
      isValid = false;
      setState(() {});
    }
    return isValid;
  }

  void clear() {
    phoneNumber = null;
    countryCode = null;
    nameTED.text = '';
    emailTED.text = '';
    isoCode = 'IN';
  }

  Widget buildShowLoading() {
    if (showLoading) {
      return Material(
        color: Colors.transparent,
        child: Container(
          color: Colors.black54,
          height: Get.height,
          width: Get.width,
          child: const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  Widget buildPhoneNumber() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IntlPhoneField(
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
        ),
        Text(
          (phoneError != null) ? 'Phone $phoneError' : '',
          style: TextStyle(fontSize: 12, color: Colors.red.shade900),
        ),
      ],
    );
  }
}
