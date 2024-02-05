import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/util/alignment_extensions.dart';
import '../../../../core/util/spacing_widgets.dart';
import '../../../../core/widgets/app_button.dart';
import '../../controller/add_log_controller.dart';
import '../widgets/app_text_fields.dart';

class AddLogView extends StatelessWidget {
  AddLogView({Key? key}) : super(key: key);

  static const String id = 'AddLogView';

  final AddLogLogic logic = AddLogLogic();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            AppTextField(
              hintText: 'Date',
              errorValidator: () {
                return null;
              },
              validator: (_) {
                return null;
              },
            ),
            AppTextField(
              hintText: 'Instructor',
              errorValidator: () {
                return null;
              },
              validator: (_) {
                return null;
              },
            ),
            AppTextField(
              hintText: 'Course / FD',
              errorValidator: () {
                return null;
              },
              validator: (_) {
                return null;
              },
            ),
            AppTextField(
              hintText: 'Dive Site',
              errorValidator: () {
                return null;
              },
              validator: (_) {
                return null;
              },
            ),
            AppTextField(
              hintText: 'Tank No',
              errorValidator: () {
                return null;
              },
              validator: (_) {
                return null;
              },
            ),
            AppTextField(
              hintText: 'Bottom Time',
              errorValidator: () {
                return null;
              },
              validator: (_) {
                return null;
              },
            ),
            AppTextField(
              hintText: 'Max Depth',
              errorValidator: () {
                return null;
              },
              validator: (_) {
                return null;
              },
            ),
            AppTextField(
              hintText: 'Time-In',
              errorValidator: () {
                return null;
              },
              validator: (_) {
                return null;
              },
            ),
            Spacing.h30,
            Spacing.h30,
            AppButton.flat(
              text: 'Submit',
              color: Colors.black,
              textColor: Colors.white,
            ),
            Spacing.h30,
            Spacing.h30,
          ],
        ).paddingSymmetric(horizontal: 20).scrollable,
      ),
    );
  }

  PreferredSizeWidget buildAppBar() {
    return AppBar(
      toolbarHeight: 70,
      centerTitle: true,
      title: Text(
        'Add Log',
        style: TextStyle(
          color: AppColors.text.black,
          fontSize: 20,
          fontWeight: FontWeight.normal,
          letterSpacing: 1.2,
        ),
      ),
      leading: TextButton(
        onPressed: () {
          Get.back();
        },
        child: Icon(
          Icons.arrow_back_ios,
          color: AppColors.text.black,
          size: 17,
        ),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
    );
  }
}
