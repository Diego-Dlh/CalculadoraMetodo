import '../models/iteration_row.dart';
import '../models/method_result.dart';
import '../services/math_service.dart';
import 'numerical_method.dart';

/// Implementación del Método de Regla Falsa (Regula Falsi / Posición Falsa).
///
/// Similar a bisección pero el punto c se calcula por interpolación lineal:
///   c = a - f(a)·(b - a) / (f(b) - f(a))
///
/// Converge más rápido que bisección en funciones suaves, pero puede ser
/// lento si el intervalo se contrae poco (efecto de "pegarse" a un extremo).
class FalsePositionMethod implements NumericalMethod {
  @override
  NumericalMethodType get type => NumericalMethodType.falsePosition;

  @override
  MethodResult calculate(Map<String, String> params) {
    final String fn = _require(params, 'function');
    final double a = _parseDouble(params, 'a');
    final double b = _parseDouble(params, 'b');
    final double tol = _parseDouble(params, 'tolerance');
    final int maxIter = _parseInt(params, 'maxIterations');

    if (a >= b) throw Exception('El límite inferior a debe ser menor que b');
    if (tol <= 0) throw Exception('La tolerancia debe ser > 0');
    if (maxIter <= 0 || maxIter > 10000) throw Exception('Iteraciones: 1 – 10000');
    if (!MathService.isSyntaxValid(fn)) throw Exception('Función f(x) no válida');

    double fa = MathService.evaluate(fn, a);
    double fb = MathService.evaluate(fn, b);

    if (fa * fb >= 0) {
      throw Exception(
        'No se cumple Bolzano: f(a)·f(b) ≥ 0\n'
        'f($a) = ${fa.toStringAsFixed(5)}\n'
        'f($b) = ${fb.toStringAsFixed(5)}\n'
        'El intervalo debe contener un cambio de signo.',
      );
    }

    double currentA = a, currentB = b;
    double c = double.nan, prevC = double.nan;
    double errorPct = double.infinity;
    int iter = 0;
    bool converged = false;
    final rows = <IterationRow>[];

    while (iter < maxIter) {
      iter++;
      prevC = c;
      final double denom = fb - fa;
      if (denom.abs() < 1e-14) throw Exception('División por cero: f(b)-f(a) ≈ 0');

      // Fórmula de la Regla Falsa: interpolación lineal entre (a,f(a)) y (b,f(b))
      c = currentA - fa * (currentB - currentA) / denom;
      final double fc = MathService.evaluate(fn, c);

      double? errRow;
      if (!prevC.isNaN) {
        final double d = c.abs() < 1e-15 ? 1e-15 : c.abs();
        errorPct = ((c - prevC) / d).abs() * 100.0;
        errRow = errorPct;
      }

      rows.add(IterationRow(
        iteration: iter,
        values: [currentA, currentB, c, fc],
        error: errRow,
      ));

      if (fc.abs() < 1e-14) { converged = true; break; }
      if (errRow != null && errorPct < tol) { converged = true; break; }

      if (fa * fc < 0) { currentB = c; fb = fc; }
      else { currentA = c; fa = fc; }
    }

    final double range = (b - a).abs();
    return MethodResult(
      methodType: type,
      root: c,
      iterations: iter,
      finalError: errorPct == double.infinity ? 100.0 : errorPct,
      converged: converged,
      columnNames: const ['a', 'b', 'c (R.Falsa)', 'f(c)'],
      table: rows,
      chartFunction: fn,
      chartMin: a - range * 0.3,
      chartMax: b + range * 0.3,
      inputSummary: 'f(x)=$fn  [${a.toStringAsFixed(3)}, ${b.toStringAsFixed(3)}]',
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
