import 'package:flutter/material.dart';

import '../data/destino_repository.dart';
import '../models/destino.dart';
import '../services/favoritos_service.dart';
import '../utils/app_routes.dart';
import '../utils/route_args.dart';

class FavoritosScreen extends StatefulWidget {
  const FavoritosScreen({super.key});

  @override
  State<FavoritosScreen> createState() => _FavoritosScreenState();
}

class _FavoritosScreenState extends State<FavoritosScreen> {
  final DestinoRepository _destinoRepository = DestinoRepository();

  final FavoritosService _favoritosService = FavoritosService();

  late Future<List<Destino>> _futuroFavoritos;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  void _cargar() {
    _futuroFavoritos = _obtenerFavoritos();
  }

  Future<List<Destino>> _obtenerFavoritos() async {
    final ids = await _favoritosService.obtenerIds();

    final destinos = await _destinoRepository.listar();

    return destinos
        .where((destino) => destino.id != null && ids.contains(destino.id))
        .toList();
  }

  void _recargar() {
    setState(() {
      _cargar();
    });
  }

  Future<void> _abrirDestino(Destino destino) async {
    await Navigator.pushNamed<bool>(
      context,
      AppRoutes.destinoDetalle,
      arguments: DestinoDetalleArgs(destino: destino),
    );

    if (!mounted) return;

    _recargar();
  }

  Future<void> _quitarFavorito(Destino destino) async {
    final id = destino.id;

    if (id == null) return;

    await _favoritosService.eliminar(id);

    if (!mounted) return;

    _recargar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${destino.nombre} eliminado de favoritos.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favoritos')),
      body: FutureBuilder<List<Destino>>(
        future: _futuroFavoritos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 52),
                    const SizedBox(height: 16),
                    const Text('No se pudieron cargar los favoritos.'),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: _recargar,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            );
          }

          final favoritos = snapshot.data ?? <Destino>[];

          if (favoritos.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.favorite_border, size: 64),
                    SizedBox(height: 16),
                    Text(
                      'Todavía no tienes destinos favoritos.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: favoritos.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final destino = favoritos[index];

              return Card(
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {
                    _abrirDestino(destino);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                destino.nombre,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                destino.categoria,
                                style: const TextStyle(
                                  color: Color(0xFF1B6B2A),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${destino.altitudMsnm} m · '
                                '${destino.dificultad}',
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            _quitarFavorito(destino);
                          },
                          tooltip: 'Quitar de favoritos',
                          icon: const Icon(Icons.favorite, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
