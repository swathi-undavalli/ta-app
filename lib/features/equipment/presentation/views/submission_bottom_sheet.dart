import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:temple_ui_tools/temple_ui_tools.dart';
import 'package:temple_ui_tools/utils/utils.dart';

import '../../../../core/constants/constants.dart';
import '../../models/equipment_model.dart';
import '../../provider/equipment.provider.dart';
import '../widgets/banner_container.dart';

class SubmissionBottomSheet extends StatefulWidget {
  final List<EquipmentPiece> pieces;
  final Function onSuccess;

  const SubmissionBottomSheet({
    super.key,
    required this.onSuccess,
    required this.pieces,
  });

  static Future<void> show(BuildContext context, List<EquipmentPiece> pieces, Function onSuccess) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (context) {
        return SubmissionBottomSheet(
          pieces: pieces,
          onSuccess: onSuccess,
        );
      },
    );
  }

  @override
  State<SubmissionBottomSheet> createState() => _SubmissionBottomSheetState();
}

class _SubmissionBottomSheetState extends State<SubmissionBottomSheet> {
  List<String> selectedPieces = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Screen.height * 0.7,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: AppColors.background.lightBlue,
      ),
      width: Screen.width,
      child: Column(
        children: [
          Spacing.h10,
          Row(
            children: [
              const Text(
                'Verify equipment',
                style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close),
              ),
            ],
          ).paddingHorizontal(16),
          const Divider(
            height: 1,
            color: Colors.grey,
          ).paddingHorizontal(8),
          Spacing.h12,
          ...(widget.pieces).map(
            (piece) {
              bool isVerified = selectedPieces.contains(piece.id);

              return InkWell(
                onTap: () {
                  if (isVerified) {
                    selectedPieces.remove(piece.id);
                  } else {
                    selectedPieces.add(piece.id);
                  }
                  setState(() {});
                },
                child: _EquipmentPieceTile(piece, isVerified),
              ).paddingOnly(bottom: 12);
            },
          ),
          const Spacer(),
          Selector<EquipmentProvider, bool>(
            selector: (context, provider) => provider.status == EquipmentStatus.loading,
            builder: (context, isLoading, child) {
              bool enable = selectedPieces.length == widget.pieces.length;
              return BannerContainer(
                height: 45,
                child: InkWell(
                  onTap: () {
                    if (isLoading) return;
                    if (enable == false) return;
                    widget.onSuccess();
                  },
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ).size(15, 15).center
                      : Text(
                          'Verified',
                          style: TextStyle(
                            color: Colors.white.withOpacity(
                              enable ? 1 : 0.5,
                            ),
                            fontWeight: FontWeight.bold,
                          ),
                        ).center,
                ),
              );
            },
          ).center.width(Screen.width),
          Spacing.h30,
        ],
      ),
    ).paddingOnly(bottom: MediaQuery.of(context).viewInsets.bottom);
  }
}

class _EquipmentPieceTile extends StatelessWidget {
  final EquipmentPiece piece;
  final bool isVerified;

  const _EquipmentPieceTile(this.piece, this.isVerified);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isVerified ? Colors.green.withOpacity(0.1) : Colors.red.shade200.withOpacity(0.1),
        // border: Border.all(color: AppColors.background.lightSkyBlue.withOpacity(0.5)),
      ),
      // height: 20,
      width: Screen.width,
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  text: '${piece.equipmentItemName} ',
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    color: Colors.black,
                    fontSize: 14,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: ' ${piece.tag.id}',
                      style: const TextStyle(
                        color: Color(0xff727272),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Spacing.h4,
              Text(
                isVerified ? 'Verified' : 'Not yet verified',
                style: TextStyle(
                  fontSize: 12,
                  color: isVerified ? Colors.green : Colors.red,
                  fontWeight: isVerified ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
          const Spacer(),
          Icon(
            isVerified ? Icons.verified : Icons.cancel,
            color: isVerified ? Colors.green : Colors.red,
          )
        ],
      ).paddingSymmetric(vertical: 8, horizontal: 16),
    ).paddingHorizontal(16);
  }
}
