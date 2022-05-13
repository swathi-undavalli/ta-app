import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/widgets/app-button.dart';
import 'package:temple_adventures/features/boat/models/boat-passengers-model.dart';

class FreelanceDiverBottomSheet extends StatelessWidget {
  final TextEditingController nameTED = TextEditingController();
  final TextEditingController phoneNumberTED = TextEditingController();
  final TextEditingController genderTED = TextEditingController();
  final Function(Freelancer) onFreelanceAdded;
  FocusNode nameNode = FocusNode();
  FocusNode phoneNumberNode = FocusNode();
  FocusNode genderNode = FocusNode();

  FreelanceDiverBottomSheet({@required this.onFreelanceAdded});

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
              buildTF(hintText: "Name", controller: nameTED),
              buildTF(
                  hintText: "Phone Number",
                  controller: phoneNumberTED,
                  isNumber: true),
              buildTF(hintText: "Gender", controller: genderTED),
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
                      onFreelanceAdded(Freelancer(
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

  Widget buildTF({
    String hintText,
    TextEditingController controller,
    bool isNumber = false,
  }) {
    return TextField(
      controller: controller,
      cursorColor: AppColors.text.darkgrey,
      keyboardType: isNumber ? TextInputType.number : null,
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        label: Text(
          hintText,
          style: TextStyle(color: Colors.black, fontSize: 12),
        ),
      ),
    );
  }
}
