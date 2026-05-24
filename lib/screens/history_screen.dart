import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../methods/numerical_method.dart';
import '../models/history_item.dart';
import '../providers/history_provider.dart';
import '../utils/app_theme.dart';
import '../utils/number_formatter.dart';

/// Historial en memoria de todos los cálculos realizados en la sesión.
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial'),
        actions: [
          Consumer<HistoryProvider>(
            builder: (_, h, __) => h.isEmpty
                ? const SizedBox.shrink()
                : IconButton(
                    icon: const Icon(Icons.delete_sweep_rounded),
                    tooltip: 'Limpiar historial',
                    onPressed: () => _confirmClear(context, h),
                  ),
          ),
        ],
      ),
      body: Consumer<HistoryProvider>(
        builder: (_, history, __) {
          if (history.isEmpty) return _buildEmpty();
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: history.items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, i) => _HistoryCard(
              item: history.items[i],
              onDelete: () => history.remove(history.count - 1 - i),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmpty() {
    return const Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.history_rounded, color: AppTheme.textSecondary, size: 52),
        SizedBox(height: 14),
        Text('Sin cálculos recientes',
            style: TextStyle(color: AppTheme.textPrimary, fontSize: 16,
                fontWeight: FontWeight.w600)),
        SizedBox(height: 6),
        Text('Los resultados aparecerán aquí\ndespués de calcular.',
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            textAlign: TextAlign.center),
      ]),
    );
  }

  void _confirmClear(BuildContext context, HistoryProvider h) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Limpiar historial',
            style: TextStyle(color: AppTheme.textPrimary)),
        content: const Text('Se eliminarán todos los cálculos guardados.',
            style: TextStyle(color: AppTheme.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar', style: TextStyle(color: AppTheme.textSecondary))),
          TextButton(
            onPressed: () { h.clear(); Navigator.pop(ctx); },
            child: const Text('Limpiar', style: TextStyle(color: AppTheme.accentWarm)),
          ),
        ],
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final HistoryItem item;
  final VoidCallback onDelete;

  const _HistoryCard({required this.item, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final config = NumericalMethodConfig.of(item.result.methodType);
    final r = item.result;
    final String time =
        '${item.timestamp.hour.toString().padLeft(2, '0')}:${item.timestamp.minute.toString().padLeft(2, '0')}';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: config.color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(config.icon, color: config.color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text(config.name,
                  style: const TextStyle(color: AppTheme.textPrimary,
                      fontSize: 13, fontWeight: FontWeight.w700)),
              const Spacer(),
              Text(time,
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
            ]),
            const SizedBox(height: 4),
            Text('Raíz: ${NumberFormatter.smart(r.root, 8)}',
                style: const TextStyle(color: AppTheme.textPrimary, fontSize: 12,
                    fontFamily: 'monospace')),
            const SizedBox(height: 2),
            Row(children: [
              _pill('${r.iterations} iter.', config.color),
              const SizedBox(width: 6),
              _pill('${r.finalError.toStringAsFixed(4)} %', AppTheme.textSecondary),
              const SizedBox(width: 6),
              if (r.converged)
                _pill('Convergió', AppTheme.success)
              else
                _pill('Límite', AppTheme.accentWarm),
            ]),
            const SizedBox(height: 4),
            Text(r.inputSummary,
                style: const TextStyle(color: AppTheme.textSecondary, fontSize: 10),
                overflow: TextOverflow.ellipsis),
          ]),
        ),
        IconButton(
          icon: const Icon(Icons.close_rounded, size: 18, color: AppTheme.textSecondary),
          onPressed: onDelete,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ]),
    );
  }

  Widget _pill(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(text,
          style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600)),
    );
  }
}
