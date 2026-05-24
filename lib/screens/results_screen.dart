import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/method_result.dart';
import '../providers/calculator_provider.dart';
import '../utils/app_theme.dart';
import '../utils/number_formatter.dart';
import '../widgets/function_chart.dart';
import '../widgets/iteration_table.dart';
import '../widgets/result_summary_card.dart';
import '../methods/numerical_method.dart';

/// Pantalla de resultados genérica para todos los métodos.
class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final result = context.watch<CalculatorProvider>().result;
    if (result == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Resultados')),
        body: const Center(child: Text('Sin resultados',
            style: TextStyle(color: AppTheme.textSecondary))),
      );
    }

    final config = NumericalMethodConfig.of(result.methodType);

    return Scaffold(
      appBar: AppBar(
        title: Text('${config.name} — Resultados'),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy_rounded),
            tooltip: 'Copiar tabla',
            onPressed: () => _copyResult(context, result),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
        children: [
          _buildBadge(result, config),
          const SizedBox(height: 16),
          _buildRootCard(result, config),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: ResultSummaryCard(
              label: 'Iteraciones',
              value: result.iterations.toString(),
              icon: Icons.repeat_rounded,
              color: config.color,
              subtitle: result.converged ? 'Convergió' : 'Límite alcanzado',
            )),
            const SizedBox(width: 10),
            Expanded(child: ResultSummaryCard(
              label: 'Error final',
              value: '${result.finalError.toStringAsFixed(6)} %',
              icon: Icons.precision_manufacturing_rounded,
              color: AppTheme.success,
              subtitle: 'Error relativo',
            )),
          ]),
          const SizedBox(height: 20),
          _sectionTitle(Icons.show_chart_rounded, 'Gráfica f(x)',
              'Toca la curva para ver valores'),
          const SizedBox(height: 10),
          SizedBox(
            height: 240,
            child: FunctionChart(
              function: result.chartFunction,
              root: result.root,
              rangeMin: result.chartMin,
              rangeMax: result.chartMax,
            ),
          ),
          const SizedBox(height: 20),
          _sectionTitle(Icons.table_chart_rounded, 'Tabla Iterativa',
              '${result.table.length} filas — desliza horizontal'),
          const SizedBox(height: 10),
          IterationTable(
            columnNames: result.columnNames,
            rows: result.table,
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(MethodResult result, NumericalMethodConfig config) {
    final bool ok = result.converged;
    final Color c = ok ? AppTheme.success : AppTheme.accent;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.withValues(alpha: 0.4)),
      ),
      child: Row(children: [
        Icon(ok ? Icons.check_circle_rounded : Icons.warning_amber_rounded,
            color: c, size: 20),
        const SizedBox(width: 10),
        Expanded(child: Text(
          ok
              ? 'Convergencia alcanzada en ${result.iterations} iteraciones'
              : 'Se alcanzó el máximo de iteraciones (${result.iterations})',
          style: TextStyle(color: c, fontSize: 13, fontWeight: FontWeight.w600),
        )),
      ]),
    );
  }

  Widget _buildRootCard(MethodResult result, NumericalMethodConfig config) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [config.color.withValues(alpha: 0.2), AppTheme.surface],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: config.color.withValues(alpha: 0.5), width: 1.5),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('RAÍZ APROXIMADA',
            style: TextStyle(color: config.color, fontSize: 10,
                fontWeight: FontWeight.w700, letterSpacing: 1.5)),
        const SizedBox(height: 8),
        SelectableText(
          NumberFormatter.smart(result.root, 10),
          style: TextStyle(color: config.color, fontSize: 26,
              fontWeight: FontWeight.w700, fontFamily: 'monospace'),
        ),
        const SizedBox(height: 4),
        Text(result.inputSummary,
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
      ]),
    );
  }

  Widget _sectionTitle(IconData icon, String title, String sub) {
    return Row(children: [
      Icon(icon, color: AppTheme.primary, size: 18),
      const SizedBox(width: 8),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(color: AppTheme.textPrimary,
            fontSize: 14, fontWeight: FontWeight.w700)),
        Text(sub, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
      ]),
    ]);
  }

  void _copyResult(BuildContext context, MethodResult result) {
    final sb = StringBuffer();
    sb.writeln('=== ${NumericalMethodConfig.of(result.methodType).name} ===');
    sb.writeln('Raíz: ${result.root.toStringAsFixed(10)}');
    sb.writeln('Iteraciones: ${result.iterations}');
    sb.writeln('Error: ${result.finalError.toStringAsFixed(6)} %');
    sb.writeln('Convergió: ${result.converged}');
    sb.writeln();
    sb.writeln('N°\t${result.columnNames.join('\t')}\tError(%)');
    for (final r in result.table) {
      sb.writeln('${r.iteration}\t'
          '${r.values.map((v) => v.toStringAsFixed(6)).join('\t')}\t'
          '${r.error?.toStringAsFixed(6) ?? "---"}');
    }
    Clipboard.setData(ClipboardData(text: sb.toString()));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Resultados copiados al portapapeles'),
          duration: Duration(seconds: 2)),
    );
  }
}
