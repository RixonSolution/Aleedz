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
    Color(0xFF67E8F9),
    Color(0xFF22D3EE),
    Color(0xFF06B6D4),
    Color(0xFF0891B2),
    Color(0xFFA855F7),
  ];

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(homeChartMP);
    final weeklyEntries = viewModel.getWeeklySaleData();

    final maxValue =
        weeklyEntries.isNotEmpty
            ? weeklyEntries
                .map((entry) => entry.value)
                .reduce((a, b) => a > b ? a : b)
            : 0.0;

    // Add 10% buffer
    final adjustedMax = maxValue + (maxValue * 0.1);

    return AspectRatio(
      aspectRatio: 1.5,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: adjustedMax,
          minY: 0,
          groupsSpace: 12,
          barTouchData: BarTouchData(enabled: true),
          gridData: FlGridData(show: false), // Optional: hide grid lines
          borderData: FlBorderData(
            show: true,
            border: const Border(
              top: BorderSide.none,
              bottom: BorderSide(
                width: 1,
                color: Colors.grey,
              ), // optional bottom line
              left: BorderSide.none,
              right: BorderSide.none,
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false), // Hides left values
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false), // Hides right values
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= weeklyEntries.length) {
                    return const SizedBox.shrink();
                  }
                  final amount = weeklyEntries[index].value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      amount.round().toString(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= weeklyEntries.length) {
                    return const SizedBox.shrink();
                  }
                  final date = weeklyEntries[index].date;
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text('${date.day}/${date.month}'),
                  );
                },
                reservedSize: 32,
              ),
            ),
          ),
          barGroups: List.generate(weeklyEntries.length, (index) {
            final entry = weeklyEntries[index];
            final value = entry.value;

            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: value,
                  gradient: LinearGradient(
                    colors: const [
                      Color(0xFF67E8F9),
                      Color(0xFF06B6D4),
                    ],
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
