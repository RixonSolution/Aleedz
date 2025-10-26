import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/services/label_services.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MonthlySalesChart extends StatelessWidget {
  final double achieved;
  final double target;

  const MonthlySalesChart({
    super.key,
    required this.achieved,
    required this.target,
  });

  @override
  Widget build(BuildContext context) {
    final double ratio =
        target <= 0 ? 0 : (target == 0 ? 0 : achieved / target);
    final bool hasValidRatio = ratio.isFinite && !ratio.isNaN;
    final double fillRatio = hasValidRatio ? ratio.clamp(0.0, 1.0) : 0.0;
    final double remaining = (1 - fillRatio).clamp(0.0, 1.0);

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
                value: fillRatio * 100,
                radius: 40,
                showTitle: false,
              ),
              PieChartSectionData(
                color: Colors.grey.shade300,
                value: remaining * 100,
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
              _getPercentageText(ratio),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              LabelService().getLabel(91),
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }

  String _getPercentageText(double ratio) {
    if (ratio.isNaN || !ratio.isFinite) {
      return "0%";
    }
    final double scaled = ratio * 100;
    if (scaled.isNaN || !scaled.isFinite) {
      return "0%";
    }
    final int rounded = scaled.round();
    return "${rounded < 0 ? 0 : rounded}%";
  }
}
