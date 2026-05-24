import '../models/iteration_row.dart';
import '../models/method_result.dart';
import '../services/math_service.dart';
import 'numerical_method.dart';

/// Implementación del Método de Punto Fijo.
///
/// Reorganiza f(x)=0 como x=g(x) e itera xₙ₊₁ = g(xₙ).
/// Converge cuando |g'(x*)| < 1 cerca de la raíz.
class FixedPointMethod implements NumericalMethod {
  @override
  NumericalMethodType get type => NumericalMethodType.fixedPoint;

  @override
  MethodResult calculate(Map<String, String> params) {
    final String gFn = _require(params, 'gFunction');
    final double x0 = _parseDouble(params, 'x0');
    final double tol = _parseDouble(params, 'tolerance');
    final int maxIter = _parseInt(params, 'maxIterations');

    if (!MathService.isSyntaxValid(gFn)) throw Exception('Función g(x) no válida');
    if (tol <= 0) throw Exception('La tolerancia debe ser > 0');
    if (maxIter <= 0 || maxIter > 10000) throw Exception('Iteraciones: 1 – 10000');

    double x = x0;
    double prevError = double.infinity;
    int iter = 0;
    bool converged = false;
    final rows = <IterationRow>[];

    while (iter < maxIter) {
      iter++;
      final double xNew = MathService.evaluate(gFn, x);

      if (xNew.isNaN || xNew.isInfinite) {
        throw Exception('g(x) produce un valor indefinido en x=${x.toStringAsFixed(6)}.\nVerifique la función.');
      }

      final double denom = xNew.abs() < 1e-15 ? 1e-15 : xNew.abs();
      final double errorPct = ((xNew - x) / denom).abs() * 100.0;

      rows.add(IterationRow(
        iteration: iter,
        values: [x, xNew],
        error: iter == 1 ? null : errorPct,
      ));

      // Detección de divergencia: si el error crece consistentemente
      if (iter > 5 && errorPct > prevError * 5) {
        throw Exception(
          'El método diverge. Verifique que |g\'(x)| < 1 cerca de la raíz.\n'
          'Pruebe reformular g(x) o cambiar x₀.',
        );
      }

      if (errorPct < tol) { converged = true; x = xNew; break; }

      prevError = errorPct;
      x = xNew;
    }

    // Para el gráfico, representamos g(x)-x = 0 (equivale a encontrar el punto fijo)
    final String chartFn = '($gFn) - x';
    final double range = 3.0;
    return MethodResult(
      methodType: type,
      root: x,
      iterations: iter,
      finalError: rows.last.error ?? 100.0,
      converged: converged,
      columnNames: const ['xₙ', 'g(xₙ) = xₙ₊₁'],
      table: rows,
      chartFunction: chartFn,
      chartMin: x - range,
      chartMax: x + range,
      inputSummary: 'g(x)=$gFn  x₀=${x0.toStringAsFixed(3)}',
    );
  }

  String _require(Map<String, String> p, String key) {
    final v = p[key]?.trim() ?? '';
    if (v.isEmpty) throw Exception('Campo "$key" requerido');
    return v;
  }

  double _parseDouble(Map<String, String> p, String key) {
    final v = _require(p, key);
    return double.tryParse(v) ?? (throw Exception('"$key" debe ser un número válido'));
  }

  int _parseInt(Map<String, String> p, String key) {
    final v = _require(p, key);
    return int.tryParse(v) ?? (throw Exception('"$key" debe ser un entero'));
  }
}
