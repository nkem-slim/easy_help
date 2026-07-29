import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DoctorLocationMap extends StatelessWidget {
  final double clinicLat;
  final double clinicLng;

  const DoctorLocationMap({
    super.key,
    required this.clinicLat,
    required this.clinicLng,
  });

  @override
  Widget build(BuildContext context) {
    final clinic = LatLng(clinicLat, clinicLng);
    // Demo "current location" pin offset from the clinic, since real user
    // geolocation isn't wired up yet.
    final origin = LatLng(clinicLat - 0.01, clinicLng - 0.012);

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        height: 180,
        child: GoogleMap(
          initialCameraPosition: CameraPosition(target: clinic, zoom: 13),
          markers: {
            Marker(
              markerId: const MarkerId('clinic'),
              position: clinic,
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueRed,
              ),
            ),
            Marker(
              markerId: const MarkerId('origin'),
              position: origin,
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen,
              ),
            ),
          },
          polylines: {
            Polyline(
              polylineId: const PolylineId('route'),
              points: [origin, clinic],
              color: const Color(0xFF1F9D63),
              width: 4,
            ),
          },
          zoomControlsEnabled: true,
          myLocationButtonEnabled: true,
          liteModeEnabled: false,
        ),
      ),
    );
  }
}
