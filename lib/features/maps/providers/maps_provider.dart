import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/services/location_service.dart';
import '../../dive_sites/models/dive_site.model.dart';
import '../repository/maps_repo.dart';

class MapsProvider extends ChangeNotifier {
  final MapsRepository mapsRepository;
  final LocationService locationService;

  MapsProvider({required this.mapsRepository, required this.locationService});

  GoogleMapController? mapController;
  LatLng? currentLocation;
  DiveSiteModel? selectedLocation;
  LatLng? currentCenterPosition;
  List<LatLng> recentLocations = [];
  bool showOverlay = false;
  bool showLoading = false;
  List<DiveSiteModel> diveSites = [];
  bool _isDeadHeadingRunning = false;
  double currentZoom = 15;

  Future<void> fetchCurrentLocation(
    BuildContext context, {
    bool hasRetried = false,
  }) async {
    try {
      bool isAllowed =
          await locationService.checkAndRequestLocationPermission(context);
      if (!isAllowed) {
        if (!hasRetried) {
          await fetchCurrentLocation(context, hasRetried: true); // retry once
        }
        return;
      }
      locationService.location.getLocation().then((location) {
        currentLocation = LatLng(
          location.latitude!,
          location.longitude!,
        );
        notifyListeners();
        _drawDeadHeading();
      });

      locationService.location.onLocationChanged.listen((newLoc) {
        currentLocation = LatLng(
          newLoc.latitude!,
          newLoc.longitude!,
        );
        notifyListeners();
      });
    } on PlatformException catch (err) {
      if (kDebugMode) {
        print('Platform exception: $err');
      }
      if (!hasRetried) {
        await fetchCurrentLocation(context, hasRetried: true); // retry once
      }
    }
  }

  void _drawDeadHeading() async {
    if (_isDeadHeadingRunning) return;
    _isDeadHeadingRunning = true;

    while (true) {
      int seconds = 1;

      if (selectedLocation != null && currentLocation != null) {
        num distance = calculateDistanceInKm(
              currentLocation!.latitude,
              currentLocation!.longitude,
              selectedLocation!.latLang.latitude,
              selectedLocation!.latLang.longitude,
            ) *
            1000;

        seconds = distance >= 5
            ? 60
            : distance >= 1
                ? 30
                : 1;
      }

      await Future.delayed(Duration(seconds: seconds));

      if (currentLocation != recentLocations.lastOrNull) {
        recentLocations.add(currentLocation!);
      }

      if (recentLocations.length > 5) {
        recentLocations.removeAt(0);
      }

      notifyListeners();
    }
  }

  void hideOverlay() {
    showOverlay = false;
    notifyListeners();
  }

  Future<void> fetchDiveSites() async {
    diveSites = await mapsRepository.getAllDiveSites();
    if (kDebugMode) {
      print('Fetched ${diveSites.length} dive sites!');
      print('${diveSites.toString()} ');
    }
    notifyListeners();
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;

    if (currentLocation != null) {
      mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: currentLocation!, zoom: 15),
        ),
      );
    }
  }

  Future<void> addNewDiveSite(String name) async {
    if (currentCenterPosition != null) {
      showLoading = true;
      DiveSiteModel newDiveSite = DiveSiteModel(
        name: name,
        latLang: GeoPoint(
          currentCenterPosition!.latitude,
          currentCenterPosition!.longitude,
        ),
      );
      await mapsRepository.addDiveSite(newDiveSite);

      diveSites.add(newDiveSite);

      showOverlay = false;
      showLoading = false;

      notifyListeners();
    }
  }

  void onMapTap(LatLng position) {
    currentCenterPosition = position;
    showOverlay = true;
    notifyListeners();
  }

  void onCameraMove(CameraPosition position) {
    if (showOverlay) {
      currentCenterPosition = position.target;
      currentZoom = position.zoom;
      notifyListeners();
    }
  }

  double calculateDistanceInKm(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.distanceBetween(
          startLatitude,
          startLongitude,
          endLatitude,
          endLongitude,
        ) /
        1000;
  }
}
