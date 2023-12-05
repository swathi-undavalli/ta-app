import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/constants.dart';
import '../../../core/util/alignment_extensions.dart';
import '../../../core/util/spacing_widgets.dart';
import '../controller/conditions_controller.dart';
import '../models/conditions_model.dart';
import '../widgets/depth_expansion_panel_widget.dart';
import '../widgets/surface_conditions_expansion_panel.dart';

class ConditionsScreen extends StatefulWidget {
  const ConditionsScreen({Key? key}) : super(key: key);

  @override
  State<ConditionsScreen> createState() => _ConditionsScreenState();
}

class _ConditionsScreenState extends State<ConditionsScreen> {
  final ConditionsLogic logic = ConditionsLogic();

  @override
  void initState() {
    logic.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          floatingActionButton: FloatingActionButton(
            elevation: 0,
            onPressed: () {
              logic.onFloatingActionButtonPressed();
            },
            backgroundColor: AppColors.background.black,
            child: const Icon(Icons.add),
          ),
          body: SafeArea(
            child: GetBuilder<ConditionsController>(
              builder: (controller) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            buildButton(
                              onTap: () {
                                logic.onDateChanged(controller.selectedDate.subtract(const Duration(days: 1)));
                              },
                              icon: Icons.arrow_back_ios_rounded,
                            ),
                            Spacing.w20,
                            SizedBox(
                              width: 103,
                              child: Text(
                                DateFormat('dd-MMM-yyyy').format(controller.selectedDate),
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ),
                            Spacing.w20,
                            buildButton(
                              onTap: () {
                                logic.onDateChanged(controller.selectedDate.add(const Duration(days: 1)));
                              },
                              icon: Icons.arrow_forward_ios_rounded,
                            ),
                            const Spacer(),
                            IconButton(
                              splashRadius: 20,
                              onPressed: () {
                                selectDate(context);
                              },
                              icon: const Icon(
                                Icons.calendar_today_outlined,
                                size: 17,
                              ),
                            ),
                          ],
                        ).paddingSymmetric(horizontal: 32),
                        const SizedBox(height: 20),
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
                              )
                            ],
                          ).paddingSymmetric(horizontal: 27),
                        ),
                        const SizedBox(height: 25),
                      ],
                    ),
                    SizedBox(
                      height: Get.height - 240,
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            if (controller.conditions != null)
                              SurfaceConditionsExpansionWidget(
                                key: UniqueKey(),
                                disableTouches: true,
                                surfaceConditions: controller.conditions!.surfaceConditions,
                                selectedReef: controller.selectedReef,
                                onChanged: (List<SurfaceCondition> surfaceConditions) {},
                              ).paddingSymmetric(horizontal: 27),
                            const SizedBox(height: 25),
                            Container(
                              width: Get.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white,
                              ),
                              child: buildGraph().paddingSymmetric(vertical: 20),
                            ).paddingSymmetric(horizontal: 20),
                            const SizedBox(height: 22),
                          ],
                        ),
                      ),
                    ),
                  ],
                ).scrollable;
              },
            ),
          ),
        ),
        GetBuilder<ConditionsController>(
          builder: (controller) {
            if (controller.showLoading) {
              return Container(
                height: Get.height,
                width: Get.width,
                color: Colors.white70,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }

  ///=========================UI=======================///

  Widget buildButton({required Function onTap, required IconData icon}) {
    return SizedBox(
      height: 20,
      width: 20,
      child: IconButton(
        splashRadius: 30,
        padding: EdgeInsets.zero,
        onPressed: () {
          onTap();
        },
        icon: Icon(
          icon,
          color: Colors.black,
          size: 14,
        ),
      ),
    );
  }

  Widget buildSurfaceConditions({required String title, required String text}) {
    return Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(
            title,
            style: const TextStyle(fontSize: FontSize.small, fontWeight: FontWeight.bold),
          ),
        ),
        Text(
          ' :   $text',
          style: const TextStyle(fontSize: FontSize.small),
        ),
      ],
    ).paddingSymmetric(horizontal: 27, vertical: 5);
  }

  List<String> getReefs(ConditionsController controller) {
    return controller.reefs;
  }

  selectDate(BuildContext context) async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: logic.controller.selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2090),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.text.black,
              onPrimary: Colors.white, // header text color
              onSurface: AppColors.text.black, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                textStyle: TextStyle(fontWeight: FontWeight.w500, color: AppColors.text.black), // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      logic.onDateChanged(date);
    }
  }

  Widget buildGraph() {
    if (logic.getLevels.isEmpty) {
      return const SizedBox(height: 100, child: Center(child: Text('No entries found in selected reef')));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: logic.getLevels.map((e) => buildLevel(e)).toList(),
    );
  }

  Widget buildLevel(Level level) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 40,
          child: Center(
            child: Text(
              '${level.depth} m',
            ).paddingOnly(right: 5),
          ),
        ),
        Container(
          color: Colors.black.withOpacity(0.3),
          width: 1,
          height: 120,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  children: List.generate(
                    5,
                    (index) => Container(
                      color: Colors.black.withOpacity(0.05),
                      width: 3,
                      height: 1,
                    ).paddingOnly(top: 6, bottom: 6),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildSlider(level.fish, SliderType.fishLife),
                    buildSlider(level.visibility, SliderType.visibility),
                    buildSlider(level.currents, SliderType.currents),
                  ],
                ),
              ],
            ),
            Container(
              color: Colors.black.withOpacity(0.05),
              width: 250,
              height: 1,
            ).paddingOnly(top: 10),
            RichText(
              text: TextSpan(
                text: level.updatedBy,
                style: TextStyle(
                  fontSize: 9,
                  color: AppColors.text.darkgrey,
                  fontFamily: AppFonts.nunito,
                ),
                children: <TextSpan>[
                  TextSpan(
                    style: TextStyle(color: AppColors.text.darkgrey, fontWeight: FontWeight.w600),
                    text: " (${DateFormat("hh : mm a").format(level.updatedAt)})",
                  ),
                ],
              ),
            ).paddingOnly(left: 5, top: 5),
          ],
        ),
      ],
    ).paddingSymmetric(horizontal: 5);
  }

  Widget buildSlider(int pos, SliderType type) {
    return Row(
      children: [
        SizedBox(
          width: Get.width - 197,
          child: SliderTheme(
            data: const SliderThemeData(
              trackHeight: 3,
              thumbShape: RoundSliderThumbShape(
                enabledThumbRadius: 5,
                pressedElevation: 1,
              ),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 12.0),
            ),
            child: Slider(
              value: pos * 1.0,
              onChanged: (double value) {},
              activeColor: AppColors.text.grey.withOpacity(0.5),
              inactiveColor: AppColors.text.grey.withOpacity(0.5),
              thumbColor: AppColors.text.black,
              divisions: 5,
              min: 0,
              max: 5,
            ),
          ),
        ),
        Text(getEmoji(type)).paddingOnly(right: 5),
        SizedBox(
          width: 80,
          child: Text(
            getStatus(pos, type),
            style: TextStyle(
              fontSize: 12,
              color: getColor(pos * 1.0, type == SliderType.currents),
            ),
          ),
        ),
      ],
    );
  }

  String getStatus(int pos, SliderType type) {
    switch (type) {
      case SliderType.fishLife:
        if (pos == 0) return 'No fish';
        if (pos == 1) return 'Scattered fish';
        if (pos == 2) return 'Lots of fish';
        if (pos == 3) return 'Rare fish life';
        return 'Whale shark';
      case SliderType.visibility:
        if (pos == 0) return "Can't see computer";
        if (pos == 1) return "Can't see dive buddy";
        if (pos == 2) return 'Can see reef';
        if (pos == 3) return 'Can see boat';
        return 'Can see everything';
      case SliderType.currents:
        if (pos == 0) return 'No current';
        if (pos == 1) return 'Mild current';
        if (pos == 2) return 'Moderate current';
        if (pos == 3) return 'Strong current';
        return 'Where is my passport ?';
    }
  }

  String getEmoji(SliderType type) {
    switch (type) {
      case SliderType.fishLife:
        return '🐠';
      case SliderType.visibility:
        return '👀';
      case SliderType.currents:
        return '🌊';
    }
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
}
