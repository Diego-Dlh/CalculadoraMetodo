import 'package:math_expressions/math_expressions.dart';

/// Servicio para parsear y evaluar expresiones matemáticas.
///
/// El preprocesador convierte notaciones del usuario (exp, e^x, sen, tg)
/// a formas reconocidas por GrammarParser antes de parsear.
class MathService {
  static final GrammarParser _parser = GrammarParser();

  /// Normaliza la expresión antes de parsearla:
  /// - exp(x)    → e(x)   — GrammarParser reconoce e(x) como Exponential(x)
  /// - e^(expr)  → e(expr) — evita el bug de e^{loopback} del GrammarParser que
  ///              consume toda la expresión como exponente (e^x-3 → e^(x-3))
  /// - e^var     → e(var)  — notación sin paréntesis: e^x, e^-x
  /// - tg(x)     → tan(x)
  /// - sen(x)    → sin(x)  (notación en español)
  /// - arcsin    → arcsin, arccos → arccos, arctan → arctan (ya soportados)
  static String normalize(String expression) {
    String s = expression.trim();
    // exp(x) → e(x): forma función reconocida por GrammarParser
    s = s.replaceAll('exp(', 'e(');
    // e^(expr) → e(expr): elimina ^ para evitar el bug de e^{loopback}
    s = s.replaceAll('e^(', 'e(');
    // e^x o e^-x (sin paréntesis) → e(x) o e(-x)
    s = s.replaceAllMapped(
      RegExp(r'e\^(-?\w+)'),
      (m) => 'e(${m.group(1)})',
    );
    // Notación española de trigonométricas
    s = s.replaceAll('sen(', 'sin(');
    s = s.replaceAll('tg(', 'tan(');
    return s;
  }

  /// Evalúa la expresión sustituyendo 'x' con [x].
  /// Lanza [Exception] si la expresión es inválida o produce valores no finitos.
  static double evaluate(String expression, double x) {
    final String normalized = normalize(expression);
    try {
      final Expression exp = _parser.parse(normalized);
      final ContextModel cm = ContextModel();
      cm.bindVariable(Variable('x'), Number(x));
      final double result = exp.evaluate(EvaluationType.REAL, cm) as double;

      if (result.isNaN) throw Exception('La función produce NaN en x=$x');
      if (result.isInfinite) throw Exception('La función es discontinua en x=$x');

      return result;
    } on Exception {
      rethrow;
    } catch (e) {
      throw Exception('Error al evaluar f($x): verifique la sintaxis');
    }
  }

  /// Verifica si la expresión es válida sintácticamente Y numéricamente en x=1.
  static bool isValid(String expression) {
    if (expression.trim().isEmpty) return false;
    try {
      _parser.parse(normalize(expression));
      evaluate(expression, 1.0);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Verifica solo la sintaxis (sin evaluación numérica).
  static bool isSyntaxValid(String expression) {
    if (expression.trim().isEmpty) return false;
    try {
      _parser.parse(normalize(expression));
      return true;
    } catch (_) {
      return false;
    }
  }
}
