import 'package:flutter/foundation.dart';
import '../methods/bisection_method.dart';
import '../methods/false_position_method.dart';
import '../methods/fixed_point_method.dart';
import '../methods/newton_raphson_method.dart';
import '../methods/numerical_method.dart';
import '../methods/secant_method.dart';
import '../models/method_result.dart';

enum CalculationState { idle, loading, success, error }

/// Proveedor unificado para todos los métodos numéricos.
/// Gestiona la selección del método, validación, cálculo y estado.
class CalculatorProvider extends ChangeNotifier {
  NumericalMethodType _selectedMethod = NumericalMethodType.bisection;
  CalculationState _state = CalculationState.idle;
  MethodResult? _result;
  String? _errorMessage;

  // Mapa de métodos disponibles
  static final Map<NumericalMethodType, NumericalMethod> _methods = {
    NumericalMethodType.bisection: BisectionMethod(),
    NumericalMethodType.fixedPoint: FixedPointMethod(),
    NumericalMethodType.falsePosition: FalsePositionMethod(),
    NumericalMethodType.newtonRaphson: NewtonRaphsonMethod(),
    NumericalMethodType.secant: SecantMethod(),
  };

  // Getters
  NumericalMethodType get selectedMethod => _selectedMethod;
  CalculationState get state => _state;
  MethodResult? get result => _result;
  String? get errorMessage => _errorMessage;
  NumericalMethodConfig get config => NumericalMethodConfig.of(_selectedMethod);

  /// Cambia el método seleccionado y limpia el resultado anterior.
  void selectMethod(NumericalMethodType type) {
    _selectedMethod = type;
    _result = null;
    _errorMessage = null;
    _state = CalculationState.idle;
    notifyListeners();
  }

  /// Ejecuta el método seleccionado con los parámetros del formulario.
  void calculate(Map<String, String> params) {
    _state = CalculationState.loading;
    _result = null;
    _errorMessage = null;
    notifyListeners();

    try {
      final method = _methods[_selectedMethod]!;
      _result = method.calculate(params);
      _state = CalculationState.success;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _state = CalculationState.error;
    }

    notifyListeners();
  }

  void reset() {
    _state = CalculationState.idle;
    _result = null;
    _errorMessage = null;
    notifyListeners();
  }
}
