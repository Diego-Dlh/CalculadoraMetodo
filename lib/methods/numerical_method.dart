import 'package:flutter/material.dart';
import '../models/method_result.dart';
import '../utils/app_theme.dart';

/// Enumeración de todos los métodos numéricos disponibles.
enum NumericalMethodType {
  bisection,
  fixedPoint,
  falsePosition,
  newtonRaphson,
  secant,
}

/// Clase abstracta base para todos los métodos numéricos.
/// Cada implementación define su propio algoritmo y columnas.
abstract class NumericalMethod {
  NumericalMethodType get type;

  /// Ejecuta el cálculo con los parámetros dados.
  /// Lanza [Exception] ante errores de validación o falta de convergencia.
  MethodResult calculate(Map<String, String> params);
}

/// Configuración estática (UI) de cada método: nombre, icono, color, campos.
class NumericalMethodConfig {
  final NumericalMethodType type;
  final String name;
  final String shortDescription;
  final IconData icon;
  final Color color;
  final List<MethodField> fields;
  final Map<String, String> defaults;

  const NumericalMethodConfig({
    required this.type,
    required this.name,
    required this.shortDescription,
    required this.icon,
    required this.color,
    required this.fields,
    required this.defaults,
  });

  /// Devuelve la configuración del método indicado.
  static NumericalMethodConfig of(NumericalMethodType type) {
    return _all.firstWhere((c) => c.type == type);
  }

  static List<NumericalMethodConfig> get all => _all;

