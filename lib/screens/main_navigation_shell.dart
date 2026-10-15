import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../core/theme/app_animations.dart';
import '../providers/auth_provider.dart';
import '../providers/vaccine_provider.dart';
import '../widgets/responsive_layout.dart';
import 'dashboard_screen.dart';
import 'schedule_screen.dart';
import 'records_screen.dart';
import 'family_screen.dart';
import 'settings_screen.dart';
import 'auth_screen.dart';
import 'splash_screen.dart';
import 'onboarding_screen.dart';

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;
  bool _showSplash = true;
  bool _showOnboarding = false;

  @override
  Widget build(BuildContext context) {
    // 1. Splash Screen
    if (_showSplash) {
      return SplashScreen(
        onFinish: () {
          setState(() {
            _showSplash = false;
            _showOnboarding = true;
          });
        },
      );
    }

    // 2. Onboarding Screen
    if (_showOnboarding) {
      return OnboardingScreen(
        onFinish: () {
          setState(() {
            _showOnboarding = false;
          });
        },
      );
    }

    // 3. Auth Check
    final auth = Provider.of<AuthProvider>(context);
    if (!auth.isAuthenticated) {
      return AuthScreen(
        onLoginSuccess: () {
          setState(() => _currentIndex = 0);
        },
      );
    }

    final isDesktop = ResponsiveLayout.isDesktop(context);

    final List<Widget> screens = [
      DashboardScreen(
        onNavigateToSchedule: () => setState(() => _currentIndex = 1),
      ),
      const ScheduleScreen(),
      const RecordsScreen(),
      const FamilyScreen(),
      SettingsScreen(
        onLogout: () {
          setState(() => _currentIndex = 0);
        },
      ),
    ];

    final destinations = [
      const NavigationDestination(
        icon: Icon(Icons.dashboard_outlined),
        selectedIcon: Icon(Icons.dashboard_rounded, color: AppColors.primaryBlue),
        label: 'Dashboard',
      ),
      const NavigationDestination(
        icon: Icon(Icons.calendar_month_outlined),
        selectedIcon: Icon(Icons.calendar_month_rounded, color: AppColors.primaryBlue),
        label: 'Schedule',
      ),
      const NavigationDestination(
        icon: Icon(Icons.verified_user_outlined),
        selectedIcon: Icon(Icons.verified_user_rounded, color: AppColors.primaryBlue),
        label: 'Records',
      ),
      const NavigationDestination(
        icon: Icon(Icons.people_outline_rounded),
        selectedIcon: Icon(Icons.people_rounded, color: AppColors.primaryBlue),
        label: 'Family',
      ),
      const NavigationDestination(
        icon: Icon(Icons.settings_outlined),
        selectedIcon: Icon(Icons.settings_rounded, color: AppColors.primaryBlue),
        label: 'Settings',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryBlue, AppColors.secondaryMint],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.health_and_safety_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'VaxiCare',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: AppColors.primaryBlue,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'WEB DEMO',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryBlue,
                ),
              ),
            ),
          ],
        ),
        actions: [
          Consumer<VaccineProvider>(
            builder: (context, provider, _) {
              final active = provider.selectedChild;
              if (active == null) return const SizedBox();
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Chip(
                  avatar: Text(active.avatarEmoji, style: const TextStyle(fontSize: 14)),
                  label: Text(
                    active.name,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryText,
                    ),
                  ),
                  backgroundColor: AppColors.cardBackground,
                  side: const BorderSide(color: AppColors.border),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                ),
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.border, height: 1),
        ),
      ),
      body: Row(
        children: [
          if (isDesktop)
            NavigationRail(
              selectedIndex: _currentIndex,
              onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
              labelType: NavigationRailLabelType.all,
              backgroundColor: Colors.white,
              selectedIconTheme: const IconThemeData(color: AppColors.primaryBlue),
              unselectedIconTheme: const IconThemeData(color: AppColors.secondaryText),
              selectedLabelTextStyle: const TextStyle(
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
              unselectedLabelTextStyle: const TextStyle(
                color: AppColors.secondaryText,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard_rounded),
                  label: Text('Dashboard'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.calendar_month_outlined),
                  selectedIcon: Icon(Icons.calendar_month_rounded),
                  label: Text('Schedule'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.verified_user_outlined),
                  selectedIcon: Icon(Icons.verified_user_rounded),
                  label: Text('Records'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.people_outline_rounded),
                  selectedIcon: Icon(Icons.people_rounded),
                  label: Text('Family'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.settings_outlined),
                  selectedIcon: Icon(Icons.settings_rounded),
                  label: Text('Settings'),
                ),
              ],
            ),
          if (isDesktop) const VerticalDivider(thickness: 1, width: 1, color: AppColors.border),
          // Screen with subtle fade switch transition
          Expanded(
            child: AnimatedSwitcher(
              duration: AppAnimations.normal,
              curve: AppAnimations.smoothInOut,
              child: KeyedSubtree(
                key: ValueKey<int>(_currentIndex),
                child: screens[_currentIndex],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: isDesktop
          ? null
          : Container(
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.border, width: 1)),
              ),
              child: NavigationBar(
                selectedIndex: _currentIndex,
                onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
                backgroundColor: Colors.white,
                indicatorColor: AppColors.primaryLight,
                animationDuration: AppAnimations.normal,
                destinations: destinations,
              ),
            ),
    );
  }
}
