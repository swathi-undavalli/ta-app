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

class GenerateOTPView extends StatefulWidget {
  const GenerateOTPView({super.key});

  static Route route() => MaterialPageRoute(
        builder: (context) => const GenerateOTPView(),
        settings: const RouteSettings(name: 'GenerateOTPView'),
      );

  @override
  State<GenerateOTPView> createState() => _GenerateOTPViewState();
}

class _GenerateOTPViewState extends State<GenerateOTPView> {
  final TextEditingController otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EquipmentProvider>().generateOTP();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background.black,
      appBar: const EquipmentAppBar(
        title: 'Generate OTP',
        description: 'Share OTP and verify rented equipment',
      ),
      body: EquipmentBody(
        child: Consumer<EquipmentProvider>(
          builder: (context, provider, child) {
            if (provider.firebaseTrackingId == null) {
              return const CircularProgressIndicator(
                color: Colors.black,
              ).center;
            }
            return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream:
                  FirebaseFirestore.instance.collection('otpValidation').doc(provider.firebaseTrackingId).snapshots(),
              builder: (context, snapshot) {
                var data = snapshot.data?.data();
                if (data == null) {
                  return const CircularProgressIndicator(
                    color: Colors.black,
                  ).center;
                }
                OtpValidation validation = OtpValidationMapper.fromMap(data);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: Screen.width,
                    ),
                    Text(
                      validation.otp,
                      style: const TextStyle(fontSize: 30),
                    ),
                    if (validation.pieces.isEmpty)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.black,
                          ).size(15, 15),
                          Spacing.w10,
                          const Text('OTP available for sharing'),
                        ],
                      )
                    else ...[
                      Text('Verify the equipment renting by ${validation.renterID}'),
                      Text(validation.pieces.toString()),
                      AppButton.flat(
                        text: 'Approve and close',
                        color: Colors.black,
                        textColor: Colors.white,
                        onTap: () async {
                          await provider.approveRentalAndAddLog(validation);
                          if (context.mounted) {
                            context.read<EquipmentProvider>().firebaseTrackingId = null;
                            Navigator.pop(context);
                          }
                        },
                      )
                    ]
                  ],
                );
              },
            );
          },
        ).paddingAll(20),
      ),
    );
  }
}
