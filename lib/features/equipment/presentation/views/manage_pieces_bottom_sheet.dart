import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:temple_ui_tools/temple_ui_tools.dart';
import 'package:temple_ui_tools/utils/utils.dart';

import '../../../../core/constants/constants.dart';
import '../../models/equipment_model.dart';
import '../../provider/equipment.provider.dart';

class ManagePiecesBottomSheet extends StatefulWidget {
  final EquipmentItem item;

  const ManagePiecesBottomSheet({super.key, required this.item});

  static Future<void> show(BuildContext context, EquipmentItem item) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (context) {
        return ManagePiecesBottomSheet(item: item);
      },
    );
  }

  @override
  State<ManagePiecesBottomSheet> createState() => _ManagePiecesBottomSheetState();
}

class _ManagePiecesBottomSheetState extends State<ManagePiecesBottomSheet> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: AppColors.background.lightBlue,
      ),
      width: Screen.width,
      child: FutureBuilder(
        future: context.read<EquipmentProvider>().repository.fetchEquipmentPieces(
              currentRental: null,
              equipmentItemId: widget.item.id,
            ),
        builder: (context, snapshot) {
          if (snapshot.data?.isEmpty ?? true) {
            return const CircularProgressIndicator(
              color: Colors.black,
            ).center;
          }

          return Consumer<EquipmentProvider>(
            builder: (context, provider, child) {
              return Column(
                children: [
                  Spacing.h10,
                  Row(
                    children: [
                      Text(
                        'Select Ids of ${widget.item.name}',
                        style: const TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
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
                  ...(snapshot.data ?? []).map(
                    (piece) {
                      bool isSelected = provider.selectedPieces.contains(piece);

                      return InkWell(
                        onTap: () {
                          provider.togglePieceSelection(piece);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: isSelected
                                ? AppColors.background.lightSkyBlue
                                : AppColors.background.lightSkyBlue.withOpacity(0.2),
                            border: Border.all(color: AppColors.background.lightSkyBlue.withOpacity(0.5)),
                          ),
                          // height: 20,
                          width: Screen.width,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                piece.assignedID,
                                style: const TextStyle(color: Colors.black, fontSize: 16),
                              ).paddingHorizontal(8),
                            ],
                          ).paddingAll(8),
                        ).paddingHorizontal(16),
                      ).paddingOnly(bottom: 12);
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    ).paddingOnly(bottom: MediaQuery.of(context).viewInsets.bottom);
  }
}
