import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/constants/assets/app_icons.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/view/screens/coverage/coverage_view.dart';
import 'package:aleedz/view/screens/home/home_view.dart';
import 'package:aleedz/viewmodel/dashboard_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardView extends ConsumerStatefulWidget {
  const DashboardView({super.key});

  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends ConsumerState<DashboardView> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeView(),
    CoverageView(),
    HomeView(),
    CoverageView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dashboardProvider);
    final viewModel = ref.read(dashboardProvider.notifier);

    return SafeArea(
      child: Scaffold(
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: AppColors.secondary,
          selectedItemColor: AppColors.whiteColor,
          unselectedItemColor: AppColors.whiteColor,
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                AppIcons.homeUnSelectedIcon,
                height: 30,
                width: 30,
                color: AppColors.whiteColor,
              ),
              activeIcon: Image.asset(
                AppIcons.homeSelectedIcon,
                height: 30,
                width: 30,
                color: AppColors.whiteColor,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                AppIcons.coverageUnSelected,
                height: 30,
                width: 30,
                color: AppColors.whiteColor,
              ),
              activeIcon: Image.asset(
                AppIcons.coverageSelected,
                height: 30,
                width: 30,
                color: AppColors.whiteColor,
              ),
              label: 'Coverage',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                AppIcons.notificationUnselected,
                height: 30,
                width: 30,
                color: AppColors.whiteColor,
              ),
              activeIcon: Image.asset(
                AppIcons.notificationSelected,
                height: 30,
                width: 30,
                color: AppColors.whiteColor,
              ),
              label: 'Alert',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                AppIcons.userUnSelected,
                height: 30,
                width: 30,
                color: AppColors.whiteColor,
              ),
              activeIcon: Image.asset(
                AppIcons.userSelected,
                height: 30,
                width: 30,
                color: AppColors.whiteColor,
              ),
              label: 'Account',
            ),
          ],
        ),
      ),
    );
  }
}
