import 'package:flutter/material.dart';

/// Sección que representa un itinerario referencial
/// para una visita de un día a Machu Picchu.
class ItinerarySection extends StatelessWidget {
  const ItinerarySection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Itinerario referencial',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 8),

          Text(
            'Ejemplo de una visita de un día. Los horarios son referenciales '
            'y podrán reemplazarse por el itinerario definitivo.',
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Colors.black87,
            ),
          ),

          SizedBox(height: 24),

          ItineraryItem(
            time: '05:30',
            title: 'Recojo y salida desde Cusco',
            description:
                'Inicio del viaje desde el punto de encuentro hacia '
                'la estación de tren.',
            icon: Icons.directions_bus_outlined,
          ),

          ItineraryItem(
            time: '07:30',
            title: 'Viaje en tren',
            description:
                'Recorrido hacia Machu Picchu Pueblo disfrutando '
                'del paisaje del Valle Sagrado.',
            icon: Icons.train_outlined,
          ),

          ItineraryItem(
            time: '10:00',
            title: 'Ascenso al santuario',
            description:
                'Traslado desde Machu Picchu Pueblo hacia el ingreso '
                'del santuario histórico.',
            icon: Icons.directions_bus_outlined,
          ),

          ItineraryItem(
            time: '10:30',
            title: 'Visita a Machu Picchu',
            description:
                'Recorrido guiado por el circuito seleccionado.',
            icon: Icons.account_balance_outlined,
          ),

          ItineraryItem(
            time: '13:30',
            title: 'Retorno a Machu Picchu Pueblo',
            description:
                'Descenso hacia el pueblo y tiempo libre antes '
                'del retorno.',
            icon: Icons.location_city_outlined,
          ),

          ItineraryItem(
            time: '16:00',
            title: 'Tren de retorno',
            description:
                'Viaje de regreso hacia Ollantaytambo.',
            icon: Icons.train_outlined,
          ),

          ItineraryItem(
            time: '19:00',
            title: 'Retorno a Cusco',
            description:
                'Traslado final hacia Cusco y cierre de la experiencia.',
            icon: Icons.flag_outlined,
            showLine: false,
          ),
        ],
      ),
    );
  }
}

/// Elemento reutilizable de la línea de tiempo.
class ItineraryItem extends StatelessWidget {
  final String time;
  final String title;
  final String description;
  final IconData icon;
  final bool showLine;

  const ItineraryItem({
    super.key,
    required this.time,
    required this.title,
    required this.description,
    required this.icon,
    this.showLine = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 70,
          child: Text(
            time,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B5E20),
            ),
          ),
        ),

        Column(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: Color(0xFFE8F5E9),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Color(0xFF1B5E20),
                size: 22,
              ),
            ),

            if (showLine)
              Container(
                width: 2,
                height: 52,
                color: Color(0xFFC8E6C9),
              ),
          ],
        ),

        const SizedBox(width: 16),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 4,
              bottom: 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}