import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../methods/numerical_method.dart';
import '../providers/calculator_provider.dart';
import '../providers/history_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/custom_text_field.dart';
import 'results_screen.dart';

/// Pantalla de formulario dinámico — campos según el método seleccionado.
class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  NumericalMethodType? _currentMethod;

  @override
  void dispose() {
    for (final c in _controllers.values) c.dispose();
    super.dispose();
  }

  /// Inicializa controladores con valores por defecto del método actual.
  void _initControllers(NumericalMethodConfig config) {
    if (_currentMethod == config.type) return;
    _currentMethod = config.type;
    for (final c in _controllers.values) c.dispose();
    _controllers.clear();
    for (final field in config.fields) {
      _controllers[field.key] =
          TextEditingController(text: config.defaults[field.key] ?? '');
    }
  }

  void _calculate() {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<CalculatorProvider>();
    final params = _controllers.map((k, v) => MapEntry(k, v.text));
    provider.calculate(params);

    if (provider.state == CalculationState.success && provider.result != null) {
      // Guardar en historial
      context.read<HistoryProvider>().addResult(provider.result!);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ResultsScreen()),
      );
    } else if (provider.state == CalculationState.error) {
      _showError(provider.errorMessage ?? 'Error desconocido');
    }
  }

  void _showError(String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(children: [
          Icon(Icons.warning_amber_rounded, color: AppTheme.accentWarm, size: 22),
          SizedBox(width: 10),
          Text('Error', style: TextStyle(color: AppTheme.textPrimary, fontSize: 16)),
        ]),
        content: Text(msg,
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13, height: 1.5)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK', style: TextStyle(color: AppTheme.primary)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CalculatorProvider>(
      builder: (_, provider, __) {
        final config = provider.config;
        _initControllers(config);

        return Scaffold(
          appBar: AppBar(
            title: Text(config.name),
            leading: const BackButton(),
          ),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
              children: [
                _buildMethodBadge(config),
                const SizedBox(height: 16),
                _buildExamples(config),
                const SizedBox(height: 16),
                _buildFields(config),
                const SizedBox(height: 24),
                _buildCalcButton(provider, config),
                const SizedBox(height: 12),
                _buildSyntaxHelp(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMethodBadge(NumericalMethodConfig config) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: config.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: config.color.withValues(alpha: 0.4)),
      ),
      child: Row(children: [
        Icon(config.icon, color: config.color, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(config.name,
                style: TextStyle(color: config.color, fontSize: 15, fontWeight: FontWeight.w700)),
            const SizedBox(height: 3),
            Text(config.shortDescription,
                style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          ]),
        ),
      ]),
    );
  }

  Widget _buildExamples(NumericalMethodConfig config) {
    final examples = _examplesFor(config.type);
    if (examples.isEmpty) return const SizedBox.shrink();

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Ejemplos rápidos',
          style: TextStyle(color: AppTheme.textSecondary, fontSize: 11,
              fontWeight: FontWeight.w700, letterSpacing: 0.8)),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        runSpacing: 6,
        children: examples.map((ex) => ActionChip(
          label: Text(ex.label),
          avatar: const Icon(Icons.play_arrow_rounded, size: 14),
          onPressed: () {
            setState(() {
              ex.values.forEach((k, v) {
                if (_controllers.containsKey(k)) _controllers[k]!.text = v;
              });
            });
            HapticFeedback.selectionClick();
          },
        )).toList(),
      ),
    ]);
  }

  Widget _buildFields(NumericalMethodConfig config) {
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
          Row(children: [
            Icon(Icons.input_rounded, color: AppTheme.primary, size: 18),
            const SizedBox(width: 8),
            const Text('Parámetros de entrada',
                style: TextStyle(color: AppTheme.textPrimary, fontSize: 14,
                    fontWeight: FontWeight.w600)),
          ]),
          const SizedBox(height: 14),
          ...config.fields.asMap().entries.map((e) {
            final field = e.value;
            final ctrl = _controllers[field.key]!;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: CustomTextField(
                controller: ctrl,
                label: field.label,
                hint: field.hint,
                icon: field.icon,
                helperText: field.helper,
                keyboardType: field.isExpression
                    ? TextInputType.text
                    : const TextInputType.numberWithOptions(decimal: true, signed: true),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Campo requerido';
                  if (!field.isExpression && double.tryParse(v) == null &&
                      int.tryParse(v) == null) return 'Número inválido';
                  return null;
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCalcButton(CalculatorProvider provider, NumericalMethodConfig config) {
    final bool loading = provider.state == CalculationState.loading;
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: config.color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        onPressed: loading ? null : _calculate,
        icon: loading
            ? const SizedBox(width: 18, height: 18,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
            : const Icon(Icons.play_arrow_rounded, size: 22),
        label: Text(loading ? 'Calculando...' : 'Calcular Raíz',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
      ),
    );
  }

  Widget _buildSyntaxHelp() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariant.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Row(children: [
          Icon(Icons.keyboard_rounded, color: AppTheme.textSecondary, size: 14),
          SizedBox(width: 6),
          Text('SINTAXIS', style: TextStyle(color: AppTheme.textSecondary, fontSize: 10,
              fontWeight: FontWeight.w700, letterSpacing: 1)),
        ]),
        const SizedBox(height: 10),
        Wrap(spacing: 10, runSpacing: 6, children: const [
          _SynChip('x^n', 'potencia'), _SynChip('sqrt(x)', 'raíz'),
          _SynChip('sin(x)', 'seno'), _SynChip('cos(x)', 'coseno'),
          _SynChip('exp(x)', 'eˣ'), _SynChip('ln(x)', 'log natural'),
          _SynChip('abs(x)', '|x|'), _SynChip('tan(x)', 'tangente'),
        ]),
      ]),
    );
  }
}

