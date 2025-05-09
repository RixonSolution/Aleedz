import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/constants/assets/app_icons.dart';
import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/view/screens/account/account_view.dart';
import 'package:aleedz/view/screens/coverage_details/coverage_view.dart';
import 'package:aleedz/view/screens/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardView extends ConsumerStatefulWidget {
  final int initialIndex;

  DashboardView({super.key, this.initialIndex = 0});

  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends ConsumerState<DashboardView> {
  late int _selectedIndex;

  final List<Widget> _screens = [
    HomeView(),
    CoverageView(),
    HomeView(),
    LogoutScreen(),
  ];

  @override
  void initState() {
    _selectedIndex = widget.initialIndex;
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                AppIcons.dashboardIcon,
                height: 30,
                width: 30,
                color: AppColors.whiteColor,
              ),

              label: LabelService().getLabel(7),
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                AppIcons.coverageIcon,
                height: 30,
                width: 30,
                color: AppColors.whiteColor,
              ),

              label: LabelService().getLabel(8),
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                AppIcons.notificationIcon,
                height: 30,
                width: 30,
                color: AppColors.whiteColor,
              ),

              label: LabelService().getLabel(9),
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                AppIcons.accountIcon,
                height: 30,
                width: 30,
                color: AppColors.whiteColor,
              ),
              label: LabelService().getLabel(10),
            ),
          ],
        ),
      ),
    );
  }
}
