import 'package:driver_vehicle_mttd/core/theme/app_theme.dart';
import 'package:driver_vehicle_mttd/providers/bottom_nav_provider.dart';
import 'package:driver_vehicle_mttd/screens/account_screen.dart';
import 'package:driver_vehicle_mttd/screens/home_tab.dart';
import 'package:driver_vehicle_mttd/screens/reports_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    BottomNavigationProvider bottomNavigationProvider = context
        .watch<BottomNavigationProvider>();
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: PageView(
        controller: bottomNavigationProvider.pageController,
        onPageChanged: bottomNavigationProvider.onPageViewChanged,
        children: const [HomeTab(), ReportsScreen(), AccountScreen()],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: isDark
                  ? colorScheme.outline.withOpacity(0.15)
                  : colorScheme.outlineVariant.withOpacity(0.2),
              width: 0.5,
            ),
          ),
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
        ),
        child: NavigationBar(
          elevation: 0,
          backgroundColor: colorScheme.surface,
          surfaceTintColor: colorScheme.surfaceTint,
          shadowColor: Colors.transparent,
          selectedIndex: bottomNavigationProvider.screenIndex,
          onDestinationSelected: bottomNavigationProvider.onBottonNavChanged,
          indicatorColor: AppTheme.lightPrimary.withOpacity(0.15),
          indicatorShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          animationDuration: const Duration(milliseconds: 400),
          height: 72,
          destinations: [
            NavigationDestination(
              label: 'Home',
              icon: Icon(
                Icons.home,
                size: 26,
                color: colorScheme.onSurfaceVariant,
              ),
              selectedIcon: const Icon(
                Icons.home,
                color: AppTheme.lightPrimary,
                size: 26,
              ),
              tooltip: 'Home',
            ),
            NavigationDestination(
              label: 'Reports',
              icon: Icon(
                Icons.report,
                size: 26,
                color: colorScheme.onSurfaceVariant,
              ),
              selectedIcon: const Icon(
                Icons.report,
                color: AppTheme.lightPrimary,
                size: 26,
              ),
              tooltip: 'Profile',
            ),
            NavigationDestination(
              label: 'Account',
              icon: Icon(
                Icons.account_circle,
                size: 26,
                color: colorScheme.onSurfaceVariant,
              ),
              selectedIcon: const Icon(
                Icons.account_circle,
                color: AppTheme.lightPrimary,
                size: 26,
              ),
              tooltip: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
