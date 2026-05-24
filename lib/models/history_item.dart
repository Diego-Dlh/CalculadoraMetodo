import 'method_result.dart';
import '../methods/numerical_method.dart';

/// Entrada del historial de cálculos.
class HistoryItem {
  final MethodResult result;
  final DateTime timestamp;

  const HistoryItem({required this.result, required this.timestamp});

  String get methodName => NumericalMethodConfig.of(result.methodType).name;
}
