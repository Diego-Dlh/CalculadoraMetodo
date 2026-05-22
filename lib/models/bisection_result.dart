import 'iteration_data.dart';

/// Contiene el resultado completo de una ejecución del método de bisección.
class BisectionResult {
  final double root;                    // Raíz aproximada encontrada
  final int iterations;                 // Número total de iteraciones realizadas
  final double finalError;              // Error relativo en la última iteración (%)
  final List<IterationData> table;      // Tabla con los datos de cada iteración
  final bool converged;                 // true si convergió antes del límite de iteraciones
  final double fa;                      // f(a) del intervalo original
  final double fb;                      // f(b) del intervalo original
  final double originalA;              // Límite inferior original
  final double originalB;              // Límite superior original

  const BisectionResult({
    required this.root,
    required this.iterations,
    required this.finalError,
    required this.table,
    required this.converged,
    required this.fa,
    required this.fb,
    required this.originalA,
    required this.originalB,
  });
}
