import 'package:flutter/material.dart';
import 'package:temple_ui_tools/styling/spacing_widgets.dart';

import '../../../../core/constants/constants.dart';
import '../../../dashboard/presentation/views/dashboard_view.dart';
import '../../../employees/model/employee.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({Key? key}) : super(key: key);

  static Route route() => MaterialPageRoute(
        builder: (context) => const WelcomeView(),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background.lightBlue,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, DashBoardView.route());
        },
        elevation: 0,
        backgroundColor: AppColors.iconColor.black,
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
      width: Screen.width,
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
