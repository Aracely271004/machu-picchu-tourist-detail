import 'package:flutter/material.dart';

/// Encabezado principal de la pantalla turística.
///
/// Utiliza un Stack para superponer:
/// - Imagen de portada.
/// - Degradado oscuro.
/// - Información textual.
/// - Botón visual de favorito.
///
/// La interfaz es completamente estática.
class DestinationHeader extends StatelessWidget {
  const DestinationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 420,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          // Imagen principal del destino turístico.
          Image.network(
            'https://images.unsplash.com/photo-1587595431973-160d0d94add1',
            fit: BoxFit.cover,
            semanticLabel:
                'Vista panorámica del santuario histórico de Machu Picchu',

            // Si la imagen no puede descargarse,
            // se muestra un fondo de respaldo.
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: const Color(0xFF2E5D3B),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.landscape_outlined,
                  size: 80,
                  color: Colors.white70,
                  semanticLabel: 'Imagen de Machu Picchu no disponible',
                ),
              );
            },
          ),

          // Degradado oscuro para mejorar la legibilidad del texto.
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Color.fromARGB(200, 0, 0, 0)],
              ),
            ),
          ),

          // Botón visual de favorito.
          Positioned(
            top: 24,
            right: 24,
            child: Semantics(
              label: 'Agregar Machu Picchu a favoritos',
              button: true,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.90),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.favorite_border,
                  semanticLabel: 'Favorito',
                ),
              ),
            ),
          ),
          // Información principal del destino.
          const Positioned(
            left: 24,
            right: 24,
            bottom: 28,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Machu Picchu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: Colors.white,
                      size: 20,
                      semanticLabel: 'Ubicación',
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Cusco, Perú',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
