import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const String _nombreDb = 'machu_picchu.db';
  static const int _versionDb = 1;

  static Database? _database;

  DatabaseHelper._();

  /// Devuelve una única instancia abierta de la base de datos.
  static Future<Database> get bd async {
    if (_database != null) {
      return _database!;
    }

    _database = await _abrir();
    return _database!;
  }

  /// Abre la base de datos y crea su estructura si es la primera ejecución.
  static Future<Database> _abrir() async {
    final String ruta = p.join(await getDatabasesPath(), _nombreDb);

    return openDatabase(
      ruta,
      version: _versionDb,

      /// SQLite no activa claves foráneas automáticamente.
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },

      onCreate: (db, version) async {
        await _crearTablas(db);
        await _insertarDatosIniciales(db);
      },

      /// Se utilizará cuando el esquema cambie en futuras versiones.
      onUpgrade: (db, versionAnterior, versionNueva) async {
        // Versión 1: todavía no existen migraciones.
      },
    );
  }

  static Future<void> _crearTablas(Database db) async {
    await db.execute('''
      CREATE TABLE destinos (
        id            INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre        TEXT    NOT NULL UNIQUE,
        descripcion   TEXT    NOT NULL,
        categoria     TEXT    NOT NULL,
        altitud_msnm  INTEGER NOT NULL
                               CHECK (altitud_msnm BETWEEN 0 AND 7000),
        duracion_h    REAL    NOT NULL
                               CHECK (duracion_h > 0),
        dificultad    TEXT    NOT NULL
                               CHECK (
                                 dificultad IN (
                                   'Fácil',
                                   'Moderada',
                                   'Difícil'
                                 )
                               ),
        precio        REAL    NOT NULL DEFAULT 0
                               CHECK (precio >= 0),
        latitud       REAL
                               CHECK (
                                 latitud IS NULL OR
                                 latitud BETWEEN -90 AND 90
                               ),
        longitud      REAL
                               CHECK (
                                 longitud IS NULL OR
                                 longitud BETWEEN -180 AND 180
                               ),
        ruta_imagen   TEXT,
        creado_en     TEXT    NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE resenas (
        id            INTEGER PRIMARY KEY AUTOINCREMENT,
        destino_id    INTEGER NOT NULL,
        autor         TEXT    NOT NULL,
        calificacion  INTEGER NOT NULL
                               CHECK (calificacion BETWEEN 1 AND 5),
        comentario    TEXT    NOT NULL,
        fecha         TEXT    NOT NULL,

        FOREIGN KEY (destino_id)
          REFERENCES destinos(id)
          ON DELETE CASCADE
      )
    ''');

    await db.execute(
      'CREATE INDEX idx_resenas_destino '
      'ON resenas(destino_id)',
    );
  }

  /// Carga inicial para que la aplicación no se abra vacía
  /// en su primera ejecución.
  static Future<void> _insertarDatosIniciales(Database db) async {
    await db.insert('destinos', {
      'nombre': 'Machu Picchu',
      'descripcion':
          'Santuario histórico ubicado en Cusco. '
          'Destaca por su arquitectura inca, terrazas, '
          'paisaje montañoso y valor cultural.',
      'categoria': 'Arqueológico',
      'altitud_msnm': 2445,
      'duracion_h': 8.0,
      'dificultad': 'Moderada',
      'precio': 152.0,
      'latitud': -13.1631,
      'longitud': -72.5450,
      'ruta_imagen':
          'https://images.unsplash.com/'
          'photo-1587595431973-160d0d94add1',
      'creado_en': DateTime.now().toIso8601String(),
    });
  }

  /// Cierra la conexión activa.
  static Future<void> cerrar() async {
    final db = _database;

    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
