class Destino {
  final int? id;
  final String nombre;
  final String descripcion;
  final String categoria;
  final int altitudMsnm;
  final double duracionH;
  final String dificultad;
  final double precio;
  final double? latitud;
  final double? longitud;
  final String? rutaImagen;
  final DateTime creadoEn;

  const Destino({
    this.id,
    required this.nombre,
    required this.descripcion,
    required this.categoria,
    required this.altitudMsnm,
    required this.duracionH,
    required this.dificultad,
    required this.precio,
    this.latitud,
    this.longitud,
    this.rutaImagen,
    required this.creadoEn,
  });

  /// Crea una copia del destino modificando únicamente
  /// los valores enviados.
  Destino copyWith({
    int? id,
    String? nombre,
    String? descripcion,
    String? categoria,
    int? altitudMsnm,
    double? duracionH,
    String? dificultad,
    double? precio,
    double? latitud,
    double? longitud,
    String? rutaImagen,
    DateTime? creadoEn,
  }) {
    return Destino(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      categoria: categoria ?? this.categoria,
      altitudMsnm: altitudMsnm ?? this.altitudMsnm,
      duracionH: duracionH ?? this.duracionH,
      dificultad: dificultad ?? this.dificultad,
      precio: precio ?? this.precio,
      latitud: latitud ?? this.latitud,
      longitud: longitud ?? this.longitud,
      rutaImagen: rutaImagen ?? this.rutaImagen,
      creadoEn: creadoEn ?? this.creadoEn,
    );
  }

  /// Convierte el objeto a un mapa compatible con SQLite.
  Map<String, Object?> toMap() {
    return {
      if (id != null) 'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'categoria': categoria,
      'altitud_msnm': altitudMsnm,
      'duracion_h': duracionH,
      'dificultad': dificultad,
      'precio': precio,
      'latitud': latitud,
      'longitud': longitud,
      'ruta_imagen': rutaImagen,
      'creado_en': creadoEn.toIso8601String(),
    };
  }

  /// Reconstruye un objeto Destino a partir de una fila de SQLite.
  factory Destino.fromMap(Map<String, Object?> map) {
    return Destino(
      id: map['id'] as int?,
      nombre: map['nombre'] as String,
      descripcion: map['descripcion'] as String,
      categoria: map['categoria'] as String,
      altitudMsnm: map['altitud_msnm'] as int,
      duracionH: (map['duracion_h'] as num).toDouble(),
      dificultad: map['dificultad'] as String,
      precio: (map['precio'] as num).toDouble(),
      latitud: (map['latitud'] as num?)?.toDouble(),
      longitud: (map['longitud'] as num?)?.toDouble(),
      rutaImagen: map['ruta_imagen'] as String?,
      creadoEn: DateTime.parse(map['creado_en'] as String),
    );
  }

  @override
  String toString() {
    return 'Destino('
        'id: $id, '
        'nombre: $nombre, '
        'categoria: $categoria, '
        'altitudMsnm: $altitudMsnm, '
        'duracionH: $duracionH, '
        'dificultad: $dificultad, '
        'precio: $precio'
        ')';
  }
}
