import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/view/screens/dashboard/dashboard_view.dart';
import 'package:aleedz/viewmodel/coverage_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class TodayPlanView extends ConsumerStatefulWidget {
  const TodayPlanView({super.key});

  @override
  ConsumerState<TodayPlanView> createState() => _CoverageViewState();
}

class _CoverageViewState extends ConsumerState<TodayPlanView> {
  GoogleMapController? mapController;
  LatLng? currentLocation;
  List<LatLng> routePoints = [];
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    // Add your destination points here
    routePoints =
        ref.read(coverageModelProvider.notifier).dashBoardList.map((item) {
          // Clean string if needed (example: "32.4945° N" → "32.4945")
          String cleanLat = item.latitude.replaceAll(RegExp(r'[^0-9.-]'), '');
          String cleanLng = item.longitude.replaceAll(RegExp(r'[^0-9.-]'), '');

          return LatLng(
            double.tryParse(cleanLat) ?? 0.0,
            double.tryParse(cleanLng) ?? 0.0,
          );
        }).toList();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);
      _updateMarkersAndPolyline();
    });
  }

  // Add this method to calculate distance between two LatLng points
  double _calculateDistance(LatLng start, LatLng end) {
    return Geolocator.distanceBetween(
      start.latitude,
      start.longitude,
      end.latitude,
      end.longitude,
    );
  }

  // Update your _updateMarkersAndPolyline method
  void _updateMarkersAndPolyline() {
    if (currentLocation == null) return;

    markers.clear();
    polylines.clear();

    // 1. Sort routePoints by distance from currentLocation (nearest first)
    routePoints.sort((a, b) {
      double distanceA = _calculateDistance(currentLocation!, a);
      double distanceB = _calculateDistance(currentLocation!, b);
      return distanceA.compareTo(distanceB);
    });

    // 2. Add current location marker
    markers.add(
      Marker(
        markerId: MarkerId('current'),
        position: currentLocation!,
        infoWindow: InfoWindow(title: 'Current Location'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    );

    // 3. Add sorted route markers
    for (int i = 0; i < routePoints.length; i++) {
      markers.add(
        Marker(
          markerId: MarkerId('point_$i'),
          position: routePoints[i],
          infoWindow: InfoWindow(
            title:
                'Point ${i + 1} (${_calculateDistance(currentLocation!, routePoints[i]).toStringAsFixed(0)}m)',
          ),
        ),
      );
    }

    // 4. Create polyline through sorted points
    polylines.add(
      Polyline(
        polylineId: PolylineId('route'),
        points: [currentLocation!, ...routePoints],
        color: Colors.blue,
        width: 5,
      ),
    );

    // 5. Zoom to fit the entire route
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mapController != null) {
        _zoomToRoute();
      }
    });
  }

  // Add this zoom function
  void _zoomToRoute() {
    LatLngBounds bounds = boundsFromLatLngList([
      currentLocation!,
      ...routePoints,
    ]);
    mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }

  LatLngBounds boundsFromLatLngList(List<LatLng> list) {
    double? x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1!) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1!) y1 = latLng.longitude;
        if (latLng.longitude < y0!) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(
      northeast: LatLng(x1!, y1!),
      southwest: LatLng(x0!, y0!),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(coverageModelProvider);

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 150),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF111827), Color(0xFF0B1120)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          NavigationService.goBack();
                        },
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(LabelService().getLabel(289),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child:
                  currentLocation == null
                      ? Center(child: LoadingAnimationWidget.discreteCircle(color: Theme.of(context).colorScheme.primary, size: 32))
                      : GoogleMap(
                        zoomControlsEnabled: false, // Removes +/- buttons
                        myLocationButtonEnabled:
                            false, // Removes "my location" button
                        compassEnabled: false, // Removes compass
                        zoomGesturesEnabled: true, // Still allow pinch-to-zoom
                        rotateGesturesEnabled: false, // Disable rotation
                        tiltGesturesEnabled: false,
                        onMapCreated: (controller) {
                          setState(() {
                            mapController = controller;
                          });
                        },
                        initialCameraPosition: CameraPosition(
                          target: currentLocation!,
                          zoom: 13,
                        ),
                        markers: markers,
                        polylines: polylines,
                        myLocationEnabled: true,
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
