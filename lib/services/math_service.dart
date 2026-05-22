import 'package:math_expressions/math_expressions.dart';

/// Servicio para parsear y evaluar expresiones matemáticas.
/// Usa la librería math_expressions para interpretar funciones como strings.
class MathService {
  static final GrammarParser _parser = GrammarParser();

  /// Evalúa la expresión [expression] sustituyendo la variable 'x' con [x].
  /// Lanza una [Exception] si la expresión no se puede evaluar.
  static double evaluate(String expression, double x) {
    try {
      final Expression exp = _parser.parse(expression.trim());
      final ContextModel cm = ContextModel();
      cm.bindVariable(Variable('x'), Number(x));
      final double result = exp.evaluate(EvaluationType.REAL, cm) as double;

      if (result.isNaN) throw Exception('La función produce NaN en x=$x');
      if (result.isInfinite) throw Exception('La función es discontinua en x=$x');

      return result;
    } on Exception {
      rethrow;
    } catch (e) {
      throw Exception('Error al evaluar f($x): verifique la sintaxis de la función');
    }
  }

  /// Verifica si el string [expression] es una expresión matemática válida.
  static bool isValid(String expression) {
    if (expression.trim().isEmpty) return false;
    try {
      _parser.parse(expression.trim());
      // Prueba evaluación en x=1 para detectar errores en tiempo de ejecución
      evaluate(expression, 1.0);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Verifica la validez solo de sintaxis (sin evaluación numérica).
  static bool isSyntaxValid(String expression) {
    if (expression.trim().isEmpty) return false;
    try {
      _parser.parse(expression.trim());
      return true;
    } catch (_) {
      return false;
    }
  }
}
