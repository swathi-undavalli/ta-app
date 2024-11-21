import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji_feedback/flutter_emoji_feedback.dart';
import 'package:get/get.dart';
import 'package:temple_ui_tools/styling/alignment_extensions.dart';
import 'package:temple_ui_tools/styling/spacing_widgets.dart';
import 'package:temple_ui_tools/utils/utils.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../bookings/models/booking_model.dart';
import '../../../bookings/presentation/widgets/app_text_fields.dart';
import '../../models/customer_feedback.dart';
import '../../models/roaster.dart';

class CustomerFeedbackBottomSheet extends StatefulWidget {
  const CustomerFeedbackBottomSheet({
    super.key,
    required this.bookingModel,
    required this.paxIndex,
    required this.customerFeedback,
  });

  final Booking bookingModel;
  final int paxIndex;
  final CustomerFeedback? customerFeedback;

  static show(
    BuildContext context, {
    required Booking bookingModel,
    required int paxIndex,
    required CustomerFeedback? customerFeedback,
  }) async {
    CustomerFeedback? data = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (context) {
        return CustomerFeedbackBottomSheet(
          bookingModel: bookingModel,
          paxIndex: paxIndex,
          customerFeedback: customerFeedback,
        );
      },
    );
    return data;
  }

  @override
  State<CustomerFeedbackBottomSheet> createState() => _CustomerFeedbackBottomSheetState();
}

class _CustomerFeedbackBottomSheetState extends State<CustomerFeedbackBottomSheet> {
  TextEditingController reviewTED = TextEditingController();
  bool showLoading = false;
  bool knowsSwimming = false;
  bool interestedOwc = false;
  int instructorRating = 3;
  int equipmentRating = 3;
  int experienceRating = 3;
  late Booking booking;
  CustomerFeedback? customerFeedback;

  @override
  void initState() {
    super.initState();
    booking = widget.bookingModel;

    customerFeedback = widget.customerFeedback;
    if (customerFeedback != null) {
      knowsSwimming = customerFeedback!.knowsSwimming!;
      interestedOwc = customerFeedback!.interestedOwc!;
      instructorRating = customerFeedback!.instructorFeedback!;
      equipmentRating = customerFeedback!.equipmentFeedback!;
      experienceRating = customerFeedback!.experienceFeedback!;
      reviewTED.text = customerFeedback!.feedback!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Screen.height,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 30,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: AppColors.background.lightBlue,
      ),
      child: (!showLoading)
          ? Column(
              children: [
                Spacing.h20,
                buildHeader(),
                Spacing.h15,
                buildSwitch(
                  text: 'Knows Swimming',
                  switchValue: knowsSwimming,
                  onChanged: (value) {
                    knowsSwimming = value;
                    setState(() {});
                  },
                ),
                Spacing.h15,
                buildSwitch(
                  text: 'Interested in OWC',
                  switchValue: interestedOwc,
                  onChanged: (value) {
                    interestedOwc = value;
                    setState(() {});
                  },
                ),
                Spacing.h20,
                buildEmojiFeedback(
                  title: 'Instructor Feedback',
                  rating: instructorRating,
                  onChanged: (value) {
                    instructorRating = value;
                    setState(() {});
                  },
                ),
                Spacing.h20,
                buildEmojiFeedback(
                  title: 'Equipment Feedback',
                  rating: equipmentRating,
                  onChanged: (value) {
                    equipmentRating = value;
                    setState(() {});
                  },
                ),
                Spacing.h20,
                buildEmojiFeedback(
                  title: 'Experience Feedback',
                  rating: experienceRating,
                  onChanged: (value) {
                    experienceRating = value;
                    setState(() {});
                  },
                ),
                AppTextField(
                  hintText: 'Feedback',
                  controller: reviewTED,
                  maxLines: 3,
                  validator: (name) {
                    return name;
                  },
                ),
                Spacing.h30,
                Row(
                  children: [
                    AppButton.miniText(
                      text: 'Cancel',
                      onTap: () {
                        Navigator.pop(context, widget.customerFeedback);
                      },
                    ),
                    const Spacer(),
                    AppButton.miniFlat(
                      text: 'Submit',
                      onTap: () async {
                        setState(() {
                          showLoading = true;
                        });
                        var pax = booking.pax![widget.paxIndex];

                        Roaster? roaster = Roaster.fromJson(pax['roaster'] ?? {});

                        customerFeedback = CustomerFeedback(
                          knowsSwimming: knowsSwimming,
                          interestedOwc: interestedOwc,
                          instructorFeedback: instructorRating,
                          equipmentFeedback: equipmentRating,
                          experienceFeedback: experienceRating,
                          feedback: reviewTED.text,
                        );

                        roaster = roaster.copyWith(
                          customerFeedback: customerFeedback,
                        );

                        pax['roaster'] = roaster.toJson();

                        await FirebaseFirestore.instance.collection('bookings').doc(booking.id).set(booking.toMap());
                        setState(() {
                          showLoading = false;
                        });
                        if (context.mounted) {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ],
                ).paddingSymmetric(horizontal: 20),
                Spacing.h50,
              ],
            ).scrollable
          : Container(
              height: Screen.height / 2,
              color: Colors.white,
              child: const CircularProgressIndicator(
                color: Colors.black,
                backgroundColor: Colors.grey,
              ).center,
            ),
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
          "How's is your dive",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ).paddingOnly(top: 8),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () async {
            Navigator.pop(context, widget.customerFeedback);
          },
        ),
      ],
    ).paddingSymmetric(horizontal: 20);
  }

  Widget buildShowLoading() {
    if (showLoading) {
      return Material(
        color: Colors.transparent,
        child: Container(
          color: Colors.black54,
          height: Screen.height,
          width: Screen.width,
          child: const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
