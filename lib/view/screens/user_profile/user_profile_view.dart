import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/constants/assets/app_icons.dart';
import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/view/screens/dashboard/dashboard_view.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String? profileImageUrl; // Optional: You can pass null for default icon

  const UserProfile({
    Key? key,
    required this.userName,
    required this.userEmail,
    this.profileImageUrl,
  }) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      // NavigationService.resetTo(
                      //   DashboardView(initialIndex: 0),
                      // ); // or any index like 2
                      NavigationService.goBack();
                    },
                    child: Image.asset(
                      AppIcons.backArrow,
                      height: 30,
                      width: 30,
                    ),
                  ),
                  Text(
                    'Profile',
                    style: TextStyle(
                      color: AppColors.blackColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      // viewModel.getCoverageList(context, forceRefresh: true);
                    },
                    child: Icon(
                      Icons.refresh,
                      size: 30,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Divider(color: AppColors.primary, height: 0),
            ),
            SizedBox(height: 5),
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey[300],

              child: const Icon(
                Icons.person,
                size: 40,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(height: 12),

            // User Name
            Text(
              widget.userName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),

            // User Email
            Text(
              widget.userEmail,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
