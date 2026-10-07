import 'package:flutter/material.dart';

/// Sección informativa sobre Machu Picchu.
///
/// Presenta tres bloques de contenido:
/// historia, arquitectura y entorno natural.
class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sobre Machu Picchu',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 24),

          AboutParagraph(
            title: 'Historia',
            text:
                'Machu Picchu es uno de los principales destinos arqueológicos '
                'del Cusco. La ciudad inca fue construida en un entorno montañoso '
                'y actualmente constituye uno de los lugares más representativos '
                'del patrimonio cultural del Perú.',
          ),

          SizedBox(height: 20),

          AboutParagraph(
            title: 'Arquitectura',
            text:
                'El conjunto arqueológico presenta sectores urbanos, ceremoniales '
                'y agrícolas. Sus construcciones de piedra, terrazas y caminos '
                'muestran el alto nivel de planificación y adaptación de la '
                'arquitectura inca al relieve de la montaña.',
          ),

          SizedBox(height: 20),

          AboutParagraph(
            title: 'Naturaleza',
            text:
                'La visita combina patrimonio histórico y paisaje natural. '
                'Montañas, vegetación y terrazas rodean el sitio arqueológico, '
                'generando una experiencia en la que cultura, naturaleza y '
                'fotografía forman parte del mismo recorrido.',
          ),
        ],
      ),
    );
  }
}

/// Bloque reutilizable para cada apartado descriptivo.
class AboutParagraph extends StatelessWidget {
  final String title;
  final String text;

  const AboutParagraph({
    super.key,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1B5E20),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          text,
          textAlign: TextAlign.justify,
          style: const TextStyle(
            fontSize: 16,
            height: 1.6,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}