import '../models/resena.dart';
import 'database_helper.dart';

class ResenaRepository {
  static const String _tabla = 'resenas';

  /// Registra una nueva reseña.
  Future<int> crear(Resena resena) async {
    final db = await DatabaseHelper.bd;

    final valores = resena.toMap()..remove('id');

    return db.insert(_tabla, valores);
  }

  /// Lista todas las reseñas de un destino.
  Future<List<Resena>> listarPorDestino(int destinoId) async {
    final db = await DatabaseHelper.bd;

    final filas = await db.query(
      _tabla,
      where: 'destino_id = ?',
      whereArgs: [destinoId],
      orderBy: 'fecha DESC',
    );

    return filas.map(Resena.fromMap).toList();
  }

  /// Busca una reseña por su identificador.
  Future<Resena?> obtenerPorId(int id) async {
    final db = await DatabaseHelper.bd;

    final filas = await db.query(
      _tabla,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (filas.isEmpty) {
      return null;
    }

    return Resena.fromMap(filas.first);
  }

  /// Actualiza una reseña existente.
  Future<int> actualizar(Resena resena) async {
    final id = resena.id;

    if (id == null) {
      throw ArgumentError('No se puede actualizar una reseña sin id.');
    }

    final db = await DatabaseHelper.bd;

    final valores = resena.toMap()..remove('id');

    return db.update(_tabla, valores, where: 'id = ?', whereArgs: [id]);
  }

  /// Elimina una reseña.
  Future<int> eliminar(int id) async {
    final db = await DatabaseHelper.bd;

    return db.delete(_tabla, where: 'id = ?', whereArgs: [id]);
  }

  /// Comprueba si un autor ya publicó una reseña
  /// para el mismo destino.
  Future<bool> existeResenaDeAutor({
    required int destinoId,
    required String autor,
  }) async {
    final db = await DatabaseHelper.bd;

    final filas = await db.rawQuery(
      '''
      SELECT COUNT(*) AS total
      FROM $_tabla
      WHERE destino_id = ?
        AND LOWER(TRIM(autor)) = LOWER(TRIM(?))
      ''',
      [destinoId, autor.trim()],
    );

    final total = (filas.first['total'] as num?)?.toInt() ?? 0;

    return total > 0;
  }

  /// Calcula el promedio de calificaciones
  /// de todas las reseñas de un destino.
  Future<double> promedioCalificacion(int destinoId) async {
    final db = await DatabaseHelper.bd;

    final filas = await db.rawQuery(
      '''
      SELECT AVG(calificacion) AS promedio
      FROM $_tabla
      WHERE destino_id = ?
      ''',
      [destinoId],
    );

    return (filas.first['promedio'] as num?)?.toDouble() ?? 0.0;
  }

  /// Devuelve la cantidad de reseñas existentes
  /// para un destino.
  Future<int> cantidadPorDestino(int destinoId) async {
    final db = await DatabaseHelper.bd;

    final filas = await db.rawQuery(
      '''
      SELECT COUNT(*) AS total
      FROM $_tabla
      WHERE destino_id = ?
      ''',
      [destinoId],
    );

    return (filas.first['total'] as num?)?.toInt() ?? 0;
  }
}
