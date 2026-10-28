import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

enum EstadoUbicacion {
  disponible,
  servicioDesactivado,
  permisoDenegado,
  permisoPermanenteDenegado,
  error,
}

class ResultadoUbicacion {
  final EstadoUbicacion estado;
  final Position? posicion;
  final String mensaje;

  const ResultadoUbicacion({
    required this.estado,
    this.posicion,
    required this.mensaje,
  });
}

class UbicacionService {
  Future<ResultadoUbicacion> obtenerUbicacionActual() async {
    try {
      final servicioActivo = await Geolocator.isLocationServiceEnabled();

      if (!servicioActivo) {
        return const ResultadoUbicacion(
          estado: EstadoUbicacion.servicioDesactivado,
          mensaje: 'El servicio de ubicación está desactivado.',
        );
      }

      var permiso = await Permission.locationWhenInUse.status;

      if (permiso.isDenied) {
        permiso = await Permission.locationWhenInUse.request();
      }

      if (permiso.isPermanentlyDenied) {
        return const ResultadoUbicacion(
          estado: EstadoUbicacion.permisoPermanenteDenegado,
          mensaje: 'El permiso de ubicación fue denegado permanentemente.',
        );
      }

      if (!permiso.isGranted) {
        return const ResultadoUbicacion(
          estado: EstadoUbicacion.permisoDenegado,
          mensaje: 'No se concedió permiso para acceder a la ubicación.',
        );
      }

      const settings = LocationSettings(accuracy: LocationAccuracy.high);

      final posicion = await Geolocator.getCurrentPosition(
        locationSettings: settings,
      ).timeout(const Duration(seconds: 15));

      return ResultadoUbicacion(
        estado: EstadoUbicacion.disponible,
        posicion: posicion,
        mensaje: 'Ubicación obtenida correctamente.',
      );
    } on TimeoutException {
      return const ResultadoUbicacion(
        estado: EstadoUbicacion.error,
        mensaje: 'No fue posible obtener la ubicación a tiempo.',
      );
    } catch (e) {
      return ResultadoUbicacion(
        estado: EstadoUbicacion.error,
        mensaje: 'No se pudo obtener la ubicación: $e',
      );
    }
  }

  double calcularDistanciaKm({
    required double latitudActual,
    required double longitudActual,
    required double latitudDestino,
    required double longitudDestino,
  }) {
    final distanciaMetros = Geolocator.distanceBetween(
      latitudActual,
      longitudActual,
      latitudDestino,
      longitudDestino,
    );

    return distanciaMetros / 1000;
  }

  Future<void> abrirConfiguracionApp() async {
    await openAppSettings();
  }

  Future<void> abrirConfiguracionUbicacion() async {
    await Geolocator.openLocationSettings();
  }
}