  static final List<NumericalMethodConfig> _all = [
    NumericalMethodConfig(
      type: NumericalMethodType.bisection,
      name: 'Bisección',
      shortDescription: 'Divide el intervalo [a,b] a la mitad sucesivamente',
      icon: Icons.cut_rounded,
      color: AppTheme.primary,
      defaults: {
        'function': 'x^3 - x - 2',
        'a': '1',
        'b': '2',
        'tolerance': '0.0001',
        'maxIterations': '100',
      },
      fields: const [
        MethodField(key: 'function', label: 'f(x)', hint: 'x^3 - x - 2', isExpression: true,
            icon: Icons.functions_rounded, helper: 'Función a evaluar'),
        MethodField(key: 'a', label: 'Límite inferior (a)', hint: '1', isExpression: false,
            icon: Icons.arrow_back_rounded, helper: 'Extremo izquierdo del intervalo'),
        MethodField(key: 'b', label: 'Límite superior (b)', hint: '2', isExpression: false,
            icon: Icons.arrow_forward_rounded, helper: 'Extremo derecho del intervalo'),
        MethodField(key: 'tolerance', label: 'Tolerancia (%)', hint: '0.0001', isExpression: false,
            icon: Icons.precision_manufacturing_outlined, helper: 'Error relativo máximo aceptado'),
        MethodField(key: 'maxIterations', label: 'Máx. iteraciones', hint: '100', isExpression: false,
            icon: Icons.repeat_rounded, helper: 'Límite de iteraciones'),
      ],
    ),
    NumericalMethodConfig(
      type: NumericalMethodType.fixedPoint,
      name: 'Punto Fijo',
      shortDescription: 'Iteración xₙ₊₁ = g(xₙ) hasta convergencia',
      icon: Icons.adjust_rounded,
      color: const Color(0xFF2196F3),
      defaults: {
        'gFunction': 'cos(x)',
        'x0': '1',
        'tolerance': '0.0001',
        'maxIterations': '100',
      },
      fields: const [
        MethodField(key: 'gFunction', label: 'g(x)', hint: 'cos(x)', isExpression: true,
            icon: Icons.functions_rounded, helper: 'Función de iteración: x = g(x)'),
        MethodField(key: 'x0', label: 'Valor inicial x₀', hint: '1', isExpression: false,
            icon: Icons.start_rounded, helper: 'Punto de inicio de la iteración'),
        MethodField(key: 'tolerance', label: 'Tolerancia (%)', hint: '0.0001', isExpression: false,
            icon: Icons.precision_manufacturing_outlined, helper: 'Error relativo máximo'),
        MethodField(key: 'maxIterations', label: 'Máx. iteraciones', hint: '100', isExpression: false,
            icon: Icons.repeat_rounded, helper: 'Límite de iteraciones'),
      ],
    ),
    NumericalMethodConfig(
      type: NumericalMethodType.falsePosition,
      name: 'Regla Falsa',
      shortDescription: 'Interpolación lineal entre f(a) y f(b)',
      icon: Icons.show_chart_rounded,
      color: const Color(0xFF4CAF50),
      defaults: {
        'function': 'x^3 - x - 2',
        'a': '1',
        'b': '2',
        'tolerance': '0.0001',
        'maxIterations': '100',
      },
      fields: const [
        MethodField(key: 'function', label: 'f(x)', hint: 'x^3 - x - 2', isExpression: true,
            icon: Icons.functions_rounded, helper: 'Función a evaluar'),
        MethodField(key: 'a', label: 'Límite inferior (a)', hint: '1', isExpression: false,
            icon: Icons.arrow_back_rounded, helper: 'Extremo izquierdo del intervalo'),
        MethodField(key: 'b', label: 'Límite superior (b)', hint: '2', isExpression: false,
            icon: Icons.arrow_forward_rounded, helper: 'Extremo derecho del intervalo'),
        MethodField(key: 'tolerance', label: 'Tolerancia (%)', hint: '0.0001', isExpression: false,
            icon: Icons.precision_manufacturing_outlined, helper: 'Error relativo máximo'),
        MethodField(key: 'maxIterations', label: 'Máx. iteraciones', hint: '100', isExpression: false,
            icon: Icons.repeat_rounded, helper: 'Límite de iteraciones'),
      ],
    ),
    NumericalMethodConfig(
      type: NumericalMethodType.newtonRaphson,
      name: 'Newton-Raphson',
      shortDescription: 'Tangente a la curva: xₙ₊₁ = xₙ − f(xₙ)/f\'(xₙ)',
      icon: Icons.trending_down_rounded,
      color: const Color(0xFFFF9800),
      defaults: {
        'function': 'x^3 - x - 2',
        'derivative': '3*x^2 - 1',
        'x0': '1.5',
        'tolerance': '0.0001',
        'maxIterations': '100',
      },
      fields: const [
        MethodField(key: 'function', label: 'f(x)', hint: 'x^3 - x - 2', isExpression: true,
            icon: Icons.functions_rounded, helper: 'Función principal'),
        MethodField(key: 'derivative', label: "f'(x) — Derivada", hint: '3*x^2 - 1', isExpression: true,
            icon: Icons.functions_rounded, helper: 'Derivada analítica de f(x)'),
        MethodField(key: 'x0', label: 'Valor inicial x₀', hint: '1.5', isExpression: false,
            icon: Icons.start_rounded, helper: 'Punto de inicio'),
        MethodField(key: 'tolerance', label: 'Tolerancia (%)', hint: '0.0001', isExpression: false,
            icon: Icons.precision_manufacturing_outlined, helper: 'Error relativo máximo'),
        MethodField(key: 'maxIterations', label: 'Máx. iteraciones', hint: '100', isExpression: false,
            icon: Icons.repeat_rounded, helper: 'Límite de iteraciones'),
      ],
    ),
    NumericalMethodConfig(
      type: NumericalMethodType.secant,
      name: 'Secante',
      shortDescription: 'Aproxima la derivada con dos puntos anteriores',
      icon: Icons.linear_scale_rounded,
      color: AppTheme.accent,
      defaults: {
        'function': 'x^3 - x - 2',
        'x0': '1',
        'x1': '2',
        'tolerance': '0.0001',
        'maxIterations': '100',
      },
      fields: const [
        MethodField(key: 'function', label: 'f(x)', hint: 'x^3 - x - 2', isExpression: true,
            icon: Icons.functions_rounded, helper: 'Función a evaluar'),
        MethodField(key: 'x0', label: 'Primer punto x₀', hint: '1', isExpression: false,
            icon: Icons.looks_one_rounded, helper: 'Primera aproximación inicial'),
        MethodField(key: 'x1', label: 'Segundo punto x₁', hint: '2', isExpression: false,
            icon: Icons.looks_two_rounded, helper: 'Segunda aproximación inicial'),
        MethodField(key: 'tolerance', label: 'Tolerancia (%)', hint: '0.0001', isExpression: false,
            icon: Icons.precision_manufacturing_outlined, helper: 'Error relativo máximo'),
        MethodField(key: 'maxIterations', label: 'Máx. iteraciones', hint: '100', isExpression: false,
            icon: Icons.repeat_rounded, helper: 'Límite de iteraciones'),
      ],
    ),
  ];
}

/// Descriptor de un campo de entrada del formulario.
class MethodField {
  final String key;
  final String label;
  final String hint;
  final bool isExpression; // true → campo de función matemática
  final IconData icon;
  final String helper;

  const MethodField({
    required this.key,
    required this.label,
    required this.hint,
    required this.isExpression,
    required this.icon,
    required this.helper,
  });
}
