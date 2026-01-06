import 'package:flutter/material.dart';
import '../config/app_theme.dart';

class InfoCard extends StatelessWidget {
  final String engine; // "ON" / "OFF"
  final bool moving; // true = digunakan
  final double speed; // km/jam

  const InfoCard({
    super.key,
    required this.engine,
    required this.moving,
    required this.speed,
  });

  @override
  Widget build(BuildContext context) {
    final bool engineOn = engine == "ON";

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.05),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },

      /// 🔑 KEY berubah → animasi berjalan
      child: Container(
        key: ValueKey("$engine-$moving-$speed"),
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            /// 🔝 HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Status Kendaraan",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _statusBadge(
                  text: engineOn ? "MESIN HIDUP" : "MESIN MATI",
                  color: engineOn ? AppTheme.sageGreen : Colors.grey,
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// 📊 INFO UTAMA
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _infoItem(
                  icon: Icons.power_settings_new,
                  label: "Mesin",
                  value: engineOn ? "ON" : "OFF",
                  color: engineOn ? AppTheme.sageGreen : Colors.grey,
                ),
                _infoItem(
                  icon: moving
                      ? Icons.directions_bike
                      : Icons.local_parking,
                  label: "Status",
                  value: moving ? "Digunakan" : "Parkir",
                  color: moving ? AppTheme.sageDark : Colors.grey,
                ),
                _infoItem(
                  icon: Icons.speed,
                  label: "Kecepatan",
                  value: "${speed.toStringAsFixed(1)} km/j",
                  color: AppTheme.sageGreen,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 ITEM INFO
  Widget _infoItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  /// 🟢 BADGE STATUS
  Widget _statusBadge({
    required String text,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
