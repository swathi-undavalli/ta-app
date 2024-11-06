import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:temple_ui_tools/temple_ui_tools.dart';
import 'package:temple_ui_tools/utils/utils.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/util/validator.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/phone_number/intl_phone_field.dart';
import '../../models/booking_model.dart';
import '../../models/customer_model.dart';
import 'app_text_fields.dart';

class AddCustomerDialog extends StatefulWidget {
  const AddCustomerDialog({
    super.key,
    required this.bookingModel,
  });

  final Booking bookingModel;

  static Future<Booking> show(BuildContext context, {required Booking bookingModel}) async {
    var data = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AddCustomerDialog(
          bookingModel: bookingModel,
        );
      },
    );
    return data as Booking;
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
  TextEditingController genderTED = TextEditingController();
  TextEditingController dobTED = TextEditingController();
  bool showLoading = false;
  String? nameError;
  String? emailError;
  String? phoneError;
  String? genderError;
  String? dobError;
  CustomerModel? customerModel;
  List<String> gender = ['Male', 'Female'];
  DateTime? dob = DateTime.now();

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
              height: 350,
              child: Column(
                children: [
                  AppTextField(
                    hintText: 'Email',
                    controller: emailTED,
                    required: true,
                    keyboardType: TextInputType.emailAddress,
                    inputFormatter: [
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        return newValue.copyWith(text: newValue.text.toLowerCase());
                      }),
                    ],
                    errorValidator: () {
                      return Validator.validateEmail(emailTED.text);
                    },
                    validator: (email) {
                      return Validator.validateEmail(emailTED.text);
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
                  buildDOB(),
                  buildGender(),
                ],
              ).scrollable,
            )
          : Container(
              height: Screen.height / 2,
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
            Navigator.pop(context);
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
                'dob': dob,
                'gender': genderTED.text,
              });
              await FirebaseFirestore.instance
                  .collection('bookings')
                  .doc(widget.bookingModel.id)
                  .set(widget.bookingModel.toMap());
              setState(() {
                showLoading = false;
              });
              clear();
              if (context.mounted) {
                Navigator.pop(context, widget.bookingModel);
              }
            }
          },
        ),
      ],
    );
  }

  Widget buildDOB() {
    return GestureDetector(
      onTap: () {
        dobDatePicker();
      },
      child: AbsorbPointer(
        child: AppTextField(
          hintText: 'Date of Birth',
          controller: dobTED,
          keyboardType: TextInputType.number,
          required: true,
          errorValidator: () {
            return dobError;
          },
          validator: (dob) {
            return dob;
          },
        ),
      ),
    );
  }

  dobDatePicker() {
    DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime.now().subtract(const Duration(days: 36500)),
      maxTime: DateTime.now().subtract(const Duration(days: 2920)),
      onChanged: (date) {
        dob = date;
        dobTED.text = DateFormat('dd MMM, yyyy').format(date);
      },
      onConfirm: (date) {
        dob = date;
        dobTED.text = DateFormat('dd MMM, yyyy').format(date);
        setState(() {});
      },
      currentTime: dob,
    );
  }

  Widget buildGender() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Gender *',
            style: TextStyle(
              color: Colors.black54,
              fontFamily: AppFonts.nunito,
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
          ),
          DropdownButton(
            underline: Container(height: 1, color: Colors.grey),
            isExpanded: true,
            value: genderTED.text.isNotEmpty ? genderTED.text : null,
            onChanged: (dynamic newGender) {
              genderTED.text = newGender;
              setState(() {});
            },
            items: gender.map((gender) {
              return DropdownMenuItem(
                value: gender,
                child: Text(gender),
              );
            }).toList(),
          ),
          Spacing.h5,
          Text(
            'Required',
            style: TextStyle(fontSize: 12, color: Colors.red.shade900),
          ),
        ],
      ),
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
      gender: genderTED.text,
      dob: null,
    );
    await FirebaseFirestore.instance.collection('customers').doc(emailTED.text).set(customer.toMap());
  }

  bool isValid() {
    bool isValid = true;
    nameError = null;
    emailError = null;
    phoneError = null;
    genderError = null;
    dobError = null;

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
    if (genderTED.text.isEmpty) {
      genderError = 'Required';
      isValid = false;
      setState(() {});
    }
    if (dobTED.text.isEmpty) {
      dobError = 'Required';
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
    dobTED.text = '';
    dob = null;
  }

  Widget buildShowLoading() {
    if (showLoading) {
      return Material(
        color: Colors.transparent,
        child: Container(
          color: Colors.black54,
          height: Screen.height,
          width: Screen.width,
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
