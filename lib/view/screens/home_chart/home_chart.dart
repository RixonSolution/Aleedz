import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/constants/app_text_style.dart';
import 'package:aleedz/core/constants/assets/app_icons.dart';
import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/view/screens/dashboard/dashboard_view.dart';
import 'package:aleedz/view/screens/home_chart/weekly_sale_chart.dart';
import 'package:aleedz/viewmodel/home_chart_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeChartView extends ConsumerStatefulWidget {
  const HomeChartView({super.key});

  @override
  ConsumerState<HomeChartView> createState() => _HomeViewState();
}

class _TableHeaderCell extends StatelessWidget {
  const _TableHeaderCell({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
      ),
    );
  }
}

class _TableBodyCell extends StatelessWidget {
  const _TableBodyCell({required this.text, this.alignment = Alignment.center});

  final String text;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      alignment: alignment,
      child: Text(text, style: const TextStyle(fontSize: 13)),
    );
  }
}

class _HomeViewState extends ConsumerState<HomeChartView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      loadUserAndFetchHome();
    });
  }

  Future<void> loadUserAndFetchHome() async {
    await ref.read(homeChartMP.notifier).loadDashboard(context);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(homeChartMP);
    double _toDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString()) ?? 0.0;
    }

    final summaries = viewModel.activeTargetAchievementSummaries;
    const monthAbbreviations = {
      'January': 'Jan',
      'February': 'Feb',
      'March': 'Mar',
      'April': 'Apr',
      'May': 'May',
      'June': 'Jun',
      'July': 'Jul',
      'August': 'Aug',
      'September': 'Sep',
      'October': 'Oct',
      'November': 'Nov',
      'December': 'Dec',
    };
    String formatMonthLabel(String month) {
      final abbrev = monthAbbreviations[month] ?? month;
      final year = viewModel.selectedYear;
      return '$abbrev,$year';
    }

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
                                // NavigationService.navigateTo(
                                //   OpenIssuesScreen(),
                                // ); //
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
                                            'Jul 2025',
                                            textAlign: TextAlign.center,
                                            style: AppTextStyles.labelStyle,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      LabelService().getLabel(161),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                      (viewModel
                                                  .monthlyDashboardSaleModel
                                                  ?.isNotEmpty ??
                                              false)
                                          ? (viewModel
                                                      .monthlyDashboardSaleModel!
                                                      .first
                                                      .saleValue ??
                                                  0.0)
                                              .toStringAsFixed(0)
                                          : '0',
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

                      // GestureDetector(
                      //   onTap: () {
                      //     NavigationService.navigateTo(OpenIssuesScreen()); //
                      //   },
                      //   child: Container(
                      //     padding: const EdgeInsets.symmetric(
                      //       horizontal: 5,
                      //       vertical: 8,
                      //     ),
                      //     decoration: BoxDecoration(
                      //       color: Colors.grey.shade100,
                      //       borderRadius: BorderRadius.circular(12),
                      //     ),
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //       children: [
                      //         Column(
                      //           crossAxisAlignment: CrossAxisAlignment.start,
                      //           children: [
                      //             Text(
                      //               'Recent Checked In',
                      //               textAlign: TextAlign.center,
                      //               style: AppTextStyles.labelStyle,
                      //             ),
                      //             Text(
                      //               'Store Name abc...address',
                      //               textAlign: TextAlign.center,
                      //               style: TextStyle(fontSize: 14),
                      //             ),
                      //           ],
                      //         ),
                      //         Column(
                      //           crossAxisAlignment: CrossAxisAlignment.end,
                      //           children: [
                      //             Text(
                      //               'In: 10:19',
                      //               textAlign: TextAlign.center,
                      //               style: TextStyle(
                      //                 color: AppColors.primary,
                      //                 fontSize: 10,
                      //                 fontWeight: FontWeight.bold,
                      //               ),
                      //             ),
                      //             Text(
                      //               'Check Out',
                      //               textAlign: TextAlign.center,
                      //               style: TextStyle(
                      //                 color: AppColors.secondary,
                      //                 fontSize: 14,
                      //                 fontWeight: FontWeight.bold,
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(height: 5),
                      Expanded(
                        child: ListView(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    LabelService().getLabel(89),
                                    style: TextStyle(
                                      color: AppColors.blackColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap:
                                              () => ref
                                                  .read(homeChartMP.notifier)
                                                  .setShowQty(true),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 10,
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                                  viewModel.showQty
                                                      ? AppColors.secondary
                                                      : Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color: AppColors.secondary,
                                              ),
                                            ),
                                            child: Text(
                                              LabelService().getLabel(162),
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    viewModel.showQty
                                                        ? Colors.white
                                                        : AppColors.secondary,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        InkWell(
                                          onTap:
                                              () => ref
                                                  .read(homeChartMP.notifier)
                                                  .setShowQty(false),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 10,
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                                  !viewModel.showQty
                                                      ? AppColors.secondary
                                                      : Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color: AppColors.secondary,
                                              ),
                                            ),
                                            child: Text(
                                              "Value",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    !viewModel.showQty
                                                        ? Colors.white
                                                        : AppColors.secondary,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                    left: 5,
                                    bottom: 10,
                                    top: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppColors.secondary,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: DropdownButton<String>(
                                    isDense: true,
                                    padding: EdgeInsets.zero,
                                    value: viewModel.selectedMonth,
                                    underline: SizedBox(),
                                    items:
                                        [
                                          'January',
                                          'February',
                                          'March',
                                          'April',
                                          'May',
                                          'June',
                                          'July',
                                          'August',
                                          'September',
                                          'October',
                                          'November',
                                          'December',
                                        ].map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              formatMonthLabel(value),
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                    onChanged: (newValue) {
                                      ref
                                          .read(homeChartMP.notifier)
                                          .updateSelectedMonth(newValue!);
                                    },
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),
                            summaries.isNotEmpty
                                ? Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: AppColors.blackColor,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Table(
                                      columnWidths: const {
                                        0: FlexColumnWidth(2),
                                        1: FlexColumnWidth(),
                                        2: FlexColumnWidth(),
                                        3: FlexColumnWidth(),
                                      },
                                      border: TableBorder.symmetric(
                                        inside: BorderSide(
                                          color: AppColors.blackColor,
                                          width: 0.5,
                                        ),
                                      ),
                                      children: [
                                        TableRow(
                                          decoration: BoxDecoration(
                                            color:
                                                AppColors.lightGreyBackground,
                                          ),
                                          children: const [
                                            _TableHeaderCell(text: 'Brand'),
                                            _TableHeaderCell(text: 'Target'),
                                            _TableHeaderCell(text: 'Achieved'),
                                            _TableHeaderCell(text: '%'),
                                          ],
                                        ),
                                        ...summaries.map((summary) {
                                          return TableRow(
                                            children: [
                                              _TableBodyCell(
                                                alignment: Alignment.centerLeft,
                                                text: summary.brandName,
                                              ),
                                              _TableBodyCell(
                                                text: summary.target
                                                    .toStringAsFixed(0),
                                              ),
                                              _TableBodyCell(
                                                text: summary.achieved
                                                    .toStringAsFixed(0),
                                              ),
                                              _TableBodyCell(
                                                text:
                                                    '${summary.percentage.toStringAsFixed(0)}%',
                                              ),
                                            ],
                                          );
                                        }),
                                      ],
                                    ),
                                  ),
                                )
                                : Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: AppColors.lightGreyBackground,
                                    ),
                                  ),
                                  child: Text(
                                    'No target achievement data available.',
                                    style: TextStyle(
                                      color: AppColors.blackColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),

                            Divider(color: AppColors.secondary),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  LabelService().getLabel(93),
                                  style: TextStyle(
                                    color: AppColors.blackColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            SizedBox(height: 250, child: WeeklySalesChart()),
                            SizedBox(height: 10),
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
