import 'package:flutter/material.dart';

import '../models/destino.dart';
import '../services/favoritos_service.dart';

class DestinationHeader extends StatefulWidget {
  final Destino destino;

  const DestinationHeader({super.key, required this.destino});

  @override
  State<DestinationHeader> createState() => _DestinationHeaderState();
}

class _DestinationHeaderState extends State<DestinationHeader> {
  final FavoritosService _favoritosService = FavoritosService();

  bool _esFavorito = false;
  bool _cargandoFavorito = true;

  @override
  void initState() {
    super.initState();
    _cargarFavorito();
  }

  Future<void> _cargarFavorito() async {
    final id = widget.destino.id;

    if (id == null) {
      setState(() {
        _cargandoFavorito = false;
      });
      return;
    }

    final esFavorito = await _favoritosService.esFavorito(id);

    if (!mounted) return;

    setState(() {
      _esFavorito = esFavorito;
      _cargandoFavorito = false;
    });
  }

  Future<void> _alternarFavorito() async {
    final id = widget.destino.id;

    if (id == null || _cargandoFavorito) {
      return;
    }

    setState(() {
      _cargandoFavorito = true;
    });

    final esFavorito = await _favoritosService.alternar(id);

    if (!mounted) return;

    setState(() {
      _esFavorito = esFavorito;
      _cargandoFavorito = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          esFavorito
              ? '${widget.destino.nombre} agregado a favoritos.'
              : '${widget.destino.nombre} eliminado de favoritos.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rutaImagen = widget.destino.rutaImagen;

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
              semanticLabel: 'Imagen de ${widget.destino.nombre}',
              errorBuilder: (context, error, stackTrace) {
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
              label: _esFavorito
                  ? 'Quitar ${widget.destino.nombre} de favoritos'
                  : 'Agregar ${widget.destino.nombre} a favoritos',
              button: true,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.90),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: _cargandoFavorito ? null : _alternarFavorito,
                  icon: Icon(
                    _esFavorito ? Icons.favorite : Icons.favorite_border,
                    color: _esFavorito ? Colors.red : Colors.black87,
                  ),
                  tooltip: _esFavorito
                      ? 'Quitar de favoritos'
                      : 'Agregar a favoritos',
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
                  widget.destino.nombre,
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
                      widget.destino.categoria,
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
