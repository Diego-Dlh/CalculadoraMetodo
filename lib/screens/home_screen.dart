import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../methods/numerical_method.dart';
import '../providers/calculator_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/method_card.dart';
import 'about_me_screen.dart';
import 'calculator_screen.dart';
import 'history_screen.dart';
import 'theory_screen.dart';

/// Pantalla principal — selector de método numérico.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora Numérica'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded),
            tooltip: 'Historial',
            onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (_) => const HistoryScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.menu_book_rounded),
            tooltip: 'Teoría',
            onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (_) => const TheoryScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            tooltip: 'Acerca de',
            onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (_) => const AboutMeScreen())),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          const _MethodLabel('Métodos de intervalo'),
          const SizedBox(height: 10),
          _buildIntervalMethods(context),
          const SizedBox(height: 16),
          const _MethodLabel('Métodos abiertos'),
          const SizedBox(height: 10),
          _buildOpenMethods(context),
          const SizedBox(height: 24),
          _buildStartButton(context),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A1F3A), Color(0xFF252D4A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.calculate_rounded, color: AppTheme.primary, size: 28),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Análisis Numérico',
                  style: TextStyle(color: AppTheme.textPrimary, fontSize: 18,
                      fontWeight: FontWeight.w700)),
              SizedBox(height: 3),
              Text('Raíces de ecuaciones no lineales',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
            ]),
          ),
        ]),
        const SizedBox(height: 14),
        const Divider(color: AppTheme.surfaceBorder),
        const SizedBox(height: 10),
        const Text(
          'Selecciona un método y configura los parámetros para encontrar '
          'la raíz de tu ecuación. Cada método tiene características '
          'distintas de convergencia y requerimientos.',
          style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, height: 1.6),
        ),
      ]),
    );
  }

  // Bisección y Regla Falsa — métodos de intervalo
  Widget _buildIntervalMethods(BuildContext context) {
    return Consumer<CalculatorProvider>(
      builder: (_, provider, __) => Row(
        children: [
          NumericalMethodType.bisection,
          NumericalMethodType.falsePosition,
        ].map((type) => Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: MethodCard(
              config: NumericalMethodConfig.of(type),
              isSelected: provider.selectedMethod == type,
              onTap: () => provider.selectMethod(type),
            ),
          ),
        )).toList(),
      ),
    );
  }

  // Punto Fijo, Newton-Raphson, Secante — métodos abiertos
  Widget _buildOpenMethods(BuildContext context) {
    return Consumer<CalculatorProvider>(
      builder: (_, provider, __) => Column(
        children: [
          Row(
            children: [
              NumericalMethodType.fixedPoint,
              NumericalMethodType.newtonRaphson,
            ].map((type) => Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: MethodCard(
                  config: NumericalMethodConfig.of(type),
                  isSelected: provider.selectedMethod == type,
                  onTap: () => provider.selectMethod(type),
                ),
              ),
            )).toList(),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: MethodCard(
              config: NumericalMethodConfig.of(NumericalMethodType.secant),
              isSelected: provider.selectedMethod == NumericalMethodType.secant,
              onTap: () => provider.selectMethod(NumericalMethodType.secant),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return Consumer<CalculatorProvider>(
      builder: (_, provider, __) {
        final config = provider.config;
        return SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: config.color,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            icon: Icon(config.icon, size: 20),
            label: Text('Usar ${config.name}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CalculatorScreen()),
            ),
          ),
        );
      },
    );
  }
}

class _MethodLabel extends StatelessWidget {
  final String text;
  const _MethodLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(
        text.toUpperCase(),
        style: const TextStyle(
          color: AppTheme.textSecondary,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1,
        ),
      );
}
