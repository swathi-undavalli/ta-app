import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/widgets/app-button.dart';
import 'package:temple_adventures/core/widgets/back-navigation-icon.dart';
import 'package:temple_adventures/core/widgets/phone_number/intl_phone_field.dart';
import 'package:temple_adventures/features/boat/controller/boat-controller.dart';
import 'package:temple_adventures/features/boat/controller/editBoat-controller.dart';
import 'package:temple_adventures/features/boat/models/boat-model.dart';
import 'package:temple_adventures/features/bookings/presentation/widgets/app-text-fields.dart';

class EditBoatPage extends StatelessWidget {
  static const String id = "EditBoatPage";
  EditBoatLogic logic = EditBoatLogic();
  final BoatsModel boatsArg = Get.arguments;

  EditBoatPage() {
    logic.controller.boatCapacityTED.text = boatsArg.capacity.toString();
    logic.controller.captainNameTED.text = boatsArg.captainName;
    logic.controller.phoneTED.text = boatsArg.phoneNumber;
    logic.controller.boatName = boatsArg.boatName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(boatName: logic.controller.boatName),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: WillPopScope(
          onWillPop: () async {
            logic.controller.reset();
            return true;
          },
          child: SafeArea(
            child: GetBuilder<EditBoatController>(builder: (controller) {
              return Center(
                child: Column(
                  children: [
                    SizedBox(height: 40),
                    buildTextFields(
                      name: "Boat Capacity",
                      textEditingController: controller.boatCapacityTED,
                      focusNode: controller.boatCapacityNode,
                      nextFocusNode: controller.captainNameNode,
                      keyBoardType: TextInputType.number,
                      // onChanged: (newCapacity) {
                      //   controller.boatsModel.capacity = int.parse(newCapacity);
                      //   controller.update();
                      // },
                    ),
                    buildTextFields(
                      name: "Captain Name",
                      textEditingController: controller.captainNameTED,
                      focusNode: controller.captainNameNode,
                      nextFocusNode: controller.phoneNode,
                      keyBoardType: TextInputType.text,
                      // onChanged: (newName) {
                      //   controller.boatsModel.captainName = newName;
                      //   controller.update();
                      // },
                    ),
                    buildPhoneNumber(),
                    SizedBox(height: 100),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        buildCancelButton(),
                        buildUpdateButton(),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget buildSubtitle(String name) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 30),
      child: Container(
        width: Get.size.width,
        child: Text(
          name,
          style: TextStyle(
            color: Colors.black54,
            fontFamily: AppFonts.nunito,
            fontSize: 12,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget buildCaptainName() {
    return GetBuilder<EditBoatController>(builder: (controller) {
      return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: DropdownButton(
          focusNode: controller.captainNameNode,
          underline: Container(height: 1, color: Colors.grey),
          isExpanded: true,
          value: controller.captainNameTED.text.isNotEmpty
              ? controller.captainNameTED.text
              : null,
          onChanged: (employee) {
            controller.captainNameTED.text = employee;
            controller.update();
          },
          items: controller.allEmployeesList.map((employee) {
            return DropdownMenuItem(
              child: new Text(employee.name),
              value: employee,
            );
          }).toList(),
        ),
      );
    });
  }

  Widget buildPhoneNumber() {
    return GetBuilder<EditBoatController>(builder: (controller) {
      return Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20),
        child: IntlPhoneField(
          autoValidate: true,
          focusNode: controller.phoneNode,
          initialCountryCode: controller.isoCode,
          showCountryFlag: false,
          initialValue: controller.phoneTED.text,
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
          onSubmitted: (_) {},
          onChanged: (phone) {
            controller.countryCodeTED.text = phone.countryCode;
            controller.phoneTED.text = phone.number;
            controller.isoCode = phone.countryISOCode;

            // controller.boatsModel.phoneNumber = phone.number;
          },
        ),
      );
    });
  }

  Widget buildCancelButton() {
    return Center(
      child: AppButton.flat(
        text: "Cancel",
        textColor: AppColors.text.black,
        color: AppColors.background.grey,
        onTap: () {
          logic.controller.reset();
          Get.back();
        },
      ),
    );
  }

  Widget buildUpdateButton() {
    return GetBuilder<EditBoatController>(builder: (controller) {
      return Center(
        child: AppButton.flat(
          text: "Update",
          textColor: AppColors.text.white,
          color: AppColors.background.black,
          onTap: () {
            BoatsModel boatsModel = BoatsModel(
              capacity: int.parse(controller.boatCapacityTED.text),
              captainName: controller.captainNameTED.text,
              phoneNumber: controller.phoneTED.text,
              boatName: boatsArg.boatName,
              id: boatsArg.id,
            );
            var boat = FirebaseFirestore.instance
                .collection("boats")
                .doc(boatsArg.id)
                .set(boatsModel.toMap());
            //print(boat);
            controller.reset();
            Get.back();
            BoatLogic boatLogic = BoatLogic();
            boatLogic.getData();
          },
        ),
      );
    });
  }

  Widget buildAppBar({String boatName}) {
    return AppBar(
      toolbarHeight: 70,
      centerTitle: true,
      title: Text(
        boatName,
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          letterSpacing: 1.2,
        ),
      ),
      leading: BackNavigationIcon(),
      elevation: 0,
      backgroundColor: AppColors.background.white,
    );
  }

  Widget buildTextFields(
      {String name,
      TextEditingController textEditingController,
      FocusNode focusNode,
      FocusNode nextFocusNode,
      TextInputType keyBoardType,
      Function onChanged}) {
    return AppTextField(
      hintText: name,
      controller: textEditingController,
      focusNode: focusNode,
      nextFocusNode: nextFocusNode,
      required: false,
      keyboardType: keyBoardType,
      onChangedCallBack: onChanged,
      errorValidator: () {
        return null;
      },
      validator: (_) {
        return null;
      },
    );
  }
}
