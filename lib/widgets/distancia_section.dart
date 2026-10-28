import 'package:flutter/material.dart';

import '../models/destino.dart';
import '../services/ubicacion_service.dart';

class DistanciaSection extends StatefulWidget {
  final Destino destino;

  const DistanciaSection({super.key, required this.destino});

  @override
  State<DistanciaSection> createState() => _DistanciaSectionState();
}

class _DistanciaSectionState extends State<DistanciaSection> {
  final UbicacionService _ubicacionService = UbicacionService();

  bool _cargando = false;
  double? _distanciaKm;
  EstadoUbicacion? _estado;
  String? _mensaje;

  @override
  void initState() {
    super.initState();
    _obtenerDistancia();
  }

  Future<void> _obtenerDistancia() async {
    final latitudDestino = widget.destino.latitud;
    final longitudDestino = widget.destino.longitud;

    if (latitudDestino == null || longitudDestino == null) {
      setState(() {
        _mensaje = 'Este destino no tiene coordenadas registradas.';
        _estado = EstadoUbicacion.error;
      });
      return;
    }

    setState(() {
      _cargando = true;
      _mensaje = null;
    });

    final resultado = await _ubicacionService.obtenerUbicacionActual();

    if (!mounted) {
      return;
    }

    if (resultado.estado == EstadoUbicacion.disponible &&
        resultado.posicion != null) {
      final posicion = resultado.posicion!;

      final distancia = _ubicacionService.calcularDistanciaKm(
        latitudActual: posicion.latitude,
        longitudActual: posicion.longitude,
        latitudDestino: latitudDestino,
        longitudDestino: longitudDestino,
      );

      setState(() {
        _cargando = false;
        _estado = EstadoUbicacion.disponible;
        _distanciaKm = distancia;
        _mensaje = null;
      });

      return;
    }

    setState(() {
      _cargando = false;
      _estado = resultado.estado;
      _mensaje = resultado.mensaje;
      _distanciaKm = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Card(
        child: Padding(padding: const EdgeInsets.all(20), child: _contenido()),
      ),
    );
  }

  Widget _contenido() {
    if (_cargando) {
      return const Row(
        children: [
          SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
          SizedBox(width: 16),
          Expanded(child: Text('Calculando distancia desde tu ubicación...')),
        ],
      );
    }

    if (_distanciaKm != null) {
      return Row(
        children: [
          const Icon(
            Icons.near_me_outlined,
            size: 40,
            color: Color(0xFF1B6B2A),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Distancia desde tu ubicación',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  '${_distanciaKm!.toStringAsFixed(1)} km',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B6B2A),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Distancia aproximada en línea recta.',
                  style: TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Actualizar ubicación',
            onPressed: _obtenerDistancia,
            icon: const Icon(Icons.refresh),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.location_off_outlined, size: 36),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Distancia no disponible',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Text(_mensaje ?? 'No fue posible obtener la ubicación.'),

        const SizedBox(height: 16),

        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            FilledButton.icon(
              onPressed: _obtenerDistancia,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),

            if (_estado == EstadoUbicacion.permisoPermanenteDenegado)
              OutlinedButton.icon(
                onPressed: () {
                  _ubicacionService.abrirConfiguracionApp();
                },
                icon: const Icon(Icons.settings),
                label: const Text('Abrir configuración'),
              ),

            if (_estado == EstadoUbicacion.servicioDesactivado)
              OutlinedButton.icon(
                onPressed: () {
                  _ubicacionService.abrirConfiguracionUbicacion();
                },
                icon: const Icon(Icons.location_on_outlined),
                label: const Text('Activar ubicación'),
              ),
          ],
        ),
      ],
    );
  }
}
