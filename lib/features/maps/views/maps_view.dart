import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:temple_ui_tools/styling/alignment_extensions.dart';
import 'package:temple_ui_tools/styling/padding_extensions.dart';
import 'package:temple_ui_tools/styling/spacing_widgets.dart';
import 'package:temple_ui_tools/utils/utils.dart';

import '../../../core/constants/constants.dart';
import '../../../core/util/map_calculations.dart';
import '../../../core/widgets/app_button.dart';
import '../../dive_sites/view/all_dive_sites_view.dart';
import '../../equipment/presentation/widgets/equipment_app_bar.dart';
import '../../equipment/presentation/widgets/equipment_body.dart';
import '../providers/maps_provider.dart';
import '../widgets/location_details.bottom_sheet.dart';
import '../widgets/overlay_icon_widget.dart';
import 'close_region_nativtion_helper.screen.dart';

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
  bool expandLocationDetails = true;
  bool showDeadHeading = false;

  @override
  initState() {
    super.initState();
    provider = context.read<MapsProvider>();
    provider.fetchCurrentLocation(context);
    provider.fetchDiveSites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background.black,
      appBar: EquipmentAppBar(
        title: 'Temple Maps',
        description: 'Friendly navigation helper',
        action: Row(
          children: [
            IconButton(
              onPressed: () async {
                final diveSite = await Navigator.push(context, AllDiveSitesView.route());
                if (diveSite == null) return;
                provider.selectedLocation = diveSite;
                provider.mapController?.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: LatLng(
                        diveSite.latLang.latitude,
                        diveSite.latLang.longitude,
                      ),
                      zoom: 15,
                    ),
                  ),
                );
                setState(() {});
              },
              icon: const Icon(Icons.travel_explore),
            ),
            IconButton(
              onPressed: provider.showPlusPointer,
              icon: const Icon(Icons.add_location_alt),
            ).paddingOnly(right: 20),
          ],
        ),
      ),
      body: EquipmentBody(
        child: Consumer<MapsProvider>(
          builder: (context, provider, child) {
            return (provider.currentUserLocation == null)
                ? const CircularProgressIndicator().center
                : Stack(
                    children: [
                      GoogleMap(
                        onMapCreated: provider.onMapCreated,
                        initialCameraPosition: CameraPosition(
                          target: provider.currentUserLocation!,
                          zoom: 20,
                        ),
                        onTap: provider.onMapTap,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                        markers: _buildMarkers(),
                        polylines: _buildPolyLines(),
                        onCameraMove: provider.onCameraMove,
                        zoomControlsEnabled: false,
                      ),
                      if (provider.currentUserLocation != null && provider.selectedLocation != null)
                        Positioned(
                          bottom: 0,
                          child: AnimatedContainer(
                            height: (expandLocationDetails ? 76 : 240) + 100,
                            duration: Duration(milliseconds: 300),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Spacer(),
                                    SpeedIndicator(
                                      speedKmph: provider.speed,
                                      child: Container(
                                        height: 100,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(8),
                                            topLeft: Radius.circular(8),
                                          ),
                                        ),
                                        child: CloseRegionNavigationHelperScreen(
                                          targetLatitude: provider.selectedLocation!.latLang.latitude,
                                          targetLongitude: provider.selectedLocation!.latLang.longitude,
                                          isWidget: true,
                                        ).paddingAll(16).center,
                                      ),
                                    ),
                                    Spacing.w16,
                                  ],
                                ).width(Screen.width),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      expandLocationDetails = !expandLocationDetails;
                                    });
                                  },
                                  child: Container(
                                    height: 76,
                                    width: Screen.width,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        topRight: Radius.circular(8),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${provider.selectedLocation?.name}',
                                                  style: TextStyle(
                                                      fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    text: 'You are ',
                                                    style: DefaultTextStyle.of(context)
                                                        .style
                                                        .copyWith(color: Colors.black87.withOpacity(0.7)),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                        text:
                                                            '${(provider.distanceToSelectedSite).toStringAsFixed(2)} kms',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          color: provider.distanceToSelectedSite < 2
                                                              ? Colors.red
                                                              : Colors.green,
                                                        ),
                                                      ),
                                                      TextSpan(text: ' away from current location'),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              height: 30,
                                              width: 30,
                                              decoration: BoxDecoration(
                                                color: Colors.black12,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Transform.rotate(
                                                angle: pi * (expandLocationDetails ? 2 : 1),
                                                child: Icon(Icons.keyboard_control_key).paddingOnly(top: 4),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ).paddingAll(16),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    color: Colors.white,
                                    width: Screen.width,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Coordinates :',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '${provider.selectedLocation!.latLang.latitude}, ${provider.selectedLocation!.latLang.longitude}',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        Spacing.h20,
                                        AppButton.flat(
                                          text: 'Compass Navigation',
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              CloseRegionNavigationHelperScreen.route(
                                                targetLatitude: provider.selectedLocation!.latLang.latitude,
                                                targetLongitude: provider.selectedLocation!.latLang.longitude,
                                              ),
                                            );
                                          },
                                          width: Screen.width,
                                        ),
                                      ],
                                    ).paddingHorizontal(16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (provider.showOverlay && provider.currentCenterPosition != null) ...[
                        OverlayIconWidget(),
                        Positioned(
                          bottom: 20,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              AppButton.flat(
                                text: 'Cancel',
                                buttonColor: Colors.white,
                                textColor: Colors.black,
                                onTap: () {
                                  provider.hideOverlay();
                                },
                              ),
                              AppButton.flat(
                                text: 'Add location',
                                onTap: () async {
                                  LocationDetailsBottomSheet.show(context);
                                },
                              ),
                            ],
                          ).width(Screen.width),
                        ),
                      ],
                      Positioned(
                        top: 12,
                        left: 12,
                        child: SpeedIndicator(
                          speedKmph: provider.speed,
                        ),
                      ),
                      Positioned(
                        top: 12 + 38 + 12,
                        right: 12,
                        child: InkWell(
                          onTap: () => setState(() => showDeadHeading = !showDeadHeading),
                          child: Container(
                            height: 38,
                            width: 38,
                            decoration: BoxDecoration(
                                color: showDeadHeading ? Colors.black : Colors.white70,
                                borderRadius: BorderRadius.circular(2)),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 0,
                                  bottom: 5,
                                  left: 18,
                                  child: Container(
                                    height: 30,
                                    width: 2,
                                    color: Colors.red,
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 7,
                                  child: Icon(
                                    Icons.navigation_rounded,
                                    color: !showDeadHeading ? Colors.black : Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
          },
        ),
      ),
    );
  }

  Set<Marker> _buildMarkers() {
    return {
      Marker(
        markerId: const MarkerId('currentLocation'),
        position: provider.currentUserLocation!,
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
            setState(() {});
          },
        );
      }),
    };
  }

  Set<Polyline> _buildPolyLines() {
    return {
      if (provider.currentUserLocation != null && provider.selectedLocation != null)
        Polyline(
          polylineId: const PolylineId('navigation_line'),
          points: [
            provider.currentUserLocation!,
            LatLng(
              provider.selectedLocation!.latLang.latitude,
              provider.selectedLocation!.latLang.longitude,
            ),
          ],
          color: Colors.blue,
          width: 5,
        ),
      if (showDeadHeading &&
          (provider.recentLocations.isNotEmpty &&
              (provider.recentLocations.length >= 2) &&
              provider.currentUserLocation != null))
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
}

class SpeedIndicator extends StatefulWidget {
  final double speedKmph;
  final Widget? child;

  const SpeedIndicator({super.key, required this.speedKmph, this.child});

  @override
  State<SpeedIndicator> createState() => _SpeedIndicatorState();
}

class _SpeedIndicatorState extends State<SpeedIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void didUpdateWidget(covariant SpeedIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.speedKmph > 1.0) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: widget.child ??
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black38, Colors.black87],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(4),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(2, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.speed, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  '${widget.speedKmph.toStringAsFixed(1)} km/h',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
