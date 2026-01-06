import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../config/app_theme.dart';
import '../services/antares_service.dart';
import '../models/lokasi_model.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  Timer? _timer;

  /// DEFAULT LOCATION (SEBELUM DATA MASUK)
  LatLng vehicleLocation = const LatLng(-6.914744, 107.609810);

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLokasi();

    /// AUTO REFRESH SETIAP 5 DETIK
    _timer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _fetchLokasi(),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// 🔄 AMBIL DATA DARI ANTARES
  Future<void> _fetchLokasi() async {
    try {
      LokasiMotor lokasi = await AntaresService.getLokasiTerakhir();

      setState(() {
        vehicleLocation = LatLng(
          lokasi.latitude,
          lokasi.longitude,
        );
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Gagal update lokasi: $e");
    }
  }

  void _recenterMap() {
    _mapController.move(vehicleLocation, 16);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.sageGreen,
              AppTheme.sageLight,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16),

              /// TITLE
              const Text(
                "Lokasi Kendaraan",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 24),

              /// MAP CARD
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(32)),
                  ),
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(32)),
                    child: Stack(
                      children: [
                        /// MAP
                        FlutterMap(
                          mapController: _mapController,
                          options: MapOptions(
                            initialCenter: vehicleLocation,
                            initialZoom: 16,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                              userAgentPackageName:
                                  'com.example.keamanan_motor',
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: vehicleLocation,
                                  width: 52,
                                  height: 52,
                                  child: _vehicleMarker(),
                                ),
                              ],
                            ),
                          ],
                        ),

                        /// COORDINATE INFO
                        Positioned(
                          top: 16,
                          left: 16,
                          child: _coordinateInfo(),
                        ),

                        /// RECENTER BUTTON
                        Positioned(
                          right: 16,
                          bottom: 96,
                          child: FloatingActionButton(
                            heroTag: "recenter",
                            backgroundColor: AppTheme.sageGreen,
                            onPressed: _recenterMap,
                            child: const Icon(Icons.my_location),
                          ),
                        ),

                        /// LOADING
                        if (isLoading)
                          const Center(
                            child: CircularProgressIndicator(),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🚲 MARKER
  Widget _vehicleMarker() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.sageGreen,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Icon(
        Icons.motorcycle,
        color: Colors.white,
        size: 28,
      ),
    );
  }

  /// 📍 KOORDINAT
  Widget _coordinateInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Koordinat Kendaraan",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Lat: ${vehicleLocation.latitude.toStringAsFixed(6)}",
            style: const TextStyle(fontSize: 12),
          ),
          Text(
            "Lng: ${vehicleLocation.longitude.toStringAsFixed(6)}",
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
