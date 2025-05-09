import 'package:aleedz/viewmodel/coverage_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapScreen extends ConsumerStatefulWidget {
  double myLat, myLang, otherLat, otherLang;
  GoogleMapScreen({
    required this.myLat,
    required this.myLang,
    required this.otherLat,
    required this.otherLang,
  });
  @override
  _GoogleMapScreenState createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends ConsumerState<GoogleMapScreen> {
  late GoogleMapController mapController;

  // Set the initial camera position
  late CameraPosition _kInitialPosition;

  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _kInitialPosition = CameraPosition(
      target: LatLng(widget.myLat, widget.myLang),
      zoom: 10,
    );

    // Add a marker for your location (example: San Francisco)
    _markers.add(
      Marker(
        markerId: MarkerId('your_location'),
        position: LatLng(widget.myLat, widget.myLang),
        infoWindow: InfoWindow(
          title: 'Your Location',
          snippet: 'This is your location.',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    );

    // Add another marker for another place (example: San Jose)
    _markers.add(
      Marker(
        markerId: MarkerId('other_location'),
        position: LatLng(
          widget.otherLat,
          widget.otherLang,
        ), // San Jose coordinates (change as needed)
        infoWindow: InfoWindow(
          title: 'Other Location',
          snippet: 'This is another location.',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );

    // Add polyline between the two markers
    _polylines.add(
      Polyline(
        polylineId: PolylineId('line_between_markers'),
        visible: true,
        points: [
          LatLng(widget.myLat, widget.myLang), // Your location (San Francisco)
          LatLng(widget.otherLat, widget.myLang), // Other location (San Jose)
        ],
        color: Colors.blue, // Line color
        width: 5, // Line width
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(coverageModelProvider);

    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: _kInitialPosition,
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        markers: _markers, // Display the markers
        polylines: _polylines, // Display the polyline
        zoomControlsEnabled: false, // This removes the + / − buttons
      ),
    );
  }
}
