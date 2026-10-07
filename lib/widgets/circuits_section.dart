import 'package:flutter/material.dart';

/// Sección que presenta los principales circuitos de visita.
///
/// La información es estática y no incluye navegación ni lógica.
class CircuitsSection extends StatelessWidget {
  const CircuitsSection({super.key});

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
            'Circuitos de visita',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Machu Picchu cuenta con diferentes circuitos que permiten '
            'recorrer el santuario según el tipo de experiencia que busca '
            'el visitante.',
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
              CircuitCard(
                number: '01',
                title: 'Panorámico',
                subtitle: 'Vistas y fotografía',
                icon: Icons.photo_camera_outlined,
                description:
                    'Recorrido orientado a obtener vistas amplias del '
                    'santuario y de las montañas que rodean Machu Picchu.',
                tags: [
                  'Paisajes',
                  'Fotografía',
                  'Montaña',
                ],
              ),

              CircuitCard(
                number: '02',
                title: 'Clásico',
                subtitle: 'Ciudad Inka',
                icon: Icons.account_balance_outlined,
                description:
                    'Recorrido enfocado en los principales sectores '
                    'arqueológicos y arquitectónicos de la ciudad inca.',
                tags: [
                  'Historia',
                  'Arquitectura',
                  'Cultura',
                ],
              ),

              CircuitCard(
                number: '03',
                title: 'Realeza',
                subtitle: 'Arqueología y aventura',
                icon: Icons.hiking_outlined,
                description:
                    'Alternativa que combina espacios arqueológicos con '
                    'sectores de mayor exigencia física y recorridos de montaña.',
                tags: [
                  'Caminata',
                  'Naturaleza',
                  'Aventura',
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Tarjeta reutilizable que representa un circuito de visita.
class CircuitCard extends StatelessWidget {
  final String number;
  final String title;
  final String subtitle;
  final IconData icon;
  final String description;
  final List<String> tags;

  const CircuitCard({
    super.key,
    required this.number,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.description,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                  color: Color(0xFF1B5E20),
                ),
              ),

              const Spacer(),

              Text(
                number,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFBDBDBD),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Text(
            'Circuito $number',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1B5E20),
            ),
          ),

          const SizedBox(height: 4),

          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black54,
            ),
          ),

          const SizedBox(height: 14),

          Text(
            description,
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 18),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tags
                .map(
                  (tag) => Chip(
                    label: Text(tag),
                    backgroundColor: const Color(0xFFF1F8E9),
                    side: BorderSide.none,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}