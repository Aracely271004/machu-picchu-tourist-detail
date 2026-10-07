import 'package:flutter/material.dart';

/// Galería de imágenes de Machu Picchu.
///
/// En esta etapa utiliza dos columnas.
/// Posteriormente se adaptará a diferentes anchos de pantalla.
class GallerySection extends StatelessWidget {
  const GallerySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Galería',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          const Text(
            'Conoce algunos de los paisajes y espacios que forman parte '
            'de la experiencia en Machu Picchu.',
            style: TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
          ),

          const SizedBox(height: 24),

          GridView.count(
            // El GridView está dentro del scroll principal,
            // por eso no necesita su propio desplazamiento.
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),

            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.05,

            children: const [
              GalleryItem(
                imageUrl: 'https://images.unsplash.com/photo-1587595431973-160d0d94add1',
                title: 'Vista panorámica',
                semanticLabel: 'Vista panorámica del santuario de Machu Picchu',
              ),

              GalleryItem(
                imageUrl: 'https://images.unsplash.com/photo-1526392060635-9d6019884377',
                title: 'Ciudad Inka',
                semanticLabel: 'Construcciones de piedra de Machu Picchu',
              ),

              GalleryItem(
                imageUrl: 'https://images.unsplash.com/photo-1526392060635-9d6019884377',
                title: 'Arquitectura',
                semanticLabel: 'Arquitectura y construcciones incas',
              ),

              GalleryItem(
                imageUrl: 'https://images.unsplash.com/photo-1587595431973-160d0d94add1',
                title: 'Montañas',
                semanticLabel: 'Montañas que rodean Machu Picchu',
              ),

              GalleryItem(
                imageUrl: 'https://images.unsplash.com/photo-1526392060635-9d6019884377',
                title: 'Terrazas',
                semanticLabel: 'Terrazas agrícolas de Machu Picchu',
              ),

              GalleryItem(
                imageUrl: 'https://images.unsplash.com/photo-1587595431973-160d0d94add1',
                title: 'Paisaje andino',
                semanticLabel: 'Paisaje natural alrededor de Machu Picchu',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Elemento reutilizable de la galería.
class GalleryItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String semanticLabel;

  const GalleryItem({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            semanticLabel: semanticLabel,

            // Imagen alternativa cuando el recurso remoto
            // no se encuentra disponible.
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: const Color(0xFFE8F5E9),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.image_not_supported_outlined,
                  size: 42,
                  color: Color(0xFF1B5E20),
                  semanticLabel: 'Imagen no disponible',
                ),
              );
            },
          ),

          // Degradado para mejorar la legibilidad del título.
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Color.fromARGB(190, 0, 0, 0)],
              ),
            ),
          ),

          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
