/// Utilidades para formatear números de forma legible en la interfaz.
class NumberFormatter {
  /// Formatea un número con [decimals] decimales fijos.
  static String fixed(double value, [int decimals = 6]) {
    return value.toStringAsFixed(decimals);
  }

  /// Formatea un número usando notación científica si es muy grande o muy pequeño.
  static String smart(double value, [int decimals = 6]) {
    if (value == 0) return '0';
    final double abs = value.abs();
    if (abs < 0.0001 || abs >= 1e7) {
      return value.toStringAsExponential(4);
    }
    return value.toStringAsFixed(decimals);
  }

  /// Formatea el error relativo como porcentaje.
  static String error(double? value) {
    if (value == null) return '---';
    if (value.isInfinite || value.isNaN) return '---';
    return '${value.toStringAsFixed(6)} %';
  }

  /// Formatea el valor de f(c) para la tabla.
  static String fc(double value) {
    if (value.abs() < 1e-10) return '≈ 0';
    final double abs = value.abs();
    if (abs < 0.0001 || abs >= 1e6) {
      return value.toStringAsExponential(4);
    }
    return value.toStringAsFixed(6);
  }
}
