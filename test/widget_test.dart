import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:machu_picchu_tourist_detail/main.dart';

void main() {
  testWidgets(
    'La pantalla principal muestra el título Machu Picchu',
    (WidgetTester tester) async {
      // Construye la aplicación principal.
      await tester.pumpWidget(const MachuPicchuApp());

      // Verifica que el nombre del destino aparezca en pantalla.
      expect(find.text('Machu Picchu'), findsOneWidget);

      // Comprueba que la aplicación utiliza la estructura Material.
      expect(find.byType(MaterialApp), findsOneWidget);
    },
  );
}