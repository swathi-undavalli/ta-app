import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:temple_ui_tools/styling/alignment_extensions.dart';
import 'package:temple_ui_tools/styling/padding_extensions.dart';
import 'package:temple_ui_tools/styling/spacing_widgets.dart';
import 'package:temple_ui_tools/utils/utils.dart';

import '../../../core/widgets/app_button.dart';
import '../providers/maps_provider.dart';

class LocationDetailsBottomSheet extends StatefulWidget {
  const LocationDetailsBottomSheet({super.key});

  static Future<void> show(BuildContext context) async {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return const LocationDetailsBottomSheet();
      },
    );
  }

  @override
  State<LocationDetailsBottomSheet> createState() => _LocationDetailsBottomSheetState();
}

class _LocationDetailsBottomSheetState extends State<LocationDetailsBottomSheet> {
  late final MapsProvider provider;
  late TextEditingController _locationName;
  late FocusNode _locationFocusNode;

  @override
  void initState() {
    super.initState();
    provider = context.read<MapsProvider>();
    _locationName = TextEditingController(text: 'Untitled site');
    _locationFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _locationName.dispose();
    _locationFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double distance = provider.calculateDistanceInKm(
      provider.currentUserLocation!.latitude,
      provider.currentUserLocation!.longitude,
      provider.currentCenterPosition!.latitude,
      provider.currentCenterPosition!.longitude,
    );
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitleAndClose(),
            Spacing.h20,
            _buildTextFieldAndEditButton(),
            Spacing.h20,
            _buildLocationDetails(distance),
            Spacing.h40,
            _buildSaveButton().center,
          ],
        ).paddingAll(20).scrollable,
      ),
    );
  }

  Widget _buildTitleAndClose() {
    return Row(
      children: [
        const Text(
          'New dive site',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () async {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  Widget _buildLocationDetails(double distance) {
    return Container(
      width: Screen.width,
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'My current location',
            style: TextStyle(color: Colors.black, fontSize: 12),
          ),
          Text(
            '${provider.currentUserLocation?.latitude.toStringAsFixed(6)} , ${provider.currentUserLocation?.longitude.toStringAsFixed(6)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 14,
            ),
          ),
          Spacing.h10,
          const Text(
            'Pointed location',
            style: TextStyle(color: Colors.black, fontSize: 12),
          ),
          Text(
            '${provider.currentCenterPosition?.latitude.toStringAsFixed(6)} , ${provider.currentCenterPosition?.longitude.toStringAsFixed(6)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 14,
            ),
          ),
          Spacing.h10,
          const Text(
            'Distance from my location',
            style: TextStyle(color: Colors.black, fontSize: 12),
          ),
          Text(
            '${(distance).toStringAsFixed(2)} km',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 14,
            ),
          ),
        ],
      ).paddingAll(15),
    );
  }

  Widget _buildTextFieldAndEditButton() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _locationName,
            focusNode: _locationFocusNode,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,
            ),
            decoration: const InputDecoration(border: InputBorder.none),
          ),
        ),
        if (!_locationFocusNode.hasFocus)
          InkWell(
            onTap: () {
              _locationFocusNode.requestFocus();
              setState(() {});
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black12,
              ),
              child: const Icon(
                Icons.edit,
                color: Colors.black,
                size: 20,
              ).paddingAll(5),
            ),
          ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return AppButton.flat(
      onTap: () {
        provider.addNewDiveSite(_locationName.text);
        Navigator.pop(context);
      },
      text: 'Save',
      showLoading: provider.showLoading,
    );
  }
}
