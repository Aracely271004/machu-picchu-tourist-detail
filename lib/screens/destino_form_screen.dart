import 'package:flutter/material.dart';

import '../data/destino_repository.dart';
import '../models/destino.dart';

class DestinoFormScreen extends StatefulWidget {
  final Destino? destino;

  const DestinoFormScreen({super.key, this.destino});

  @override
  State<DestinoFormScreen> createState() => _DestinoFormScreenState();
}

class _DestinoFormScreenState extends State<DestinoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final DestinoRepository _repository = DestinoRepository();

  late final TextEditingController _nombreController;
  late final TextEditingController _descripcionController;
  late final TextEditingController _altitudController;
  late final TextEditingController _duracionController;
  late final TextEditingController _precioController;
  late final TextEditingController _latitudController;
  late final TextEditingController _longitudController;
  late final TextEditingController _imagenController;

  String _categoria = 'Arqueológico';
  String _dificultad = 'Moderada';

  bool _guardando = false;
  String? _errorNombreAsync;

  static const List<String> _categorias = [
    'Arqueológico',
    'Trekking',
    'Cultural',
    'Gastronómico',
  ];

  static const List<String> _dificultades = ['Fácil', 'Moderada', 'Difícil'];

  bool get _editando => widget.destino != null;

  @override
  void initState() {
    super.initState();

    final destino = widget.destino;

    _nombreController = TextEditingController(text: destino?.nombre ?? '');

    _descripcionController = TextEditingController(
      text: destino?.descripcion ?? '',
    );

    _altitudController = TextEditingController(
      text: destino?.altitudMsnm.toString() ?? '',
    );

    _duracionController = TextEditingController(
      text: destino?.duracionH.toString() ?? '',
    );

    _precioController = TextEditingController(
      text: destino?.precio.toString() ?? '',
    );

    _latitudController = TextEditingController(
      text: destino?.latitud?.toString() ?? '',
    );

    _longitudController = TextEditingController(
      text: destino?.longitud?.toString() ?? '',
    );

    _imagenController = TextEditingController(text: destino?.rutaImagen ?? '');

    if (destino != null) {
      _categoria = destino.categoria;
      _dificultad = destino.dificultad;
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _altitudController.dispose();
    _duracionController.dispose();
    _precioController.dispose();
    _latitudController.dispose();
    _longitudController.dispose();
    _imagenController.dispose();

    super.dispose();
  }

  Future<void> _guardar() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _errorNombreAsync = null;
    });

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _guardando = true;
    });

    final nombre = _nombreController.text.trim();

    final existe = await _repository.existeNombre(
      nombre,
      excluirId: widget.destino?.id,
    );

    if (!mounted) return;

    if (existe) {
      setState(() {
        _guardando = false;
        _errorNombreAsync = 'Ya existe un destino registrado con ese nombre.';
      });
      return;
    }

    final destino = Destino(
      id: widget.destino?.id,
      nombre: nombre,
      descripcion: _descripcionController.text.trim(),
      categoria: _categoria,
      altitudMsnm: int.parse(_altitudController.text.trim()),
      duracionH: double.parse(_duracionController.text.trim()),
      dificultad: _dificultad,
      precio: double.parse(_precioController.text.trim()),
      latitud: _latitudController.text.trim().isEmpty
          ? null
          : double.parse(_latitudController.text.trim()),
      longitud: _longitudController.text.trim().isEmpty
          ? null
          : double.parse(_longitudController.text.trim()),
      rutaImagen: _imagenController.text.trim().isEmpty
          ? null
          : _imagenController.text.trim(),
      creadoEn: widget.destino?.creadoEn ?? DateTime.now(),
    );

    try {
      if (_editando) {
        await _repository.actualizar(destino);
      } else {
        await _repository.crear(destino);
      }

      if (!mounted) return;

      Navigator.pop(context, destino);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _guardando = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo guardar el destino: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editando ? 'Editar destino' : 'Nuevo destino'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  border: const OutlineInputBorder(),
                  errorText: _errorNombreAsync,
                ),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  final texto = value?.trim() ?? '';

                  if (texto.isEmpty) {
                    return 'El nombre es obligatorio.';
                  }

                  if (texto.length < 4) {
                    return 'Debe tener al menos 4 caracteres.';
                  }

                  if (texto.length > 80) {
                    return 'No debe superar 80 caracteres.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _descripcionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  final texto = value?.trim() ?? '';

                  if (texto.isEmpty) {
                    return 'La descripción es obligatoria.';
                  }

                  if (texto.length < 20) {
                    return 'Debe tener al menos 20 caracteres.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                initialValue: _categoria,
                decoration: const InputDecoration(
                  labelText: 'Categoría',
                  border: OutlineInputBorder(),
                ),
                items: _categorias
                    .map(
                      (categoria) => DropdownMenuItem(
                        value: categoria,
                        child: Text(categoria),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _categoria = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _altitudController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Altitud (msnm)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final altitud = int.tryParse(value?.trim() ?? '');

                  if (altitud == null) {
                    return 'Ingrese una altitud válida.';
                  }

                  if (altitud < 0 || altitud > 7000) {
                    return 'Debe estar entre 0 y 7000 msnm.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _duracionController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Duración (horas)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final duracion = double.tryParse(value?.trim() ?? '');

                  if (duracion == null) {
                    return 'Ingrese una duración válida.';
                  }

                  if (duracion <= 0) {
                    return 'La duración debe ser mayor a 0.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                initialValue: _dificultad,
                decoration: const InputDecoration(
                  labelText: 'Dificultad',
                  border: OutlineInputBorder(),
                ),
                items: _dificultades
                    .map(
                      (dificultad) => DropdownMenuItem(
                        value: dificultad,
                        child: Text(dificultad),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _dificultad = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _precioController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Precio (S/)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final precio = double.tryParse(value?.trim() ?? '');

                  if (precio == null) {
                    return 'Ingrese un precio válido.';
                  }

                  if (precio < 0) {
                    return 'El precio no puede ser negativo.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _latitudController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Latitud',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final texto = value?.trim() ?? '';

                  if (texto.isEmpty) return null;

                  final latitud = double.tryParse(texto);

                  if (latitud == null) {
                    return 'Ingrese una latitud válida.';
                  }

                  if (latitud < -90 || latitud > 90) {
                    return 'Debe estar entre -90 y 90.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _longitudController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Longitud',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final texto = value?.trim() ?? '';

                  if (texto.isEmpty) return null;

                  final longitud = double.tryParse(texto);

                  if (longitud == null) {
                    return 'Ingrese una longitud válida.';
                  }

                  if (longitud < -180 || longitud > 180) {
                    return 'Debe estar entre -180 y 180.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _imagenController,
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(
                  labelText: 'URL de imagen',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final texto = value?.trim() ?? '';

                  if (texto.isEmpty) return null;

                  final uri = Uri.tryParse(texto);

                  if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
                    return 'Ingrese una URL válida.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 24),

              FilledButton.icon(
                onPressed: _guardando ? null : _guardar,
                icon: _guardando
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save_outlined),
                label: Text(_guardando ? 'Guardando...' : 'Guardar destino'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
