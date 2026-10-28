import '../models/destino.dart';

class DestinoDetalleArgs {
  final Destino destino;

  const DestinoDetalleArgs({required this.destino});
}

class DestinoFormArgs {
  final Destino? destino;

  const DestinoFormArgs({this.destino});
}

class ResenaFormArgs {
  final int destinoId;

  const ResenaFormArgs({required this.destinoId});
}
