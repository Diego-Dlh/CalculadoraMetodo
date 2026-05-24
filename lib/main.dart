import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'providers/calculator_provider.dart';
import 'providers/history_provider.dart';
import 'screens/splash_screen.dart';
import 'utils/app_theme.dart';

void main() {
  // Preservar el splash nativo hasta que lo quitemos manualmente
  final WidgetsBinding binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFF001A4D),
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  runApp(const CalculadoraMetodoApp());
}

class CalculadoraMetodoApp extends StatelessWidget {
  const CalculadoraMetodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CalculatorProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
      ],
      child: MaterialApp(
        title: 'RaicesPro',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        // Iniciar en SplashScreen, que navega a HomeScreen tras la carga
        home: const SplashScreen(),
      ),
    );
  }
}
