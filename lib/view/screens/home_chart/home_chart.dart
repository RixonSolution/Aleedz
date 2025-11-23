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

class _LegendDot extends StatelessWidget {
  final String label;
  final Color color;
  const _LegendDot({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.greyText),
        ),
      ],
    );
  }
}

class _TargetAchievementCard extends StatelessWidget {
  final String monthLabel;
  final bool isQty;
  final List summaries;

  const _TargetAchievementCard({
    Key? key,
    required this.monthLabel,
    required this.isQty,
    required this.summaries,
  }) : super(key: key);

  double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    double totalTarget = 0;
    double totalAchieved = 0;
    for (final s in summaries) {
      totalTarget += _toDouble(s.target);
      totalAchieved += _toDouble(s.achieved);
    }
    final percent = totalTarget > 0 ? (totalAchieved / totalTarget) * 100 : 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Target Achievement',
                style: TextStyle(
                  color: AppColors.blackColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    monthLabel,
                    style: const TextStyle(
                      color: AppColors.blackColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    isQty ? 'Qty' : 'Value',
                    style: const TextStyle(
                      color: AppColors.greyText,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Center(
            child: SizedBox(
              height: 160,
              width: 160,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 160,
                    width: 160,
                    child: CircularProgressIndicator(
                      value: (percent / 100).clamp(0.0, 1.0),
                      strokeWidth: 14,
                      backgroundColor: Colors.grey.shade200,
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Achievement',
                        style: TextStyle(
                          color: AppColors.greyText,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '${percent.toStringAsFixed(0)}%',
                        style: const TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      'Target',
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      totalTarget.toStringAsFixed(0),
                      style: const TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      'Achieved',
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      totalAchieved.toStringAsFixed(0),
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
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

  String _initialsFromName(String name) {
    if (name.trim().isEmpty) return 'NA';
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
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
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade200),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 56,
                            width: 56,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFF7A1A), Color(0xFFF0530F)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                _initialsFromName(
                                  viewModel.user?.teamMemberName ?? '',
                                ),
                                style: const TextStyle(
                                  color: AppColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${viewModel.user?.teamMemberName ?? ""}',
                                style: const TextStyle(
                                  color: Color(0xFF111827),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${viewModel.user?.teamTypeName ?? ""}',
                                style: const TextStyle(
                                  color: Color(0xFF4B5563),
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${viewModel.user?.divisionName ?? ""}',
                                style: const TextStyle(
                                  color: Color(0xFF6B7280),
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),

                              // Stats
                              Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        NavigationService.navigateTo(
                                          DashboardView(initialIndex: 1),
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(14),
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFF3B82F6),
                                              Color(0xFF2563EB),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.public,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                                const SizedBox(width: 6),
                                                Text(
                                                  LabelService().getLabel(11),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 6),
                                            const Text(
                                              'Stores',
                                              style: TextStyle(
                                                color: Colors.white70,
                                                fontSize: 11,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              "${viewModel.storeCount ?? 0}",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 28,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(14),
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFFFF7A1A),
                                            Color(0xFFF0530F),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.event_note,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                formatMonthLabel(
                                                  viewModel.selectedMonth,
                                                ),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          const Text(
                                            'Sales Achieved',
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 11,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
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
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
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
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                        ? AppColors.primary
                                                        : Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                  color: AppColors.primary,
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
                                                          : AppColors.primary,
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
                              if (summaries.isNotEmpty)
                                _TargetAchievementCard(
                                  monthLabel: formatMonthLabel(
                                    viewModel.selectedMonth,
                                  ),
                                  isQty: viewModel.showQty,
                                  summaries: summaries,
                                )
                              else
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.grey.shade200,
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

                              const SizedBox(height: 10),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 10,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      LabelService().getLabel(93),
                                      style: const TextStyle(
                                        color: AppColors.blackColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Wrap(
                                      spacing: 12,
                                      runSpacing: 8,
                                      children: const [
                                        _LegendDot(
                                          label: 'Series 1',
                                          color: Color(0xFF67E8F9),
                                        ),
                                        _LegendDot(
                                          label: 'Series 2',
                                          color: Color(0xFF22D3EE),
                                        ),
                                        _LegendDot(
                                          label: 'Series 3',
                                          color: Color(0xFF06B6D4),
                                        ),
                                        _LegendDot(
                                          label: 'Series 4',
                                          color: Color(0xFF0891B2),
                                        ),
                                        _LegendDot(
                                          label: 'Series 5',
                                          color: Color(0xFFA855F7),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    SizedBox(
                                      height: 250,
                                      child: WeeklySalesChart(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
