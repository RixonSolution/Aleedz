import 'dart:io';
import 'package:aleedz/core/constants/api_constants.dart';
import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/view/screens/onboarding/login_view.dart';
import 'package:aleedz/view/screens/change_pwd/change_pwd_view.dart';
import 'package:aleedz/view/screens/user_profile/user_profile_view.dart';
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
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            contentPadding: EdgeInsets.zero,
            insetPadding: const EdgeInsets.symmetric(horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            content: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1f2937), Color(0xFF0f172a)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LabelService().getLabel(85),
                      style: TextStyle(color: AppColors.whiteColor),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      LabelService().getLabel(99),
                      style: TextStyle(color: AppColors.whiteColor),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            LabelService().getLabel(94),
                            style: TextStyle(color: AppColors.whiteColor),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            final prefs = await SharedPreferences.getInstance();
                            final keysToKeep = {
                              ApiConstants.baseUrlPreferenceKey,
                            };
                            for (final key in prefs.getKeys()) {
                              if (!keysToKeep.contains(key)) {
                                await prefs.remove(key);
                              }
                            }
                            NavigationService.resetTo(LoginView());
                          },
                          child: Text(
                            LabelService().getLabel(95),
                            style: TextStyle(color: AppColors.whiteColor),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  List<Map<String, dynamic>> getMenuItems(
    BuildContext context,
    StoreViewModel viewModel,
  ) {
    final notifier = ref.read(storeModelProvider.notifier);
    bool hasRosLabel(int id) =>
        viewModel.rosLabels.any((label) => label.rosLabelID == id);

    return [
      {
        'title': LabelService().getLabel(83),
        'icon': Icons.person,
        'onTap': () async {
          if (widget.onClose != null) widget.onClose!(); // Hide drawer
          await Future.delayed(
            Duration(milliseconds: 300),
          ); // Wait for animation
          NavigationService.navigateTo(
            UserProfile(
              userName: notifier.user?.teamMemberName.toString() ?? '',
              userEmail: notifier.user?.email.toString() ?? '',
            ),
          );
        },
      },
      {
        'title': LabelService().getLabel(84),
        'icon': Icons.lock,
        'onTap': () async {
          if (widget.onClose != null) widget.onClose!(); // Hide drawer
          await Future.delayed(
            Duration(milliseconds: 300),
          ); // Wait for animation
          NavigationService.navigateTo(ChangePassword());
        },
      },

      // {
      //   'title': LabelService().getLabel(81),
      //   'icon': Icons.school,
      //   'onTap': () async {
      //     if (widget.onClose != null) widget.onClose!(); // Hide drawer
      //     await Future.delayed(
      //       Duration(milliseconds: 300),
      //     ); // Wait for animation
      //     NavigationService.navigateTo(UserTrainingListView());
      //   },
      //   'visible': hasRosLabel(30),
      // },
      // {
      //   'title': LabelService().getLabel(82),
      //   'icon': Icons.school,
      //   'onTap': () async {
      //     if (widget.onClose != null) widget.onClose!(); // Hide drawer
      //     await Future.delayed(
      //       Duration(milliseconds: 300),
      //     ); // Wait for animation
      //     NavigationService.navigateTo(PendingDeplomentView());
      //   },
      //   'visible': hasRosLabel(34),
      // },
      // {
      //   'title': 'Sellout',
      //   'icon': Icons.school,
      //   'onTap': () async {
      //     if (widget.onClose != null) widget.onClose!(); // Hide drawer
      //     await Future.delayed(
      //       Duration(milliseconds: 300),
      //     ); // Wait for animation
      //     NavigationService.navigateTo(
      //       IssuesView(checkInTime: '05:30', storeName: 'STC', storeId: 0),
      //     );
      //   },
      //   'visible': hasRosLabel(38),
      // },
      {
        'title': LabelService().getLabel(85),
        'icon': Icons.logout,
        'onTap': () {
          _showLogoutDialog(context);
        },
      },
    ];
  }

  File? _imageFile;

  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('profile_image');
    if (imagePath != null && File(imagePath).existsSync()) {
      setState(() {
        _imageFile = File(imagePath);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfileImage();
      _initializeData();
    });
  }

  Future<void> _initializeData() async {
    final notifier = ref.read(storeModelProvider.notifier);
    await notifier.getROSLabels();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(storeModelProvider);
    final menuItems = getMenuItems(context, viewModel);

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
              color: AppColors.navBarDark,
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // Profile Circle Avatar
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey[300],
                      backgroundImage:
                          _imageFile != null ? FileImage(_imageFile!) : null,
                      child:
                          _imageFile == null
                              ? const Icon(
                                Icons.person,
                                size: 20,
                                color: AppColors.travelBlue,
                              )
                              : null,
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          viewModel.user?.teamMemberName.toString() ?? '',
                          style: const TextStyle(
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          viewModel.user?.email.toString() ??
                              '', // Replace with your user's email variable
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),

                    // const SizedBox(width: 8),
                    // Close Icon
                    // IconButton(
                    //   icon: const Icon(
                    //     Icons.close,
                    //     color: AppColors.whiteColor,
                    //   ),
                    //   onPressed: widget.onClose,
                    // ),
                  ],
                ),
              ],
            ),
          ),

          // Body
          Expanded(
            child: ListView(
              children:
                  menuItems
                      .where((item) => item['visible'] != false)
                      .map(
                        (item) => ListTile(
                          leading: Icon(
                            item['icon'],
                            color: AppColors.travelBlue,
                          ),
                          title: Text(item['title'] ?? ''),
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo.png', height: 80, width: 80),
              Text('www.aleedz.com', style: TextStyle(fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }
}
