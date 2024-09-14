import 'package:flutter/material.dart';
import 'package:flutter_emoji_feedback/flutter_emoji_feedback.dart';
import 'package:get/get.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/util/alignment_extensions.dart';
import '../../../../core/util/spacing_widgets.dart';
import '../../../../core/widgets/app_button.dart';

class RoasterTimeEditorBs extends StatefulWidget {
  const RoasterTimeEditorBs({super.key, x});

  static void show(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (context) {
        return const RoasterTimeEditorBs();
      },
    );
  }

  @override
  State<RoasterTimeEditorBs> createState() => _RoasterTimeEditorBsState();
}

class _RoasterTimeEditorBsState extends State<RoasterTimeEditorBs> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 30,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: AppColors.background.lightBlue,
      ),
      child: Column(
        children: [
          buildHeader(),
          Spacing.h15,
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
                onTap: () async {
                  setState(() {});

                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ).paddingSymmetric(horizontal: 20),
          Spacing.h30,
        ],
      ).scrollable,
    );
  }

  Widget buildEmojiFeedback({
    required String title,
    required int? rating,
    required Function onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 12),
        ),
        Spacing.h15,
        EmojiFeedback(
          animDuration: const Duration(milliseconds: 300),
          emojiPreset: [
            classicEmojiPreset.first,
            classicEmojiPreset[2],
            classicEmojiPreset.last,
          ],
          curve: Curves.bounceIn,
          inactiveElementScale: .5,
          elementSize: 70,
          showLabel: false,
          rating: rating,
          onChanged: (value) {
            onChanged(value);
          },
        ),
      ],
    ).paddingSymmetric(horizontal: 20);
  }

  Widget buildSwitch({
    required String text,
    Function? onChanged,
    required bool switchValue,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black,
            ),
          ),
        ),
        Switch(
          value: switchValue,
          onChanged: onChanged as void Function(bool)?,
          activeColor: AppColors.text.skyBlue,
          inactiveThumbColor: AppColors.text.grey,
        ),
      ],
    ).paddingSymmetric(horizontal: 20);
  }

  Widget buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Change Times',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ).paddingOnly(top: 8),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () async {
            Navigator.pop(context);
          },
        ),
      ],
    ).paddingSymmetric(horizontal: 20);
  }
}
