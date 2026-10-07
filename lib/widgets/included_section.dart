import 'package:flutter/material.dart';

/// Sección que resume los servicios incluidos y no incluidos
/// en la experiencia turística.
///
/// La información es estática y puede actualizarse posteriormente
/// con los datos definitivos del itinerario.
class IncludedSection extends StatelessWidget {
  const IncludedSection({super.key});

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
            'Qué está incluido',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 8),

          Text(
            'Servicios considerados dentro de la experiencia turística.',
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Colors.black87,
            ),
          ),

          SizedBox(height: 24),

          IncludedItem(
            text: 'Traslado turístico desde Cusco.',
          ),
          IncludedItem(
            text: 'Boletos de tren de ida y retorno.',
          ),
          IncludedItem(
            text: 'Bus de subida y bajada hacia Machu Picchu.',
          ),
          IncludedItem(
            text: 'Entrada al santuario histórico.',
          ),
          IncludedItem(
            text: 'Servicio de guía durante el recorrido.',
          ),

          SizedBox(height: 28),

          Text(
            'No incluye',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 16),

          NotIncludedItem(
            text: 'Alimentación y bebidas.',
          ),
          NotIncludedItem(
            text: 'Gastos personales.',
          ),
          NotIncludedItem(
            text: 'Servicios adicionales no especificados.',
          ),
        ],
      ),
    );
  }
}

/// Elemento visual para un servicio incluido.
class IncludedItem extends StatelessWidget {
  final String text;

  const IncludedItem({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: Color(0xFFE8F5E9),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check,
              size: 18,
              color: Color(0xFF1B5E20),
              semanticLabel: 'Servicio incluido',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Elemento visual para un servicio no incluido.
class NotIncludedItem extends StatelessWidget {
  final String text;

  const NotIncludedItem({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: Color(0xFFF0F0F0),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.close,
              size: 18,
              color: Colors.black54,
              semanticLabel: 'Servicio no incluido',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}