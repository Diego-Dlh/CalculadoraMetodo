import '../models/bisection_result.dart';
import '../models/iteration_data.dart';
import 'math_service.dart';

/// Implementa el algoritmo iterativo del Método de Bisección.
///
/// El Método de Bisección es un algoritmo de búsqueda de raíces que divide
/// repetidamente un intervalo [a, b] a la mitad y selecciona el subintervalo
/// donde se garantiza que existe al menos una raíz (por el Teorema de Bolzano).
class BisectionService {
  /// Ejecuta el método de bisección para encontrar una raíz de [function]
  /// en el intervalo [[a], [b]] con tolerancia [tolerance] y máximo de
  /// [maxIterations] iteraciones.
  ///
  /// Condición previa: f(a) · f(b) < 0 (signos opuestos garantizan raíz).
  static BisectionResult calculate({
    required String function,
    required double a,
    required double b,
    required double tolerance,
    required int maxIterations,
  }) {
    final List<IterationData> table = [];

    double currentA = a;
    double currentB = b;
    double c = 0.0;
    double prevC = double.nan;
    double errorPercent = double.infinity;
    int iteration = 0;
    bool converged = false;

    // Evaluar en los extremos del intervalo
    double fa = MathService.evaluate(function, currentA);
    double fb = MathService.evaluate(function, currentB);

    // Verificar condición de Bolzano: f(a)·f(b) < 0
    if (fa * fb >= 0) {
      throw Exception(
        'f(a) · f(b) ≥ 0\n'
        'No se garantiza raíz en el intervalo.\n'
        'f(${currentA.toStringAsFixed(4)}) = ${fa.toStringAsFixed(6)}\n'
        'f(${currentB.toStringAsFixed(4)}) = ${fb.toStringAsFixed(6)}',
      );
    }

    while (iteration < maxIterations) {
      iteration++;

      // Calcular el punto medio del intervalo actual
      c = (currentA + currentB) / 2.0;
      final double fc = MathService.evaluate(function, c);

      // Calcular error relativo porcentual (no aplica en la primera iteración)
      double? errorForRow;
      if (!prevC.isNaN) {
        // Error relativo: |(c_nuevo - c_anterior) / c_nuevo| × 100
        final double denom = c.abs() < 1e-15 ? 1e-15 : c.abs();
        errorPercent = ((c - prevC) / denom).abs() * 100.0;
        errorForRow = errorPercent;
      }

      // Registrar datos de esta iteración en la tabla
      table.add(IterationData(
        iteration: iteration,
        a: currentA,
        b: currentB,
        c: c,
        fc: fc,
        error: errorForRow,
      ));

      // Criterio de parada 1: f(c) exactamente 0 (raíz exacta)
      if (fc.abs() < 1e-14) {
        errorPercent = 0.0;
        converged = true;
        break;
      }

      // Criterio de parada 2: error relativo menor que la tolerancia
      if (errorForRow != null && errorPercent < tolerance) {
        converged = true;
        break;
      }

      // Actualizar el intervalo según el signo de f(c)
      // Si f(a)·f(c) < 0 → la raíz está en [a, c]
      // Si f(a)·f(c) > 0 → la raíz está en [c, b]
      if (fa * fc < 0) {
        currentB = c;
        fb = fc;
      } else {
        currentA = c;
        fa = fc;
      }

      prevC = c;
    }

    final double finalError = errorPercent == double.infinity ? 100.0 : errorPercent;

    return BisectionResult(
      root: c,
      iterations: iteration,
      finalError: finalError,
      table: table,
      converged: converged,
      fa: MathService.evaluate(function, a),
      fb: MathService.evaluate(function, b),
      originalA: a,
      originalB: b,
    );
  }
}
