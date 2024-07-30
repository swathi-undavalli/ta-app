import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/util/alignment_extensions.dart';
import '../../../../core/util/spacing_widgets.dart';
import '../../../../core/widgets/app_button.dart';

class FiltersBottomSheet extends StatefulWidget {
  const FiltersBottomSheet({
    super.key,
    required this.result,
  });
  final FiltersResult result;

  static Future<FiltersResult?> show(
    BuildContext context, {
    required FiltersResult result,
  }) async {
    var data = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      builder: (BuildContext context) {
        return FiltersBottomSheet(
          result: result,
        );
      },
    );
    return data as FiltersResult?;
  }

  @override
  State<FiltersBottomSheet> createState() => _FiltersBottomSheetState();
}

class _FiltersBottomSheetState extends State<FiltersBottomSheet> {
  late FiltersResult result;

  @override
  void initState() {
    super.initState();
    result = widget.result;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          Spacing.h10,
          buildTitleAndClose(),
          Spacing.h30,
          buildDateSelector(),
          buildCheckBoxWidget(
            title: 'Show ongoing certifications',
            value: result.showOngoingLogs ?? false,
            onChanged: (bool? value) {
              setState(() {
                result.showOngoingLogs = value ?? false;
              });
            },
          ),
          buildCheckBoxWidget(
            title: 'Show completed certifications',
            value: result.showCompletedLogs ?? false,
            onChanged: (bool? value) {
              setState(() {
                result.showCompletedLogs = value ?? false;
              });
            },
          ),
          Spacing.h50,
          buildClearAndApplyButtons(),
          Spacing.h50,
        ],
      ).scrollable.paddingSymmetric(horizontal: 30),
    );
  }

  Widget buildClearAndApplyButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppButton.miniFlat(
          onTap: () {
            setState(() {
              result.clear;
            });
          },
          text: 'Clear All',
        ),
        AppButton.miniFlat(
          onTap: onApply,
          text: 'Apply',
        ),
      ],
    );
  }

  Widget buildCheckBoxWidget({required String title, required bool value, required Function onChanged}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Checkbox(
          value: value,
          activeColor: AppColors.background.skyBlue,
          onChanged: (value) {
            onChanged(value);
          },
        ),
      ],
    );
  }

  Widget buildTitleAndClose() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Filters',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ).paddingOnly(top: 8),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: onApply,
        ),
      ],
    );
  }

  void onApply() {
    Navigator.pop(context, result);
  }

  Widget buildDateSelector() {
    return Row(
      children: [
        Text(
          'Select Date',
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        Spacing.w20,
        Text(
          (result.selectedDate != null) ? DateFormat('dd-MM-yyyy').format(result.selectedDate!) : '-',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.text.black,
            fontWeight: FontWeight.bold,
            fontFamily: AppFonts.nunito,
          ),
        ),
        const Spacer(),
        IconButton(
          splashRadius: 20,
          icon: const Icon(
            Icons.calendar_today_outlined,
            size: 20,
          ),
          onPressed: () {
            showDateSelector();
          },
        ),
      ],
    );
  }

  void showDateSelector() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: result.selectedDate,
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
      setState(() {
        result.selectedDate = date;
      });
    }
  }
}

class FiltersResult {
  DateTime? selectedDate;
  bool? showOngoingLogs;
  bool? showCompletedLogs;

  FiltersResult({
    this.selectedDate,
    this.showCompletedLogs,
    this.showOngoingLogs,
  });

  get clear {
    selectedDate = null;
    showCompletedLogs = false;
    showOngoingLogs = false;
  }
}
