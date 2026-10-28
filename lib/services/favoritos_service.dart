import 'package:shared_preferences/shared_preferences.dart';

class FavoritosService {
  static const String _clave = 'destinos_favoritos';

  Future<Set<int>> obtenerIds() async {
    final prefs = await SharedPreferences.getInstance();

    final valores = prefs.getStringList(_clave) ?? <String>[];

    return valores.map(int.tryParse).whereType<int>().toSet();
  }

  Future<bool> esFavorito(int destinoId) async {
    final favoritos = await obtenerIds();
    return favoritos.contains(destinoId);
  }

  Future<bool> alternar(int destinoId) async {
    final prefs = await SharedPreferences.getInstance();
    final favoritos = await obtenerIds();

    final bool ahoraEsFavorito;

    if (favoritos.contains(destinoId)) {
      favoritos.remove(destinoId);
      ahoraEsFavorito = false;
    } else {
      favoritos.add(destinoId);
      ahoraEsFavorito = true;
    }

    final valores = favoritos.map((id) => id.toString()).toList()..sort();

    await prefs.setStringList(_clave, valores);

    return ahoraEsFavorito;
  }

  Future<void> eliminar(int destinoId) async {
    final prefs = await SharedPreferences.getInstance();
    final favoritos = await obtenerIds();

    favoritos.remove(destinoId);

    await prefs.setStringList(
      _clave,
      favoritos.map((id) => id.toString()).toList(),
    );
  }
}