// ── Ejemplos por método ──────────────────────────────────────────────────────

class _Example {
  final String label;
  final Map<String, String> values;
  const _Example(this.label, this.values);
}

List<_Example> _examplesFor(NumericalMethodType type) {
  switch (type) {
    case NumericalMethodType.bisection:
    case NumericalMethodType.falsePosition:
      return [
        _Example('x³−x−2', {'function': 'x^3 - x - 2', 'a': '1', 'b': '2'}),
        _Example('cos(x)−x', {'function': 'cos(x) - x', 'a': '0', 'b': '1'}),
        _Example('x²−4', {'function': 'x^2 - 4', 'a': '1', 'b': '3'}),
        _Example('eˣ−3', {'function': 'exp(x) - 3', 'a': '0', 'b': '2'}),
      ];
    case NumericalMethodType.fixedPoint:
      return [
        _Example('cos(x)', {'gFunction': 'cos(x)', 'x0': '1'}),
        _Example('(x+2)^(1/3)', {'gFunction': '(x+2)^(1/3)', 'x0': '1'}),
        _Example('exp(x)/3', {'gFunction': 'exp(x)/3', 'x0': '1'}),
      ];
    case NumericalMethodType.newtonRaphson:
      return [
        _Example('x³−x−2', {'function': 'x^3 - x - 2', 'derivative': '3*x^2 - 1', 'x0': '1.5'}),
        _Example('cos(x)−x', {'function': 'cos(x) - x', 'derivative': '-sin(x) - 1', 'x0': '0.5'}),
        _Example('x²−2', {'function': 'x^2 - 2', 'derivative': '2*x', 'x0': '1'}),
      ];
    case NumericalMethodType.secant:
      return [
        _Example('x³−x−2', {'function': 'x^3 - x - 2', 'x0': '1', 'x1': '2'}),
        _Example('cos(x)−x', {'function': 'cos(x) - x', 'x0': '0', 'x1': '1'}),
        _Example('eˣ−3', {'function': 'exp(x) - 3', 'x0': '0', 'x1': '2'}),
      ];
  }
}

class _SynChip extends StatelessWidget {
  final String code;
  final String desc;
  const _SynChip(this.code, this.desc);

  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppTheme.primary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(code,
          style: const TextStyle(color: AppTheme.primaryLight, fontSize: 11,
              fontFamily: 'monospace')),
    ),
    const SizedBox(width: 4),
    Text(desc, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
  ]);
}
