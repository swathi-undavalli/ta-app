import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:temple_ui_tools/temple_ui_tools.dart';
import 'package:temple_ui_tools/utils/utils.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/app_button.dart';
import '../../models/otp_validation_model.dart';
import '../../provider/equipment.provider.dart';
import '../widgets/equipment_app_bar.dart';
import '../widgets/equipment_body.dart';

class VerifyOTPView extends StatefulWidget {
  const VerifyOTPView({super.key});

  static Route route() => MaterialPageRoute(
        builder: (context) => const VerifyOTPView(),
        settings: const RouteSettings(name: 'VerifyOTPView'),
      );

  @override
  State<VerifyOTPView> createState() => _VerifyOTPViewState();
}

class _VerifyOTPViewState extends State<VerifyOTPView> {
  final TextEditingController otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background.black,
      appBar: const EquipmentAppBar(
        title: 'Verify OTP',
        description: 'Ask any diver to generate Equipment OTP',
      ),
      body: EquipmentBody(
        child: Consumer<EquipmentProvider>(
          builder: (context, provider, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'You are taking ${provider.selectedPieces.length} items',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Spacing.h18,
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...provider.selectedItems.map(
                      (item) {
                        final data = provider.selectedPieces.where((pieces) => pieces.equipmentItemID == item.id);
                        return _TitleValuePairs(title: item.name, value: '${data.length}');
                      },
                    ),
                  ],
                ).centerR,
                Spacing.h50,
                const Spacer(),
                TextField(
                  controller: otpController,
                  decoration: const InputDecoration(
                    hintText: 'Enter OTP 😊',
                  ),
                  style: const TextStyle(fontSize: 30),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                ).width(150).center,
                const Spacer(),
                if (provider.firebaseTrackingId == null)
                  AppButton.flat(
                    text: 'Verify OTP',
                    color: Colors.black,
                    textColor: Colors.white,
                    onTap: () {
                      provider.verifyOTP(otpController.text);
                    },
                  )
                else
                  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('otpValidation')
                        .doc(provider.firebaseTrackingId)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var d = snapshot.data?.data();
                        final validation = OtpValidationMapper.fromMap(d ?? {});
                        if (validation.approve == false) return const CircularProgressIndicator();
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.verified,
                                  color: Colors.green,
                                ),
                                Spacing.w8,
                                const Text(
                                  'OTP verification done by Kamesh',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            AppButton.flat(
                              textColor: Colors.white,
                              color: Colors.black,
                              text: 'Close',
                              onTap: () {
                                provider.resetSelections();
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                            )
                          ],
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                const Spacer(),
              ],
            );
          },
        ).paddingAll(20),
      ),
    );
  }
}

class _TitleValuePairs extends StatelessWidget {
  final String title, value;

  const _TitleValuePairs({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: Screen.width / 3,
          child: Text(
            '$title :',
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
              letterSpacing: 0.3,
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
          ),
        ),
        Spacing.w20,
        Text(
          value,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
            height: 1.3,
          ),
        ),
      ],
    ).paddingOnly(bottom: 5);
  }
}
