import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/widgets/app-button.dart';
import 'package:temple_adventures/core/widgets/phone_number/intl_phone_field.dart';
import 'package:temple_adventures/features/boat/models/boat-passengers-model.dart';
import 'package:temple_adventures/features/bookings/presentation/widgets/app-text-fields.dart';

class FreelanceDiverBottomSheet extends StatefulWidget {
  final Function(Freelancer) onFreelanceAdded;

  FreelanceDiverBottomSheet({@required this.onFreelanceAdded});

  @override
  State<FreelanceDiverBottomSheet> createState() =>
      _FreelanceDiverBottomSheetState();
}

class _FreelanceDiverBottomSheetState extends State<FreelanceDiverBottomSheet> {
  final TextEditingController nameTED = TextEditingController();

  final TextEditingController phoneNumberTED = TextEditingController();
  final TextEditingController countryCodeTED = TextEditingController();

  final TextEditingController genderTED = TextEditingController();

  FocusNode nameNode = FocusNode();

  String countryISoCode = "IN";

  FocusNode phoneNumberNode = FocusNode();

  FocusNode genderNode = FocusNode();

  List<String> gender = ['Male', 'Female'];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 350,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          )),
      child: Padding(
        padding: const EdgeInsets.all(17.0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Add Freelance", style: TextStyle(fontSize: 17)),
                  GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        height: 30,
                        width: 30,
                        child: Icon(
                          Icons.clear_rounded,
                          size: 21,
                        ),
                      ))
                ],
              ),
              SizedBox(height: 10),
              buildName(),
              // buildTF(
              //     hintText: "Phone Number",
              //     controller: phoneNumberTED,
              //     isNumber: true,
              //     node: phoneNumberNode),
              buildPhoneNumber(),
              buildSubtitle("Gender"),
              buildGender(),
              // buildTF(hintText: "Gender", controller: genderTED),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppButton.miniText(
                    onTap: () {
                      Get.back();
                    },
                    text: "Cancel",
                  ),
                  AppButton.miniFlat(
                    onTap: () {
                      widget.onFreelanceAdded(Freelancer(
                          name: nameTED.text,
                          phone: phoneNumberTED.text,
                          gender: genderTED.text));
                      Get.back();
                    },
                    text: "Add",
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSubtitle(String name) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Container(
        width: Get.size.width,
        child: Text(
          name,
          style: TextStyle(
            color: Colors.black,
            fontFamily: AppFonts.nunito,
            fontSize: 12,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget buildPhoneNumber() {
    return IntlPhoneField(
      autoValidate: true,
      focusNode: phoneNumberNode,
      initialCountryCode: countryISoCode,
      showCountryFlag: false,
      // controller: phoneNumberTED,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
      onSubmitted: (_) {
        genderNode.requestFocus();
      },
      onChanged: (phone) {
        phoneNumberTED.text = phone.number;
        countryCodeTED.text = phone.countryCode;
        countryISoCode = phone.countryISOCode;
        //print(phone.number);
        //print(phone.countryISOCode);
        //print(phone.countryCode);
      },
    );
  }

  Widget buildGender() {
    return DropdownButton(
      focusNode: genderNode,
      underline: Container(height: 1, color: Colors.grey),
      isExpanded: true,
      value: genderTED.text.isNotEmpty ? genderTED.text : null,
      onChanged: (newGender) {
        setState(() {
          genderTED.text = newGender;
        });
      },
      items: gender.map((gender) {
        return DropdownMenuItem(
          child: new Text(gender),
          value: gender,
        );
      }).toList(),
    );
  }

  Widget buildName() {
    return AppTextField(
      hintText: 'Name',
      controller: nameTED,
      focusNode: nameNode,
      nextFocusNode: phoneNumberNode,
      required: true,
      errorValidator: () {
        return null;
      },
      validator: (firstName) {
        return null;
      },
    );
  }
}
