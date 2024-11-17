import 'package:flutter/material.dart';
import 'package:temple_ui_tools/styling/alignment_extensions.dart';
import 'package:temple_ui_tools/styling/padding_extensions.dart';
import 'package:temple_ui_tools/styling/spacing_widgets.dart';

import '../../../../core/constants/constants.dart';
import '../../models/equipment_model.dart';

class EquipmentPiecesSummaryTable extends StatelessWidget {
  final List<EquipmentPiece> selectedPieces;
  final String? title;

  const EquipmentPiecesSummaryTable(this.selectedPieces, {super.key, this.title});

  @override
  Widget build(BuildContext context) {
    final equipmentMap = <String, List<EquipmentPiece>>{};
    for (var piece in selectedPieces) {
      equipmentMap.putIfAbsent(piece.equipmentItemID, () => []).add(piece);
    }

    return Column(
      children: [
        Text(
          title ?? 'Equipment renting : ',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ).paddingOnly(left: 13).left,
        Spacing.h8,
        for (var entry in equipmentMap.entries)
          _ListItem(
            index: equipmentMap.keys.toList().indexOf(entry.key),
            equipmentID: entry.key,
            pieces: entry.value,
          ),
        Spacing.h8,
        const _DashedLine(),
        Row(
          children: [
            Spacing.w16,
            Text(
              'Total Equipment',
              style: itemsFontStyle.copyWith(fontWeight: FontWeight.bold, color: const Color(0xff727272)),
            ).paddingVertical(16),
            const Spacer(),
            Text(
              '${selectedPieces.length}',
              style: itemsFontStyle.copyWith(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
            ).paddingVertical(16),
            Spacing.w16,
          ],
        ),
        const _DashedLine(),
      ],
    );
  }
}

class _ListItem extends StatelessWidget {
  final String equipmentID;
  final List<EquipmentPiece> pieces;
  final int index;

  const _ListItem({required this.equipmentID, required this.pieces, required this.index});

  @override
  Widget build(BuildContext context) {
    final currentPieces = pieces.where((piece) => piece.equipmentItemID == equipmentID);

    return Row(
      children: [
        Spacing.w16,
        Text(
          '${index + 1}. ${currentPieces.first.equipmentItemName} ( ${currentPieces.map((p) => p.assignedID).join(', ')} )',
          style: itemsFontStyle,
        ),
        const Spacer(),
        Text(
          '${currentPieces.length}',
          style: itemsFontStyle.copyWith(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        Spacing.w16,
      ],
    ).paddingOnly(bottom: 8);
  }
}

class _DashedLine extends StatelessWidget {
  const _DashedLine();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 2.0;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return const SizedBox(
              width: dashWidth,
              height: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Color(0xff999999)),
              ),
            );
          }),
        );
      },
    );
  }
}
