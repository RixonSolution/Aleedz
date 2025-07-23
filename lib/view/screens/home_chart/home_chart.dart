import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/constants/app_text_style.dart';
import 'package:aleedz/core/constants/assets/app_icons.dart';
import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/view/screens/dashboard/dashboard_view.dart';
import 'package:aleedz/view/screens/home_chart/monthly_sale_chart.dart';
import 'package:aleedz/view/screens/home_chart/weekly_sale_chart.dart';
import 'package:aleedz/view/screens/open_issues/open_issues_view.dart';
import 'package:aleedz/viewmodel/coverage_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeChartView extends ConsumerStatefulWidget {
  const HomeChartView({super.key});

  @override
  ConsumerState<HomeChartView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeChartView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      loadUserAndFetchCoverage();
    });
  }

  Future<void> loadUserAndFetchCoverage() async {
    await ref.read(coverageModelProvider.notifier).loadUser();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(coverageModelProvider);

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        body:
            viewModel.loader
                ? Center(child: CircularProgressIndicator())
                : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.blackColor,
                                width: 1,
                              ),
                            ),
                            child: const Icon(
                              Icons.person,
                              size: 70,
                              color: AppColors.blackColor,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${viewModel.user?.teamMemberName ?? ""}',
                                style: const TextStyle(
                                  color: AppColors.blackColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '${viewModel.user?.teamTypeName ?? ""}',
                                style: const TextStyle(
                                  color: AppColors.blackColor,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '${viewModel.user?.divisionName ?? ""}',
                                style: const TextStyle(
                                  color: AppColors.blackColor,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const Divider(color: AppColors.primary, height: 5),
                      const SizedBox(height: 5),

                      // Stats
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                NavigationService.navigateTo(
                                  DashboardView(initialIndex: 1),
                                ); //
                              },
                              child: Container(
                                height: 110,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 0,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          AppIcons.coverageNetwork,
                                          height: 20,
                                          width: 20,
                                        ),
                                        SizedBox(
                                          width: 85,
                                          child: Text(
                                            LabelService().getLabel(11),
                                            textAlign: TextAlign.center,
                                            style: AppTextStyles.labelStyle,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "${viewModel.storeCount ?? 0}",
                                      style: AppTextStyles.bigTextStyle,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                NavigationService.navigateTo(
                                  OpenIssuesScreen(),
                                ); //
                              },
                              child: Container(
                                height: 110,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 0,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          AppIcons.toddayPlan,
                                          height: 20,
                                          width: 20,
                                        ),
                                        SizedBox(
                                          width: 85,
                                          child: Text(
                                            'May 2025',
                                            textAlign: TextAlign.center,
                                            style: AppTextStyles.labelStyle,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      'Sale Achieved',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                      "122",
                                      style: AppTextStyles.bigTextStyle,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      GestureDetector(
                        onTap: () {
                          NavigationService.navigateTo(OpenIssuesScreen()); //
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Recent Checked In',
                                    textAlign: TextAlign.center,
                                    style: AppTextStyles.labelStyle,
                                  ),
                                  Text(
                                    'Store Name abc...address',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'In: 10:19',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Check Out',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: AppColors.secondary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 5),
                      Expanded(
                        child: ListView(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Monthly Sales Target",
                                      style: TextStyle(
                                        color: AppColors.blackColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "QTY | Value",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "Jul, 2025",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 200, child: MonthlySalesChart()),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Target\n1000",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Achieved\n800",
                                  textAlign: TextAlign.center,

                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 32),
                            Text(
                              "Last 7 Days Sales",
                              style: TextStyle(
                                color: AppColors.blackColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 250, child: WeeklySalesChart()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}
