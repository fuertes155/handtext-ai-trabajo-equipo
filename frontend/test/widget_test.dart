import 'package:flutter_test/flutter_test.dart';
import 'package:handtext_ai/main.dart';

void main() {
  testWidgets('desde la bienvenida se puede consultar la privacidad', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('Privacidad y acerca de'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Privacidad'));
    await tester.pumpAndSettle();
    expect(
      find.text(
        'Las cuentas y sesiones de la app se guardan en el dispositivo.',
      ),
      findsOneWidget,
    );
  });
}
