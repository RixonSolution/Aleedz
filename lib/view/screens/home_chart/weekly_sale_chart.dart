import 'package:aleedz/viewmodel/home_chart_viewmodel.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WeeklySalesChart extends ConsumerStatefulWidget {
  @override
  ConsumerState<WeeklySalesChart> createState() => _WeeklySalesChartState();
}

class _WeeklySalesChartState extends ConsumerState<WeeklySalesChart> {
  final List<Color> colors = [
    Color(0xFF0a4369),
    Color(0xFF0a4369),
    Color(0xFF0a4369),
    Color(0xFF0a4369),
    Color(0xFF0a4369),
  ];

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(homeChartMP);
    final weeklyDataMap = viewModel.getWeeklySaleData();

    // Extract values and calculate max value
    final values = weeklyDataMap.values;
    final maxValue =
        values.isNotEmpty ? values.reduce((a, b) => a > b ? a : b) : 0.0;

    // Add 10% buffer
    final adjustedMax = maxValue + (maxValue * 0.1);

    // Calculate interval
    final interval = adjustedMax > 0 ? adjustedMax / 4 : 1000;

    return AspectRatio(
      aspectRatio: 1.5,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: adjustedMax,
          minY: 0,
          groupsSpace: 12,
          barTouchData: BarTouchData(enabled: true),
          titlesData: FlTitlesData(
            show: true,
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text('${value.toInt()}');
                },
                reservedSize: 40,
                interval: double.parse(interval.toString()),
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text('${value.toInt()}');
                },
                reservedSize: 40,
                interval: double.parse(interval.toString()),
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final weekdayIndex = value.toInt() + 1;
                  final today = DateTime.now();
                  final weekdayDate = today.subtract(
                    Duration(days: today.weekday - weekdayIndex),
                  );
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text('${weekdayDate.day}/${weekdayDate.month}'),
                  );
                },
                reservedSize: 32,
              ),
            ),
          ),
          barGroups: List.generate(7, (index) {
            // Weekday keys in map are 1 (Monday) to 7 (Sunday)
            final weekday = index + 1;
            final value = weeklyDataMap[weekday] ?? 0.0;

            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: value,
                  gradient: LinearGradient(
                    colors: colors,
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                  width: 20,
                  borderRadius: BorderRadius.circular(2),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
