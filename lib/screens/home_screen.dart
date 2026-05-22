import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/bisection_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/custom_text_field.dart';
import 'results_screen.dart';
import 'about_screen.dart';

/// Pantalla principal con el formulario de entrada del método de bisección.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores de los campos de texto
  final _functionCtrl = TextEditingController(text: 'x^3 - x - 2');
  final _aCtrl = TextEditingController(text: '1');
  final _bCtrl = TextEditingController(text: '2');
  final _tolCtrl = TextEditingController(text: '0.0001');
  final _maxIterCtrl = TextEditingController(text: '100');

  // Funciones de ejemplo para demostración rápida
  static const List<_ExampleFn> _examples = [
    _ExampleFn('x³−x−2', 'x^3 - x - 2', '1', '2'),
    _ExampleFn('cos(x)−x', 'cos(x) - x', '0', '1'),
    _ExampleFn('x²−4', 'x^2 - 4', '1', '3'),
    _ExampleFn('sin(x)−x/2', 'sin(x) - x/2', '1', '2'),
    _ExampleFn('eˣ−3', 'exp(x) - 3', '0', '2'),
    _ExampleFn('ln(x)−1', 'ln(x) - 1', '1', '4'),
  ];

  @override
  void dispose() {
    _functionCtrl.dispose();
    _aCtrl.dispose();
    _bCtrl.dispose();
    _tolCtrl.dispose();
    _maxIterCtrl.dispose();
    super.dispose();
  }

  void _calculate() {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<BisectionProvider>();
    provider.calculate(
      functionStr: _functionCtrl.text,
      aStr: _aCtrl.text,
      bStr: _bCtrl.text,
      toleranceStr: _tolCtrl.text,
      maxIterStr: _maxIterCtrl.text,
    );

    if (provider.state == CalculationState.success && provider.result != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ResultsScreen()),
      );
    } else if (provider.state == CalculationState.error) {
      _showErrorDialog(provider.errorMessage ?? 'Error desconocido');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppTheme.accentWarm, size: 24),
            SizedBox(width: 10),
            Text(
              'Error de validación',
              style: TextStyle(color: AppTheme.textPrimary, fontSize: 17),
            ),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Entendido', style: TextStyle(color: AppTheme.primary)),
          ),
        ],
      ),
    );
  }

  void _applyExample(_ExampleFn ex) {
    setState(() {
      _functionCtrl.text = ex.function;
      _aCtrl.text = ex.a;
      _bCtrl.text = ex.b;
    });
    HapticFeedback.selectionClick();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Método de Bisección'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            tooltip: 'Acerca del método',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AboutScreen()),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildExampleChips(),
            const SizedBox(height: 20),
            _buildFunctionCard(),
            const SizedBox(height: 12),
            _buildIntervalCard(),
            const SizedBox(height: 12),
            _buildParametersCard(),
            const SizedBox(height: 24),
            _buildCalculateButton(),
            const SizedBox(height: 12),
            _buildSyntaxHelp(),
          ],
        ),
      ),
    );
  }

  // ── Banner superior con gradiente ────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A1F3A), Color(0xFF252D4A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.functions_rounded,
                  color: AppTheme.primary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Calculadora Numérica',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Análisis Numérico — Ingeniería en Sistemas',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: AppTheme.surfaceBorder),
          const SizedBox(height: 12),
          const Text(
            'El Método de Bisección encuentra raíces de ecuaciones no lineales '
            'f(x) = 0 dividiendo iterativamente el intervalo [a, b] a la mitad.',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 13,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  // ── Chips de funciones de ejemplo ────────────────────────────────────────────
  Widget _buildExampleChips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ejemplos rápidos',
          style: TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _examples.map((ex) {
            return ActionChip(
              label: Text(ex.label),
              onPressed: () => _applyExample(ex),
              avatar: const Icon(Icons.play_arrow_rounded, size: 14),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ── Tarjeta: función matemática ───────────────────────────────────────────────
  Widget _buildFunctionCard() {
    return _SectionCard(
      icon: Icons.functions_rounded,
      title: 'Función f(x)',
      child: CustomTextField(
        controller: _functionCtrl,
        label: 'f(x)',
        hint: 'ej. x^3 - x - 2',
        icon: Icons.edit_rounded,
        helperText: 'Use x como variable. Operadores: ^ * / + -',
        validator: (v) {
          if (v == null || v.trim().isEmpty) return 'Ingrese una función';
          return null;
        },
      ),
    );
  }

  // ── Tarjeta: intervalo [a, b] ─────────────────────────────────────────────────
  Widget _buildIntervalCard() {
    return _SectionCard(
      icon: Icons.linear_scale_rounded,
      title: 'Intervalo [a, b]',
      child: Row(
        children: [
          Expanded(
            child: CustomTextField(
              controller: _aCtrl,
              label: 'Límite inferior (a)',
              hint: 'ej. 1',
              icon: Icons.arrow_back_rounded,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
                signed: true,
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Requerido';
                if (double.tryParse(v) == null) return 'Número inválido';
                return null;
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: CustomTextField(
              controller: _bCtrl,
              label: 'Límite superior (b)',
              hint: 'ej. 2',
              icon: Icons.arrow_forward_rounded,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
                signed: true,
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Requerido';
                if (double.tryParse(v) == null) return 'Número inválido';
                final double? a = double.tryParse(_aCtrl.text);
                final double? b = double.tryParse(v);
                if (a != null && b != null && b <= a) return 'b debe ser > a';
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  // ── Tarjeta: parámetros del método ───────────────────────────────────────────
  Widget _buildParametersCard() {
    return _SectionCard(
      icon: Icons.tune_rounded,
      title: 'Parámetros del método',
      child: Column(
        children: [
          CustomTextField(
            controller: _tolCtrl,
            label: 'Tolerancia (%)',
            hint: 'ej. 0.0001',
            icon: Icons.precision_manufacturing_outlined,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            helperText: 'Error relativo porcentual máximo aceptado',
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Ingrese la tolerancia';
              final double? tol = double.tryParse(v);
              if (tol == null) return 'Número inválido';
              if (tol <= 0) return 'Debe ser > 0';
              return null;
            },
          ),
          const SizedBox(height: 12),
          CustomTextField(
            controller: _maxIterCtrl,
            label: 'Máximo de iteraciones',
            hint: 'ej. 100',
            icon: Icons.repeat_rounded,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            helperText: 'Número máximo de pasos del algoritmo',
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Ingrese el máximo';
              final int? n = int.tryParse(v);
              if (n == null || n <= 0) return 'Debe ser un entero positivo';
              if (n > 10000) return 'No puede superar 10000';
              return null;
            },
          ),
        ],
      ),
    );
  }

  // ── Botón principal calcular ──────────────────────────────────────────────────
  Widget _buildCalculateButton() {
    return Consumer<BisectionProvider>(
      builder: (_, provider, __) {
        final bool isLoading = provider.state == CalculationState.loading;
        return SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton.icon(
            onPressed: isLoading ? null : _calculate,
            icon: isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.calculate_rounded, size: 22),
            label: Text(isLoading ? 'Calculando...' : 'Calcular Raíz'),
          ),
        );
      },
    );
  }

  // ── Ayuda de sintaxis ─────────────────────────────────────────────────────────
  Widget _buildSyntaxHelp() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariant.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.keyboard_rounded, color: AppTheme.textSecondary, size: 14),
              SizedBox(width: 6),
              Text(
                'REFERENCIA DE SINTAXIS',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _syntaxChip('x^2', 'potencia'),
              _syntaxChip('sqrt(x)', 'raíz'),
              _syntaxChip('sin(x)', 'seno'),
              _syntaxChip('cos(x)', 'coseno'),
              _syntaxChip('tan(x)', 'tangente'),
              _syntaxChip('exp(x)', 'eˣ'),
              _syntaxChip('ln(x)', 'logaritmo natural'),
              _syntaxChip('log(x)', 'log₁₀'),
              _syntaxChip('abs(x)', 'valor absoluto'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _syntaxChip(String code, String desc) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
          decoration: BoxDecoration(
            color: AppTheme.primary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            code,
            style: const TextStyle(
              color: AppTheme.primaryLight,
              fontSize: 11,
              fontFamily: 'monospace',
            ),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          desc,
          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11),
        ),
      ],
    );
  }
}

// ── Widget auxiliar: tarjeta de sección ──────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const _SectionCard({
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
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
              Icon(icon, color: AppTheme.primary, size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
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
}

// ── Datos de ejemplos ─────────────────────────────────────────────────────────
class _ExampleFn {
  final String label;
  final String function;
  final String a;
  final String b;

  const _ExampleFn(this.label, this.function, this.a, this.b);
}

