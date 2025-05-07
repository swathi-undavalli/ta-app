import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:temple_ui_tools/styling/alignment_extensions.dart';
import 'package:temple_ui_tools/styling/padding_extensions.dart';
import 'package:temple_ui_tools/styling/spacing_widgets.dart';
import 'package:temple_ui_tools/utils/utils.dart';

import '../../../core/util/map_calculations.dart';
import '../../dive_sites/view/all_dive_sites_view.dart';
import '../providers/maps_provider.dart';
import '../widgets/location_details_bottomSheet.dart';
import '../widgets/overlay_icon_widget.dart';

class MapsView extends StatefulWidget {
  const MapsView({super.key});

  static Route route() {
    return MaterialPageRoute(
      builder: (BuildContext context) {
        return const MapsView();
      },
    );
  }

  @override
  MapsViewState createState() => MapsViewState();
}

class MapsViewState extends State<MapsView> {
  late final MapsProvider provider;

  @override
  initState() {
    super.initState();
    provider = context.read<MapsProvider>();
    provider.fetchCurrentLocation(context);
    provider.fetchDiveSites();
  }

  double get distanceToSelectedSite {
    if (provider.currentLocation == null || provider.selectedLocation == null) {
      return 0.0;
    }
    return provider.calculateDistanceInKm(
      provider.currentLocation!.latitude,
      provider.currentLocation!.longitude,
      provider.selectedLocation!.latLang.latitude,
      provider.selectedLocation!.latLang.longitude,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MapsProvider>(
        builder: (context, provider, child) {
          return SafeArea(
            child: (provider.currentLocation == null)
                ? const CircularProgressIndicator().center
                : Stack(
                    children: [
                      GoogleMap(
                        onMapCreated: provider.onMapCreated,
                        initialCameraPosition: CameraPosition(
                          target: provider.currentLocation!,
                          zoom: 20,
                        ),
                        onTap: provider.onMapTap,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                        markers: _buildMarkers(),
                        polylines: _buildPolyLines(),
                        onCameraMove: provider.onCameraMove,
                      ),
                      if (provider.showOverlay &&
                          provider.currentCenterPosition != null)
                        OverlayIconWidget(
                          onLocationTap: () {
                            LocationDetailsBottomSheet.show(context);
                          },
                          onAddTap: () {
                            LocationDetailsBottomSheet.show(context);
                          },
                          onEyeTap: () {
                            provider.hideOverlay();
                          },
                        ),
                      _buildSelectedLocationInfo(),
                      _buildMenu(),
                    ],
                  ),
          );
        },
      ),
    );
  }

  Set<Marker> _buildMarkers() {
    return {
      Marker(
        markerId: const MarkerId('currentLocation'),
        position: provider.currentLocation!,
        infoWindow: const InfoWindow(title: 'Current location'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      ),
      ...provider.diveSites.map((site) {
        return Marker(
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          markerId: MarkerId(site.name),
          position: LatLng(site.latLang.latitude, site.latLang.longitude),
          infoWindow: InfoWindow(title: site.name),
          onTap: () {
            provider.selectedLocation = site;
            distanceToSelectedSite;
            setState(() {});
          },
        );
      }),
    };
  }

  Set<Polyline> _buildPolyLines() {
    return {
      if (provider.currentLocation != null && provider.selectedLocation != null)
        Polyline(
          polylineId: const PolylineId('navigation_line'),
          points: [
            provider.currentLocation!,
            LatLng(
              provider.selectedLocation!.latLang.latitude,
              provider.selectedLocation!.latLang.longitude,
            ),
          ],
          color: Colors.blue,
          width: 5,
        ),
      if (provider.recentLocations.isNotEmpty &&
          (provider.recentLocations.length >= 2) &&
          provider.currentLocation != null)
        Polyline(
          points: [
            provider.recentLocations.last,
            getNextPointOnLine(
              provider.recentLocations[provider.recentLocations.length - 2],
              provider.recentLocations.last,
              Screen.width,
              Screen.height,
              provider.currentZoom,
            ),
          ],
          color: Colors.red,
          width: 2,
          polylineId: const PolylineId('Dead Heading'),
        ),
    };
  }

  Widget _buildSelectedLocationInfo() {
    if (provider.currentLocation != null && provider.selectedLocation != null) {
      return Positioned(
        bottom: 70,
        left: 10,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${provider.selectedLocation?.name}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacing.h20,
              const Text(
                'Coordinates of selected location :',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacing.h10,
              Text(
                '(${provider.selectedLocation!.latLang.latitude}, ${provider.selectedLocation!.latLang.longitude})',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Spacing.h20,
              const Text(
                'Distance from current location :',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacing.h10,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (distanceToSelectedSite).toStringAsFixed(2),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Teko-Medium',
                      height: 1,
                    ),
                  ),
                  Spacing.w8,
                  const Text(
                    'kilo meters',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      height: 1,
                      fontFamily: 'Teko-Medium',
                    ),
                  ).paddingOnly(top: 10),
                ],
              ),
            ],
          ).paddingAll(20),
        ),
      );
    }
    return const SizedBox();
  }

  Widget _buildMenu() {
    return Positioned(
      bottom: 15,
      left: 20,
      child: InkWell(
        onTap: () async {
          final result =
              await Navigator.push(context, AllDiveSitesView.route());

          await provider.fetchDiveSites();

          if (!provider.diveSites.contains(provider.selectedLocation)) {
            provider.selectedLocation = null;
          }

          if (result != null) {
            provider.selectedLocation = result;
            distanceToSelectedSite;
          }

          setState(() {});
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white70,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 10,
                offset: const Offset(1, 1),
              ),
            ],
          ),
          child: const Text(
            'Menu',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ).paddingAll(10),
        ),
      ),
    );
  }
}
