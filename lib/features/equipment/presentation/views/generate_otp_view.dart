import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:provider/provider.dart';
import 'package:temple_adventures/features/equipment/presentation/views/submission_bottom_sheet.dart';
import 'package:temple_ui_tools/temple_ui_tools.dart';
import 'package:temple_ui_tools/utils/utils.dart';

import '../../../../core/constants/constants.dart';
import '../../../employees/model/employee.dart';
import '../../models/otp_validation_model.dart';
import '../../provider/equipment.provider.dart';
import '../widgets/banner_container.dart';
import '../widgets/equipment_app_bar.dart';
import '../widgets/equipment_body.dart';
import '../widgets/equipment_pieces_summary_table.dart';

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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EquipmentProvider>().fetchEmployees();
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
      body: Stack(
        children: [
          EquipmentBody(
            child: Consumer<EquipmentProvider>(
              builder: (context, provider, child) {
                if (provider.firebaseTrackingId == null) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(
                        color: Colors.black,
                      ).center,
                      Spacing.h32,
                      const Text(
                        'Generating OTP...',
                        style: itemsFontStyle,
                      ),
                    ],
                  );
                }
                return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('otpValidation')
                      .doc(provider.firebaseTrackingId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    var data = snapshot.data?.data();
                    if (data == null) {
                      return const CircularProgressIndicator(
                        color: Colors.black,
                      ).center;
                    }

                    OtpValidation validation = OtpValidationMapper.fromMap(data);
                    Employee? renter = provider.employees.firstWhereOrNull((e) => e.id == validation.renterID);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: Screen.width,
                        ),
                        Spacing.h24,
                        Container(
                          width: 195,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: const Color(0xffD1F8FF).withOpacity(0.34),
                          ),
                          child: Text(
                            validation.otp,
                            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold, letterSpacing: 10),
                          ).center,
                        ),
                        Spacing.h24,
                        if (validation.pieces.isEmpty)
                          RichText(
                            text: TextSpan(
                              text: '',
                              style: itemsFontStyle.copyWith(color: Colors.black),
                              children: [
                                WidgetSpan(
                                  child: const CircularProgressIndicator(color: Colors.black, strokeWidth: 2)
                                      .size(10, 10)
                                      .paddingOnly(bottom: 5, right: 10),
                                ),
                                const TextSpan(text: 'Share '),
                                const TextSpan(
                                  text: 'OTP ',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: appBlue),
                                ),
                                const TextSpan(text: 'to your diver buddy so you can '),
                                const TextSpan(
                                  text: 'verify',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: appBlue),
                                ),
                                const TextSpan(text: ' Equipment'),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          )
                        else ...[
                          RichText(
                            text: TextSpan(
                              text: '',
                              style: itemsFontStyle.copyWith(color: Colors.black),
                              children: [
                                const TextSpan(
                                  text: 'OTP ',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: appBlue),
                                ),
                                const TextSpan(text: 'shared with '),
                                TextSpan(
                                  text: '${renter?.name},',
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: appBlue),
                                ),
                                const TextSpan(text: ' Approve only after verification.'),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Spacing.h40,
                          EquipmentPiecesSummaryTable(validation.pieces),
                        ],
                      ],
                    );
                  },
                );
              },
            ).paddingAll(20),
          ),
          const _ApproveBanner(),
        ],
      ),
    );
  }
}

class _ApproveBanner extends StatelessWidget {
  const _ApproveBanner();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 30,
      child: Consumer<EquipmentProvider>(
        builder: (context, provider, child) {
          if (provider.firebaseTrackingId == null) return const SizedBox();
          return BannerContainer(
            height: 45,
            child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream:
                  FirebaseFirestore.instance.collection('otpValidation').doc(provider.firebaseTrackingId).snapshots(),
              builder: (context, snapshot) {
                if (provider.status == EquipmentStatus.loading) {
                  return const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ).size(15, 15);
                }

                if (snapshot.hasData) {
                  var d = snapshot.data?.data();
                  final validation = OtpValidationMapper.fromMap(d ?? {});
                  return InkWell(
                    onTap: () async {
                      if (validation.pieces.isEmpty) return;
                      SubmissionBottomSheet.show(context, validation.pieces, () async {
                        provider.status = EquipmentStatus.loading;
                        await provider.approveRentalAndAddLog(validation);
                        if (context.mounted) {
                          provider.firebaseTrackingId = null;
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }
                        provider.status = EquipmentStatus.loaded;
                      });
                    },
                    child: Text(
                      'Log & Approve',
                      style: TextStyle(
                        color: Colors.white.withOpacity(validation.pieces.isNotEmpty ? 1 : 0.5),
                        fontWeight: FontWeight.bold,
                      ),
                    ).center,
                  );
                }

                return const SizedBox();
              },
            ).center,
          );
        },
      ).center.width(Screen.width),
    );
  }
}
