import '../models/iteration_row.dart';
import '../models/method_result.dart';
import '../services/math_service.dart';
import 'numerical_method.dart';

/// Implementación del Método de Bisección.
///
/// Busca la raíz en [a,b] dividiendo el intervalo a la mitad en cada paso.
/// Requiere f(a)·f(b) < 0 (Teorema de Bolzano).
class BisectionMethod implements NumericalMethod {
  @override
  NumericalMethodType get type => NumericalMethodType.bisection;

  @override
  MethodResult calculate(Map<String, String> params) {
    final String fn = _require(params, 'function');
    final double a = _parseDouble(params, 'a');
    final double b = _parseDouble(params, 'b');
    final double tol = _parseDouble(params, 'tolerance');
    final int maxIter = _parseInt(params, 'maxIterations');

    _validateInterval(a, b);
    _validateTolerance(tol, maxIter);
    if (!MathService.isSyntaxValid(fn)) throw Exception('Función f(x) no válida');

    double fa = MathService.evaluate(fn, a);
    double fb = MathService.evaluate(fn, b);
    if (fa * fb >= 0) {
      throw Exception(
        'No se cumple Bolzano: f(a)·f(b) ≥ 0\n'
        'f($a) = ${fa.toStringAsFixed(5)}\n'
        'f($b) = ${fb.toStringAsFixed(5)}\n'
        'Cambie el intervalo para que f cambie de signo.',
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
      c = (currentA + currentB) / 2.0;
      final double fc = MathService.evaluate(fn, c);

      double? errRow;
      if (!prevC.isNaN) {
        final double denom = c.abs() < 1e-15 ? 1e-15 : c.abs();
        errorPct = ((c - prevC) / denom).abs() * 100.0;
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
      columnNames: const ['a', 'b', 'c = (a+b)/2', 'f(c)'],
      table: rows,
      chartFunction: fn,
      chartMin: a - range * 0.3,
      chartMax: b + range * 0.3,
      inputSummary: 'f(x)=$fn  [${a.toStringAsFixed(3)}, ${b.toStringAsFixed(3)}]',
    );
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

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

  void _validateInterval(double a, double b) {
    if (a >= b) throw Exception('El límite inferior a debe ser menor que b');
  }

  void _validateTolerance(double tol, int maxIter) {
    if (tol <= 0) throw Exception('La tolerancia debe ser > 0');
    if (maxIter <= 0 || maxIter > 10000) throw Exception('Iteraciones: 1 – 10000');
  }
}
