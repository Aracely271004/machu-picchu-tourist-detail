import 'package:flutter/material.dart';

import 'data/database_helper.dart';
import 'screens/destinos_screen.dart';
import 'screens/tourist_detail_screen.dart';
import 'utils/app_routes.dart';
import 'utils/route_args.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DatabaseHelper.bd;

  runApp(const MachuPicchuApp());
}

class MachuPicchuApp extends StatelessWidget {
  const MachuPicchuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.inicio,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case AppRoutes.inicio:
            return MaterialPageRoute(
              builder: (_) => const DestinosScreen(),
              settings: settings,
            );

          case AppRoutes.destinoDetalle:
            final args = settings.arguments;

            if (args is! DestinoDetalleArgs) {
              return MaterialPageRoute(
                builder: (_) => const _RutaInvalidaScreen(),
              );
            }

            return MaterialPageRoute<bool>(
              builder: (_) => TouristDetailScreen(destino: args.destino),
              settings: settings,
            );

          default:
            return MaterialPageRoute(
              builder: (_) => const _RutaInvalidaScreen(),
            );
        }
      },
    );
  }
}

class _RutaInvalidaScreen extends StatelessWidget {
  const _RutaInvalidaScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ruta no disponible')),
      body: const Center(
        child: Text('No se pudo abrir la pantalla solicitada.'),
      ),
    );
  }
}
