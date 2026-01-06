import 'dart:async';
import 'package:flutter/material.dart';
import 'package:keamanan_motor/services/antares_service.dart';
import '../config/app_theme.dart';
import '../models/lokasi_model.dart';
import '../screens/welcome_screen.dart';

class ControlScreen extends StatefulWidget {
  const ControlScreen({super.key});

  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  bool engineOn = false;
  double speed = 0.0;
  bool isLoading = false;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchStatus();

    _timer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _fetchStatus(),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// 🔄 AMBIL DATA DARI ANTARES
  Future<void> _fetchStatus() async {
    try {
      final LokasiMotor data =
          await AntaresService.getLokasiTerakhir();

      setState(() {
        engineOn = data.engineOn;
        speed = data.speed;
      });
    } catch (e) {
      debugPrint("Gagal ambil status: $e");
    }
  }

  /// 🔌 KIRIM PERINTAH RELAY
  Future<void> _toggleEngine(bool turnOn) async {
    try {
      setState(() => isLoading = true);

      await AntaresService.kirimPerintahRelay(
        turnOn ? "ON" : "OFF",
      );

      await Future.delayed(const Duration(seconds: 1));
      await _fetchStatus();
    } finally {
      setState(() => isLoading = false);
    }
  }

  /// ⚠️ POPUP KONFIRMASI
  Future<void> _showConfirmDialog({
    required bool turnOn,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text("Konfirmasi"),
          content: Text(
            turnOn
                ? "Apakah Anda yakin ingin menghidupkan mesin?"
                : "Apakah Anda yakin ingin mematikan mesin?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    turnOn ? Colors.green : Colors.red,
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Ya"),
            ),
          ],
        );
      },
    );

    if (result == true) {
      _toggleEngine(turnOn);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = engineOn ? Colors.green : Colors.red;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppTheme.sageGreen, AppTheme.sageLight],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ===== TOP BAR + LOGOUT =====
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 40),

                    const Text(
                      "Kontrol Kendaraan",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    IconButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const WelcomeScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      icon: const Icon(
                        Icons.logout,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(32),
                    ),
                  ),
                  child: Column(
                    children: [
                      /// STATUS CARD
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Status Mesin",
                              style: TextStyle(color: color),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              engineOn ? "HIDUP" : "MATI",
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: color,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Kecepatan: ${speed.toStringAsFixed(1)} km/h",
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      if (isLoading)
                        const CircularProgressIndicator()
                      else ...[
                        _button(
                          icon: Icons.power_settings_new,
                          title: "Hidupkan Mesin",
                          color: Colors.green,
                          enabled: !engineOn,
                          onTap: () =>
                              _showConfirmDialog(turnOn: true),
                        ),
                        const SizedBox(height: 16),
                        _button(
                          icon: Icons.block,
                          title: "Matikan Mesin",
                          color: Colors.red,
                          enabled: engineOn,
                          onTap: () =>
                              _showConfirmDialog(turnOn: false),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _button({
    required IconData icon,
    required String title,
    required Color color,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: enabled ? onTap : null,
      child: Opacity(
        opacity: enabled ? 1 : 0.4,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: color.withOpacity(0.4)),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withOpacity(0.15),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Icon(Icons.chevron_right, color: color),
            ],
          ),
        ),
      ),
    );
  }
}
