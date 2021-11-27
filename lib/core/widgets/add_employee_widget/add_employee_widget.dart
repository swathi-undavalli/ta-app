import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/features/employees/presentation/screens/all-employees-screen.dart';
import '../app-button.dart';

class AddEmployeeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 321,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Add Employees",
                  style: TextStyle(
                    fontFamily: AppFonts.nunito,
                    color: AppColors.text.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "Only admins can view",
                  style: TextStyle(
                    fontFamily: AppFonts.nunito,
                    color: AppColors.text.darkgrey,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            SizedBox(width: 60),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: AppButton.miniFlat(
                onTap: () {
                  Get.toNamed(AllEmployeesScreen.id);
                },
                text: 'VIEW',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
