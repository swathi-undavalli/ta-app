import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/features/dashboard/presentation/screens/dashboard-screen.dart';
import 'package:temple_adventures/features/home/model/employee.dart';

class WelcomeScreen extends StatelessWidget {
  static const String id = "WelcomeScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.offAndToNamed(DashBoardScreen.id);
        },
        elevation: 0,
        backgroundColor: AppColors.IconColor.black,
        child: Icon(Icons.arrow_forward_ios_outlined),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildHii(),
              SizedBox(height: 20),
              buildPersonName(),
              SizedBox(height: 5),
              buildPersonRole(),
            ],
          ),
        ),
      ),
    );
  }

  ///============UI============///

  Widget buildPersonRole() {
    return Text(
      currentEmployee.role,
      style: TextStyle(
        fontSize: FontSize.message,
        color: AppColors.text.black,
        fontFamily: AppFonts.nunito,
        fontWeight: FontWeight.normal,
      ),
    );
  }

  Widget buildPersonName() {
    return Text(
      currentEmployee.firstName,
      style: TextStyle(
        fontSize: FontSize.title,
        color: AppColors.text.skyBlue,
        fontFamily: AppFonts.nunito,
        fontWeight: FontWeight.w700,
      ),
    );
  }

 Widget buildHii() {
    return Container(
      width: Get.size.width,
      child: Text(
        'Hi,',
        style: TextStyle(
          fontSize: FontSize.title,
          color: AppColors.text.black,
          fontFamily: AppFonts.nunito,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
