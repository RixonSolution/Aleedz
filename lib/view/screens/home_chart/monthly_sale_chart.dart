import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MonthlySalesChart extends StatelessWidget {
  final double achieved = 800;
  final double target = 1000;
  final double percent = 800 / 1000;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        PieChart(
          PieChartData(
            startDegreeOffset: 270,
            sectionsSpace: 0,
            centerSpaceRadius: 60,
            sections: [
              PieChartSectionData(
                color: Colors.blue,
                value: percent * 100,
                radius: 40,
                showTitle: false,
              ),
              PieChartSectionData(
                color: Colors.grey.shade300,
                value: (1 - percent) * 100,
                radius: 40,
                showTitle: false,
              ),
            ],
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "${(percent * 100).toInt()}%",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text("Achievement", style: TextStyle(fontSize: 14)),
          ],
        ),
      ],
    );
  }
}
