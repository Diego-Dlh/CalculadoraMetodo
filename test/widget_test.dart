import 'package:flutter_test/flutter_test.dart';
import 'package:calculadora_metodo/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const CalculadoraMetodoApp());
    expect(find.text('Método de Bisección'), findsOneWidget);
  });
}
