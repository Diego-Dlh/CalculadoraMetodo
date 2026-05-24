import '../models/iteration_row.dart';
import '../models/method_result.dart';
import '../services/math_service.dart';
import 'numerical_method.dart';

/// Implementación del Método de la Secante.
///
/// Aproxima la derivada de Newton-Raphson usando dos puntos anteriores:
///   xₙ₊₁ = xₙ − f(xₙ)·(xₙ − xₙ₋₁) / (f(xₙ) − f(xₙ₋₁))
///
/// No requiere f'(x) analítica. Convergencia superlineal (orden ≈ 1.618).
class SecantMethod implements NumericalMethod {
  @override
  NumericalMethodType get type => NumericalMethodType.secant;

  @override
  MethodResult calculate(Map<String, String> params) {
    final String fn = _require(params, 'function');
    final double x0 = _parseDouble(params, 'x0');
    final double x1 = _parseDouble(params, 'x1');
    final double tol = _parseDouble(params, 'tolerance');
    final int maxIter = _parseInt(params, 'maxIterations');

    if (!MathService.isSyntaxValid(fn)) throw Exception('Función f(x) no válida');
    if (tol <= 0) throw Exception('La tolerancia debe ser > 0');
    if (maxIter <= 0 || maxIter > 10000) throw Exception('Iteraciones: 1 – 10000');
    if ((x1 - x0).abs() < 1e-14) throw Exception('x₀ y x₁ deben ser diferentes');

    double xPrev = x0;
    double xCurr = x1;
    double errorPct = double.infinity;
    int iter = 0;
    bool converged = false;
    final rows = <IterationRow>[];

    while (iter < maxIter) {
      iter++;
      final double fPrev = MathService.evaluate(fn, xPrev);
      final double fCurr = MathService.evaluate(fn, xCurr);

      final double denomF = fCurr - fPrev;
      if (denomF.abs() < 1e-14) {
        throw Exception(
          'División por cero: f(xₙ) − f(xₙ₋₁) ≈ 0 en iteración $iter.\n'
          'Los dos puntos producen el mismo valor de f — cambie x₀ o x₁.',
        );
      }

      // Fórmula de la Secante
      final double xNew = xCurr - fCurr * (xCurr - xPrev) / denomF;

      final double denom = xNew.abs() < 1e-15 ? 1e-15 : xNew.abs();
      errorPct = ((xNew - xCurr) / denom).abs() * 100.0;

      rows.add(IterationRow(
        iteration: iter,
        values: [xPrev, xCurr, fCurr, xNew],
        error: iter == 1 ? null : errorPct,
      ));

      if (errorPct < tol) { converged = true; xCurr = xNew; break; }
      if (fCurr.abs() < 1e-14) { converged = true; xCurr = xNew; break; }

      xPrev = xCurr;
      xCurr = xNew;
    }

    final double minX = [x0, x1, xCurr].reduce((a, b) => a < b ? a : b);
    final double maxX = [x0, x1, xCurr].reduce((a, b) => a > b ? a : b);
    final double range = (maxX - minX).abs().clamp(1.0, double.infinity);

    return MethodResult(
      methodType: type,
      root: xCurr,
      iterations: iter,
      finalError: rows.last.error ?? 100.0,
      converged: converged,
      columnNames: const ['xₙ₋₁', 'xₙ', 'f(xₙ)', 'xₙ₊₁'],
      table: rows,
      chartFunction: fn,
      chartMin: minX - range * 0.4,
      chartMax: maxX + range * 0.4,
      inputSummary: 'f(x)=$fn  x₀=${x0.toStringAsFixed(3)}, x₁=${x1.toStringAsFixed(3)}',
    );
  }

  String _require(Map<String, String> p, String key) {
    final v = p[key]?.trim() ?? '';
    if (v.isEmpty) throw Exception('Campo "$key" requerido');
    return v;
  }

  double _parseDouble(Map<String, String> p, String key) {
    final v = _require(p, key);
    return double.tryParse(v) ?? (throw Exception('"$key" debe ser número válido'));
  }

  int _parseInt(Map<String, String> p, String key) {
    final v = _require(p, key);
    return int.tryParse(v) ?? (throw Exception('"$key" debe ser entero'));
  }
}
