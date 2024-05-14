import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/util/spacing_widgets.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../controller/roaster_controller.dart';

class RoasterView extends StatefulWidget {
  const RoasterView({super.key});
  static const String id = 'RoasterView';
  @override
  State<RoasterView> createState() => _RoasterViewState();
}

class _RoasterViewState extends State<RoasterView> {
  final RoasterLogic logic = RoasterLogic();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background.lightBlue,
      appBar: const AppBarWidget(heading: 'Roaster'),
      body: SafeArea(
        child: GetBuilder<RoasterController>(
          builder: (controller) {
            return Column(
              children: [
                Spacing.h20,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    buildButton(
                      onTap: () {
                        logic.onDateChanged(
                          controller.selectedDate.subtract(const Duration(days: 1)),
                        );
                      },
                      icon: Icons.arrow_back_ios_rounded,
                    ),
                    Spacing.w20,
                    Text(
                      DateFormat('dd-MMM-yyyy').format(controller.selectedDate),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Spacing.w20,
                    buildButton(
                      onTap: () {
                        logic.onDateChanged(
                          controller.selectedDate.add(const Duration(days: 1)),
                        );
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
                ),

              ],
            ).paddingSymmetric(horizontal: 20);
          },
        ),
      ),
    );
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
                foregroundColor: AppColors.text.black,
                textStyle: const TextStyle(fontWeight: FontWeight.w500), // button text color
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
}
