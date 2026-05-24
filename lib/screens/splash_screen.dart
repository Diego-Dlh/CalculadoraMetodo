import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  static const Color centerColor = Color(0xFF00307A);
  static const Color midColor    = Color(0xFF00205B);
  static const Color edgeColor   = Color(0xFF00184A);
  static const Color blueAccent  = Color(0xFF1DB9FF);
  static const Color greenAccent = Color(0xFF8CE34A);

  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<double> _scale;
  late Animation<double> _bar;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fade  = CurvedAnimation(parent: _ctrl,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn));
    _scale = Tween<double>(begin: 0.85, end: 1.0).animate(
        CurvedAnimation(parent: _ctrl,
            curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack)));
    _bar = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _ctrl,
            curve: const Interval(0.4, 1.0, curve: Curves.easeInOut)));

    _ctrl.forward();

    Future.delayed(const Duration(milliseconds: 1400), () {
      FlutterNativeSplash.remove();
      if (mounted) {
        Navigator.of(context).pushReplacement(PageRouteBuilder(
          pageBuilder: (_, __, ___) => const HomeScreen(),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
        ));
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.1,
            colors: [centerColor, midColor, edgeColor],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Logo centrado — ocupa el espacio principal
              Expanded(
                child: FadeTransition(
                  opacity: _fade,
                  child: ScaleTransition(
                    scale: _scale,
                    child: Center(
                      child: const SizedBox.shrink(),
                    ),
                  ),
                ),
              ),

              // Barra de carga en la parte inferior
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 0, 32, 48),
                child: AnimatedBuilder(
                  animation: _bar,
                  builder: (_, __) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Pista (fondo de la barra)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          height: 5,
                          width: double.infinity,
                          color: Colors.white.withValues(alpha: 0.1),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: FractionallySizedBox(
                              widthFactor: _bar.value,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [blueAccent, greenAccent],
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                  boxShadow: [
                                    BoxShadow(
                                      color: blueAccent.withValues(alpha: 0.6),
                                      blurRadius: 10,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${(_bar.value * 100).toInt()} %',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.4),
                          fontSize: 11,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
