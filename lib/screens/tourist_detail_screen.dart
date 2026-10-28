import 'package:flutter/material.dart';

import '../data/destino_repository.dart';
import '../models/destino.dart';
import '../utils/app_routes.dart';
import '../utils/route_args.dart';
import '../widgets/about_section.dart';
import '../widgets/activities_section.dart';
import '../widgets/booking_bar.dart';
import '../widgets/circuits_section.dart';
import '../widgets/destination_header.dart';
import '../widgets/gallery_section.dart';
import '../widgets/how_to_get_there_section.dart';
import '../widgets/included_section.dart';
import '../widgets/itinerary_section.dart';
import '../widgets/practical_info_section.dart';
import '../widgets/recommendations_section.dart';

import '../widgets/resenas_section.dart';

import '../widgets/distancia_section.dart';

class TouristDetailScreen extends StatelessWidget {
  final Destino destino;

  const TouristDetailScreen({super.key, required this.destino});

  Future<void> _editarDestino(BuildContext context) async {
    final destinoActualizado = await Navigator.pushNamed<Destino>(
      context,
      AppRoutes.destinoFormulario,
      arguments: DestinoFormArgs(destino: destino),
    );

    if (!context.mounted) {
      return;
    }

    if (destinoActualizado != null) {
      // Retornamos true para que la lista vuelva a consultar SQLite.
      Navigator.pop(context, true);
    }
  }

  Future<void> _eliminarDestino(BuildContext context) async {
    final id = destino.id;

    if (id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se puede eliminar un destino sin identificador.'),
        ),
      );
      return;
    }

    final confirmado = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Eliminar destino'),
          content: Text(
            '¿Deseas eliminar "${destino.nombre}"? '
            'Esta acción no se puede deshacer.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancelar'),
            ),
            FilledButton.icon(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              icon: const Icon(Icons.delete_outline),
              label: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (!context.mounted || confirmado != true) {
      return;
    }

    try {
      await DestinoRepository().eliminar(id);

      if (!context.mounted) {
        return;
      }

      // Regresa a la lista y solicita su actualización.
      Navigator.pop(context, true);
    } catch (e) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo eliminar el destino: $e')),
      );
    }
  }

  Future<void> _mostrarAcciones(BuildContext context) async {
    final accion = await showModalBottomSheet<String>(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text('Editar destino'),
                subtitle: const Text('Modificar los datos almacenados'),
                onTap: () {
                  Navigator.pop(sheetContext, 'editar');
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text(
                  'Eliminar destino',
                  style: TextStyle(color: Colors.red),
                ),
                subtitle: const Text('Eliminar permanentemente de SQLite'),
                onTap: () {
                  Navigator.pop(sheetContext, 'eliminar');
                },
              ),
            ],
          ),
        );
      },
    );

    if (!context.mounted) {
      return;
    }

    if (accion == 'editar') {
      await _editarDestino(context);
    } else if (accion == 'eliminar') {
      await _eliminarDestino(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isWideScreen = constraints.maxWidth >= 840;

          return SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: screenWidth >= 1200 ? 1200 : screenWidth,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DestinationHeader(destino: destino),

                    if (isWideScreen)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: PracticalInfoSection(destino: destino),
                          ),
                          const Expanded(child: AboutSection()),
                        ],
                      )
                    else ...[
                      PracticalInfoSection(destino: destino),
                      const AboutSection(),
                    ],

                    DistanciaSection(destino: destino),
                    const HowToGetThereSection(),
                    const CircuitsSection(),
                    const ItinerarySection(),
                    const IncludedSection(),
                    const ActivitiesSection(),
                    const RecommendationsSection(),
                    if (destino.id != null)
                      ResenasSection(destinoId: destino.id!),
                    const GallerySection(),
                  ],
                ),
              ),
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _mostrarAcciones(context);
        },
        icon: const Icon(Icons.settings_outlined),
        label: const Text('Gestionar'),
      ),

      bottomNavigationBar: const BookingBar(),
    );
  }
}
