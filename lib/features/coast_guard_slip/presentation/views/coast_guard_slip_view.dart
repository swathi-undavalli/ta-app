import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/util/alignment_extensions.dart';
import '../../../../core/util/spacing_widgets.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/back_navigation_icon.dart';
import '../../controller/coast_guard_slip_controller.dart';

class CoastGuardSlipView extends StatefulWidget {
  const CoastGuardSlipView({Key? key}) : super(key: key);
  static const String id = 'CoastGuardSlipView';

  @override
  State<CoastGuardSlipView> createState() => _CoastGuardSlipViewState();
}

class _CoastGuardSlipViewState extends State<CoastGuardSlipView> {
  final CoastGuardSlipLogic logic = CoastGuardSlipLogic();

  @override
  void initState() {
    logic.init().whenComplete(() => logic.controller.update());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: SafeArea(
        child: GetBuilder<CoastGuardSlipController>(
          builder: (controller) {
            return Column(
              children: [
                buildCalenderWidget(controller, context),
                Spacing.h20,
                if (controller.showLoading)
                  const CircularProgressIndicator(
                    color: Colors.white,
                    backgroundColor: Colors.black,
                  ).center
                else
                  AppButton.flat(
                    onTap: logic.generateCoastGuardSlip,
                    text: 'Generate',
                    color: Colors.black,
                    textColor: Colors.white,
                  ).center,
              ],
            ).paddingSymmetric(horizontal: 20, vertical: 20).scrollable;
          },
        ),
      ),
    );
  }

  Widget buildCalenderWidget(CoastGuardSlipController controller, BuildContext context) {
    return Row(
      children: [
        buildButton(
          onTap: () {
            logic.onDateChanged(
              controller.selectedDate.subtract(const Duration(days: 1)),
            );
          },
          icon: Icons.arrow_back_ios_rounded,
        ),
        Spacing.w15,
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            DateFormat('dd-MM-yyyy').format(controller.selectedDate),
            style: TextStyle(
              fontSize: 16,
              color: AppColors.text.black,
              fontWeight: FontWeight.bold,
              fontFamily: AppFonts.nunito,
            ),
          ),
        ),
        Spacing.w15,
        Text(
          DateFormat('EEEE').format(controller.selectedDate),
          style: TextStyle(
            fontSize: 13,
            color: AppColors.text.black,
            fontFamily: AppFonts.nunito,
            fontWeight: FontWeight.w600,
          ),
        ),
        Spacing.w15,
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
            showDateSelector(context);
          },
          icon: const Icon(
            Icons.calendar_today_outlined,
            size: 17,
          ),
        ),
      ],
    );
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

  Widget buildChip({
    required Function onTap,
    required Color color,
    required String title,
  }) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        height: 32,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: const TextStyle(color: Colors.black, fontSize: 12),
          textAlign: TextAlign.center,
        ).paddingSymmetric(horizontal: 10, vertical: 7),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      toolbarHeight: 70,
      centerTitle: true,
      title: Text(
        'Coast Guard Slip',
        style: TextStyle(
          color: AppColors.text.black,
          fontSize: 20,
          fontFamily: AppFonts.nunito,
          fontWeight: FontWeight.normal,
          letterSpacing: 1.2,
        ),
      ),
      leading: const BackNavigationIcon(),
      elevation: 0,
      backgroundColor: AppColors.background.white,
    );
  }

  showDateSelector(BuildContext context) async {
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
                textStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: AppColors.text.black,
                ), // button text color
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
}
