/// Representa una fila genérica de la tabla iterativa.
/// Compatible con todos los métodos numéricos — las columnas son dinámicas.
class IterationRow {
  final int iteration;

  /// Valores numéricos de cada columna (en el mismo orden que [columnNames]).
  final List<double> values;

  /// Error relativo porcentual. null en la primera iteración de algunos métodos.
  final double? error;

  const IterationRow({
    required this.iteration,
    required this.values,
    this.error,
  });
}
