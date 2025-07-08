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
  bool _showProfileDrawer = false;

  final List<Widget> _screens = [
    HomeView(),
    CoverageView(),
    HomeView(),
    SizedBox(), // Placeholder for drawer
  ];

  @override
  void initState() {
    _selectedIndex = widget.initialIndex;
    super.initState();
  }

  void _onItemTapped(int index) {
    if (index == 3) {
      // Profile icon tapped - show drawer
      setState(() {
        _showProfileDrawer = true;
      });
    } else {
      // Navigate to other tabs normally
      setState(() {
        _selectedIndex = index;
        _showProfileDrawer = false;
      });
    }
  }

  void _closeDrawer() {
    setState(() {
      _showProfileDrawer = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Stack(
          children: [
            Scaffold(
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

            // 🔹 Profile Drawer Panel
            if (_showProfileDrawer)
              GestureDetector(
                onTap: _closeDrawer,
                child: Container(
                  color: Colors.black54,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: FractionallySizedBox(
                      widthFactor: 0.75, // 75% of screen width
                      child: Material(
                        elevation: 16,
                        child: ProfileScreen(
                          onClose: _closeDrawer, // Optional close callback
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
