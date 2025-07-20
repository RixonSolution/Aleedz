import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/view/screens/%20login/login_view.dart';
import 'package:aleedz/view/screens/issues/issues.view.dart';
import 'package:aleedz/view/screens/issues/issues_list.dart';
import 'package:aleedz/view/screens/pending_deployment/pending_deployment.dart';
import 'package:aleedz/view/screens/sales/sale_view.dart';
import 'package:aleedz/view/screens/store_share/store_share_view.dart';
import 'package:aleedz/view/screens/user_training/user_training_list_view.dart';
import 'package:aleedz/viewmodel/store_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final VoidCallback? onClose;

  const ProfileScreen({super.key, this.onClose});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  Future<void> _showLogoutDialog(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.secondary,
            title: const Text(
              'Logout',
              style: TextStyle(color: AppColors.whiteColor),
            ),
            content: const Text(
              'Are you sure you want to logout?',
              style: TextStyle(color: AppColors.whiteColor),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'No',
                  style: TextStyle(color: AppColors.whiteColor),
                ),
              ),
              TextButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.clear();
                  NavigationService.resetTo(LoginView());
                },
                child: const Text(
                  'Yes',
                  style: TextStyle(color: AppColors.whiteColor),
                ),
              ),
            ],
          ),
    );
  }

  List<Map<String, dynamic>> getMenuItems(BuildContext context) {
    return [
      {
        'title': LabelService().getLabel(83),
        'icon': Icons.person,
        'onTap': () {},
      },
      {
        'title': LabelService().getLabel(84),
        'icon': Icons.lock,
        'onTap': () {},
      },
      {
        'title': LabelService().getLabel(81),
        'icon': Icons.school,
        'onTap': () {
          NavigationService.navigateTo(UserTrainingListView());
        },
        'visible': true,
      },
      {
        'title': LabelService().getLabel(82),
        'icon': Icons.school,
        'onTap': () {
          NavigationService.navigateTo(PendingDeplomentView());
        },
        'visible': true,
      },
      {
        'title': 'Sellout',
        'icon': Icons.school,
        'onTap': () {
          NavigationService.navigateTo(
            IssuesView(checkInTime: '05:30', storeName: 'STC', storeId: 0),
          );
        },
        'visible': true,
      },
      {
        'title': 'Store Share',
        'icon': Icons.school,
        'onTap': () {
          NavigationService.navigateTo(
            SaleView(checkInTime: '05:30', storeName: 'STC', storeId: 0),
          );

          // NavigationService.navigateTo(
          //   StoreShareView(checkInTime: '05:30', storeName: 'STC', storeId: 0),
          // );
        },
        'visible': true,
      },
      {
        'title': LabelService().getLabel(85),
        'icon': Icons.logout,
        'onTap': () {
          _showLogoutDialog(context);
        },
      },
    ];
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // _initializeData();
    });
  }

  Future<void> _initializeData() async {
    final notifier = ref.read(storeModelProvider.notifier);
    await notifier.getROSLabels();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(storeModelProvider);
    final menuItems = getMenuItems(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        // borderRadius: BorderRadius.horizontal(left: Radius.circular(16)),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
      ),
      child: Column(
        children: [
          // Custom AppBar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: const BorderRadius.only(
                // topLeft: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Account",
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.whiteColor),
                  onPressed: widget.onClose,
                ),
              ],
            ),
          ),

          // Body
          Expanded(
            child:
                viewModel.loader
                    ? const Center(child: CircularProgressIndicator())
                    : ListView(
                      children:
                          menuItems
                              .where((item) => item['visible'] != false)
                              .map(
                                (item) => ListTile(
                                  leading: Icon(
                                    item['icon'],
                                    color: Colors.blue,
                                  ),
                                  title: Text(item['title']),
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                  ),
                                  onTap: item['onTap'],
                                ),
                              )
                              .toList(),
                    ),
          ),
        ],
      ),
    );
  }
}
