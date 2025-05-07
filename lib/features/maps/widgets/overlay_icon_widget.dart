import 'package:flutter/material.dart';
import 'package:temple_ui_tools/styling/alignment_extensions.dart';
import 'package:temple_ui_tools/styling/padding_extensions.dart';
import 'package:temple_ui_tools/styling/spacing_widgets.dart';

class OverlayIconWidget extends StatelessWidget {
  final VoidCallback onAddTap;
  final VoidCallback onLocationTap;
  final VoidCallback onEyeTap;

  const OverlayIconWidget({
    super.key,
    required this.onAddTap,
    required this.onLocationTap,
    required this.onEyeTap,
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
            _buildIconButton(icon: Icons.navigation_rounded, onTap: onLocationTap),
            Spacing.w10,
            _buildHorizontalLine(),
            InkWell(
              onTap: onAddTap,
              child: const Icon(Icons.add, size: 20),
            ),
            _buildHorizontalLine(),
            Spacing.w10,
            _buildIconButton(icon: Icons.remove_red_eye_rounded, onTap: onEyeTap),
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
