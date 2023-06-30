import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/widgets/app-button.dart';
import 'package:temple_adventures/core/widgets/back-navigation-icon.dart';
import 'package:temple_adventures/features/boat/controller/manage-dsd-equipment-controller.dart';
import 'package:temple_adventures/features/bookings/presentation/widgets/app-text-fields.dart';

class ManageDSDEquipment extends StatefulWidget {
  static const String id = "ManageDSDEquipment";

  @override
  State<ManageDSDEquipment> createState() => _ManageDSDEquipmentState();
}

class _ManageDSDEquipmentState extends State<ManageDSDEquipment> {
  final ManageDSDEquipmentLogic logic = ManageDSDEquipmentLogic();

  @override
  void initState() {
    logic.init().whenComplete(() => logic.controller.update());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar() as PreferredSizeWidget?,
      body: WillPopScope(
        onWillPop: () async {
          logic.controller.reset();
          return true;
        },
        child: SafeArea(
          child: GetBuilder<ManageDSDEquipmentController>(builder: (controller) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextField(
                    hintText: "BCD",
                    controller: controller.bdcTED,
                    errorValidator: () {
                      return null;
                    },
                    validator: (_) {
                      return null;
                    },
                  ),
                  AppTextField(
                    hintText: "Regulator",
                    controller: controller.regTED,
                    errorValidator: () {
                      return null;
                    },
                    validator: (_) {
                      return null;
                    },
                  ),
                  AppTextField(
                    hintText: "Mask",
                    controller: controller.maskTED,
                    errorValidator: () {
                      return null;
                    },
                    validator: (_) {
                      return null;
                    },
                  ),
                  AppTextField(
                    hintText: "Power Mask",
                    controller: controller.powerMaskTED,
                    errorValidator: () {
                      return null;
                    },
                    validator: (_) {
                      return null;
                    },
                  ),
                  AppTextField(
                    hintText: "Fins",
                    controller: controller.finsTED,
                    errorValidator: () {
                      return null;
                    },
                    validator: (_) {
                      return null;
                    },
                  ),
                  AppTextField(
                    hintText: "Boots",
                    controller: controller.bootsTED,
                    errorValidator: () {
                      return null;
                    },
                    validator: (_) {
                      return null;
                    },
                  ),
                  AppTextField(
                    hintText: "Weights",
                    controller: controller.weightsTED,
                    errorValidator: () {
                      return null;
                    },
                    validator: (_) {
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Employees : ",
                    style: TextStyle(
                        fontSize: FontSize.textSize,
                        color: AppColors.text.black,
                        fontFamily: AppFonts.nunito,
                        fontWeight: FontWeight.w600),
                  ),
                  AppTextField(
                    controller: controller.dayOffTED,
                    hintText: "Day offs",
                    minLines: 3,
                    errorValidator: () {
                      return null;
                    },
                    validator: (_) {
                      return null;
                    },
                  ),
                  AppTextField(
                    controller: controller.leavesTED,
                    hintText: "Leaves",
                    minLines: 3,
                    errorValidator: () {
                      return null;
                    },
                    validator: (_) {
                      return null;
                    },
                  ),
                  AppTextField(
                    controller: controller.generalNotesTED,
                    hintText: "General Notes",
                    minLines: 3,
                    errorValidator: () {
                      return null;
                    },
                    validator: (_) {
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Weather : ",
                    style: TextStyle(
                        fontSize: FontSize.textSize,
                        color: AppColors.text.black,
                        fontFamily: AppFonts.nunito,
                        fontWeight: FontWeight.w600),
                  ),
                  AppTextField(
                    controller: controller.highTideTED,
                    hintText: "High Tide",
                    errorValidator: () {
                      return null;
                    },
                    validator: (_) {
                      return null;
                    },
                  ),
                  AppTextField(
                    controller: controller.lowTideTED,
                    hintText: "Low Tide",
                    errorValidator: () {
                      return null;
                    },
                    validator: (_) {
                      return null;
                    },
                  ),
                  AppTextField(
                    controller: controller.wavesTED,
                    hintText: "Waves",
                    errorValidator: () {
                      return null;
                    },
                    validator: (_) {
                      return null;
                    },
                  ),
                  AppTextField(
                    controller: controller.windsTED,
                    hintText: "Winds",
                    errorValidator: () {
                      return null;
                    },
                    validator: (_) {
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: AppButton.flat(
                      text: "Submit",
                      onTap: () {
                        logic.onSubmitPressed();
                      },
                      color: Colors.black,
                      textColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ).paddingSymmetric(horizontal: 20),
            );
          }),
        ),
      ),
    );
  }

  Widget buildAppBar() {
    return AppBar(
      toolbarHeight: 70,
      centerTitle: true,
      title: buildTitle(),
      leading: BackNavigationIcon(),
      elevation: 0,
      backgroundColor: AppColors.background.white,
    );
  }

  Widget buildTitle() {
    return Text(
      'DSD Equipment',
      style: TextStyle(
        color: AppColors.text.black,
        fontSize: 20,
        fontFamily: AppFonts.nunito,
        fontWeight: FontWeight.normal,
        letterSpacing: 1.2,
      ),
    );
  }
}
