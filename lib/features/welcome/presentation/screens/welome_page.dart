import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/constants.dart';
import '../../../dashboard/presentation/screens/dashboard_screen.dart';
import '../../../employees/model/employee.dart';

class WelcomeScreen extends StatelessWidget {
  static const String id = 'WelcomeScreen';

  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background.lightBlue,

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.offAndToNamed(DashBoardScreen.id);
        },
        elevation: 0,
        backgroundColor: AppColors.IconColor.black,
        child: const Icon(
          Icons.arrow_forward_ios_outlined,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildHii(),
              const SizedBox(height: 20),
              buildPersonName(),
              const SizedBox(height: 5),
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
      currentEmployee!.role!,
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
      currentEmployee!.firstName!,
      style: TextStyle(
        fontSize: FontSize.title,
        color: AppColors.text.skyBlue,
        fontFamily: AppFonts.nunito,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget buildHii() {
    return SizedBox(
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
