import 'package:flutter_test/flutter_test.dart';

import 'package:incluapp/main.dart';

void main() {
  testWidgets('IncluApp muestra la pantalla de captura', (tester) async {
    await tester.pumpWidget(const IncluApp());

    expect(find.text('IncluApp'), findsOneWidget);
    expect(find.text('Captura tu texto'), findsOneWidget);
    expect(find.text('Abrir cámara'), findsOneWidget);
    expect(find.text('Elegir imagen'), findsOneWidget);
  });
}
