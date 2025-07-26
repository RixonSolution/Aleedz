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
    final weeklyData = viewModel.getWeeklySaleData();

    return AspectRatio(
      aspectRatio: 1.5,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 1000,
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
                reservedSize: 35,
                interval: 50,
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text('${value.toInt()}');
                },
                reservedSize: 35,
                interval: 100,
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  DateTime date = DateTime.now().subtract(
                    Duration(days: (7 - value).toInt()),
                  );
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${date.day}/${date.month}',
                      style: TextStyle(fontSize: 14),
                    ),
                  );
                },
                reservedSize: 40,
              ),
            ),
          ),
          barGroups: List.generate(7, (index) {
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY:
                      weeklyData[index] != null
                          ? double.parse(weeklyData[index].toString())
                          : 0.0,
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
