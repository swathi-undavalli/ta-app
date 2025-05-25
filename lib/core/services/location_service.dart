import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

import '../widgets/alert_dialog.dart';

class LocationService {
  final Location location = Location();

  Future<bool> checkAndRequestLocationPermission(BuildContext context) async {
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled && context.mounted) {
        CustomAlertDialog.show(
          context,
          onConfirm: () async {
            await Geolocator.openLocationSettings();
            if (context.mounted) {
              Navigator.pop(context);
            }
          },
          title: 'Permission Denied',
          content: 'Location permission is required to use this feature.',
        );
        return false;
      }
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
    }

    if (permissionGranted == PermissionStatus.deniedForever) {
      CustomAlertDialog.show(
        context,
        onConfirm: () {
          AppSettings.openAppSettings();
          Navigator.pop(context);
        },
        title: 'Permission Required',
        content: 'This app needs location access. Please enable it in the app settings.',
      );
      return false;
    }

    if (permissionGranted != PermissionStatus.granted) {
      CustomAlertDialog.show(
        context,
        onConfirm: () async {
          await Geolocator.openLocationSettings();
          Navigator.pop(context);
        },
        title: 'Permission Denied',
        content: 'Location permission is required to use this feature.',
      );

      return false;
    }

    return true;
  }
}
