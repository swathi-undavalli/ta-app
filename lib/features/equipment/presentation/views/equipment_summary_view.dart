import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:temple_ui_tools/temple_ui_tools.dart';
import 'package:temple_ui_tools/utils/utils.dart';

import '../../../../core/constants/constants.dart';
import '../../models/equipment_model.dart';
import '../../provider/equipment.provider.dart';
import '../widgets/banner_container.dart';
import '../widgets/equipment_app_bar.dart';
import '../widgets/equipment_body.dart';
import 'manage_pieces_bottom_sheet.dart';
import 'verify_otp_view.dart';

class EquipmentSummaryView extends StatefulWidget {
  const EquipmentSummaryView({super.key});

  static Route route() => MaterialPageRoute(
        builder: (context) => const EquipmentSummaryView(),
        settings: const RouteSettings(name: 'EquipmentSummaryView'),
      );

  @override
  State<EquipmentSummaryView> createState() => _EquipmentSummaryViewState();
}

class _EquipmentSummaryViewState extends State<EquipmentSummaryView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background.black,
      appBar: const EquipmentAppBar(
        title: 'Summary',
        description: 'Please verify your selected items',
      ),
      body: Stack(
        children: [
          EquipmentBody(
            child: Consumer<EquipmentProvider>(
              builder: (context, provider, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Spacing.h20,
                    ...provider.selectedItems.map((item) => _EquipmentCard(item)),
                  ],
                );
              },
            ).paddingHorizontal(16).scrollable,
          ),
          const _VerifyWithOTPBanner(),
        ],
      ),
    );
  }
}

class _EquipmentCard extends StatelessWidget {
  final EquipmentItem item;

  const _EquipmentCard(this.item);

  @override
  Widget build(BuildContext context) {
    final provider = context.read<EquipmentProvider>();

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(8),
      ),
      width: Screen.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xffB3B3B3), width: 0.5),
                  color: Colors.white,
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(item.photo ?? placeHolderImage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Spacing.w16,
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    item.category.name,
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color(0xff6B6868).withOpacity(0.8),
                    ),
                  ),
                  Consumer<EquipmentProvider>(
                    builder: (context, provider, child) {
                      int itemsCount = provider.selectedPieces.where((e) => (e.equipmentItemID == item.id)).length;
                      if (itemsCount == 0) {
                        return InkWell(
                          onTap: () {
                            ManagePiecesBottomSheet.show(context, item);
                          },
                          child: Text(
                            'Add',
                            style: TextStyle(
                              color: AppColors.text.skyBlue,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        );
                      }

                      return RichText(
                        text: TextSpan(
                          text: 'Total items : ',
                          style: TextStyle(
                            fontSize: 14,
                            color: const Color(0xff6B6868).withOpacity(0.8),
                            fontFamily: AppFonts.nunito,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: itemsCount.toString(),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  provider.removeItemAndPieces(item);
                  if (provider.selectedItems.isEmpty) Navigator.pop(context);
                },
                icon: const Icon(Icons.close),
              ).center.height(70),
            ],
          ),
          _EquipmentPieces(item),
        ],
      ).paddingAll(8),
    ).paddingOnly(bottom: 16);
  }
}

class _EquipmentPieces extends StatelessWidget {
  final EquipmentItem item;

  const _EquipmentPieces(this.item);

  @override
  Widget build(BuildContext context) {
    return Consumer<EquipmentProvider>(
      builder: (context, provider, child) {
        Iterable<String> selectedPieces =
            provider.selectedPieces.where((piece) => piece.equipmentItemID == item.id).map((p) => p.assignedID);

        if (selectedPieces.isEmpty) return const SizedBox();

        return Container(
          width: Screen.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey.shade200,
          ),
          child: Row(
            children: [
              Text(
                selectedPieces.join(', '),
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ).paddingOnly(left: 16),
              const Spacer(),
              TextButton(
                onPressed: () async {
                  await ManagePiecesBottomSheet.show(context, item);
                },
                child: Text(
                  'Manage',
                  style: TextStyle(
                    color: AppColors.text.skyBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ).paddingOnly(right: 10),
            ],
          ),
        ).paddingOnly(top: 8);
      },
    );
  }
}

class _VerifyWithOTPBanner extends StatelessWidget {
  const _VerifyWithOTPBanner();

  @override
  Widget build(BuildContext context) {
    return Consumer<EquipmentProvider>(
      builder: (context, provider, child) {
        final selectedItems = provider.selectedItems.map((item) => item.id).toSet().toList();
        final selectedPieceIDs = provider.selectedPieces.map((item) => item.equipmentItemID).toSet().toList();

        if (selectedItems.length != selectedPieceIDs.length) return const SizedBox();

        return Positioned(
          bottom: 40,
          child: BannerContainer(
            height: 45,
            child: Row(
              children: [
                RichText(
                  text: TextSpan(
                    text: '${provider.selectedPieces.length} ',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: AppFonts.nunito,
                      fontSize: 12,
                    ),
                    children: const <TextSpan>[
                      TextSpan(
                        text: 'Equipment selected',
                        style: TextStyle(fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    // TODO: Ask for confirmation before going there
                    Navigator.push(context, VerifyOTPView.route());
                  },
                  child: Text(
                    'Verify with OTP',
                    style: TextStyle(
                      color: AppColors.text.skyBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ).paddingHorizontal(16),
          ).center.width(Screen.width),
        );
      },
    );
  }
}
