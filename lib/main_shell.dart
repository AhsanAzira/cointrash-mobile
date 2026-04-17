import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'pages/dashboard_screen.dart';
import 'pages/point_screen.dart';
import 'pages/scan_screen.dart';
import 'pages/map_screen.dart';
import 'pages/profile_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    DashboardScreen(),
    PointScreen(),
    ScanScreen(),
    MapScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.primaryDark,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (i) => setState(() => _currentIndex = i),
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppColors.primaryDark,
            selectedItemColor: AppColors.white,
            unselectedItemColor: AppColors.textGray.withValues(alpha: 0.7),
            selectedFontSize: 11,
            unselectedFontSize: 11,
            showUnselectedLabels: true,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
            elevation: 0,
            items: [
              _buildNavItem(0, Icons.home_rounded, 'Beranda'),
              _buildNavItem(1, Icons.account_balance_wallet, 'Point'),
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _currentIndex == 2
                        ? AppColors.primaryGreen
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.qr_code_scanner_rounded,
                    color: _currentIndex == 2
                        ? AppColors.white
                        : AppColors.primaryGreen,
                    size: 24,
                  ),
                ),
                label: 'Scan',
              ),
              _buildNavItem(3, Icons.map, 'Lokasi'),
              _buildNavItem(4, Icons.person, 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
    int index,
    IconData iconData,
    String label,
  ) {
    bool isSelected = _currentIndex == index;
    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          iconData,
          color: isSelected
              ? AppColors.white
              : AppColors.textGray.withValues(alpha: 0.7),
          size: 22,
        ),
      ),
      label: label,
    );
  }
}
