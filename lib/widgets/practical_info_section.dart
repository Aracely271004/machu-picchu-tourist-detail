import 'package:flutter/material.dart';

/// Sección que presenta información práctica del destino.
///
/// Se utiliza Wrap para permitir que las tarjetas se reorganicen
/// automáticamente cuando cambia el ancho disponible.
class PracticalInfoSection extends StatelessWidget {
  const PracticalInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Información práctica',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 24),
            LayoutBuilder(
            builder: (context, constraints) {
              final bool isCompact = constraints.maxWidth < 520;

              if (isCompact) {
                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: const [
                    PracticalInfoCard(
                      icon: Icons.landscape_outlined,
                      value: '2 445 m',
                      label: 'Altitud',
                    ),
                    PracticalInfoCard(
                      icon: Icons.schedule_outlined,
                      value: 'Día completo',
                      label: 'Duración',
                    ),
                    PracticalInfoCard(
                      icon: Icons.hiking_outlined,
                      value: 'Moderada',
                      label: 'Dificultad',
                    ),
                    PracticalInfoCard(
                      icon: Icons.wb_sunny_outlined,
                      value: '1 °C – 20 °C',
                      label: 'Clima',
                    ),
                    PracticalInfoCard(
                      icon: Icons.location_on_outlined,
                      value: 'Cusco',
                      label: 'Región',
                    ),
                    PracticalInfoCard(
                      icon: Icons.confirmation_number_outlined,
                      value: 'Con boleto',
                      label: 'Ingreso',
                    ),
                  ],
                );
              }

              return const Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: PracticalInfoCard(
                          icon: Icons.landscape_outlined,
                          value: '2 445 m',
                          label: 'Altitud',
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: PracticalInfoCard(
                          icon: Icons.schedule_outlined,
                          value: 'Día completo',
                          label: 'Duración',
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: PracticalInfoCard(
                          icon: Icons.hiking_outlined,
                          value: 'Moderada',
                          label: 'Dificultad',
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: PracticalInfoCard(
                          icon: Icons.wb_sunny_outlined,
                          value: '1 °C – 20 °C',
                          label: 'Clima',
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: PracticalInfoCard(
                          icon: Icons.location_on_outlined,
                          value: 'Cusco',
                          label: 'Región',
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: PracticalInfoCard(
                          icon: Icons.confirmation_number_outlined,
                          value: 'Con boleto',
                          label: 'Ingreso',
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Tarjeta reutilizable para mostrar un dato práctico.
class PracticalInfoCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const PracticalInfoCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minWidth: 150,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(20, 0, 0, 0),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 30,
            color: const Color(0xFF1B5E20),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}