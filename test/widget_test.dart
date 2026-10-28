import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:machu_picchu_tourist_detail/screens/destino_form_screen.dart';

void main() {
  Future<void> prepararFormulario(WidgetTester tester) async {
    // Usamos una ventana alta para mantener todos los
    // TextFormField y el botón dentro del árbol de widgets.
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const MaterialApp(home: DestinoFormScreen()));

    await tester.pumpAndSettle();
  }

  testWidgets('El formulario de destino muestra sus campos principales', (
    WidgetTester tester,
  ) async {
    await prepararFormulario(tester);

    expect(find.text('Nuevo destino'), findsOneWidget);

    expect(find.text('Nombre'), findsOneWidget);

    expect(find.text('Descripción'), findsOneWidget);

    expect(find.text('Categoría'), findsOneWidget);

    expect(find.text('Altitud (msnm)'), findsOneWidget);

    expect(find.text('Duración (horas)'), findsOneWidget);

    expect(find.text('Dificultad'), findsOneWidget);

    expect(find.text('Precio (S/)'), findsOneWidget);

    expect(find.text('Guardar destino'), findsOneWidget);
  });

  testWidgets('El formulario valida los campos obligatorios', (
    WidgetTester tester,
  ) async {
    await prepararFormulario(tester);

    final botonGuardar = find.text('Guardar destino');

    expect(botonGuardar, findsOneWidget);

    await tester.tap(botonGuardar);

    await tester.pumpAndSettle();

    expect(find.text('El nombre es obligatorio.'), findsOneWidget);

    expect(find.text('La descripción es obligatoria.'), findsOneWidget);

    expect(find.text('Ingrese una altitud válida.'), findsOneWidget);

    expect(find.text('Ingrese una duración válida.'), findsOneWidget);

    expect(find.text('Ingrese un precio válido.'), findsOneWidget);
  });
}
