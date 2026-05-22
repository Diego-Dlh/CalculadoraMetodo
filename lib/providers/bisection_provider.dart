import 'package:flutter/foundation.dart';
import '../models/bisection_result.dart';
import '../services/bisection_service.dart';
import '../services/math_service.dart';

/// Estado de la operación de cálculo.
enum CalculationState { idle, loading, success, error }

/// ChangeNotifier que coordina la lógica de negocio y expone el estado a la UI.
/// Valida entradas, ejecuta el algoritmo y notifica a los widgets escuchando.
class BisectionProvider extends ChangeNotifier {
  CalculationState _state = CalculationState.idle;
  BisectionResult? _result;
  String? _errorMessage;

  // Campos del formulario guardados para la pantalla de resultados
  String _function = '';
  double _a = 0;
  double _b = 0;
  // Getters públicos
  CalculationState get state => _state;
  BisectionResult? get result => _result;
  String? get errorMessage => _errorMessage;
  String get function => _function;
  double get a => _a;
  double get b => _b;

  /// Valida las entradas y ejecuta el método de bisección.
  void calculate({
    required String functionStr,
    required String aStr,
    required String bStr,
    required String toleranceStr,
    required String maxIterStr,
  }) {
    _state = CalculationState.loading;
    _errorMessage = null;
    _result = null;
    notifyListeners();

    try {
      // --- Validaciones de campos vacíos ---
      if (functionStr.trim().isEmpty) {
        throw Exception('Ingrese una función f(x)');
      }
      if (aStr.trim().isEmpty) throw Exception('Ingrese el límite inferior a');
      if (bStr.trim().isEmpty) throw Exception('Ingrese el límite superior b');
      if (toleranceStr.trim().isEmpty) throw Exception('Ingrese la tolerancia');
      if (maxIterStr.trim().isEmpty) {
        throw Exception('Ingrese el número máximo de iteraciones');
      }

      // --- Validación de función matemática ---
      if (!MathService.isSyntaxValid(functionStr)) {
        throw Exception(
          'La función no tiene sintaxis válida.\n'
          'Ejemplos: x^3 - x - 2, sin(x) - x/2, exp(x) - 3',
        );
      }

      // --- Conversión numérica ---
      final double? a = double.tryParse(aStr);
      final double? b = double.tryParse(bStr);
      final double? tol = double.tryParse(toleranceStr);
      final int? maxIter = int.tryParse(maxIterStr);

      if (a == null) throw Exception('El límite inferior "a" no es un número válido');
      if (b == null) throw Exception('El límite superior "b" no es un número válido');
      if (tol == null) throw Exception('La tolerancia no es un número válido');
      if (maxIter == null) {
        throw Exception('El máximo de iteraciones no es un entero válido');
      }

      // --- Validaciones lógicas ---
      if (a >= b) {
        throw Exception('El límite inferior debe ser estrictamente menor que el superior (a < b)');
      }
      if (tol <= 0) {
        throw Exception('La tolerancia debe ser un valor positivo mayor que 0');
      }
      if (tol >= 100) {
        throw Exception('La tolerancia debe ser menor que 100%');
      }
      if (maxIter <= 0) {
        throw Exception('El número máximo de iteraciones debe ser mayor que 0');
      }
      if (maxIter > 10000) {
        throw Exception('El número máximo de iteraciones no puede superar 10000');
      }

      // --- Evaluar f(a) y f(b) para verificar condición de Bolzano ---
      final double fa = MathService.evaluate(functionStr, a);
      final double fb = MathService.evaluate(functionStr, b);

      if (fa * fb >= 0) {
        throw Exception(
          'No se cumple la condición de Bolzano:\n'
          'f(a) · f(b) debe ser < 0\n\n'
          'f(${a.toStringAsFixed(4)}) = ${fa.toStringAsFixed(6)}\n'
          'f(${b.toStringAsFixed(4)}) = ${fb.toStringAsFixed(6)}\n\n'
          'Cambie el intervalo [a, b] de modo que la función cambie de signo.',
        );
      }

      // --- Ejecutar el algoritmo ---
      _function = functionStr.trim();
      _a = a;
      _b = b;
      _result = BisectionService.calculate(
        function: functionStr,
        a: a,
        b: b,
        tolerance: tol,
        maxIterations: maxIter,
      );

      _state = CalculationState.success;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _state = CalculationState.error;
    }

    notifyListeners();
  }

  /// Reinicia el estado para una nueva consulta.
  void reset() {
    _state = CalculationState.idle;
    _result = null;
    _errorMessage = null;
    notifyListeners();
  }
}
