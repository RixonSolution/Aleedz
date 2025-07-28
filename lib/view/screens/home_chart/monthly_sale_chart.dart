import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/services/label_services.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MonthlySalesChart extends StatefulWidget {
  dynamic achieved, target;

  MonthlySalesChart({super.key, required this.achieved, required this.target});

  @override
  State<MonthlySalesChart> createState() => _MonthlySalesChartState();
}

class _MonthlySalesChartState extends State<MonthlySalesChart> {
  double percent = 0.0;

  @override
  void initState() {
    percent = widget.achieved / widget.target;

    super.initState();
  }

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
                color: AppColors.secondary,
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
              _getPercentageText(percent),
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              "${LabelService().getLabel(91)}",
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }

  String _getPercentageText(double? percent) {
    if (percent == null || percent.isNaN || percent.isInfinite) {
      return "0%";
    }
    return "${(percent * 100).toInt()}%";
  }
}
