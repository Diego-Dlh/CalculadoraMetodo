import 'package:flutter/material.dart';
import '../models/iteration_data.dart';
import '../utils/app_theme.dart';
import '../utils/number_formatter.dart';

/// Tabla iterativa horizontal con los datos de cada paso del método de bisección.
/// Usa SingleChildScrollView para manejar el scroll horizontal en pantallas pequeñas.
class IterationTable extends StatelessWidget {
  final List<IterationData> rows;

  const IterationTable({super.key, required this.rows});

  // Columnas de la tabla con sus anchos
  static const List<_Column> _columns = [
    _Column('N°', 44),
    _Column('a', 100),
    _Column('b', 100),
    _Column('c = (a+b)/2', 110),
    _Column('f(c)', 110),
    _Column('Error (%)', 110),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const Divider(height: 1, color: AppTheme.surfaceBorder),
              ...rows.asMap().entries.map(
                (e) => _buildRow(e.value, isEven: e.key.isEven),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: AppTheme.surfaceVariant,
      child: Row(
        children: _columns.map((col) {
          return SizedBox(
            width: col.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              child: Text(
                col.title,
                style: const TextStyle(
                  color: AppTheme.primary,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRow(IterationData row, {required bool isEven}) {
    final bool isRoot = row.fc.abs() < 1e-10;
    final Color rowColor = isRoot
        ? AppTheme.success.withValues(alpha: 0.08)
        : isEven
            ? AppTheme.surface
            : AppTheme.surfaceVariant.withValues(alpha: 0.4);

    final cells = [
      row.iteration.toString(),
      NumberFormatter.smart(row.a),
      NumberFormatter.smart(row.b),
      NumberFormatter.smart(row.c),
      NumberFormatter.fc(row.fc),
      NumberFormatter.error(row.error),
    ];

    return Container(
      color: rowColor,
      child: Row(
        children: _columns.asMap().entries.map((e) {
          final int index = e.key;
          final _Column col = e.value;
          final bool isIterCol = index == 0;
          final bool isFcCol = index == 4;
          final bool isErrorCol = index == 5;

          Color textColor = AppTheme.textPrimary;
          if (isIterCol) textColor = AppTheme.primary;
          if (isFcCol && isRoot) textColor = AppTheme.success;
          if (isErrorCol && row.error != null && row.error! < 0.001) {
            textColor = AppTheme.success;
          }

          return SizedBox(
            width: col.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: Text(
                cells[index],
                style: TextStyle(
                  color: textColor,
                  fontSize: 11,
                  fontFamily: 'monospace',
                  fontWeight: isIterCol ? FontWeight.w700 : FontWeight.w400,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _Column {
  final String title;
  final double width;
  const _Column(this.title, this.width);
}

