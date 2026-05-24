import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/math_service.dart';
import '../utils/app_theme.dart';

/// Gráfico de f(x) con la raíz marcada. Acepta rangos opcionales.
/// Para Punto Fijo, la función ya viene como g(x)-x.
class FunctionChart extends StatelessWidget {
  final String function;
  final double root;
  final double? rangeMin;
  final double? rangeMax;

  const FunctionChart({
    super.key,
    required this.function,
    required this.root,
    this.rangeMin,
    this.rangeMax,
  });

  List<FlSpot> _generateSpots(double start, double end) {
    const int n = 300;
    final double step = (end - start) / n;
    final List<FlSpot> spots = [];
    for (int i = 0; i <= n; i++) {
      final double x = start + i * step;
      try {
        final double y = MathService.evaluate(function, x);
        if (!y.isNaN && !y.isInfinite && y.abs() < 1e8) {
          spots.add(FlSpot(x, y));
        }
      } catch (_) {}
    }
    return spots;
  }

  @override
  Widget build(BuildContext context) {
    final double start = rangeMin ?? root - 3.0;
    final double end = rangeMax ?? root + 3.0;
    final List<FlSpot> spots = _generateSpots(start, end);

    if (spots.isEmpty) {
      return const Center(
        child: Text('No se puede graficar en este rango',
            style: TextStyle(color: AppTheme.textSecondary)),
      );
    }

    final double minY = spots.map((s) => s.y).reduce(math.min);
    final double maxY = spots.map((s) => s.y).reduce(math.max);
    final double yRange = (maxY - minY).abs();
    final double yPad = yRange < 0.001 ? 1.0 : yRange * 0.15;

    return LineChart(
      LineChartData(
        minX: start,
        maxX: end,
        minY: minY - yPad,
        maxY: maxY + yPad,
        gridData: FlGridData(
          show: true,
          getDrawingHorizontalLine: (_) =>
              FlLine(color: Colors.white.withValues(alpha: 0.07), strokeWidth: 1),
          getDrawingVerticalLine: (_) =>
              FlLine(color: Colors.white.withValues(alpha: 0.07), strokeWidth: 1),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              getTitlesWidget: (v, _) => Text(_fmt(v),
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 9),
                  textAlign: TextAlign.right),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 26,
              getTitlesWidget: (v, _) => Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(_fmt(v),
                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 9)),
              ),
            ),
          ),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(
            show: true, border: Border.all(color: AppTheme.surfaceBorder)),
        extraLinesData: ExtraLinesData(
          horizontalLines: [
            HorizontalLine(
              y: 0,
              color: Colors.white.withValues(alpha: 0.3),
              strokeWidth: 1.2,
              dashArray: [6, 4],
            ),
          ],
          verticalLines: [
            VerticalLine(
              x: root,
              color: AppTheme.accent,
              strokeWidth: 2,
              dashArray: [5, 4],
              label: VerticalLineLabel(
                show: true,
                alignment: Alignment.topRight,
                padding: const EdgeInsets.only(left: 4, bottom: 4),
                style: const TextStyle(color: AppTheme.accent, fontSize: 9,
                    fontWeight: FontWeight.bold),
                labelResolver: (_) => 'raíz',
              ),
            ),
          ],
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            curveSmoothness: 0.3,
            color: AppTheme.primaryLight,
            barWidth: 2.5,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
                show: true,
                color: AppTheme.primary.withValues(alpha: 0.06)),
          ),
          LineChartBarData(
            spots: [FlSpot(root, 0)],
            color: AppTheme.accent,
            barWidth: 0,
            dotData: FlDotData(
              show: true,
              getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                radius: 7,
                color: AppTheme.accent,
                strokeColor: Colors.white,
                strokeWidth: 2,
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: AppTheme.surfaceVariant,
            tooltipRoundedRadius: 8,
            getTooltipItems: (spots) => spots.map((s) => LineTooltipItem(
              'x=${s.x.toStringAsFixed(4)}\nf(x)=${s.y.toStringAsFixed(4)}',
              const TextStyle(color: AppTheme.textPrimary, fontSize: 10,
                  fontFamily: 'monospace'),
            )).toList(),
          ),
        ),
      ),
      duration: Duration.zero,
    );
  }

  String _fmt(double v) {
    if (v.abs() >= 1000 || (v.abs() < 0.01 && v != 0)) {
      return v.toStringAsExponential(1);
    }
    return v.toStringAsFixed(v.truncateToDouble() == v ? 0 : 2);
  }
}
