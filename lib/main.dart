import 'package:flutter/material.dart';

import 'screens/tourist_detail_screen.dart';

void main() {
  runApp(const MachuPicchuApp());
}

/// Widget raíz de la aplicación.
///
/// Esta aplicación corresponde al Proyecto Integrador 4:
/// Pantalla de detalle de un lugar turístico.
///
/// Todo el proyecto utilizará únicamente StatelessWidget,
/// según las restricciones establecidas para la sesión.
class MachuPicchuApp extends StatelessWidget {
  const MachuPicchuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Machu Picchu',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const TouristDetailScreen(),
    );
  }
}