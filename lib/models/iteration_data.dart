/// Representa los datos de una sola iteración del método de bisección.
/// Cada fila de la tabla iterativa corresponde a un objeto de esta clase.
class IterationData {
  final int iteration;  // Número de iteración
  final double a;       // Límite inferior del intervalo
  final double b;       // Límite superior del intervalo
  final double c;       // Punto medio: c = (a + b) / 2
  final double fc;      // Valor de la función en c: f(c)
  final double? error;  // Error relativo porcentual (null en la primera iteración)

  const IterationData({
    required this.iteration,
    required this.a,
    required this.b,
    required this.c,
    required this.fc,
    this.error,
  });
}
