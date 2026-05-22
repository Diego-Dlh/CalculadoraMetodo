import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/math_service.dart';
import '../utils/app_theme.dart';

/// Gráfico de línea que visualiza la función f(x) en el intervalo estudiado.
/// Marca la raíz encontrada con una línea vertical y punto resaltado.
class FunctionChart extends StatelessWidget {
  final String function;
  final double a;
  final double b;
  final double root;

  const FunctionChart({
    super.key,
    required this.function,
    required this.a,
    required this.b,
    required this.root,
  });

  /// Genera los puntos (x, f(x)) para graficar la función.
  /// Extiende el rango un 30% a cada lado para mostrar contexto.
  List<FlSpot> _generateSpots() {
    final double range = (b - a).abs();
    final double start = a - range * 0.3;
    final double end = b + range * 0.3;
    const int numPoints = 300;
    final double step = (end - start) / numPoints;
    final List<FlSpot> spots = [];

    for (int i = 0; i <= numPoints; i++) {
      final double x = start + i * step;
      try {
        final double y = MathService.evaluate(function, x);
        // Filtrar puntos con valores extremos que distorsionarían el gráfico
        if (!y.isNaN && !y.isInfinite && y.abs() < 1e8) {
          spots.add(FlSpot(x, y));
        }
      } catch (_) {
        // Saltar puntos donde la función no está definida
      }
    }
    return spots;
  }

  @override
  Widget build(BuildContext context) {
    final List<FlSpot> spots = _generateSpots();

    if (spots.isEmpty) {
      return const Center(
        child: Text(
          'No se puede graficar la función en este intervalo',
          style: TextStyle(color: AppTheme.textSecondary),
          textAlign: TextAlign.center,
        ),
      );
    }

    // Calcular límites del gráfico
    final double minY = spots.map((s) => s.y).reduce(math.min);
    final double maxY = spots.map((s) => s.y).reduce(math.max);
    final double minX = spots.map((s) => s.x).reduce(math.min);
    final double maxX = spots.map((s) => s.x).reduce(math.max);
    final double yRange = (maxY - minY).abs();
    final double yPad = yRange < 0.001 ? 1.0 : yRange * 0.15;

    return LineChart(
      LineChartData(
        minX: minX,
        maxX: maxX,
        minY: minY - yPad,
        maxY: maxY + yPad,

        // Cuadrícula de fondo
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          getDrawingHorizontalLine: (_) => FlLine(
            color: Colors.white.withValues(alpha: 0.07),
            strokeWidth: 1,
          ),
          getDrawingVerticalLine: (_) => FlLine(
            color: Colors.white.withValues(alpha: 0.07),
            strokeWidth: 1,
          ),
        ),

        // Títulos de los ejes
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 52,
              getTitlesWidget: (value, meta) => Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Text(
                  _formatAxisLabel(value),
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 10,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              getTitlesWidget: (value, meta) => Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  _formatAxisLabel(value),
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 10,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),

        borderData: FlBorderData(
          show: true,
          border: Border.all(color: AppTheme.surfaceBorder),
        ),

        // Líneas extra: eje y=0 y línea vertical en la raíz
        extraLinesData: ExtraLinesData(
          horizontalLines: [
            HorizontalLine(
              y: 0,
              color: Colors.white.withValues(alpha: 0.25),
              strokeWidth: 1.5,
              dashArray: [6, 4],
              label: HorizontalLineLabel(
                show: true,
                alignment: Alignment.topRight,
                padding: const EdgeInsets.only(right: 8, bottom: 4),
                style: const TextStyle(
                  color: Colors.white38,
                  fontSize: 10,
                ),
                labelResolver: (_) => 'y = 0',
              ),
            ),
          ],
          verticalLines: [
            // Intervalo a
            VerticalLine(
              x: a,
              color: AppTheme.accentWarm.withValues(alpha: 0.6),
              strokeWidth: 1.5,
              dashArray: [4, 4],
              label: VerticalLineLabel(
                show: true,
                alignment: Alignment.topRight,
                padding: const EdgeInsets.only(left: 4, bottom: 4),
                style: const TextStyle(color: AppTheme.accentWarm, fontSize: 9),
                labelResolver: (_) => 'a',
              ),
            ),
            // Intervalo b
            VerticalLine(
              x: b,
              color: AppTheme.accentWarm.withValues(alpha: 0.6),
              strokeWidth: 1.5,
              dashArray: [4, 4],
              label: VerticalLineLabel(
                show: true,
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.only(right: 4, bottom: 4),
                style: const TextStyle(color: AppTheme.accentWarm, fontSize: 9),
                labelResolver: (_) => 'b',
              ),
            ),
            // Raíz encontrada
            VerticalLine(
              x: root,
              color: AppTheme.accent,
              strokeWidth: 2,
              label: VerticalLineLabel(
                show: true,
                alignment: Alignment.topRight,
                padding: const EdgeInsets.only(left: 4, bottom: 4),
                style: const TextStyle(
                  color: AppTheme.accent,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
                labelResolver: (_) => 'raíz',
              ),
            ),
          ],
        ),

        lineBarsData: [
          // Curva de la función f(x)
          LineChartBarData(
            spots: spots,
            isCurved: true,
            curveSmoothness: 0.3,
            color: AppTheme.primaryLight,
            barWidth: 2.5,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: AppTheme.primary.withValues(alpha: 0.06),
            ),
          ),
          // Punto de la raíz en y=0
          LineChartBarData(
            spots: [FlSpot(root, 0)],
            isCurved: false,
            color: AppTheme.accent,
            barWidth: 0,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
                radius: 7,
                color: AppTheme.accent,
                strokeColor: Colors.white,
                strokeWidth: 2,
              ),
            ),
          ),
        ],

        // Tooltip al tocar la gráfica
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: AppTheme.surfaceVariant,
            tooltipRoundedRadius: 8,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                return LineTooltipItem(
                  'x = ${spot.x.toStringAsFixed(4)}\n'
                  'f(x) = ${spot.y.toStringAsFixed(4)}',
                  const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 11,
                    fontFamily: 'monospace',
                  ),
                );
              }).toList();
            },
          ),
          handleBuiltInTouches: true,
        ),
      ),
      duration: const Duration(milliseconds: 0),
    );
  }

  String _formatAxisLabel(double value) {
    if (value.abs() >= 1000 || (value.abs() < 0.01 && value != 0)) {
      return value.toStringAsExponential(1);
    }
    return value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 2);
  }
}

