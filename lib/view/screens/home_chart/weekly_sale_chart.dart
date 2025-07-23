import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WeeklySalesChart extends StatelessWidget {
  final List<List<double>> data = [
    [20, 20, 20, 20, 10], // Day 1
    [25, 20, 20, 15, 10], // Day 2
    [30, 25, 15, 10, 5], // Day 3
    [35, 20, 20, 15, 5], // Day 4
    [25, 30, 20, 15, 10], // Day 5
    [30, 25, 20, 10, 5], // Day 6
    [28, 22, 20, 15, 10], // Day 7
  ];

  final List<Color> colors = [
    Colors.lightBlue.shade100,
    Colors.lightBlue.shade200,
    Colors.lightBlue.shade300,
    Colors.lightBlue.shade400,
    Colors.blue.shade700,
  ];

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barGroups:
            data.asMap().entries.map((entry) {
              int dayIndex = entry.key;
              List<double> values = entry.value;
              double runningTotal = 0;

              return BarChartGroupData(
                x: dayIndex,
                barRods: [
                  BarChartRodData(
                    fromY: 0,
                    toY: values.reduce((a, b) => a + b),
                    rodStackItems: List.generate(values.length, (i) {
                      final from = runningTotal;
                      final to = from + values[i];
                      runningTotal = to;
                      return BarChartRodStackItem(from, to, colors[i]);
                    }),
                    width: 18,
                  ),
                ],
              );
            }).toList(),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget:
                  (value, meta) => Text(
                    'Day ${value.toInt() + 1}',
                    style: TextStyle(fontSize: 10),
                  ),
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 28),
          ),
        ),
        gridData: FlGridData(show: false),
      ),
    );
  }
}
