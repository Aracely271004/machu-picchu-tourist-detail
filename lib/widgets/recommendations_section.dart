import 'package:flutter/material.dart';

/// Sección con recomendaciones prácticas para el visitante.
///
/// Toda la información es estática y está orientada
/// exclusivamente a la presentación de la interfaz.
class RecommendationsSection extends StatelessWidget {
  const RecommendationsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recomendaciones',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),

          SizedBox(height: 8),

          Text(
            'Ten en cuenta estas recomendaciones antes de realizar '
            'tu visita a Machu Picchu.',
            style: TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
          ),

          SizedBox(height: 24),

          RecommendationItem(
            icon: Icons.wb_sunny_outlined,
            title: 'Protección solar',
            description:
                'Lleva protector solar, gorra o sombrero para protegerte '
                'durante las zonas expuestas del recorrido.',
          ),

          RecommendationItem(
            icon: Icons.checkroom_outlined,
            title: 'Ropa adecuada',
            description:
                'Usa ropa cómoda y lleva una prenda para lluvia o frío, '
                'debido a los cambios de clima.',
          ),

          RecommendationItem(
            icon: Icons.directions_walk_outlined,
            title: 'Calzado cómodo',
            description:
                'Utiliza calzado apropiado para caminar por escaleras, '
                'senderos y superficies irregulares.',
          ),

          RecommendationItem(
            icon: Icons.badge_outlined,
            title: 'Documento de identidad',
            description:
                'Lleva contigo el documento utilizado para realizar '
                'la reserva o compra de la entrada.',
          ),

          RecommendationItem(
            icon: Icons.confirmation_number_outlined,
            title: 'Planifica tu ingreso',
            description:
                'Revisa con anticipación la fecha, horario y circuito '
                'correspondiente a tu entrada.',
          ),

          RecommendationItem(
            icon: Icons.water_drop_outlined,
            title: 'Mantente hidratado',
            description:
                'Lleva agua suficiente para mantenerte hidratado '
                'durante el recorrido.',
            showDivider: false,
          ),
        ],
      ),
    );
  }
}

/// Elemento reutilizable que muestra una recomendación.
class RecommendationItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool showDivider;

  const RecommendationItem({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Color(0xFFE8F5E9),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Color(0xFF1B5E20), size: 24),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
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
          ],
        ),

        if (showDivider)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(height: 1, color: Color(0xFFE0E0E0)),
          ),
      ],
    );
  }
}
