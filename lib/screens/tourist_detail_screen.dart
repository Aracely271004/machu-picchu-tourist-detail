import 'package:flutter/material.dart';

import '../widgets/destination_header.dart';
import '../widgets/practical_info_section.dart';
import '../widgets/about_section.dart';
import '../widgets/how_to_get_there_section.dart';
import '../widgets/circuits_section.dart';
import '../widgets/itinerary_section.dart';
import '../widgets/included_section.dart';
import '../widgets/activities_section.dart';
import '../widgets/recommendations_section.dart';
import '../widgets/gallery_section.dart';
import '../widgets/booking_bar.dart';
import '../models/destino.dart';

class TouristDetailScreen extends StatelessWidget {
  final Destino destino;

  const TouristDetailScreen({super.key, required this.destino});

  @override
  Widget build(BuildContext context) {
    // MediaQuery obtiene información global del dispositivo/pantalla.
    final double screenWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          // LayoutBuilder trabaja con el ancho realmente disponible
          // para esta parte de la interfaz.
          final bool isWideScreen = constraints.maxWidth >= 840;

          return SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                // En monitores muy grandes evitamos que el contenido
                // se expanda indefinidamente.
                constraints: BoxConstraints(
                  maxWidth: screenWidth >= 1200 ? 1200 : screenWidth,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DestinationHeader(destino: destino),

                    // En pantallas grandes las dos secciones
                    // se presentan una al lado de la otra.
                    if (isWideScreen)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: PracticalInfoSection(destino: destino),
                          ),
                          Expanded(child: AboutSection()),
                        ],
                      )
                    else ...[
                      PracticalInfoSection(destino: destino),
                      const AboutSection(),
                    ],

                    const HowToGetThereSection(),
                    const CircuitsSection(),
                    const ItinerarySection(),
                    const IncludedSection(),
                    const ActivitiesSection(),
                    const RecommendationsSection(),
                    const GallerySection(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: const BookingBar(),
    );
  }
}
