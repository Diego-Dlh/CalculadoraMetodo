import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

/// Pantalla "Acerca de" — información del equipo y la asignatura.
class AboutMeScreen extends StatelessWidget {
  const AboutMeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Acerca de')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
        children: [
          _buildHero(),
          const SizedBox(height: 20),
          _buildInfoCard(),
          const SizedBox(height: 14),
          _buildTeamCard(),
          const SizedBox(height: 14),
          _buildAppCard(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ── Banner principal ───────────────────────────────────────────────────────
  Widget _buildHero() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
      decoration: BoxDecoration(
        gradient: const RadialGradient(
          center: Alignment.center,
          radius: 1.1,
          colors: [Color(0xFF00307A), Color(0xFF00205B), Color(0xFF00184A)],
          stops: [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1DB9FF).withValues(alpha: 0.3)),
      ),
      child: Column(children: [
        // Ícono de la app
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: Border.all(
                color: const Color(0xFF1DB9FF).withValues(alpha: 0.5), width: 2),
          ),
          child: const Icon(Icons.functions_rounded,
              color: Color(0xFF1DB9FF), size: 40),
        ),
        const SizedBox(height: 16),
        const Text(
          'RaicesPro',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Calculadora de Métodos Numéricos',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.65),
            fontSize: 13,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: const Color(0xFF8CE34A).withValues(alpha: 0.4)),
          ),
          child: const Text(
            'Esta aplicación fue diseñada como muestra de nuestras habilidades '
            'para la asignatura de Análisis Numérico.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              height: 1.6,
            ),
          ),
        ),
      ]),
    );
  }

  // ── Información académica ──────────────────────────────────────────────────
  Widget _buildInfoCard() {
    return _Card(
      icon: Icons.school_rounded,
      iconColor: const Color(0xFF1DB9FF),
      title: 'Información Académica',
      children: [
        _InfoRow(Icons.book_rounded, 'Asignatura', 'Análisis Numérico'),
        _InfoRow(Icons.calendar_today_rounded, 'Período', '2026 — Semestre 1'),
        _InfoRow(Icons.group_rounded, 'Grupo', 'Grupo 2'),
        _InfoRow(Icons.person_rounded, 'Profesor', 'Marlon Andres Hurtado Cantillo'),
      ],
    );
  }

  // ── Equipo de trabajo ──────────────────────────────────────────────────────
  Widget _buildTeamCard() {
    return _Card(
      icon: Icons.groups_rounded,
      iconColor: const Color(0xFF8CE34A),
      title: 'Equipo de Trabajo',
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF8CE34A).withValues(alpha: 0.12),
                AppTheme.surface,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: const Color(0xFF8CE34A).withValues(alpha: 0.3)),
          ),
          child: Row(children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFF8CE34A).withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  '7',
                  style: TextStyle(
                    color: Color(0xFF8CE34A),
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Grupo de Trabajo N° 7',
                    style: TextStyle(
                      color: Color(0xFF8CE34A),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Ingeniería de Sistemas',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ],
    );
  }

  // ── Sobre la app ───────────────────────────────────────────────────────────
  Widget _buildAppCard() {
    return _Card(
      icon: Icons.calculate_rounded,
      iconColor: AppTheme.primary,
      title: 'Sobre la Aplicación',
      children: [
        _MethodChip(Icons.cut_rounded, 'Bisección', AppTheme.primary),
        _MethodChip(Icons.adjust_rounded, 'Punto Fijo', const Color(0xFF2196F3)),
        _MethodChip(Icons.show_chart_rounded, 'Regla Falsa', const Color(0xFF4CAF50)),
        _MethodChip(Icons.trending_down_rounded, 'Newton-Raphson', const Color(0xFFFF9800)),
        _MethodChip(Icons.linear_scale_rounded, 'Secante', AppTheme.accent),
        const SizedBox(height: 8),
        Text(
          'Desarrollada con Flutter · Dart 3 · fl_chart · math_expressions',
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 11,
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// ── Widgets auxiliares ────────────────────────────────────────────────────────

class _Card extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final List<Widget> children;

  const _Card({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.children,
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
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 10),
          Text(title,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              )),
        ]),
        const SizedBox(height: 14),
        ...children,
      ]),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(children: [
        Icon(icon, color: AppTheme.textSecondary, size: 16),
        const SizedBox(width: 10),
        SizedBox(
          width: 90,
          child: Text(label,
              style: const TextStyle(
                  color: AppTheme.textSecondary, fontSize: 13)),
        ),
        const Text(' : ',
            style: TextStyle(color: AppTheme.surfaceBorder)),
        Expanded(
          child: Text(value,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              )),
        ),
      ]),
    );
  }
}

class _MethodChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _MethodChip(this.icon, this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 10),
        Text(label,
            style: TextStyle(
                color: color, fontSize: 13, fontWeight: FontWeight.w600)),
      ]),
    );
  }
}
