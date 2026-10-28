import 'package:flutter/material.dart';

import 'data/database_helper.dart';
import 'screens/destinos_screen.dart';
import 'screens/tourist_detail_screen.dart';
import 'utils/app_routes.dart';
import 'utils/route_args.dart';

import 'screens/destino_form_screen.dart';
import 'models/destino.dart';

import 'models/resena.dart';
import 'screens/resena_form_screen.dart';

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

          case AppRoutes.destinoFormulario:
            final args = settings.arguments;

            if (args != null && args is! DestinoFormArgs) {
              return MaterialPageRoute(
                builder: (_) => const _RutaInvalidaScreen(),
              );
            }

            final formArgs =
                args as DestinoFormArgs? ?? const DestinoFormArgs();

            return MaterialPageRoute<Destino>(
              builder: (_) => DestinoFormScreen(destino: formArgs.destino),
              settings: settings,
            );

          case AppRoutes.resenaFormulario:
            final args = settings.arguments;

            if (args is! ResenaFormArgs) {
              return MaterialPageRoute(
                builder: (_) => const _RutaInvalidaScreen(),
              );
            }

            return MaterialPageRoute<Resena>(
              builder: (_) => ResenaFormScreen(destinoId: args.destinoId),
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
