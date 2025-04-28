import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/view/screens/coverage/coverage_view.dart';
import 'package:aleedz/viewmodel/dashboard_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeView extends ConsumerWidget {
  HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardProvider);
    final viewModel = ref.read(dashboardProvider.notifier);

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person, size: 100),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '@ Muhammad Adeel',
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '@ Visual Merchandiser, Dubai',
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '@ Company Name',
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Divider(color: AppColors.primary),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 28, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '@11 Coverage',
                          style: TextStyle(
                            color: AppColors.secondary,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Stores',
                          style: TextStyle(
                            color: AppColors.secondary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '27',
                          style: TextStyle(
                            color: AppColors.secondary,
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 5),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 28, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Today’s Plan',
                          style: TextStyle(
                            color: AppColors.secondary,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '10-Jan-2025',
                          style: TextStyle(
                            color: AppColors.secondary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '6',
                          style: TextStyle(
                            color: AppColors.secondary,
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 220,

                        child: Text(
                          '@13 Recent Visit',
                          style: TextStyle(
                            color: AppColors.secondary,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 20,
                            color: AppColors.primary,
                          ),
                          SizedBox(
                            width: 200,
                            child: Text(
                              'Emax Mall Of The Emirates,Dubai UAE',
                              style: TextStyle(
                                color: AppColors.blackColor,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      NavigationService.navigateTo(CoverageView());
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 3,
                      ),
                      decoration: BoxDecoration(color: Colors.grey.shade200),
                      child: Column(
                        children: [
                          Text(
                            'Check In:10:11',
                            style: TextStyle(
                              color: AppColors.blackColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '@15 CheckOut',
                            style: TextStyle(
                              color: AppColors.blackColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 220,

                        child: Text(
                          '@13 Recent Visit',
                          style: TextStyle(
                            color: AppColors.secondary,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 20,
                            color: AppColors.primary,
                          ),
                          SizedBox(
                            width: 200,
                            child: Text(
                              'Emax Mall Of The Emirates,Dubai UAE',
                              style: TextStyle(
                                color: AppColors.blackColor,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      NavigationService.navigateTo(CoverageView());
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 3,
                      ),
                      decoration: BoxDecoration(color: AppColors.primary),
                      child: Column(
                        children: [
                          Text(
                            'Check In:10:11',
                            style: TextStyle(
                              color: AppColors.whiteColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '@15 CheckOut',
                            style: TextStyle(
                              color: AppColors.whiteColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
