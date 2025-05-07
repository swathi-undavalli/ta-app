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
import '../../../../core/widgets/field_error.dart';
import '../../../../core/widgets/image_uploader.dart';
import '../../../../core/widgets/phone_number_input.dart';
import '../../models/booking_model.dart';
import '../../models/customer_model.dart';
import 'app_text_fields.dart';

class AddCustomerDialog extends StatefulWidget {
  const AddCustomerDialog({
    super.key,
    required this.bookingModel,
  });

  final Booking bookingModel;

  static Future<Booking> show(
    BuildContext context, {
    required Booking bookingModel,
  }) async {
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
  String? countryCode;
  String? isoCode = 'IN';
  late TextEditingController nameTED;
  late TextEditingController phoneTED;
  late TextEditingController emailTED;
  late TextEditingController genderTED;
  late TextEditingController dobTED;
  bool showLoading = false;
  String? nameError;
  String? emailError;
  String? phoneError;
  String? genderError;
  String? dobError;
  List<String> gender = ['Male', 'Female'];
  DateTime? dob = DateTime.now();
  String? _uploadedImage;
  String? _pickedImageError;
  late Booking bookingModel;

  @override
  void initState() {
    super.initState();
    bookingModel = widget.bookingModel;
    nameTED = TextEditingController();
    phoneTED = TextEditingController();
    emailTED = TextEditingController();
    genderTED = TextEditingController();
    dobTED = TextEditingController();
  }

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
                        return newValue.copyWith(
                          text: newValue.text.toLowerCase(),
                        );
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
                  Spacing.h5,
                  buildIdProof(),
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
        AppButton.miniFlat(
          isSecondary: true,
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
              bookingModel.pax?.add({
                'first-name': nameTED.text,
                'email': emailTED.text,
                'last-name': '',
                'countryCode': countryCode,
                'phoneNumber': phoneTED.text,
                'isoCode': isoCode,
                'dob': dob,
                'gender': genderTED.text,
                'idProof': _uploadedImage,
              });
              await FirebaseFirestore.instance
                  .collection('bookings')
                  .doc(bookingModel.id)
                  .set(bookingModel.toMap());
              setState(() {
                showLoading = false;
              });
              clear();
              if (context.mounted) {
                Navigator.pop(context, bookingModel);
              }
            }
          },
        ),
      ],
    );
  }

  Widget buildIdProof() {
    return Column(
      children: [
        Row(
          children: [
            const Text(
              'Photo : ',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacing.w8,
            const Text(
              'upload IdProof',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ).left,
          ],
        ),
        Spacing.h8,
        Row(
          children: [
            ImageUploader(
              onImageUploaded: (String imageUrl) => _uploadedImage = imageUrl,
            ),
            FieldError(_pickedImageError),
          ],
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
    return Column(
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
        if (genderError != null)
          Text(
            'Required',
            style: TextStyle(fontSize: 12, color: Colors.red.shade900),
          ),
      ],
    );
  }

  Future<bool> isCustomerExists() async {
    var d = await FirebaseFirestore.instance
        .collection('customers')
        .doc(emailTED.text)
        .get();
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
      phoneNumber: phoneTED.text,
      idProof: _uploadedImage,
      gender: genderTED.text,
      dob: dobTED.text,
    );
    await FirebaseFirestore.instance
        .collection('customers')
        .doc(emailTED.text)
        .set(customer.toMap());
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
    if (phoneTED.text.isEmpty) {
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
    phoneTED.text = '';
    countryCode = null;
    nameTED.text = '';
    emailTED.text = '';
    isoCode = 'IN';
    dobTED.text = '';
    dob = null;
    _uploadedImage = null;
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
        PhoneNumberInput(
          controller: phoneTED,
          initialCountryCode: isoCode,
          required: true,
          onChanged: (phone) {
            countryCode = phone.countryCode;
            phoneTED.text = phone.number;
            isoCode = phone.countryISOCode;
          },
          onCountryChanged: (country) {
            countryCode = country.dialCode;
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
