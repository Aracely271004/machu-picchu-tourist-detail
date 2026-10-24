import 'package:sqflite/sqflite.dart';

import '../models/destino.dart';
import 'database_helper.dart';

class DestinoRepository {
  static const String _tabla = 'destinos';

  /// Registra un nuevo destino.
  Future<int> crear(Destino destino) async {
    final db = await DatabaseHelper.bd;

    final valores = destino.toMap()..remove('id');

    return db.insert(
      _tabla,
      valores,
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  /// Lista todos los destinos.
  ///
  /// Si se proporciona una categoría, devuelve únicamente
  /// los destinos pertenecientes a ella.
  Future<List<Destino>> listar({String? categoria}) async {
    final db = await DatabaseHelper.bd;

    final filas = await db.query(
      _tabla,
      where: categoria == null ? null : 'categoria = ?',
      whereArgs: categoria == null ? null : [categoria],
      orderBy: 'nombre COLLATE NOCASE ASC',
    );

    return filas.map(Destino.fromMap).toList();
  }

  /// Busca un destino por su identificador.
  Future<Destino?> obtenerPorId(int id) async {
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

    return Destino.fromMap(filas.first);
  }

  /// Actualiza un destino existente.
  Future<int> actualizar(Destino destino) async {
    final id = destino.id;

    if (id == null) {
      throw ArgumentError('No se puede actualizar un destino sin id.');
    }

    final db = await DatabaseHelper.bd;

    final valores = destino.toMap()..remove('id');

    return db.update(_tabla, valores, where: 'id = ?', whereArgs: [id]);
  }

  /// Elimina un destino por id.
  ///
  /// Las reseñas relacionadas se eliminan automáticamente
  /// por ON DELETE CASCADE.
  Future<int> eliminar(int id) async {
    final db = await DatabaseHelper.bd;

    return db.delete(_tabla, where: 'id = ?', whereArgs: [id]);
  }

  /// Comprueba si ya existe un destino con el mismo nombre.
  ///
  /// [excluirId] permite ignorar el propio registro durante edición.
  Future<bool> existeNombre(String nombre, {int? excluirId}) async {
    final db = await DatabaseHelper.bd;

    late final List<Map<String, Object?>> filas;

    if (excluirId == null) {
      filas = await db.rawQuery(
        '''
        SELECT COUNT(*) AS total
        FROM $_tabla
        WHERE LOWER(nombre) = LOWER(?)
        ''',
        [nombre.trim()],
      );
    } else {
      filas = await db.rawQuery(
        '''
        SELECT COUNT(*) AS total
        FROM $_tabla
        WHERE LOWER(nombre) = LOWER(?)
          AND id <> ?
        ''',
        [nombre.trim(), excluirId],
      );
    }

    final total = Sqflite.firstIntValue(filas) ?? 0;

    return total > 0;
  }
}
