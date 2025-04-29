import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/constants/app_constants.dart';
import 'package:aleedz/core/constants/assets/app_images.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/view/screens/dashboard/dashboard_view.dart';
import 'package:aleedz/viewmodel/login_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loginProvider);
    final viewModel = ref.read(loginProvider.notifier);

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Top Area (Logo and Text)
            SizedBox(height: 60),
            Image.asset(AppImages.logo1, height: 110, width: 200),
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Text(
                AppConstants.retailMarketing,
                style: TextStyle(
                  color: AppColors.blackColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 40),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Text(
                    '@1 Title of company',
                    style: TextStyle(
                      color: AppColors.blackColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 50),

            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Text(
                '@2 Login',
                style: TextStyle(
                  color: AppColors.blackColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: TextField(
                decoration: InputDecoration(
                  hintText: '@3 username',
                  hintStyle: TextStyle(
                    color: AppColors.blackColor,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: TextField(
                decoration: InputDecoration(
                  hintText: '@4 password',
                  hintStyle: TextStyle(
                    color: AppColors.blackColor,
                    fontSize: 14,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
              child: InkWell(
                onTap: () {
                  NavigationService.navigateTo(DashboardView());
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color:
                        AppColors.secondary, // Background with secondary color
                    border: Border(
                      bottom: BorderSide(
                        color:
                            AppColors
                                .primary, // Bottom border with primary color
                        width:
                            4.0, // Adjust the width to control the thickness of the line
                      ),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '@5 Login',
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 10),
            Center(
              child: Text(
                '@6 Forgot Password ?',
                style: TextStyle(color: AppColors.blackColor, fontSize: 12),
              ),
            ),

            // Spacer to push the copyright to the bottom
            Spacer(),

            // Bottom Area (Copyright)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: Text(AppConstants.copyright)),
            ),
          ],
        ),
      ),
    );
  }
}
