import 'package:flutter/material.dart';
import '../methods/numerical_method.dart';
import '../utils/app_theme.dart';

/// Pantalla de teoría con explicación matemática de cada método.
class TheoryScreen extends StatefulWidget {
  const TheoryScreen({super.key});

  @override
  State<TheoryScreen> createState() => _TheoryScreenState();
}

class _TheoryScreenState extends State<TheoryScreen> {
  NumericalMethodType _selected = NumericalMethodType.bisection;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Teoría')),
      body: Column(children: [
        _buildSelector(),
        Expanded(child: _buildContent()),
      ]),
    );
  }

  Widget _buildSelector() {
    return Container(
      height: 56,
      color: AppTheme.surface,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        children: NumericalMethodConfig.all.map((cfg) {
          final bool sel = _selected == cfg.type;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(cfg.name),
              selected: sel,
              onSelected: (_) => setState(() => _selected = cfg.type),
              selectedColor: cfg.color.withValues(alpha: 0.25),
              checkmarkColor: cfg.color,
              labelStyle: TextStyle(
                color: sel ? cfg.color : AppTheme.textSecondary,
                fontWeight: sel ? FontWeight.w700 : FontWeight.w400,
                fontSize: 13,
              ),
              side: BorderSide(color: sel ? cfg.color : AppTheme.surfaceBorder),
              avatar: Icon(cfg.icon, size: 14, color: sel ? cfg.color : AppTheme.textSecondary),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildContent() {
    switch (_selected) {
      case NumericalMethodType.bisection: return _BisectionTheory();
      case NumericalMethodType.fixedPoint: return _FixedPointTheory();
      case NumericalMethodType.falsePosition: return _FalsePositionTheory();
      case NumericalMethodType.newtonRaphson: return _NewtonRaphsonTheory();
      case NumericalMethodType.secant: return _SecantTheory();
    }
  }
}

// ── Teorías por método ────────────────────────────────────────────────────────

class _BisectionTheory extends StatelessWidget {
  @override
  Widget build(BuildContext context) => _TheoryLayout(
    config: NumericalMethodConfig.of(NumericalMethodType.bisection),
    description:
        'El Método de Bisección divide repetidamente el intervalo [a,b] a la mitad '
        'y selecciona el subintervalo donde existe la raíz. Se basa en el Teorema '
        'del Valor Intermedio de Bolzano.',
    formulas: const [
      _Formula('Punto medio', 'c = (a + b) / 2'),
      _Formula('Condición Bolzano', 'f(a) · f(b) < 0'),
      _Formula('Error relativo', 'Eᵣ = |cₙ − cₙ₋₁| / |cₙ| × 100 %'),
      _Formula('Cota del error', '|x* − cₙ| ≤ (b − a) / 2ⁿ'),
    ],
    convergence: 'Lineal — orden p = 1\nEl error se reduce a la mitad en cada iteración.',
    pros: const ['Siempre converge si se cumple Bolzano', 'Simple de implementar',
        'No requiere derivadas', 'Error fácil de acotar'],
    cons: const ['Convergencia lenta (orden 1)', 'Requiere que f cambie de signo',
        'Una raíz por ejecución', 'Puede no detectar raíces de orden par'],
  );
}

class _FixedPointTheory extends StatelessWidget {
  @override
  Widget build(BuildContext context) => _TheoryLayout(
    config: NumericalMethodConfig.of(NumericalMethodType.fixedPoint),
    description:
        'El Método de Punto Fijo reformula f(x)=0 como x=g(x) e itera '
        'la función g hasta que xₙ₊₁ ≈ xₙ. Converge si |g\'(x*)| < 1 '
        'cerca de la raíz.',
    formulas: const [
      _Formula('Iteración', 'xₙ₊₁ = g(xₙ)'),
      _Formula('Condición convergencia', '|g\'(x*)| < 1'),
      _Formula('Error relativo', 'Eᵣ = |xₙ₊₁ − xₙ| / |xₙ₊₁| × 100 %'),
    ],
    convergence: 'Lineal — orden p = 1\nLa tasa depende del valor de |g\'(x*)|.',
    pros: const ['Fácil de programar', 'No requiere evaluación de derivadas',
        'Muy flexible en la elección de g(x)'],
    cons: const ['No siempre converge', 'Depende de la formulación de g(x)',
        'Puede diverger si |g\'(x*)| ≥ 1', 'Convergencia lenta'],
  );
}

class _FalsePositionTheory extends StatelessWidget {
  @override
  Widget build(BuildContext context) => _TheoryLayout(
    config: NumericalMethodConfig.of(NumericalMethodType.falsePosition),
    description:
        'La Regla Falsa (Regula Falsi) usa interpolación lineal entre los puntos '
        '(a, f(a)) y (b, f(b)) para estimar la raíz, en lugar de tomar el punto '
        'medio como en bisección. Mantiene el intervalo con cambio de signo.',
    formulas: const [
      _Formula('Punto c (interpolación)', 'c = a − f(a)·(b−a) / (f(b)−f(a))'),
      _Formula('Equivalente', 'c = (a·f(b) − b·f(a)) / (f(b) − f(a))'),
      _Formula('Condición Bolzano', 'f(a) · f(b) < 0'),
      _Formula('Error relativo', 'Eᵣ = |cₙ − cₙ₋₁| / |cₙ| × 100 %'),
    ],
    convergence: 'Superlineal en la mayoría de casos, puede ser lineal si '
        'un extremo queda fijo (efecto de "pegarse").',
    pros: const ['Siempre converge con Bolzano', 'Más rápido que bisección normalmente',
        'No requiere derivadas', 'Mantiene acotamiento del error'],
    cons: const ['Puede ser lento si un extremo es estático', 'Convergencia variable',
        'Puede acercarse asintóticamente en algunos casos'],
  );
}

class _NewtonRaphsonTheory extends StatelessWidget {
  @override
  Widget build(BuildContext context) => _TheoryLayout(
    config: NumericalMethodConfig.of(NumericalMethodType.newtonRaphson),
    description:
        'El Método de Newton-Raphson traza la tangente a la curva f(x) en el '
        'punto actual y usa su intersección con el eje x como nueva aproximación. '
        'Converge cuadráticamente cerca de la raíz, siendo uno de los métodos '
        'más rápidos en la práctica.',
    formulas: const [
      _Formula('Fórmula iterativa', 'xₙ₊₁ = xₙ − f(xₙ) / f\'(xₙ)'),
      _Formula('Condición', 'f\'(xₙ) ≠ 0'),
      _Formula('Error relativo', 'Eᵣ = |xₙ₊₁ − xₙ| / |xₙ₊₁| × 100 %'),
      _Formula('Convergencia cuadrática', 'eₙ₊₁ ≈ C · eₙ²'),
    ],
    convergence: 'Cuadrática — orden p = 2\nEl número de dígitos correctos '
        'se duplica en cada iteración cerca de la raíz.',
    pros: const ['Convergencia muy rápida (orden 2)', 'Pocas iteraciones necesarias',
        'Muy preciso cerca de la raíz', 'Ampliamente usado en la práctica'],
    cons: const ['Requiere f\'(x) analítica', 'No converge si f\'(x₀) ≈ 0',
        'Sensible al punto inicial', 'Puede oscilar o diverger'],
  );
}

class _SecantTheory extends StatelessWidget {
  @override
  Widget build(BuildContext context) => _TheoryLayout(
    config: NumericalMethodConfig.of(NumericalMethodType.secant),
    description:
        'El Método de la Secante aproxima la derivada de Newton-Raphson '
        'usando los dos puntos anteriores, eliminando la necesidad de calcular '
        'f\'(x) analíticamente. La convergencia es superlineal con orden ≈ 1.618.',
    formulas: const [
      _Formula('Fórmula iterativa',
          'xₙ₊₁ = xₙ − f(xₙ)·(xₙ − xₙ₋₁) / (f(xₙ) − f(xₙ₋₁))'),
      _Formula('Aprox. derivada', 'f\'(xₙ) ≈ (f(xₙ) − f(xₙ₋₁)) / (xₙ − xₙ₋₁)'),
      _Formula('Orden convergencia', 'p = (1 + √5) / 2 ≈ 1.618 (razón áurea)'),
      _Formula('Error relativo', 'Eᵣ = |xₙ₊₁ − xₙ| / |xₙ₊₁| × 100 %'),
    ],
    convergence: 'Superlineal — orden p ≈ 1.618\nMás rápido que métodos lineales '
        'pero más lento que Newton-Raphson.',
    pros: const ['No requiere f\'(x) analítica', 'Convergencia superlineal',
        'Solo evalúa f(x)', 'Buena alternativa a Newton-Raphson'],
    cons: const ['Necesita dos puntos iniciales', 'Puede dividir por cero si f(xₙ)≈f(xₙ₋₁)',
        'Menos robusto que métodos de intervalo', 'Puede diverger sin Bolzano'],
  );
}

// ── Widgets de composición ────────────────────────────────────────────────────

class _TheoryLayout extends StatelessWidget {
  final NumericalMethodConfig config;
  final String description;
  final List<_Formula> formulas;
  final String convergence;
  final List<String> pros;
  final List<String> cons;

  const _TheoryLayout({
    required this.config,
    required this.description,
    required this.formulas,
    required this.convergence,
    required this.pros,
    required this.cons,
  });

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      _heroCard(),
      const SizedBox(height: 12),
      _section('Fórmulas clave', Icons.functions_rounded, _formulasWidget()),
      const SizedBox(height: 12),
      _section('Convergencia', Icons.trending_down_rounded,
          _convWidget()),
      const SizedBox(height: 12),
      _section('Ventajas y desventajas', Icons.balance_rounded,
          _prosConsWidget()),
      const SizedBox(height: 24),
    ],
  );

  Widget _heroCard() => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [config.color.withValues(alpha: 0.15), AppTheme.surface],
        begin: Alignment.topLeft, end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: config.color.withValues(alpha: 0.4)),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: config.color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(config.icon, color: config.color, size: 26),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(config.name,
            style: TextStyle(color: config.color, fontSize: 20,
                fontWeight: FontWeight.w700))),
      ]),
      const SizedBox(height: 14),
      Text(description,
          style: const TextStyle(color: AppTheme.textSecondary,
              fontSize: 13, height: 1.65)),
    ]),
  );

  Widget _section(String title, IconData icon, Widget child) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppTheme.surface,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppTheme.surfaceBorder),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: config.color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(icon, color: config.color, size: 16),
        ),
        const SizedBox(width: 10),
        Text(title, style: const TextStyle(color: AppTheme.textPrimary,
            fontSize: 14, fontWeight: FontWeight.w700)),
      ]),
      const SizedBox(height: 14),
      child,
    ]),
  );

  Widget _formulasWidget() => Column(
    children: formulas.map((f) => Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(width: 110,
          child: Text(f.name, style: const TextStyle(
              color: AppTheme.textSecondary, fontSize: 12))),
        const SizedBox(width: 8),
        Expanded(child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          decoration: BoxDecoration(
            color: AppTheme.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(f.value, style: TextStyle(color: config.color,
              fontSize: 12, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
        )),
      ]),
    )).toList(),
  );

  Widget _convWidget() => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: config.color.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: config.color.withValues(alpha: 0.3)),
    ),
    child: Text(convergence,
        style: const TextStyle(color: AppTheme.textPrimary,
            fontSize: 13, height: 1.6, fontFamily: 'monospace')),
  );

  Widget _prosConsWidget() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Ventajas', style: TextStyle(color: AppTheme.success,
          fontSize: 13, fontWeight: FontWeight.w700)),
      const SizedBox(height: 8),
      ...pros.map((p) => _bullet(p, AppTheme.success)),
      const SizedBox(height: 14),
      Text('Desventajas', style: const TextStyle(color: AppTheme.accentWarm,
          fontSize: 13, fontWeight: FontWeight.w700)),
      const SizedBox(height: 8),
      ...cons.map((c) => _bullet(c, AppTheme.accentWarm)),
    ],
  );

  Widget _bullet(String text, Color color) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(Icons.circle, color: color, size: 6),
      const SizedBox(width: 10),
      Expanded(child: Text(text, style: const TextStyle(
          color: AppTheme.textSecondary, fontSize: 12, height: 1.4))),
    ]),
  );
}

class _Formula {
  final String name;
  final String value;
  const _Formula(this.name, this.value);
}
