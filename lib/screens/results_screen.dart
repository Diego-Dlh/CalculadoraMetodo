import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/bisection_result.dart';
import '../providers/bisection_provider.dart';
import '../utils/app_theme.dart';
import '../utils/number_formatter.dart';
import '../widgets/function_chart.dart';
import '../widgets/iteration_table.dart';
import '../widgets/result_summary_card.dart';

/// Pantalla de resultados: muestra raíz, iteraciones, error, gráfico y tabla.
class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BisectionProvider>();
    final BisectionResult? result = provider.result;

    if (result == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Resultados')),
        body: const Center(
          child: Text(
            'No hay resultados disponibles',
            style: TextStyle(color: AppTheme.textSecondary),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded),
            tooltip: 'Copiar resultado',
            onPressed: () => _copyResult(context, result, provider.function),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
        children: [
          _buildConvergenceBadge(result),
          const SizedBox(height: 16),
          _buildSummaryCards(result),
          const SizedBox(height: 20),
          _buildSection(
            icon: Icons.show_chart_rounded,
            title: 'Gráfica de f(x)',
            subtitle: 'Toca la curva para ver valores exactos',
            child: SizedBox(
              height: 260,
              child: FunctionChart(
                function: provider.function,
                a: provider.a,
                b: provider.b,
                root: result.root,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildFunctionInfo(result, provider.function),
          const SizedBox(height: 16),
          _buildSection(
            icon: Icons.table_chart_rounded,
            title: 'Tabla Iterativa',
            subtitle: '${result.table.length} iteraciones — desliza horizontalmente',
            child: IterationTable(rows: result.table),
          ),
        ],
      ),
    );
  }

  // ── Badge de convergencia ─────────────────────────────────────────────────────
  Widget _buildConvergenceBadge(BisectionResult result) {
    final bool converged = result.converged;
    final Color color = converged ? AppTheme.success : AppTheme.accent;
    final IconData icon = converged
        ? Icons.check_circle_rounded
        : Icons.warning_amber_rounded;
    final String message = converged
        ? 'Convergencia alcanzada en ${result.iterations} iteraciones'
        : 'Se alcanzó el máximo de iteraciones (${result.iterations})';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  // ── Tarjetas de resumen ───────────────────────────────────────────────────────
  Widget _buildSummaryCards(BisectionResult result) {
    return Column(
      children: [
        // Raíz principal — tarjeta grande
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2A1F4A), Color(0xFF1E2235)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppTheme.primary.withValues(alpha: 0.5), width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'RAÍZ APROXIMADA',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              SelectableText(
                NumberFormatter.smart(result.root, 10),
                style: const TextStyle(
                  color: AppTheme.primaryLight,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'monospace',
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'f(raíz) ≈ ${NumberFormatter.fc(
                  // Mostramos el f(c) de la última iteración
                  result.table.isNotEmpty ? result.table.last.fc : 0,
                )}',
                style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        // Tarjetas secundarias en fila
        Row(
          children: [
            Expanded(
              child: ResultSummaryCard(
                label: 'Iteraciones',
                value: result.iterations.toString(),
                icon: Icons.repeat_rounded,
                color: AppTheme.accent,
                subtitle: result.converged ? 'Convergió' : 'Límite alcanzado',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ResultSummaryCard(
                label: 'Error final',
                value: '${result.finalError.toStringAsFixed(6)} %',
                icon: Icons.precision_manufacturing_rounded,
                color: AppTheme.success,
                subtitle: 'Error relativo',
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── Información de la función e intervalo ─────────────────────────────────────
  Widget _buildFunctionInfo(BisectionResult result, String function) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'DETALLES DEL CÁLCULO',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          _infoRow('Función', 'f(x) = $function'),
          _infoRow('Intervalo', '[${result.originalA}, ${result.originalB}]'),
          _infoRow(
            'f(a)',
            NumberFormatter.smart(result.fa),
            valueColor: result.fa < 0 ? AppTheme.accentWarm : AppTheme.success,
          ),
          _infoRow(
            'f(b)',
            NumberFormatter.smart(result.fb),
            valueColor: result.fb < 0 ? AppTheme.accentWarm : AppTheme.success,
          ),
          _infoRow(
            'f(a)·f(b)',
            NumberFormatter.smart(result.fa * result.fb),
            valueColor: (result.fa * result.fb) < 0
                ? AppTheme.success
                : AppTheme.accentWarm,
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
            ),
          ),
          const Text(' : ', style: TextStyle(color: AppTheme.surfaceBorder)),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: valueColor ?? AppTheme.textPrimary,
                fontSize: 12,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Widget de sección con título ──────────────────────────────────────────────
  Widget _buildSection({
    required IconData icon,
    required String title,
    String? subtitle,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppTheme.primary, size: 18),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 11,
                    ),
                  ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  // ── Copiar resultado al portapapeles ──────────────────────────────────────────
  void _copyResult(
    BuildContext context,
    BisectionResult result,
    String function,
  ) {
    final StringBuffer sb = StringBuffer();
    sb.writeln('=== MÉTODO DE BISECCIÓN ===');
    sb.writeln('Función: f(x) = $function');
    sb.writeln('Intervalo: [${result.originalA}, ${result.originalB}]');
    sb.writeln('Raíz aproximada: ${result.root.toStringAsFixed(10)}');
    sb.writeln('Iteraciones: ${result.iterations}');
    sb.writeln('Error final: ${result.finalError.toStringAsFixed(6)} %');
    sb.writeln('Convergió: ${result.converged ? "Sí" : "No"}');
    sb.writeln();
    sb.writeln('N°\ta\t\tb\t\tc\t\tf(c)\t\tError(%)');
    for (final row in result.table) {
      sb.writeln(
        '${row.iteration}\t'
        '${row.a.toStringAsFixed(6)}\t'
        '${row.b.toStringAsFixed(6)}\t'
        '${row.c.toStringAsFixed(6)}\t'
        '${row.fc.toStringAsFixed(6)}\t'
        '${row.error?.toStringAsFixed(6) ?? "---"}',
      );
    }

    Clipboard.setData(ClipboardData(text: sb.toString()));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Resultados copiados al portapapeles'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

