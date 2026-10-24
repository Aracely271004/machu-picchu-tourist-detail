class Resena {
  final int? id;
  final int destinoId;
  final String autor;
  final int calificacion;
  final String comentario;
  final DateTime fecha;

  const Resena({
    this.id,
    required this.destinoId,
    required this.autor,
    required this.calificacion,
    required this.comentario,
    required this.fecha,
  });

  /// Crea una copia de la reseña modificando únicamente
  /// los valores proporcionados.
  Resena copyWith({
    int? id,
    int? destinoId,
    String? autor,
    int? calificacion,
    String? comentario,
    DateTime? fecha,
  }) {
    return Resena(
      id: id ?? this.id,
      destinoId: destinoId ?? this.destinoId,
      autor: autor ?? this.autor,
      calificacion: calificacion ?? this.calificacion,
      comentario: comentario ?? this.comentario,
      fecha: fecha ?? this.fecha,
    );
  }

  /// Convierte la reseña a un mapa compatible con SQLite.
  Map<String, Object?> toMap() {
    return {
      if (id != null) 'id': id,
      'destino_id': destinoId,
      'autor': autor,
      'calificacion': calificacion,
      'comentario': comentario,
      'fecha': fecha.toIso8601String(),
    };
  }

  /// Reconstruye una reseña a partir de una fila de SQLite.
  factory Resena.fromMap(Map<String, Object?> map) {
    return Resena(
      id: map['id'] as int?,
      destinoId: map['destino_id'] as int,
      autor: map['autor'] as String,
      calificacion: map['calificacion'] as int,
      comentario: map['comentario'] as String,
      fecha: DateTime.parse(map['fecha'] as String),
    );
  }

  @override
  String toString() {
    return 'Resena('
        'id: $id, '
        'destinoId: $destinoId, '
        'autor: $autor, '
        'calificacion: $calificacion, '
        'fecha: $fecha'
        ')';
  }
}
