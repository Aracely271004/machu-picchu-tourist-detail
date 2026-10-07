import 'package:flutter/material.dart';

/// Sección que presenta distintas formas de llegar a Machu Picchu.
///
/// Toda la información es estática y se muestra únicamente
/// con fines de interfaz.
class HowToGetThereSection extends StatelessWidget {
  const HowToGetThereSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cómo llegar',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Existen diferentes alternativas para llegar a Machu Picchu. '
            'La elección depende del tiempo disponible y del tipo de '
            'experiencia que busca el visitante.',
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 24),

          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: const [
              TravelOptionCard(
                icon: Icons.train_outlined,
                title: 'Viaje en tren',
                description:
                    'Traslado desde Cusco u Ollantaytambo hacia '
                    'Machu Picchu Pueblo. Es una alternativa cómoda '
                    'y permite disfrutar del paisaje durante el recorrido.',
                detail: 'Ideal para una visita de un día.',
              ),

              TravelOptionCard(
                icon: Icons.hiking_outlined,
                title: 'Camino Inca',
                description:
                    'Ruta de caminata que combina naturaleza, '
                    'paisajes andinos y sitios arqueológicos antes '
                    'de llegar al santuario.',
                detail: 'Ideal para aventura y trekking.',
              ),

              TravelOptionCard(
                icon: Icons.directions_bus_outlined,
                title: 'Ruta Hidroeléctrica',
                description:
                    'Alternativa terrestre que permite llegar hasta '
                    'Hidroeléctrica y continuar hacia Machu Picchu '
                    'Pueblo mediante caminata o tren.',
                detail: 'Alternativa terrestre y económica.',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Tarjeta reutilizable para representar una forma de viaje.
class TravelOptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String detail;

  const TravelOptionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Color(0xFFE8F5E9),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: const Color(0xFF1B5E20),
              size: 28,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            description,
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              const Icon(
                Icons.info_outline,
                size: 18,
                color: Color(0xFF1B5E20),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  detail,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1B5E20),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}