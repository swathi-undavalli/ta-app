import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
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

//#region Constants
final _defaultPinTheme = PinTheme(
  width: 56,
  height: 56,
  textStyle: const TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
  decoration: BoxDecoration(
    border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
    borderRadius: BorderRadius.circular(20),
  ),
);

final _focusedPinTheme = _defaultPinTheme.copyDecorationWith(
  border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
  borderRadius: BorderRadius.circular(8),
);

final _submittedPinTheme = _defaultPinTheme.copyWith(
  decoration: _defaultPinTheme.decoration?.copyWith(
    color: const Color.fromRGBO(234, 239, 243, 1),
  ),
);
//#endregion Constants

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EquipmentProvider>().fetchEmployees();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.background.black,
        appBar: const EquipmentAppBar(
          title: 'Verify OTP',
          description: 'Ask any diver to generate Equipment OTP',
          hideBackButton: true,
        ),
        body: Stack(
          children: [
            EquipmentBody(
              child: Consumer<EquipmentProvider>(
                builder: (context, provider, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      EquipmentPiecesSummaryTable(provider.selectedPieces),
                      Spacing.h36,
                      RichText(
                        text: TextSpan(
                          text: 'Above information needs to be verified by any ',
                          style: itemsFontStyle.copyWith(color: Colors.black),
                          children: const <TextSpan>[
                            TextSpan(text: 'Diver', style: TextStyle(fontWeight: FontWeight.bold, color: appBlue)),
                            TextSpan(text: ', ask your diver buddy to share '),
                            TextSpan(text: 'OTP', style: TextStyle(fontWeight: FontWeight.bold, color: appBlue)),
                            TextSpan(text: ' and start the verification process in their app.'),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Spacing.h48,
                      Pinput(
                        onCompleted: (pin) => provider.verifyOTP(pin),
                        onChanged: provider.onOTPChange,
                        focusedPinTheme: _focusedPinTheme,
                        submittedPinTheme: _submittedPinTheme,
                        keyboardType: const TextInputType.numberWithOptions(),
                      ),
                      if (provider.error != null)
                        Text(
                          provider.error!,
                          style: const TextStyle(color: Colors.red),
                        ).paddingOnly(top: 16),
                      if (provider.firebaseTrackingId != null)
                        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                          stream: FirebaseFirestore.instance
                              .collection('otpValidation')
                              .doc(provider.firebaseTrackingId)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              var d = snapshot.data?.data();
                              final validation = OtpValidationMapper.fromMap(d ?? {});
                              Employee? employee = provider.employees.firstWhereOrNull(
                                (employee) => employee.id == validation.approverID,
                              );
                              return _VerificationText(validation: validation, employee: employee);
                            }
                            return const SizedBox();
                          },
                        ),
                    ],
                  );
                },
              ).paddingAll(20),
            ),
            if (MediaQuery.of(context).viewInsets.bottom == 0) const _VerifyWithOTPBanner(),
          ],
        ),
      ),
    );
  }
}

class _VerificationText extends StatelessWidget {
  final OtpValidation validation;
  final Employee? employee;

  const _VerificationText({required this.validation, this.employee});

  @override
  Widget build(BuildContext context) {
    if (validation.approve == true) {
      return RichText(
        text: TextSpan(
          text: '',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontFamily: AppFonts.nunito,
            fontWeight: FontWeight.bold,
          ),
          children: [
            WidgetSpan(
              child: const Icon(
                Icons.verified,
                color: Colors.green,
              ).paddingOnly(right: 10),
            ),
            const TextSpan(
              text: 'Equipment is verified by ',
            ),
            TextSpan(
              text: '${employee?.name ?? validation.approverID} ',
              style: const TextStyle(
                color: appBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ).paddingOnly(top: 33);
    }

    return RichText(
      text: TextSpan(
        text: '${employee?.name ?? validation.approverID} ',
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: appBlue, fontFamily: AppFonts.nunito),
        children: const <TextSpan>[
          TextSpan(
              text: 'is verifying your Equipment',
              style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black)),
        ],
      ),
      textAlign: TextAlign.center,
    ).paddingOnly(top: 33);
  }
}

class _VerifyWithOTPBanner extends StatelessWidget {
  const _VerifyWithOTPBanner();

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).viewInsets.bottom != 0) return const SizedBox();

    return Consumer<EquipmentProvider>(
      builder: (context, provider, child) {
        return Positioned(
          bottom: 30,
          child: BannerContainer(
            height: 45,
            child: InkWell(
              onTap: () {
                if (provider.firebaseTrackingId == null && provider.otp?.length == 4) {
                  provider.verifyOTP(provider.otp!);
                }
              },
              child: (provider.firebaseTrackingId == null
                  ? Text(
                      'Verify OTP',
                      style: TextStyle(
                        color: Colors.white.withOpacity(
                          (provider.otp?.length == 4) ? 1 : 0.5,
                        ),
                        fontWeight: FontWeight.bold,
                      ),
                    ).center
                  : StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection('otpValidation')
                          .doc(provider.firebaseTrackingId)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var d = snapshot.data?.data();
                          final validation = OtpValidationMapper.fromMap(d ?? {});
                          if (validation.approve == true) {
                            return InkWell(
                              onTap: () {
                                provider.resetSelections();
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Log & Close',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ).center,
                            );
                          }
                        }
                        return const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ).size(15, 15);
                      },
                    ).center),
            ),
          ).center.width(Screen.width),
        );
      },
    );
  }
}
