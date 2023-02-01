import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/access_levels.dart';
import 'package:temple_adventures/features/employees/presentation/screens/all-employees-screen.dart';
import 'package:temple_adventures/features/home/model/employee.dart';
import '../app-button.dart';

class AddEmployeeWidget extends StatelessWidget {
  String text;
  String subText;
Function   onTap;


  AddEmployeeWidget({required this.text, required this.subText,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return EmployeeAccess(
      access: AccessRights.viewEmployees,
      child: Container(
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
                    text,
                    style: TextStyle(
                      fontFamily: AppFonts.nunito,
                      color: AppColors.text.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    subText,
                    style: TextStyle(
                      fontFamily: AppFonts.nunito,
                      color: AppColors.text.darkgrey,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: AppButton.miniFlat(
                  onTap: onTap,
                    // Get.toNamed(AllEmployeesScreen.id);
                  text: 'VIEW',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
