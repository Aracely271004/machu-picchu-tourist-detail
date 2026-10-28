import 'package:flutter/material.dart';

import '../data/destino_repository.dart';
import '../data/resena_repository.dart';
import '../models/destino.dart';
import '../models/resena.dart';

class ResenaFormScreen extends StatefulWidget {
  final int destinoId;

  const ResenaFormScreen({super.key, required this.destinoId});

  @override
  State<ResenaFormScreen> createState() => _ResenaFormScreenState();
}

class _ResenaFormScreenState extends State<ResenaFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final DestinoRepository _destinoRepository = DestinoRepository();
  final ResenaRepository _resenaRepository = ResenaRepository();

  final TextEditingController _autorController = TextEditingController();
  final TextEditingController _comentarioController = TextEditingController();

  late Future<List<Destino>> _futuroDestinos;

  int? _destinoSeleccionado;
  int _calificacion = 5;
  DateTime _fecha = DateTime.now();

  bool _guardando = false;
  String? _errorDuplicado;

  @override
  void initState() {
    super.initState();

    _destinoSeleccionado = widget.destinoId;
    _futuroDestinos = _destinoRepository.listar();
  }

  @override
  void dispose() {
    _autorController.dispose();
    _comentarioController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarFecha() async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: _fecha,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (fecha != null) {
      setState(() {
        _fecha = fecha;
      });
    }
  }

  Future<void> _guardar() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _errorDuplicado = null;
    });

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final destinoId = _destinoSeleccionado;

    if (destinoId == null) {
      return;
    }

    setState(() {
      _guardando = true;
    });

    final autor = _autorController.text.trim();

    final existe = await _resenaRepository.existeResenaDeAutor(
      destinoId: destinoId,
      autor: autor,
    );

    if (!mounted) {
      return;
    }

    if (existe) {
      setState(() {
        _guardando = false;
        _errorDuplicado =
            'Este autor ya publicó una reseña para el destino seleccionado.';
      });

      return;
    }

    final resena = Resena(
      destinoId: destinoId,
      autor: autor,
      calificacion: _calificacion,
      comentario: _comentarioController.text.trim(),
      fecha: _fecha,
    );

    try {
      await _resenaRepository.crear(resena);

      if (!mounted) {
        return;
      }

      Navigator.pop(context, resena);
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _guardando = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo guardar la reseña: $e')),
      );
    }
  }

  String _fechaTexto(DateTime fecha) {
    final dia = fecha.day.toString().padLeft(2, '0');
    final mes = fecha.month.toString().padLeft(2, '0');
    final anio = fecha.year.toString();

    return '$dia/$mes/$anio';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva reseña')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              TextFormField(
                controller: _autorController,
                decoration: InputDecoration(
                  labelText: 'Autor',
                  border: const OutlineInputBorder(),
                  errorText: _errorDuplicado,
                ),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  final texto = value?.trim() ?? '';

                  if (texto.isEmpty) {
                    return 'El autor es obligatorio.';
                  }

                  if (texto.length < 4 || texto.length > 60) {
                    return 'Debe tener entre 4 y 60 caracteres.';
                  }

                  final regex = RegExp(r"^[A-Za-zÁÉÍÓÚÜÑáéíóúüñ ]+$");

                  if (!regex.hasMatch(texto)) {
                    return 'Use solamente letras y espacios.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              FutureBuilder<List<Destino>>(
                future: _futuroDestinos,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const LinearProgressIndicator();
                  }

                  if (snapshot.hasError) {
                    return const Text('No se pudieron cargar los destinos.');
                  }

                  final destinos = snapshot.data ?? <Destino>[];

                  return DropdownButtonFormField<int>(
                    initialValue: _destinoSeleccionado,
                    decoration: const InputDecoration(
                      labelText: 'Destino',
                      border: OutlineInputBorder(),
                    ),
                    items: destinos
                        .where((destino) => destino.id != null)
                        .map(
                          (destino) => DropdownMenuItem<int>(
                            value: destino.id,
                            child: Text(destino.nombre),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _destinoSeleccionado = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Seleccione un destino.';
                      }

                      return null;
                    },
                  );
                },
              ),

              const SizedBox(height: 24),

              Text(
                'Calificación: $_calificacion / 5',
                style: Theme.of(context).textTheme.titleMedium,
              ),

              Slider(
                value: _calificacion.toDouble(),
                min: 1,
                max: 5,
                divisions: 4,
                label: '$_calificacion',
                onChanged: (value) {
                  setState(() {
                    _calificacion = value.round();
                  });
                },
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('1'),
                  Text('2'),
                  Text('3'),
                  Text('4'),
                  Text('5'),
                ],
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _comentarioController,
                maxLines: 5,
                maxLength: 400,
                decoration: const InputDecoration(
                  labelText: 'Comentario',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  final texto = value?.trim() ?? '';

                  if (texto.isEmpty) {
                    return 'El comentario es obligatorio.';
                  }

                  if (texto.length < 20) {
                    return 'Debe tener al menos 20 caracteres.';
                  }

                  if (texto.length > 400) {
                    return 'No debe superar 400 caracteres.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 8),

              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_month_outlined),
                title: const Text('Fecha de la reseña'),
                subtitle: Text(_fechaTexto(_fecha)),
                trailing: const Icon(Icons.chevron_right),
                onTap: _seleccionarFecha,
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
                    : const Icon(Icons.rate_review_outlined),
                label: Text(_guardando ? 'Publicando...' : 'Publicar reseña'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
