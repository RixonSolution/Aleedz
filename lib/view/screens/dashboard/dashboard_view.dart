import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/view/screens/account/account_view.dart';
import 'package:aleedz/view/screens/coverage_details/coverage_view.dart';
import 'package:aleedz/view/screens/home/home_view.dart';
import 'package:aleedz/view/screens/home_chart/home_chart.dart';
import 'package:aleedz/viewmodel/coverage_viewmodel.dart';
import 'package:aleedz/viewmodel/home_chart_viewmodel.dart';
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
  List<Widget> _screens = [SizedBox(), SizedBox(), SizedBox(), SizedBox()];

  static const Color _navBackground = Color(0xFF1f2937);

  Widget _navIcon(IconData icon, bool isActive) {
    final color = isActive ? Colors.white : Colors.white70;
    return Icon(icon, color: color, size: 28);
  }

  // final List<Widget> _screens = [
  //   HomeView(),
  //   CoverageView(),
  //   HomeView(),
  //   SizedBox(), // Placeholder for drawer
  // ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;

    Future.microtask(() {
      loadUserAndFetchCoverage();
    });
  }

  Future<void> loadUserAndFetchCoverage() async {
    final coverageVM = ref.read(coverageModelProvider.notifier);
    final homeChartVM = ref.read(homeChartMP.notifier);

    await coverageVM.loadUser();
    await homeChartVM
        .loadUser(); // ensure same user data is ready for HomeChartView

    final user = coverageVM.user ?? homeChartVM.user;

    setState(() {
      _screens = [
        user?.teamMemberID == 9 ? HomeChartView() : HomeView(),
        CoverageView(),
        user?.teamMemberID == 9 ? HomeChartView() : HomeView(),

        SizedBox(), // Drawer placeholder
      ];
    });
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
    final viewModel = ref.watch(coverageModelProvider);

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
                backgroundColor: _navBackground,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.white70,
                elevation: 10,
                items: [
                  BottomNavigationBarItem(
                    icon: _navIcon(Icons.home_outlined, _selectedIndex == 0),
                    label: LabelService().getLabel(7),
                  ),
                  BottomNavigationBarItem(
                    icon: _navIcon(
                      Icons.shopping_bag_outlined,
                      _selectedIndex == 1,
                    ),
                    label: LabelService().getLabel(8),
                  ),
                  BottomNavigationBarItem(
                    icon: _navIcon(
                      Icons.notifications_none_outlined,
                      _selectedIndex == 2,
                    ),
                    label: LabelService().getLabel(9),
                  ),
                  BottomNavigationBarItem(
                    icon: _navIcon(Icons.person_outline, _selectedIndex == 3),
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
