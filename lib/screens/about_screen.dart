import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

/// Pantalla explicativa del Método de Bisección.
/// Describe el algoritmo, teorema de Bolzano, convergencia y ventajas.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Acerca del Método')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHeroCard(),
          const SizedBox(height: 16),
          _buildSection(
            icon: Icons.school_rounded,
            title: 'Teorema de Bolzano',
            child: _buildBolzano(),
          ),
          const SizedBox(height: 12),
          _buildSection(
            icon: Icons.functions_rounded,
            title: 'Fórmulas Clave',
            child: _buildFormulas(),
          ),
          const SizedBox(height: 12),
          _buildSection(
            icon: Icons.list_alt_rounded,
            title: 'Algoritmo Paso a Paso',
            child: _buildAlgorithm(),
          ),
          const SizedBox(height: 12),
          _buildSection(
            icon: Icons.trending_down_rounded,
            title: 'Convergencia',
            child: _buildConvergence(),
          ),
          const SizedBox(height: 12),
          _buildSection(
            icon: Icons.balance_rounded,
            title: 'Ventajas y Desventajas',
            child: _buildProsCons(),
          ),
          const SizedBox(height: 12),
          _buildSection(
            icon: Icons.calculate_rounded,
            title: 'Ejemplo Resuelto',
            child: _buildExample(),
          ),
          const SizedBox(height: 24),
          _buildFooter(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ── Tarjeta hero principal ────────────────────────────────────────────────────
  Widget _buildHeroCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A1F3A), Color(0xFF252D4A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.4)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.cut_rounded,
              color: AppTheme.primary,
              size: 36,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Método de Bisección',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Método de búsqueda de raíces por división de intervalos',
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Divider(color: AppTheme.surfaceBorder),
          const SizedBox(height: 12),
          const Text(
            'El Método de Bisección es uno de los algoritmos numéricos más simples y '
            'confiables para encontrar raíces de ecuaciones no lineales. Se basa en '
            'el Teorema del Valor Intermedio (Bolzano) y garantiza convergencia '
            'siempre que se cumplan las condiciones iniciales.',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 13,
              height: 1.7,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ── Teorema de Bolzano ────────────────────────────────────────────────────────
  Widget _buildBolzano() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _mathBox(
          'Teorema (Bolzano - Valor Intermedio)',
          'Si f : [a, b] → ℝ es continua\n'
              'y  f(a) · f(b) < 0\n\n'
              'Entonces  ∃ c ∈ (a, b)  tal que  f(c) = 0',
        ),
        const SizedBox(height: 12),
        _paragraph(
          'Esta condición asegura que la función cambia de signo dentro del '
          'intervalo, lo que implica la existencia de al menos una raíz. Si '
          'f(a) > 0 y f(b) < 0 (o viceversa), la función debe cruzar el eje '
          'x en algún punto del intervalo.',
        ),
      ],
    );
  }

  // ── Fórmulas ──────────────────────────────────────────────────────────────────
  Widget _buildFormulas() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _formulaRow('Punto medio', 'c = (a + b) / 2'),
        const SizedBox(height: 10),
        _formulaRow(
          'Error relativo',
          'Eᵣ = |( cₙ - cₙ₋₁ ) / cₙ| × 100 %',
        ),
        const SizedBox(height: 10),
        _formulaRow(
          'Cota del error',
          '|x* - cₙ| ≤ (b - a) / 2ⁿ',
        ),
        const SizedBox(height: 10),
        _formulaRow(
          'Mín. iteraciones',
          'n ≥ log₂( (b - a) / ε ) / log₂(2)',
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.accent.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppTheme.accent.withValues(alpha: 0.3)),
          ),
          child: const Text(
            'Donde x* es la raíz exacta, cₙ es el punto medio de la '
            'n-ésima iteración, ε es la tolerancia deseada y n es el '
            'número de iteraciones requeridas.',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }

  // ── Algoritmo ─────────────────────────────────────────────────────────────────
  Widget _buildAlgorithm() {
    final steps = [
      ('Verificar condición inicial',
          'Evaluar f(a) y f(b). Si f(a)·f(b) < 0, continuar. De lo contrario, cambiar el intervalo.'),
      ('Calcular el punto medio',
          'c = (a + b) / 2\nEste punto divide el intervalo a la mitad.'),
      ('Evaluar f(c)',
          'Si f(c) = 0 o |error| < tolerancia → la raíz es c. Detener.'),
      ('Actualizar el intervalo',
          'Si f(a)·f(c) < 0 → la raíz está en [a, c]: hacer b = c\n'
              'Si f(a)·f(c) > 0 → la raíz está en [c, b]: hacer a = c'),
      ('Calcular el error relativo',
          'Eᵣ = |(c_nuevo - c_anterior) / c_nuevo| × 100 %'),
      ('Repetir desde paso 2',
          'Continuar hasta que el error sea menor que la tolerancia o se '
              'alcance el máximo de iteraciones.'),
    ];

    return Column(
      children: steps.asMap().entries.map((entry) {
        final int i = entry.key;
        final (String title, String desc) = entry.value;
        return _algorithmStep(i + 1, title, desc);
      }).toList(),
    );
  }

  Widget _algorithmStep(int n, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.primary.withValues(alpha: 0.5)),
            ),
            child: Center(
              child: Text(
                '$n',
                style: const TextStyle(
                  color: AppTheme.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Convergencia ──────────────────────────────────────────────────────────────
  Widget _buildConvergence() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _paragraph(
          'El método de bisección tiene convergencia lineal. En cada iteración, '
          'el error se reduce a la mitad:',
        ),
        const SizedBox(height: 10),
        _mathBox(
          'Tasa de convergencia',
          'eₙ₊₁ ≈ eₙ / 2\n\n'
              'Orden de convergencia: p = 1  (lineal)\n'
              'Constante asintótica: C = 0.5',
        ),
        const SizedBox(height: 12),
        _paragraph(
          'Para garantizar una precisión de ε dígitos decimales, se necesitan '
          'aproximadamente:',
        ),
        const SizedBox(height: 8),
        _mathBox(
          'Iteraciones mínimas requeridas',
          'n ≥ ⌈ log₂( (b₀ - a₀) / ε ) ⌉',
        ),
        const SizedBox(height: 12),
        _infoChip(
          Icons.lightbulb_rounded,
          'El método siempre converge si f es continua y f(a)·f(b) < 0, '
              'aunque puede ser lento comparado con Newton-Raphson.',
          AppTheme.accent,
        ),
      ],
    );
  }

  // ── Ventajas y desventajas ────────────────────────────────────────────────────
  Widget _buildProsCons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ventajas',
          style: TextStyle(
            color: AppTheme.success,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        ...[
          'Siempre converge si se cumplen las condiciones iniciales.',
          'Algoritmo simple y fácil de implementar.',
          'No requiere calcular derivadas de f(x).',
          'Robustez garantizada — no diverge.',
          'Error fácil de acotar en cada iteración.',
        ].map((t) => _bulletPoint(t, AppTheme.success)),
        const SizedBox(height: 14),
        const Text(
          'Desventajas',
          style: TextStyle(
            color: AppTheme.accentWarm,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        ...[
          'Convergencia lenta (orden lineal, p = 1).',
          'Requiere que f cambie de signo en [a, b].',
          'Puede fallar si la raíz es de orden par (tangente al eje).',
          'Menos eficiente que Newton-Raphson o Secante.',
          'Solo encuentra una raíz por intervalo.',
        ].map((t) => _bulletPoint(t, AppTheme.accentWarm)),
      ],
    );
  }

  // ── Ejemplo resuelto ──────────────────────────────────────────────────────────
  Widget _buildExample() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _paragraph('Encontrar la raíz de  f(x) = x³ - x - 2  en  [1, 2]'),
        const SizedBox(height: 12),
        _mathBox(
          'Verificación de Bolzano',
          'f(1) = 1³ - 1 - 2 = -2   (negativo)\n'
              'f(2) = 2³ - 2 - 2 = +4   (positivo)\n\n'
              'f(1) · f(2) = -8 < 0  ✓  Existe raíz en (1, 2)',
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.surfaceVariant,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppTheme.surfaceBorder),
          ),
          child: Column(
            children: [
              _tableHeaderRow(),
              const Divider(color: AppTheme.surfaceBorder, height: 12),
              _tableDataRow('1', '1.0000', '2.0000', '1.5000', '-0.1250', '---'),
              _tableDataRow('2', '1.5000', '2.0000', '1.7500', '+1.6094', '14.29%'),
              _tableDataRow('3', '1.5000', '1.7500', '1.6250', '+0.6660', '7.69%'),
              _tableDataRow('4', '1.5000', '1.6250', '1.5625', '+0.2517', '4.00%'),
              _tableDataRow('5', '1.5000', '1.5625', '1.5313', '+0.0591', '2.04%'),
              const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  '... converge a x ≈ 1.52138',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _tableHeaderRow() {
    return Row(
      children: ['N°', 'a', 'b', 'c', 'f(c)', 'Error'].map((h) {
        return Expanded(
          child: Text(
            h,
            style: const TextStyle(
              color: AppTheme.primary,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
        );
      }).toList(),
    );
  }

  Widget _tableDataRow(
    String n,
    String a,
    String b,
    String c,
    String fc,
    String err,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [n, a, b, c, fc, err].map((v) {
          return Expanded(
            child: Text(
              v,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 9,
                fontFamily: 'monospace',
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── Footer ────────────────────────────────────────────────────────────────────
  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariant.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: const Column(
        children: [
          Icon(Icons.school_rounded, color: AppTheme.textSecondary, size: 28),
          SizedBox(height: 8),
          Text(
            'Análisis Numérico',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Ingeniería en Sistemas de Información',
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
          ),
          SizedBox(height: 4),
          Text(
            'Método de Bisección — Búsqueda de Raíces',
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 11),
          ),
        ],
      ),
    );
  }

  // ── Helpers de UI ─────────────────────────────────────────────────────────────

  Widget _buildSection({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppTheme.primary, size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _mathBox(String label, String content) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.primary.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.primary,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 13,
              fontFamily: 'monospace',
              height: 1.8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _formulaRow(String label, String formula) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.surfaceVariant,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              formula,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 12,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _paragraph(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: AppTheme.textSecondary,
        fontSize: 13,
        height: 1.6,
      ),
    );
  }

  Widget _bulletPoint(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.circle, color: color, size: 6),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: color.withValues(alpha: 0.9), fontSize: 12, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}

