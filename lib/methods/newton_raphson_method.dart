import '../models/iteration_row.dart';
import '../models/method_result.dart';
import '../services/math_service.dart';
import 'numerical_method.dart';

/// Implementación del Método de Newton-Raphson.
///
/// Usa la tangente a la curva para aproximar la raíz:
///   xₙ₊₁ = xₙ − f(xₙ) / f'(xₙ)
///
/// Convergencia cuadrática (orden 2) cerca de la raíz simple.
/// Requiere conocer f'(x) analíticamente y f'(xₙ) ≠ 0.
class NewtonRaphsonMethod implements NumericalMethod {
  @override
  NumericalMethodType get type => NumericalMethodType.newtonRaphson;

  @override
  MethodResult calculate(Map<String, String> params) {
    final String fn = _require(params, 'function');
    final String dfn = _require(params, 'derivative');
    final double x0 = _parseDouble(params, 'x0');
    final double tol = _parseDouble(params, 'tolerance');
    final int maxIter = _parseInt(params, 'maxIterations');

    if (!MathService.isSyntaxValid(fn)) throw Exception('Función f(x) no válida');
    if (!MathService.isSyntaxValid(dfn)) throw Exception('Derivada f\'(x) no válida');
    if (tol <= 0) throw Exception('La tolerancia debe ser > 0');
    if (maxIter <= 0 || maxIter > 10000) throw Exception('Iteraciones: 1 – 10000');

    double x = x0;
    double errorPct = double.infinity;
    int iter = 0;
    bool converged = false;
    final rows = <IterationRow>[];

    while (iter < maxIter) {
      iter++;
      final double fx = MathService.evaluate(fn, x);
      final double dfx = MathService.evaluate(dfn, x);

      // Verificar que la derivada no sea cero (tangente horizontal → sin intersección)
      if (dfx.abs() < 1e-14) {
        throw Exception(
          'f\'(xₙ) ≈ 0 en x=${x.toStringAsFixed(6)}\n'
          'La tangente es horizontal — el método no puede continuar.\n'
          'Cambie x₀ o verifique la derivada.',
        );
      }

      final double xNew = x - fx / dfx;

      final double denom = xNew.abs() < 1e-15 ? 1e-15 : xNew.abs();
      errorPct = ((xNew - x) / denom).abs() * 100.0;

      rows.add(IterationRow(
        iteration: iter,
        values: [x, fx, dfx, xNew],
        error: iter == 1 ? null : errorPct,
      ));

      if (errorPct < tol) { converged = true; x = xNew; break; }
      if (fx.abs() < 1e-14) { converged = true; x = xNew; break; }

      x = xNew;
    }

    final double range = 3.0;
    return MethodResult(
      methodType: type,
      root: x,
      iterations: iter,
      finalError: rows.last.error ?? 100.0,
      converged: converged,
      columnNames: const ['xₙ', 'f(xₙ)', "f'(xₙ)", 'xₙ₊₁'],
      table: rows,
      chartFunction: fn,
      chartMin: x - range,
      chartMax: x + range,
      inputSummary: 'f(x)=$fn  x₀=${x0.toStringAsFixed(3)}',
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
