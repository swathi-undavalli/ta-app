import 'package:flutter/material.dart';
import 'package:temple_ui_tools/styling/alignment_extensions.dart';
import 'package:temple_ui_tools/styling/padding_extensions.dart';
import 'package:temple_ui_tools/styling/spacing_widgets.dart';

class OverlayIconWidget extends StatelessWidget {
  const OverlayIconWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildVerticalLine(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacing.w10,
            _buildHorizontalLine(),
            const Icon(Icons.add, size: 20),
            _buildHorizontalLine(),
            Spacing.w10,
          ],
        ),
        _buildVerticalLine(),
      ],
    ).center;
  }

  Widget _buildIconButton({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(2),
        ),
        child: Icon(icon).paddingAll(5),
      ),
    );
  }

  Widget _buildVerticalLine() {
    return Container(
      width: 3,
      height: 80,
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
    );
  }

  Widget _buildHorizontalLine() {
    return Container(
      width: 80,
      height: 3,
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
    );
  }
}
