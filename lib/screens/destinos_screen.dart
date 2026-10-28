import 'package:flutter/material.dart';

import '../utils/app_routes.dart';
import '../utils/route_args.dart';
import '../data/destino_repository.dart';
import '../models/destino.dart';

class DestinosScreen extends StatefulWidget {
  const DestinosScreen({super.key});

  @override
  State<DestinosScreen> createState() => _DestinosScreenState();
}

class _DestinosScreenState extends State<DestinosScreen> {
  final DestinoRepository _repository = DestinoRepository();

  late Future<List<Destino>> _futuroDestinos;

  String _categoriaSeleccionada = 'Todos';

  static const List<String> _categorias = [
    'Todos',
    'Arqueológico',
    'Trekking',
    'Cultural',
    'Gastronómico',
  ];

  @override
  void initState() {
    super.initState();
    _cargarDestinos();
  }

  void _cargarDestinos() {
    _futuroDestinos = _repository.listar(
      categoria: _categoriaSeleccionada == 'Todos'
          ? null
          : _categoriaSeleccionada,
    );
  }

  void _cambiarCategoria(String categoria) {
    setState(() {
      _categoriaSeleccionada = categoria;
      _cargarDestinos();
    });
  }

  void _recargar() {
    setState(() {
      _cargarDestinos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8FF),
      appBar: AppBar(
        title: const Text(
          'Destinos turísticos',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFFFF8FF),
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _construirFiltros(),
            Expanded(
              child: FutureBuilder<List<Destino>>(
                future: _futuroDestinos,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const _EstadoCarga();
                  }

                  if (snapshot.hasError) {
                    return _EstadoError(
                      mensaje: snapshot.error.toString(),
                      onReintentar: _recargar,
                    );
                  }

                  final destinos = snapshot.data ?? <Destino>[];

                  if (destinos.isEmpty) {
                    return _EstadoVacio(categoria: _categoriaSeleccionada);
                  }

                  return _ListaDestinos(
                    destinos: destinos,
                    onActualizar: _recargar,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _construirFiltros() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: _categorias.map((categoria) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(categoria),
              selected: categoria == _categoriaSeleccionada,
              onSelected: (_) {
                _cambiarCategoria(categoria);
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ListaDestinos extends StatelessWidget {
  final List<Destino> destinos;
  final VoidCallback onActualizar;

  const _ListaDestinos({required this.destinos, required this.onActualizar});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: destinos.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _DestinoCard(
          destino: destinos[index],
          onActualizar: onActualizar,
        );
      },
    );
  }
}

class _DestinoCard extends StatelessWidget {
  final Destino destino;
  final VoidCallback onActualizar;

  const _DestinoCard({required this.destino, required this.onActualizar});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () async {
          final cambios = await Navigator.pushNamed<bool>(
            context,
            AppRoutes.destinoDetalle,
            arguments: DestinoDetalleArgs(destino: destino),
          );

          if (cambios == true) {
            onActualizar();
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: 190,
              child: _ImagenDestino(destino: destino),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    destino.nombre,
                    style: Theme.of(context).textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    destino.categoria,
                    style: const TextStyle(
                      color: Color(0xFF1B6B2A),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 16,
                    runSpacing: 10,
                    children: [
                      _DatoDestino(
                        icono: Icons.terrain,
                        texto: '${destino.altitudMsnm} m',
                      ),
                      _DatoDestino(
                        icono: Icons.directions_walk,
                        texto: destino.dificultad,
                      ),
                      _DatoDestino(
                        icono: Icons.schedule,
                        texto: '${destino.duracionH.toStringAsFixed(0)} h',
                      ),
                      _DatoDestino(
                        icono: Icons.payments_outlined,
                        texto: 'S/ ${destino.precio.toStringAsFixed(0)}',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImagenDestino extends StatelessWidget {
  final Destino destino;

  const _ImagenDestino({required this.destino});

  @override
  Widget build(BuildContext context) {
    final ruta = destino.rutaImagen;

    if (ruta == null || ruta.isEmpty) {
      return _placeholder();
    }

    return Image.network(
      ruta,
      fit: BoxFit.cover,
      semanticLabel: 'Imagen de ${destino.nombre}',
      errorBuilder: (_, _, _) {
        return _placeholder();
      },
    );
  }

  Widget _placeholder() {
    return Container(
      color: const Color(0xFFE8F5E9),
      alignment: Alignment.center,
      child: const Icon(Icons.landscape, size: 60, color: Color(0xFF1B6B2A)),
    );
  }
}

class _DatoDestino extends StatelessWidget {
  final IconData icono;
  final String texto;

  const _DatoDestino({required this.icono, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icono, size: 18, color: const Color(0xFF1B6B2A)),
        const SizedBox(width: 5),
        Text(texto),
      ],
    );
  }
}

class _EstadoCarga extends StatelessWidget {
  const _EstadoCarga();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Cargando destinos...'),
        ],
      ),
    );
  }
}

class _EstadoError extends StatelessWidget {
  final String mensaje;
  final VoidCallback onReintentar;

  const _EstadoError({required this.mensaje, required this.onReintentar});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 56, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'No se pudieron cargar los destinos.',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(mensaje, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onReintentar,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EstadoVacio extends StatelessWidget {
  final String categoria;

  const _EstadoVacio({required this.categoria});

  @override
  Widget build(BuildContext context) {
    final mensaje = categoria == 'Todos'
        ? 'No hay destinos registrados.'
        : 'No hay destinos en la categoría $categoria.';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.travel_explore,
              size: 60,
              color: Color(0xFF1B6B2A),
            ),
            const SizedBox(height: 16),
            Text(
              mensaje,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
