import 'iteration_row.dart';
import '../methods/numerical_method.dart';

/// Resultado genérico para cualquier método numérico.
/// Contiene los datos necesarios para mostrar resultados, tabla y gráfica.
class MethodResult {
  final NumericalMethodType methodType;
  final double root;
  final int iterations;
  final double finalError;
  final bool converged;

  /// Nombres de las columnas intermedias (sin "N°" ni "Error %" que siempre se muestran).
  final List<String> columnNames;
  final List<IterationRow> table;

  /// Función a graficar como f(x)=0. Para Punto Fijo es "g(x)-x".
  final String chartFunction;
  final double chartMin;
  final double chartMax;

  /// Resumen de las entradas para mostrar en historial.
  final String inputSummary;

  const MethodResult({
    required this.methodType,
    required this.root,
    required this.iterations,
    required this.finalError,
    required this.converged,
    required this.columnNames,
    required this.table,
    required this.chartFunction,
    required this.chartMin,
    required this.chartMax,
    required this.inputSummary,
  });
}
