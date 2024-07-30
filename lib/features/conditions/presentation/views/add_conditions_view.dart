import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:temple_ui_tools/utils/utils.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/util/utils.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../bookings/presentation/widgets/app_text_fields.dart';
import '../../controller/add_conditions_controller.dart';
import '../../models/conditions_model.dart';
import '../widgets/depth_expansion_panel_widget.dart';
import '../widgets/surface_conditions_expansion_panel.dart';

class AddConditionsView extends StatefulWidget {
  const AddConditionsView({super.key});

  static Route route() => MaterialPageRoute(
        builder: (context) => const AddConditionsView(),
      );

  @override
  State<AddConditionsView> createState() => _AddConditionsViewState();
}

class _AddConditionsViewState extends State<AddConditionsView> {
  final AddConditionsLogic logic = AddConditionsLogic();

  final TextEditingController depthTED = TextEditingController();

  @override
  void initState() {
    logic.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddConditionsController>(
      builder: (controller) {
        return Stack(
          children: [
            WillPopScope(
              onWillPop: () async {
                if (logic.controller.conditions != null && logic.controller.conditions!.levels.isNotEmpty) {
                  _showAlert(
                    context: context,
                    content: 'All your changes will be discarded.',
                    title: 'Are you sure,you want to go back?',
                    onOkayPressed: () {
                      logic.controller.reset();
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  );
                } else {
                  logic.controller.reset();
                  Navigator.pop(context);
                }
                return true;
              },
              child: Scaffold(
                backgroundColor: AppColors.background.lightBlue,
                appBar: buildAppBar(context) as PreferredSizeWidget?,
                floatingActionButton: buildFloatingActionButton(),
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 30),
                            SizedBox(
                              width: 103,
                              child: Text(
                                DateFormat('dd-MMM-yyyy').format(DateTime.now()),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ).paddingSymmetric(horizontal: 30),
                            const SizedBox(height: 30),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  ...controller.reefs.map(
                                    (e) => buildChip(
                                      onTap: () {
                                        logic.onChipChanged(e);
                                      },
                                      reefName: e,
                                    ),
                                  ),
                                ],
                              ).paddingSymmetric(horizontal: 27),
                            ),
                            const SizedBox(height: 30),
                            if (controller.conditions != null)
                              buildSurfaceConditionsExpansionWidget(controller).paddingSymmetric(horizontal: 27),
                            const SizedBox(height: 30),
                            if (controller.conditions != null && controller.conditions!.levels.isNotEmpty)
                              const Text(
                                'Water Conditions : ',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ).paddingSymmetric(horizontal: 27),
                            const SizedBox(height: 30),
                          ],
                        ),
                        SizedBox(
                          height: Screen.height - 373,
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (logic.getLevels.isEmpty)
                                  SizedBox(
                                    height: Screen.height / 3,
                                    width: Screen.width,
                                    child: const Center(
                                      child: Text(
                                        'Please add water conditions by clicking below',
                                      ),
                                    ),
                                  ),
                                if (controller.conditions != null && controller.conditions!.levels.isNotEmpty)
                                  ...controller.conditions!.levels.asMap().entries.map(
                                    (l) {
                                      if (l.value.reef == controller.selectedReef) {
                                        return buildDepthExpansionPanel(
                                          level: l.value,
                                          onDeletePressed: () {
                                            _showAlert(
                                              context: context,
                                              title: 'Are you you want to delete ?',
                                              content: 'Added information will be completely removed.',
                                              onOkayPressed: () {
                                                controller.conditions!.levels.removeAt(l.key);
                                                Navigator.pop(context);
                                                controller.update();
                                              },
                                            );
                                          },
                                          onChanged: (
                                            double fish,
                                            double visibility,
                                            double currents,
                                          ) {
                                            controller.conditions!.levels[l.key] =
                                                controller.conditions!.levels[l.key].copyWith(
                                              fish: fish.toInt(),
                                              visibility: visibility.toInt(),
                                              currents: currents.toInt(),
                                            );

                                            // log("$fish");
                                            // log("$visibility");
                                            // log("$currents");
                                          },
                                        ).paddingOnly(
                                          bottom: 12,
                                          left: 27,
                                          right: 27,
                                        );
                                      }
                                      return const SizedBox();
                                    },
                                  ),
                                const SizedBox(height: 50),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (controller.showLoading)
              Container(
                color: Colors.white.withOpacity(0.6),
                height: Screen.height,
                width: Screen.width,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  ///=====================UI==================///

  Widget buildSurfaceConditionsExpansionWidget(
    AddConditionsController controller,
  ) {
    return SurfaceConditionsExpansionWidget(
      key: UniqueKey(),
      surfaceConditions: controller.conditions!.surfaceConditions,
      onChanged: (List<SurfaceCondition> surfaceConditions) {
        controller.conditions = controller.conditions!.copyWith(surfaceConditions: surfaceConditions);
      },
      selectedReef: controller.selectedReef,
      disableTouches: false,
    );
  }

  Widget buildDepthExpansionPanel({
    required Level level,
    required Function onDeletePressed,
    required Function(double fish, double visibility, double currents) onChanged,
  }) {
    return DepthExpansionPanelWidget(
      level: level,
      onDeletePressed: onDeletePressed,
      onChanged: onChanged,
    );
  }

  Widget buildChip({required Function onTap, required String reefName}) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        height: 27,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: logic.controller.selectedReef == reefName ? AppColors.text.skyBlue : AppColors.text.white,
        ),
        child: Text(
          reefName,
          style: TextStyle(
            color: logic.controller.selectedReef == reefName ? AppColors.text.white : AppColors.text.black,
            fontSize: FontSize.small,
          ),
        ).paddingSymmetric(horizontal: 9, vertical: 5),
      ).paddingOnly(right: 13),
    );
  }

  Widget buildAppBar(context) {
    return AppBar(
      toolbarHeight: 70,
      leading: IconButton(
        color: AppColors.text.black,
        iconSize: 17,
        onPressed: () {
          _showAlert(
            context: context,
            content: 'All your changes will be discarded.',
            title: 'Are you sure,you want to go back?',
            onOkayPressed: () {
              logic.controller.reset();
              Navigator.pop(context);
              Navigator.pop(context);
            },
          );
        },
        icon: const Icon(Icons.arrow_back_ios),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            logic.onSavePressed(context);
          },
          child: Center(
            child: Container(
              height: 30,
              width: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black,
              ),
              child: const Center(
                child: Text(
                  'Save',
                  style: TextStyle(fontSize: FontSize.small, color: Colors.white),
                ),
              ),
            ).paddingOnly(right: 30),
          ),
        ),
      ],
      elevation: 0,
      backgroundColor: Colors.transparent,
    );
  }

  Future<void> _showAlert({
    required BuildContext context,
    required String title,
    required String content,
    required Function onOkayPressed,
  }) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          content: Text(
            content,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
          ),
          actions: <Widget>[
            Row(
              children: [
                AppButton.miniText(
                  text: 'Cancel',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                const Spacer(),
                AppButton.miniFlat(
                  text: 'Okay',
                  onTap: () {
                    onOkayPressed();
                  },
                ),
              ],
            ).paddingSymmetric(horizontal: 10),
          ],
        );
      },
    );
  }

  Widget buildFloatingActionButton() {
    return GetBuilder<AddConditionsController>(
      builder: (controller) {
        return FloatingActionButton(
          elevation: 0,
          backgroundColor: AppColors.background.black,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            Get.bottomSheet(
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Add Depth',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    AppTextField(
                      hintText: 'Add depth',
                      controller: depthTED,
                      keyboardType: TextInputType.number,
                      errorValidator: () {
                        return null;
                      },
                      validator: (firstName) {
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        AppButton.miniText(
                          text: 'Cancel',
                          onTap: () {
                            Navigator.pop(context);
                            depthTED.clear();
                          },
                        ),
                        const Spacer(),
                        AppButton.miniFlat(
                          text: 'Submit',
                          onTap: () {
                            if (logic.addLevel(
                              depth: depthTED.text,
                              reefName: controller.selectedReef,
                            )) {
                              depthTED.clear();
                              Navigator.pop(context);
                            } else {
                              showToast('Depth is already added in this site');
                            }
                          },
                          textColor: AppColors.text.white,
                        ),
                      ],
                    ),
                  ],
                ).paddingSymmetric(horizontal: 30, vertical: 30),
              ),
              barrierColor: Colors.black.withOpacity(0.3),
              isDismissible: false,
            );
          },
        );
      },
    );
  }
}
