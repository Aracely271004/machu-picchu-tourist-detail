import 'package:flutter/material.dart';

import '../models/destino.dart';

class DestinationHeader extends StatelessWidget {
  final Destino destino;

  const DestinationHeader({super.key, required this.destino});

  @override
  Widget build(BuildContext context) {
    final rutaImagen = destino.rutaImagen;

    return SizedBox(
      height: 420,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (rutaImagen != null && rutaImagen.isNotEmpty)
            Image.network(
              rutaImagen,
              fit: BoxFit.cover,
              semanticLabel: 'Imagen de ${destino.nombre}',
              errorBuilder: (_, _, _) {
                return _imagenRespaldo();
              },
            )
          else
            _imagenRespaldo(),

          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Color.fromARGB(200, 0, 0, 0)],
              ),
            ),
          ),

          Positioned(
            top: 24,
            right: 24,
            child: Semantics(
              label: 'Agregar ${destino.nombre} a favoritos',
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

          Positioned(
            left: 24,
            right: 24,
            bottom: 28,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  destino.nombre,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.category_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      destino.categoria,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
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

  Widget _imagenRespaldo() {
    return Container(
      color: const Color(0xFF2E5D3B),
      alignment: Alignment.center,
      child: const Icon(
        Icons.landscape_outlined,
        size: 80,
        color: Colors.white70,
      ),
    );
  }
}
