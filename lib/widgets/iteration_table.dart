import 'package:flutter/material.dart';
import '../models/iteration_row.dart';
import '../utils/app_theme.dart';
import '../utils/number_formatter.dart';

/// Tabla iterativa genérica con scroll horizontal.
/// Las columnas se configuran dinámicamente según el método.
class IterationTable extends StatelessWidget {
  /// Nombres de las columnas intermedias (sin "N°" ni "Error %" que son fijos).
  final List<String> columnNames;
  final List<IterationRow> rows;

  const IterationTable({
    super.key,
    required this.columnNames,
    required this.rows,
  });

  static const double _colWidth = 105.0;
  static const double _nColWidth = 42.0;
  static const double _errColWidth = 110.0;

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
      child: Row(children: [
        _headerCell('N°', _nColWidth),
        ...columnNames.map((n) => _headerCell(n, _colWidth)),
        _headerCell('Error (%)', _errColWidth),
      ]),
    );
  }

  Widget _headerCell(String text, double width) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 11),
        child: Text(
          text,
          style: const TextStyle(
            color: AppTheme.primary,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildRow(IterationRow row, {required bool isEven}) {
    final bool isRootRow = row.values.isNotEmpty &&
        row.error != null &&
        row.error! < 0.0001;

    final Color bg = isRootRow
        ? AppTheme.success.withValues(alpha: 0.08)
        : isEven
            ? AppTheme.surface
            : AppTheme.surfaceVariant.withValues(alpha: 0.4);

    return Container(
      color: bg,
      child: Row(children: [
        _dataCell(row.iteration.toString(), _nColWidth, color: AppTheme.primary, bold: true),
        ...row.values.map((v) => _dataCell(NumberFormatter.smart(v), _colWidth)),
        _dataCell(
          NumberFormatter.error(row.error),
          _errColWidth,
          color: row.error != null && row.error! < 0.001 ? AppTheme.success : null,
        ),
      ]),
    );
  }

  Widget _dataCell(String text, double width, {Color? color, bool bold = false}) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 9),
        child: Text(
          text,
          style: TextStyle(
            color: color ?? AppTheme.textPrimary,
            fontSize: 10,
            fontFamily: 'monospace',
            fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
