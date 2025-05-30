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
  LatLng? currentUserLocation;
  DiveSiteModel? selectedLocation;
  final int maxRecentLocations = 5;
  LatLng? currentCenterPosition;
  List<LatLng> recentLocations = [];
  bool showOverlay = false;
  bool showLoading = false;
  List<DiveSiteModel> diveSites = [];
  double currentZoom = 15;
  double speed = 0;

  Future<void> fetchCurrentLocation(
    BuildContext context, {
    bool hasRetried = false,
  }) async {
    try {
      bool isAllowed = await locationService.checkAndRequestLocationPermission(context);
      if (!isAllowed) {
        if (!hasRetried) {
          await fetchCurrentLocation(context, hasRetried: true); // retry once
        }
        return;
      }
      locationService.location.getLocation().then((location) {
        currentUserLocation = LatLng(
          location.latitude!,
          location.longitude!,
        );
        notifyListeners();
      });

      locationService.location.onLocationChanged.listen((newLoc) {
        currentUserLocation = LatLng(
          newLoc.latitude!,
          newLoc.longitude!,
        );
        double? speedInMps = newLoc.speed; // Speed in meters/second
        double? speedInKmph = speedInMps != null ? speedInMps * 3.6 : null;
        speed = speedInKmph ?? 0;

        if (currentUserLocation != recentLocations.lastOrNull) {
          recentLocations.add(currentUserLocation!);
        }

        if (recentLocations.length > 5) recentLocations.removeAt(0);

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

  double get distanceToSelectedSite {
    if (currentUserLocation == null || selectedLocation == null) {
      return 0.0;
    }
    return calculateDistanceInKm(
      currentUserLocation!.latitude,
      currentUserLocation!.longitude,
      selectedLocation!.latLang.latitude,
      selectedLocation!.latLang.longitude,
    );
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

    if (currentUserLocation != null) {
      mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: currentUserLocation!, zoom: 15),
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
    // currentCenterPosition = position;
    // showOverlay = true;
    // notifyListeners();
  }

  void showPlusPointer() {
    showOverlay = true;
    selectedLocation = null;
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
