import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import 'control_screen.dart';
import 'map_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int index = 0;

  final pages = const [
    ControlScreen(),
    MapScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.sageLight,
      body: Stack(
        children: [
          /// PAGE CONTENT
          pages[index],

          /// FLOATING NAV BAR
          Positioned(
            left: 16,
            right: 16,
            bottom: 30,
            child: _floatingNavBar(),
          ),
        ],
      ),
    );
  }

  /// ================= FLOATING NAV BAR =================
  Widget _floatingNavBar() {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          /// NAV ITEMS
          Row(
            children: [
              _navItem(
                icon: Icons.settings_remote,
                label: "Kontrol",
                isActive: index == 0,
                onTap: () => setState(() => index = 0),
              ),
              _navItem(
                icon: Icons.map_rounded,
                label: "Peta",
                isActive: index == 1,
                onTap: () => setState(() => index = 1),
              ),
            ],
          ),

          /// SLIDING INDICATOR
          _slidingIndicator(),
        ],
      ),
    );
  }

  /// ================= SLIDING INDICATOR =================
  Widget _slidingIndicator() {
    return AnimatedAlign(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      alignment:
          index == 0 ? Alignment.bottomLeft : Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: AppTheme.sageGreen,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppTheme.sageGreen.withOpacity(0.6),
                blurRadius: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ================= NAV ITEM =================
  Widget _navItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(32),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 26,
              color: isActive
                  ? AppTheme.sageGreen
                  : Colors.grey.shade400,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isActive
                    ? AppTheme.sageGreen
                    : Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
