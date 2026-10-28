import 'package:flutter/material.dart';

import '../data/resena_repository.dart';
import '../models/resena.dart';
import '../utils/app_routes.dart';
import '../utils/route_args.dart';

class ResenasSection extends StatefulWidget {
  final int destinoId;

  const ResenasSection({super.key, required this.destinoId});

  @override
  State<ResenasSection> createState() => _ResenasSectionState();
}

class _ResenasSectionState extends State<ResenasSection> {
  final ResenaRepository _repository = ResenaRepository();

  late Future<List<Resena>> _futuroResenas;
  late Future<double> _futuroPromedio;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  void _cargarDatos() {
    _futuroResenas = _repository.listarPorDestino(widget.destinoId);

    _futuroPromedio = _repository.promedioCalificacion(widget.destinoId);
  }

  void _recargar() {
    setState(() {
      _cargarDatos();
    });
  }

  Future<void> _crearResena() async {
    final resena = await Navigator.pushNamed<Resena>(
      context,
      AppRoutes.resenaFormulario,
      arguments: ResenaFormArgs(destinoId: widget.destinoId),
    );

    if (!mounted) {
      return;
    }

    if (resena != null) {
      _recargar();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reseña publicada correctamente.')),
      );
    }
  }

  String _formatearFecha(DateTime fecha) {
    final dia = fecha.day.toString().padLeft(2, '0');
    final mes = fecha.month.toString().padLeft(2, '0');
    final anio = fecha.year.toString();

    return '$dia/$mes/$anio';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Reseñas',
                  style: Theme.of(context).textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              FilledButton.icon(
                onPressed: _crearResena,
                icon: const Icon(Icons.rate_review_outlined),
                label: const Text('Escribir reseña'),
              ),
            ],
          ),

          const SizedBox(height: 20),

          FutureBuilder<double>(
            future: _futuroPromedio,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LinearProgressIndicator();
              }

              if (snapshot.hasError) {
                return const Text('No se pudo calcular el promedio.');
              }

              final promedio = snapshot.data ?? 0.0;

              return FutureBuilder<List<Resena>>(
                future: _futuroResenas,
                builder: (context, resenasSnapshot) {
                  final cantidad = resenasSnapshot.data?.length ?? 0;

                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Icon(Icons.star, size: 36, color: Colors.amber),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cantidad == 0
                                    ? 'Sin calificaciones'
                                    : '${promedio.toStringAsFixed(1)} / 5',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                cantidad == 1
                                    ? '1 reseña'
                                    : '$cantidad reseñas',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),

          const SizedBox(height: 16),

          FutureBuilder<List<Resena>>(
            future: _futuroResenas,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (snapshot.hasError) {
                return const Center(
                  child: Text('No se pudieron cargar las reseñas.'),
                );
              }

              final resenas = snapshot.data ?? <Resena>[];

              if (resenas.isEmpty) {
                return const Card(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.rate_review_outlined, size: 48),
                          SizedBox(height: 12),
                          Text(
                            'Todavía no hay reseñas para este destino.',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              return Column(
                children: resenas.map((resena) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const CircleAvatar(
                                  child: Icon(Icons.person_outline),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        resena.autor,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        _formatearFecha(resena.fecha),
                                        style: const TextStyle(
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${resena.calificacion}/5',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Text(resena.comentario),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
