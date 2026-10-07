import 'package:flutter/material.dart';

/// Sección que muestra actividades relacionadas con
/// la experiencia turística en Machu Picchu.
///
/// Se utiliza Wrap porque la cantidad de elementos puede
/// reorganizarse automáticamente según el ancho disponible.
class ActivitiesSection extends StatelessWidget {
  const ActivitiesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Actividades',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),

          SizedBox(height: 8),

          Text(
            'Descubre algunas de las experiencias que puedes disfrutar '
            'durante tu visita a Machu Picchu.',
            style: TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
          ),

          SizedBox(height: 24),

          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              ActivityChip(
                icon: Icons.account_balance_outlined,
                label: 'Arqueología',
              ),
              ActivityChip(icon: Icons.history_edu_outlined, label: 'Historia'),
              ActivityChip(
                icon: Icons.photo_camera_outlined,
                label: 'Fotografía',
              ),
              ActivityChip(icon: Icons.hiking_outlined, label: 'Caminata'),
              ActivityChip(icon: Icons.landscape_outlined, label: 'Naturaleza'),
              ActivityChip(icon: Icons.groups_outlined, label: 'Cultura Inka'),
              ActivityChip(icon: Icons.visibility_outlined, label: 'Paisajes'),
            ],
          ),
        ],
      ),
    );
  }
}

/// Chip reutilizable para representar una actividad.
class ActivityChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const ActivityChip({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(
        icon,
        size: 20,
        color: const Color(0xFF1B5E20),
        semanticLabel: label,
      ),
      label: Text(
        label,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      backgroundColor: const Color(0xFFF1F8E9),
      side: const BorderSide(color: Color(0xFFC8E6C9)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}
